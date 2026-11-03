# Ultimate Light Rail UI Preview — 0.1.2

Dit is een **aparte experimentele UI-mod** naast de stabiele Ultimate Light Rail 0.17.2 (revision 48). De core en haar stationslogica zijn ongewijzigd. Deze proef is lokaal gebouwd en getest op syntaxis/cataloguswiring, nog niet in de game gerenderd.

0.1.1 herstelt de opstartcrash "Duplicate animation name" uit 0.1.0. De eigen stijlen registreren hun animaties nu met een unieke ULR-prefix; een regressiecontrole voert beide stijlen uit en controleert registraties en verwijzingen naast de bestaande native animatienamen.

0.1.2 herstelt "function data() not defined": de replacement-scriptresource levert de callback via data(), zoals de native scriptloader vereist. GUI-modules worden pas binnen de callback geladen. De lokale controle test nu dit resourceformaat in plaats van het script als gewone Lua-module te laden.

## Installeren en proberen

1. Gebruik een kopie van je testsave.
2. Pak `ultimate-light-rail-ui-preview-0.1.2.zip` uit naast de core in dezelfde staging_area. Het archief heeft een eigen map `mrnickert_ulr_ui_preview`; plaats die niet in de coremap. Overschrijf de vorige UI Preview-bestanden als die er al staan.
3. Activeer zowel Ultimate Light Rail als Ultimate Light Rail UI Preview en herlaad de save.
4. Zoek de Light Rail-knop tussen de bestaande wegvervoer- en treinknop.
5. Open de drie submenu's: Remises, Sporen, Stations. De huidige standardstationkaart en actieve ULR Contract Example-kaarten horen hier te verschijnen.
6. Kies het spoor, een tramremise en een station; controleer dat het native bouwgereedschap en het stationsinstellingenpaneel openen. Controleer ook terugschakelen naar wegen/treinen en sluiten van het venster.

De normale native tramremise blijft tevens in het normale menu staan. Ons spoor en onze bekende stations worden alleen in de UI-catalogus naar Light Rail verplaatst; de engine-resources en saveobjecten worden niet aangepast.

## Terug naar de stabiele UI

Schakel uitsluitend **Ultimate Light Rail UI Preview** uit en herlaad. Laat de core actief voor je stations. Deze GUI-mod heeft geen eigen station-/spoorobjecten; plaatsingen gebruiken de originele core/native resource-ID's.

## Wat deze proef technisch doet

- Via het native `react-replacement-config`-mechanisme vervangen we precies de publieke GameBar-recipe en ConstructionListWindow-recipe.
- De twee adapters worden bij het bouwen afgeleid van de geïnstalleerde native GUI-sources en met Teal naar Lua omgezet. Nieuwe recepten krijgen ULR-namen; eigen stijlen richten zich alleen op die recepten. De native Construction-tool blijft geregistreerd en beheert alle bouwacties.
- Een extra LIGHT_RAIL-categorie wordt achter de bestaande 17 categorieën toegevoegd. Zo houden alle bestaande hoofdknoppen hun tabindex; alleen de nieuwe knop verwijst naar de extra tab.
- De catalogus bewaart de native depot-tijdperkvarianten en de oorspronkelijke definities/parameters. Geen nieuwe remise-, voertuig- of stationslogica.
- Het aangeleverde PNG-icoon is alleen verliesvrij naar TGA omgezet, zonder bijsnijden, achtergrondverwijdering, recolouring of vervorming.

Dit is een relatief brede GUI-replacement voor een eerste engineproef. Andere mods die dezelfde twee recepten vervangen kunnen conflicteren. Native bestands-hashes staan in `build_manifest.json`; generatie stopt als de vereiste bronankers niet meer overeenkomen. Er wordt niets in de geïnstalleerde basebestanden overschreven.

## Grenzen en vervolg

Nog te testen: werkelijke positie/stijl/iconweergave, muisbediening, alle native keuzepanelen, wisselen tussen menu's, sluiten en save/herladen. Er is nog geen eigen controller/radial-menu-item of sneltoets. Het gewone native toetsenbordmenu is behouden.

Ontdekking omvat nu de standaardstation-ID, de bekende voorbeeldmod en expliciet gemarkeerde `ulr_stations`-categorieën. Dit bewijst nog geen algemene automatische herkenning van ieder script dat buildStation aanroept. Na een geslaagde proef hoort een construction-description-helper in de core-API de eigen categorie te gaan toewijzen; daarna kan deze UI in de hoofdmod worden geïntegreerd. De stabiele coretag blijft het terugvalpunt.

## Zelf bouwen

```powershell
python scripts/build_ui_preview.py
./scripts/convert_ui_icon.ps1
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_ui_preview.lua
python scripts/package_ui_preview.py
```

De generator gebruikt je geïnstalleerde game. De native-afgeleide Lua/styles, icoonconversie en manifest zijn gegenereerde bestanden; ze worden niet als grote kopieën in Git opgeslagen. Het archief bevat wel de benodigde adapters om deze concrete proef te draaien.
