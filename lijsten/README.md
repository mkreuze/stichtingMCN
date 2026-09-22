# Actie-, besluiten- en relatielijst

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
Die staan in Supabase onder **Project Settings → API**:
de *Project URL* en de *anon public* sleutel.
Die twee mogen in de pagina staan; ze geven op zichzelf geen toegang,
want de toegangsregels in de database bepalen wat iemand mag.
De *service_role* sleutel geef je nooit door en zet je nergens in.

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
