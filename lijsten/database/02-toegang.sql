-- ============================================================
--  Toegangsregels
--  Draai dit ná 01-schema.sql. Ook dit mag meerdere keren.
--
--  De regel is simpel: je ziet niets tenzij je e-mailadres in
--  de tabel "leden" staat. Wijzigen mag alleen met de rol
--  bewerker of beheerder.
--
--  Let op de schrijfwijze: alles staat hier als losse, korte
--  opdrachten zonder meerregelige blokken. Sommige SQL-editors
--  knippen een script bij elke puntkomma en struikelen anders
--  over de functies.
-- ============================================================

-- ── Hulpfuncties ────────────────────────────────────────────
-- Deze lezen het e-mailadres van wie er ingelogd is. Ze draaien
-- met verhoogde rechten (security definer), zodat ze de
-- ledenlijst mogen lezen zonder in een kringetje te belanden.

create or replace function public.mijn_rol() returns text language sql stable security definer set search_path = public as 'select rol from leden where lower(email) = lower(auth.email())';

create or replace function public.is_lid() returns boolean language sql stable security definer set search_path = public as 'select public.mijn_rol() is not null';

create or replace function public.mag_bewerken() returns boolean language sql stable security definer set search_path = public as 'select public.mijn_rol() in (''bewerker'', ''beheerder'')';

create or replace function public.is_beheerder() returns boolean language sql stable security definer set search_path = public as 'select public.mijn_rol() = ''beheerder''';

-- ── Regels aanzetten ────────────────────────────────────────
alter table leden        enable row level security;
alter table organisaties enable row level security;
alter table personen     enable row level security;
alter table categorieen  enable row level security;
alter table acties       enable row level security;
alter table besluiten    enable row level security;

-- ── Lezen: alleen leden. Wijzigen: alleen bewerkers ─────────

drop policy if exists lezen on organisaties;
drop policy if exists toevoegen on organisaties;
drop policy if exists wijzigen on organisaties;
drop policy if exists verwijderen on organisaties;
create policy lezen on organisaties for select to authenticated using (public.is_lid());
create policy toevoegen on organisaties for insert to authenticated with check (public.mag_bewerken());
create policy wijzigen on organisaties for update to authenticated using (public.mag_bewerken()) with check (public.mag_bewerken());
create policy verwijderen on organisaties for delete to authenticated using (public.mag_bewerken());

drop policy if exists lezen on personen;
drop policy if exists toevoegen on personen;
drop policy if exists wijzigen on personen;
drop policy if exists verwijderen on personen;
create policy lezen on personen for select to authenticated using (public.is_lid());
create policy toevoegen on personen for insert to authenticated with check (public.mag_bewerken());
create policy wijzigen on personen for update to authenticated using (public.mag_bewerken()) with check (public.mag_bewerken());
create policy verwijderen on personen for delete to authenticated using (public.mag_bewerken());

drop policy if exists lezen on categorieen;
drop policy if exists toevoegen on categorieen;
drop policy if exists wijzigen on categorieen;
drop policy if exists verwijderen on categorieen;
create policy lezen on categorieen for select to authenticated using (public.is_lid());
create policy toevoegen on categorieen for insert to authenticated with check (public.mag_bewerken());
create policy wijzigen on categorieen for update to authenticated using (public.mag_bewerken()) with check (public.mag_bewerken());
create policy verwijderen on categorieen for delete to authenticated using (public.mag_bewerken());

drop policy if exists lezen on acties;
drop policy if exists toevoegen on acties;
drop policy if exists wijzigen on acties;
drop policy if exists verwijderen on acties;
create policy lezen on acties for select to authenticated using (public.is_lid());
create policy toevoegen on acties for insert to authenticated with check (public.mag_bewerken());
create policy wijzigen on acties for update to authenticated using (public.mag_bewerken()) with check (public.mag_bewerken());
create policy verwijderen on acties for delete to authenticated using (public.mag_bewerken());

drop policy if exists lezen on besluiten;
drop policy if exists toevoegen on besluiten;
drop policy if exists wijzigen on besluiten;
drop policy if exists verwijderen on besluiten;
create policy lezen on besluiten for select to authenticated using (public.is_lid());
create policy toevoegen on besluiten for insert to authenticated with check (public.mag_bewerken());
create policy wijzigen on besluiten for update to authenticated using (public.mag_bewerken()) with check (public.mag_bewerken());
create policy verwijderen on besluiten for delete to authenticated using (public.mag_bewerken());


-- ── De ledenlijst zelf: ieder lid mag hem zien, maar alleen
--    een beheerder mag hem wijzigen ─────────────────────────
drop policy if exists lezen on leden;
drop policy if exists toevoegen on leden;
drop policy if exists wijzigen on leden;
drop policy if exists verwijderen on leden;
create policy lezen on leden for select to authenticated using (public.is_lid());
create policy toevoegen on leden for insert to authenticated with check (public.is_beheerder());
create policy wijzigen on leden for update to authenticated using (public.is_beheerder()) with check (public.is_beheerder());
create policy verwijderen on leden for delete to authenticated using (public.is_beheerder());
