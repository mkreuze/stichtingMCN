-- ============================================================
--  Sector bij een organisatie
--
--  Naast "soort" (wat voor organisatie is het) komt er "sector"
--  (in welk deel van het mobiel erfgoed is ze actief). Net als bij
--  soort is de keuzelijst in de Console zelf te beheren.
--
--  Je mag dit opnieuw draaien.
-- ============================================================

alter table organisaties add column if not exists sector text not null default '';

create table if not exists organisatie_sectoren (
  naam      text primary key,
  volgorde  integer not null default 100
);

alter table organisatie_sectoren enable row level security;

drop policy if exists lezen       on organisatie_sectoren;
drop policy if exists toevoegen   on organisatie_sectoren;
drop policy if exists wijzigen    on organisatie_sectoren;
drop policy if exists verwijderen on organisatie_sectoren;
create policy lezen       on organisatie_sectoren for select to authenticated using (public.is_lid());
create policy toevoegen   on organisatie_sectoren for insert to authenticated with check (public.mag_bewerken());
create policy wijzigen    on organisatie_sectoren for update to authenticated using (public.mag_bewerken()) with check (public.mag_bewerken());
create policy verwijderen on organisatie_sectoren for delete to authenticated using (public.mag_bewerken());

-- ── De lijst om mee te beginnen ─────────────────────────────
-- Pas dit gerust aan in de Console; dit is alleen een startpunt.
insert into organisatie_sectoren (naam, volgorde) values
  ('Wegvervoer', 10),
  ('Railvervoer', 20),
  ('Varend erfgoed', 30),
  ('Luchtvaart', 40),
  ('Militair erfgoed', 50),
  ('Overkoepelend', 60),
  ('Niet sectorgebonden', 70)
on conflict (naam) do nothing;

insert into organisatie_sectoren (naam, volgorde)
select distinct sector, 200 from organisaties
where sector <> '' and sector not in (select naam from organisatie_sectoren)
on conflict (naam) do nothing;

select naam, volgorde from organisatie_sectoren order by volgorde, naam;
