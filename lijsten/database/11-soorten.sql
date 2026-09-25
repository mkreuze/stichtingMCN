-- ============================================================
--  Soorten organisaties
--
--  De keuzelijst bij "soort" stond in de pagina zelf; nu staat hij
--  in de database, zodat je hem in de Console kunt beheren zonder
--  dat er iets aan de code hoeft te veranderen.
--
--  Je mag dit opnieuw draaien: bestaande soorten blijven staan.
-- ============================================================

create table if not exists organisatie_soorten (
  naam      text primary key,
  volgorde  integer not null default 100
);

alter table organisatie_soorten enable row level security;

drop policy if exists lezen       on organisatie_soorten;
drop policy if exists toevoegen   on organisatie_soorten;
drop policy if exists wijzigen    on organisatie_soorten;
drop policy if exists verwijderen on organisatie_soorten;
create policy lezen       on organisatie_soorten for select to authenticated using (public.is_lid());
create policy toevoegen   on organisatie_soorten for insert to authenticated with check (public.mag_bewerken());
create policy wijzigen    on organisatie_soorten for update to authenticated using (public.mag_bewerken()) with check (public.mag_bewerken());
create policy verwijderen on organisatie_soorten for delete to authenticated using (public.mag_bewerken());

-- ── De lijst om mee te beginnen ─────────────────────────────
insert into organisatie_soorten (naam, volgorde) values
  ('Museum', 10),
  ('Vereniging', 20),
  ('Stichting', 30),
  ('Overheid', 40),
  ('Fonds', 50),
  ('Leverancier', 60),
  ('Netwerk of koepel', 70),
  ('Onderwijs of onderzoek', 80),
  ('Pers of media', 90),
  ('Bedrijf', 100),
  ('Overig', 110)
on conflict (naam) do nothing;

-- ── Soorten die al bij een organisatie stonden, erbij zetten ─
insert into organisatie_soorten (naam, volgorde)
select distinct soort, 200 from organisaties
where soort <> '' and soort not in (select naam from organisatie_soorten)
on conflict (naam) do nothing;

select naam, volgorde from organisatie_soorten order by volgorde, naam;
