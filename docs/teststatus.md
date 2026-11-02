# Teststatus 0.8.2

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
