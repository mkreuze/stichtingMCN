-- ============================================================
--  Live bijwerken aanzetten
--
--  Hierdoor ziet iedereen met de pagina open een wijziging meteen,
--  zonder te verversen. Zonder deze stap werkt de lijst gewoon;
--  anderen zien jouw wijziging dan pas na een verversing.
--
--  MAKKELIJKER KAN OOK, met knoppen in plaats van SQL:
--    Database -> Publications -> supabase_realtime
--    -> zet de vijf tabellen hieronder aan.
--
--  Gebruik je dit bestand: draai het één keer. Draai je het nog
--  eens, dan komt er een foutmelding "is already member of
--  publication". Die is onschuldig - het stond er al - maar de
--  regels erna worden dan niet meer uitgevoerd. Draai ze in dat
--  geval één voor één.
-- ============================================================

alter publication supabase_realtime add table organisaties;
alter publication supabase_realtime add table personen;
alter publication supabase_realtime add table categorieen;
alter publication supabase_realtime add table acties;
alter publication supabase_realtime add table besluiten;

-- Controle: hier horen de vijf tabellen te staan.
select tablename from pg_publication_tables where pubname = 'supabase_realtime' order by tablename;
