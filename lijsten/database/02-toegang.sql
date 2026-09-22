-- ============================================================
--  Toegangsregels
--  Draai dit ná 01-schema.sql. Ook dit mag meerdere keren.
--
--  De regel is simpel: je ziet niets tenzij je e-mailadres in
--  de tabel "leden" staat. Wijzigen mag alleen met de rol
--  bewerker of beheerder.
-- ============================================================

-- ── Hulpfuncties ────────────────────────────────────────────
-- Deze lezen het e-mailadres van wie er ingelogd is.
create or replace function public.mijn_rol()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select rol from leden where lower(email) = lower(auth.email());
$$;

create or replace function public.is_lid()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.mijn_rol() is not null;
$$;

create or replace function public.mag_bewerken()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.mijn_rol() in ('bewerker', 'beheerder');
$$;

create or replace function public.is_beheerder()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.mijn_rol() = 'beheerder';
$$;

-- ── Regels aanzetten ────────────────────────────────────────
alter table leden        enable row level security;
alter table organisaties enable row level security;
alter table personen     enable row level security;
alter table categorieen  enable row level security;
alter table acties       enable row level security;
alter table besluiten    enable row level security;

-- ── Lezen: alleen leden. Wijzigen: alleen bewerkers ─────────
do $$
declare t text;
begin
  foreach t in array array['organisaties','personen','categorieen','acties','besluiten']
  loop
    execute format('drop policy if exists lezen on %I', t);
    execute format('drop policy if exists toevoegen on %I', t);
    execute format('drop policy if exists wijzigen on %I', t);
    execute format('drop policy if exists verwijderen on %I', t);

    execute format('create policy lezen on %I for select to authenticated using (public.is_lid())', t);
    execute format('create policy toevoegen on %I for insert to authenticated with check (public.mag_bewerken())', t);
    execute format('create policy wijzigen on %I for update to authenticated using (public.mag_bewerken()) with check (public.mag_bewerken())', t);
    execute format('create policy verwijderen on %I for delete to authenticated using (public.mag_bewerken())', t);
  end loop;
end $$;

-- ── De ledenlijst zelf: iedereen die lid is mag hem zien,
--    maar alleen een beheerder mag hem wijzigen ─────────────
drop policy if exists lezen       on leden;
drop policy if exists toevoegen   on leden;
drop policy if exists wijzigen    on leden;
drop policy if exists verwijderen on leden;

create policy lezen       on leden for select to authenticated using (public.is_lid());
create policy toevoegen   on leden for insert to authenticated with check (public.is_beheerder());
create policy wijzigen    on leden for update to authenticated using (public.is_beheerder()) with check (public.is_beheerder());
create policy verwijderen on leden for delete to authenticated using (public.is_beheerder());
