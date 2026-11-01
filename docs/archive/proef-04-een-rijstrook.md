# Proef 04: directe haltebinding met een tramrijstrook

Versie 0.3.1 / revision 9. Naam in het menu blijft UM Track-bound Stop (Test), Nederlands UM Spoorgebonden Halte (Test).

## Vastgestelde fout

Bij selecteren van revision 8 weigert TF3 de constructiepreview. stdout.txt meldt: EdgeList node reference 1 refers to an edge with multiple lanes with transport modes, ConstructionRep.cpp:1070. Dit is een validatiefout voordat een constructie geplaatst is. Er is dus nog geen terminalkoppeling of werking aangetoond.

De gewone tramtemplate heeft twee lanes voor dezelfde terminalmodi TRAM en ELECTRIC_TRAM. De overgenomen railstationbinding vehicleNode={-1,1} moet naar precies een passende lane kunnen verwijzen. Revision 9 gebruikt een eigen interne STREET-template met een forward=true lane op offset=0, verder afgeleid van het native tramprofiel. Er worden geen globale tramprofielen gewijzigd. De twee echte segmenten door de halte en de directe middenverwijzing blijven gelijk.

**Dit is een eenrichtingsproef.** Het lost geen omkeren, tegenverkeer, kopstation of wisselrouting op. We onderzoeken uitsluitend of de engine een halte rechtstreeks aan een eenduidige tram-lane kan binden. Het eigen profiel blijft voorlopig uit het algemene spoorbouwmenu.

## Eerste speltest

1. Vervang de bestanden in dezelfde staging-modmap en laad je lege testsave opnieuw. De game hoeft hiervoor volgens de geteste werkwijze van de gebruiker niet afgesloten te worden.
2. Selecteer UM Track-bound Stop (Test). Controleer eerst of de bouwpreview nu verschijnt.
3. Als de preview werkt, plaats slechts een halte op vlakke, vrije grond.
4. Laat vijf tot tien seconden ongepauzeerd lopen, pauzeer en meld het resultaat. Nog geen spoor, tweede halte of lijn toevoegen.

Als er geen preview verschijnt, geeft het log opnieuw de native validatiereden. De combinatie is nog niet in de engine bewezen. Bij een crash stoppen we deze proef en gebruiken we de normale save van voor die plaatsing; geen crashsave.

## Controle

De lokale test resolveert de terminalverwijzing naar het midden van de root edgeLists en telt de lanes die de terminalmodi ondersteunen. Het nieuwe profiel telt er een. Een fixture met twee passende lanes wordt expliciet afgewezen, overeenkomstig de gemelde enginevalidatie. Verder zijn de voetgangersverwijzingen en het ontbreken van interne voertuigcurves gecontroleerd. Dit is geen vervanging voor de bouwpreview en het native diagnoselog.

De oudere kopstation- en surface_stop-resources blijven onveranderd. De nieuwe constructie kon in revision 8 nog niet geplaatst worden; er zijn daarvan dus geen geplaatste stations om te migreren.
