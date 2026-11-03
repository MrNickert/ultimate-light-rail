# Architectuur — Ultimate Light Rail 1.0.0

## Runtime

`light_rail_station.con.lua` beschrijft het bouwmenu en de keuzeknoppen. Het updatescript vertaalt de keuzes naar benoemde waarden en roept `station_api_v1.buildStation()` aan. De publieke API valideert het contract; `station_layout_builder.lua` dispatcht naar de surface-, underground- of elevatedbouwer. `station_components.lua` past de visuele bouwset toe zonder de transportgeometrie te wijzigen.

`station_standard_kit.lua` kiest expliciete 20m-modellen voor de inbegrepen ontwerpen. `station_menu.lua` levert een lichte, zelfstandige categoriehelper voor constructionbeschrijvingen. Externe assetmods gebruiken dezelfde helpers.

## UI

De hoofdmod registreert een native `react-replacement-config`. Het script levert `data().doReplaceFn` en vervangt de GameBar- en ConstructionListWindow-recepten. De bestaande Construction-tool blijft verantwoordelijk voor bouwen; de adapter gebruikt zijn descriptor uit `_react.tools.Construction`.

`content/gui/catalog.lua` verzamelt het native tramdepot, het eigen spoor en constructions met de categorie `ulr_stations`. Eén gecombineerde categorie behoudt het native zoekveld en verbergt categorietabs. De native tramremise blijft ook in het gewone menu beschikbaar. Catalogusfiltering verandert geen engine-resources of saveobjecten.

`scripts/build_ui.py` leidt adapters en stijlen af van de geïnstalleerde GUI-bronnen. Recepten en animaties krijgen unieke namen; imports worden expliciet naar native of eigen namespaces gericht. Het pakket bevat gegenereerde Lua en bronhashes. De interne UI-koppeling en bronankers vereisen controle bij game-updates. Mods die dezelfde recepten vervangen kunnen conflicteren.

## Build

Genereer de GUI en het transparante 30×30-menuicoon vóór het verpakken. `package.py` gebruikt een expliciete runtimebestandslijst, controleert eigen resources en vertalingen en schrijft alleen de hoofdmod. Voorbeeldmod en developer kit krijgen afzonderlijke ZIP's. Diagnostics en testbestanden worden niet in de hoofdmod opgenomen.
