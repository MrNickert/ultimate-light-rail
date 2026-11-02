# Installatie 0.8.4

1. Bewaar je werkende test-save als terugvalpunt.
2. Pak `ultimate-metro-0.8.4-clean.zip` uit in de bestaande `staging_area`. De map in de zip heet `mrnickert_ultimate_metro`. Bij een schone installatie vanaf 0.7.0 mogen de bestanden worden overschreven: er verdwijnen geen runtimebestanden. Bij oudere proefversies moet de complete modmap worden vervangen zodat oude diagnosehooks niet blijven staan.
3. Laad je save opnieuw met Ultimate Metro actief. De game hoeft niet afgesloten te worden.
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

Gebruik `ultimate-metro-0.8.4-clean.zip`. Herlaad de save en plaats één nieuw **Metro Kopstation** om de aankleding te bekijken. Beide perrons zijn 80m lang, 5m breed en circa 25cm hoog. De kop heeft een bestraat plein. Controleer de verhoogde toegang en het instappen. Bestaande geplaatste stations worden niet automatisch verbouwd. De ondergrondse variant is in deze versie niet aangepast.

## Hotfix 0.8.4

De overlappende modellen op het spoorbed zijn verwijderd. Herlaad de save en plaats één nieuw bovengronds kopstation. Controleer het asfalt onder de rails op normale hoogte en ingezoomd. Een al geplaatst 0.8.2-station bewaart zijn oude modellen totdat het opnieuw wordt opgebouwd; alleen herladen verwijdert die niet gegarandeerd.

## Visuele controle 0.8.4

Plaats een nieuw bovengronds kopstation na herladen. Controleer het tegelpatroon op het kopplein, het tramspoor bij de aansluiting en in de kruiswissel, de bomen en bloemen, vrije doorgang op het plein en instappen. De rijpaden en snelheden zijn behouden. Nieuwe tramstroken gebruiken de native transparante tramtextuur boven het asfalt; de visuele aansluiting moet nog in de engine worden beoordeeld.
