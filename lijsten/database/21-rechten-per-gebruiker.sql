-- ============================================================
--  Rechten per gebruiker
--
--  Per gebruiker in de ledenlijst:
--    toegang_acties     ja/nee  - de actielijst
--    acties_groepen     welke groepen van categorieen (bijvoorbeeld
--                       Bestuur, Projectgroep). Leeg = alle groepen.
--    toegang_besluiten  ja/nee
--    toegang_relaties   ja/nee  - organisaties en personen
--
--  De rol blijft bepalen of iemand mag wijzigen (kijker, bewerker,
--  beheerder). Deze rechten bepalen wat iemand ziet. Een beheerder
--  ziet altijd alles. Bestaande gebruikers houden overal toegang.
--
--  Wie geen toegang tot de relaties heeft maar wel tot de acties, ziet
--  alleen de namen van organisaties en personen (nodig om bij een
--  actie te kiezen wie het doet), geen adres, e-mail of telefoon.
--
--  Een categorie zonder groep is alleen zichtbaar voor wie alle
--  groepen mag zien.
--
--  Categorieen aanmaken, hernoemen en verwijderen mag voortaan alleen
--  de beheerder (in de Console onder het tandwieltje).
--
--  Je mag dit opnieuw draaien.
-- ============================================================

alter table leden add column if not exists toegang_acties    boolean not null default true;
alter table leden add column if not exists acties_groepen    text[]  not null default '{}';
alter table leden add column if not exists toegang_besluiten boolean not null default true;
alter table leden add column if not exists toegang_relaties  boolean not null default true;

-- ── Hulpfuncties ────────────────────────────────────────────
create or replace function public.mag_acties() returns boolean language sql stable security definer set search_path = public as 'select public.is_beheerder() or coalesce((select toegang_acties from leden where lower(email) = lower(auth.email())), false)';

create or replace function public.mag_besluiten() returns boolean language sql stable security definer set search_path = public as 'select public.is_beheerder() or coalesce((select toegang_besluiten from leden where lower(email) = lower(auth.email())), false)';

create or replace function public.mag_relaties() returns boolean language sql stable security definer set search_path = public as 'select public.is_beheerder() or coalesce((select toegang_relaties from leden where lower(email) = lower(auth.email())), false)';

create or replace function public.mijn_groepen() returns text[] language sql stable security definer set search_path = public as 'select case when public.is_beheerder() then ''{}''::text[] else coalesce((select acties_groepen from leden where lower(email) = lower(auth.email())), ''{}''::text[]) end';

create or replace function public.categorie_zichtbaar(groepen text[]) returns boolean language sql stable security definer set search_path = public as 'select public.mag_acties() and (cardinality(public.mijn_groepen()) = 0 or coalesce(groepen, ''{}''::text[]) && public.mijn_groepen())';

create or replace function public.actie_zichtbaar(cat text) returns boolean language sql stable security definer set search_path = public as 'select exists (select 1 from categorieen c where c.id = cat and public.categorie_zichtbaar(c.labels))';

-- Alleen de namen, voor wie de acties wel maar de relaties niet ziet.
create or replace function public.namen_organisaties() returns table (id text, naam text, eigen boolean) language sql stable security definer set search_path = public as 'select o.id, o.naam, o.eigen from organisaties o where public.mag_acties() order by o.naam';

create or replace function public.namen_personen() returns table (id text, organisatie_id text, naam text, voornaam text, tussenvoegsel text, achternaam text) language sql stable security definer set search_path = public as 'select p.id, p.organisatie_id, p.naam, p.voornaam, p.tussenvoegsel, p.achternaam from personen p where public.mag_acties()';

grant execute on function public.namen_organisaties() to authenticated;
grant execute on function public.namen_personen() to authenticated;

-- ── Categorieen: zien wat bij je groepen hoort, beheren alleen door de beheerder
drop policy if exists lezen       on categorieen;
drop policy if exists toevoegen   on categorieen;
drop policy if exists wijzigen    on categorieen;
drop policy if exists verwijderen on categorieen;
create policy lezen       on categorieen for select to authenticated using (public.is_lid() and public.categorie_zichtbaar(labels));
create policy toevoegen   on categorieen for insert to authenticated with check (public.is_beheerder());
create policy wijzigen    on categorieen for update to authenticated using (public.is_beheerder()) with check (public.is_beheerder());
create policy verwijderen on categorieen for delete to authenticated using (public.is_beheerder());

-- ── Acties: alleen in een zichtbare categorie ───────────────
drop policy if exists lezen       on acties;
drop policy if exists toevoegen   on acties;
drop policy if exists wijzigen    on acties;
drop policy if exists verwijderen on acties;
create policy lezen       on acties for select to authenticated using (public.is_lid() and public.actie_zichtbaar(categorie_id));
create policy toevoegen   on acties for insert to authenticated with check (public.mag_bewerken() and public.actie_zichtbaar(categorie_id));
create policy wijzigen    on acties for update to authenticated using (public.mag_bewerken() and public.actie_zichtbaar(categorie_id)) with check (public.mag_bewerken() and public.actie_zichtbaar(categorie_id));
create policy verwijderen on acties for delete to authenticated using (public.mag_bewerken() and public.actie_zichtbaar(categorie_id));

-- ── Besluiten ───────────────────────────────────────────────
drop policy if exists lezen       on besluiten;
drop policy if exists toevoegen   on besluiten;
drop policy if exists wijzigen    on besluiten;
drop policy if exists verwijderen on besluiten;
create policy lezen       on besluiten for select to authenticated using (public.is_lid() and public.mag_besluiten());
create policy toevoegen   on besluiten for insert to authenticated with check (public.mag_bewerken() and public.mag_besluiten());
create policy wijzigen    on besluiten for update to authenticated using (public.mag_bewerken() and public.mag_besluiten()) with check (public.mag_bewerken() and public.mag_besluiten());
create policy verwijderen on besluiten for delete to authenticated using (public.mag_bewerken() and public.mag_besluiten());

-- ── Relaties ────────────────────────────────────────────────
drop policy if exists lezen       on organisaties;
drop policy if exists toevoegen   on organisaties;
drop policy if exists wijzigen    on organisaties;
drop policy if exists verwijderen on organisaties;
create policy lezen       on organisaties for select to authenticated using (public.is_lid() and public.mag_relaties());
create policy toevoegen   on organisaties for insert to authenticated with check (public.mag_bewerken() and public.mag_relaties());
create policy wijzigen    on organisaties for update to authenticated using (public.mag_bewerken() and public.mag_relaties()) with check (public.mag_bewerken() and public.mag_relaties());
create policy verwijderen on organisaties for delete to authenticated using (public.mag_bewerken() and public.mag_relaties());

drop policy if exists lezen       on personen;
drop policy if exists toevoegen   on personen;
drop policy if exists wijzigen    on personen;
drop policy if exists verwijderen on personen;
create policy lezen       on personen for select to authenticated using (public.is_lid() and public.mag_relaties());
create policy toevoegen   on personen for insert to authenticated with check (public.mag_bewerken() and public.mag_relaties());
create policy wijzigen    on personen for update to authenticated using (public.mag_bewerken() and public.mag_relaties()) with check (public.mag_bewerken() and public.mag_relaties());
create policy verwijderen on personen for delete to authenticated using (public.mag_bewerken() and public.mag_relaties());

-- ── Controle ────────────────────────────────────────────────
-- Iedereen staat nog op "overal toegang"; dat pas je in de Console aan
-- onder het tandwieltje, bij Gebruikers.
select email, rol, toegang_acties as acties,
       case when cardinality(acties_groepen) = 0 then 'alle groepen' else array_to_string(acties_groepen, ', ') end as groepen,
       toegang_besluiten as besluiten, toegang_relaties as relaties
from   leden
order  by email;
