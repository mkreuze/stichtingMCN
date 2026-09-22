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
