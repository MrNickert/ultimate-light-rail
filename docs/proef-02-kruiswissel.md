# Proef 02: tweesporig kopstation met kruiswissel

Versie 0.2.0, revision 4. Dit is een nieuwe constructie naast de oude UM Surface Stop. Bestaande proefhaltes worden niet verbouwd.

## Plaatsen

1. Bewaar een kopie van de testsave en sluit de game af voordat je het nieuwe pakket uitpakt. Vervang de bestanden in dezelfde staging-modmap; voorkom een extra dubbele modmap.
2. Laad de testsave met Ultimate Metro ingeschakeld. Zoek in het menu voor wegstations **UM Crossover Terminus (Test)**, in het Nederlands **UM Kruiswisselkopstation (Test)**.
3. Plaats twee nieuwe kopstations op vrije, vlakke grond. Begin bij voorkeur met de stations en verbind ze daarna met gewone elektrische tramtrack. Beide ingangen moeten naar de verbinding wijzen. Draai het tweede station 180 graden.
4. De ingang is het enige korte stuk standaard tramtrack dat uit de voorkant steekt. Klik op het buitenste uiteinde hiervan om de verbinding te tekenen. De twee perronsporen eindigen aan de achterkant: daar hoort geen externe aansluiting.
5. Bij aansluiten op een bestaand doodlopend spoor is het buitenste ingangspunt ook het uitlijnpunt. Controleer de bouwpreview; een melding over kromming blijft een mislukte plaatsing. Forceer geen scheve aansluiting. Noteer of het vrij plaatsen wel lukt en het uitlijnen niet.
6. Verbind ook de remise met deze elektrische tramtrack. Maak een nieuwe lijn met alleen deze twee nieuwe stations, laat tien seconden lopen en controleer op lijnfouten.
7. Laat het diagnoselog beoordelen voordat je een voertuig inzet. Als er een pad is: test met slechts één omkeerbare Citylink. Controleer achtereenvolgens remise-uitrit, aankomst, vertrek, de wisselroute en omkeren. Een tweede voertuig en conflictveiligheid zijn nog geen onderdeel van deze proef.

## Ontwerp

Eén standaard tweerichtings-tramaansluiting loopt naar twee parallelle perronsporen met hartlijnen op y=-2,5 en y=+2,5 meter, zoals de native Underground Stop. Voor de perrons ligt een 30 meter lange kruiswissel: twee rechte verbindingen en twee kruislings lopende verbindingen met horizontale eindraaklijnen. Elk perron heeft een eigen terminal. De rijpaden zijn in beide richtingen gedefinieerd en vragen reservering aan. Dat laatste bewijst nog niet dat de engine de kruising veilig afhandelt.

Het X-kruispunt bevat geen gezamenlijk tussenknooppunt en geen verborgen keerlus. De omkeerbeweging moet door de tramrouter worden geaccepteerd. De reizigers hebben een voetroute achter de spooreinden langs.

De lengtes 60/80/120 meter betreffen het perrondeel; de wisselstraat en aansluiting voegen aan de voorkant samen 50 meter toe. De eenvoudige grondafwerking en twee bestaande wachthuisjes maken de opstelling herkenbaar. De interne rails, wisseltongen, stootblokken en bovenleiding hebben nog geen complete 3D-weergave. De standaard aansluiting heeft wel zijn normale infrastructuurweergave. Dit is een routingproef, geen publiceerbaar station.

## Controle buiten het spel

De lokale controle verifieert dat beide aanrijsporen beide perronpunten kunnen bereiken, de wisselcurves zonder knik aansluiten en het uitlijnpunt overeenkomt met het externe aansluitpunt, voor alle drie de perronlengtes. De bestaande prototypecontrole en diagnosetest blijven slagen. Dit vervangt de speltest niet.

Het alleen-lezen diagnoserapport ondersteunt beide stationstypen en geeft voorrang aan maximaal vier terminals van de nieuwe kopstations. De oude stations mogen blijven staan als vergelijkingsmateriaal.
