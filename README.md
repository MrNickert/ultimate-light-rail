# Ultimate Metro

Versie 0.9.1, revision 27. Drie tramgebaseerde metrostations met twee perrons van 80 meter en een optionele compacte kruiswissel. Gebruik gewone elektrische tramtrack en omkeerbare lightrailvoertuigen, bijvoorbeeld Citylink.

## Stations

- **Metro Terminus / Metro Kopstation**: het bestaande bovengrondse station, met een eigen menuafbeelding.
- **Underground Metro Terminus / Ondergronds Metro Kopstation**: een nieuwe variant met sporen op 18 meter diepte, de native ondergrondse stationshal en trappen naar een ingang op straatniveau. Eigen menuafbeelding en ondergrondse bouwweergave.

Beide staan in het wegstationsmenu. De rechte interne stationssporen en de korte aansluiting hebben een maximum van **80 km/u**, de kruiswissel **40 km/u**. De engine kan op bochten of bij nadering van een halte verder afremmen. De stationslanen gebruiken nu rechtstreeks 80 en 40, zoals de native constructiescripts hun limieten doorgeven. Alleen het aparte straatprofielveld LaneConfig.speed blijft omgerekend naar m/s. De effectieve snelheid van deze correctie moet nog in de game worden bevestigd.

De mod gebruikt dezelfde beproefde voertuiggeometrie voor beide varianten. De ondergrondse variant verplaatst die 18 meter naar beneden en gebruikt de native voetgangerscirculatie. Er zijn geen automatische wereldwijzigingen of diagnosescripts. De standaard tramtrack tussen stations behoudt zijn normale reserveringsgedrag.

## Teststatus

Het bestaande bovengrondse station is door de gebruiker getest met keren, instappen, drukke kruisende lijnen, wachten/vrijgeven van wisselroutes en opslaan/herladen. De ondergrondse variant en hogere wisselsnelheid zijn door de gebruiker getest. De in 0.8.1 verplaatste voetgangerstoegang aan de kop moet nog in de game worden beoordeeld. Lokale tests controleren de gelijke voertuiggeometrie, beide wisselopties, toegankelijke perrons vanaf straatniveau, modellen, terreinbewerking, snelheden en pakketafhankelijkheden.

De menuafbeeldingen zijn gegenereerde illustraties, geen screenshots. De game gebruikt bestaande Urban Games-modellen; zie [credits](credits.txt).

## Installeren en proberen

Zie [installatie](docs/installatie.md) en [teststatus](docs/teststatus.md). Oude resource-ID's en parameterindices van het werkende bovengrondse station blijven behouden. De mod herschrijft bestaande geplaatste stations niet automatisch; hun opgeslagen snelheidsgeometrie kan pas na herconfigureren/opnieuw bouwen wijzigen.

## Ontwikkelen

```powershell
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_terminus.lua
python scripts/test_native_layout.py
python scripts/package.py
```

De tweede controle leest de native Lua-hulpfuncties uit de geïnstalleerde game. Alleen hun Teal-wiskunde en engine-serialisatie worden in de test vervangen; plaatsing, reserveringen en voertuigsnelheid moeten in de game worden beoordeeld. Het pakket bevat 27 bestanden en geen meegeleverde native 3D-assets.

## Bovengrondse afwerking in 0.8.2

Doorlopende lage perrons, zichtbaar straatwerk onder de sporen en een plein aan de kop, met banken, afvalbakken, plantenbakken, verlichting en bovenleidingsmasten met decoratieve draden. Alle zichtbare onderdelen gebruiken bestaande game-assets. De aparte oppervlaktedecoratie voegt geen vervoerslanen toe; voertuigpaden en ondergrondse aankleding blijven hetzelfde. Plaats een nieuw bovengronds station om de nieuwe inrichting te beoordelen en test de 25cm hoge voetgangersingang en het instappen.

## 0.8.4 spoorbedweergave

De drie platte perronmodellen onder de rails zijn verwijderd: hun vloer lag gelijk aan het grondvlak, waardoor beide oppervlakken door elkaar tekenden. Het spoorbed gebruikt weer de bestaande native asfaltgrondtextuur. Verhoogde perrons, plein, inrichting, spoorpaden en ondergrondse variant blijven behouden. Plaats een nieuw bovengronds station om de weergave te controleren; bestaande opgeslagen geometrie wordt niet automatisch herbouwd.

## Afwerking 0.8.4

Het kopplein gebruikt vier native verbindingsstukken op vrijwel oorspronkelijke schaal voor een gelijkmatig tegelpatroon. Het spoorbed gebruikt dezelfde native tramtextuur als de gewone tramtrack, aangebracht op kleine oorspronkelijke vlakke stroken langs de beproefde rijpaden. Op het plein staan twee kleine bomen, boombakken en vier bloembakken met azalea. Zijperrons blijven vrij van groen vanwege de bovenleiding. Nieuwe geometrie is alleen visueel; netwerk en ondergrondse variant veranderen niet.

## Compacte kop en doorlopende trambestrating 0.8.5

Het kopplein is 5m diep in plaats van 10m, met twee bomen en vier bloembakken in een compactere opstelling. De voetgangersverbinding en terreinbewerking zijn mee ingekort. Het spoorbed krijgt nu naast de native railtextuur ook de bijbehorende native trambestrating. De oorspronkelijke grondtextuur street_fill is grind, niet asfalt; die alleen leverde niet dezelfde kleurinvulling als de native aansluiting. Beide materiaalstroken volgen dezelfde rijpaden. De stationsperrons blijven 80m lang.

## 0.8.6 bredere wisselondergrond en snelheidsmeting

De grindondergrond onder de wissel is 11m breed, gelijk aan de twee native aansluitlanen van 5,5m. De perronruimte blijft 8m breed. Instappen met de compacte kop is door de gebruiker bevestigd. Gemeld rijgedrag: circa 13 km/u bij binnenkomst en 23 km/u bij vertrek; versnellen als ongeveer 80% van de tram de wissel gepasseerd is. De oorzaak is nog niet vastgesteld.

De afzonderlijke, tijdelijke **Ultimate Metro Speed Probe** leest de daadwerkelijke speedLimit en curveSpeedLimit van bestaande metroconstructies uit en schrijft één [UMSPEED]-rapport naar stdout.txt. Activeer hem naast de hoofdmod, herlaad en laat circa 10 seconden doorlopen. Hij bevat geen voertuig-, resource- of wereldwijzigingen en geen opgeslagen meetstaat. Schakel hem na de meting weer uit. De gewone mod blijft vrij van diagnosehooks. Zie diagnostics/speed_probe/README.md.

## Doorgaand station met onderdoorgang — 0.9.0

Nieuw in het wegstationsmenu: **Metro Through Station / Metro Doorgaand Station**. Twee zijperrons van 80m, gewone elektrische tramtrack aan beide uiteinden en toegang vanaf beide zijkanten. Voetgangers gebruiken de native trappen en een pad onder de twee sporen door; er is intern geen gelijkvloerse oversteek. Voor deze proef gebruikt de bouwoptie het native onderdoorgang-icoon.

De nieuwe doorrijlanen volgen gewone, gerichte tramverkeersregels. De bestaande kopstations behouden hun volledige bouwresultaat. Lokale controles bevestigen dat beide ingangen beide perrons ondergronds bereiken, maar plaatsing, native routeerbaarheid en instappen moeten nog in de game worden getest.

Deze stap deelt aankleding met de kopstations en scheidt de rij-/perronindeling van de voetgangersverbinding. Het uiteindelijke doel blijft één configureerbare stationfamilie met type, lengte en aantal perronsporen. Die keuzemogelijkheden zijn nog niet gebouwd; de nieuwe proef is bewust vast op 80m en twee perrons. Bestaande resource-ID's blijven als adapters nodig voor saves.

Extra controle: `& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_through_station.lua`.

## Stationssnelheid 0.9.1

De gebruiker bevestigt een werkende doorgaande variant, maar meldt ook daar ongeveer 23 km/u. De bouwcode gaf 80/3,6 = 22,22 door aan het stationsveld speedLimit. Native stationsscripts geven hun limiet direct door (bijvoorbeeld 40 voor de ondergrondse halte). Daarom is de deling voor stationslanen verwijderd: recht 80, wissel 40. Het aparte straatprofielveld speed blijft op 80/3,6. Dit is een gerichte correctie op basis van de waarneming en native scripts; de werkelijke snelheid na deze wijziging is nog niet in de engine gemeten.
