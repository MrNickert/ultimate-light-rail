# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.6.1 / revision 16.

## Bewezen enkelspoorbasis

De combinatie UM Bidirectional Stop (Test) en UM Lightrail (Test) levert in het native log paden in beide richtingen. De gebruiker bevestigde een geldige lijn, aansluiting op een tramremise, een rijdend lightrailvoertuig/Citylink, stoppen met deurbediening, zelfstandig keren en vertrek over hetzelfde spoor. Opslaan en herladen is eveneens getest en blijft werken. Dit is bereikt op trambasis, zonder verborgen keerlus of automatische voertuigcommando's.

Dit bewijst nog geen verkeer met meerdere voertuigen, dubbelspoorbedrijf, reizigersafhandeling of algemene wegintegratie.

## Actieve proef: kopstation met interne wissels

Revision 15 werd in het spel als Construction Not Possible geweigerd, zonder specifieke foutcode in stdout. Revision 16 vervangt de root-STREET-wisselkruisingen door interne voertuiglanes volgens het native stationsschema. De externe aansluiting is nu een enkele rechte dubbele straat-edge. De interne rijpaden gebruiken de vier onderzochte tram/spoormodi, expliciete reservering en tweerichtingsverkeer; deze combinatie moet in deze constructie nog worden getest.

Dezelfde **UM Twin Terminus (Test)** / **UM Dubbel Kopstation (Test)** heeft twee interne perronsporen, elk een eigen haltepunt, een eilandperron en een kruiswissel. Bestaande railmodellen en stootblokken verzorgen een voorlopige decoratieve weergave. De wissel kan in het bouwmenu uitgeschakeld worden als vergelijkingsvariant; standaard staat hij aan.

Zie [Proef 11](docs/proef-11-interne-wissels.md). Vervang de bestanden, laad een testsave en probeer een nieuw station op vrije vlakke grond. Als het met kruiswissel plaatsbaar is: plaats een exemplaar en laat tien seconden lopen. Is de preview rood, vergelijk dan op dezelfde plaats met Zonder wissel. Nog geen lijn of voertuig toevoegen; eerst beoordelen we de native bouw- en routegegevens.

De werkende oude haltes en spoorprofielen blijven behouden. De nieuwe interne routewerking en kruisingsveiligheid zijn niet door de lokale controles bewezen.

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
