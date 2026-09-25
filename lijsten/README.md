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

Twee weergaven:

- **Per categorie** — kaarten die je open- en dichtklapt, met de voortgang
  per categorie.
- **Alle acties** — één doorlopende lijst met kolommen: actie, wie, datum,
  categorie, label en relatie. Verlopen datums kleuren rood.

Een uitgeklapte categorie gebruikt dezelfde tabel, zonder de kolom
Categorie. Elke actie is een eigen kaartje met links een smal streepje
in de kleur van wie de actie doet, zodat je in één oogopslag ziet van
wie iets is.

In de kolom Datum staat bij een afgeronde actie de datum waarop hij is
afgerond, en bij een openstaande de geplande datum. Sorteren op datum
gebruikt diezelfde waarde.

De filters bovenin werken in beide weergaven. Vanuit de lijst klik je door
naar de categorie of naar de relatie.

## De relatielijst

Twee weergaven, met een zoekveld dat op beide werkt:

- **Organisaties** — per organisatie een kaart met adres, website en
  toelichting, en daaronder de personen die erbij horen.
- **Personen** — één doorlopende lijst van iedereen, met functie,
  organisatie en contactgegevens.

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
