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

- **Per onderwerp** — kaarten die je open- en dichtklapt, met de voortgang
  per onderwerp.
- **Alle acties** — één doorlopende lijst met kolommen: actie, wie, datum,
  onderwerp en label. Verlopen datums kleuren rood. Klik op de kolomkop
  *Wie*, *Datum* of *Label* om daarop te sorteren; nog een keer klikken
  sorteert andersom, een derde keer zet de gewone volgorde terug. Lege
  waarden staan altijd onderaan.
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
andere acties blijven staan. Zolang er een formulier open staat,
verdwijnt de kopregel met de kolomnamen, en de pagina schuift zo dat de
bovenkant van het formulier boven in beeld staat.

In de kolom Datum staat bij een afgeronde actie de datum waarop hij is
afgerond, en bij een openstaande de geplande datum. Sorteren op datum
gebruikt diezelfde waarde.

Boven de lijst staan de vijf weergaven als tabbladen. Daaronder:

- **Te doen / Afgerond / Alle**;
- **Filter** — klapt een paneel open met *Groep*, *Label* en
  *Datum*. Staat er een filter aan, dan staat het aantal op de knop en
  verschijnt eronder een label zoals *Label: Leveranciers ×*; met het
  kruisje haal je dat filter weg, met *Filters wissen* alles tegelijk.
  Ook "alleen acties van deze organisatie" vanuit de relatielijst staat
  daar als label;
- rechts de **volgorde** (niet bij Agenda, die staat altijd op datum) en
  bij *Per onderwerp* **Alles inklappen**.

Het filterpaneel heeft ook **Wie**: een persoon, een organisatie (met al
haar mensen) of een oude losse naam.

Filters gelden in alle weergaven. Klik je in een regel op een label, dan
wordt dat het filter. Vanuit de lijst klik je door naar het onderwerp.

**Woorden.** Een *actie* is iets wat er moet gebeuren (het woord *taak*
wordt niet meer gebruikt). Acties staan in een *onderwerp* (Bestuurzaken,
Financiën, …). Een *groep* (Bestuur, Projectgroep) is een verzameling
onderwerpen met leden, zoals bij Google Groups: leden zien alleen de
acties van de onderwerpen in hun groepen. In de database heten
onderwerpen nog `categorieen` en groepen `labels` van een categorie.

**Afronden.** Bij het afronden vul je de datum en eventueel commentaar
in. Met *Vervolgactie of besluit toevoegen* komen er velden bij voor een
vervolgactie (met datum; die komt in hetzelfde onderwerp, bij dezelfde
persoon of organisatie en met dezelfde labels) en een besluit. Wat je al
had ingevuld, blijft staan.

De Console opent op **Alle acties**. Met **+ Nieuwe actie** rechts in de
balk voeg je vanuit elke weergave een actie toe; je kiest daar ook de
categorie. Ontbreekt de titel of wie het doet, dan krijgt dat veld een
rood randje. **Alles inklappen / uitklappen** staat bij elke weergave met
groepen.

## Besluiten

Besluiten staan in dezelfde vorm als de acties: een kaart met een blok en
elk besluit als wit kaartje, met de kolommen Besluit, Datum, Categorie en
de actie waar het bij hoort.

## Kleuren

De acties en besluiten gebruiken het groen van de Console, de relaties
het blauw van de N uit het logo (#75C3EA). De donkere versie heet
*antraciet*: neutraal donkergrijs, met hetzelfde groen en blauw als
accent. Ook de keuzelijsten en de datumkiezer van de browser worden dan
donker. De ruimte voor de schuifbalk
wordt altijd vastgehouden, zodat de pagina niet verspringt als je wisselt
tussen een korte en een lange lijst.

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

Een organisatie heeft twee vinkjes: *Aangesloten bij MCN* (zoals de
sectorfederaties) en *Aangesloten als bron* (levert gegevens aan). Ze
staan als labeltje op de kaart, er is een filter *Aansluiting*, en in de
Excel-export staan ze als kolommen. De vinkjes komen er met
`27-aansluiting.sql`, dat de eerste keer FEHAC, FVEN, Historisch
Railvervoer Nederland en de Nationale Federatie Historische Luchtvaart
als aangesloten aanvinkt.

Een persoon heeft een veld *notitie* voor wat niet in de vaste velden
past, zoals een tweede e-mailadres. Het staat klein onder de naam en als
kolom in de Excel-export. Het veld komt er met
`23-organisaties-en-contacten.sql`; daarvoor laat het formulier het weg.

`23-organisaties-en-contacten.sql` vult ook soort en sector aan bij de 44
organisaties die die nog niet hadden, en neemt de contactpersonen uit
`contactpersonen_mail.xlsx` over (28-09-2026). Wie er al is (zelfde
e-mailadres of naam; bij MCN ook zelfde voornaam) wordt aangevuld, niet
dubbel aangemaakt. Algemene adressen (info@, penningmeester@) staan bij
de organisatie.

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

## Instellingen (het tandwieltje)

Rechtsboven, naast de **i**, staat een tandwieltje. Daaronder:

- **Weergave** — voor iedereen: *Automatisch*, *Licht* of *Donker*.
  Automatisch volgt de instelling van de computer of telefoon. De keuze
  wordt op dat apparaat onthouden.
- **Beheer** — alleen voor wie in de tabel `leden` de rol *beheerder*
  heeft. Elke kaart klapt in en uit met de kop; *Alles uitklappen* /
  *Alles inklappen* doet ze allemaal tegelijk.
  - *Gebruikers*: wie mag inloggen, met welke rol (kijker, bewerker,
    beheerder). Toevoegen, naam of rol wijzigen, en toegang intrekken.
    Een nieuwe gebruiker vraagt op het inlogscherm een link aan. Bij
    *Gebruiker toevoegen* kun je iemand kiezen uit de contactpersonen
    van de eigen organisatie; naam en e-mail worden dan overgenomen
    (wie geen e-mailadres heeft of al gebruiker is, staat uitgegrijsd). Het
    e-mailadres is de sleutel en is niet te wijzigen. Je eigen rol en
    je eigen toegang kun je hier niet wijzigen, zodat je jezelf niet
    buitensluit; de database houdt daarnaast altijd minstens één
    beheerder over. Per gebruiker stel je ook de **toegang** in:
    *Acties* (alle groepen, of alleen bijvoorbeeld *Projectgroep*),
    *Besluiten* en *Relaties*. De rol bepaalt of iemand mag wijzigen,
    de toegang wat iemand ziet. Wie de relaties niet ziet, ziet bij
    acties wel de namen van organisaties en personen maar geen adres,
    e-mail of telefoon. Een onderwerp zonder groep is alleen zichtbaar
    voor wie alle groepen ziet. Een beheerder ziet altijd alles;
  - *Groepen*: zoals Google Groups. Per groep de onderwerpen en de leden.
    Leden toevoegen met *+ Lid toevoegen…*, weghalen met het kruisje.
    Wie "alle groepen" heeft, zit automatisch in elke groep, ook in
    nieuwe; haal je zo iemand uit één groep, dan houdt hij de andere.
    Een groep aanmaken, hernoemen (onderwerpen en leden gaan mee; een
    bestaande naam voegt samen) of opheffen. Een groep bestaat zolang er
    een onderwerp in zit. Wie door een wijziging in geen enkele groep
    meer zit, ziet geen acties meer; daar vraagt de Console eerst naar;
  - *Onderwerpen*: naam, volgnummer en groepen. Toevoegen, en
    verwijderen als er geen acties meer in staan. Dit gebeurt alleen nog
    hier, niet meer in de actielijst;
  - *Soorten organisaties* en *Sectoren*: toevoegen, hernoemen (de
    organisaties gaan mee) en verwijderen als er geen organisatie meer
    bij hoort;
  - *Labels bij acties*: elk label met het aantal acties. Hernoemen past
    alle acties aan; hernoem je naar een bestaand label, dan worden ze
    samengevoegd. Verwijderen haalt het label bij alle acties weg; de
    acties zelf blijven staan;
  - *Huisstijl*: de kleuren van de lichte en de donkere versie naast
    elkaar, met een klein voorbeeld, de kleurcodes en de kleuren uit het
    logo. Met *Kleuren aanpassen* kies je per versie zeven kleuren
    (achtergrond, blok acties, blok relaties, kaartje, tekst, accent
    acties, accent relaties) met een kleurkiezer of een kleurcode. Het
    voorbeeld en de Console kleuren direct mee, eerst alleen bij jou;
    *Opslaan voor iedereen* legt ze vast in de tabel `instellingen` (na
    `22-instellingen-huisstijl.sql`). Zachtere tinten, zoals de vulling
    achter een accent, rekent de Console zelf uit. Met *Terug naar de
    standaardkleuren* haal je alles weg.

  - *Logboek*: wie wat heeft gewijzigd, en wanneer, nieuwste bovenaan,
    te filteren op persoon en op soort (acties, besluiten, relaties,
    beheer, bezoeken). De database schrijft het zelf bij via
    `26-logboek.sql`: elke toevoeging, wijziging en verwijdering in de
    Console-tabellen, met per gewijzigd veld de oude en nieuwe waarde,
    en bij een verwijdering de hele regel. Openen van de Console komt er
    hooguit één keer per uur per persoon in. Alleen de beheerder kan
    het lezen; niemand kan het aanpassen. Bij *Gebruikers* staat per
    persoon wanneer die de Console voor het laatst opende (*gezien*) en
    voor het laatst inlogde (*ingelogd*);
  - *Backup*: alle tabellen (acties, besluiten, onderwerpen,
    organisaties, personen, soorten, sectoren, gebruikers, instellingen)
    vers uit de database in één bestand. *Downloaden (.json)* is de
    volledige backup waarmee alles terug te zetten is; *Downloaden
    (.xlsx)* is dezelfde inhoud als Excel om in te kijken, met een
    tabblad per tabel. De kop toont de datum van de laatste backup op
    dit apparaat. Terugzetten gaat niet vanuit de Console: vraag dat
    aan wie de database beheert.

Een bewerker of kijker ziet alleen *Weergave*. De Console laat hen ook
buiten het scherm om geen gebruikers, soorten, sectoren of labels
beheren, en na `20-beheer-alleen-beheerder.sql` weigert de database het
wijzigen van soorten, sectoren en gebruikers ook voor iedereen die geen
beheerder is. Labels horen bij de acties zelf; die blijft een bewerker
bij een actie invullen.

## Versies

Rechtsboven in de Console staat een **i**. Wijs je die aan (of tik je
erop), dan zie je het versienummer. Bij elke nieuwe publicatie gaat het
nummer omhoog: in `index.html` bij het commentaar *Versienummer*, en met
een regel hieronder.

| Versie | Datum | Wat |
|---|---|---|
| 1.0 | 23-09-2026 | Eerste publicatie: acties, besluiten en relaties, inloggen met een link per e-mail. |
| 1.1 | 25-09-2026 | Naam in voornaam, tussenvoegsel en achternaam, met geslacht; acties gekoppeld aan de eigen mensen. |
| 1.2 | 25-09-2026 | Rustiger actielijst: witte kaartjes op een mint blok, stipje bij Wie, gedempte labels. |
| 1.3 | 25-09-2026 | Weergaven Per persoon, Per organisatie en Agenda; een geopende actie blijft een wit kaartje. |
| 1.4 | 25-09-2026 | Wie is organisatie plus contactpersoon; het veld Relatie en de losse namen vervallen; formulier met kopjes. |
| 1.5 | 25-09-2026 | Filterbalk met knop Filter en labels; Nieuwe actie vanuit elke weergave; filter op Wie; besluiten en relaties in kaartstijl, relaties in het blauw van het logo; formulieren voor organisatie en contactpersoon met kopjes; versieknopje. |
| 1.6 | 25-09-2026 | Tandwieltje met instellingen: licht, donker of automatisch voor iedereen; beheer van soorten, sectoren en actielabels voor de beheerder. |
| 1.7 | 25-09-2026 | Gebruikers beheren onder het tandwieltje; beheerkaarten in- en uitklapbaar; soorten, sectoren en gebruikers ook in de database alleen door de beheerder te wijzigen. |
| 1.8 | 25-09-2026 | Rechten per gebruiker (acties per groep, besluiten, relaties), ook in de database; categorieën beheren onder het tandwieltje. |
| 1.9 | 25-09-2026 | Bij wijzigen verdwijnt de kopregel en schuift het formulier boven in beeld. |
| 1.10 | 25-09-2026 | Donkere versie antraciet; kaart Huisstijl onder het beheer; bij een nieuwe gebruiker kiezen uit de contactpersonen van MCN. |
| 1.11 | 25-09-2026 | Huisstijl instelbaar door de beheerder: zeven kleuren per versie, licht en donker, voor iedereen. |
| 1.12 | 28-09-2026 | Backup van alle gegevens onder het tandwieltje (.json en .xlsx); notitieveld bij personen; SQL 23 met soort en sector voor 44 organisaties en de contactpersonen uit de mail. |
| 1.13 | 28-09-2026 | Logboek onder het tandwieltje (wie wijzigde wat, en bezoeken); bij Gebruikers laatst gezien en laatst ingelogd; bij organisaties *Aangesloten bij MCN* en *Aangesloten als bron*, met filter. Database: `26-logboek.sql`, `27-aansluiting.sql`. |
| 1.14 | 01-10-2026 | *Categorie* heet nu *onderwerp* en *categoriegroep* *groep*; nieuwe kaart *Groepen* (zoals Google Groups) met onderwerpen en leden; sorteren door op de kolomkop Wie, Datum of Label te klikken; afronden: commentaar blijft staan bij *Vervolgactie of besluit toevoegen*, vervolgactie met datum en bij dezelfde persoon; overal *actie* in plaats van *taak*. |
