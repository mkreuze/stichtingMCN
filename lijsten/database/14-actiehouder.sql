-- ============================================================
--  De actiehouder koppelen aan de relatielijst
--
--  Tot nu toe was "wie" losse tekst. Daardoor staan jullie eigen
--  mensen twee keer in het systeem: als actiehouder én straks als
--  persoon in de relatielijst.
--
--  Vanaf nu kan een actie verwijzen naar een persoon uit de
--  relatielijst. Losse tekst blijft mogelijk voor namen die geen
--  persoon zijn, zoals "Sectoren" of "Allen".
--
--  Je mag dit opnieuw draaien.
-- ============================================================

-- Welke organisatie is die van onszelf? De personen daarvan staan
-- bovenaan in de keuzelijst bij een actie.
alter table organisaties add column if not exists eigen boolean not null default false;

-- De actiehouder als verwijzing. Blijft leeg bij een losse naam.
alter table acties add column if not exists eigenaar_persoon_id text references personen(id) on delete set null;

create index if not exists acties_eigenaar_persoon_idx on acties (eigenaar_persoon_id);

select
  (select count(*) from information_schema.columns
     where table_name = 'organisaties' and column_name = 'eigen')                  as veld_eigen,
  (select count(*) from information_schema.columns
     where table_name = 'acties' and column_name = 'eigenaar_persoon_id')          as veld_actiehouder,
  (select count(*) from organisaties where eigen)                                  as eigen_organisaties;
