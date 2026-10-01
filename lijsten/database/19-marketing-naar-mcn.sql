-- ============================================================
--  "Marketing" wordt: hele organisatie MCN
--
--  Acties met de losse naam "Marketing" krijgen als actiehouder de hele
--  eigen organisatie (de organisatie waarbij "Dit is onze eigen
--  organisatie" is aangevinkt). In de Console staat dan bij Wie de
--  naam van die organisatie, en bij bewerken "Hele organisatie".
--
--  Dit gebeurt alleen als er precies een eigen organisatie is.
--  Draai eerst 17-wie-organisatie.sql. Opnieuw draaien kan geen kwaad.
-- ============================================================

update acties a
set    eigenaar_organisatie_id = o.id,
       eigenaar                = o.naam
from   organisaties o
where  o.eigen
  and  (select count(*) from organisaties where eigen) = 1
  and  a.eigenaar_persoon_id is null
  and  a.eigenaar_organisatie_id is null
  and  lower(btrim(a.eigenaar)) = 'marketing';

-- ── Controle ────────────────────────────────────────────────
-- Bovenaan de acties die nu bij de hele organisatie staan. Staat er
-- onderaan nog een regel met "Marketing", dan is het niet gelukt; kijk dan
-- of er precies een organisatie als eigen is aangevinkt.
select 'hele organisatie' as wie, o.naam as organisatie, a.titel
from   acties a join organisaties o on o.id = a.eigenaar_organisatie_id
where  a.eigenaar_persoon_id is null
union all
select 'nog Marketing', '', a.titel
from   acties a
where  lower(btrim(a.eigenaar)) = 'marketing' and a.eigenaar_organisatie_id is null
order  by 1, 3;
