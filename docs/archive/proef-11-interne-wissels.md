# Proef 11: interne stationswissels

Versie 0.6.1 / revision 16. Dezelfde menu-entry: UM Twin Terminus (Test), Nederlands UM Dubbel Kopstation (Test).

## Waarom deze wijziging

De gebruiker kreeg bij revision 15 een volledig rode spoorpreview met Construction Not Possible. stdout.txt bevatte bij die poging geen specifieke foutcode of Lua-updatefout voor de nieuwe constructie. De precieze native afwijzingsvoorwaarde is daarom niet vastgesteld. Het is niet verantwoord de oorzaak zonder extra meting aan een bepaalde boog, afstand of andere mod toe te schrijven.

Revision 16 vermijdt de complexe root-STREET-knooppunten uit de geweigerde preview. Hij volgt de constructievorm van de native Underground Stop: een korte externe STREET-aansluiting en een intern stationsnetwerk. Hier gebruiken de interne voertuiglanes de vier vervoersmodi TRAM, ELECTRIC_TRAM, TRAM_TRACK en ELECTRIC_TRAM_TRACK, met forwardOnly=false en needsReservation=true. Dat is een nieuwe combinatie voor deze stationsgeometrie; de eerdere vier-modimetingen betroffen gegenereerde straatsegmenten, dus het nieuwe interne rijgedrag is nog niet bewezen.

## Opbouw

- Een rechte dubbele elektrische vooraansluiting van x=-130 tot x=-100.
- Twee interne rijpaden beginnen op x=-100,y=-2.5/+2.5, overeenkomstig de native dubbele tram-offsets.
- De sporen gaan geleidelijk naar y=-6/+6. Twee optionele kruisverbindingen lopen via een gedeelde kruiscoordinaat op x=-40,y=0.
- Twee perronsporen met haltepunten op x=40 en spooreinden op x=80.
- Elke terminal verwijst naar de daadwerkelijk aangewezen raw node in zijn eigen interne laneList: {0,7} en {1,7}. Er zijn geen directe terminalverwijzingen naar de dubbele ingang.
- Een eilandperron met voetgangersverbinding achter de spooreinden.

Voor de weergave worden bestaande Urban Games-railsegmenten en stootblokken als modellen geplaatst. Het zijn decoratieve verwijzingen naar de geinstalleerde game; er wordt geen trein-infrastructuur gebouwd en er worden geen assets meegeleverd. De kleine railstukken volgen de interne curves als koorden. Wisseltongen, ballastovergangen en interne bovenleiding zijn voorlopig niet volledig uitgewerkt. De weergave is geen zelfstandig bewijs van een verbonden rijpad.

## Eerste speltest

1. Vervang de bestanden en laad je testkopie opnieuw. Afsluiten van de game is niet vereist in de gebruikte werkwijze.
2. Selecteer **UM Twin Terminus (Test)** / **UM Dubbel Kopstation (Test)** op ruime vrije vlakke grond. Laat de optie **Crossover / Kruiswissel** op **Scissors crossover / Met kruiswissel** staan.
3. Als de preview plaatsbaar is: plaats een station, laat tien seconden lopen en pauzeer. Nog geen lijn, aansluiting of voertuig toevoegen. Meld het resultaat voor de diagnoselogcontrole.
4. Is de preview opnieuw rood: kies **No crossover / Zonder wissel** op dezelfde plaats en meld of dat wel plaatsbaar wordt. Plaats die referentievariant alleen als die groen is. Dit onderscheidt de basisopbouw van de kruisverbindingen zonder een nieuwe pakketversie.

De diagnose uit revision 15 meet de daadwerkelijk gegenereerde ingangslanes naar beide interne terminals en terug. Hij werkt ook bij slechts een nieuw kopstation. De oude werkende haltes en profielen blijven ongewijzigd.

## Controles en beperking

Lokaal zijn beide wisselopties getest: slechts een rechte externe straat-edge, correcte interne terminal- en reizigersverwijzingen, vier modi op alle voertuiglanes, twee aparte perronsporen en geen dubbele of omgekeerd overlappende curves. Zonder wissel kan in het geometrische model elk ingangsspoor alleen zijn eigen perron bereiken; met wissel kunnen beide ingangssporen beide perrons bereiken. Decoratieve modeltransformaties zijn eindig en de modellen bestaan in de geinstalleerde game met lege native metadata.

Deze controles vervangen de native bouw- en routecontrole niet. Plaatsbaarheid, verbinden van interne lanes aan de externe straat, functioneren van de kruiswissel, voertuigomkering en reserveringsveiligheid zijn nog open voor deze constructie.

## Uitkomst en ontwerpcorrectie

Deze variant was plaatsbaar. De log vond per ingangslane alleen het eigen perron heen en terug, niet de kruiselingse perronroutes. De gebruiker wees de spoorweguitstraling en grote wisselstraat af als verkeerde ontwerprichting. Proef 12 verkleint de opbouw naar tramspoorafstand, verwijdert dwarsliggers/stootblokken en maakt de wisselaansluitingen geometrisch tangentieel.
