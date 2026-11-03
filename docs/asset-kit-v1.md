# Assetbouwset v1 — handleiding voor makers

De componentenbasis bestaat vanaf 0.16.0 / revision 45. Deze handleiding beschrijft **0.17.0 / revision 46**, waarin onze inbegrepen stations zelf expliciete bouwsets gebruiken. Dit is een uitbreiding binnen API v1. De eerdere `assets`-vorm blijft werken, maar voor nieuwe ontwerpen gebruiken we `components`. Beide vormen mogen niet in één ontwerp gemengd worden.

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

Aangeleverde rechte perron- en dakmodellen zijn **exact 20m lang**. De kern herhaalt ze zonder lengte-, breedte- of hoogteschaling. De `moduleLength=20`-declaratie is verplicht. De maker moet de werkelijke modelgeometrie conform aanleveren; de API inspecteert niet automatisch iedere externe mesh. Defaults volgen de inbegrepen bouwset van de gebruikte coreversie. Kies expliciete modellen als je een eigen vaste vormgeving wilt behouden.

De herhaling begint bij het vaste vrije bouwvlak. Dit is geen nieuw globaal raster dat bestaande traplocaties verplaatst. De 40m native onderdoorgang, 18m elevated trappen, smalle stroken naast openingen en korte eind-/aansluitstukken blijven van de kern. Een eigen model vervangt alleen volledige 20m-perronstukken; resterende korte stukken gebruiken het bestaande kernmodel, zodat geen maatwerkmodel uitgerekt of over een trapgat gelegd wordt. Daardoor zijn sommige randstukken nog niet volledig in de eigen stijl vorm te geven.

Eigen daken bedekken de bruikbare perronlengte 0..L, in hele 20m-modules. Elevated wissel-/eindzones behouden vaste native dakpasstukken. De kern plaatst kapkolommen op vaste veilige plekken, houdt hokjes buiten de kolomlijn en zet bovengrondse bovenleidingmasten buiten de kap; contactdraden blijven op dezelfde positie.

Onze inbegrepen bovengrondse/elevated stations kiezen nu zelf expliciet `platform20.mdl` en, waar van toepassing, `platform_roof20.mdl`. Deze referentiewrappers zijn 20m groot door de geïnstalleerde native 40m-visuals intern op halve lengte te gebruiken. Het patroon in lengterichting verandert daardoor. Zelf gemodelleerde 20m-assets hoeven intern niet gehalveerd te worden. De kern plaatst de aangeleverde 20m-modellen ongeschaald. Oude 40m-helpers blijven voor legacy en korte vaste passtukken, niet als volledige alternatieve standaardbouwset.

De native perronvloer is aan de geïnstalleerde mesh gecontroleerd op z≈1,1m; de nieuwe 20m-wrapper, het kopplein en vaste perronpasstukken worden naar z=0,25m genormaliseerd. Er zijn geen native mesh- of texturebinaries gekopieerd.

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

- `api.getDefaultKit()` geeft verse context-defaultselecties.
- `api.getDefaultKit("surface")` of `"elevated"` geeft de concrete inbegrepen bouwset met expliciete modelreferenties. `"underground"` geeft de vaste hal als lege componententabel. Deze contexthelper is beschikbaar vanaf revision 46.
- Voor `benches` is vanaf revision 46 optioneel `entranceModel` toegestaan naast `model`: één banktype op het perron en een ander bij de elevated ingang. Zonder dit veld gebruikt de ingang hetzelfde eigen bankmodel.
- `api.getContract()` geeft onder andere modulelengte, vaste perronmaten, beschikbare sleutels en de vaste-route/entree/trap-afspraken.
- `api.getDefaultDesign()` blijft de oude asset-role configuratie teruggeven voor bestaande consumers.

## Voorbeeld en bewijs

De optionele `ulr_contract_example` 0.2.0 heeft twee menu-items: het oude rolvoorbeeld en **ULR Component Kit Example**. Bij de laatste kies je doorgaand/kopstation, lengte en Covered/Minimal. Covered toont een bovengrondse kap met 20m-modelwrappers uit de eigen namespace, zonder hokjes/groen. Minimal laat daarnaast dak en meubilair weg. De dependency vereist core revision 45.

Alle 72 functionele referentiegevallen blijven gelijk, met alleen de modeltabellen uitgesloten omdat de standaardassemblage nu bewust 20m-onderdelen gebruikt. Voor 27 ondergrondse/legacy-gevallen blijft ook de volledige modeluitvoer gelijk. Alle lengtes en beide typen zijn lokaal op dekking en routing gecontroleerd.

De gebruiker heeft de onafhankelijke voorbeeldmod geplaatst: 40m/80m, met/zonder dak. Instappen en wissels zijn bevestigd in twee geteste varianten. De nieuwe inbegrepen standaardbouwsets van 0.17.0 vragen nog een in-game eindcontrole; dat is een aparte validatie en geen bewijs voor alle toekomstige externe assets.

## Zelf een mod aanleveren

```text
my_station_mod/
  mod.json
  _metadata/modinfo.json
  content/
    my_station.con.lua
    my_station.script.lua
    platform20.mdl
    roof20.mdl
    ... eigen meshes, materialen en textures indien nodig
```

Declareer voor nieuwe makers die deze handleiding volgen de verplichte coredependency in `mod.json`:

```json
"dependencies": [{
  "mod": {"modId": "mrnickert_ultimate_metro", "revisionMin": 46, "revisionMax": -1},
  "modInfo": {"displayName": "Ultimate Light Rail"},
  "loadBefore": true,
  "optional": false
}]
```

Gebruik je eigen mod-ID en eigen resource-ID's. Een `.con.lua` verzorgt naam, menuafbeelding, keuzeknoppen en de verwijzing naar je script. Het script roept `buildStation` aan zoals hierboven. De voorbeeldmod bevat werkende declarations als startpunt; haar dependency is nog revision 45 omdat die bewust ook de eerdere componentenbasis demonstreert. Verhoog bij gebruik van revision-46-functies zelf het minimum.

Aanlevercheck: juiste 20m-maten, oorsprong en vloer; geen vaste kapkolommen in het dakmodel; geen transportmetadata; alle resources mod-gekwalificeerd; eigen dependency; testen op korte/lange stations, trapvrijheid, straat-/spooraansluiting, instappen, kruisen en save/herladen. Dat zijn praktische acceptatiecriteria; het is geen claim dat de API iedere modelafwijking automatisch afvangt.
