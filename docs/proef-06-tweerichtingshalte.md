# Proef 06: gemeten tweerichtingsprofiel aan een halte koppelen

Versie 0.4.1 / revision 11. Nieuwe menu-entry: UM Bidirectional Stop (Test), Nederlands UM Tweerichtingshalte (Test).

## Uitkomst van de richtingproef

Het native diagnoselog van 1 november 2026, constructie 327518, toont:

| Referentie | forwardOnly | needsReservation | TRAM en ELECTRIC_TRAM | TRAM_TRACK en ELECTRIC_TRAM_TRACK |
| --- | --- | --- | --- | --- |
| A, enkele tram-lane, STREET | true | false | vooruit 1 edge, terug 0 | beide richtingen 0 |
| B, hetzelfde met extra spoortrammodi, STREET | false | true | beide richtingen 1 edge | beide richtingen 1 edge |
| C, native treinspoor, TRACK | false | true | beide richtingen 0 | beide richtingen 1 edge |

A en B verschillen alleen in de modeverzamelingen. Op deze ene geometrie zijn die extra modi dus voldoende om de engine een gereserveerde edge met terugrichting te laten genereren, ook voor gewone TRAM/ELECTRIC_TRAM-padvragen. Er zijn geen dubbele geometrische edges of omkeercommando's nodig voor dit gemeten resultaat. Dit bewijst uitsluitend bereikbaarheid op het geisoleerde segment, niet dat een voertuig bij een station kan keren.

## Nieuwe constructie

De nieuwe halte is een afzonderlijke kopie van de in revision 9 geaccepteerde spoorgebonden doorgaande halte. De enige geometrie-invoerwijziging is de verwijzing naar precies het reeds gemeten mode_probe.street_template. Het haltepunt blijft vehicleNode={-1,1}, het profiel blijft STREET met een lane en de terminalmodi blijven TRAM/ELECTRIC_TRAM. Er zijn geen interne voertuig-laneLists. De 80 meter straatsegmenten, voetgangersroutes, shelter, terrein en kosten blijven gelijk.

De eerdere haltes en het gemeten profiel worden niet gewijzigd. Gebouwde eenrichtingshaltes worden dus niet alsnog tweerichtingshaltes. De diagnose geeft voorrang aan de nieuwe terminals en vermeldt nu ook de native forwardOnly/reservation-vlaggen op hun echte straatsegmenten.

## Speltest

1. Bewaar de huidige testsave met de richtingproef en oude haltes als referentie.
2. Vervang de bestanden in dezelfde staging-modmap en laad de save opnieuw. Afsluiten van de game is niet vereist in de werkwijze van de gebruiker.
3. Zoek **UM Bidirectional Stop (Test)** / **UM Tweerichtingshalte (Test)**. Plaats twee nieuwe exemplaren op vrije vlakke grond. De oude Track-bound Stop is uitsluitend de eerdere eenrichtingsreferentie.
4. Verbind de twee nieuwe haltes via gewone elektrische tramtrack, zoals in de geslaagde eenrichtingstest. Laat de buitenste uiteinden doodlopen: deze proef bevat geen externe keerlus.
5. Maak een nieuwe lijn met alleen deze twee nieuwe haltes. Laat tien seconden lopen, pauzeer en meld het resultaat, ook als de lijn nog een fout geeft.
6. Zet nog geen voertuig in. Eerst moeten het native diagnoselog en de lijnplanner een heen- en terugverbinding aantonen. Daarna volgt een afzonderlijke test met een Citylink voor remise-uitrit, aankomst, stilstand en daadwerkelijk keren.

## Wat nog open is

Plaatsbaarheid van de nieuwe combinatie, routebereikbaarheid tussen haltes, lijnplanneracceptatie, voertuigomkering, passagiersafhandeling en reserveringsveiligheid zijn nog niet getest. Een pad in beide richtingen is geen bewijs dat een tram bij de terminal de rijrichting mag veranderen. De engine kan extra voertuig- of lijnvoorwaarden stellen.

De gekozen ontwikkelkoers blijft eerst tram als basis onderzoeken vanwege de bestaande lightrailvoertuigen en mogelijke wegintegratie. Een eigen lightrail-infrastructuur is een productrichting; een overstap naar treinspoor is alleen nodig als de benodigde functies binnen de tramroute onhaalbaar blijken. Een overgang tussen trein- en tramsporen is geen verplichte scope.
