# Installatie 0.10.3

Pak `ultimate-light-rail-0.10.3.zip` uit in de bestaande staging_area en overschrijf de modbestanden. De interne map blijft `mrnickert_ultimate_metro`. Herlaad de save; de game hoeft niet afgesloten.

Zoek **Lightrail / Light Rail** naast de gewone tramtrack (kleine wegen/tram-infrastructuur, vanaf 1925). Teken een nieuwe elektrische verbinding; bestaande rails krijgen niet automatisch een hek. Voor de nieuwe hekken langs stationsaansluitingen plaats je een nieuw bovengronds station. De hekjes stoppen vóór het perron; bestaande stations blijven werken zonder automatische verbouwing.

Test ook direct vastklikken van een nieuw kopstation en doorgaand station aan bestaand spoor, aan beide stationseinden en bij een T-aansluiting. Controleer dat de bouwpreview geen Collision door hekmodellen geeft en hekken niet over de kruising doorlopen.

Controleer beide buitenhekken, bocht, helling en aansluitingen op gewone tramtrack/stations. Maak een wegkruising: de railovergang moet native blijven en de hekken mogen die niet afsluiten. Controleer ook tunnel/brug, twee of meer trams en opslaan/herladen. Deze nieuwe decoratie is nog niet in-game gevalideerd.

## Eerdere installatie-instructies

# Installatie 0.9.3

1. Bewaar je werkende test-save als terugvalpunt.
2. Pak `ultimate-light-rail-0.9.3.zip` uit in de bestaande `staging_area`. De map in de zip heet `mrnickert_ultimate_metro`. Bij een schone installatie vanaf 0.7.0 mogen de bestanden worden overschreven: er verdwijnen geen runtimebestanden. Bij oudere proefversies moet de complete modmap worden vervangen zodat oude diagnosehooks niet blijven staan.
3. Laad je save opnieuw met Ultimate Light Rail actief. De game hoeft niet afgesloten te worden.
4. Open het wegstationsmenu. Je ziet **Metro Kopstation** en **Ondergronds Metro Kopstation**, elk met een eigen afbeelding.
5. Plaats eerst een nieuw ondergronds kopstation op vlak terrein. Houd de ingang op straatniveau bereikbaar vanaf een gewone weg. De ingang staat boven het kopse einde van de perrons, aan de tegenoverliggende kant van de kruiswissel. De weg sluit aan op de voorkant van het ingangsplein.
6. Sluit gewone elektrische tramtrack in een tunnel aan op de dubbele vooraansluiting op **18 meter diepte**. Het station heeft alleen vooraan een spooraansluiting.
7. Test een lijn en een omkeerbaar voertuig. Controleer de tunnelovergang, stoppen/keren, bereikbaarheid van beide perrons en instappen. Sla daarna op en laad opnieuw.

Het rij-/keer-/wisselprincipe is overgenomen uit het werkende bovengrondse station. De ondergrondse plaatsing, tunnelaansluiting en toegang zijn nieuwe integratiepunten en nog niet in de engine bevestigd. Test daarom in een kopie van je werkende save.

De nieuwe maximumsnelheden zijn 80 km/u op rechte stationssporen en 40 km/u op de kruiswissel. Bestaande geplaatste stations kunnen hun opgeslagen oude geometrie en snelheden behouden. Gebruik voor de eerste snelheidsproef een nieuw station. De mod voert geen automatische verbouwing van bestaande stations uit.

Staging-map:

```text
C:\Program Files (x86)\Steam\userdata\87691647\3493540\local\staging_area
```

## Wijziging 0.8.1

Transparante menuafbeeldingen en een gedraaide ingang boven de gesloten kop. Plaats een nieuw ondergronds station om deze indeling te beoordelen; opgeslagen stations worden niet automatisch verbouwd. Rijden en hogere wisselsnelheid van 0.8.0 zijn door de gebruiker bevestigd. Controleer voor de verplaatste ingang opnieuw de plaatsing en voetgangerstoegang.

## 0.8.2 bovengrondse aankleding

Gebruik `ultimate-light-rail-0.9.3.zip`. Herlaad de save en plaats één nieuw **Metro Kopstation** om de aankleding te bekijken. Beide perrons zijn 80m lang, 5m breed en circa 25cm hoog. De kop heeft een bestraat plein. Controleer de verhoogde toegang en het instappen. Bestaande geplaatste stations worden niet automatisch verbouwd. De ondergrondse variant is in deze versie niet aangepast.

## Hotfix 0.8.4

De overlappende modellen op het spoorbed zijn verwijderd. Herlaad de save en plaats één nieuw bovengronds kopstation. Controleer het asfalt onder de rails op normale hoogte en ingezoomd. Een al geplaatst 0.8.2-station bewaart zijn oude modellen totdat het opnieuw wordt opgebouwd; alleen herladen verwijdert die niet gegarandeerd.

## Visuele controle 0.8.4

Plaats een nieuw bovengronds kopstation na herladen. Controleer het tegelpatroon op het kopplein, het tramspoor bij de aansluiting en in de kruiswissel, de bomen en bloemen, vrije doorgang op het plein en instappen. De rijpaden en snelheden zijn behouden. Nieuwe tramstroken gebruiken de native transparante tramtextuur boven het asfalt; de visuele aansluiting moet nog in de engine worden beoordeeld.

## Controle 0.8.5

Plaats na herladen een nieuw bovengronds station. Het kopplein heeft één rij van 5m; beide bomen en vier bloembakken zijn behouden. Controleer de verkorte voetgangerstoegang en het instappen. Vergelijk bij de linker aansluiting nu ook de trambestrating/kleur onder de rails, door de wissel en tussen de perrons. De native aansluiting en voertuiglanen zijn niet veranderd. De visuele overeenkomst moet in de game worden bevestigd.

## Snelheidsmeting

Pak de losse ultimate-metro-speed-probe-0.1.0.zip naast de hoofdmod uit in staging_area. Activeer **Ultimate Metro Speed Probe** in de mods van je save. Herlaad een save met bestaande metrokopstations en laat ongeveer 10 seconden doorlopen. Er hoeft geen nieuw station of voertuig geplaatst te worden voor de meting. Het rapport staat in crash_dump/stdout.txt onder [UMSPEED]. De meetmod is veilig uit te schakelen na de diagnose: hij voegt geen wereldobjecten toe. Plaats voor de bredere grondweergave van de hoofdmod wel een nieuw station, omdat opgeslagen constructies hun oude grondvlak behouden.

## Eerste spelproef doorgaand station 0.9.0

1. Werk de hoofdmod bij en herlaad de test-save. De game hoeft niet afgesloten te worden.
2. Kies **Metro Doorgaand Station / Metro Through Station** in het wegstationsmenu. Het gebruikt voor deze proef een native onderdoorgang-icoon.
3. Plaats het op vlak terrein tussen de bestaande eindstations. Beide uiteinden zijn open voor gewone elektrische tramtrack. Gebruik de doorgaande variant, niet een bestaand kopstation.
4. Verbind de twee spooruiteinden en breng een gewone weg dicht bij één van de zijtoegangen aan het begin van de perrons. Begin met een weg aan één kant: zo kun je ook de toegang tot het andere perron via de onderdoorgang testen.
5. Voeg het station als tussenhalte aan een lijn toe. Controleer de heen- en terugrichting met een voertuig; de twee perrons hebben tegengestelde rijrichtingen.
6. Controleer de trapopeningen, zichtbare perronnaden, passagiers die via de trappen het andere perron bereiken en instappen. Plaatsing en routeerbaarheid zijn nog niet in de engine bevestigd.
7. Sla op en laad opnieuw. De bestaande kopstations zijn in deze versie niet verbouwd.

De eerste doorgaande variant heeft 80m perrons en twee perronsporen. Instelbare lengte, type en aantal perrons volgen als aparte uitbreiding. Het snelheidsvraagstuk bij de kopstationwissel blijft geparkeerd; deze versie wijzigt die limieten of geometrie niet.

## Snelheidstest 0.9.1

Herlaad na bijwerken en plaats één nieuwe doorgaande halte. Bestaande geplaatste stations kunnen hun opgeslagen oude limieten behouden. Laat een tram op een vrije lijn door de halte rijden en vergelijk met de eerdere 23 km/u. Controleer na deze proef ook een nieuw kopstation als de doorgaande variant sneller rijdt. De beoogde maxima blijven recht 80 en wissel 40; de engine kan nog lager uitkomen door voertuigmaximum, optrekken, afremmen, bochten en reserveringen. De meetmod is optioneel voor verdere diagnose.

## Toegangstest 0.9.2

Herlaad en plaats een nieuw doorgaand station langs een gewone weg. Aan beide perrons zijn nu aansluitingen bij begin, midden en einde. De weg moet dicht bij de toegangspunten liggen om de korte grijze verbindingspaden te laten ontstaan. Controleer de drie aansluitingen langs de weg en eventueel ook de andere perronzijde met een tweede weg. Controleer instappen en de onderdoorgang. Bestaande geplaatste stations kunnen de oude twee ingangen behouden totdat hun constructie opnieuw wordt opgebouwd.

## Hernoeming 0.9.3

De zichtbare modnaam is nu **Ultimate Light Rail**. De interne ID en map in de zip blijven `mrnickert_ultimate_metro` voor bestaande saves. Werk dezelfde bestaande modmap bij; maak geen tweede kopie met een nieuwe mod-ID. Na herladen verschijnt de nieuwe naam. Voor deze hernoeming hoef je geen stations opnieuw te plaatsen: alle stationsbestanden en verwijzingen blijven gelijk.

De huidige stationnamen in het bouwmenu blijven Metro Kopstation, Ondergronds Metro Kopstation en Metro Doorgaand Station. De Git-repository/projectmap hoeft voor de spelnaam niet te worden hernoemd.
