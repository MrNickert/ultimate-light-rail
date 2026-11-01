# Proef 07: waar stopt de terugweg?

Versie 0.4.2 / revision 12. Alleen diagnose; geen nieuwe stationsgeometrie of infrastructuurprofielen.

## Vastgesteld in revision 11

Beide nieuwe bidirectional_stop-constructies konden worden geplaatst. Het log toont op alle vier de eigen stationsegmenten forwardOnly=false en needsReservation=true. Van terminal 327512 naar 327541 wordt een pad met zes edges gevonden voor TRAM en ELECTRIC_TRAM. Terug wordt voor beide modi geen pad gevonden. De aanwezigheid van tweerichtingsedges bewijst dus nog geen tweerichtingsroute over meerdere segmenten en aansluitingen.

De zichtbare pijlen zijn geen voldoende diagnose voor het netwerkgedrag. Voor deze route wijzen zowel de gebruikerswaarneming als de daadwerkelijke padvragen nog op een ontbrekende terugweg. We hebben de oorzaak nog niet gelokaliseerd.

## Wat deze diagnose toevoegt

Voor elke nieuwe halte worden uit de daadwerkelijk gegenereerde segmentnetwerken de twee buitenste voertuigknooppunten bepaald. Het script vraagt een pad over het hele lokale station in beide richtingen. Het vraagt ook opnieuw paden tussen de haltepunten op. Beide metingen gebruiken zes modeverzamelingen: TRAM, ELECTRIC_TRAM, TRAM_TRACK, ELECTRIC_TRAM_TRACK, TRAM+TRAM_TRACK en ELECTRIC_TRAM+ELECTRIC_TRAM_TRACK.

Dat kan onderscheid maken tussen een blokkade binnen het station en een blokkade in de grotere verbinding, en laten zien of een route afhankelijk is van de modeverzameling. Het is nog geen vaststelling dat deze factoren de oorzaak zijn. Een gecombineerd pad bewijst bovendien nog geen werkende lijn of voertuigomkering.

De diagnose richt de terminalparen op de nieuwe bidirectional_stop-haltes als die aanwezig zijn. Oude eenrichtingsreferenties mogen blijven staan, maar worden dan niet meer in alle interstationpadvragen gemengd. De opgeslagen diagnosestatus wordt bij deze versie vernieuwd zodat hetzelfde ongewijzigde netwerk opnieuw wordt bemeten.

## Uitvoeren

1. Sla de huidige opstelling met de twee nieuwe haltes en hun verbinding op.
2. Vervang de modbestanden en laad precies die save opnieuw. De game hoeft niet afgesloten te worden.
3. Laat tien seconden ongepauzeerd lopen en pauzeer.
4. Meld dat het log klaarstaat. Niets opnieuw plaatsen of verbinden. Nog geen voertuig inzetten.

Dit pakket wijzigt geen opgeslagen stations, spoorprofielen, lijnen of voertuigen en verstuurt geen wereldcommando's. Het lost de ontbrekende terugroute niet op; het maakt de oorzaak beter meetbaar. De bestaande stationscripts en alle profielresources blijven byte voor byte ongewijzigd.
