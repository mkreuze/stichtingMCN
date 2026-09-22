-- ============================================================
--  Actie-, besluiten- en relatielijst — alles in één keer
--
--  Plak dit volledige bestand in de SQL Editor van Supabase en
--  klik op Run. Onderaan verschijnt een telling waarmee je kunt
--  controleren of alles goed is overgekomen.
--
--  Je mag dit opnieuw draaien: bestaande gegevens blijven staan
--  en er ontstaan geen dubbele regels.
--
--  Het aanzetten van "live bijwerken" zit hier NIET in; dat is
--  een aparte stap, omdat die opdracht niet in elke editor werkt.
--  Zonder die stap werkt de lijst gewoon; alleen zien anderen een
--  wijziging pas als ze de pagina verversen.
-- ============================================================


-- ############################################################
-- #  01-schema
-- ############################################################

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


-- ############################################################
-- #  02-toegang
-- ############################################################

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


-- ############################################################
-- #  04-eerste-lid
-- ############################################################

-- ============================================================
--  Jezelf toegang geven
--  Vervang het e-mailadres door dat van jezelf en draai dit.
--  Zonder deze regel ziet niemand iets — ook jij niet.
--
--  Rollen: kijker | bewerker | beheerder
-- ============================================================
insert into leden (email, naam, rol)
values ('mk@mobielecollectie.nl', 'Marinus Kreuze', 'beheerder')
on conflict (email) do update set rol = excluded.rol;

-- Voorbeeld voor de anderen — pas aan en haal de streepjes weg:
-- insert into leden (email, naam, rol) values
--   ('iemand@voorbeeld.nl', 'Naam', 'bewerker'),
--   ('nogiemand@voorbeeld.nl', 'Naam', 'kijker')
-- on conflict (email) do update set rol = excluded.rol;


-- ############################################################
-- #  05-bestaande-lijst
-- ############################################################

-- ============================================================
--  De bestaande lijst overzetten
--  Gemaakt uit de actielijst zoals die op 22 September 2026 in de
--  Claude-artifact stond: 6 categorieën, 41 acties, 1 besluit(en).
--
--  Draai dit ná 01 t/m 04. Je mag het opnieuw draaien: bestaande
--  regels worden bijgewerkt, niet gedupliceerd.
-- ============================================================

-- ── Categorieën ─────────────────────────────────────────────
insert into categorieen (id, nr, titel, labels) values
  ('bestuur', 1, 'Bestuurzaken', array['Bestuur']::text[]),
  ('beleid', 2, 'Beleid', array['Bestuur']::text[]),
  ('overheid', 3, 'Overheid', array['Bestuur']::text[]),
  ('financien', 4, 'Financiën', array['Bestuur']::text[]),
  ('platform', 5, 'MCN Platform site', array['Bestuur', 'Projectgroep']::text[]),
  ('communicatie', 6, 'Communicatie en marketing', array['Bestuur']::text[])
on conflict (id) do update set nr = excluded.nr, titel = excluded.titel, labels = excluded.labels;

-- ── Acties ──────────────────────────────────────────────────
insert into acties (id, categorie_id, titel, eigenaar, wanneer, notitie, labels, gereed, gereed_op, gereed_notitie, volgorde) values
  ('t15', 'bestuur', 'Eén of twee beoogde bestuursleden aanwijzen', 'Sectoren', '2026-08-17', 'Verzoek van 28 juli, tussenbericht 4 augustus — staat nog open', array['Bestuur samenstelling']::text[], false, null, '', 0),
  ('t16', 'bestuur', 'Bestuur aanvullen conform statuten (min. 5 leden, elke sector vertegenwoordigd)', 'Sectoren', '', 'Statutaire termijn loopt', array['Bestuur samenstelling']::text[], false, '2026-09-17', 'Er is nog geen bestuurslid door de sectororgansaties aangedragen', 1),
  ('t13', 'bestuur', 'ANBI-stukken publiceren op de site', 'Marinus', '2026-09-14', 'De Over MCN pagina op de site stichting MCN moet ANBI Proof zijn', '{}', true, '2026-09-17', 'Pagina is aangepast.
- Jaarverslagen
- Statuten
- Wie in het bestuur
- Projectgroep
- Doelstellineg
- Beleidspaln', 2),
  ('t14', 'bestuur', 'Statutaire aanwijzing vervangend bestuurder vastleggen', 'Marinus', '', 'Continuïteit bij ontstentenis/belet', array['Bestuur samenstelling']::text[], false, null, '', 3),
  ('t6', 'bestuur', 'Serviceafspraken Spinque afronden t/m 2027', 'Marinus', '2026-09-17', 'Vertraging door vakantieperiode', array['Leveranciers']::text[], false, null, '', 4),
  ('t8', 'bestuur', 'Contracten Leaseweb en XYNTA beëindigen', 'Marinus', '', 'Na verhuizing hosting/domeinen naar TransIP', array['Leveranciers']::text[], false, null, '', 5),
  ('leveranciers-1789495126241', 'bestuur', 'Getekende SLA opsturen naar Norday', 'Marinus', '2026-09-18', 'Vervolg op: SLA Norday afronden t/m 2027', '{}', true, '2026-09-17', 'Opgestuurd naar Norday/Xander', 6),
  ('t7', 'bestuur', 'SLA Norday afronden t/m 2027', 'Marinus', '2026-09-14', 'Standen nog een aantal vragen open over onderandere eigendomen, deze zijn tot tevredenheid benantwoord in een mail van Norday', array['Leveranciers']::text[], true, '2026-09-14', 'deze zijn tot tevredenheid benantwoord in een mail van Norday en gekoppeld aan de SLA', 7),
  ('t23', 'bestuur', 'Voortgangsbericht nr. 2 versturen', 'Marinus', '2026-09-18', '', array['Rapportage']::text[], false, null, '', 8),
  ('t10', 'bestuur', 'Keuze beheer en financiering platform ná 31-12-2027', 'Sectoren', '', 'Nog niets belegd — wachten maakt de keuze niet makkelijker', '{}', false, null, '', 9),
  ('bestuur-1789647611039', 'bestuur', 'Krijg getekende SLA terug', 'Marinus', '2026-09-17', 'Vervolg op: Getekende SLA opsturen naar Norday', array['Leveranciers']::text[], false, null, '', 10),
  ('t11', 'bestuur', 'Documentatie aanleveren voor formele afsluiting Cultuurfonds', 'Marinus', 'vóór half sept', '', array['Subsidies']::text[], false, null, '', 11),
  ('t12', 'bestuur', 'Afspraak inplannen en dossier afronden met Mondriaanfonds', 'Marinus', 'vóór half sept', 'Vertraagd door vakanties', array['Subsidies']::text[], false, null, '', 12),
  ('bestuur-1789649096587', 'bestuur', 'Nieuwe bestuursleden', 'Sectoren', '', 'Vervolg op: Bestuur aanvullen conform statuten (min. 5 leden, elke sector vertegenwoordigd)', array['Bestuur samenstelling']::text[], false, null, '', 13),
  ('bestuur-1790074773985', 'bestuur', 'Tjeerd de groot benaderen over mogelijke relatie met BBZ', 'Marinus', '', '', array['Bestuur samenstelling']::text[], false, null, '', 14),
  ('beleid-1789656272962', 'beleid', 'Beleidsplan maken 2026 - 2030', 'Marinus', '2026-11-01', 'Vervolg op bestaande beleidsplan', '{}', false, null, '', 0),
  ('t21', 'overheid', 'Overleg RCE met Diede Bos', 'Marinus', '24 aug', 'Samen met Ben Boortman', '{}', false, null, '', 0),
  ('t22', 'overheid', 'Jaarverslag 2025 toesturen aan OCW zodra gereed', 'Marinus', '', '', '{}', false, null, '', 1),
  ('t1', 'financien', 'Jaarrekening 2025 vaststellen en ondertekenen', 'Marinus', '17 aug', 'Na eindcontrole met Frisz Finance', '{}', true, '2026-08-31', 'Gecontroleerd door Frirz en ondertekend door MK. dit geldt voor 2025 en de herziene versies van 2024 en 2025,', 0),
  ('t2', 'financien', 'Jaarcijfers verwerken in jaarverslag, toesturen en publiceren', 'Marinus', 'vóór 28 aug', 'Publicatie op stichtingmcn.nl', '{}', true, '2026-09-06', 'De basis cijfers van jaarrekeningen van 2023, 2024 en 2025 zijn verwerkt in de jaarverslagen en gepubulceerd op de site sichtingMCN.nl', 1),
  ('t3', 'financien', 'Mailinglijst opstellen en jaarverslag versturen aan belanghebbenden', 'Marinus', '', 'RCE, NDE, OCW', '{}', false, null, '', 2),
  ('t4', 'financien', 'Budgetbegroting 2026 en 2027 opstellen', 'Marinus', 'week van 17 aug', '', '{}', true, '2026-09-03', 'Op gesteld en gestuurd aan Bart en Theo', 3),
  ('t5', 'financien', 'PICA-begroting opstellen', 'Marinus', 'week van 17 aug', '', '{}', true, '2026-09-03', 'Op gesteld en gestuurd aan Bart en Theo', 4),
  ('financien-1789493799802', 'financien', 'Opsturen naar Bart en Theo', 'Marinus', '2026-09-15', 'Vervolg op: Jaarrekening 2025 vaststellen en ondertekenen', '{}', false, null, '', 5),
  ('financien-1789494311306', 'financien', 'MCN Portal/ NMRE 2.0 begroting updaten en opsturen', 'Marinus', '', '', '{}', false, null, '', 6),
  ('financien-1789649299080', 'financien', 'krijg factuur van Norday', 'Marinus', '2026-09-17', '', array['Leveranciers']::text[], false, null, '', 7),
  ('t9', 'platform', 'Eindverslag MCN Patform/ MNRE 2.0 opstellen', 'Marinus', '2026-09-24', 'Incl. verantwoOnddrdeel van rapportage naar subsidieverstrekkers', '{}', false, null, '', 0),
  ('pica-project-1789628953687', 'platform', 'Nieuwe bron Gazelle (onderdeel Pon)', 'Ben', '2026-09-24', 'Gazelle objecten zijn beschreven in Altlatis, het abo van Pon.
Vraag: wat zijn de vervolgstappen?', '{}', false, null, '', 1),
  ('pica-project-1789630726311', 'platform', 'Beschrijving opdracht Naar Spinque', 'Boudewijn', '2026-09-24', 'Spinque zal aanpassingen gaan doen aan de huidige opzet.
dit wordt niet een opdracht maar een aantal kleine.
Deze zullen beschreven moeten worden', array['Pica Project']::text[], false, null, '', 2),
  ('pica-project-1789631633928', 'platform', 'FVEN bellen over het aanstuiten van bronnen die niet zijn aangesloten bij de FVEN', 'Marinus', '2026-09-24', 'Denk aan BM, Valken, etc', '{}', false, null, '', 3),
  ('pica-project-1789631794015', 'platform', 'Algemene handleiding schrijven', 'Boudewijn', '2026-10-01', 'Algemene handleiding schrijven van de nieuwe thesaurus ( onderdeel van eind product PICA Project)', array['Pica Project']::text[], false, null, '', 4),
  ('pica-project-1789631839308', 'platform', 'Contactpersoon PICA doorgeven inzake accountantverklaring', 'Boudewijn', '2026-09-24', 'Het is nog niet duidelijk welke eisen aan de "accountansverklaring worden gesteld. In eesrte instantie was dat goed verwerkt in de jaarcijfers, maar wellicht moet dat anders.
Boudewijn brnet Marinus in contact met PICA contactpersoon om dit te bespreken', '{}', false, null, '', 5),
  ('organisatie-mcn-portaal-1789629873674', 'platform', 'Frank van den Boogaard heeft rapport gemaakt beoordelen wat we daarmee gaan doen', 'Marinus', '2026-09-22', '', array['MCN Platform Organisatie']::text[], false, null, '', 6),
  ('organisatie-mcn-portaal-1789630378749', 'platform', 'Frank van den Boogaard vragen om in de redactie te komen', 'Ben', '2026-09-24', '', array['MCN Platform Organisatie']::text[], false, null, '', 7),
  ('doorontwikkeling-mcn-portal-2-0-1789631972583', 'platform', 'Lijst van doorontwikkelingen MCN Portal 2.0 voor 2027', 'Allen', '2026-09-24', 'Inhoud, organsiatie, financieen, en mogelijke financiers.
Voorzet:
- Toeveogen van verhalen
- Nieuwe bronnen
- tussenlaag, werven, fabrieken ed', array['MCN Portaal 2.0']::text[], false, null, '', 8),
  ('redactie-mcn-portaal-1789632062438', 'platform', 'Het toevoegen van verhalen aan MCN Portaal', 'Allen', '2026-09-24', 'Waar komen de content vandaan
Waar wordt het opgeslagen ( techniek, CMS, Spinque)
Hoe verwerken we de verhalen; relevant maken binnen de site zoals de relatie leggen met objecten en canon
Welke selctie criteria hanteren we, Bijvoorbeeld alleen over het functionele gebruik, of over gebeutenissen. Kortom hoe voorkomen we dat dit een "grindbak wordt', '{}', false, null, '', 9),
  ('video-project-1789635914756', 'platform', 'Opstarten Videoproject', 'Allen', '', 'Er is een toekenning van het Mondriaanfonds om video''s toe te voegen aan MCN Portaal', array['Video Project']::text[], false, null, '', 10),
  ('platform-1789647322585', 'platform', 'Eind begroting MCN Patform/ MNRE 2.0 opstellen', 'Marinus', '2026-09-24', 'Onderdeel van rapportage naar Subsieverstrekkers', '{}', false, null, '', 11),
  ('platform-1789991315090', 'platform', 'Presentatie MCN Platform /NMRE 2.0 bij de FVEN Jaarvergadering', 'Marinus', '', 'op 31 okt 2026 is er een Jaar Vergadering van het Algemene bestuur, Verzoek is of we daar over het MCN Platform /NMRE 2.0 een presenatie willen geven.', array['Marketing']::text[], false, null, '', 12),
  ('t19', 'communicatie', 'Nieuwe berichtgeving collectiesite delen met bestuur', 'Marinus', 'deze week', 'Met Ben en Klaas voorbereid', '{}', false, null, '', 0),
  ('t20', 'communicatie', 'Shortlist maken van te benaderen organisaties', 'Marketing', '', '', '{}', false, null, '', 1)
on conflict (id) do update set
  categorie_id = excluded.categorie_id, titel = excluded.titel,
  eigenaar = excluded.eigenaar, wanneer = excluded.wanneer,
  notitie = excluded.notitie, labels = excluded.labels,
  gereed = excluded.gereed, gereed_op = excluded.gereed_op,
  gereed_notitie = excluded.gereed_notitie, volgorde = excluded.volgorde;

-- ── Besluiten ───────────────────────────────────────────────
insert into besluiten (id, tekst, datum, actie_id, categorie_titel, actie_titel) values
  ('besluit-1789647784280', 'Bestuur heeft jaarrekening 2025 en de herziene versies van 2024 en 2023 goedgekeurd', '2026-09-13', 't1', 'Financiën', 'Jaarrekening 2025 vaststellen en ondertekenen')
on conflict (id) do update set
  tekst = excluded.tekst, datum = excluded.datum,
  categorie_titel = excluded.categorie_titel, actie_titel = excluded.actie_titel;

-- ── Controle ────────────────────────────────────────────────
select 'categorieen' as tabel, count(*) from categorieen
union all select 'acties', count(*) from acties
union all select 'acties afgerond', count(*) from acties where gereed
union all select 'acties met label', count(*) from acties where cardinality(labels) > 0
union all select 'besluiten', count(*) from besluiten;
