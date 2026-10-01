-- ============================================================
--  Drie dubbele organisaties samenvoegen
--
--    FEHAC      <- Federatie Historische Automobiel- en Motorfietsclubs
--    FVEN       <- Federatie Varend Erfgoed Nederland
--    Railhobby  <- Rail Hobby
--
--  De korte naam blijft staan: daar hangen de meeste personen aan en
--  die heeft al soort, sector en website. Van de andere gaan de
--  personen en acties (ook bij Wie) over, lege velden worden
--  aangevuld en de lange naam komt in de toelichting, zodat zoeken
--  erop blijft werken. Had de dubbele een ander e-mailadres, dan komt
--  dat er ook bij. Daarna wordt de dubbele verwijderd.
--
--  Je mag dit opnieuw draaien: is de dubbele al weg, dan gebeurt er
--  niets.
-- ============================================================

-- ── FEHAC <- Federatie Historische Automobiel- en Motorfietsclubs ──
update personen set organisatie_id = (select id from organisaties where lower(naam) = lower('FEHAC') order by aangemaakt limit 1) where organisatie_id in (select id from organisaties where lower(naam) = lower('Federatie Historische Automobiel- en Motorfietsclubs')) and exists (select 1 from organisaties where lower(naam) = lower('FEHAC'));
update acties set organisatie_id = (select id from organisaties where lower(naam) = lower('FEHAC') order by aangemaakt limit 1) where organisatie_id in (select id from organisaties where lower(naam) = lower('Federatie Historische Automobiel- en Motorfietsclubs')) and exists (select 1 from organisaties where lower(naam) = lower('FEHAC'));
update acties set eigenaar_organisatie_id = (select id from organisaties where lower(naam) = lower('FEHAC') order by aangemaakt limit 1) where eigenaar_organisatie_id in (select id from organisaties where lower(naam) = lower('Federatie Historische Automobiel- en Motorfietsclubs')) and exists (select 1 from organisaties where lower(naam) = lower('FEHAC'));
update organisaties d set soort = case when d.soort = '' then f.soort else d.soort end, sector = case when d.sector = '' then f.sector else d.sector end, adres = case when d.adres = '' then f.adres else d.adres end, postcode = case when d.postcode = '' then f.postcode else d.postcode end, plaats = case when d.plaats = '' then f.plaats else d.plaats end, website = case when d.website = '' then f.website else d.website end, email = case when d.email = '' then f.email else d.email end, telefoon = case when d.telefoon = '' then f.telefoon else d.telefoon end, notitie = case when position('Voluit: Federatie Historische Automobiel- en Motorfietsclubs' in d.notitie) > 0 then d.notitie else concat_ws(chr(10), nullif(d.notitie, ''), nullif(f.notitie, ''), case when f.email <> '' and d.email <> '' and lower(f.email) <> lower(d.email) then 'Ook: ' || f.email end, 'Voluit: Federatie Historische Automobiel- en Motorfietsclubs') end from organisaties f where lower(d.naam) = lower('FEHAC') and lower(f.naam) = lower('Federatie Historische Automobiel- en Motorfietsclubs') and d.id <> f.id;
delete from organisaties where lower(naam) = lower('Federatie Historische Automobiel- en Motorfietsclubs') and exists (select 1 from organisaties where lower(naam) = lower('FEHAC')) and not exists (select 1 from personen p where p.organisatie_id = organisaties.id) and not exists (select 1 from acties a where a.organisatie_id = organisaties.id or a.eigenaar_organisatie_id = organisaties.id);

-- ── FVEN <- Federatie Varend Erfgoed Nederland ──
update personen set organisatie_id = (select id from organisaties where lower(naam) = lower('FVEN') order by aangemaakt limit 1) where organisatie_id in (select id from organisaties where lower(naam) = lower('Federatie Varend Erfgoed Nederland')) and exists (select 1 from organisaties where lower(naam) = lower('FVEN'));
update acties set organisatie_id = (select id from organisaties where lower(naam) = lower('FVEN') order by aangemaakt limit 1) where organisatie_id in (select id from organisaties where lower(naam) = lower('Federatie Varend Erfgoed Nederland')) and exists (select 1 from organisaties where lower(naam) = lower('FVEN'));
update acties set eigenaar_organisatie_id = (select id from organisaties where lower(naam) = lower('FVEN') order by aangemaakt limit 1) where eigenaar_organisatie_id in (select id from organisaties where lower(naam) = lower('Federatie Varend Erfgoed Nederland')) and exists (select 1 from organisaties where lower(naam) = lower('FVEN'));
update organisaties d set soort = case when d.soort = '' then f.soort else d.soort end, sector = case when d.sector = '' then f.sector else d.sector end, adres = case when d.adres = '' then f.adres else d.adres end, postcode = case when d.postcode = '' then f.postcode else d.postcode end, plaats = case when d.plaats = '' then f.plaats else d.plaats end, website = case when d.website = '' then f.website else d.website end, email = case when d.email = '' then f.email else d.email end, telefoon = case when d.telefoon = '' then f.telefoon else d.telefoon end, notitie = case when position('Voluit: Federatie Varend Erfgoed Nederland' in d.notitie) > 0 then d.notitie else concat_ws(chr(10), nullif(d.notitie, ''), nullif(f.notitie, ''), case when f.email <> '' and d.email <> '' and lower(f.email) <> lower(d.email) then 'Ook: ' || f.email end, 'Voluit: Federatie Varend Erfgoed Nederland') end from organisaties f where lower(d.naam) = lower('FVEN') and lower(f.naam) = lower('Federatie Varend Erfgoed Nederland') and d.id <> f.id;
delete from organisaties where lower(naam) = lower('Federatie Varend Erfgoed Nederland') and exists (select 1 from organisaties where lower(naam) = lower('FVEN')) and not exists (select 1 from personen p where p.organisatie_id = organisaties.id) and not exists (select 1 from acties a where a.organisatie_id = organisaties.id or a.eigenaar_organisatie_id = organisaties.id);

-- ── Railhobby <- Rail Hobby ──
update personen set organisatie_id = (select id from organisaties where lower(naam) = lower('Railhobby') order by aangemaakt limit 1) where organisatie_id in (select id from organisaties where lower(naam) = lower('Rail Hobby')) and exists (select 1 from organisaties where lower(naam) = lower('Railhobby'));
update acties set organisatie_id = (select id from organisaties where lower(naam) = lower('Railhobby') order by aangemaakt limit 1) where organisatie_id in (select id from organisaties where lower(naam) = lower('Rail Hobby')) and exists (select 1 from organisaties where lower(naam) = lower('Railhobby'));
update acties set eigenaar_organisatie_id = (select id from organisaties where lower(naam) = lower('Railhobby') order by aangemaakt limit 1) where eigenaar_organisatie_id in (select id from organisaties where lower(naam) = lower('Rail Hobby')) and exists (select 1 from organisaties where lower(naam) = lower('Railhobby'));
update organisaties d set soort = case when d.soort = '' then f.soort else d.soort end, sector = case when d.sector = '' then f.sector else d.sector end, adres = case when d.adres = '' then f.adres else d.adres end, postcode = case when d.postcode = '' then f.postcode else d.postcode end, plaats = case when d.plaats = '' then f.plaats else d.plaats end, website = case when d.website = '' then f.website else d.website end, email = case when d.email = '' then f.email else d.email end, telefoon = case when d.telefoon = '' then f.telefoon else d.telefoon end, notitie = case when position('Ook geschreven als: Rail Hobby' in d.notitie) > 0 then d.notitie else concat_ws(chr(10), nullif(d.notitie, ''), nullif(f.notitie, ''), case when f.email <> '' and d.email <> '' and lower(f.email) <> lower(d.email) then 'Ook: ' || f.email end, 'Ook geschreven als: Rail Hobby') end from organisaties f where lower(d.naam) = lower('Railhobby') and lower(f.naam) = lower('Rail Hobby') and d.id <> f.id;
delete from organisaties where lower(naam) = lower('Rail Hobby') and exists (select 1 from organisaties where lower(naam) = lower('Railhobby')) and not exists (select 1 from personen p where p.organisatie_id = organisaties.id) and not exists (select 1 from acties a where a.organisatie_id = organisaties.id or a.eigenaar_organisatie_id = organisaties.id);

-- ── Controle: de lange namen 0, de korte 1 ─────────────────
select 'Federatie Historische Automobiel- en Motorfietsclubs' as wat, count(*) from organisaties where lower(naam) = lower('Federatie Historische Automobiel- en Motorfietsclubs')
union all select 'FEHAC', count(*) from organisaties where lower(naam) = lower('FEHAC')
union all select '  personen bij FEHAC', count(*) from personen where organisatie_id in (select id from organisaties where lower(naam) = lower('FEHAC'))
union all select 'Federatie Varend Erfgoed Nederland' as wat, count(*) from organisaties where lower(naam) = lower('Federatie Varend Erfgoed Nederland')
union all select 'FVEN', count(*) from organisaties where lower(naam) = lower('FVEN')
union all select '  personen bij FVEN', count(*) from personen where organisatie_id in (select id from organisaties where lower(naam) = lower('FVEN'))
union all select 'Rail Hobby' as wat, count(*) from organisaties where lower(naam) = lower('Rail Hobby')
union all select 'Railhobby', count(*) from organisaties where lower(naam) = lower('Railhobby')
union all select '  personen bij Railhobby', count(*) from personen where organisatie_id in (select id from organisaties where lower(naam) = lower('Railhobby'));
