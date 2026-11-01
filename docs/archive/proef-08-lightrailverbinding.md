# Proef 08: hetzelfde lightrailprofiel over de hele verbinding

Versie 0.4.3 / revision 13. Nieuw bouwbaar spoor: UM Lightrail (Test).

## Meting die deze proef motiveert

De revision-12-diagnose van 1 november 2026 toont voor beide bidirectional_stop-constructies een lokale passage van twee edges in beide richtingen voor alle zes modeverzamelingen. De haltepassages zelf zijn dus in beide richtingen bereikbaar. Tussen terminal 327512 en 327550 werkt de volledige verbinding alleen heen (zes edges), niet terug, ook niet met gecombineerde tram/spoormodi. Dat lokaliseert de ontbrekende verbinding buiten de gemeten haltepassages, maar wijst nog niet een afzonderlijke junction of edge als schuldige aan.

De gebruiker ziet dat omdraaien van een halte de gekozen rijstrook op de gewone tussenliggende dubbele tramtrack verandert. Dat past bij een richtingsafhankelijke aansluiting tussen de enkele lane van de halte en de normale dubbele infrastructuur. Dit is een onderbouwde hypothese, geen bewezen oorzaak.

## Nieuwe resource

lightrail_test.street_template.lua is een afzonderlijke bouwbare kopie van mode_probe.street_template.lua, dat in de haltes gebruikt wordt. Alleen de beschrijving en bouwmenucategorie verschillen. Lane-aantal, offset, hoogte, modusverzamelingen, snelheid, straatsoort, stijl, kosten en overige simulatievelden zijn identiek. Het blijft STREET-infrastructuur op trambasis. Er is geen conversie naar treinrails.

Dit vermijdt in de volgende proef de overgang naar het normale tweestrooks tramprofiel. Het profiel is nieuw bouwbaar; de aansluiting tussen afzonderlijk gebouwde segmenten en een complete heen-en-terugroute zijn daarmee nog niet bewezen. Er worden geen bestaande straten of stations automatisch gewijzigd.

## Uitvoeren

1. Bewaar de huidige testsave en vervang de modbestanden. Laad dezelfde save opnieuw.
2. Laat beide bestaande **UM Bidirectional Stop (Test)**-haltes staan. Zoek **UM Lightrail (Test)** in dezelfde bouwcategorie als normale tramtrack, bij de kleine wegen/tram-infrastructuur. Een eigen Metro-tab is nog niet toegevoegd.
3. Verwijder op de testsave alleen het normale tramspoor tussen deze twee nieuwe haltes. Bouw die volledige verbinding opnieuw met UM Lightrail (Test). Kies de elektrische uitvoering/elektrische tramtrack waar het bouwgereedschap die keuze biedt. Begin exact aan het vrije spooruiteinde van de ene halte en eindig aan dat van de andere.
4. Controleer dat er geen kort oud stuk standaard tramtrack in de verbinding achterblijft. De haltes hoeven niet gesloopt of opnieuw geplaatst te worden.
5. Laat tien seconden ongepauzeerd lopen en pauzeer. Een lijn is voor de diagnose niet nodig. Als de lijn er al is, meld of de foutmelding verandert.
6. Sla deze variant op en meld dat de meting klaarstaat. Nog geen voertuig inzetten; eerst beoordelen we de gevonden paden.

Als het nieuwe profiel niet in het menu verschijnt of niet op het halteuiteinde aansluit, stop bij die stap en meld het resultaat. We wijzigen niet de native aansluitregels met verborgen of overlappende rijpaden.

## Nog niet bewezen

Een complete lijn, voertuigen keren, voertuigtoegang vanuit een remise, reizigerstoegang, reserveringsveiligheid en integratie met gewone wegtramtrack. De testsave blijft onderzoeksmateriaal. De koers is tram eerst; een zelfstandig metronetwerk zonder wegintegratie blijft een aanvaardbare uitkomst. Een spoor-tramovergang is geen verplichte scope.

## Uitgevoerd resultaat

Het native log vond met dit profiel vier edges in beide richtingen voor alle gemeten modi. De gebruiker bevestigde een werkende lijn, remise-aansluiting, rijdende Citylink/lightrail, stoppen en deuren bedienen, zelfstandig keren en vertrek over hetzelfde spoor. Opslaan/herladen is getest; alles blijft werken. Dit is de enkelsporige referentie. Dubbelspoor wordt afzonderlijk getest in proef-09-dubbelspoor.md.
