# Beheerhandleiding website Stichting Mobiele Collectie Nederland

Overdrachtsdocument voor de website **www.stichtingmcn.nl**. Stand van zaken: 13 september 2026 (laatste wijziging live: 2 juli 2026, commit `a8a4f56`).

---

## 1. In één oogopslag

- De site is een **statische website**: twee bestanden (`index.html` en `nieuws.js`) plus een map `fotos/`. Er is geen CMS, geen database, geen build-stap en geen serverlogica.
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
| **Lokale werkmap** | Bewerken op de computer | Nu: `OneDrive\Bureaublad\MCN\mobiel-erfgoed-site` (git-checkout). | Nieuwe beheerder doet zelf `git clone https://github.com/mkreuze/stichtingMCN.git`. |

Er zijn **geen** analytics, cookies, formulieren of andere externe diensten.

---

## 3. Hoe de site technisch in elkaar zit

### 3.1 Bestanden

| Bestand / map | Inhoud | Wordt gedeployd? |
|---|---|---|
| `index.html` | De hele site: alle CSS (in `<style>`), navigatie, alle vaste pagina's, footer en het JavaScript voor de navigatie. Het logo (boven en in de footer) zit als ingebakken afbeelding (base64) in het bestand; alle andere afbeeldingen komen uit `fotos/`. | Ja |
| `nieuws.js` | De volledige tekst van alle nieuwsartikelen, als één HTML-tekst in `window.MCN_ARTICLES_HTML`. | Ja |
| `fotos/` | Foto's bij nieuwsberichten; `fotos/partners/` bevat de partnerlogo's. | Ja |
| `.github/workflows/deploy.yml` | De automatische deploy. | Nee |
| `.gitignore` | Sluit `.claude/`, `.tmp_*`, editor- en OS-bestanden uit. | Nee |

> Let op: de workflow kopieert **alleen** `index.html`, `nieuws.js` en `fotos/`. Voeg je een nieuw bestand of nieuwe map toe op het hoogste niveau (bijv. `favicon.ico`, `documenten/`), dan moet je die ook in `deploy.yml` bij de stap *Voorbereiden upload-map* toevoegen.

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

### 4.1 Eenmalige voorbereiding

1. GitHub-account met schrijfrechten op de repo.
2. Git geïnstalleerd (Windows: *Git for Windows*; of GitHub Desktop als je liever niet met de opdrachtregel werkt).
3. Repo ophalen:
   ```bash
   git clone https://github.com/mkreuze/stichtingMCN.git
   ```
4. Een teksteditor, bij voorkeur VS Code.

### 4.2 Standaardwerkwijze

1. **Bijwerken:** `git pull` (zodat je met de laatste versie begint).
2. **Bewerken** van `index.html` en/of `nieuws.js`.
3. **Lokaal controleren:** dubbelklik op `index.html`; de site werkt direct in de browser, zonder webserver. Controleer ook op mobiel formaat (browser smal maken).
4. **Vastleggen en publiceren:**
   ```bash
   git add -A
   git commit -m "Korte beschrijving van de wijziging"
   git push origin main
   ```
5. **Controleren:** op GitHub → tabblad *Actions* moet de run *Deploy naar TransIP* groen worden (duurt < 1 minuut). Ververs daarna www.stichtingmcn.nl (eventueel met Ctrl+F5).

Wie grotere wijzigingen eerst wil laten beoordelen, werkt op een aparte branch en maakt een pull request; pas bij samenvoegen in `main` gaat het live.

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

**Partner toevoegen of verwijderen**
In `index.html` onder `<div id="page-partners">`: kopieer of verwijder een `<a … class="news-card">`-blok. Logo in `fotos/partners/` (SVG of PNG met transparante achtergrond werkt het best).

**Menu-item toevoegen**
Nieuwe pagina als `<div id="page-NAAM" class="page">` toevoegen, en in `<ul class="nav-links">` én in de footer een link met `onclick="showPage('NAAM')"` zetten.

**Wijziging terugdraaien**
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
- **Verwijderde bestanden blijven op de server staan** (er wordt zonder `--delete` gespiegeld). Een foto die je uit de repo haalt, is dus nog steeds via de directe URL bereikbaar; verwijder die zo nodig handmatig via SFTP of de TransIP-bestandsbeheerder.
- Mislukt de deploy (rood in *Actions*), dan blijft de vorige versie gewoon online. Meest voorkomende oorzaak: gewijzigd SFTP-wachtwoord of verlopen hostingpakket.

---

## 5. Checklist overdracht

- [ ] Nieuwe beheerder heeft schrijfrechten op GitHub (of repo is overgedragen aan een MCN-organisatie).
- [ ] Nieuwe beheerder heeft toegang tot het TransIP-account (hosting, domeinen `stichtingmcn.nl` en `mobiel-erfgoed.nl`, e-mail).
- [ ] Duidelijk bij wie `mobielecollectienederland.nl` geregistreerd is (niet bij TransIP).
- [ ] SFTP-gegevens staan in de wachtwoordkluis van MCN; wachtwoord gewijzigd en GitHub-secret `SFTP_PASSWORD` bijgewerkt.
- [ ] Testwijziging gedaan door de nieuwe beheerder (bijv. een spatie in een tekst), deploy groen, live gecontroleerd.
- [ ] Afgesproken wie het domein en de mailbox van `mobielecollectie.nl` beheert (contactadres op de site).
- [ ] Verlengdatums domeinen en hostingcontract genoteerd.
- [ ] Oud beheerder verwijderd als collaborator / uit TransIP, zodra de overdracht rond is.

---

## 6. Bekende aandachtspunten

In volgorde van belang. Geen van deze punten verhindert het dagelijks beheer.

1. **ANBI-publicatieplicht nagaan.** Als (culturele) ANBI moet MCN op internet o.a. bestuurssamenstelling, beleidsplan, beloningsbeleid, een actueel activiteitenverslag en de financiële verantwoording publiceren. De site noemt RSIN, beloningsbeleid en ANBI-status, maar bijvoorbeeld geen bestuursleden, beleidsplan of jaarcijfers.
2. **GitHub Pages uitzetten.** Het bestand `CNAME` (dat doorstuurde naar het niet-bestaande domein `stichtingmobielecollectie.nl`) is verwijderd, maar GitHub Pages zelf staat nog aan en draait bij elke push een overbodige run *pages build and deployment*. Uitzetten via GitHub → Settings → Pages.
3. **Oud bestand `nieuws.html` nog op de server.** Het is uit de repo en uit `deploy.yml` gehaald (september 2026), maar omdat de deploy niets verwijdert staat het nog op TransIP. Eenmalig handmatig weghalen via SFTP of de TransIP-bestandsbeheerder.
4. **Nieuws staat op twee à drie plekken** (artikel, overzicht, homepagekaart) die met de hand gelijk moeten blijven. Makkelijk om er één te vergeten.
5. **Kapotte links naar de oude website.** In de artikelen `kamer`, `inbreng` en `europe` staan links naar twee PDF's (Kamerbrief OCW 10 juni 2025 en de Europese enquête) op `www.mobiel-erfgoed.nl/docs/…`. Dat domein stuurt alles door naar de homepage, dus die documenten zijn niet meer te openen. Advies: PDF's (als ze nog bestaan) in een map `documenten/` in de repo zetten, die map aan `deploy.yml` toevoegen en de links aanpassen.
6. **Vindbaarheid (SEO) en details:** geen `meta description`, geen favicon, artikelen hebben geen eigen URL die zoekmachines indexeren (alleen `#…`), nieuwsberichten tonen geen datum, jaartal in de footer (`© 2026`) staat vast in de code, en de knop "Terug naar nieuws" gaat naar Home.
7. **Deploy-beveiliging:** SFTP met wachtwoord, en de controle van de server-sleutel is uitgeschakeld (`StrictHostKeyChecking=no`). Werkt, maar een SSH-sleutel en een vaste host key zijn veiliger.
8. **Commitbericht `b0b3938`** noemt "standpunten & lobby, agenda, datums op nieuwskaarten", maar bevat alleen de wijziging "platform" → "platforms" (die daarna weer is teruggedraaid). Die onderdelen zijn dus níet gebouwd.
