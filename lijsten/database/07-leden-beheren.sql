-- ============================================================
--  Wie mag erbij — de ledenlijst beheren
--
--  Dit is de enige lijst die telt. Wie hierin staat kan een
--  account aanmaken en inloggen; wie er niet in staat, niet.
--
--  Rollen:
--    kijker    = mag alles lezen, niets wijzigen
--    bewerker  = mag alles lezen en wijzigen
--    beheerder = mag daarnaast bepalen wie toegang heeft
--
--  Pas hieronder de adressen aan en draai dit bestand.
-- ============================================================

-- ── Iemand toevoegen of zijn rol wijzigen ───────────────────
-- Staat het adres er al in, dan wordt alleen de rol bijgewerkt.

insert into leden (email, naam, rol) values
  ('iemand@voorbeeld.nl',    'Voornaam Achternaam', 'bewerker'),
  ('nogiemand@voorbeeld.nl', 'Voornaam Achternaam', 'kijker')
on conflict (email) do update set naam = excluded.naam, rol = excluded.rol;

-- ── Iemand de toegang ontnemen ──────────────────────────────
-- Haal de streepjes weg en vul het adres in.
-- Let op: een bestaand account blijft bestaan, maar ziet niets meer.
-- Wil je het account zelf ook weg, doe dat dan in het Supabase-scherm
-- onder Authentication -> Users.

-- delete from leden where lower(email) = lower('iemand@voorbeeld.nl');

-- ── Kijken wie er nu op staat ───────────────────────────────
select naam, email, rol from leden order by rol, naam;
