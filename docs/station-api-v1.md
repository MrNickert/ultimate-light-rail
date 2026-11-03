# Stationscontract v1

Vanaf **0.16.0 / revision 45** is `components` de aanbevolen ontwerpvorm. Zie [assetbouwset v1](asset-kit-v1.md) voor standaard/eigen/geen, verplichte 20m-modules en de vaste delen. De oudere `assets`-vorm hieronder blijft voor compatibiliteit ondersteund. Gebruik per ontwerp één vorm.

Eerste implementatie: Ultimate Light Rail 0.15.0 / revision 44. Onze bestaande configureerbare stations gebruiken dit contract daadwerkelijk. Een onafhankelijke voorbeeld-consumer is lokaal getest; activeren en laden van twee mods in de game is nog niet bevestigd.

## Opbouw

- `station_api_v1.lua`: publiek contract, validatie en beperkte visuele vervanging.
- `station_standard_design.lua`: ons eigen ontwerp, met verse tabellen per aanroep.
- `station_layout_builder.lua`: private dispatch naar de bestaande bewezen bouwers.
- `station_config_util.lua`: vertaalt bestaande menu-/save-indices; behoudt oude defaults.

Onze standaardstations gebruiken dezelfde publieke API. Verborgen legacy constructions behouden hun oude scripts. De helpers mengen intern nog geometrie en aankleding; deze eerste contractlaag vervangt benoemde model-ID's na de bestaande bouwstappen. Dit is nog geen vrij configureerbaar stationsbouwsysteem.

## Aanroep

```lua
local api = require "mrnickert_ultimate_metro::/station_api_v1.lua"
function data()
 return {updateFn=function(captureParams, params)
  return api.buildStation({
   apiVersion=1,
   placement="surface",
   stationType="through",
   platformLength=80,
   platformTracks=2,
   fence=true,
   design={apiVersion=1,id="my_design",assets={
    platformSurface="my_mod::/platform.mdl",
   }},
  },captureParams,params)
 end}
end
```

Het resultaat is rechtstreeks een construction-update-resultaat. De consumer levert een eigen `.con.lua`, script en resources. Er is geen globale registratie, automatische menu-inschrijving, migratie of routeplannerpatch. `require` gebruikt onze bestaande mod-gekwalificeerde Lua-imports; `buildStation` is onze eigen API.

## Stationvelden

| Veld | Contract |
| --- | --- |
| apiVersion | Verplicht, exact 1 |
| placement | Verplicht: surface, underground, elevated |
| stationType | Verplicht: through, terminus |
| platformLength | Verplicht aantal meters: 40, 60, 80, 100, 120 |
| platformTracks | Optioneel, standaard 2; andere aantallen afgewezen |
| fence | Optioneel boolean, standaard true; ondergronds effectief false |
| design | Optioneel ontwerp; weglaten gebruikt standaardontwerp |

Kopstation impliceert kruiswissel, doorgaand geen kruiswissel. Onbekende velden worden met een herkenbare API-fout afgewezen. `captureParams` en `constructionParams` zijn optionele tabellen. De API verandert geen caller-tabellen. De bestaande save-adapter blijft tolerant voor oude indices.

## Ontwerp

Een ontwerp is `{apiVersion=1,id="lowercase_identifier",assets={...}}`. `api.getDefaultDesign()` geeft een onafhankelijke kopie van ons standaardontwerp. Ontbrekende rollen gebruiken hun standaardmodel. Onbekende rollen, callbacks en ongekwalificeerde modelpaden worden afgewezen.

Alle referenties hieronder hebben prefix `mrnickert_ultimate_metro::/`, behalve het native wachthokje.

| Rol | Referentiemodel | Toepassing |
| --- | --- | --- |
| platformSurface | surface_platform.mdl | Bovengrondse/verhoogde vlakke perronstukken |
| headSurface | surface_head_tile.mdl | Bovengronds kopplein |
| shelter | ::/stations/street/small_stops/small_new.mdl | Bovengrondse wachthokjes |
| elevatedRoof | elevated_platform_roof.mdl | Verhoogde kap; kernkolommen blijven |
| elevatedEntranceBench | elevated_entrance.mdl | Parkbank bij verhoogde entree |
| entrancePaving | elevated_paving.mdl | Bestrating verhoogde entree |

Een rol werkt alleen waar de bestaande bouwer het referentiemodel plaatst. De ondergrondse hal, trapmodellen, veiligheid, draagconstructie, bovenleiding en kapkolommen blijven vast in v1.

### Fysieke aansluitafspraken

Een vervangmodel behoudt oorsprong, assen, vloerhoogte, afmetingen en veilige collisionruimte van het referentiemodel. De kern hergebruikt alle transforms, inclusief versmallen, verkorten en roteren. Nieuwe perronbreedtes en eigen traplocaties passen niet in v1.

- Perron: lokaal x=0..40m, y=-2.5..2.5m, native loopvloer z=circa 1.1m (geverifieerd uit de mesh; historische buildertransforms blijven behouden). De kern schaalt dit naar de gekozen lengte, breedte en hoogte; bedek geen trapgaten.
- Kopplein: referentie x=-5..0m, y=-5..5m, behoud de vloer-/randhoogte.
- Kap: behoud de referentiehoogte en vrije ruimte voor contactdraden en kernkolommen; voeg geen kolommen in trapgaten toe.
- Entreestoep: 3x3m vlak op lokaal z=0. Bankje volgens referentiemodel. Beide wrappers hebben geen collisionvolume; behoud vrije looproute en straataansluiting.
- Modellen mogen geen transportmetadata, terminals of extra persoon-/voertuiglanen toevoegen.

Dit zijn verplichtingen voor assetmakers. De API valideert schema en modelreferentie, maar inspecteert externe modellen niet volledig. De engine moet resources nog laden; een verkeerd model kan alsnog botsingen of fouten veroorzaken.

## Saves en versies

Mod-ID, alle bestaande construction-ID's en de vier opgeslagen menukeuzes blijven behouden. Ontbrekende lengte blijft 80m. Geplaatste stations worden niet automatisch verbouwd; nieuwe plaatsingen gaan via het contract. API-versie staat los van modrevision. Een brekende API krijgt een nieuw publiek pad/versienummer.

## Externe proef

`examples/contract_station` is een zelfstandige optionele consumer met eigen mod-ID, dependency, construction, script en perronwrapper. Het hoofdarchief bevat dit voorbeeld niet. De wrapper verwijst rechtstreeks naar dezelfde native meshes, met dezelfde dimensies. Geen native mesh-/texturebinaries worden gekopieerd.

Het oorspronkelijke voorbeeld 0.1.0 vereiste revision 44; de huidige voorbeeldmod 0.2.0 vereist revision 45 vanwege het extra componentenvoorbeeld. De dependency gebruikt `loadBefore=true`, `optional=false`. De consumer voegt één vast bovengronds doorgaand 80m station toe. Het uiterlijk blijft bewust gelijk om de geometrie te kunnen vergelijken. De lokale test controleert deze aparte consumer, maar bewijst nog geen engine-import tussen twee actieve mods.

## Bewijs

`python scripts/test_station_contract.py` vergelijkt de volledige bouwresultaten met vooraf vastgelegde SHA256-waarden uit 0.14.2 / commit d3ce898: 60 combinaties, zes standaard-/terugvalgevallen en zes legacyvarianten. Sleutels worden gesorteerd, getallen met 17 significante cijfers opgeslagen en model-/lanevolgorde behouden. De native `orderedPairs`-teststub is voor deze nulmeting gecorrigeerd naar gesorteerde iteratie, vóór runtimewijzigingen. Dit is geen render- of savebestandvergelijking.

`python scripts/test_native_layout.py` controleert daarnaast directe API-aanroepen, daadwerkelijke visuele vervanging, caller-isolatie, ongeldige contracten, de onafhankelijke voorbeeld-consumer en alle eerdere layouttests.

In-game: nieuwe stations naast de 0.14.2-referentiestations plaatsen. Werking en de externe twee-modproef worden afzonderlijk beoordeeld.
