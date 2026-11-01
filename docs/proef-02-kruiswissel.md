# Proef 02: tweesporig kopstation met kruiswissel

Versie 0.2.2, revision 6. Dit is een nieuwe constructie naast de oude UM Surface Stop. Bestaande proefhaltes worden niet verbouwd.

## Plaatsen

1. Bewaar een kopie van de testsave en sluit de game af voordat je het nieuwe pakket uitpakt. Vervang de bestanden in dezelfde staging-modmap; voorkom een extra dubbele modmap.
2. Laad de testsave met Ultimate Metro ingeschakeld. Zoek in het menu voor wegstations **UM Crossover Terminus (Test)**, in het Nederlands **UM Kruiswisselkopstation (Test)**.
3. Plaats twee nieuwe kopstations op vrije, vlakke grond. Begin bij voorkeur met de stations en verbind ze daarna met gewone elektrische tramtrack. Beide ingangen moeten naar de verbinding wijzen. Draai het tweede station 180 graden.
4. De ingang is het enige korte stuk standaard tramtrack dat uit de voorkant steekt. Klik op het buitenste uiteinde hiervan om de verbinding te tekenen. De twee perronsporen eindigen aan de achterkant: daar hoort geen externe aansluiting.
5. Bij aansluiten op een bestaand doodlopend spoor is het buitenste ingangspunt ook het uitlijnpunt. Controleer de bouwpreview; een melding over kromming blijft een mislukte plaatsing. Forceer geen scheve aansluiting. Noteer of het vrij plaatsen wel lukt en het uitlijnen niet.
6. Verbind ook de remise met deze elektrische tramtrack. Maak een nieuwe lijn met alleen deze twee nieuwe stations, laat tien seconden lopen en controleer op lijnfouten.
7. Laat het diagnoselog beoordelen voordat je een voertuig inzet. Als er een pad is: test met slechts één omkeerbare Citylink. Controleer achtereenvolgens remise-uitrit, aankomst, vertrek, de wisselroute en omkeren. Een tweede voertuig en conflictveiligheid zijn nog geen onderdeel van deze proef.

## Ontwerp

Eén standaard tweerichtings-tramaansluiting loopt naar twee parallelle perronsporen met hartlijnen op y=-2,5 en y=+2,5 meter, zoals de native Underground Stop. Voor de perrons ligt een 30 meter lange kruiswissel: twee rechte verbindingen en twee kruislings lopende verbindingen met horizontale eindraaklijnen. Elk perron heeft een eigen terminal. De rijpaden zijn in beide richtingen gedefinieerd. Vanaf revision 5 gebruiken ze, net als de native Underground Stop, geen expliciete spoorreservering. Of de engine de kruising en het omkeren accepteert is niet bewezen; gebruik slechts een voertuig.

Het X-kruispunt bevat geen gezamenlijk tussenknooppunt en geen verborgen keerlus. De omkeerbeweging moet door de tramrouter worden geaccepteerd. De reizigers hebben een voetroute achter de spooreinden langs.

De lengtes 60/80/120 meter betreffen het perrondeel; de wisselstraat en aansluiting voegen aan de voorkant samen 50 meter toe. De eenvoudige grondafwerking en twee bestaande wachthuisjes maken de opstelling herkenbaar. De interne rails, wisseltongen, stootblokken en bovenleiding hebben nog geen complete 3D-weergave. De standaard aansluiting heeft wel zijn normale infrastructuurweergave. Dit is een routingproef, geen publiceerbaar station.

## Controle buiten het spel

De lokale controle verifieert dat beide aanrijsporen beide perronpunten kunnen bereiken, de wisselcurves zonder knik aansluiten en het uitlijnpunt overeenkomt met het externe aansluitpunt, voor alle drie de perronlengtes. De bestaande prototypecontrole en diagnosetest blijven slagen. Dit vervangt de speltest niet.

Het alleen-lezen diagnoserapport ondersteunt beide stationstypen en geeft voorrang aan maximaal vier terminals van de nieuwe kopstations. De oude stations mogen blijven staan als vergelijkingsmateriaal.

## Wat revision 5 corrigeert

Het spelrapport van revision 4 laat zien dat de stationrijpaden daadwerkelijk samenvallen met de externe tramnetwerkknooppunten. De eerdere veronderstelling dat alleen een losliggende aansluiting de oorzaak was, is daarmee niet houdbaar. Toch ontbreken alle gevonden terminalpaden nog.

De uitlijnmatrix is een kwartslag aangepast zodat de ingang langs het bestaande spoor hoort te liggen, in plaats van er haaks op. De grondvlakken en terreinuitlijning staan nu op de subconstructie, zoals de TF3-constructiedefinities voorschrijven. De terminalverwijzingen tellen de ruwe lane-nodes, inclusief de dubbele segmentuiteinden; de stop ligt daardoor nu op x=0 bij de perronmiddens, in plaats van op het begin van de perrons bij de wisselstraat. De lokale test leest de daadwerkelijk aangewezen node uit en controleert zijn positie.

De expliciete reserveringsvlag is uitgeschakeld om dichter bij de native tramhalte te blijven. Dit is een te testen configuratieaanpassing; het is geen vastgestelde oplossing voor de lijnfout. Extra alleen-lezen padproeven testen een enkele interne edge en een traject van twee edges in beide richtingen. De diagnose wordt na deze upgrade opnieuw gestart, ook wanneer de aansluitingen sinds de vorige save gelijk zijn.

**Plaats voor deze proef twee nieuwe kruiswisselkopstations.** Reeds gebouwde constructies bevatten hun eerder opgeslagen geometrie en haltepunten; alleen het pakket vervangen bouwt ze niet opnieuw. Bouw de nieuwe proefopstelling bij voorkeur apart, zodat de bestaande beschikbaar blijft voor vergelijking. Koppel alleen de nieuwe stations aan de nieuwe testlijn.

## Terugweg in revision 6

Het log van revision 5 toont voor beide kopstations: single-edge vooruit = 1, achteruit = 0; traject van twee edges vooruit = 2, achteruit = 0, voor TRAM en ELECTRIC_TRAM. Dit bewijst de blokkade op de geteste terugrichting binnen de stations. Het bewijst geen algemene onmogelijkheid om trams te laten keren.

Revision 6 voegt voor elk van de vier voertuiglanes een expliciete tegenrichting toe. Alle posities blijven gelijk; segmentvolgorde en raaklijnen worden omgekeerd. Daardoor bestaat een gerichte geometrische route van beide aanrijsporen naar beide perrons en terug. De spelengine moet dit nog bevestigen. De plaatsingscorrecties blijven behouden.

Plaats opnieuw twee nieuwe kruiswisselkopstations, maak een lijn tussen alleen die twee en laat tien seconden lopen. De extra proeven moeten nu laten zien of de terugweg binnen het station gevonden wordt. Gebruik pas na beoordeling van de lijnverbinding een voertuig. Een vindbaar pad is nog geen bewijs van veilig wisselgedrag of daadwerkelijk omkeren.
