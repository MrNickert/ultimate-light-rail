# Ultimate Light Rail

Versie **0.17.0**, modrevision **46**, stationscontract **API v1**. Tramgebaseerde lightrailstations en spoor voor Transport Fever 3. De interne mod-ID blijft `mrnickert_ultimate_metro` voor savecompatibiliteit.

## Voor spelers

Kies **Lightrailstation / Light Rail Station** in het wegstationsmenu.

| Instelling | Keuzes |
| --- | --- |
| Ligging | Bovengronds / Ondergronds / Verhoogd |
| Stationstype | Doorgaand / Kopstation |
| Perronlengte | 40 / 60 / 80 / 100 / 120 meter |
| Hek langs aansluiting | Nee / Ja; ondergronds uitgeschakeld |

Alle stations hebben twee perronsporen. Kopstations hebben automatisch een kruiswissel. De lightrail gebruikt tramvoertuigen en sluit op native elektrische tramtrack aan. Het openbare Lightrailspoor volgt het normale native tramgedrag, met lage metalen buitenhekken.

Bovengronds blijven de stations standaard zonder kap, met hokjes en meubilair. Het doorgaande station heeft een vaste voetgangersonderdoorgang en meerdere publieke aansluitingen. Het kopstation heeft een ingericht kopplein. Elevated heeft een betonnen draagconstructie, perronkappen en één centrale entree op maaiveld; spoorhoogte +12m. Ondergronds liggen de sporen op -18m met een vaste native hal en straattoegang.

Gebruik voertuigen die binnen de gekozen perronlengte passen: te lange voertuigen kunnen een kruiswissel geblokkeerd houden. [Installeren en testen](docs/installatie.md).

## De standaardstations gebruiken zelf het contract

Vanaf 0.17.0 kiezen de inbegrepen bovengrondse/elevated ontwerpen expliciet dezelfde 20m-perron- en dakcomponenten die een externe maker kan aanleveren. Ze hebben geen aparte publieke bouwroute. De native ondergrondse hal blijft een vaste kernassemblage en loopt eveneens via de API.

De 20m-overstap verandert de zichtbare modelopbouw en tegel-/dakherhaling. De oude 40m-native helpermodellen blijven nodig voor legacy en vaste korte pas-/trapstukken. Ze zijn geen algemene uitzonderingsroute voor onze nieuwe standaardontwerpen.

Geplaatste stations worden niet automatisch herbouwd. Alle construction-ID's, opgeslagen keuze-indexen en standaardlengte van 80m blijven behouden. Oude verborgen stations blijven laadbaar; hun scripts behouden de vorige werking.

## Voor assetmakers

Een ontwerp kiest per onderdeel **standaard**, **eigen model** of **geen**. Beschikbaar: perron, hokje, kap, bomen, plantenbakken, bankjes, prullenbakken en lampen. De kern houdt spoorindeling, twee sporen, vaste perronbreedte/hoogte, entrees, trappen en routes in beheer.

- [Handleiding en aansluitmaten](docs/asset-kit-v1.md)
- [API-schema en compatibiliteit](docs/station-api-v1.md)
- [Zelfstandige voorbeeldmod](examples/contract_station/README.md)

Gewone eigen perron- en dakmodules zijn exact 20m. Korte passtukken, trapzones en de ondergrondse hal blijven vast. Nieuwe modellen moeten binnen het referentieprofiel passen; de API controleert niet automatisch alle externe mesh- en collisiongeometrie. Nieuwe mods die de 0.17-helpers of entreebankvariant gebruiken, vereisen minimaal revision 46.

## Wat is bewezen?

Automatisch: alle **72 functionele referentiegevallen** behouden hun volledige uitvoer behalve de visuele modellen. Bij **27 ondergrondse/legacy-gevallen** is ook de volledige modeluitvoer gelijk gebleven. Aanvullend zijn perron-/kapdekking, vaste trappen, 20m-modules, API-validatie en ongewijzigde caller-tabellen gecontroleerd.

In-game: de gebruiker bevestigde de eerdere standaardstations en daarna plaatsing van de losse Component Kit Example met/zonder kap op 40m en 80m. Instappen en wissels zijn bevestigd in twee geteste voorbeeldvarianten. Dit bewijst de externe modkoppeling voor die voorbeelden, niet alle mogelijke modellen en varianten. De nieuwe standaardassemblage van 0.17.0 vraagt nog een visuele/functionele eindcontrole. [Volledige teststatus](docs/teststatus.md).

## Ontwikkelen

```powershell
python scripts/test_station_contract.py
python scripts/test_native_layout.py
python scripts/package.py
python scripts/package_contract_example.py
python scripts/package_sdk.py
```

Native tests gebruiken de geïnstalleerde spelbestanden en `C:\Program Files\Teal\0.24.8\tl.exe`; er worden geen native mesh-/texturebinaries meegeleverd. Het hoofdarchief bevat alleen de runtime-mod. De voorbeeldmod en makersdocumentatie zijn aparte archieven. Geen automatische wijzigingen aan saves, routes of native resources.
