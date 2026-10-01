-- ============================================================
--  De bestaande acties koppelen aan jullie eigen mensen
--
--  In de actielijst staat de actiehouder nu nog als losse tekst:
--  "Marinus", "Ben", "Boudewijn". Zodra die mensen als persoon bij
--  jullie eigen organisatie staan, kan de actie naar die persoon
--  verwijzen. Daarna klopt het overal: bij de persoon zie je zijn
--  openstaande acties, en een adreswijziging hoef je maar op één
--  plek te doen.
--
--  VOORAF: de organisatie moet aangevinkt staan als "Dit is onze
--  eigen organisatie", en de personen moeten daar staan met hun
--  voornaam ingevuld.
--
--  Gekoppeld wordt op voornaam. Namen die geen persoon zijn --
--  "Sectoren", "Allen", "Marketing" -- blijven gewoon als tekst
--  staan; dat is de bedoeling.
--
--  Je mag dit opnieuw draaien. Al gekoppelde acties blijven staan,
--  ook als je een koppeling zelf hebt aangepast.
-- ============================================================

update acties a
set    eigenaar_persoon_id = p.id
from   personen p
join   organisaties o on o.id = p.organisatie_id
where  o.eigen
  and  a.eigenaar_persoon_id is null
  and  lower(btrim(a.eigenaar)) = lower(btrim(p.voornaam));

-- ── Controle ────────────────────────────────────────────────
-- Links: wat nu gekoppeld is. Rechts: wat als losse tekst blijft
-- staan. Staat daar een naam van een collega tussen, dan is die
-- persoon nog niet aangemaakt of staat de voornaam anders gespeld.
select coalesce(pe.naam, '— nog losse tekst —') as actiehouder,
       a.eigenaar                               as tekst_in_de_lijst,
       count(*)                                 as aantal_acties
from   acties a
left   join personen pe on pe.id = a.eigenaar_persoon_id
group  by 1, 2
order  by 1, 2;
