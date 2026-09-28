-- ============================================================
--  Logboek: wie heeft wat gewijzigd, en wanneer iemand er was
--
--  1. Een tabel "logboek". De database schrijft daar zelf een regel
--     in bij elke toevoeging, wijziging en verwijdering in de
--     Console-tabellen, met wie het deed. Niemand kan dat overslaan
--     of achteraf aanpassen; alleen de beheerder kan het lezen.
--     Bij een wijziging staat per veld de oude en nieuwe waarde
--     erbij; bij een verwijdering de hele regel, zodat die zo nodig
--     terug te zetten is.
--  2. Bij "leden" een kolom "laatst_gezien". De Console zet die bij
--     elk bezoek, en schrijft hooguit één keer per uur per persoon
--     "opende de Console" in het logboek.
--  3. Een functie "laatste_logins" waarmee de beheerder ziet wanneer
--     iemand voor het laatst heeft ingelogd.
--
--  Je mag dit opnieuw draaien.
-- ============================================================

create table if not exists logboek (
  id           bigserial primary key,
  wanneer      timestamptz not null default now(),
  wie          text not null default '',
  tabel        text not null,
  actie        text not null,
  rij_id       text not null default '',
  omschrijving text not null default '',
  velden       text[] not null default '{}',
  wijziging    jsonb
);
create index if not exists logboek_wanneer_idx on logboek (wanneer desc);
create index if not exists logboek_wie_idx on logboek (wie);

alter table logboek enable row level security;
drop policy if exists lezen on logboek;
create policy lezen on logboek for select to authenticated using (public.is_beheerder());
-- Lezen mag (alleen de beheerder, zie hierboven); schrijven, wijzigen
-- en verwijderen mag niemand: dat doet alleen de database zelf, via
-- de functies hieronder.
grant select on logboek to authenticated;
revoke insert, update, delete, truncate on logboek from anon, authenticated;

alter table leden add column if not exists laatst_gezien timestamptz;

-- ── De functie die elke wijziging opschrijft ────────────────
-- Twee gegevens per tabel: het veld met de sleutel en het veld met
-- een leesbare naam. Velden die alleen iets bijhouden (laatst_gezien,
-- bijgewerkt) tellen niet als wijziging.
-- (Alles op één regel, zoals in de andere bestanden.)
create or replace function public.logboek_schrijf() returns trigger language plpgsql security definer set search_path = public as 'declare n jsonb; o jsonb; v text[]; w jsonb; r jsonb; begin if tg_op <> ''INSERT'' then o := to_jsonb(old); end if; if tg_op <> ''DELETE'' then n := to_jsonb(new); end if; if tg_op = ''UPDATE'' then select array_agg(k order by k), jsonb_object_agg(k, jsonb_build_array(o->k, n->k)) into v, w from jsonb_object_keys(n) k where (n->k) is distinct from (o->k) and k not in (''laatst_gezien'', ''bijgewerkt''); if v is null then return null; end if; end if; r := coalesce(n, o); insert into public.logboek (wie, tabel, actie, rij_id, omschrijving, velden, wijziging) values (coalesce(nullif(auth.email(), ''''), ''database (SQL Editor)''), tg_table_name, case tg_op when ''INSERT'' then ''toegevoegd'' when ''UPDATE'' then ''gewijzigd'' else ''verwijderd'' end, coalesce(r->>tg_argv[0], ''''), coalesce(nullif(r->>tg_argv[1], ''''), r->>tg_argv[0], ''''), coalesce(v, ''{}''), case when tg_op = ''DELETE'' then o else w end); return null; end';
revoke execute on function public.logboek_schrijf() from public, anon, authenticated;

-- ── Op elke tabel aanzetten ─────────────────────────────────
drop trigger if exists logboek on acties;
create trigger logboek after insert or update or delete on acties for each row execute function public.logboek_schrijf('id', 'titel');
drop trigger if exists logboek on besluiten;
create trigger logboek after insert or update or delete on besluiten for each row execute function public.logboek_schrijf('id', 'tekst');
drop trigger if exists logboek on categorieen;
create trigger logboek after insert or update or delete on categorieen for each row execute function public.logboek_schrijf('id', 'titel');
drop trigger if exists logboek on organisaties;
create trigger logboek after insert or update or delete on organisaties for each row execute function public.logboek_schrijf('id', 'naam');
drop trigger if exists logboek on personen;
create trigger logboek after insert or update or delete on personen for each row execute function public.logboek_schrijf('id', 'naam');
drop trigger if exists logboek on organisatie_soorten;
create trigger logboek after insert or update or delete on organisatie_soorten for each row execute function public.logboek_schrijf('naam', 'naam');
drop trigger if exists logboek on organisatie_sectoren;
create trigger logboek after insert or update or delete on organisatie_sectoren for each row execute function public.logboek_schrijf('naam', 'naam');
drop trigger if exists logboek on leden;
create trigger logboek after insert or update or delete on leden for each row execute function public.logboek_schrijf('email', 'naam');
drop trigger if exists logboek on instellingen;
create trigger logboek after insert or update or delete on instellingen for each row execute function public.logboek_schrijf('sleutel', 'sleutel');

-- ── Bezoek melden (de Console roept dit aan bij het openen) ─
create or replace function public.meld_bezoek() returns void language sql volatile security definer set search_path = public as 'update leden set laatst_gezien = now() where lower(email) = lower(auth.email()); insert into logboek (wie, tabel, actie, omschrijving) select auth.email(), ''console'', ''bezoek'', ''opende de Console'' where public.is_lid() and not exists (select 1 from logboek where lower(wie) = lower(auth.email()) and actie = ''bezoek'' and wanneer > now() - interval ''1 hour'')';
revoke execute on function public.meld_bezoek() from public, anon;
grant execute on function public.meld_bezoek() to authenticated;

-- ── Laatst ingelogd (alleen voor de beheerder) ──────────────
create or replace function public.laatste_logins() returns table (email text, laatst timestamptz) language sql stable security definer set search_path = public as 'select u.email::text, u.last_sign_in_at from auth.users u where public.is_beheerder()';
revoke execute on function public.laatste_logins() from public, anon;
grant execute on function public.laatste_logins() to authenticated;

-- ── Controle: 9 tabellen met logboek, en de drie functies ───
select 'tabellen met logboek' as wat, count(*)::text as uitkomst from pg_trigger where tgname = 'logboek' and not tgisinternal
union all select 'functies', count(*)::text from pg_proc where proname in ('logboek_schrijf', 'meld_bezoek', 'laatste_logins')
union all select 'regels in het logboek', count(*)::text from logboek;
