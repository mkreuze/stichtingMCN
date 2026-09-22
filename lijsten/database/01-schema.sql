-- ============================================================
--  Actie-, besluiten- en relatielijst — database
--  Plak dit in Supabase onder "SQL Editor" en klik op Run.
--  Je mag het meerdere keren draaien: bestaande gegevens
--  blijven staan.
--  De kenmerken (id) zijn tekst, geen uuid: de bestaande lijst
--  gebruikt eigen kenmerken en die moeten bij het overzetten
--  ongewijzigd mee kunnen.
-- ============================================================

-- ── Wie mag erbij ───────────────────────────────────────────
-- Eén regel per persoon die de lijst mag gebruiken.
--   kijker    = mag alles lezen, niets wijzigen
--   bewerker  = mag alles lezen en wijzigen
--   beheerder = mag daarnaast bepalen wie toegang heeft
create table if not exists leden (
  email      text primary key,
  naam       text not null default '',
  rol        text not null default 'kijker'
             check (rol in ('kijker', 'bewerker', 'beheerder')),
  aangemaakt timestamptz not null default now()
);

-- ── Relaties ────────────────────────────────────────────────
create table if not exists organisaties (
  id         text primary key default gen_random_uuid()::text,
  naam       text not null,
  soort      text not null default '',
  plaats     text not null default '',
  website    text not null default '',
  notitie    text not null default '',
  aangemaakt timestamptz not null default now()
);

create table if not exists personen (
  id             text primary key default gen_random_uuid()::text,
  organisatie_id text references organisaties(id) on delete set null,
  naam           text not null,
  functie        text not null default '',
  email          text not null default '',
  telefoon       text not null default '',
  aangemaakt     timestamptz not null default now()
);

-- ── Acties ──────────────────────────────────────────────────
create table if not exists categorieen (
  id     text primary key default gen_random_uuid()::text,
  nr     integer not null default 1,
  titel  text not null,
  labels text[] not null default '{}'
);

create table if not exists acties (
  id             text primary key default gen_random_uuid()::text,
  categorie_id   text not null references categorieen(id) on delete cascade,
  titel          text not null,
  eigenaar       text not null default '',
  wanneer        text not null default '',
  notitie        text not null default '',
  labels         text[] not null default '{}',
  organisatie_id text references organisaties(id) on delete set null,
  persoon_id     text references personen(id) on delete set null,
  gereed         boolean not null default false,
  gereed_op      date,
  gereed_notitie text not null default '',
  volgorde       integer not null default 0,
  aangemaakt     timestamptz not null default now()
);

create index if not exists acties_categorie_idx   on acties (categorie_id);
create index if not exists acties_organisatie_idx on acties (organisatie_id);
create index if not exists acties_persoon_idx     on acties (persoon_id);
create index if not exists personen_org_idx       on personen (organisatie_id);

-- ── Besluiten ───────────────────────────────────────────────
create table if not exists besluiten (
  id              text primary key default gen_random_uuid()::text,
  tekst           text not null,
  datum           date,
  actie_id        text references acties(id) on delete set null,
  categorie_titel text not null default '',
  actie_titel     text not null default '',
  aangemaakt      timestamptz not null default now()
);
