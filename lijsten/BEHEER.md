# Beheerhandleiding Mobiel Erfgoed Console

Overdrachtsdocument voor de **Mobiel Erfgoed Console**: de interne werklijst
van de Stichting Mobiele Collectie Nederland met acties, besluiten en
relaties. Stand van zaken: 1 oktober 2026, versie 1.15.

De **website** www.stichtingmcn.nl heeft een eigen handleiding:
[`BEHEER.md`](../BEHEER.md) in de hoofdmap. Hoe de Console werkt voor de
gebruiker (weergaven, filters, formulieren, versiegeschiedenis) staat in
[`README.md`](README.md) in deze map.

---

## 1. In één oogopslag

- De Console is **één HTML-bestand** (`index.html`) zonder bouwstap. Alle
  gegevens en het inloggen lopen via **Supabase** (database op een Europese
  server, Frankfurt).
- De Console staat op **Vercel**: https://stichting-mcn.vercel.app. Vercel
  publiceert automatisch vanaf de GitHub-tak **`mcn-console`**, map
  `lijsten`. **Een wijziging op die tak staat binnen een minuut live.**
- Inloggen gaat met een link per e-mail, zonder wachtwoord. Alleen wie in
  de tabel `leden` staat, kan een account aanmaken en iets zien.
- De Console staat los van de website: andere hosting (Vercel in plaats van
  TransIP), andere tak (`mcn-console` in plaats van `main`). Ze delen alleen
  de GitHub-repository.

```
  wijziging in lijsten/  ──►  push naar mcn-console  ──►  Vercel  ──►  stichting-mcn.vercel.app
                                                                            │
                                         gegevens en inloggen  ◄────────────┘
                                         Supabase (Frankfurt)
```

---

## 2. Systemen en accounts

| Systeem | Waarvoor | Details | Toegang overdragen |
|---|---|---|---|
| **Supabase** – project van MCN | Database, inloggen, toegangsregels | Gratis abonnement: 500 MB database, 1 GB bestandsopslag, 5 GB dataverkeer per maand. Europese server (Frankfurt). | Nieuwe beheerder uitnodigen in het Supabase-project (Organization → Members). Het databasewachtwoord staat in de wachtwoordkluis van MCN. |
| **Supabase** – Authentication | Inloggen met een link per e-mail | *Hooks → Before User Created* staat op `public.mag_account_aanmaken`: alleen adressen uit `leden` mogen een account maken. Onder *URL Configuration* staat het adres van de Console. | Zelfde project. Verhuist de Console, dan het nieuwe adres hier toevoegen. |
| **Vercel** – project | Publiceert de Console | Gratis (Hobby). Productietak `mcn-console`, hoofdmap (*Root Directory*) `lijsten`. | Vercel-account van de beheerder; project overdragen of nieuwe beheerder uitnodigen. |
| **GitHub** – tak `mcn-console` | Broncode en versiegeschiedenis | In dezelfde repository als de website, [`mkreuze/stichtingMCN`](https://github.com/mkreuze/stichtingMCN). | Zie de website-handleiding. |
| **cdnjs / jsDelivr** | Bibliotheken voor PDF- en Excel-downloads | Worden pas bij een download ingeladen. Geen account nodig. | – |

In de pagina staan twee sleutels van Supabase: de *Project URL* en de
*publishable* (vroeger *anon*) sleutel. Die mogen openbaar zijn; de
toegangsregels in de database bepalen wat iemand mag. De **secret**
sleutel (`sb_secret_…`, vroeger *service_role*) omzeilt alle regels: die
komt nooit in een pagina, een mail of de repository.

---

## 3. Hoe de Console in elkaar zit

### 3.1 Bestanden in `lijsten/`

| Bestand / map | Inhoud |
|---|---|
| `index.html` | De hele Console: opmaak, schermen en logica. Het versienummer staat bij het *i*-knopje rechtsboven. |
| `logo.png` | Het logo bovenaan. |
| `README.md` | Uitleg voor de gebruiker en de versietabel. |
| `BEHEER.md` | Deze handleiding. |
| `OVERZETTEN.md` | Hoe de oude lijst uit het Claude-artifact is overgezet (afgerond). |
| `database/` | De SQL-bestanden die de database hebben opgebouwd, op nummer (01 t/m 27). |
| `test-nepsupabase.js` | Hulpbestand om de Console zonder echte database te testen. |

### 3.2 Tabellen in Supabase

| Tabel | Inhoud | In de Console heet het |
|---|---|---|
| `leden` | Wie mag inloggen, met rol en toegang | Gebruikers |
| `categorieen` | Naam, volgnummer en groepen (`labels`) | Onderwerpen; de labels zijn de groepen |
| `acties` | De acties, met wie, datum, labels, afronding | Acties |
| `besluiten` | Besluiten, met de actie waar ze uit voortkwamen | Besluiten |
| `organisaties` | Organisaties met adres, soort, sector, aansluiting | Relaties → Organisaties |
| `personen` | Contactpersonen, met notitie | Relaties → Personen |
| `organisatie_soorten`, `organisatie_sectoren` | De keuzelijsten | Soorten, Sectoren |
| `instellingen` | De huisstijl | Huisstijl |
| `logboek` | Elke wijziging, door de database zelf bijgeschreven | Logboek |

**Rollen:** `kijker` (alleen lezen), `bewerker` (lezen en wijzigen),
`beheerder` (ook gebruikers, groepen, onderwerpen en keuzelijsten
beheren; ziet altijd alles). **Toegang per gebruiker:** acties (alle
groepen of alleen bepaalde), besluiten en relaties. Dit wordt door de
database zelf afgedwongen, niet alleen door de Console.

---

## 4. Dagelijks beheer (in de Console zelf)

Alles hieronder doet de beheerder onder het **tandwieltje** rechtsboven.

- **Gebruikers** — iemand toegang geven: *Gebruiker toevoegen*, kies de
  persoon uit de contactpersonen van MCN (die heeft een e-mailadres
  nodig). Contactpersonen en gebruikers zijn twee aparte lijsten. Bij
  elke gebruiker staat wanneer die voor het laatst is ingelogd.
- **Groepen** — zoals Google Groups: per groep (Bestuur, Projectgroep) de
  onderwerpen en de leden. Leden toevoegen of weghalen.
- **Onderwerpen** — naam, volgorde en groepen.
- **Soorten organisaties, Sectoren, Labels bij acties** — de keuzelijsten.
- **Huisstijl** — de kleuren van de lichte en de donkere versie.
- **Logboek** — wie wat heeft gewijzigd. Bij een verwijdering staat de
  hele regel erin, zodat die terug te zetten is.
- **Backup** — zie §6.

---

## 5. Een wijziging aan de Console zelf

Wijzigingen in de pagina of de database doet Claude (of een ontwikkelaar)
op de tak `mcn-console`.

1. **Pagina wijzigen:** `lijsten/index.html` aanpassen, testen, het
   versienummer bij het *i*-knopje ophogen, een regel toevoegen aan de
   versietabel in `README.md` en aan het Beheerlog hieronder.
2. **Publiceren:** vastleggen en pushen naar `mcn-console`. Vercel zet het
   binnen een minuut live; gebruikers zien het na verversen (F5).
3. **Database wijzigen:** altijd met een nieuw, genummerd bestand in
   `database/` (bijv. `28-….sql`), dat opnieuw gedraaid mag worden en
   onderaan een controle-telling heeft. De beheerder draait het in
   Supabase → **SQL Editor**: plakken, *Run*, de telling controleren.
   Maak eerst een backup (§6).
4. **Pagina en database samen:** de pagina moet blijven werken zolang het
   nieuwe SQL-bestand nog niet gedraaid is (nieuwe velden pas tonen als
   de kolom bestaat). Zo maakt de volgorde niet uit.

**Let op bij de SQL Editor van Supabase:** die knipt een script in stukken
bij elke puntkomma, ook midden in een functie, en struikelt over `$$`.
Daarom staat elke opdracht op één regel en staat een puntkomma binnen een
functie geschreven als `\073`. Houd dat zo. Controleer na het plakken of
alles is meegekomen: een te lange plak wordt stilzwijgend afgekapt.

**Geen persoonsgegevens in de repository.** De repository is openbaar.
Contactgegevens (e-mailadressen, telefoonnummers) horen alleen in de
database, niet in SQL-bestanden of andere bestanden op GitHub. Moeten er
contacten worden ingelezen, dan gebeurt dat met een bestand dat niet in
de repository komt.

---

## 6. Backup en herstel

- **Backup maken:** tandwieltje → *Backup* → *Downloaden (.json)*. Dat is
  de volledige backup van alle tabellen. *Downloaden (.xlsx)* is dezelfde
  inhoud om in te kijken. Bewaar het bestand op een veilige plek: er
  staan e-mailadressen en telefoonnummers in.
- **Wanneer:** regelmatig, en altijd vóór het draaien van een nieuw
  SQL-bestand.
- **Herstel:** niet vanuit de Console. Met het `.json`-bestand kan een
  ontwikkelaar (of Claude) de gegevens terugzetten. Een enkele verwijderde
  regel staat ook in het logboek.
- Het gratis abonnement van Supabase biedt zelf geen backup die je kunt
  terugzetten. De eigen backup is dus belangrijk.

---

## 7. Later verhuizen naar TransIP

Besluit van 25-09-2026: zolang de Console nog vaak verandert, blijft hij
op Vercel. Als hij af is, gaat hij naar **stichtingmcn.nl/console**, zodat
alles bij één partij zit. Wat er dan moet gebeuren:

1. In `.github/workflows/deploy.yml` bij *Voorbereiden upload-map* de map
   `console/` aanmaken en daarin `lijsten/index.html` en `lijsten/logo.png`
   zetten (niet de rest van `lijsten/`).
2. De tak `mcn-console` samenvoegen met `main`.
3. In Supabase (*Authentication → URL Configuration*) het nieuwe adres
   toevoegen.
4. Daarna het Vercel-project opheffen.

Vanaf dan gaat elke wijziging aan de Console live via `main`, net als de
website, en dus steeds met toestemming.

---

## 8. Bekende aandachtspunten

1. **Supabase pauzeert een gratis project** als er een week niemand in de
   Console is geweest. De gegevens blijven bewaard; het project weer
   aanzetten kan met één klik in het Supabase-scherm. Supabase mailt
   vooraf.
2. **PDF- en Excel-downloads** laden hun bibliotheek van internet
   (cdnjs, met jsDelivr als reserve). Zonder internet werken ze niet.
3. **Documenten koppelen** aan acties of organisaties is besproken maar nog
   niet gebouwd. Advies: eerst met links naar documenten in de eigen
   opslag, niet uploaden in Supabase (1 GB opslag, niet in de backup).
4. **Herkomst:** de lijst draaide eerst als Claude-artifact. Die is
   overgezet met behoud van alle kenmerken en daarna opgeruimd.

---

## 9. Beheerlog

| Datum | Wie | Wat |
|---|---|---|
| 22-09-2026 | Marinus Kreuze | Mobiel Erfgoed Console opgezet: eigen Supabase-database (Frankfurt) met toegangsregels per rol, en de actie- en besluitenlijst overgezet uit het Claude-artifact (6 categorieën, 41 acties, 1 besluit). Relatielijst met organisaties en personen toegevoegd. |
| 23-09-2026 | Marinus Kreuze | Console gepubliceerd op Vercel vanaf de tak `mcn-console`. Aanmelden beperkt tot adressen in de tabel `leden` via het Supabase-haakje *Before User Created*. |
| 25-09-2026 | Marinus Kreuze | Naam van een persoon gesplitst in voornaam, tussenvoegsel en achternaam, met geslacht erbij. Actiehouders gekoppeld aan de personen van de eigen organisatie. Actielijst rustiger gemaakt. Nieuwe weergaven Per persoon, Per relatie en Agenda. |
| 25-09-2026 | Marinus Kreuze | Bij *Wie* eerst de organisatie (standaard de eigen organisatie), dan de contactpersoon, of de hele organisatie. Het aparte veld *Relatie* is vervallen. *Per relatie* heet *Per organisatie*. Database: `17-wie-organisatie.sql`. |
| 25-09-2026 | Marinus Kreuze | Losse namen Allen en Marketing omgezet naar de hele organisatie MCN (`18-` en `19-…-naar-mcn.sql`). Filterbalk opgeruimd. |
| 25-09-2026 | Marinus Kreuze | Versie 1.5: *Nieuwe actie* vanuit elke weergave, filter op *Wie*, besluiten en relaties in kaartstijl, versieknopje. |
| 25-09-2026 | Marinus Kreuze | Versie 1.6: tandwieltje met *Instellingen*: licht/donker voor iedereen, beheer van soorten, sectoren en labels voor de beheerder. |
| 25-09-2026 | Marinus Kreuze | Versie 1.7: gebruikers beheren onder het tandwieltje. Database: `20-beheer-alleen-beheerder.sql`. |
| 25-09-2026 | Marinus Kreuze | Versie 1.8: rechten per gebruiker (acties per groep, besluiten, relaties), ook in de database (`21-rechten-per-gebruiker.sql`). |
| 25-09-2026 | Marinus Kreuze | Versie 1.9–1.10: formulier schuift in beeld; donkere versie *antraciet*; kaart *Huisstijl*; nieuwe gebruiker kiezen uit de contactpersonen van MCN. |
| 25-09-2026 | Marinus Kreuze | Versie 1.11: huisstijl instelbaar door de beheerder. Database: `22-instellingen-huisstijl.sql`. |
| 25-09-2026 | Marinus Kreuze | Besluit: de Console blijft voorlopig op Vercel en verhuist later naar TransIP (stichtingmcn.nl/console); zie §7. |
| 28-09-2026 | Marinus Kreuze | Versie 1.12: backup onder het tandwieltje; notitieveld bij personen. Database: `23-organisaties-en-contacten.sql` (soort en sector voor 44 organisaties, contactpersonen uit de mail). |
| 28-09-2026 | Marinus Kreuze | `24-fim-samenvoegen.sql` en `25-dubbele-organisaties.sql`: FIM, FEHAC, FVEN en Railhobby elk tot één organisatie samengevoegd. |
| 28-09-2026 | Marinus Kreuze | Oude Claude-artifacts opgeruimd (inhoud eerst vergeleken: alles stond al in de Console). |
| 28-09-2026 | Marinus Kreuze | Versie 1.13: *Logboek* en laatst gezien/ingelogd (`26-logboek.sql`); bij organisaties *Aangesloten bij MCN* en *Aangesloten als bron* (`27-aansluiting.sql`). |
| 01-10-2026 | Marinus Kreuze | Versie 1.14: *categorie* heet *onderwerp*, *categoriegroep* heet *groep*; kaart *Groepen* met onderwerpen en leden; sorteren op kolomkoppen; fout bij afronden opgelost; overal *actie* in plaats van *taak*. |
| 01-10-2026 | Marinus Kreuze | Versie 1.15: groepen als eigen balk boven de weergaven; keuzelijst *Volgorde* vervallen, sorteren met de kolomkoppen. |
| 01-10-2026 | Marinus Kreuze | Beheerhandleiding gesplitst: deze handleiding voor de Console, `BEHEER.md` in de hoofdmap voor de website. |
