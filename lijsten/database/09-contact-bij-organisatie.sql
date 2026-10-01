-- ============================================================
--  Algemeen e-mailadres en telefoonnummer bij een organisatie
--
--  Veel organisaties hebben een algemeen adres (info@...) dat niet
--  bij één persoon hoort. Daar zijn deze twee velden voor.
--
--  Je mag dit opnieuw draaien: staat een veld er al, dan gebeurt
--  er niets.
-- ============================================================

alter table organisaties add column if not exists email    text not null default '';
alter table organisaties add column if not exists telefoon text not null default '';

select column_name from information_schema.columns
where table_schema = 'public' and table_name = 'organisaties'
order by ordinal_position;
