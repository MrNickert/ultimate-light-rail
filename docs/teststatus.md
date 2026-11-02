# Teststatus 0.8.6

## Door de gebruiker bevestigd op het bovengrondse station

- Omkeren aan het perron, deuren en verlichting.
- Gewone native tramtrack en tramremise aansluiten.
- Meerdere voertuigen op twee drukke kruisende lijnen: wachten en verderrijden bij vrijgegeven wisselroutes.
- Voetgangers bereiken de halte en stappen in.
- Opslaan/herladen en opschoning van oude proefobjecten.

## Lokaal gecontroleerd in 0.8.1

- Bestaande station-ID, parameters, wisselopties en geometrie blijven behouden.
- Ondergronds zijn alle voertuigposities exact 18m lager, met dezelfde tangenten en reserveringsvlaggen.
- Native voetgangerslanen verbinden de publieke ingang op z=0 met beide perrons op z=-17,65.
- Native model-, botsings- en terreingeometrie wordt opgebouwd met de geïnstalleerde Lua-hulpfuncties. Alleen het ingangsvlak wordt bovengronds uitgelijnd.
- Snelheidsgrenzen: 80 km/u recht, 40 km/u wissel; omrekening naar m/s.
- Beide wisselopties, lokale afhankelijkheden, vertalingen, afbeeldingsformaten en zip-inhoud.

## Nog in de game te testen

Plaatsbaarheid van de ondergrondse versie, uitlijning en beeld van hal/wissel, tunnel aansluiten en doorrijden, openbare weg naar de ingang, instappen op beide perrons en opslaan/herladen met het nieuwe station. De lokale voetgangerscontrole bevestigt een verbonden pad, maar vervangt geen proef met passagiers in de game. Snelheidslimieten zijn maxima: voertuigen remmen ook voor de halte, bochten en reserveringen.

## Gebruikersproef en wijziging 0.8.1

De gebruiker bevestigde dat het ondergrondse station functioneert zoals verwacht en de hogere wisselsnelheid beter werkt. Versie 0.8.1 behoudt alle voertuigpaden en snelheden. Alleen de native stationshal en voetgangersingang zijn naar de kop verplaatst en gedraaid, met een zichtbare afsluitmuur. De nieuwe ingang en plaatsing moeten nog in de game worden getest. Menu-iconen en previews hebben nu echte alpha-transparantie.

## 0.8.2 bovengrondse aankleding

De gedeelde voertuigbouwer en de volledige ondergrondse variant blijven gelijk aan 0.8.1. De bovengrondse adapter voegt visuele perronvlakken en inrichting toe en zet alleen de bestaande voetgangerspunten op 0,25m hoogte. De visuele perrondefinitie bevat geen native transportmetadata. Bovenleidingsdraden zijn decoratieve modellen; de bestaande elektrische vervoersmodi blijven de werking bepalen. Nieuw te testen: visuele uitlijning, perronhoogte, vrije doorgang langs meubels, aansluiting van de verhoogde voetgangersingang op de straat en instappen.

## 0.8.4 spoorbedweergave

Gebruikersbeeld: zwarte en witte strepen op het spoorbed. De afgeplatte native perronvloer was op exact z=0 geplaatst, gelijk aan het terreinoppervlak. De drie extra spoorbedmodellen zijn verwijderd; de native asfaltgrondtextuur blijft actief. De controle bewaakt dat alleen de vier verhoogde perronmodules en het kopplein als perronmesh voorkomen. De visuele bevestiging van de hotfix volgt nog in de game.

## 0.8.4 tegelpatroon, tramstroken en groen

De vervormde pleinmodule wordt vervangen door vier native 5x10m verbindingsstukken (100% lengte, 90% breedte). Een oorspronkelijke vierpuntsstrook gebruikt het bestaande native tramspoor-materiaal, zonder spoorwegmodellen op maaiveld. Bomen, boombakken, plantenbakken en bloemstruiken staan alleen op het kopplein. Controleer in de game de decalweergave, wisselovergangen en wandelruimte; lokale controles vervangen de beeldproef niet.

## 0.8.5 compact plein en native kleurinvulling

Eén rij koptegels is verwijderd. De bomen en bloembakken staan dichter bij elkaar; de wandelverbinding loopt op x=81,5 naar een publieke toegang op x=85. Gedeelde voetgangerspunten worden één keer verplaatst, met opnieuw berekende tangenten. De native .street gebruikt zowel new_medium_tram_track als new_medium_tram_paving; de laatste ontbrak in de interne weergave. Beide lagen worden nu langs elk bestaand rijpad opgebouwd, op verschillende hoogten boven de grindgrond. Geen aanpassing aan voertuigroutes of de ondergrondse variant.

## Gebruikersbevestiging 0.8.5 en vervolg 0.8.6

Instappen via het compacte kopplein is bevestigd. De gebruiker ziet bij de wissel circa 13 km/u bij binnenkomst en 23 km/u bij vertrek; de tram versnelt zodra ongeveer 80% voorbij de wissel is. Dit bewijst nog niet welke engine-limiet de oorzaak is. De gewone 0.8.6 verandert de snelheid en rijgeometrie niet. Alleen de wisselondergrond wordt 11m breed. Een afzonderlijke read-only probe leest effectieve ingestelde en bochtlimieten uit; het engine-rapport is nog nodig voordat een snelheidsoplossing gekozen wordt.
