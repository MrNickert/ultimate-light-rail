# Proef 09: dubbel verbindingsspoor

Versie 0.5.0 / revision 14. Nieuw bouwprofiel: UM Lightrail Double (Test), Nederlands UM Lightrail Dubbel (Test).

## Bewezen basis

In revision 13 vond het native log een pad van vier edges tussen beide haltepunten in beide richtingen, voor alle zes gemeten modeverzamelingen. De gebruiker bevestigde daarna een geldige lijn, aansluiting op een tramremise, een toegewezen lightrailvoertuig/Citylink dat de route berijdt, stoppen met deuren openen/sluiten en zelfstandig veranderen van rijrichting met wisselende verlichting, gevolgd door vertrek over hetzelfde spoor. Opslaan en opnieuw laden is getest; de gebruiker meldt dat alles blijft werken.

Dit zijn resultaten van de enkelsporige opstelling. Passeren met meerdere voertuigen, spoorgebruik per richting en kruisingveiligheid zijn daarmee niet getest.

## Wat deze versie toevoegt

Een afzonderlijk dubbelspoorprofiel met de oorspronkelijke dubbele tram-lane-indeling: offsets -0.25 en +0.25, tegengestelde logische forward-waarden en dezelfde hoogte/breedte als de basis. Beide lanes houden de vier vervoersmodi van het werkende enkelspoor. De rijpaden vallen niet geometrisch samen. Het type blijft STREET; er worden geen wereldcommando's gebruikt.

De bestaande enkelspoorresources en haltes blijven ongewijzigd. Voor deze eerste dubbelspoorproef blijven de haltes dus enkelsporig en wordt alleen de verbinding verdubbeld. Een station met twee afzonderlijke perronsporen en een echte wisselstraat is de volgende bouwstap na een geslaagde dubbelspoorverbinding. De eerdere afgewezen directe binding aan een template met meerdere passende lanes blijft een beperking om daarbij te respecteren.

Twee fysiek gescheiden lanes garanderen nog niet dat een lijn elke richting op een ander spoor kiest. De extra spoormodi kunnen beide lanes technisch tweerichtingsverkeer geven. Een richting per spoor afdwingen vereist dus een afzonderlijke route- of signaalproef. De witte pijlen zijn daarvoor geen afdoend bewijs.

## Speltest

1. Bewaar de werkende enkelspoorsave als referentie en maak een aparte testkopie.
2. Zet het testvoertuig eerst in de remise voordat je zijn tussenliggende spoor vervangt; pauzeer daarna. Je hoeft de bestaande haltes of lijn niet opnieuw aan te maken.
3. Vervang de modbestanden en laad de testkopie opnieuw. De game afsluiten is niet vereist in de geteste werkwijze van de gebruiker.
4. Zoek **UM Lightrail Double (Test)** / **UM Lightrail Dubbel (Test)** in dezelfde bouwcategorie als UM Lightrail (Test).
5. Vervang alleen de verbinding tussen de twee bestaande Bidirectional Stops door dit nieuwe dubbele profiel, met elektrische tramtrack. Er wordt niets automatisch geconverteerd.
6. Laat tien seconden lopen en pauzeer. Meld of het dubbele spoor zichtbaar is, de aansluiting lukt en de lijn geldig blijft. Eerst bekijken we ook de heen- en terugpaden in het log.
7. Als de lijn en paden geldig zijn, kan hetzelfde ene voertuig weer op de lijn. Observeer het gekozen spoor heen en terug en of het zelfstandig blijft keren. Voeg nog geen tweede voertuig toe voordat deze vergelijking is beoordeeld.

Bij een ongeldige aansluiting of lijn blijft de enkelspoorsave de werkende referentie. Dit is nog een proefversie; de nieuwe junctions moeten in de game getest worden.

## Lokale controle

De test controleert twee afzonderlijke offsets, native tegengestelde lane-orientatie, alle vier de vervoersmodi op beide lanes en gelijkheid met de enkelspoorbasis buiten laneConfigs, beschrijving en bouwmenu. De oudere template- en stationsbestanden worden niet aangepast. Dit bewijst geen complete native route of veilige verkeersafhandeling.
