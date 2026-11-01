# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.5.0 / revision 14.

## Bewezen enkelspoorbasis

De combinatie UM Bidirectional Stop (Test) en UM Lightrail (Test) levert in het native log paden in beide richtingen. De gebruiker bevestigde een geldige lijn, aansluiting op een tramremise, een rijdend lightrailvoertuig/Citylink, stoppen met deurbediening, zelfstandig keren en vertrek over hetzelfde spoor. Opslaan en herladen is eveneens getest en blijft werken. Dit is bereikt op trambasis, zonder verborgen keerlus of automatische voertuigcommando's.

Dit bewijst nog geen verkeer met meerdere voertuigen, dubbelspoorbedrijf, reizigersafhandeling of algemene wegintegratie.

## Actieve proef: dubbel verbindingsspoor

Nieuw: **UM Lightrail Double (Test)** / **UM Lightrail Dubbel (Test)**, in dezelfde bouwcategorie als het enkele profiel. Het combineert de native dubbele tram-lane-indeling met de vier vervoersmodi van de werkende enkelspoorbasis.

Zie [Proef 09](docs/proef-09-dubbelspoor.md). Bewaar de werkende enkelspoorsave, maak een testkopie en zet het voertuig eerst in de remise. Vervang de modbestanden, laad de testkopie opnieuw en vervang alleen het tussenliggende spoor door de elektrische dubbele variant. De bestaande haltes blijven voor deze proef enkelsporig en hoeven niet opnieuw geplaatst te worden. Laat tien seconden lopen en beoordeel lijn en log voordat een voertuig wordt ingezet.

Het nieuwe spoor moet in de game nog getest worden. Of elke richting een ander spoor gebruikt, staat niet automatisch vast; beide lanes kunnen door de engine technisch tweerichtingsverkeer krijgen. Stations met twee aparte perronsporen en wissels volgen nadat de dubbelspoorverbinding werkt.

## Ontwikkelkoers

Tram is de eerste basis vanwege lightrailvoertuigen en mogelijke wegintegratie. Treinspoor blijft een alternatief bij een aangetoonde functionele grens. Een zelfstandig metronetwerk is toegestaan; een trein/tramovergang is geen vereiste. De beoogde verdere stappen zijn dubbele stations/wissels, verkeersafhandeling met meerdere voertuigen, ondergrondse varianten en een Metro-interface.

## Compatibiliteit en afbakening

Deze versie voegt een apart dubbel profiel toe. De werkende enkelspoor- en stationsresources blijven ongewijzigd; bestaande objecten worden niet automatisch geconverteerd. Gebruik een afzonderlijke testsave. Verwijder de mod niet uit een save die zijn constructies of profielen bevat. De mod is nog niet geschikt voor publieke release.

De oudere proefconstructies blijven beschikbaar als vergelijkingsmateriaal. Versie 0.2.2/revision 6 met overlappende tegengestelde curves is ingetrokken wegens een enginecrash. Deze fout is hersteld; zie docs/herstel-023.md en de controle op dubbele edges. De eerdere richting- en aansluitproblemen staan met hun uitkomsten in de genummerde proefdocumenten.

## Diagnose en ontwikkeling

De alleen-lezen diagnose met prefix [UMNET] meet lokale stationpassages en terminalpaden voor tram-, spoortram- en gecombineerde modi. Hij richt zich op de nieuwe Bidirectional Stops en rapporteert opnieuw bij gewijzigde aansluitingen. Het losse meetobject uit proef 05 gebruikt [UMDIR]. De scripts versturen geen wereldcommando's.

Gebruik het VS Code-profiel Transport Fever 3 Modding. Controleer wijzigingen met de passende Lua-tests in tests/ via de Teal-runner; bouw het private pakket met python scripts/package.py. Lokale tests vervangen de native spelproeven niet.
