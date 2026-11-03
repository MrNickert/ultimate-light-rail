# Installatie en eindcontrole 0.17.0

1. Bewaar een kopie van de werkende save en de visuele referentiesave.
2. Pak `ultimate-light-rail-0.17.0.zip` uit in de bestaande staging_area en overschrijf de modbestanden. De map blijft `mrnickert_ultimate_metro`.
3. Herlaad de save; het spel volledig afsluiten is niet nodig.
4. Plaats nieuwe standaardstations. Bestaande objecten worden niet automatisch omgebouwd naar de nieuwe modelassemblage.

Controleer bovengronds, ondergronds en elevated, met doorgaand/kopstation en de verschillende lengtes. De gewone bouwoptie en opgeslagen keuzes blijven gelijk. Bovengronds blijft standaard zonder kap; elevated met kap.

Vanaf deze versie gebruikt de standaardbouwset echte 20m-referentiecomponenten in de vrije perron-/dakdelen. De wrapper hergebruikt native 40m-visuals op halve lengte; tegel- en dakherhaling kan dus verschillen van de oude referentiestations. Vaste trappen, korte passtukken en de ondergrondse hal blijven kernonderdelen.

Controleer eerst uitstraling, aansluiten op sporen/straat en vrije trapgaten. Controleer daarna instappen, rijden, keren, kruisende routes en opslaan/herladen. De automatische vergelijking bevestigt ongewijzigde functionele bouwdata, maar vervangt deze enginecontrole niet.

## Voorbeeldmod

De reeds geteste voorbeeldmod 0.2.0 blijft bruikbaar. Die is geen dependency van de hoofdmod en hoeft niet actief te zijn voor onze standaardstations. Alleen het voorbeeld vereist Ultimate Light Rail. Testobjecten uit de voorbeeldmod vereisen dat die mod actief blijft in hun save.

## Verwijderen

Verwijder de mod niet uit een save waarin haar stations of infrastructuur nog aanwezig zijn. Legacy construction-ID's en resources blijven meegeleverd voor bestaande saves. Geen automatische migratie of afbraak.
