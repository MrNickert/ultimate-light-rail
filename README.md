# Ultimate Light Rail

Versie 0.11.1, revision 36. Tramgebaseerde lightrailinfrastructuur voor Transport Fever 3. Interne mod-ID blijft `mrnickert_ultimate_metro` voor savecompatibiliteit.

## Eén configureerbaar station

Zoek **Lightrailstation / Light Rail Station** in het wegstationsmenu. Het native instellingenpaneel heeft precies drie keuzes:

| Instelling | Keuzes |
| --- | --- |
| Ligging | Bovengronds / Ondergronds |
| Stationstype | Doorgaand / Kopstation |
| Hek langs aansluiting | Nee / Ja; uitgeschakeld ondergronds |

Kopstations hebben altijd een kruiswissel, doorgaande stations nooit. Er is geen aparte wisselkeuze in het nieuwe menu. Standaard: bovengronds kopstation met hek. Perrons blijven 80m lang, twee perronsporen. De opties gelden bij nieuwe plaatsing; bestaande stations worden niet automatisch verbouwd.

Bovengronds gebruikt de doorgaande variant de geteste voetgangersonderdoorgang met drie straataansluitingen per perron. Het kopstation houdt het ingerichte kopplein. Hekken stoppen bij de perrons; de native randdecoratie verzorgt aansluitingen aan het netwerk.

Ondergronds liggen de rails op 18m diepte met een ingang aan straatniveau en native stationsmodellen/voetgangersroutes. De doorgaande ondergrondse variant is nieuw: twee tunnelverbindingen en geen gesloten kopwand. Gebruik de ondergrondse weergave in de werkbalk bij het aansluiten van tunnels. De liggingknop verandert de constructie, maar schakelt deze aparte weergaveknop niet automatisch om.

Het native onderdoorgang-icoon en de preview van het eerdere doorgaande station worden hergebruikt; geen nieuwe beeldgeneratie. De afbeelding wisselt niet mee met elke parameterkeuze.

## Bestaande saves

De drie afzonderlijke stations verdwijnen uit het bouwmenu, maar hun resource-ID's, oude parameters en scripts blijven aanwezig voor geplaatste stations. De oude kopstations behouden dus ook hun opgeslagen wisselkeuze. Eén nieuw constructiebestand bewaart voortaan de drie nieuwe instellingen. Er zijn geen automatische wereldwijzigingen of migratiehooks.

Gebruik [installatie-instructies](docs/installatie.md) en [teststatus](docs/teststatus.md). De gebruiker heeft 0.11.0 met het gecombineerde menu en alle stationvarianten getest en als foutloos bevestigd. 0.11.1 vervangt uitsluitend de menuafbeelding/preview en werkt de documentatie bij.

## Lightrailspoor

De losse **Lightrail / Light Rail**-optie blijft naast gewone tramtrack staan (vanaf 1925). Native rijstroken, richtingen, snelheid, trammodi, kosten en materialen blijven gelijk. Lage metalen buitenhekken gebruiken het native fence_metal_4m, proportioneel verkleind tot circa 1,36m. Geen extra onderhoud of snelheidsbonus; tunnels krijgen geen hek.

## Ontwikkelen

```powershell
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_terminus.lua
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_through_station.lua
python scripts/test_native_layout.py
python scripts/package.py
```

De native test draait ook de configuratiematrix: acht keuzes, automatische kruiswissel, ongewijzigde oude lay-outs, hekken zonder rijpadwijzigingen, beide bereikbare ondergrondse perrons en twee open tunnelaansluitingen. Het pakket bevat 38 runtimebestanden; alle lokale afhankelijkheden, vertalingen en native assetverwijzingen worden gecontroleerd. Deze controles bewijzen geen engineplaatsing, menuweergave of passagiersinstap van de nieuwe ondergrondse variant.

Stationslanen gebruiken 80 en kruiswissels 40 volgens de native constructieconventie; straatprofielsnelheden blijven m/s. Gebruiker bevestigde eerder beter rijgedrag; exacte maxima zijn niet gemeten. De losse historische Speed Probe zit niet in het hoofdpakket. Zie [credits](CREDITS.md) en [architectuur](docs/architectuur.md).
