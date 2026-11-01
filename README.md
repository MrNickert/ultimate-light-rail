# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.6.0 / revision 15.

## Bewezen enkelspoorbasis

De combinatie UM Bidirectional Stop (Test) en UM Lightrail (Test) levert in het native log paden in beide richtingen. De gebruiker bevestigde een geldige lijn, aansluiting op een tramremise, een rijdend lightrailvoertuig/Citylink, stoppen met deurbediening, zelfstandig keren en vertrek over hetzelfde spoor. Opslaan en herladen is eveneens getest en blijft werken. Dit is bereikt op trambasis, zonder verborgen keerlus of automatische voertuigcommando's.

Dit bewijst nog geen verkeer met meerdere voertuigen, dubbelspoorbedrijf, reizigersafhandeling of algemene wegintegratie.

## Actieve proef: tweesporig kopstation

Nieuw: **UM Twin Terminus (Test)** / **UM Dubbel Kopstation (Test)**. De constructie bevat een dubbele vooraansluiting, twee aparte perronsporen met elk een direct haltepunt, een eilandperron en een expliciete kruiswissel. De spooreinden achter het perron hebben geen externe voertuigaansluiting. Alle rijpaden bestaan uit echte STREET-segmenten op de werkende lightrailprofielen.

Zie [Proef 10](docs/proef-10-kopstation.md). Vervang de bestanden, laad een testkopie van de save en plaats slechts een nieuw kopstation op ruime vrije vlakke grond. Laat tien seconden lopen. De diagnose meet de daadwerkelijke routes tussen elk ingangsspoor en beide terminals, in beide richtingen. Nog geen lijn of voertuig toevoegen: eerst controleren we de nieuwe native wisselknooppunten.

De oude haltes en profielen blijven behouden. Deze nieuwe stationsgeometrie, beide perronroutes en reserveringsveiligheid zijn nog niet in de game getest. Bij succes volgt een tweede station, een dubbele verbinding en een proef met een voertuig.

## Uitkomst van de dubbele verbinding

De dubbelspoorverbinding uit revision 14 geeft in het native log een pad van zes edges in beide richtingen. De gebruiker ziet dat het voertuig de getekende lijn over hetzelfde rijpad heen en terug volgt en dat het tweede zichtbare spoor bij de enkelspoorovergang lijkt te eindigen. Daarmee zijn twee bereikbare onafhankelijke rijroutes en een spoor per richting nog niet bewezen. Het nieuwe kopstation moet daarom eerst expliciete toegang tot beide perronsporen aantonen.

## Ontwikkelkoers

Tram is de eerste basis vanwege lightrailvoertuigen en mogelijke wegintegratie. Treinspoor blijft een alternatief bij een aangetoonde functionele grens. Een zelfstandig metronetwerk is toegestaan; een trein/tramovergang is geen vereiste. De beoogde verdere stappen zijn dubbele stations/wissels, verkeersafhandeling met meerdere voertuigen, ondergrondse varianten en een Metro-interface.

## Compatibiliteit en afbakening

Deze versie voegt een apart dubbel profiel toe. De werkende enkelspoor- en stationsresources blijven ongewijzigd; bestaande objecten worden niet automatisch geconverteerd. Gebruik een afzonderlijke testsave. Verwijder de mod niet uit een save die zijn constructies of profielen bevat. De mod is nog niet geschikt voor publieke release.

De oudere proefconstructies blijven beschikbaar als vergelijkingsmateriaal. Versie 0.2.2/revision 6 met overlappende tegengestelde curves is ingetrokken wegens een enginecrash. Deze fout is hersteld; zie docs/herstel-023.md en de controle op dubbele edges. De eerdere richting- en aansluitproblemen staan met hun uitkomsten in de genummerde proefdocumenten.

## Diagnose en ontwikkeling

De alleen-lezen diagnose met prefix [UMNET] meet lokale stationpassages en terminalpaden voor tram-, spoortram- en gecombineerde modi. Hij richt zich op de nieuwe Bidirectional Stops en rapporteert opnieuw bij gewijzigde aansluitingen. Het losse meetobject uit proef 05 gebruikt [UMDIR]. De scripts versturen geen wereldcommando's.

Gebruik het VS Code-profiel Transport Fever 3 Modding. Controleer wijzigingen met de passende Lua-tests in tests/ via de Teal-runner; bouw het private pakket met python scripts/package.py. Lokale tests vervangen de native spelproeven niet.
