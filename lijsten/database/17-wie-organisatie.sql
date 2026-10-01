-- ============================================================
--  Wie doet een actie: organisatie en persoon
--
--  Bij "Wie" kies je voortaan eerst de organisatie (standaard jullie
--  eigen organisatie) en daarna een contactpersoon daarvan. Je kunt ook
--  de hele organisatie kiezen, zonder persoon. Daarvoor krijgt een actie
--  een veld voor de organisatie van de actiehouder.
--
--  Het aparte veld "Relatie" verdwijnt uit het formulier. Wat daar al
--  stond, blijft in de database bewaard; er wordt niets gewist.
--
--  Daarnaast wordt de koppeling van 16-acties-koppelen.sql nog eens
--  gelegd, nu ook op volledige naam. Stond er bij een actie nog een losse
--  naam als "Marinus", dan wijst die daarna naar de persoon.
--
--  Onderaan staat een controle. Je mag dit opnieuw draaien.
-- ============================================================

alter table acties add column if not exists eigenaar_organisatie_id text references organisaties(id) on delete set null;

create index if not exists acties_eigenaar_organisatie_idx on acties (eigenaar_organisatie_id);

-- Losse namen koppelen aan de personen van de eigen organisatie:
-- op voornaam ("Marinus") of op volledige naam ("Marinus Kreuze").
update acties a
set    eigenaar_persoon_id = p.id
from   personen p
join   organisaties o on o.id = p.organisatie_id
where  o.eigen
  and  a.eigenaar_persoon_id is null
  and  a.eigenaar <> ''
  and  (lower(btrim(a.eigenaar)) = lower(btrim(p.voornaam))
        or lower(btrim(a.eigenaar)) = lower(btrim(p.naam)));

-- Bij een gekoppelde persoon hoort diens organisatie.
update acties a
set    eigenaar_organisatie_id = p.organisatie_id
from   personen p
where  p.id = a.eigenaar_persoon_id
  and  a.eigenaar_organisatie_id is distinct from p.organisatie_id;

-- ── Controle ────────────────────────────────────────────────
-- Per regel: wat er staat. Bij "eigen organisatie" hoort precies een
-- naam te staan; bij "nog losse naam" alleen namen die geen persoon zijn,
-- zoals Sectoren of Allen.
select 'eigen organisatie' as wat, naam as waarde, null::bigint as aantal
from   organisaties where eigen
union all
select 'persoon bij eigen organisatie', p.naam || '  (voornaam: ' || coalesce(nullif(p.voornaam, ''), 'LEEG') || ')', null
from   personen p join organisaties o on o.id = p.organisatie_id where o.eigen
union all
select 'gekoppeld aan persoon', pe.naam, count(*)
from   acties a join personen pe on pe.id = a.eigenaar_persoon_id
group  by pe.naam
union all
select 'nog losse naam', a.eigenaar, count(*)
from   acties a
where  a.eigenaar_persoon_id is null and a.eigenaar_organisatie_id is null and a.eigenaar <> ''
group  by a.eigenaar
union all
select 'oude relatie (bewaard, niet meer zichtbaar)', coalesce(o.naam, pr.naam, '?'), count(*)
from   acties a
left   join organisaties o on o.id = a.organisatie_id
left   join personen pr on pr.id = a.persoon_id
where  a.organisatie_id is not null or a.persoon_id is not null
group  by 2
order  by 1, 2;
