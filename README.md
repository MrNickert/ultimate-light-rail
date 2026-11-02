# Ultimate Light Rail

Versie 0.10.4, revision 34. Voorheen **Ultimate Metro**. Een tramgebaseerde stationsset voor lightrail in Transport Fever 3, met gewone elektrische tramtrack en omkeerbare voertuigen zoals Citylink.

## Lightrailspoor

**Lightrail / Light Rail** staat naast de gewone tramtrack bij de kleine wegen/tram-infrastructuur (vanaf 1925). Het gebruikt exact dezelfde native rijstroken, richtingen, snelheid, trammodi, kosten en materialen. De verschillen zijn een eigen menuafbeelding en een laag metalen hek langs beide buitenzijden: het native industriële fence_metal_4m, proportioneel verkleind tot 40% (circa 1,36m hoog). De hekken gebruiken de native randdecoratie, met nul extra onderhoud en zonder geluid-/snelheidsbonus. Tunnels krijgen geen hek. De bestaande native tramoptie blijft beschikbaar.

De gebruiker heeft bevestigd dat kruisingen in 0.10.0 vrij blijven. De hekpanelen stonden toen dwars; 0.10.1 draait ze 90 graden. Controleer de gecorrigeerde hekpositie, bochten, hellingen en aansluitingen op stations nog in-game. Ook met meerdere trams testen; de eerdere succesvolle native tramproef is geen bewijs voor deze nieuwe decoratie. Er worden geen bestaande sporen of stations automatisch vervangen.

De bovengrondse stations hebben hetzelfde hek langs de spooraansluitingen: bij het kopstation tot aan het begin van de perrons en bij het doorgaande station aan beide uiteinden. Langs de perrons, toegangen en het kopplein staat geen hek. De ondergrondse variant is ongewijzigd. Voor deze aankleding een nieuw station plaatsen; bestaande stations worden niet automatisch verbouwd. Op de aanklikbare buitenste 10m verzorgt de game de hek-randdecoratie; vaste hekmodellen staan alleen op de interne aansluitingen/wisselstraat en hebben geen botsingsvolume. De menuafbeelding toont een korte sectie met palen buiten de hekken, dwarskabels en twee bovenleidingen. De botsings- en aansluitcorrectie moet nog in-game worden getest.

## Stations

- **Metro Kopstation / Metro Terminus**: twee perrons van 80m, compacte kruiswissel, bestraat kopplein, bomen en bloembakken.
- **Ondergronds Metro Kopstation / Underground Metro Terminus**: perrons op 18m diepte met voetgangerstoegang vanaf straatniveau.
- **Metro Doorgaand Station / Metro Through Station**: twee perrons van 80m, spooraansluitingen aan beide uiteinden en een voetgangersonderdoorgang. Elk perron heeft drie mogelijke straataansluitingen: begin, midden en einde.

Alle drie staan in het wegstationsmenu. De doorgaande variant gebruikt vooralsnog het native onderdoorgang-icoon. Perronlengte en aantal perronsporen staan vast. Het vervolgdoel is één configureerbare stationfamilie met type, lengte en perronindeling, met behoud van bestaande saveverwijzingen.

## Installeren en bestaande saves

Pak `ultimate-light-rail-0.10.4.zip` uit in je bestaande staging_area en herlaad de save. Zie [installatie](docs/installatie.md).

**De interne map en mod-ID blijven `mrnickert_ultimate_metro`.** Dit voorkomt dat huidige stations en saves hun resources kwijtraken. Deze versie voegt alleen een apart spoorprofiel met hek toe; bestaande stationsbestanden blijven gelijk. Stations opnieuw plaatsen is niet nodig. Verwijder de mod niet zolang een save zijn stations bevat.

De huidige projectmap/repository kan de oude naam behouden. De spelnaam wordt bepaald door de modmetadata.

## Bevestigde werking

De gebruiker heeft het kopstation getest met stoppen/keren, instappen, meerdere kruisende lijnen, wachten en vrijgeven van wisselroutes, en opslaan/herladen. De doorgaande variant is als functioneel geslaagd geaccepteerd na in-/uitstappen op beide perrons. Zie [teststatus](docs/teststatus.md) voor de precieze bevestigingen en resterende meetpunten.

De gebruiker meldt betere snelheid na de correctie in 0.9.1. Stationslanen krijgen rechtstreeks 80 en wissels 40; het aparte straatprofielveld `speed` behoudt zijn omrekening naar m/s. Exacte maxima zijn niet gemeten. Voertuigen kunnen ook afremmen voor haltes, bochten en reserveringen.

De losse, optionele **Ultimate Metro Speed Probe** behoudt zijn historische naam. Hij zit niet in het hoofdpakket en verandert geen stations of voertuigen.

## Ontwikkelen

```powershell
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_terminus.lua
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_through_station.lua
python scripts/test_native_layout.py
python scripts/package.py
```

Het pakket bevat 33 runtimebestanden. Alle lokale afhankelijkheden, vertalingen, native assetverwijzingen en pakketinhoud worden gecontroleerd. Er zijn geen automatische wereldwijzigingen of diagnosehooks in de hoofdmod. Modellen, materialen en texturen worden uit de geïnstalleerde game hergebruikt; enkele visuele wrappers en vlakke tramstroken zijn van dit project. De twee eigen menuillustraties zijn gegenereerde previews, geen screenshots. Zie [credits](CREDITS.md) en [architectuur](docs/architectuur.md).
