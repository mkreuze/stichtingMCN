# De bestaande lijst overzetten

De lijst die nu als Claude-artifact draait bevat categorieën, acties en
besluiten. Die hoeven niet opnieuw ingetypt te worden.

## Hoe het gaat

1. Jij maakt het Supabase-project aan en draait de bestanden uit `database/`.
2. Je geeft mij de *Project URL* en de *anon public* sleutel door.
3. Ik lees de huidige lijst uit de artifact, zet hem om naar de tabellen
   en schrijf hem weg. Dat gebeurt in één keer; je hoeft niets te doen.
4. We controleren samen of alles klopt: aantal categorieën, acties,
   besluiten en labels.

De artifact blijft daarbij ongemoeid. Pas als de nieuwe lijst goed staat
en jij tevreden bent, stoppen we met de oude.

## Wat er meeverhuist

| Uit de artifact | Wordt in de database |
|---|---|
| categorie (naam, volgnummer, labels) | `categorieen` |
| actie (titel, wie, datum, toelichting, labels, afgerond) | `acties` |
| besluit (tekst, datum, herkomst) | `besluiten` |

De kenmerken blijven gelijk, dus de koppeling tussen een besluit en de
actie waar het uit voortkwam blijft bestaan.

## Wat er nieuw bij komt

Organisaties en personen. Die staan nog niet in de artifact en vullen we
daarna in — met de hand, of uit een bestand als je er al een hebt.
