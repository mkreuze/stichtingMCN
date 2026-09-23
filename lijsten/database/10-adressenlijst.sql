-- ============================================================
--  Adressenlijst overnemen in de relatielijst
--
--  Gemaakt uit "Adressenlijst Jubileumcongres MCN 21 november 2025"
--  (78 regels) op 23 September 2026.
--
--  Draai dit ná 08 en 09, want het gebruikt de velden adres,
--  postcode, email en telefoon bij een organisatie.
--
--  Je mag dit opnieuw draaien: bestaande regels worden bijgewerkt,
--  er ontstaan geen dubbelen.
--
--  Let op: soort, adres, postcode en plaats zijn leeg gelaten. Die
--  stonden niet in het bestand; die vul je in de Console zelf aan.
-- ============================================================

-- ── Organisaties (56) ──────────────────────────────────────
insert into organisaties (id, naam, email, notitie) values
  ('org-rdw', 'RDW', '', ''),
  ('org-paleis-het-loo', 'Paleis Het Loo', '', 'Ook uitnodigen voor platforms'),
  ('org-federatie-historische-automobiel-en-motorfietsclubs', 'Federatie Historische Automobiel- en Motorfietsclubs', 'voorzitter@fehac.nl', ''),
  ('org-nationale-federatie-historische-luchtvaart', 'Nationale Federatie Historische Luchtvaart', 'anjarick@gmail.com', ''),
  ('org-federatie-varend-erfgoed-nederland', 'Federatie Varend Erfgoed Nederland', 'secr@fven.nl', ''),
  ('org-historisch-railvervoer-nederland', 'Historisch Railvervoer Nederland', 'info@railmusea.nl', ''),
  ('org-erfgoedvereniging-heemschut', 'Erfgoedvereniging Heemschut', 'info@heemschut.nl', ''),
  ('org-erfgoedplatform-kunsten-92', 'Erfgoedplatform / Kunsten ''92', 'info@kunsten92.nl', ''),
  ('org-landelijk-contact-museumconsulenten', 'Landelijk Contact Museumconsulenten', 'info@museumconsulenten.nl', ''),
  ('org-federatie-instandhouding-monumenten', 'Federatie Instandhouding Monumenten', 'info@fimnederland.nl', ''),
  ('org-federatie-industrieel-erfgoed-nederland', 'Federatie Industrieel Erfgoed Nederland', 'redactie@industrieel-erfgoed.nl', ''),
  ('org-bankgiro-loterij-open-monumentendag', 'BankGiro Loterij Open Monumentendag', 'info@openmonumentendag.nl', ''),
  ('org-mondriaan-fonds', 'Mondriaan Fonds', 'info@mondriaanfonds.nl', ''),
  ('org-cultuurfonds', 'Cultuurfonds', 'info@cultuurfonds.nl', ''),
  ('org-stichting-hippomobiel-erfgoed', 'Stichting Hippomobiel Erfgoed', 'info@hippomobielerfgoed.nl', ''),
  ('org-museumvereniging', 'Museumvereniging', 'info@museumvereniging.nl', ''),
  ('org-fonds-voor-cultuurparticipatie', 'Fonds voor Cultuurparticipatie', 'info@cultuurparticipatie.nl', ''),
  ('org-rail-hobby', 'Rail Hobby', 'info@railhobby.nl', ''),
  ('org-museumtijdschrift', 'Museumtijdschrift', 'museumtijdschrift@museumtijdschrift', ''),
  ('org-op-de-rails', 'Op de Rails', 'opderails@nvbs.com', ''),
  ('org-heemschut-tijdschrift', 'Heemschut - tijdschrift', 'redactie@heemschut.nl', ''),
  ('org-industria', 'Industria', 'redactie@industrieel-erfgoed.nl', ''),
  ('org-historisch-nieuwsblad', 'Historisch Nieuwsblad', 'smits@historischnieuwsblad.nl', ''),
  ('org-rail-magazine', 'Rail Magazine', 'info@railmagazine.nl', ''),
  ('org-verenigde-vleugels', 'Verenigde Vleugels', 'info@verenigdevleugels.nl', ''),
  ('org-erfgoed-magazine', 'Erfgoed Magazine', 'info@erfgoed-magazine.nl', ''),
  ('org-op-oude-rails', 'Op Oude Rails', 'paulenbren@gmail.com', ''),
  ('org-erfgoedstem', 'Erfgoedstem', 'redactie@erfgoedstem.nl', ''),
  ('org-monumentaal', 'Monumentaal', 'redactie@monumentaal.com', ''),
  ('org-scheepspost', 'Scheepspost', 'redactie@scheepspost.info', ''),
  ('org-european-heritage', 'European Heritage', 'jetske@heritagetribune.eu', ''),
  ('org-leer-je-erfgoed', 'Leer je erfgoed', 'info@leerjeerfgoed.nl', ''),
  ('org-e-faith', 'E-FAITH', 'secretariat@e-faith.org', ''),
  ('org-erfgoedjong', 'Erfgoedjong', 'info@erfgoedjong.nl', ''),
  ('org-koninklijke-luchtmacht-historische-vlucht', 'Koninklijke Luchtmacht Historische Vlucht', 'office@kluhv.nl', ''),
  ('org-dda', 'DDA', 'office@dutchdakota.org', ''),
  ('org-netwerk-digitaal-erfgoed', 'Netwerk Digitaal Erfgoed', 'info@netwerkdigitaalerfgoed.nl', ''),
  ('org-nvbs', 'NVBS', 'agenda@nvbs.com', 'Ook: socialmedia@nvbs.com'),
  ('org-vlaamse-vereniging-voor-industriele-archeologie-vzw', 'Vlaamse Vereniging voor Industriële Archeologie vzw', 'info@industrieelerfgoed.be', ''),
  ('org-loopings', 'Loopings', 'redactie@looopings.nl', ''),
  ('org-auto-motor-klassiek', 'Auto Motor Klassiek', 'redactie@amklassiek.nl', ''),
  ('org-klassiek-techniek', 'Klassiek & Techniek', 'benno@klassiek-techniek.nl', ''),
  ('org-onschatbare-klassieker', 'Onschatbare klassieker', 'info@okm.nl', ''),
  ('org-autoweek', 'Autoweek', 'redactie@autoweek.nl', ''),
  ('org-industriecultuur', 'Industriecultuur', 'info@industriecultuur.be', ''),
  ('org-hrn-update', 'HRN Update', 'railmusea@gmail.com', ''),
  ('org-fim', 'FIM', '', ''),
  ('org-ocw', 'OCW', '', ''),
  ('org-rce', 'RCE', '', ''),
  ('org-fehac', 'FEHAC', '', ''),
  ('org-fven', 'FVEN', '', ''),
  ('org-boei', 'BOEi', '', ''),
  ('org-erfgoedacademie', 'ErfgoedAcademie', 'info@erfgoedacademie.nl', ''),
  ('org-reinwardt-academie', 'Reinwardt Academie', 'rwa-info@ahk.nl', ''),
  ('org-nederland-monumentenland', 'Nederland Monumentenland', 'info@monumentenland.nl', ''),
  ('org-nationale-monumentenorganisatie', 'Nationale Monumentenorganisatie', 'info@nmo.nl', '')
on conflict (id) do update set
  naam = excluded.naam,
  email = case when organisaties.email = '' then excluded.email else organisaties.email end,
  notitie = case when organisaties.notitie = '' then excluded.notitie else organisaties.notitie end;

-- ── Personen (29) ─────────────────────────────────────────
insert into personen (id, organisatie_id, naam, functie, email, telefoon) values
  ('pers-chris-sijbranda-3', 'org-rdw', 'Chris Sijbranda', '', 'CSybranda@rdw.nl', ''),
  ('pers-wim-van-den-hende-4', 'org-rdw', 'Wim van den Hende', '', 'WvandenHende@rdw.nl', ''),
  ('pers-noah-van-kipshagen-5', null, 'Noah van Kipshagen', '', 'nvankipshagen@gmail.com', ''),
  ('pers-marit-berends-6', 'org-paleis-het-loo', 'Marit Berends', 'conservator', 'm.berends@paleishetloo.nl', ''),
  ('pers-elisabeth-wiessner-41', 'org-netwerk-digitaal-erfgoed', 'Elisabeth Wiessner', '', 'elisabeth.wiessner@netwerkdigitaalerfgoed.nl', ''),
  ('pers-arjen-kok-45', null, 'Arjen Kok', '', 'arjenkok@gmail.com', ''),
  ('pers-lara-riga-54', 'org-mondriaan-fonds', 'Lara Riga', '', 'lara.riga@mondriaanfonds.nl', ''),
  ('pers-annemarie-willems-55', 'org-cultuurfonds', 'Annemarie Willems', '', 'A.Willems@cultuurfonds.nl', ''),
  ('pers-anna-de-wit-56', 'org-cultuurfonds', 'Anna de Wit', '', 'a.dewit@cultuurfonds.nl', ''),
  ('pers-martine-van-lier-57', 'org-fim', 'Martine van Lier', '', 'martine.v.lier@gmail.com', ''),
  ('pers-thomas-van-den-berg-58', 'org-ocw', 'Thomas van den Berg', '', 't.p.vandenberg@minocw.nl', ''),
  ('pers-myra-wanst-59', 'org-ocw', 'Myra Wanst', '', 'm.s.wanst@minocw.nl', ''),
  ('pers-lieve-ettes-60', 'org-ocw', 'Lieve Ettes', '', 'l.ettes@minocw.nl', ''),
  ('pers-dirk-houtgraaf-61', 'org-rce', 'Dirk Houtgraaf', '', 'D.Houtgraaf@cultureelerfgoed.nl', ''),
  ('pers-chris-van-bendegem-62', 'org-ocw', 'Chris van Bendegem', '', 'c.b.vanbendegem@minocw.nl', ''),
  ('pers-frank-bergevoet-63', 'org-rce', 'Frank Bergevoet', '', 'F.Bergevoet@cultureelerfgoed.nl', ''),
  ('pers-bert-pronk-64', 'org-fehac', 'Bert Pronk', '', 'public-affairs-fehac@mail.com', ''),
  ('pers-rolf-holwerda-65', 'org-fven', 'Rolf Holwerda', '', 'holwerh@xs4all.nl', ''),
  ('pers-pieter-van-der-ham-66', 'org-historisch-railvervoer-nederland', 'Pieter van der Ham', '', 'pietervanderham@planet.nl', ''),
  ('pers-stijn-van-genugten-67', null, 'Stijn van Genugten', 'Voorzitter Beoordelingscommissie NRRe', 'stijnvangenuchten@gmail.com', ''),
  ('pers-karel-loeff-68', 'org-erfgoedvereniging-heemschut', 'Karel Loeff', '', 'Loeff@Heemschut.nl', ''),
  ('pers-dr-erik-nijhof-69', 'org-federatie-industrieel-erfgoed-nederland', 'Dr. Erik Nijhof', '', '1948erik@gmail.com', ''),
  ('pers-jaap-nieweg-70', null, 'Jaap Nieweg', 'Grondlegger MCN', 'j.nieweg@quicknet.nl', ''),
  ('pers-rebecca-roskam-71', 'org-mondriaan-fonds', 'Rebecca Roskam', '', 'rebecca.roskam@mondriaanfonds.nl', ''),
  ('pers-max-popma-72', null, 'Max Popma', 'Grondlegger MCN', 'maxpopma@gmail.com', ''),
  ('pers-arno-van-der-holst-73', null, 'Arno van der Holst', 'Grondlegger MCN', 'hubobe@hotmail.com', ''),
  ('pers-arno-boon-74', 'org-boei', 'Arno Boon', '', 'a.boon@boei.nl', ''),
  ('pers-bert-boer-78', 'org-nederland-monumentenland', 'Bert Boer', '', 'b.boer@monumentenland.nl', ''),
  ('pers-eefje-van-duin-79', 'org-federatie-instandhouding-monumenten', 'Eefje van Duin', '', 'voorzitter@fimnederland.nl', '')
on conflict (id) do update set
  organisatie_id = excluded.organisatie_id, naam = excluded.naam,
  functie = excluded.functie, email = excluded.email;

-- ── Controle ────────────────────────────────────────────────
select 'organisaties' as tabel, count(*) from organisaties
union all select 'waarvan met algemeen adres', count(*) from organisaties where email <> ''
union all select 'personen', count(*) from personen
union all select 'waarvan zonder organisatie', count(*) from personen where organisatie_id is null;
