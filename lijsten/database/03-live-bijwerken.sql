-- ============================================================
--  Live bijwerken aanzetten
--  Hierdoor zien alle geopende vensters een wijziging meteen,
--  net als in de huidige lijst. Draai dit ná 01 en 02.
--  (Deze opdracht werkt alleen in Supabase.)
-- ============================================================
do $$
declare t text;
begin
  foreach t in array array['organisaties','personen','categorieen','acties','besluiten']
  loop
    begin
      execute format('alter publication supabase_realtime add table %I', t);
    exception
      when others then null;   -- stond er al bij, of dit is geen Supabase
    end;
  end loop;
end $$;
