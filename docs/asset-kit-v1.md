# Componentenbouwset v1 — Ultimate Light Rail 1.0.0

Voor makers van visuele stationontwerpen. Vereist core revision 49. De standaardstations gebruiken dezelfde publieke bouw-API en componentenregels.

## Wie levert wat?

De maker levert een eigen mod, constructionbeschrijving, updatescript en de modellen die afwijken van de standaard. Gebruik `station_menu.lua.getMenuCategory()` om in het gedeelde Light Rail-menu te verschijnen. [Volledige API en voorbeeldcode](station-api-v1.md).

De kern levert twee perronsporen, wissels bij kopstations, stopposities, terminals, entrees, trappen, looproutes, draagconstructie en veiligheidsvoorzieningen. Kopieer deze logica niet naar een assetmod.

## Drie keuzes

| Waarde | Betekenis |
| --- | --- |
| Weggelaten of `"default"` | Contextafhankelijk standaardonderdeel |
| `false` | Geen optioneel onderdeel |
| `{model="my_mod::/model.mdl"}` | Eigen model op de vaste plaatsen |

Voor `platform` en `canopy` is ook `moduleLength=20` verplicht. Een perron kan niet worden weggelaten. `true`, losse modelstrings, callbacks en eigen plaatsingsvelden zijn niet toegestaan.

```lua
design={apiVersion=1,id="my_station",components={
 platform={model="my_mod::/platform20.mdl",moduleLength=20},
 canopy={model="my_mod::/roof20.mdl",moduleLength=20},
 shelter=false, trees=false, planters=false,
 benches="default", bins="default", lights="default",
}}
```

## Onderdelen

| Sleutel | Toepassing |
| --- | --- |
| `platform` | Rechte 20m-perronstukken buiten vaste trap-/passtukken |
| `shelter` | Vaste wachthokjesplekken; elevated heeft plekken voor een eigen hokje |
| `canopy` | 20m-overkapping, zowel surface als elevated |
| `trees` | Bovengronds kopplein of elevated entreeplein |
| `planters` | Dezelfde vaste pleinen |
| `benches` | Perronbankjes en elevated entreebank |
| `bins` | Vaste prullenbakplekken op het perron |
| `lights` | Vaste perronlampen |

Een eigen bank kan optioneel `entranceModel="my_mod::/entrance_bench.mdl"` opgeven voor een apart model bij de verhoogde entree. Zonder dit veld gebruikt de ingang hetzelfde eigen bankmodel.

`trees=false` verwijdert ook boomroosters; een eigen boom behoudt het rooster. `planters=false` verwijdert ook de bijbehorende struiken; een eigen bak behoudt die struiken en moet erop aansluiten. Bovenleiding, veiligheidshekken, pijlers en kapsteunen blijven kernonderdelen.

Defaults zijn contextafhankelijk: surface heeft standaard geen kap, elevated wel. Kies een expliciete kapmodeltabel voor een bovengrondse overkapping. Een keuze maakt geen nieuwe plekken: een doorgaand bovengronds station heeft bijvoorbeeld geen kopplein voor bomen.

## Verplichte 20m-modules

Gewone rechte perron- en dakmodellen zijn exact **20m lang**. De kern herhaalt eigen modellen zonder lengte-, breedte- of hoogteschaling. `moduleLength=20` is een verklaring van de maker; de API meet de externe mesh niet automatisch.

De kern vervangt alleen volledige 20m-stukken in het vrije bouwvlak. Vaste trappen, de native onderdoorgang, smalle stroken bij openingen en korte aansluit-/eindstukken blijven kernonderdelen. Op een kort doorgaand station kan het hele perron uit vaste stukken bestaan, waardoor een eigen perronmodel daar niet wordt gebruikt. Deze stukken zijn in v1 niet afzonderlijk te stylen.

Kappen bedekken de bruikbare perronlengte 0..L in hele 20m-modules. Verhoogde wissel-/eindzones hebben vaste dakpasstukken. De kern plaatst kapkolommen op veilige plekken, houdt wachthokjes vrij en verplaatst bovengrondse masten buiten de kap; de contactdraden blijven op hun positie.

De meegeleverde referentiewrappers gebruiken native 40m-visuals intern op halve lengte. Zelf gemodelleerde 20m-assets hoeven intern niet gehalveerd te worden.

## Modelmaten

| Onderdeel | Lokale modelruimte |
| --- | --- |
| Perron | x=0..20m, y=-2,5..2,5m; loopvloer z=0,25m; oorsprong op spoor-/dekniveau |
| Kap | x=0..20m; referentiebreedte circa 5,29m; dak z=3,1499..4,385m boven perronvloer; oorsprong op perronvloer |
| Kapsteunen | Door de kern geleverd; geen eigen vaste kolommen in het dakmodel |
| Wachthokje | Nulpunt en veilige ruimte van native `small_new.mdl` |
| Bomen, bakken, meubels | Referentieposes en -schalen volgen; geen eigen plaatsingscoördinaten |

Een dak mag bij de referentie enkele centimeters over de nominale lengte steken. Houd trappen, loopruimte, contactdraden en kapliggers vrij. Gebruik passende colliders. Voeg geen transportproviders, terminals of extra persoon-/voertuiglanen toe aan modellen.

## Vaste grenzen

- Twee perronsporen; lengtes 40/60/80/100/120m.
- Perronbreedte 5m; loopvloer 0,25m boven lokaal spoor-/dekniveau.
- Vaste entree-, trap-, onderdoorgang- en routeposities.
- Ondergrondse hal volledig vast: componenten mogen daar alleen weggelaten of `"default"` zijn. Eigen modellen en `false` worden afgewezen.

Perronhoogte, extra sporen, vrije plaatsing en andere traplocaties zijn geen makeropties in v1.

## Aanleveren en testen

```text
my_station_mod/
  mod.json
  _metadata/modinfo.json
  content/
    station.con.lua
    station.script.lua
    platform20.mdl
    roof20.mdl
    ... eigen meshes, materialen en textures
```

Gebruik een eigen mod-ID en eigen namespace. Declareer de verplichte coredependency op revision 49. Test met beide mods actief: menuherkenning, korte en lange stations, doorgaand en kopstation, trapvrijheid, straat-/spooraansluiting, instappen, wissels en opslaan/herladen. Een geldig schema bewijst niet dat een willekeurig extern model in de engine past.
