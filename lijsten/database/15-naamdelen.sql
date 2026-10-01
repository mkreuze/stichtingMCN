-- ============================================================
--  Naam in delen, en geslacht erbij
--
--  Een persoon had één naamveld. Dat wordt nu voornaam,
--  tussenvoegsel en achternaam, plus geslacht. Het veld "naam"
--  blijft bestaan als de volledige naam; de Console vult dat
--  voortaan zelf uit de drie delen.
--
--  Bestaande namen worden automatisch gesplitst. Nederlandse
--  tussenvoegsels (van, van der, de, ten, ...) worden herkend, en
--  een titel vooraan (Dr., Drs., Ir.) blijft bij de voornaam staan.
--  Loopt er eentje verkeerd, dan pas je hem in de Console aan.
--
--  Geslacht blijft leeg: dat valt niet uit een naam af te leiden
--  en wordt dus niet geraden.
--
--  Je mag dit opnieuw draaien; al gevulde delen blijven staan.
-- ============================================================

alter table personen add column if not exists voornaam      text not null default '';
alter table personen add column if not exists tussenvoegsel text not null default '';
alter table personen add column if not exists achternaam    text not null default '';
alter table personen add column if not exists geslacht      text not null default ''
  check (geslacht in ('', 'vrouw', 'man', 'anders'));

-- ── De bestaande namen splitsen ─────────────────────────────
-- Alleen bij personen waar de delen nog leeg zijn.
with zonder_titel as (
  select id, naam,
         coalesce((regexp_match(naam, '^([A-Za-z]{1,5}\.)\s+(.+)$'))[1], '') as titel,
         coalesce((regexp_match(naam, '^[A-Za-z]{1,5}\.\s+(.+)$'))[1], naam) as rest
  from personen
  where voornaam = '' and achternaam = ''
), ontleed as (
  select id, naam, titel, rest,
         regexp_match(rest,
           '^(\S+)\s+((?:(?:van|von|de|den|der|des|het|ten|ter|te|op|aan|in|uit|bij|''t|d'')\s+)+)(.+)$', 'i') as m
  from zonder_titel
)
update personen p set
  voornaam      = btrim(o.titel || ' ' || coalesce(o.m[1], split_part(o.rest, ' ', 1))),
  tussenvoegsel = coalesce(btrim(o.m[2]), ''),
  achternaam    = coalesce(o.m[3], nullif(btrim(substr(o.rest, length(split_part(o.rest, ' ', 1)) + 1)), ''), '')
from ontleed o
where p.id = o.id;

-- ── Controle ────────────────────────────────────────────────
select voornaam, tussenvoegsel, achternaam, geslacht, naam as volledige_naam
from personen
order by achternaam, voornaam;
