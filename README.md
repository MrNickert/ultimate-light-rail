# Ultimate Light Rail

**Release 1.0.0 · modrevision 49 · Station API v1**

Tramgebaseerde lightrail voor Transport Fever 3, met een eigen bouwmenu, spoor en configureerbare passagiersstations.

## Spelen

Open **Light Rail**, tussen wegvervoer en trein. De tramremise, het lightrailspoor en alle aangesloten stations staan samen in één overzicht met zoekveld.

| Instelling | Keuzes |
| --- | --- |
| Ligging | Ondergronds / Bovengronds / Verhoogd; standaard bovengronds |
| Stationstype | Doorgaand / Kopstation |
| Perronlengte | 40 / 60 / 80 / 100 / 120 meter |
| Hekken | Nee / Ja; ondergronds uitgeschakeld |

Alle stations hebben twee perronsporen. Kopstations bevatten een kruiswissel en ondersteunen keren zonder zichtbare keerlus. Gebruik tramvoertuigen en native elektrische tramtrack; kies voertuigen die binnen de perronlengte passen. Te lange voertuigen kunnen de wissel bezet houden. Selecteer zo nodig terminals of waypoints om beide sporen te gebruiken.

Bovengrondse stations hebben lage perrons, meubilair en bij een kopstation een ingericht kopplein. Doorgaande stations hebben een voetgangersonderdoorgang. Verhoogde stations hebben een betonnen draagconstructie, kappen en één centrale entree op maaiveld; de sporen liggen op +12m. Ondergronds liggen de sporen op -18m met een vaste hal en straattoegang. Het openbare lightrailspoor heeft lage metalen buitenhekken en behoudt native tramverkeersgedrag.

[Installatie](docs/installatie.md) · [Teststatus en beperkingen](docs/teststatus.md)

## Stations maken

De standaardstations gebruiken dezelfde publieke API als externe ontwerpen. Makers kiezen standaardonderdelen, eigen modellen of geen optionele aankleding. De kern beheert twee sporen, vaste entrees, trappen, looproutes, terminals en wissels.

- [Developer kit: beginnen](docs/developer-kit-readme.md)
- [20m-componenten en aansluitmaten](docs/asset-kit-v1.md)
- [API v1 en gedeeld bouwmenu](docs/station-api-v1.md)
- [Zelfstandige voorbeeldmod](examples/contract_station/README.md)

Gebruik `station_menu.lua` in de constructionbeschrijving om eigen stations in het Light Rail-menu op te nemen. Een eigen namespace vereist geen aanpassing aan de hoofdmod.

## Bouwen en controleren

Windows, Python 3, PowerShell, Teal 0.24.8 en een geïnstalleerde Steam-versie van Transport Fever 3 zijn nodig. VS Code kan de meegeleverde `all_def.tl` gebruiken. `tlconfig.example.lua` is de lokale configuratiebasis.

```powershell
python scripts/build_ui.py
./scripts/convert_ui_icon.ps1
python scripts/test_station_contract.py
python scripts/test_native_layout.py
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_ui.lua
python scripts/check_ui.py
python scripts/package.py
python scripts/package_contract_example.py
python scripts/package_sdk.py
```

De drie ZIP's in `dist/` zijn de hoofdmod, de optionele voorbeeldmod en de developer kit. De UI is onderdeel van de hoofdmod. Native GUI-adapters worden tijdens de build afgeleid van de geïnstalleerde bronnen; de manifest-hashes staan in het pakket. [Architectuur](docs/architectuur.md) · [Credits](CREDITS.md).
