# Mobiel Erfgoed Console

Een gedeelde lijst voor bestuur en projectgroep, met een eigen database en
een eigen inlog. Dit is de opvolger van de lijst die nu als Claude-artifact
draait; de opzet en de werking zijn gelijk, met een relatielijst erbij.

## Waarom een eigen database

- De persoonsgegevens in de relatielijst staan in een database van de
  stichting zelf, op een Europese server.
- Er is onderscheid tussen **meekijken** en **wijzigen**.
- Wie niet op de ledenlijst staat, ziet niets — ook niet met de link.

## Onderdelen

| Wat | Waar |
|---|---|
| De pagina zelf | `index.html` — één bestand, geen bouwstap |
| Database en inlog | Supabase (gratis pakket) |
| Publicatie | Vercel, of een submap op de eigen website |

## In gebruik nemen

**1. Maak een Supabase-project aan** op supabase.com.
Kies bij *Region* een **Europese** server (bijvoorbeeld Frankfurt).
Bewaar het wachtwoord dat je voor de database instelt.

**2. Maak de tabellen aan.**
Ga in Supabase naar **SQL Editor** en draai de bestanden uit `database/`
op volgorde: `01-schema.sql`, `02-toegang.sql`, `03-live-bijwerken.sql`.
Plak de inhoud, klik op *Run*, en ga door naar het volgende bestand.

**3. Geef jezelf toegang.**
Pas in `04-eerste-lid.sql` het e-mailadres aan en draai ook dat.
Zonder deze stap ziet niemand iets — ook jij niet.

**4. Zet inloggen per e-mail aan.**
Ga naar **Authentication → Providers** en zorg dat *Email* aanstaat.
Zet **Confirm email** aan en wachtwoorden uit als je alleen met een
toegangslink per e-mail wilt werken.

**5. Geef de twee sleutels door.**
Die staan in Supabase onder **Settings → API Keys**:

- de **Project URL** (ziet eruit als `https://abcdefgh.supabase.co`)
- de **publishable** sleutel, die begint met `sb_publishable_`

Heet het bij jou nog *anon public* in plaats van *publishable*? Dan is dat
de goede; Supabase is die naam aan het vervangen en beide werken.

Deze twee mogen openbaar in de pagina staan: ze geven op zichzelf geen
toegang, want de toegangsregels in de database bepalen wat iemand mag.

De **secret** sleutel (`sb_secret_…`, vroeger *service_role*) is iets
heel anders: die omzeilt alle toegangsregels. Die geef je nooit door,
zet je nergens in een pagina en mail je niet.

## De actielijst

Vijf weergaven:

- **Per categorie** — kaarten die je open- en dichtklapt, met de voortgang
  per categorie.
- **Alle acties** — één doorlopende lijst met kolommen: actie, wie, datum,
  categorie en label. Verlopen datums kleuren rood.
- **Per persoon** — een kaart per actiehouder: eerst de mensen van de eigen
  organisatie, dan personen van buiten, dan losse namen zoals Sectoren.
- **Per organisatie** — een kaart per organisatie van de actiehouder:
  eerst de eigen organisatie, dan de andere op naam. Met een knop naar
  die organisatie in de relatielijst.
- **Agenda** — Datum verstreken, Binnen 7 dagen, Binnen 30 dagen, Later,
  Geen vaste datum en Afgerond, binnen elke kaart op datum.

Elke kaart heeft een witte kop en een mint blok met de acties als witte
kaartjes. Links op elk kaartje staat een smal streepje in de kleur van
wie de actie doet; in de kolom Wie staat een stipje in dezelfde kleur.
Een afgeronde actie is lichtgrijs. Open je een actie om te bewerken of
af te ronden, dan wordt dat kaartje op zijn plek een formulier; de
andere acties blijven staan.

In de kolom Datum staat bij een afgeronde actie de datum waarop hij is
afgerond, en bij een openstaande de geplande datum. Sorteren op datum
gebruikt diezelfde waarde.

Boven de lijst staan de vijf weergaven als tabbladen. Daaronder:

- **Te doen / Afgerond / Alle**;
- **Filter** — klapt een paneel open met *Categoriegroep*, *Label* en
  *Datum*. Staat er een filter aan, dan staat het aantal op de knop en
  verschijnt eronder een label zoals *Label: Leveranciers ×*; met het
  kruisje haal je dat filter weg, met *Filters wissen* alles tegelijk.
  Ook "alleen acties van deze organisatie" vanuit de relatielijst staat
  daar als label;
- rechts de **volgorde** (niet bij Agenda, die staat altijd op datum) en
  bij *Per categorie* **Alles inklappen**.

Filters gelden in alle weergaven. Klik je in een regel op een label, dan
wordt dat het filter. Vanuit de lijst klik je door naar de categorie.

## Wie doet een actie

Bij *Wie* kies je eerst de **organisatie** en daarna **wie** daar de
actie doet. De organisatie staat standaard op de organisatie waarbij
*Dit is onze eigen organisatie* is aangevinkt. De tweede keuzelijst
toont dan:

- **Contactpersonen** van die organisatie, op achternaam;
- **Hele organisatie**, als niet één persoon de actie doet.

Losse namen zoals Sectoren of Allen zijn niet meer te kiezen. Een actie
die er nog een heeft, toont die als *(oude naam)* tot je iemand anders
kiest. Moet iemand een actie krijgen die nog niet in de relatielijst
staat, voeg hem dan eerst als contactpersoon toe.

Elk veld in het formulier heeft een kopje: Actie, Organisatie, Wie,
Datum, Toelichting, Label en (bij bewerken) Categorie. Organisatie, Wie
en Datum staan op een regel, net als Label en Categorie.

Kies je een andere organisatie, dan verschijnen de contactpersonen van
die organisatie. Bij iemand van buiten staat de naam van zijn organisatie
klein onder de naam, zodat je ziet dat het werk buiten de deur ligt.

Er is geen apart veld *Relatie* meer: de organisatie van de actiehouder
is de relatie. Het aantal acties bij een organisatie of persoon in de
relatielijst, en het filter *acties van deze organisatie*, gaan daarom
over de acties waar die organisatie of persoon de actiehouder is.
Relaties die vroeger bij een actie waren ingevuld, zijn in de database
bewaard maar niet meer zichtbaar.

## De relatielijst

Twee weergaven, met een zoekveld dat op beide werkt:

- **Organisaties** — per organisatie een kaart met adres, website en
  toelichting, en daaronder de personen die erbij horen.
- **Personen** — één doorlopende lijst van iedereen, op achternaam
  gesorteerd, met functie, organisatie en contactgegevens.

Een naam bestaat uit voornaam, tussenvoegsel en achternaam, met
daarnaast geslacht (vrouw, man, anders, of leeg). Het veld met de
volledige naam wordt uit die delen samengesteld; sorteren en zoeken gaan
ook op achternaam. In de Excel-export staan de delen én de volledige
naam als aparte kolommen.

Het veld *soort* is een keuzelijst die je zelf beheert: knop **Soorten
beheren** bij Organisaties. Daar voeg je een soort toe, hernoem je er een
(de organisaties die hem gebruiken gaan mee) of verwijder je er een die
nergens meer in gebruik is. De lijst staat in de tabel
`organisatie_soorten`. Staat er iets niet bij, dan kun je bij een
organisatie met *Anders, namelijk…* alsnog zelf iets invullen.

Met de keuzelijst ernaast filter je de organisaties op soort; daar staat
ook *Nog geen soort*, handig om te zien wat nog ingevuld moet worden.

## Wie mag een account aanmaken

Alleen adressen die in de tabel `leden` staan. Dat wordt afgedwongen door
het Supabase-haakje **Authentication → Hooks → Before User Created**, dat
de functie `public.mag_account_aanmaken` aanroept (zie
`database/06-wie-mag-inloggen.sql`). Iemand anders die het probeert,
krijgt te lezen dat zijn adres niet op de lijst staat.

Mensen toevoegen, hun rol wijzigen of ze de toegang ontnemen doe je met
`database/07-leden-beheren.sql`.

## Wie mag wat

| Rol | Lezen | Wijzigen | Toegang van anderen regelen |
|---|---|---|---|
| kijker | ja | nee | nee |
| bewerker | ja | ja | nee |
| beheerder | ja | ja | ja |

Toegang regel je in de tabel `leden`. Staat een e-mailadres daar niet in,
dan levert inloggen een lege lijst op.

## Getest

De toegangsregels zijn niet alleen bedacht maar ook nagemeten, met
`database/toegangsproef.sh` tegen een echte PostgreSQL-database:
een buitenstaander ziet nul regels, een kijker wijzigt nul regels,
een bewerker kan zichzelf geen beheerder maken.

## Waar het draait

| | |
|---|---|
| Publicatie | Vercel, gekoppeld aan deze GitHub-repo |
| Tak die live gaat | `mcn-console` |
| Hoofdmap in Vercel | `lijsten` |
| Database en inlog | Supabase, Europese server |
| Adres | https://stichting-mcn.vercel.app |

Die twee Vercel-instellingen staan onder **Settings → Environments →
Production → Branch Tracking** en **Settings → Build & Deployment →
Root Directory**. Vergeet de hoofdmap niet: zonder die instelling
publiceert Vercel de website uit de hoofdmap van de repo in plaats van
deze applicatie.

De tak `main` blijft van de website: wat daarop komt, gaat via GitHub
Actions naar TransIP. De applicatie staat bewust op een eigen tak, zodat
publiceren van het een het ander niet raakt.

## Na het eerste keer publiceren

Supabase moet weten waar het inloggen op uitkomt, anders loopt de link
uit de mail dood. Zet in Supabase onder **Authentication → URL
Configuration** het adres van Vercel bij **Site URL**, en zet hetzelfde
adres met `/**` erachter bij **Redirect URLs**.
