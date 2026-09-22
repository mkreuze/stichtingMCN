PSQL="psql -h /var/tmp/pgtest -p 5433 -U postgres -tAq"
als () { $PSQL -c "begin; set local role authenticated; set local test.email = '$1'; $2; commit;" 2>&1 | tr -d '\n'; }
proef () { # omschrijving, verwacht, werkelijk
  if [ "$2" = "$3" ]; then printf '%-50s %-24s goed\n' "$1" "$3"
  else printf '%-50s %-24s !! FOUT, verwacht: %s\n' "$1" "$3" "$2"; fi
}
echo "------------------------------------------------------------------------------"
proef "buitenstaander: aantal zichtbare organisaties" "0" "$(als vreemde@example.org 'select count(*) from organisaties')"
proef "kijker: aantal zichtbare organisaties"         "1" "$(als kijker@example.org 'select count(*) from organisaties')"
proef "bewerker: aantal zichtbare organisaties"       "1" "$(als bewerker@example.org 'select count(*) from organisaties')"
proef "niet ingelogd: aantal zichtbare organisaties"  "0" "$(als '' 'select count(*) from organisaties')"

r=$(als kijker@example.org "with u as (update organisaties set plaats='HACK' returning 1) select count(*) from u")
proef "kijker: aantal gewijzigde organisaties"        "0" "$r"
r=$(als kijker@example.org "with d as (delete from organisaties returning 1) select count(*) from d")
proef "kijker: aantal verwijderde organisaties"       "0" "$r"
r=$(als kijker@example.org "insert into personen (naam) values ('Stiekem')")
echo "$r" | grep -qi "row-level security" && r2="geweigerd" || r2="DOORGELATEN"
proef "kijker: persoon toevoegen"                     "geweigerd" "$r2"

r=$(als bewerker@example.org "with u as (update organisaties set plaats='Amersfoort' returning 1) select count(*) from u")
proef "bewerker: aantal gewijzigde organisaties"      "1" "$r"
r=$(als bewerker@example.org "with u as (update leden set rol='beheerder' where email='bewerker@example.org' returning 1) select count(*) from u")
proef "bewerker: zichzelf tot beheerder maken"        "0" "$r"
r=$(als vreemde@example.org "insert into organisaties (naam) values ('Inbraak')")
echo "$r" | grep -qi "row-level security" && r2="geweigerd" || r2="DOORGELATEN"
proef "buitenstaander: organisatie toevoegen"         "geweigerd" "$r2"
echo "------------------------------------------------------------------------------"
echo -n "plaats van de organisatie nu: "; $PSQL -c "select plaats from organisaties"
echo -n "rol van de bewerker nu:       "; $PSQL -c "select rol from leden where email='bewerker@example.org'"
echo -n "aantal personen:              "; $PSQL -c "select count(*) from personen"
