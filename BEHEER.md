# Beheerhandleiding website Stichting Mobiele Collectie Nederland

Overdrachtsdocument voor de website **www.stichtingmcn.nl**. Stand van zaken: 13 september 2026. Wie de site overneemt en nog niets geïnstalleerd heeft, begint bij **§4.1**.

---

## 1. In één oogopslag

- De site is een **statische website**: twee bestanden (`index.html` en `nieuws.js`) plus de mappen `fotos/` en `documenten/`. Er is geen CMS, geen database, geen build-stap en geen serverlogica.
- De broncode staat op **GitHub** in de openbare repository [`mkreuze/stichtingMCN`](https://github.com/mkreuze/stichtingMCN).
- De site draait bij **TransIP** (webhosting, domeinnaam, DNS en e-mail).
- **Een wijziging live zetten = een commit op de branch `main` pushen.** Een GitHub Action kopieert de bestanden dan automatisch via SFTP naar TransIP. Binnen een minuut staat de wijziging online.
- Het collectieplatform **mobielecollectie.nl** is een apart systeem en maakt géén deel uit van deze website; de site linkt er alleen naar.

```
  bewerken (lokaal)  ──►  git commit + push naar main  ──►  GitHub Action "Deploy naar TransIP"
                                                                   │  lftp mirror via SFTP
                                                                   ▼
                                                     TransIP webhosting (nginx)  ──►  www.stichtingmcn.nl
```

---

## 2. Systemen en accounts

| Systeem | Waarvoor | Details | Toegang overdragen |
|---|---|---|---|
| **GitHub** – repo `mkreuze/stichtingMCN` | Broncode, versiegeschiedenis, automatische deploy | Openbaar (public). Standaardbranch `main`. Eigenaar: persoonlijk account `mkreuze`. | Repo overdragen aan een GitHub-organisatie van MCN, of nieuwe beheerder als *collaborator* toevoegen (Settings → Collaborators). |
| **GitHub Actions** | Deploy bij elke push naar `main` | Workflow: `.github/workflows/deploy.yml`. Gebruikt 4 *secrets*: `SFTP_HOST`, `SFTP_USERNAME`, `SFTP_PASSWORD`, `SFTP_TARGET_DIR`. | Secrets staan in Settings → Secrets and variables → Actions. Waarden zijn niet uit te lezen; noteer ze in de wachtwoordkluis van MCN. **Wijzig het SFTP-wachtwoord na overdracht** en werk het secret bij. |
| **TransIP** – webhosting | Serveert de website | nginx, IP `85.10.159.122`. Bestanden staan in de map uit `SFTP_TARGET_DIR`. | TransIP-account (contract, facturatie, SFTP-gebruiker). |
| **TransIP** – domeinen & DNS | `stichtingmcn.nl` en `mobiel-erfgoed.nl` | Beide met nameservers `ns0.transip.net`, `ns1.transip.nl`, `ns2.transip.eu`. `mobiel-erfgoed.nl` is het domein van de oude website en stuurt álle adressen door naar de homepage van `www.stichtingmcn.nl`. | Zelfde TransIP-account; let op verlengdatums. |
| **Andere hoster** (nameservers `dhs12.nl`) | `mobielecollectienederland.nl` | Stuurt door naar `mobiel-erfgoed.nl` → `www.stichtingmcn.nl`. Onder `/nrme/` staat nog een oude NRME-pagina. | Navragen bij wie dit domein geregistreerd is. |
| **TransIP** – e-mail | MX van `stichtingmcn.nl` | `mx.transip.email` | Zelfde TransIP-account. |
| **Google Fonts** | Lettertypen Nunito en Nunito Sans | Extern ingeladen vanaf `fonts.googleapis.com`. Geen account nodig. | – |
| **mobielecollectie.nl** | Het collectieplatform (apart systeem, ander IP) | Alleen gelinkt vanuit de site. Het contactadres op de site is `secretaris@mobielecollectie.nl` – dat valt onder dít domein, niet onder TransIP-hosting van de website. | Apart overdragen / navragen wie dit beheert. |
| **Lokale werkmap** | Bewerken op de computer | Nu: `OneDrive\Bureaublad\MCN\mobiel-erfgoed-site` (git-checkout). | Nieuwe beheerder zet een eigen werkmap op volgens §4.1. |

Er zijn **geen** analytics, cookies, formulieren of andere externe diensten.

---

## 3. Hoe de site technisch in elkaar zit

### 3.1 Bestanden

| Bestand / map | Inhoud | Wordt gedeployd? |
|---|---|---|
| `index.html` | De hele site: alle CSS (in `<style>`), navigatie, alle vaste pagina's, footer en het JavaScript voor de navigatie. Het logo (boven en in de footer) zit als ingebakken afbeelding (base64) in het bestand; alle andere afbeeldingen komen uit `fotos/`. | Ja |
| `nieuws.js` | De volledige tekst van alle nieuwsartikelen, als één HTML-tekst in `window.MCN_ARTICLES_HTML`. | Ja |
| `fotos/` | Foto's bij nieuwsberichten; `fotos/partners/` bevat de partnerlogo's. | Ja |
| `documenten/` | PDF's waar artikelen naar linken (brief aan de Kamercommissie OCW, rapport *Mobile heritage in Europe*). | Ja |
| `BEHEER.md` | Deze handleiding. | Nee |
| `CLAUDE.md` | Werkafspraken voor Claude (AI-assistent): wordt automatisch gelezen als je in deze map met Claude werkt, met welk account ook. | Nee |
| `tools/preview-server.js` | Kleine lokale testserver: `node tools/preview-server.js . 8001` en open `http://localhost:8001`. Alleen nodig als dubbelklikken op `index.html` niet volstaat. | Nee |
| `.github/workflows/deploy.yml` | De automatische deploy. | Nee |
| `.gitignore` | Sluit `.claude/`, `.tmp_*`, editor- en OS-bestanden uit. | Nee |

> Let op: de workflow kopieert **alleen** `index.html`, `nieuws.js`, `fotos/` en `documenten/`. Voeg je een nieuw bestand of nieuwe map toe op het hoogste niveau (bijv. `favicon.ico`), dan moet je die ook in `deploy.yml` bij de stap *Voorbereiden upload-map* toevoegen.

### 3.2 Paginasysteem (één pagina, meerdere "schermen")

De site is technisch één HTML-pagina. Elke "pagina" is een blok `<div id="page-NAAM" class="page">`. Alleen het blok met de klasse `active` is zichtbaar.

- Klikken op een menu-item roept `showPage('NAAM')` aan. Die functie verbergt alle blokken, toont `page-NAAM`, scrolt naar boven en zet `#NAAM` in de adresbalk.
- Daardoor werken de terugknop van de browser en directe links, bijv. `https://www.stichtingmcn.nl/#partners` of `#kamer`.
- Bij het laden zet het script de inhoud van `nieuws.js` in `<div id="articles-container">`, zodat ook de artikelen als `page-…`-blok beschikbaar zijn.
- `showArticle('x')` doet hetzelfde als `showPage('x')`.

**Vaste pagina's (in `index.html`)**

| Hash | Pagina |
|---|---|
| `#home` | Home: intro, "Uitgelicht", 5 nieuwskaarten, zijbalk, groene band |
| `#nieuws` | Overzicht van alle nieuwsartikelen |
| `#sectoren` | Rail, weg, water, lucht |
| `#partners` | 9 partners met logo, link en beschrijving |
| `#over` | Over MCN (missie, visie, activiteiten, geschiedenis, bestuur, ANBI) |
| `#contact` | E-mail, KVK, RSIN, ANBI-status |

**Nieuwsartikelen (in `nieuws.js`)**

`nieuwplatform`, `kamer`, `jubileum`, `erfgoedbeoefening`, `varend`, `restauratie`, `inbreng`, `europe`, `platform`, `klimaat`, `jaarverslag`, `halveeeeuw`.

### 3.3 Opmaak

- Kleuren en lettertypen staan als variabelen bovenaan de `<style>` in `index.html` (`--green`, `--pink`, `--blue`, `--ink`, …). Eén waarde aanpassen werkt door in de hele site.
- Labels bij berichten: `tag-g` (groen), `tag-p` (roze), `tag-b` (blauw), `tag-gray` (grijs).
- Responsief: onder 900px vallen kolommen samen en verdwijnt de zijbalk; onder 768px verschijnt het hamburgermenu; onder 600px staat alles in één kolom.
- Partnerlogo's hebben een reserve: laadt een logo niet, dan verschijnt de naam in tekst.

---

## 4. Hoe een wijziging (mutatie) werkt

### 4.1 Starten vanaf nul: nieuwe beheerder zonder software

Voor wie nog niets geïnstalleerd heeft. Reken op ongeveer een uur. Alles is gratis en werkt op Windows en Mac. Je hoeft niet te kunnen programmeren: de werkwijze hieronder gebruikt knoppen in plaats van opdrachtregels. Wel helpt het als je een beetje HTML kunt lezen (tags als `<p>` en `<a>`).

**Stap 1 – Accounts regelen (nog niets installeren)**

1. Maak een gratis account aan op [github.com](https://github.com/signup), bij voorkeur met een MCN-mailadres. GitHub vraagt je tweestapsverificatie aan te zetten; doe dat.
2. Geef je GitHub-gebruikersnaam door aan de huidige beheerder. Die nodigt je uit via de repo → *Settings* → *Collaborators* → *Add people*.
3. Accepteer de uitnodiging uit de e-mail van GitHub. Je ziet de repo nu op [github.com/mkreuze/stichtingMCN](https://github.com/mkreuze/stichtingMCN).
4. Alleen als je ook hosting, domeinen of e-mail gaat beheren: vraag toegang tot het TransIP-account. Voor het bijwerken van de site is dat niet nodig.

> **Alleen een tikfout herstellen?** Dat kan zonder installatie. Open het bestand op github.com (bijv. `index.html`), klik op het potlood-icoon (*Edit this file*), pas de tekst aan en klik op *Commit changes*. Let op: de wijziging staat dan binnen een minuut live, zónder dat je hem eerst hebt kunnen bekijken. Voor alles wat groter is dan een woord: volg de stappen hieronder.

**Stap 2 – Software installeren**

| Programma | Waarvoor | Downloaden |
|---|---|---|
| **GitHub Desktop** | De site ophalen, wijzigingen vastleggen en publiceren, met knoppen. Bevat zelf Git; dat hoef je niet apart te installeren. | [desktop.github.com](https://desktop.github.com) |
| **Visual Studio Code** | De bestanden bewerken (overzichtelijke kleuren, zoeken en vervangen). | [code.visualstudio.com](https://code.visualstudio.com) |
| Een webbrowser | De site controleren. | Meestal al aanwezig |

Alleen nodig in bijzondere gevallen:

| Programma | Wanneer | Downloaden |
|---|---|---|
| WinSCP (Windows) of Cyberduck (Mac) | Handmatig bestanden op de TransIP-server bekijken of verwijderen (zie §4.4). | [winscp.net](https://winscp.net) · [cyberduck.io](https://cyberduck.io) |
| Git for Windows | Als je liever met de opdrachtregel werkt. | [git-scm.com](https://git-scm.com) |

**Stap 3 – Eenmalig instellen**

1. Open **GitHub Desktop** en kies *Sign in to GitHub.com*. Je browser opent; log in en geef toestemming.
2. Vul bij *Configure Git* je naam en e-mailadres in. Die komen bij elke wijziging te staan, zodat later te zien is wie wat heeft gedaan.
3. Kies *File* → *Clone repository* → tabblad *GitHub.com* → `mkreuze/stichtingMCN`.
4. Kies bij *Local path* een map die **niet** door OneDrive, Dropbox of iCloud wordt gesynchroniseerd, bijvoorbeeld `C:\Websites\stichtingMCN`. Synchronisatieprogramma's kunnen Git-mappen verstoren. Klik op *Clone*.
5. Stel de editor in: *File* → *Options* (Mac: *GitHub Desktop* → *Settings*) → *Integrations* → *External editor*: **Visual Studio Code**.
6. **Heb je op deze computer meer dan één GitHub-account** (bijvoorbeeld een zakelijk en een privé-account)? Leg dan vast welk account bij deze website hoort, anders vraagt Git steeds opnieuw welk account het moet gebruiken. Open in GitHub Desktop *Repository* → *Open in Command Prompt* (of Git Bash in de websitemap) en voer uit, met jouw GitHub-gebruikersnaam:
   ```bash
   git config credential.username jouw-gebruikersnaam
   ```
   Controleren: `git config --get credential.username` toont de naam. Welke accounts Windows heeft opgeslagen, zie je met `git credential-manager github list`.

**Stap 4 – Proefwijziging (controleert of alles werkt)**

1. Klik in GitHub Desktop bovenin op *Fetch origin* (en daarna *Pull origin* als die knop verschijnt). Controleer dat *Current branch* op **main** staat.
2. Klik op *Open in Visual Studio Code*. Open `BEHEER.md` en voeg onderaan bij §7 *Beheerlog* een regel toe met de datum en je naam. Sla op (Ctrl+S / Cmd+S).
3. Ga terug naar GitHub Desktop. Links zie je `BEHEER.md` met je wijziging.
4. Typ linksonder bij *Summary* een korte omschrijving, bijvoorbeeld `Beheerlog: nieuwe beheerder`, en klik op **Commit to main**.
5. Klik bovenin op **Push origin**.
6. Ga op github.com naar de repo → tabblad *Actions*. De bovenste run *Deploy naar TransIP* wordt binnen een minuut groen. Is hij groen, dan werkt alles.

`BEHEER.md` komt zelf niet op de website, dus deze proef verandert niets voor bezoekers.

### 4.2 Standaardwerkwijze

1. **Bijwerken:** GitHub Desktop → *Fetch origin* / *Pull origin*. Zo begin je altijd met de nieuwste versie.
2. **Bewerken:** *Open in Visual Studio Code* en pas `index.html` en/of `nieuws.js` aan. Sla op.
3. **Lokaal controleren:** dubbelklik in de Verkenner (Mac: Finder) op `index.html`. De site opent in je browser, zonder webserver. Bekijk ook het mobiele formaat door het browservenster smal te maken.
4. **Vastleggen en publiceren:** GitHub Desktop → *Summary* invullen → **Commit to main** → **Push origin**.
5. **Controleren:** github.com → *Actions*: run *Deploy naar TransIP* moet groen worden (< 1 minuut). Ververs daarna www.stichtingmcn.nl, eventueel met Ctrl+F5.

Werk je liever met de opdrachtregel (Git for Windows), dan zijn stap 1 en 4:

```bash
git pull
git add -A
git commit -m "Korte beschrijving van de wijziging"
git push origin main
```

Wie grotere wijzigingen eerst wil laten beoordelen, werkt op een aparte branch (GitHub Desktop: *Current branch* → *New branch*) en maakt een pull request; pas bij samenvoegen in `main` gaat het live.

### 4.3 Veelvoorkomende mutaties

**Tekst wijzigen op een vaste pagina**
Zoek in `index.html` naar de tekst (Ctrl+F) en pas die aan. Speciale tekens mogen als gewoon teken (é, ë, ’) of als HTML-code (`&eacute;`, `&euml;`, `&rsquo;`); beide werken.

**Nieuwsbericht toevoegen** – drie plekken:
1. **Het artikel zelf** in `nieuws.js`: kopieer een bestaand blok van `<div id="page-…" class="page">` tot en met de afsluitende `</div></div>` en plak het binnen de backticks (`` ` ``). Geef het een unieke, korte id zonder spaties, bijv. `page-congres2026`.
   *Let op:* gebruik in de tekst geen backtick (`` ` ``) en geen `${`; dat breekt het JavaScript-bestand en dan verdwijnen álle artikelen.
2. **De overzichtspagina** in `index.html`, onder `<div id="page-nieuws">`: kopieer een `<article class="list-article">`-blok, zet het bovenaan en laat de knop `showArticle('congres2026')` aanroepen.
3. **De homepage** (optioneel) in `index.html`, onder `<div class="news-grid">`: kopieer een `news-card` en verwijder eventueel de oudste kaart. Wil je het bericht als *Uitgelicht* tonen, pas dan het blok `featured-grid` aan.
4. Foto in `fotos/` zetten (zie hieronder).


**Foto toevoegen**
Zet de foto in `fotos/`. Gebruik bij voorkeur een bestandsnaam zonder spaties (anders `%20` in de code), JPG, maximaal ca. 1600px breed en liefst onder 300 KB. Verwijs ernaar met `src="fotos/bestandsnaam.jpg"` en vul altijd een `alt`-tekst in.

**Document (PDF) toevoegen**
Zet de PDF in `documenten/`, met een bestandsnaam zonder spaties (bijv. `Jaarverslag-MCN-2025.pdf`). Link ernaar met `<a href="documenten/Jaarverslag-MCN-2025.pdf" target="_blank">Download jaarverslag (PDF)</a>`.

**Partner toevoegen of verwijderen**
In `index.html` onder `<div id="page-partners">`: kopieer of verwijder een `<a … class="news-card">`-blok. Logo in `fotos/partners/` (SVG of PNG met transparante achtergrond werkt het best).

**Menu-item toevoegen**
Nieuwe pagina als `<div id="page-NAAM" class="page">` toevoegen, en in `<ul class="nav-links">` én in de footer een link met `onclick="showPage('NAAM')"` zetten.

**Wijziging terugdraaien**
GitHub Desktop → tabblad *History* → rechtsklik op de wijziging → *Revert changes in commit* → **Push origin**. Via de opdrachtregel:
```bash
git log --oneline
git revert <commit-code>
git push origin main
```
De vorige versie staat daarna binnen een minuut weer live.

**Handmatig opnieuw deployen** (bijv. na wijzigen van het SFTP-wachtwoord)
GitHub → *Actions* → *Deploy naar TransIP* → *Run workflow*.

### 4.4 Wat de deploy wél en níet doet

- `lftp mirror -R` uploadt nieuwe en gewijzigde bestanden naar TransIP.
- **Verwijderde bestanden blijven op de server staan** (er wordt zonder `--delete` gespiegeld). Een foto die je uit de repo haalt, is dus nog steeds via de directe URL bereikbaar. Verwijder die zo nodig handmatig via SFTP (WinSCP/Cyberduck), of voeg in `deploy.yml` na de `mirror`-regel eenmalig `cd $SFTP_TARGET_DIR` en `rm -f bestandsnaam` toe, publiceer, en haal die regels daarna weer weg (zo is in september 2026 `nieuws.html` opgeruimd).
- Mislukt de deploy (rood in *Actions*), dan blijft de vorige versie gewoon online. Meest voorkomende oorzaak: gewijzigd SFTP-wachtwoord of verlopen hostingpakket.
- **Pushen blijft hangen of vraagt steeds om in te loggen?** Dan komt de wijziging niet eens bij GitHub aan. Meestal staan er meerdere GitHub-accounts op de computer en weet Git niet welk het moet gebruiken; zie §4.1, stap 3.6.

---

## 5. Checklist overdracht

- [ ] Nieuwe beheerder heeft schrijfrechten op GitHub (of repo is overgedragen aan een MCN-organisatie).
- [ ] Nieuwe beheerder heeft toegang tot het TransIP-account (hosting, domeinen `stichtingmcn.nl` en `mobiel-erfgoed.nl`, e-mail).
- [ ] Duidelijk bij wie `mobielecollectienederland.nl` geregistreerd is (niet bij TransIP).
- [ ] SFTP-gegevens staan in de wachtwoordkluis van MCN; wachtwoord gewijzigd en GitHub-secret `SFTP_PASSWORD` bijgewerkt.
- [ ] Nieuwe beheerder heeft §4.1 doorlopen: software geïnstalleerd, repo gekloond, proefwijziging gepusht en de deploy was groen.
- [ ] Afgesproken wie het domein en de mailbox van `mobielecollectie.nl` beheert (contactadres op de site).
- [ ] Verlengdatums domeinen en hostingcontract genoteerd.
- [ ] Oud beheerder verwijderd als collaborator / uit TransIP, zodra de overdracht rond is.

---

## 6. Bekende aandachtspunten

In volgorde van belang. Geen van deze punten verhindert het dagelijks beheer.

1. **ANBI-publicatieplicht nagaan.** Als (culturele) ANBI moet MCN op internet o.a. bestuurssamenstelling, beleidsplan, beloningsbeleid, een actueel activiteitenverslag en de financiële verantwoording publiceren. De site noemt RSIN, beloningsbeleid en ANBI-status, maar bijvoorbeeld geen bestuursleden, beleidsplan of jaarcijfers.
2. **Nieuws staat op twee à drie plekken** (artikel, overzicht, homepagekaart) die met de hand gelijk moeten blijven. Makkelijk om er één te vergeten.
3. **Vindbaarheid (SEO) en details:** geen `meta description`, geen favicon, artikelen hebben geen eigen URL die zoekmachines indexeren (alleen `#…`), nieuwsberichten tonen geen datum, jaartal in de footer (`© 2026`) staat vast in de code, en de knop "Terug naar nieuws" gaat naar Home.
4. **Deploy-beveiliging:** SFTP met wachtwoord, en de controle van de server-sleutel is uitgeschakeld (`StrictHostKeyChecking=no`). Werkt, maar een SSH-sleutel en een vaste host key zijn veiliger.
5. **Commitbericht `b0b3938`** noemt "standpunten & lobby, agenda, datums op nieuwskaarten", maar bevat alleen de wijziging "platform" → "platforms" (die daarna weer is teruggedraaid). Die onderdelen zijn dus níet gebouwd.

---

## 7. Mobiel Erfgoed Console

Dit staat **los van de website**. De site blijft statische HTML op TransIP;
de Console is een aparte applicatie met een eigen database en een eigen inlog.
Ze delen alleen de GitHub-repo.

| Wat | Waar |
|---|---|
| De pagina | `lijsten/index.html`, één bestand, geen bouwstap |
| Database en inlog | Supabase, Europese server (Frankfurt) |
| Publicatie | Vercel, vanaf de tak `mcn-console`, hoofdmap `lijsten` |
| Adres | https://stichting-mcn.vercel.app |

**Wat erin zit:** acties per categorie met labels en datums, een aparte
besluitenlijst, en een relatielijst met organisaties en de personen die
erbij horen. Een actie kan aan een organisatie en/of persoon gekoppeld
worden. Er is een PDF-download.

**Wie erbij mag** staat in de tabel `leden` in Supabase — dat is de enige
lijst die telt. Wie er niet in staat kan niet eens een account aanmaken.
Drie rollen: `kijker` (alleen lezen), `bewerker` (lezen en wijzigen),
`beheerder` (bepaalt ook wie toegang heeft). Iemand toevoegen of
verwijderen doe je met `lijsten/database/07-leden-beheren.sql` in de
SQL Editor van Supabase.

**Opnieuw opbouwen** kan met de bestanden in `lijsten/database/`, op
nummer. Die documentatie staat in `lijsten/README.md`.

**Let op bij de SQL Editor van Supabase:** die knipt een script in stukken
bij elke puntkomma en struikelt over meerregelige functies met `$$`.
Alle bestanden zijn daarom geschreven als korte losse opdrachten. Houd dat
zo als er iets bij komt. Controleer na het plakken altijd of alles is
meegekomen — een te lange plak wordt stilzwijgend afgekapt.

**Herkomst:** de lijst draaide eerst als Claude-artifact. Die is overgezet
met behoud van alle kenmerken, dus de koppeling tussen een besluit en de
actie waar het uit voortkwam is intact.

---

## 8. Beheerlog

| Datum | Wie | Wat |
|---|---|---|
| 13-09-2026 | Marinus Kreuze | Handleiding opgesteld; opruimronde (dubbele bestanden, GitHub Pages uit, PDF's teruggezet in `documenten/`). |
| 14-09-2026 | Marinus Kreuze | `CLAUDE.md` en `tools/preview-server.js` toegevoegd; pushen hing door twee GitHub-accounts op één computer, opgelost met `credential.username`. |
| 22-09-2026 | Marinus Kreuze | Mobiel Erfgoed Console opgezet: eigen Supabase-database (Frankfurt) met toegangsregels per rol, en de actie- en besluitenlijst overgezet uit het Claude-artifact (6 categorieën, 41 acties, 1 besluit). Relatielijst met organisaties en personen toegevoegd. |
| 23-09-2026 | Marinus Kreuze | Console gepubliceerd op Vercel vanaf de tak `mcn-console`. Aanmelden beperkt tot adressen in de tabel `leden` via het Supabase-haakje *Before User Created*. |
| 25-09-2026 | Marinus Kreuze | Console: naam van een persoon gesplitst in voornaam, tussenvoegsel en achternaam, met geslacht erbij. Actiehouders gekoppeld aan de personen van de eigen organisatie. Actielijst rustiger gemaakt: gekleurde pillen bij *Wie* en *Label* vervangen door een stipje en gedempte tekst, en afgeronde acties krijgen een eigen vulling. De groenige grijstinten zijn behouden. |
