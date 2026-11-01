# Ultimate Metro

Versie 0.8.0, revision 19. Twee tramgebaseerde metrokopstations met twee perrons van 80 meter en een optionele compacte kruiswissel. Gebruik gewone elektrische tramtrack en omkeerbare lightrailvoertuigen, bijvoorbeeld Citylink.

## Stations

- **Metro Terminus / Metro Kopstation**: het bestaande bovengrondse station, met een eigen menuafbeelding.
- **Underground Metro Terminus / Ondergronds Metro Kopstation**: een nieuwe variant met sporen op 18 meter diepte, de native ondergrondse stationshal en trappen naar een ingang op straatniveau. Eigen menuafbeelding en ondergrondse bouwweergave.

Beide staan in het wegstationsmenu. De rechte interne stationssporen en de korte aansluiting hebben een maximum van **80 km/u**, de kruiswissel **40 km/u**. De engine kan op bochten of bij nadering van een halte verder afremmen. Intern worden de snelheden gedeeld door 3,6, omdat de velden meters per seconde gebruiken.

De mod gebruikt dezelfde beproefde voertuiggeometrie voor beide varianten. De ondergrondse variant verplaatst die 18 meter naar beneden en gebruikt de native voetgangerscirculatie. Er zijn geen automatische wereldwijzigingen of diagnosescripts. De standaard tramtrack tussen stations behoudt zijn normale reserveringsgedrag.

## Teststatus

Het bestaande bovengrondse station is door de gebruiker getest met keren, instappen, drukke kruisende lijnen, wachten/vrijgeven van wisselroutes en opslaan/herladen. De ondergrondse variant is nieuw en moet nog in de game worden geplaatst en aangesloten. Lokale tests controleren de gelijke voertuiggeometrie, beide wisselopties, toegankelijke perrons vanaf straatniveau, modellen, terreinbewerking, snelheden en pakketafhankelijkheden.

De menuafbeeldingen zijn gegenereerde illustraties, geen screenshots. De game gebruikt bestaande Urban Games-modellen; zie [credits](credits.txt).

## Installeren en proberen

Zie [installatie](docs/installatie.md) en [teststatus](docs/teststatus.md). Oude resource-ID's en parameterindices van het werkende bovengrondse station blijven behouden. De mod herschrijft bestaande geplaatste stations niet automatisch; hun opgeslagen snelheidsgeometrie kan pas na herconfigureren/opnieuw bouwen wijzigen.

## Ontwikkelen

```powershell
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_terminus.lua
python scripts/test_native_layout.py
python scripts/package.py
```

De tweede controle leest de native Lua-hulpfuncties uit de geïnstalleerde game. Alleen hun Teal-wiskunde en engine-serialisatie worden in de test vervangen; plaatsing, reserveringen en voertuigsnelheid moeten in de game worden beoordeeld. Het pakket bevat 15 bestanden en geen meegeleverde native 3D-assets.
