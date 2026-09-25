-- ============================================================
--  Beheer alleen voor de beheerder
--
--  1. Soorten en sectoren van organisaties: toevoegen, hernoemen en
--     verwijderen mag alleen nog de beheerder. Iedereen met toegang
--     kan ze blijven lezen, en een bewerker kan bij een organisatie
--     gewoon een soort en sector kiezen.
--
--  2. De ledenlijst (wie mag inloggen, met welke rol): dat was al
--     alleen voor de beheerder. Nieuw is een beveiliging: de laatste
--     beheerder kan niet worden verwijderd en niet worden teruggezet
--     naar bewerker of kijker. Zo kun je jezelf niet buitensluiten.
--
--  Labels bij acties horen bij de acties zelf; die kan een bewerker
--  bij een actie blijven invullen. Het hernoemen en samenvoegen van
--  labels staat in de Console alleen onder het beheer.
--
--  Je mag dit opnieuw draaien.
-- ============================================================

-- Hulpfuncties. Ze lezen de ledenlijst buiten de toegangsregels om,
-- anders zou een regel op "leden" zichzelf aanroepen.
create or replace function public.aantal_beheerders() returns bigint language sql stable security definer set search_path = public as 'select count(*) from leden where rol = ''beheerder''';

create or replace function public.was_beheerder(adres text) returns boolean language sql stable security definer set search_path = public as 'select exists (select 1 from leden where lower(email) = lower(adres) and rol = ''beheerder'')';

-- ── 1. Soorten ──────────────────────────────────────────────
drop policy if exists toevoegen   on organisatie_soorten;
drop policy if exists wijzigen    on organisatie_soorten;
drop policy if exists verwijderen on organisatie_soorten;
create policy toevoegen   on organisatie_soorten for insert to authenticated with check (public.is_beheerder());
create policy wijzigen    on organisatie_soorten for update to authenticated using (public.is_beheerder()) with check (public.is_beheerder());
create policy verwijderen on organisatie_soorten for delete to authenticated using (public.is_beheerder());

-- ── 1. Sectoren ─────────────────────────────────────────────
drop policy if exists toevoegen   on organisatie_sectoren;
drop policy if exists wijzigen    on organisatie_sectoren;
drop policy if exists verwijderen on organisatie_sectoren;
create policy toevoegen   on organisatie_sectoren for insert to authenticated with check (public.is_beheerder());
create policy wijzigen    on organisatie_sectoren for update to authenticated using (public.is_beheerder()) with check (public.is_beheerder());
create policy verwijderen on organisatie_sectoren for delete to authenticated using (public.is_beheerder());

-- ── 2. Ledenlijst: de laatste beheerder blijft ──────────────
drop policy if exists wijzigen    on leden;
drop policy if exists verwijderen on leden;
create policy wijzigen on leden for update to authenticated
  using (public.is_beheerder())
  with check (public.is_beheerder() and (rol = 'beheerder' or not public.was_beheerder(email) or public.aantal_beheerders() > 1));
create policy verwijderen on leden for delete to authenticated
  using (public.is_beheerder() and (rol <> 'beheerder' or public.aantal_beheerders() > 1));

-- ── Controle ────────────────────────────────────────────────
-- Bij soorten en sectoren hoort bij toevoegen, wijzigen en verwijderen
-- "is_beheerder" te staan; bij leden de extra voorwaarde.
select tablename as tabel, policyname as regel, cmd as soort,
       coalesce(qual, '') || case when with_check is not null then '  |  ' || with_check else '' end as voorwaarde
from   pg_policies
where  tablename in ('organisatie_soorten', 'organisatie_sectoren', 'leden')
order  by 1, 3;
