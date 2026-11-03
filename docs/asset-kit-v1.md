# Assetbouwset v1 — handleiding voor makers

Beschikbaar vanaf Ultimate Light Rail 0.16.0 / revision 45. Dit is een uitbreiding binnen API v1. De eerdere `assets`-vorm blijft werken, maar voor nieuwe ontwerpen gebruiken we `components`. Beide vormen mogen niet in één ontwerp gemengd worden.

## Kort beginnen

Je levert een eigen mod met dependency, construction-menu-item, kort bouwscript en de modellen die je wilt vervangen. De kern verzorgt sporen, terminals, looproutes, entrees, trappen en veilige vaste aansluitmaten. Je hoeft geen stationslogica te kopiëren.

```lua
local api = require "mrnickert_ultimate_metro::/station_api_v1.lua"
function data()
 return {updateFn=function(capture, params)
  return api.buildStation({
   apiVersion=1,
   placement="surface",
   stationType="through",
   platformLength=80,
   platformTracks=2,
   fence=true,
   design={
    apiVersion=1,
    id="my_station",
    components={
     platform={model="my_mod::/platform20.mdl",moduleLength=20},
     canopy={model="my_mod::/roof20.mdl",moduleLength=20},
     shelter=false,
     trees=false,
     planters=false,
     benches="default",
    },
   },
  },capture,params)
 end}
end
```

## Drie keuzes per onderdeel

| Waarde | Betekenis |
| --- | --- |
| Weggelaten of `"default"` | Gebruik wat ons standaardstation daar plaatst |
| `false` | Plaats dit optionele onderdeel niet |
| `{model="my_mod::/model.mdl"}` | Gebruik het eigen model op de vaste plaatsen |

Voor `platform` en `canopy` moet de modeltabel bovendien `moduleLength=20` bevatten. `true`, losse modelstrings en eigen plaatsingsvelden zijn niet toegestaan. Het perron is verplicht en kan niet op `false`.

## Onderdelen

| Sleutel | Wat je kiest | Wanneer er plaatsen zijn |
| --- | --- | --- |
| `platform` | Gewone rechte 20m-perronmodules | Volledige 20m-stukken buiten vaste trap-/passtukken |
| `shelter` | Wachthokje of geen | Bestaande bovengrondse plekken; elevated heeft vaste extra plekken voor een eigen hokje |
| `canopy` | 20m-overkapping of geen | Eigen kap kan zowel bovengronds als elevated |
| `trees` | Bomen of geen | Kopplein bovengronds / elevated entreeplein |
| `planters` | Plantenbakken of geen | Dezelfde vaste pleinen |
| `benches` | Bankjes of geen | Perrons en elevated entreebankje |
| `bins` | Prullenbakken of geen | Bestaande vaste perronplekken |
| `lights` | Perronlampen of geen | Bestaande vaste perronplekken |

`trees=false` verwijdert ook de boomroosters. `planters=false` verwijdert de bijbehorende struiken. Een eigen boom behoudt het rooster; een eigen bak behoudt de bestaande struiken en moet dus op dezelfde afmetingen aansluiten. Catenary, veiligheidshekken en structurele pijlers worden niet verwijderd door de aankledingkeuzes.

`"default"` betekent contextafhankelijk standaardgedrag: bovengronds staat standaard geen kap, elevated wel. Vraag een kap expliciet met een modeltabel om bovengronds te overkappen. Een keuze voegt niet overal nieuwe plekken toe: bijvoorbeeld een doorgaand bovengronds station heeft geen kopplein voor bomen. Ook geeft een eigen perronmodel op een kort doorgaand station mogelijk geen vervanging als het gehele perron uit vaste trap- en passtukken bestaat.

## Wat vaststaat

- Twee perronsporen.
- Lengtes 40 / 60 / 80 / 100 / 120 meter.
- Perronbreedte 5m; loopvloer 0,25m boven het plaatselijke spoor-/dekniveau.
- Plaats en vorm van entrees, trappen en onderdoorgangen.
- Sporen, kruiswissels, keren, stopposities, routing en terminals.
- Ondergrondse hal is volledig vast. Daar accepteert `components` uitsluitend weggelaten/`"default"`-onderdelen; een aanpassing wordt expliciet afgewezen.

Perronhoogte, aantal sporen, vrije plaatsing en andere traplocaties zijn geen instelbare makeropties. Onbekende velden geven een herkenbare fout in plaats van stilzwijgend onjuiste verwachtingen te scheppen.

## De 20m-afspraak: gewone modules versus vaste stukken

Aangeleverde rechte perron- en dakmodellen zijn **exact 20m lang**. De kern herhaalt ze zonder lengte-, breedte- of hoogteschaling. De `moduleLength=20`-declaratie is verplicht. De maker moet de werkelijke modelgeometrie conform aanleveren; de API inspecteert niet automatisch iedere externe mesh.

De herhaling begint bij het vaste vrije bouwvlak. Dit is geen nieuw globaal raster dat bestaande traplocaties verplaatst. De 40m native onderdoorgang, 18m elevated trappen, smalle stroken naast openingen en korte eind-/aansluitstukken blijven van de kern. Een eigen model vervangt alleen volledige 20m-perronstukken; resterende korte stukken gebruiken het bestaande kernmodel, zodat geen maatwerkmodel uitgerekt of over een trapgat gelegd wordt. Daardoor zijn sommige randstukken nog niet volledig in de eigen stijl vorm te geven.

Eigen daken bedekken de bruikbare perronlengte 0..L, in hele 20m-modules. Elevated wissel-/eindzones behouden vaste native dakpasstukken. De kern plaatst kapkolommen op vaste veilige plekken, houdt hokjes buiten de kolomlijn en zet bovengrondse bovenleidingmasten buiten de kap; contactdraden blijven op dezelfde positie.

Ons standaardontwerp blijft visueel exact gelijk: het gebruikt intern native 40m-platforms en kappen als adapters voor twee logische modules. Dat is een expliciete compatibiliteitsvoorziening. De nieuwe referentiewrappers `platform20.mdl` en `platform_roof20.mdl` zijn 20m groot door het native 40m-model in hun eigen wrapper te halveren. Daarmee verandert het patroon van die referentie-onderdelen in lengterichting. Voor een eigen exact 20m gemodelleerde mesh is deze halvering niet nodig. Er zijn geen native mesh- of texturebinaries gekopieerd. De native perronvloer is aan de geïnstalleerde mesh gecontroleerd op z≈1,1m; de nieuwe 20m-wrapper en de vaste perronpasstukken van een eigen kit normaliseren die naar z=0,25m. De historische standaardtransforms blijven om compatibiliteitsredenen ongewijzigd.

## Aansluitmaten voor modellen

| Onderdeel | Vaste modelruimte |
| --- | --- |
| Perron | x=0..20m, y=-2,5..2,5m; lokale loopvloer z=0,25m; oorsprong op dekniveau |
| Kap | x=0..20m; referentie breedte circa 5,29m; dak tussen z=3,1499..4,385m boven perronvloer; oorsprong op perronvloer |
| Kapsteunen | Worden door de kern geleverd; geen eigen vaste kolommen in het dakmodel |
| Wachthokje | Volg het lokale nulpunt en veilige ruimte van het native `small_new.mdl`; geen eigen transportmetadata |
| Bomen/bakken/meubilair | Volg de referentiemodellen en hun vaste poses/schalen; geen eigen plaatsingscoördinaten in v1 |

Een fysiek dak mag bij de referentie enkele centimeters over de nominale 20m-grens steken. Bewaar ruimte voor trappen, contactdraden en vaste kapliggers. Eigen modellen mogen geen transportprovider, terminals of extra persoon-/voertuiglanen toevoegen. Voor balken, pylonen, trappen en ander dragend werk blijft de kern verantwoordelijk.

Gebruik een passende collider die de vrije loopruimte niet afsluit. Eigen resources worden door de engine geladen; schema-validatie alleen bewijst niet dat een model goed past. De automatische tests controleren onze referentiewrappers, niet alle mogelijke externe modellen.

## Helpers

- `api.getDefaultKit()` geeft een verse onderdelenconfiguratie.
- `api.getContract()` geeft onder andere modulelengte, vaste perronmaten, beschikbare sleutels en de vaste-route/entree/trap-afspraken.
- `api.getDefaultDesign()` blijft de oude asset-role configuratie teruggeven voor bestaande consumers.

## Voorbeeld en bewijs

De optionele `ulr_contract_example` 0.2.0 heeft twee menu-items: het oude rolvoorbeeld en **ULR Component Kit Example**. Bij de laatste kies je doorgaand/kopstation, lengte en Covered/Minimal. Covered toont een bovengrondse kap met 20m-modelwrappers uit de eigen namespace, zonder hokjes/groen. Minimal laat daarnaast dak en meubilair weg. De dependency vereist core revision 45.

Alle 72 standaardreferentiegevallen blijven exact gelijk aan de bestaande nulmeting. Bij 40 bovengrondse/elevated combinaties zijn optionele verwijdering, ongeschaalde modules, vaste functionele uitvoer en veilige kolom-/mastposities lokaal gecontroleerd. De daadwerkelijke twee-modimport, aankleding, botsingen en instappen moeten nog in de game worden beoordeeld.
