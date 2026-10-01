-- ============================================================
--  Instellingen voor iedereen: de huisstijl
--
--  Een kleine tabel voor instellingen die voor alle gebruikers gelden.
--  Nu alleen de kleuren van de lichte en de donkere versie, die de
--  beheerder onder het tandwieltje bij Huisstijl kiest.
--
--  Lezen mag ieder lid; wijzigen alleen de beheerder.
--  Je mag dit opnieuw draaien.
-- ============================================================

create table if not exists instellingen (
  sleutel    text primary key,
  waarde     jsonb not null default '{}'::jsonb,
  bijgewerkt timestamptz not null default now()
);

alter table instellingen enable row level security;

drop policy if exists lezen       on instellingen;
drop policy if exists toevoegen   on instellingen;
drop policy if exists wijzigen    on instellingen;
drop policy if exists verwijderen on instellingen;
create policy lezen       on instellingen for select to authenticated using (public.is_lid());
create policy toevoegen   on instellingen for insert to authenticated with check (public.is_beheerder());
create policy wijzigen    on instellingen for update to authenticated using (public.is_beheerder()) with check (public.is_beheerder());
create policy verwijderen on instellingen for delete to authenticated using (public.is_beheerder());

grant select, insert, update, delete on instellingen to authenticated;

-- ── Controle ────────────────────────────────────────────────
-- Leeg zolang er nog niets is ingesteld: dan gelden de standaardkleuren.
select sleutel, waarde, bijgewerkt from instellingen;
