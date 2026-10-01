-- ============================================================
--  Adresgegevens bij een organisatie
--
--  Voegt twee velden toe aan de tabel organisaties: adres en
--  postcode. Het veld plaats bestond al. Bestaande organisaties
--  krijgen lege velden; je vult ze in wanneer je wilt.
--
--  Je mag dit opnieuw draaien: staat een veld er al, dan gebeurt
--  er niets.
-- ============================================================

alter table organisaties add column if not exists adres    text not null default '';
alter table organisaties add column if not exists postcode text not null default '';

-- Controle: hier horen adres, postcode en plaats bij te staan.
select column_name, data_type
from information_schema.columns
where table_schema = 'public' and table_name = 'organisaties'
order by ordinal_position;
