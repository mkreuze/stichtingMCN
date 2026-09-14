# Werkafspraken voor Claude – website stichtingmcn.nl

Statische website van de Stichting Mobiele Collectie Nederland. **Lees eerst `BEHEER.md`**: daarin staan de opbouw van de site, de systemen, de publicatiestap en de bekende aandachtspunten. Dit bestand bevat alleen wat Claude daarnaast moet weten.

## Communicatie

- Antwoord in het **Nederlands**.
- De beheerder is geen ontwikkelaar. Leg in gewone taal uit wat je doet en wat het gevolg is ("live zetten" = zichtbaar op www.stichtingmcn.nl).

## Nooit zonder toestemming

- **Pushen naar `main` zet de site live.** Werk op een aparte branch, commit daar, en vraag altijd eerst of het live mag.
- Geen bestanden van de server verwijderen, geen instellingen van GitHub of TransIP wijzigen en geen bestanden van internet downloaden zonder expliciete toestemming.

## Lokaal testen

- Start de preview met `node tools/preview-server.js . 8001` en open `http://localhost:8001`.
  Voor het browserpaneel van Claude Code: zet dit in `.claude/launch.json` (die map staat in `.gitignore`):
  `{"version":"0.0.1","configurations":[{"name":"site","runtimeExecutable":"node","runtimeArgs":["tools/preview-server.js",".","8001"],"port":8001}]}`
- Gebruik **niet** `python -m http.server`: die liet afbeeldingen halverwege hangen.
- Controleer na een wijziging: alle afbeeldingen geladen (`naturalWidth > 0`), het aantal artikelen in `#articles-container`, en links naar `documenten/`.
- Een browsertab met `#hash` erachter laadt niet opnieuw; voeg `?v=2` toe om zeker de nieuwe bestanden te krijgen.

## Publiceren en controleren

1. Push de branch naar `main` (fast-forward): `git push origin <branch>:main`.
   Blijft de push hangen of vraagt Git om een gebruikersnaam, dan ontbreekt de GitHub-login. Vraag de beheerder die push één keer zelf in een terminal (Git Bash) uit te voeren; daarna onthoudt Git Credential Manager de login.
2. Volg de run *Deploy naar TransIP* via `https://api.github.com/repos/mkreuze/stichtingMCN/actions/runs` (duurt ca. 30–60 seconden).
3. Vergelijk live met git, met regeleinden genegeerd (de werkmap gebruikt CRLF):
   `curl -s "https://www.stichtingmcn.nl/index.html?nc=$RANDOM" | tr -d '\r' | md5sum` tegen `git show HEAD:index.html | tr -d '\r' | md5sum`.
4. Werk de lokale hoofdmap bij als die op `main` staat: `git merge --ff-only origin/main`.

## Aandachtspunten bij wijzigen

- **Foto's en PDF's als bestand**, niet als base64 in de HTML. Foto's in `fotos/`, PDF's in `documenten/`, bestandsnamen zonder spaties.
- **Nieuw bestand of nieuwe map op het hoogste niveau?** Voeg die toe aan de stap *Voorbereiden upload-map* in `.github/workflows/deploy.yml`, anders komt het niet online.
- **De publicatie verwijdert niets** op de server (`lftp mirror` zonder `--delete`). Verwijderen kan eenmalig met `cd $SFTP_TARGET_DIR` en `rm -f <bestand>` na de `mirror`-regel; daarna weer weghalen.
- **In `nieuws.js`** staat alle artikeltekst binnen één template literal: geen backtick en geen `${` in de tekst.
- Een nieuwsbericht staat op drie plekken (artikel in `nieuws.js`, overzicht en homepagekaart in `index.html`); houd ze gelijk.
- Houd `BEHEER.md` bij als de opbouw of werkwijze verandert, en voeg een regel toe aan het *Beheerlog*. De Google Doc "Beheerhandleiding website stichtingmcn.nl" is een kopie; `BEHEER.md` is leidend.
