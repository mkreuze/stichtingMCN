-- ============================================================
--  FIM samenvoegen met Federatie Instandhouding Monumenten
--
--  "FIM" en "Federatie Instandhouding Monumenten" zijn dezelfde
--  organisatie (beide fimnederland.nl). Wat bij FIM hoort gaat over
--  naar de Federatie Instandhouding Monumenten: de personen, de
--  acties (ook als FIM bij Wie stond) en lege velden. Daarna wordt
--  FIM verwijderd.
--
--  Je mag dit opnieuw draaien: bestaat FIM niet meer, dan gebeurt er
--  niets.
-- ============================================================

-- Personen verhuizen
update personen set organisatie_id = (select id from organisaties where lower(naam) = 'federatie instandhouding monumenten' order by aangemaakt limit 1) where organisatie_id in (select id from organisaties where lower(naam) = 'fim') and exists (select 1 from organisaties where lower(naam) = 'federatie instandhouding monumenten');

-- Acties die aan FIM gekoppeld waren
update acties set organisatie_id = (select id from organisaties where lower(naam) = 'federatie instandhouding monumenten' order by aangemaakt limit 1) where organisatie_id in (select id from organisaties where lower(naam) = 'fim') and exists (select 1 from organisaties where lower(naam) = 'federatie instandhouding monumenten');
update acties set eigenaar_organisatie_id = (select id from organisaties where lower(naam) = 'federatie instandhouding monumenten' order by aangemaakt limit 1) where eigenaar_organisatie_id in (select id from organisaties where lower(naam) = 'fim') and exists (select 1 from organisaties where lower(naam) = 'federatie instandhouding monumenten');

-- Lege velden aanvullen met wat bij FIM stond, en de afkorting noteren
update organisaties d set soort = case when d.soort = '' then f.soort else d.soort end, sector = case when d.sector = '' then f.sector else d.sector end, adres = case when d.adres = '' then f.adres else d.adres end, postcode = case when d.postcode = '' then f.postcode else d.postcode end, plaats = case when d.plaats = '' then f.plaats else d.plaats end, website = case when d.website = '' then f.website else d.website end, email = case when d.email = '' then f.email else d.email end, telefoon = case when d.telefoon = '' then f.telefoon else d.telefoon end, notitie = case when position('Afkorting: FIM' in d.notitie) > 0 then d.notitie when f.notitie = '' and d.notitie = '' then 'Afkorting: FIM' when f.notitie = '' then d.notitie || chr(10) || 'Afkorting: FIM' when d.notitie = '' then f.notitie || chr(10) || 'Afkorting: FIM' else d.notitie || chr(10) || f.notitie || chr(10) || 'Afkorting: FIM' end from organisaties f where lower(d.naam) = 'federatie instandhouding monumenten' and lower(f.naam) = 'fim';

-- FIM zelf verwijderen (alleen als de federatie er is, en er niets meer aan hangt)
delete from organisaties where lower(naam) = 'fim' and exists (select 1 from organisaties where lower(naam) = 'federatie instandhouding monumenten') and not exists (select 1 from personen p where p.organisatie_id = organisaties.id) and not exists (select 1 from acties a where a.organisatie_id = organisaties.id or a.eigenaar_organisatie_id = organisaties.id);

-- ── Controle: FIM 0, de federatie 1, met haar personen ──────
select 'FIM' as wat, count(*) from organisaties where lower(naam) = 'fim'
union all select 'Federatie Instandhouding Monumenten', count(*) from organisaties where lower(naam) = 'federatie instandhouding monumenten'
union all select 'personen bij de federatie', count(*) from personen where organisatie_id in (select id from organisaties where lower(naam) = 'federatie instandhouding monumenten');
