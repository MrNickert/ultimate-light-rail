# Eigen Light Rail-menu — haalbaarheidsonderzoek

Status: onderzoek op de lokaal geïnstalleerde Transport Fever 3-bestanden. Nog geen UI-prototype of enginebewijs. De werkende core 0.17.2 / commit ce6efa7 wordt apart als `v0.17.2-core-stable` gemarkeerd. Dit onderzoek verandert geen stations, API-uitvoer, categorieën of runtimebestanden.

## Gewenste spelerervaring

Een eigen Light Rail-knop tussen wegvervoer en trein in de onderste bouwbalk. Een eenvoudig zijaanzicht van een metro/lightrailvoertuig, in dezelfde monochrome stijl en knopmaat als de bestaande iconen. Drie onderdelen in het menu:

1. Tramremise: bestaande native remise, inclusief passende tijdperkvariant.
2. Lightrailspoor: uitsluitend onze publieke lightrailtrack.
3. Stations: onze configureerbare stations en toekomstige uitbreidingen die het menucontract gebruiken.

Onze eigen infrastructuur hoeft dan geen plaats meer in de gewone weg-/treincatalogi te krijgen. De native tramremise mag haar oorspronkelijke beschikbaarheid in het normale trammenu behouden; het Light Rail-menu kan een toegang tot dezelfde native bouwdefinitie bieden.

## Primaire bronnen uit de installatie

Alle paden hieronder zijn binnen `C:/Program Files (x86)/Steam/steamapps/common/Transport Fever 3`.

| Bron | Vastgesteld |
| --- | --- |
| `base/content/gui.zip` → `gui/game_bar/game_bar.tl` | `routesGroup` bevat expliciet Road, Rail, Water en Air. De gewenste positie zit tussen Road en Rail. `ConstructionToolButton` opent een vast tabnummer met `constructionMenuSetTab` en gebruikt de native Construction-tool. |
| `base/content/gui.zip` → `gui/main/main_mod_button_area.tl` | `MainModButtonAreaExtension` bestaat, maar is een aparte modknoppenzone; niet de gevraagde positie tussen Road en Rail. |
| `base/content/gui.zip` → `gui/main/mod_entry_point.tl` | `ModEntryPointExtension` kan eigen GUI toevoegen. Dit is een mogelijke ingang voor het eigen catalogusvenster. |
| `base/tealdef/scripts/react.d.tl` | `ReactReplacementApi.ReplaceRecipe` en `React.CallOriginalRecipe` bestaan. Een vervanging moet dezelfde API aanbieden. |
| `base/content/gui.zip` → `gui/game_bar/game_bar.tl` + `.d.tl` | `game_bar.GameBar` is publiek geëxporteerd. De interne ConstructionToolButton/Group zijn lokale recepten; niet rechtstreeks beschikbaar als module-export. Een kleine private subknop vervangen is dus niet automatisch mogelijk via de publieke export. |
| `base/content/gui.zip` → `gui/construction/construction.tl` | De hoofdmenu's worden met expliciete `addCategoryNew`-aanroepen opgebouwd. Alleen een extra categorie-resource toevoegen maakt daarom nog geen zelfstandige nieuwe hoofdknop. |
| `base/content/gui.zip` → `gui/construction/construction_react_util.tl` | `getMenuCategories` verzamelt `menu_category`-resources en koppelt alle definities aan hun categorienaam. `getConstructionDefinitions` en `getStreetDefinitions` leveren de verschillende native bouwdefinities. |
| `base/content/gui.zip` → `gui/construction/menu/menu_categories/category_road_buildings.res.lua` | Een subcategorie is een generieke `.res.lua` met `type="menu_category"`, eigen category-ID, naam, icoon, order en een bestaand menu zoals ROAD. Dit is geen registratie van een nieuwe hoofdknop. |
| `base/content/depots/road.zip` → `road/tram_depot/tram_depot.con.lua` | De native tramremise en templates voor 1900–1940, 1940–1980 en vanaf 1980 zijn beschikbaar. Model-/bouwlogica hoeft niet opnieuw ontworpen te worden. Relatieve resourcepaden moeten bij hergebruik correct naar de base-namespace blijven verwijzen. |
| `base/tealdef/gui/construction/construction_menu.d.tl` | ConstructionMenu beschrijft de bestaande vaste namen; er is geen gedocumenteerde algemene registerMainMenu-aanroep gevonden. Dit is een Teal-type, geen bewijs dat een engine-enum nooit uitbreidbaar kan zijn. |

Aanvullend gelezen: https://tf3-docs.transportfever.net/en/guides/gui.html . Deze onofficiële gids beschrijft plugins en recipe replacement aan de hand van de spelbestanden. De uitspraken hierboven zijn aan de lokale primaire bronnen getoetst.

## Conclusie

Het ontwerp is technisch kansrijk. Het spel heeft eigen GUI-recepten, plugins, recipe replacement en data-gedreven categorieën. De exacte gevraagde positie en een zelfstandige catalogus met zowel street-template als construction-definities zijn echter geen al bewezen simpele categorie-instelling.

Een prototype moet bewijzen dat we de knop exact tussen de native Road/Rail-knoppen krijgen en het normale bouwgereedschap kunnen openen zonder de rest van de balk of parameters te verstoren. Het native modknoppengebied is een alternatief, maar voldoet niet aan de gevraagde positie en wordt daarom niet als equivalent gepresenteerd.

## Voorgestelde opbouw

- **UI-adapter:** eigen Light Rail-toegang en catalogus. Gebruik de ondersteunde plugin/replacement-mechanismen; wijzig geen geïnstalleerde base-bestanden.
- **Catalogus:** combineer de native tramremise, onze street-template en onze station-constructions. Laat de bestaande native plaatsing en stationsparameters hun werk doen.
- **Eigen menu-identiteit:** stabiele namen voor remises, spoor en stations. Verplaats onze entries pas nadat de zelfstandige catalogus werkt; geen brede verplaatsing van alle native traminhoud.
- **Stationscontract:** voeg een gedeelde helper voor de `.con.lua`-beschrijving toe die automatisch de Light Rail-stationscategorie kiest. Naam en parameters mogen van de maker komen; menuplaatsing krijgt de frameworkdefault.
- **Icoon:** een origineel eenvoudig zijprofiel, als transparante resource op de native iconmaat. Geen nieuwe stationsafbeeldingen of assetontwerpen nodig voor de eerste proef.

Belangrijk: `buildStation()` wordt pas bij de construction-update aangeroepen. Het beheert nu niet de vooraf geladen `.con.lua`-menuomschrijving. Alleen deze functie gebruiken laat toekomstige stations dus nog niet automatisch in het nieuwe menu verschijnen. De beschrijvingshelper wordt onderdeel van het volledige toekomstige aanlevercontract. Oudere add-ons met een eigen hardgecodeerde road_buildings-categorie worden niet stilzwijgend als automatisch verhuisd beschouwd.

## Eerste prototype en acceptatie

1. Alleen knop + leeg Light Rail-menu, exact tussen wegvervoer en trein.
2. Standaardstation openen, met de bestaande vier keuzerijen en werkende plaatsing.
3. Lightrailtrack en native tramremise toevoegen, met correcte brug/tunnel/bovenleiding- en tijdperkopties.
4. Voorbeeldmod via de nieuwe beschrijvingshelper laten verschijnen zonder de gewone catalogi te vervuilen.
5. Controleren op toetsenbord/muis, menu wisselen/sluiten, geselecteerde gereedschappen, save/herladen en uitgeschakelde mod. Nagaan wat er gebeurt als een andere mod dezelfde GameBar vervangt.

Er is nog geen claim van enginewerking, een definitief icoon of compatibiliteit met andere GUI-mods. De volgende ontwikkelstap is deze UI-proef, niet een wijziging aan de bewezen tram-/stationlogica.
