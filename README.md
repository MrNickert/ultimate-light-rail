# Ultimate Metro

Versie 0.8.5, revision 24. Twee tramgebaseerde metrokopstations met twee perrons van 80 meter en een optionele compacte kruiswissel. Gebruik gewone elektrische tramtrack en omkeerbare lightrailvoertuigen, bijvoorbeeld Citylink.

## Stations

- **Metro Terminus / Metro Kopstation**: het bestaande bovengrondse station, met een eigen menuafbeelding.
- **Underground Metro Terminus / Ondergronds Metro Kopstation**: een nieuwe variant met sporen op 18 meter diepte, de native ondergrondse stationshal en trappen naar een ingang op straatniveau. Eigen menuafbeelding en ondergrondse bouwweergave.

Beide staan in het wegstationsmenu. De rechte interne stationssporen en de korte aansluiting hebben een maximum van **80 km/u**, de kruiswissel **40 km/u**. De engine kan op bochten of bij nadering van een halte verder afremmen. Intern worden de snelheden gedeeld door 3,6, omdat de velden meters per seconde gebruiken.

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

De tweede controle leest de native Lua-hulpfuncties uit de geïnstalleerde game. Alleen hun Teal-wiskunde en engine-serialisatie worden in de test vervangen; plaatsing, reserveringen en voertuigsnelheid moeten in de game worden beoordeeld. Het pakket bevat 22 bestanden en geen meegeleverde native 3D-assets.

## Bovengrondse afwerking in 0.8.2

Doorlopende lage perrons, zichtbaar straatwerk onder de sporen en een plein aan de kop, met banken, afvalbakken, plantenbakken, verlichting en bovenleidingsmasten met decoratieve draden. Alle zichtbare onderdelen gebruiken bestaande game-assets. De aparte oppervlaktedecoratie voegt geen vervoerslanen toe; voertuigpaden en ondergrondse aankleding blijven hetzelfde. Plaats een nieuw bovengronds station om de nieuwe inrichting te beoordelen en test de 25cm hoge voetgangersingang en het instappen.

## 0.8.4 spoorbedweergave

De drie platte perronmodellen onder de rails zijn verwijderd: hun vloer lag gelijk aan het grondvlak, waardoor beide oppervlakken door elkaar tekenden. Het spoorbed gebruikt weer de bestaande native asfaltgrondtextuur. Verhoogde perrons, plein, inrichting, spoorpaden en ondergrondse variant blijven behouden. Plaats een nieuw bovengronds station om de weergave te controleren; bestaande opgeslagen geometrie wordt niet automatisch herbouwd.

## Afwerking 0.8.4

Het kopplein gebruikt vier native verbindingsstukken op vrijwel oorspronkelijke schaal voor een gelijkmatig tegelpatroon. Het spoorbed gebruikt dezelfde native tramtextuur als de gewone tramtrack, aangebracht op kleine oorspronkelijke vlakke stroken langs de beproefde rijpaden. Op het plein staan twee kleine bomen, boombakken en vier bloembakken met azalea. Zijperrons blijven vrij van groen vanwege de bovenleiding. Nieuwe geometrie is alleen visueel; netwerk en ondergrondse variant veranderen niet.

## Compacte kop en doorlopende trambestrating 0.8.5

Het kopplein is 5m diep in plaats van 10m, met twee bomen en vier bloembakken in een compactere opstelling. De voetgangersverbinding en terreinbewerking zijn mee ingekort. Het spoorbed krijgt nu naast de native railtextuur ook de bijbehorende native trambestrating. De oorspronkelijke grondtextuur street_fill is grind, niet asfalt; die alleen leverde niet dezelfde kleurinvulling als de native aansluiting. Beide materiaalstroken volgen dezelfde rijpaden. De stationsperrons blijven 80m lang.
