# Teststatus 0.8.0

## Door de gebruiker bevestigd op het bovengrondse station

- Omkeren aan het perron, deuren en verlichting.
- Gewone native tramtrack en tramremise aansluiten.
- Meerdere voertuigen op twee drukke kruisende lijnen: wachten en verderrijden bij vrijgegeven wisselroutes.
- Voetgangers bereiken de halte en stappen in.
- Opslaan/herladen en opschoning van oude proefobjecten.

## Lokaal gecontroleerd in 0.8.0

- Bestaande station-ID, parameters, wisselopties en geometrie blijven behouden.
- Ondergronds zijn alle voertuigposities exact 18m lager, met dezelfde tangenten en reserveringsvlaggen.
- Native voetgangerslanen verbinden de publieke ingang op z=0 met beide perrons op z=-17,65.
- Native model-, botsings- en terreingeometrie wordt opgebouwd met de geïnstalleerde Lua-hulpfuncties. Alleen het ingangsvlak wordt bovengronds uitgelijnd.
- Snelheidsgrenzen: 80 km/u recht, 40 km/u wissel; omrekening naar m/s.
- Beide wisselopties, lokale afhankelijkheden, vertalingen, afbeeldingsformaten en zip-inhoud.

## Nog in de game te testen

Plaatsbaarheid van de ondergrondse versie, uitlijning en beeld van hal/wissel, tunnel aansluiten en doorrijden, openbare weg naar de ingang, instappen op beide perrons en opslaan/herladen met het nieuwe station. De lokale voetgangerscontrole bevestigt een verbonden pad, maar vervangt geen proef met passagiers in de game. Snelheidslimieten zijn maxima: voertuigen remmen ook voor de halte, bochten en reserveringen.
