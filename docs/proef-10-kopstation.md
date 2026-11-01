# Proef 10: tweesporig kopstation met kruiswissel

Versie 0.6.0 / revision 15. Nieuwe constructie: UM Twin Terminus (Test), Nederlands UM Dubbel Kopstation (Test).

## Ontwerp

Een dubbele aanrijaansluiting aan de voorkant splitst naar twee aparte enkelstrooks lightrailsporen met de bewezen gemengde vervoersmodi. De hoofdsporen hebben hartlijnen op y=-6 en y=+6 meter. Vanaf x=0 tot x=80 ligt een eilandperron. Elk perronspoor heeft een eigen direct gebonden haltepunt op x=40 en eindigt op x=80. Achter de spooreinden ligt alleen een voetgangersverbinding en publieksingang; er is geen voertuigaansluiting aan de achterkant.

Voor het perron liggen twee kruislings lopende wisselroutes tussen x=-60 en x=-20. Beide bevatten een expliciet punt op x=-40,y=0. Het root-geometriemodel deelt zo een vierarmig kruispunt; de native engine moet nog bevestigen hoe dit punt als transportknooppunt en railkruising wordt opgebouwd. Dit is geen oversteken met twee ongekoppelde over elkaar getekende voertuig-lanes. Alle voertuiggeometrie bestaat uit echte STREET-edgeLists. Er worden geen identieke tegengestelde curves of voertuigcommando's toegevoegd.

De enkele bouwbare dubbele ingang loopt van x=-130 tot x=-100. Alleen het uiteinde op x=-130 is vrij/snapbaar. Dat punt is bedoeld voor **UM Lightrail Double (Test)**. De constructie is voor deze eerste functionele proef circa 230 meter lang inclusief wisselstraat en voetgangerstoegang. Het perron is 80 meter. De ruime tussenafstand is een onderzoekskeuze; visuele verfijning en compactere geometrie zijn vervolgwerk.

## Haltebinding en enginebeperkingen

De eerder bewezen enkelspoorhalte gebruikt een directe terminalverwijzing naar een root-edge-endpoint. Dezelfde techniek wordt hier afzonderlijk op de twee perronsporen toegepast. De globale ruwe endpointindices zijn 9 en 19: beide wijzen op een eigen enkelstrooks spoorsegment op x=40. Geen terminal wijst naar de dubbelstrooks ingang, omdat de engine directe verwijzingen naar meerdere passende lanes afwijst.

De gebruikte enkel- en dubbelspoorprofielen blijven ongewijzigd. Dat een eerdere lightrail zelfstandig keerde op de enkelspoorhalte bewijst niet dat deze nieuwe wissels, terminalposities en benaderingsroutes ook werken. Native plaatsbaarheid, beide perronroutes, lijnkeuze, voertuigomkering en conflictveiligheid moeten nog worden getest.

## Eerste speltest: een station, geen voertuig

1. Bewaar de werkende enkelspoor-/dubbelspoorsave als referentie en gebruik een testkopie.
2. Vervang de modbestanden en laad de save opnieuw. Afsluiten is niet nodig volgens de geteste werkwijze van de gebruiker.
3. Zoek **UM Twin Terminus (Test)** / **UM Dubbel Kopstation (Test)** in het wegstationsmenu, naast de eerdere proefhaltes.
4. Plaats een exemplaar op ruime vlakke vrije grond, los van de werkende lijn. De enige dubbele ingang zit aan de voorkant; de perronsporen lopen aan de andere kant dood. Als de preview niet verschijnt of plaatsen geweigerd wordt, meld dat meteen. Forceer geen alternatieve aansluitingen.
5. Laat tien seconden ongepauzeerd lopen en pauzeer. Maak nog geen lijn en zet nog geen voertuig in.
6. Meld dat het log klaarstaat. De [UMNET]-diagnose meet per werkelijk gegenereerde ingangslane de route naar beide terminals en terug. Hij geeft het nieuwe station voorrang boven oude referentiehaltes. Dit werkt ook als er maar een kopstation is geplaatst.

Eerst beoordelen we of de engine beide haltepunten, de splitsing en de kruiswissel daadwerkelijk heeft aangelegd. Bij succes volgt een tweede kopstation met zijn ingang naar de verbinding gericht, verbonden via UM Lightrail Double. Dan testen we beide perronkeuzes en een enkele Citylink. Een spoor per rijrichting en passeren met meerdere voertuigen zijn nog afzonderlijke verkeersproeven.

## Lokale controles

De controles lossen de echte globale terminalverwijzingen op, controleren dat die een enkel passend profiel hebben, vinden verbindingen naar beide perronpunten in het root-geometriemodel, controleren de gedeelde vierarmige kruiscoordinaat en verwerpen identieke of exact omgekeerde dubbele curves. De Bezier-controlpunten blijven binnen het spoorgebied en lopen in x vooruit, zonder verborgen omkeerbochten. Pedestrian-referenties en het voorste snappunt worden gecontroleerd.

Deze controles testen onze constructiedata. Ze bewijzen niet dat de native STREET-junctiongenerator alle vertakkingen en kruisingen accepteert of veilig afhandelt. Test daarom eerst een station en daarna slechts een voertuig.
