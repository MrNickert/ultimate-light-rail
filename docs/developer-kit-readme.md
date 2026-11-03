# Ultimate Light Rail Developer Kit

**Core 1.0.0 · revision 49 · Station API v1**

Dit pakket bevat documentatie, een zelfstandige voorbeeldmod en referentiedeclaraties. Installeer de hoofdmod afzonderlijk. De kit zelf activeer je niet in de game.

## Start

1. Lees `docs/asset-kit-v1.md` voor maten en ondersteunde onderdelen.
2. Kopieer `example/` naar je eigen modmap. Wijzig mod-ID, zichtbare namen en alle verwijzingen naar de voorbeeldnamespace `ulr_contract_example`.
3. Declareer Ultimate Light Rail revision 49 als verplichte dependency met `loadBefore=true` en `optional=false`.
4. Gebruik `station_menu.lua.getMenuCategory()` in je `.con.lua`. Je station verschijnt dan in het gedeelde Light Rail-menu.
5. Roep `station_api_v1.lua.buildStation()` aan vanuit je updatescript en lever je eigen 20m-modellen aan.
6. Test minimaal korte en lange perrons, beide stationstypen, vrije trapzones, instappen, kruisen en opslaan/herladen.

De voorbeeldmod bevat een configureerbare 20m-componentenbouwset en een vast ontwerp met modelrollen. Gebruik de componentenbouwset als startpunt voor nieuwe ontwerpen. Beide voorbeelden tonen de gedeelde menukoppeling.

## Bestanden

- `docs/asset-kit-v1.md`: componentkeuzes, modelmaten en vaste delen.
- `docs/station-api-v1.md`: API, dependency, constructionbeschrijving en modelrollen.
- `example/`: volledige, optionele voorbeeldmod.
- `reference/`: modeldeclaraties en de concrete standaardbouwset ter referentie; geen kopieën van native meshes of textures.

Perron- en dakmodules zijn exact 20m. Perronbreedte, vloerhoogte, twee sporen, entrees en trappen staan vast. Ondergronds is de hal niet met eigen componenten aan te passen. Modellen moeten de referentieprofielen en vrije routes respecteren; schemavalidatie controleert niet automatisch iedere mesh of collider.
