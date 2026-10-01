-- ============================================================
--  Aansluiting van organisaties
--
--  Twee kenmerken bij een organisatie:
--    aangesloten  aangesloten bij MCN, zoals de sectorfederaties
--    bron         aangesloten als bron: levert gegevens aan
--  Een organisatie kan allebei zijn, één van de twee, of geen.
--
--  De vier sectorfederaties worden de eerste keer als aangesloten
--  aangevinkt: FEHAC, FVEN, Historisch Railvervoer Nederland en de
--  Nationale Federatie Historische Luchtvaart. Daarna blijft dit
--  bestand eraf, ook als je het opnieuw draait. Aan- en uitvinken
--  doe je in de Console bij de organisatie.
--
--  Je mag dit opnieuw draaien.
-- ============================================================

alter table organisaties add column if not exists aangesloten boolean not null default false;
alter table organisaties add column if not exists bron boolean not null default false;

update organisaties set aangesloten = true where lower(naam) in ('fehac', 'fven', 'historisch railvervoer nederland', 'nationale federatie historische luchtvaart') and not exists (select 1 from organisaties o where o.aangesloten);

-- ── Controle ────────────────────────────────────────────────
select 'aangesloten bij MCN' as wat, count(*) from organisaties where aangesloten
union all select 'aangesloten als bron', count(*) from organisaties where bron;

select naam from organisaties where aangesloten order by naam;
