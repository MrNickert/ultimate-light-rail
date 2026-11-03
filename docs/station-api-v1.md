# Station API v1 — Ultimate Light Rail 1.0.0

De publieke API bouwt tramgebaseerde passagiersstations. De kern beheert geometrie, transportnetwerk, terminals, entrees en looproutes; een ontwerp levert visuele onderdelen.

## Dependency

Neem dit op in je eigen `mod.json`:

```json
"dependencies": [{
  "mod": {"modId": "mrnickert_ultimate_metro", "revisionMin": 49, "revisionMax": -1},
  "modInfo": {"displayName": "Ultimate Light Rail"},
  "loadBefore": true,
  "optional": false
}]
```

## Construction en gedeeld menu

Gebruik de lichte menuhelper in je `.con.lua`; deze laadt geen stationsbouwers:

```lua
local menu = require "mrnickert_ultimate_metro::/station_menu.lua"
function data()
 return {
  availability={yearFrom=0,yearTo=0},
  description={name="My Light Rail Station",description="My station design.",
   icon="my_mod::/station.tga"},
  menuCategory=menu.getMenuCategory(1100),
  params={},
  updateScript={fileName="my_mod::/station.script@updateFn"},
 }
end
```

`getMenuCategory(order)` geeft een nieuwe tabel met de gedeelde categorie `ulr_stations` en de filters `passenger` en `station`. `order` is optioneel, standaard 1000, en moet een niet-negatief geheel getal zijn. Dezelfde helper is beschikbaar als `station_api_v1.getMenuCategory`. Gebruik in resourcebeschrijvingen bij voorkeur de lichte module. Het menu herkent de categorie ongeacht jouw mod-ID; wijzig de hoofdmod niet. `buildStation()` alleen registreert geen menu-item.

## Updatescript

```lua
local station = require "mrnickert_ultimate_metro::/station_api_v1.lua"
function data()
 return {updateFn=function(capture,params)
  return station.buildStation({
   apiVersion=1, placement="surface", stationType="through",
   platformLength=80, platformTracks=2, fence=true,
   design={apiVersion=1,id="my_design",components={
    platform={model="my_mod::/platform20.mdl",moduleLength=20},
    canopy={model="my_mod::/roof20.mdl",moduleLength=20},
    shelter=false, trees=false, planters=false,
   }},
  },capture,params)
 end}
end
```

Het resultaat is rechtstreeks het construction-update-resultaat. `capture` en `params` zijn optionele tabellen; de API wijzigt geen caller-tabellen.

## Stationvelden

| Veld | Contract |
| --- | --- |
| `apiVersion` | Verplicht, exact 1 |
| `placement` | Verplicht: `surface`, `underground`, `elevated` |
| `stationType` | Verplicht: `through`, `terminus` |
| `platformLength` | Verplicht: 40, 60, 80, 100 of 120 meter |
| `platformTracks` | Optioneel, standaard 2; alleen 2 toegestaan |
| `fence` | Optionele boolean; standaard true, ondergronds effectief false |
| `design` | Optioneel; weglaten gebruikt de standaardbouwset |

Kopstation impliceert kruiswissel; doorgaand heeft geen kruiswissel. Liggingen zijn benoemde waarden, geen menu-indices. Onbekende velden en ongeldige waarden geven een API-fout.

## Ontwerpen en helpers

Een ontwerp bevat `apiVersion=1`, een lowercase `id` en precies één van `components` of `assets`. Gebruik voor nieuwe ontwerpen `components`; de [componentenhandleiding](asset-kit-v1.md) beschrijft standaard/eigen/geen en alle modelmaten.

- `getContract()`: modulelengte, perronmaten, ondersteunde componenten en vaste layoutafspraken.
- `getDefaultKit()`: verse contextafhankelijke standaardselecties.
- `getDefaultKit(placement)`: concrete standaardbouwset voor surface/elevated; vaste lege componentenbouwset voor underground.
- `getDefaultDesign()`: verse standaardconfiguratie met modelrollen.

Modelreferenties zijn mod-gekwalificeerd: `my_mod::/model.mdl` of een native `::/model.mdl`. Geef geen callbacks, eigen transforms of transportmetadata in een ontwerp mee.

## Modelrollen

Als alternatief voor componenten ondersteunt `assets` vervanging van deze rollen. Ontbrekende rollen houden het standaardmodel. De kern behoudt alle transforms, inclusief schaling; deze vorm is bedoeld voor visuele vervangers met exact het referentieprofiel.

| Rol | Referentiemodel, prefix `mrnickert_ultimate_metro::/` tenzij anders vermeld |
| --- | --- |
| `platformSurface` | `surface_platform.mdl` |
| `headSurface` | `surface_head_tile.mdl` |
| `shelter` | native `::/stations/street/small_stops/small_new.mdl` |
| `elevatedRoof` | `elevated_platform_roof.mdl` |
| `elevatedEntranceBench` | `elevated_entrance.mdl` |
| `entrancePaving` | `elevated_paving.mdl` |

Een rol werkt alleen waar de bouwer het model plaatst. De perronrol volgt lokaal x=0..40m, y=-2,5..2,5m met referentievloer rond z=1,1m vóór kerntransforms. Het kopplein volgt x=-5..0m, y=-5..5m. De entreestoep is een lokaal 3×3m-vlak op z=0. Houd oorsprong, vrije ruimte en het volledige referentieprofiel aan. Voor ongeschaalde 20m-modules gebruik je `components`.

## Grenzen

API v1 ondersteunt precies twee sporen, vaste perronbreedte en vloerhoogte, vaste entrees/trappen en de opgegeven lengtes. Ondergronds is de hal een vaste assemblage. De API valideert het schema en modelpaden; externe meshgeometrie en colliders moeten door de maker worden gecontroleerd. Een API-versie staat los van de modrevision. Een brekend stationscontract hoort in een nieuw publiek API-pad.
