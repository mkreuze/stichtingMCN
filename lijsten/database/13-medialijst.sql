-- ============================================================
--  Medialijst overnemen en samenvoegen
--
--  Gemaakt uit "MCN Medialijst" (133 regels, door Klaas Smit) op 23 September 2026:
--  132 organisaties, waarvan 13 al in de relatielijst stonden.
--
--  Draai dit ná 11 (soorten) en 12 (sectoren).
--
--  Samenvoegen gaat op naam. Stond een organisatie er al, dan worden
--  lege velden aangevuld en blijft staan wat er al was. Je mag dit
--  opnieuw draaien zonder dubbelen te krijgen.
--
--  De soort van Klaas is vertaald naar de keuzelijst van de Console
--  (twaalf soorten media werden "Pers of media"). Het origineel staat
--  in de toelichting, zodat je het niet kwijt bent.
-- ============================================================

-- ── Sectoren uit het bestand toevoegen ──────────────────────
insert into organisatie_sectoren (naam, volgorde) values
  ('Algemeen', 200),
  ('Club/vereniging', 210),
  ('Erfgoed', 220),
  ('Erfgoedhuis', 230),
  ('Luchtvaart', 240),
  ('Railvervoer', 250),
  ('Regionale media', 260),
  ('Vakblad erfgoed', 270),
  ('Vakblad mobiliteit', 280),
  ('Varend erfgoed', 290),
  ('Wegvervoer', 300)
on conflict (naam) do nothing;

-- ── Soorten uit het bestand toevoegen ───────────────────────
insert into organisatie_soorten (naam, volgorde) values
  ('Erfgoedhuis', 200),
  ('Museum', 210),
  ('Netwerk of koepel', 220),
  ('Overig', 230),
  ('Pers of media', 240),
  ('Stichting', 250),
  ('Vereniging', 260)
on conflict (naam) do nothing;

-- ── De organisaties ─────────────────────────────────────────
insert into organisaties (id, naam, sector, soort, website, email, notitie) values
  ('org-autoweek', 'AutoWeek', 'Wegvervoer', 'Pers of media', 'https://www.autoweek.nl', 'redactie@autoweek.nl', 'Medialijst: Magazine/online'),
  ('org-auto-motor-klassiek', 'Auto Motor Klassiek', 'Wegvervoer', 'Pers of media', 'https://www.amklassiek.nl', 'redactie@amklassiek.nl', 'Medialijst: Magazine/online'),
  ('org-octane-nederland', 'Octane Nederland', 'Wegvervoer', 'Pers of media', 'https://www.octanemagazine.nl', 'info@octanemagazine.nl', 'Medialijst: Magazine'),
  ('org-klassiekerweb', 'Klassiekerweb', 'Wegvervoer', 'Pers of media', 'https://www.klassiekerweb.nl', 'info@klassiekerweb.nl', 'Medialijst: Online'),
  ('org-nsmbl', 'NSMBL', 'Wegvervoer', 'Pers of media', 'https://www.nsmbl.nl', 'redactie@nsmbl.nl', 'Medialijst: Online'),
  ('org-topgear-nederland', 'TopGear Nederland', 'Wegvervoer', 'Pers of media', 'https://topgear.nl', 'redactie@topgear.nl', 'Medialijst: Magazine/online'),
  ('org-autovisie', 'Autovisie', 'Wegvervoer', 'Pers of media', 'https://www.autovisie.nl', 'redactie@autovisie.nl', 'Medialijst: Magazine/online'),
  ('org-de-auto', 'De Auto', 'Wegvervoer', 'Pers of media', 'https://www.knac.nl', 'ledenservice@knac.nl', 'Medialijst: Clubblad'),
  ('org-fehac', 'FEHAC', 'Wegvervoer', 'Vereniging', 'https://www.fehac.nl', 'secretariaat@fehac.nl', 'Medialijst: Belangenorganisatie'),
  ('org-louwman-museum', 'Louwman Museum', 'Wegvervoer', 'Museum', 'https://www.louwmanmuseum.nl', 'info@louwmanmuseum.nl', ''),
  ('org-daf-museum', 'DAF Museum', 'Wegvervoer', 'Museum', 'https://www.dafmuseum.nl', 'info@daf-museum.nl', ''),
  ('org-nederlands-transport-museum', 'Nederlands Transport Museum', 'Wegvervoer', 'Museum', 'https://www.nederlandstransportmuseum.nl', 'info@sntm.nl', ''),
  ('org-knac', 'KNAC', 'Wegvervoer', 'Vereniging', 'https://www.knac.nl', 'ledenservice@knac.nl', ''),
  ('org-a-ford-club-nederland', 'A-Ford Club Nederland', 'Wegvervoer', 'Vereniging', 'https://www.a-ford.nl/', 'info@a-ford.nl', ''),
  ('org-alfa-romeo-spider-register', 'Alfa Romeo Spider Register', 'Wegvervoer', 'Vereniging', 'https://www.alfaspider.com/', 'pr@alfaspider.com', ''),
  ('org-austin-healey-owners-club-nederland', 'Austin Healey Owners Club Nederland', 'Wegvervoer', 'Vereniging', 'https://www.healey.nl/', 'voorzitter@healey.nl', ''),
  ('org-bmw-02-club-nederland', 'BMW 02 Club Nederland', 'Wegvervoer', 'Vereniging', 'bmw02club.nl', 'secretaris@bmw02club.nl', ''),
  ('org-citroen-id-ds-club-nederland', 'Citroën ID/DS Club Nederland', 'Wegvervoer', 'Vereniging', 'citroeniddsclub.nl', 'secretaris@citroeniddsclub.nl', ''),
  ('org-daf-club-nederland', 'DAF Club Nederland', 'Wegvervoer', 'Vereniging', 'dafclub.nl', 'pr@dafclub.nl', ''),
  ('org-fiat-500-club-nederland', 'Fiat 500 Club Nederland', 'Wegvervoer', 'Vereniging', 'fiat500club.nl', 'info@fiat500club.nl', ''),
  ('org-jaguar-daimler-club-holland', 'Jaguar Daimler Club Holland', 'Wegvervoer', 'Vereniging', 'jdch.nl', 'voorzitter@jdch.nl', ''),
  ('org-mercedes-benz-automobiel-clubs-nederland', 'Mercedes-Benz Automobiel Clubs Nederland', 'Wegvervoer', 'Vereniging', 'mbac.nl', 'info@mbac.nl', ''),
  ('org-volvo-klassieker-vereniging', 'Volvo Klassieker Vereniging', 'Wegvervoer', 'Vereniging', 'volvokv.nl', 'onderdelen@volvokv.nl', ''),
  ('org-historische-automobiel-club-cuylenborgh', 'Historische Automobiel Club Cuylenborgh', 'Wegvervoer', 'Vereniging', 'https://www.hacc.nl/hacc/', 'info@hacc.nl', ''),
  ('org-internationale-historische-automobiel-club-nederland', 'Internationale Historische Automobiel Club Nederland', 'Wegvervoer', 'Vereniging', 'ihac.nl', 'info@ihac.nl', ''),
  ('org-oldtimer-club-leusden', 'Oldtimer Club Leusden', 'Wegvervoer', 'Vereniging', 'https://www.oldtimerclubleusden.nl/', 'oldtimerclubleusden@gmail.com', ''),
  ('org-opel-museum-tijnje', 'Opel Museum Tijnje', 'Wegvervoer', 'Museum', 'https://www.opelmuseum.nl', 'meindertvanwijk@hetnet.nl', ''),
  ('org-rambler-amc-museum', 'Rambler AMC Museum', 'Wegvervoer', 'Museum', 'https://www.rambler-amc-museum.nl', 'info@rambler-amc-museum.nl', ''),
  ('org-ford-museum-beekbergen', 'Ford Museum Beekbergen', 'Wegvervoer', 'Museum', 'http://ford-museum.nl', 'info@ford-museum.nl', ''),
  ('org-achterhoeks-oldtimer-museum', 'Achterhoeks Oldtimer Museum', 'Wegvervoer', 'Museum', 'https://www.veerbeek-oldtimers.nl', 'g.j.veerbeek@hetnet.nl', ''),
  ('org-automuseum-schagen', 'Automuseum Schagen', 'Wegvervoer', 'Museum', 'https://automuseumschagen.nl/', 'info@automuseumschagen.nl', ''),
  ('org-classic-park-boxtel', 'Classic Park Boxtel', 'Wegvervoer', 'Museum', 'https://www.classicpark.nl', 'info@classicpark.nl', ''),
  ('org-volvo-museum-loosdrecht', 'Volvo Museum Loosdrecht', 'Wegvervoer', 'Museum', 'https://nld237.nl/', 'info@haselhoffbv.nl', ''),
  ('org-saab-museum-aalten', 'Saab Museum Aalten', 'Wegvervoer', 'Museum', 'http://www.saabmuseumkempink.nl/', 'akempink@kpnmail.nl', ''),
  ('org-trekkermuseum-nisse', 'Trekkermuseum Nisse', 'Wegvervoer', 'Museum', 'https://trekkermuseum-otmmz.nl/', 'info@trekkermuseum-otmmz.nl', ''),
  ('org-schuttevaer', 'Schuttevaer', 'Varend erfgoed', 'Pers of media', 'https://www.schuttevaer.nl', 'redactie@schuttevaer.nl', 'Medialijst: Vakmedium'),
  ('org-zeilen', 'Zeilen', 'Varend erfgoed', 'Pers of media', 'https://www.zeilen.nl', 'info@zeilen.nl', 'Medialijst: Vakmedium'),
  ('org-nautique', 'Nautique', 'Varend erfgoed', 'Pers of media', 'https://www.nautique.nl', 'redactie@nautique.nl', 'Medialijst: Vakmedium'),
  ('org-nieuwsblad-transport', 'Nieuwsblad Transport', 'Varend erfgoed', 'Pers of media', 'https://www.nt.nl', 'redactie@nt.nl', 'Medialijst: Vakmedium'),
  ('org-spiegel-der-zeilvaart', 'Spiegel der Zeilvaart', 'Varend erfgoed', 'Pers of media', 'https://www.spiegelderzeilvaart.nl', 'redactie@spiegelderzeilvaart.nl', 'Medialijst: Vakmedium'),
  ('org-watersport-tv', 'Watersport-TV', 'Varend erfgoed', 'Pers of media', 'watersport-tv.nl', 'info@watersport-tv.nl', 'Medialijst: Vakmedium'),
  ('org-het-scheepvaartmuseum', 'Het Scheepvaartmuseum', 'Varend erfgoed', 'Museum', 'https://www.hetscheepvaartmuseum.nl', 'pr@hetscheepvaartmuseum.nl', ''),
  ('org-maritiem-museum-rotterdam', 'Maritiem Museum Rotterdam', 'Varend erfgoed', 'Museum', 'https://www.maritiemmuseum.nl', 'info@maritiemmuseum.nl', ''),
  ('org-batavialand', 'Batavialand', 'Varend erfgoed', 'Museum', 'https://www.batavialand.nl', 'robert.waagmeester@batavialand.nl', ''),
  ('org-museumwerf-vreeswijk', 'Museumwerf Vreeswijk', 'Varend erfgoed', 'Museum', 'https://www.museumwerf.nl', 'info@museumwerf.nl', ''),
  ('org-fries-scheepvaartmuseum', 'Fries Scheepvaartmuseum', 'Varend erfgoed', 'Museum', 'https://friesscheepvaartmuseum.nl/', 'info@friesscheepvaartmuseum.nl', ''),
  ('org-zuiderzee-museum', 'Zuiderzee Museum', 'Varend erfgoed', 'Museum', 'https://www.zuiderzeemuseum.nl/', 'info@zuiderzeemuseum.nl', ''),
  ('org-fven', 'FVEN', 'Varend erfgoed', 'Netwerk of koepel', 'https://www.fven.nl', 'bureau@fven.nl', 'Medialijst: Koepelorganisatie'),
  ('org-ssrp', 'SSRP', 'Club/vereniging', 'Overig', 'ssrp.nl', 'm.kreuze@ssrp.nl', 'Medialijst: Behoudsorganisatie'),
  ('org-lvbhb', 'LVBHB', 'Club/vereniging', 'Overig', 'https://www.lvbhb.nl/', 'secretaris@lvbhb.nl', 'Medialijst: Behoudsorganisatie'),
  ('org-bbz', 'BBZ', 'Club/vereniging', 'Overig', 'https://www.debbz.nl/', 'ofni@debbz.nl', 'Medialijst: Behoudsorganisatie'),
  ('org-museumschip-mercuur', 'Museumschip Mercuur', 'Club/vereniging', 'Stichting', 'https://www.museumschip-mercuur.nl/', 'info@museumschip-mercuur.nl', ''),
  ('org-historische-scheepswerf-meerman', 'Historische Scheepswerf Meerman', 'Club/vereniging', 'Stichting', 'werfarnedmuiden.nl', 'info@werfarnemuiden.nl', ''),
  ('org-museumhaven-zeeland', 'Museumhaven Zeeland', 'Club/vereniging', 'Stichting', 'musemhavenzeeland.nl', 'info@museumhavenzeeland.nl', ''),
  ('org-stichting-behoud-hoogaars', 'Stichting Behoud Hoogaars', 'Club/vereniging', 'Stichting', 'hoogaars.nl', 'info@hoogaars.nl', ''),
  ('org-luchtvaartnieuws', 'Luchtvaartnieuws', 'Luchtvaart', 'Pers of media', 'https://www.luchtvaartnieuws.nl', 'redactie@luchtvaartnieuws.nl', 'Medialijst: Online'),
  ('org-piloot-vliegtuig', 'Piloot & Vliegtuig', 'Luchtvaart', 'Pers of media', 'https://www.pilootenvliegtuig.nl', 'redactiepilootenvliegtuig@eisma.nl', 'Medialijst: Magazine'),
  ('org-scramble', 'Scramble', 'Luchtvaart', 'Pers of media', 'https://www.scramble.nl', 'civupload@scramble.nl', 'Medialijst: Magazine/online'),
  ('org-aviationnews', 'AviationNews', 'Luchtvaart', 'Pers of media', 'https://www.aviationnews.nl', 'editor@ainonline.com', 'Medialijst: Online'),
  ('org-flightlevel', 'FlightLevel', 'Luchtvaart', 'Pers of media', 'https://www.flightlevel.be', 'redactie@flightlevel.be', 'Medialijst: Magazine/online'),
  ('org-aviation24', 'Aviation24', 'Luchtvaart', 'Pers of media', 'https://aviation24.be', 'newsteam@aviation24.be', 'Medialijst: Online'),
  ('org-aviodrome', 'Aviodrome', 'Luchtvaart', 'Museum', 'https://www.aviodrome.nl', 'info@aviodrome.nl', ''),
  ('org-nationaal-militair-museum', 'Nationaal Militair Museum', 'Luchtvaart', 'Museum', 'https://www.nmm.nl', 'info@nmm.nl', ''),
  ('org-rail-magazine', 'Rail Magazine', 'Railvervoer', 'Pers of media', 'https://www.railmagazine.nl', 'info@railmagazine.nl', 'Medialijst: Magazine'),
  ('org-spoorpro', 'SpoorPro', 'Railvervoer', 'Pers of media', 'https://www.spoorpro.nl', 'redactie@spoorpro.nl', 'Medialijst: Vakmedium'),
  ('org-railtech', 'RailTech', 'Railvervoer', 'Pers of media', 'https://www.railtech.com', 'news@railtech.com', 'Medialijst: Vakmedium'),
  ('org-op-de-rails', 'Op de Rails', 'Railvervoer', 'Pers of media', 'https://www.nvbs.com', 'opderails@nvbs.com', 'Medialijst: Tijdschrift'),
  ('org-ov-magazine', 'OV Magazine', 'Railvervoer', 'Pers of media', 'https://www.ovmagazine.nl', '', 'Medialijst: Vakmedium'),
  ('org-railhobby', 'Railhobby', 'Railvervoer', 'Pers of media', 'https://www.railhobby.nl', '', 'Medialijst: Magazine'),
  ('org-het-spoorwegmuseum', 'Het Spoorwegmuseum', 'Railvervoer', 'Museum', 'https://www.spoorwegmuseum.nl', 'info@spoorwegmuseum.nl', ''),
  ('org-museumstoomtram-hoorn-medemblik', 'Museumstoomtram Hoorn-Medemblik', 'Railvervoer', 'Museum', 'https://www.stoomtram.nl', 'info@stoomtram.nl', ''),
  ('org-veluwsche-stoomtrein-maatschappij', 'Veluwsche Stoomtrein Maatschappij', 'Railvervoer', 'Museum', 'https://www.vsm.nl', 'info@stoomtrein.org', ''),
  ('org-historiek', 'Historiek', 'Erfgoed', 'Pers of media', 'https://historiek.net', 'redactie@historiek.net', 'Medialijst: Online'),
  ('org-erfgoedstem', 'Erfgoedstem', 'Erfgoed', 'Pers of media', 'https://www.erfgoedstem.nl', 'redactie@erfgoedstem.nl', 'Medialijst: Online'),
  ('org-erfgoedvereniging-heemschut', 'Erfgoedvereniging Heemschut', 'Erfgoed', 'Overig', 'https://www.heemschut.nl', 'info@heemschut.nl', 'Medialijst: Erfgoedorganisatie'),
  ('org-museumvereniging', 'Museumvereniging', 'Erfgoed', 'Netwerk of koepel', 'https://www.museumvereniging.nl', 'persberichten@museumvereniging.nl', 'Medialijst: Branche'),
  ('org-bankgiro-loterij-open-monumentendag', 'BankGiro Loterij Open Monumentendag', 'Erfgoed', 'Netwerk of koepel', 'https://www.openmonumentendag.nl', 'info@openmonumentendag.nl', 'Medialijst: Platform'),
  ('org-faro', 'FARO', 'Erfgoed', 'Netwerk of koepel', 'https://faro.be', 'info@faro.be', 'Medialijst: Erfgoedplatform'),
  ('org-nos', 'NOS', 'Algemeen', 'Pers of media', 'https://nos.nl', 'reacties@nos.nl', 'Medialijst: Nieuws'),
  ('org-npo', 'NPO', 'Algemeen', 'Pers of media', 'npo.nl', 'communicatie@npo.nl', 'Medialijst: Nieuws'),
  ('org-anp', 'ANP', 'Algemeen', 'Pers of media', 'https://anp.nl', 'info@anp.nl', 'Medialijst: Persbureau'),
  ('org-bnr', 'BNR', 'Algemeen', 'Pers of media', 'https://bnr.nl', 'webredactie@bnr.nl', 'Medialijst: Nieuws'),
  ('org-trouw', 'Trouw', 'Algemeen', 'Pers of media', 'https://trouw.nl', 'secretariaat@trouw.nl', 'Medialijst: Krant'),
  ('org-nrc', 'NRC', 'Algemeen', 'Pers of media', 'https://nrc.nl', 'nrc@nrc.nl', 'Medialijst: Krant'),
  ('org-de-volkskrant', 'De Volkskrant', 'Algemeen', 'Pers of media', 'https://volkskrant.nl', 'redactie@volkskrant.nl', 'Medialijst: Krant'),
  ('org-algemeen-dagblad', 'Algemeen Dagblad', 'Algemeen', 'Pers of media', 'ad.nl', 'redactie@ad.nl', 'Medialijst: Krant'),
  ('org-parool', 'Parool', 'Algemeen', 'Pers of media', 'parool.nl', 'redactie@parool.nl', 'Medialijst: Krant'),
  ('org-nu-nl', 'Nu.nl', 'Algemeen', 'Pers of media', 'nu.nl', 'contact@nu.nl', 'Medialijst: Online krant'),
  ('org-telegraaf', 'Telegraaf', 'Algemeen', 'Pers of media', 'https://telegraaf.nl', 'nieuwsdienst@telegraaf.nl', 'Medialijst: Krant'),
  ('org-reformatorisch-dagblad', 'Reformatorisch Dagblad', 'Algemeen', 'Pers of media', 'https://rd.nl', 'onderzoek@rd.nl', 'Medialijst: Krant'),
  ('org-de-gelderlander', 'De Gelderlander', 'Regionale media', 'Pers of media', 'https://www.gelderlander.nl', 'redactie@gelderlander.nl', 'Medialijst: Krant'),
  ('org-brabants-dagblad', 'Brabants Dagblad', 'Regionale media', 'Pers of media', 'https://www.bd.nl', 'redactie.tilburg@bd.nl', 'Medialijst: Krant'),
  ('org-de-stentor', 'De Stentor', 'Regionale media', 'Pers of media', 'https://www.destentor.nl', 'info@destentor.nl', 'Medialijst: Krant'),
  ('org-bn-destem', 'BN DeStem', 'Regionale media', 'Pers of media', 'https://www.bndestem.nl', 'redactie@bndestem.nl', 'Medialijst: Krant'),
  ('org-de-limburger', 'De Limburger', 'Regionale media', 'Pers of media', 'https://www.limburger.nl', 'rubrieken@delimburger.nl', 'Medialijst: Krant'),
  ('org-dagblad-van-het-noorden', 'Dagblad van het Noorden', 'Regionale media', 'Pers of media', 'https://www.dvhn.nl', 'redactie@dvhn.nl', 'Medialijst: Krant'),
  ('org-eindhovens-dagblad', 'Eindhovens Dagblad', 'Regionale media', 'Pers of media', 'https://www.ed.nl', 'redactie@ed.nl', 'Medialijst: Krant'),
  ('org-tubantia', 'Tubantia', 'Regionale media', 'Pers of media', 'https://www.tubantia.nl', 'info@tubantia.wegener.nl', 'Medialijst: Krant'),
  ('org-pzc', 'PZC', 'Regionale media', 'Pers of media', 'https://www.pzc.nl', 'redactie@pzc.nl', 'Medialijst: Krant'),
  ('org-noordhollands-dagblad', 'Noordhollands Dagblad', 'Regionale media', 'Pers of media', 'https://www.noordhollandsdagblad.nl', 'redactie@noordhollandsdagblad.nl', 'Medialijst: Krant'),
  ('org-leeuwarder-courant', 'Leeuwarder Courant', 'Regionale media', 'Pers of media', 'https://www.lc.nl', 'redactie@lc.nl', 'Medialijst: Krant'),
  ('org-friesch-dagblad', 'Friesch Dagblad', 'Regionale media', 'Pers of media', 'https://www.frieschdagblad.nl', 'regio@frieschdagblad.nl', 'Medialijst: Krant'),
  ('org-haarlems-dagblad', 'Haarlems Dagblad', 'Regionale media', 'Pers of media', 'https://www.haarlemsdagblad.nl', 'stadsredactie@haarlemsdagblad.nl', 'Medialijst: Krant'),
  ('org-leidsch-dagblad', 'Leidsch Dagblad', 'Regionale media', 'Pers of media', 'https://www.leidschdagblad.nl', 'redactie@leidschdagblad.nl', 'Medialijst: Krant'),
  ('org-ijmuider-courant', 'IJmuider Courant', 'Regionale media', 'Pers of media', 'https://www.ijmuidercourant.nl', 'redactie@ijmuidercourant.nl', 'Medialijst: Krant'),
  ('org-gooi-en-eemlander', 'Gooi en Eemlander', 'Regionale media', 'Pers of media', 'https://www.gooieneemlander.nl', 'redactie@gooieneemlander.nl', 'Medialijst: Krant'),
  ('org-barneveldse-krant', 'Barneveldse Krant', 'Regionale media', 'Pers of media', 'https://www.barneveldsekrant.nl', 'barneveldsekrant@bdu.nl', 'Medialijst: Krant'),
  ('org-nh-nieuws', 'NH Nieuws', 'Regionale media', 'Pers of media', 'https://www.nhnieuws.nl', 'nieuws@nhmedia.nl', 'Medialijst: Omroep'),
  ('org-omroep-brabant', 'Omroep Brabant', 'Regionale media', 'Pers of media', 'https://www.omroepbrabant.nl', 'info@omroepbrabant.nl', 'Medialijst: Omroep'),
  ('org-omroep-gelderland', 'Omroep Gelderland', 'Regionale media', 'Pers of media', 'https://www.gld.nl', 'omroep@gld.nl', 'Medialijst: Omroep'),
  ('org-omroep-west', 'Omroep West', 'Regionale media', 'Pers of media', 'https://www.omroepwest.nl', 'redactie@omroepwest.nl', 'Medialijst: Omroep'),
  ('org-rtv-noord', 'RTV Noord', 'Regionale media', 'Pers of media', 'https://www.rtvnoord.nl', 'redactie@rtvnoord.nl', 'Medialijst: Omroep'),
  ('org-rtv-oost', 'RTV Oost', 'Regionale media', 'Pers of media', 'https://www.rtvoost.nl', 'nieuws@oost.nl', 'Medialijst: Omroep'),
  ('org-rtv-rijnmond', 'RTV Rijnmond', 'Regionale media', 'Pers of media', 'https://www.rijnmond.nl', 'nieuws@rijnmond.nl', 'Medialijst: Omroep'),
  ('org-omrop-fryslan', 'Omrop Fryslân', 'Regionale media', 'Pers of media', 'https://www.omropfryslan.nl', 'redaksje@omropfryslan.nl', 'Medialijst: Omroep'),
  ('org-klassiek-techniek', 'Klassiek & Techniek', 'Vakblad mobiliteit', 'Pers of media', 'https://www.klassiek-techniek.nl', 'info@klassiek-techniek.nl', 'Medialijst: Vakblad'),
  ('org-truckstar', 'Truckstar', 'Vakblad mobiliteit', 'Pers of media', 'https://www.truckstar.nl', 'redactie@truckstar.nl', 'Medialijst: Vakblad'),
  ('org-erfgoed-magazine', 'Erfgoed Magazine', 'Vakblad erfgoed', 'Pers of media', 'https://erfgoed-magazine.nl', 'info@erfgoed-magazine.nl', 'Medialijst: Vakblad'),
  ('org-monumentaal', 'Monumentaal', 'Vakblad erfgoed', 'Pers of media', 'https://monumentaal.com', 'redactie@monumentaal.com', 'Medialijst: Vakblad'),
  ('org-museumpeil', 'Museumpeil', 'Vakblad erfgoed', 'Pers of media', 'https://museumpeil.eu/', 'redactie@museumpeil.eu', 'Medialijst: Vakblad'),
  ('org-archievenblad', 'Archievenblad', 'Vakblad erfgoed', 'Pers of media', 'https://www.kvan.nl/archievenblad/', 'info@kvan.nl', 'Medialijst: Vakblad'),
  ('org-boekman', 'Boekman', 'Vakblad erfgoed', 'Pers of media', 'https://www.boekman.nl/', 'secretariaat@boekman.nl', 'Medialijst: Vakblad'),
  ('org-erfgoed-brabant', 'Erfgoed Brabant', 'Erfgoedhuis', 'Erfgoedhuis', 'https://erfgoedbrabant.nl', 'info@erfgoedbrabant.nl', ''),
  ('org-erfgoed-gelderland', 'Erfgoed Gelderland', 'Erfgoedhuis', 'Erfgoedhuis', 'https://www.erfgoedgelderland.nl', 'info@erfgoedgelderland.nl', ''),
  ('org-erfgoed-zeeland', 'Erfgoed Zeeland', 'Erfgoedhuis', 'Erfgoedhuis', 'https://www.erfgoedzeeland.nl', 'info@erfgoedzeeland.nl', ''),
  ('org-landschap-erfgoed-utrecht', 'Landschap Erfgoed Utrecht', 'Erfgoedhuis', 'Erfgoedhuis', 'https://www.landschaperfgoedutrecht.nl', 'info@landschaperfgoedutrecht.nl', ''),
  ('org-erfgoedhuis-zuid-holland', 'Erfgoedhuis Zuid-Holland', 'Erfgoedhuis', 'Erfgoedhuis', 'https://www.erfgoedhuis-zh.nl', 'info@erfgoedhuis-zh.nl', ''),
  ('org-huis-van-hilde', 'Huis van Hilde', 'Erfgoedhuis', 'Erfgoedhuis', 'https://www.huisvanhilde.nl', 'info@huisvanhilde.nl', ''),
  ('org-collectie-overijssel', 'Collectie Overijssel', 'Erfgoedhuis', 'Erfgoedhuis', 'https://www.collectieoverijssel.nl', 'info@collectieoverijssel.nl', ''),
  ('org-erfgoedpartners-groningen', 'Erfgoedpartners Groningen', 'Erfgoedhuis', 'Erfgoedhuis', 'https://www.erfgoedpartners.nl', 'info@erfgoedpartners.nl.', ''),
  ('org-museumfederatie-fryslan', 'Museumfederatie Fryslân', 'Erfgoedhuis', 'Erfgoedhuis', 'https://www.museumfederatie.frl', 'info@museumfederatiefryslan.nl', ''),
  ('org-drents-archief', 'Drents Archief', 'Erfgoedhuis', 'Erfgoedhuis', 'https://www.drentsarchief.nl', 'info@drentsarchief.nl', '')
on conflict (id) do update set
  sector  = case when organisaties.sector  = '' then excluded.sector  else organisaties.sector  end,
  soort   = case when organisaties.soort   = '' then excluded.soort   else organisaties.soort   end,
  website = case when organisaties.website = '' then excluded.website else organisaties.website end,
  email   = case when organisaties.email   = '' then excluded.email   else organisaties.email   end,
  notitie = case when organisaties.notitie = '' then excluded.notitie
                 when excluded.notitie = '' then organisaties.notitie
                 else organisaties.notitie || E'\n' || excluded.notitie end;

-- ── Controle ────────────────────────────────────────────────
select 'organisaties' as tabel, count(*) from organisaties
union all select 'waarvan met sector', count(*) from organisaties where sector <> ''
union all select 'waarvan met soort', count(*) from organisaties where soort <> ''
union all select 'waarvan met e-mailadres', count(*) from organisaties where email <> ''
union all select 'sectoren in de keuzelijst', count(*) from organisatie_sectoren
union all select 'soorten in de keuzelijst', count(*) from organisatie_soorten;
