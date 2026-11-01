# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.6.2 / revision 17.

## Bewezen enkelspoorbasis

De combinatie UM Bidirectional Stop (Test) en UM Lightrail (Test) levert in het native log paden in beide richtingen. De gebruiker bevestigde een geldige lijn, aansluiting op een tramremise, een rijdend lightrailvoertuig/Citylink, stoppen met deurbediening, zelfstandig keren en vertrek over hetzelfde spoor. Opslaan en herladen is eveneens getest en blijft werken. Dit is bereikt op trambasis, zonder verborgen keerlus of automatische voertuigcommando's.

Dit bewijst nog geen verkeer met meerdere voertuigen, dubbelspoorbedrijf, reizigersafhandeling of algemene wegintegratie.

## Actieve proef: compact tramkopstation

De eerdere variant was plaatsbaar, maar te groot en met spoorwegmodellen vormgegeven. Het native log liet elke ingangslane zijn eigen perron heen en terug bereiken, maar geen kruiselingse wisselroutes. Beide punten worden in revision 17 aangepakt.

**UM Twin Terminus (Test)** / **UM Dubbel Kopstation (Test)** gebruikt nu de normale tramspoorafstand van 5 meter, een wisselzone van 30 meter, twee zijperrons en kale rails in verharding. Dwarsliggers en spoorwegstootblokken zijn verwijderd. Eindraaklijnen van de kruiswissel liggen nu exact parallel aan de hoofdsporen. De totale lengte daalt van ongeveer 230 naar ongeveer 130 meter.

Zie [Proef 12](docs/proef-12-compact-tramkopstation.md). Vervang de bestanden, laad de testsave en plaats een nieuw station met Met kruiswissel op vrije grond. Laat tien seconden lopen. Eerst beoordelen we de nieuwe uitstraling en daadwerkelijke kruiselingse routes. Bestaande grote stations worden niet automatisch verkleind.

De plaatsbaarheid en wisselwerking van deze compacte variant zijn nog niet in het spel bewezen. Het corrigeren van de knik is een gerichte geometriewijziging; een werkend wisselpad moet nog gemeten worden.

## Uitkomst van de dubbele verbinding

De dubbelspoorverbinding uit revision 14 geeft in het native log een pad van zes edges in beide richtingen. De gebruiker ziet dat het voertuig de getekende lijn over hetzelfde rijpad heen en terug volgt en dat het tweede zichtbare spoor bij de enkelspoorovergang lijkt te eindigen. Daarmee zijn twee bereikbare onafhankelijke rijroutes en een spoor per richting nog niet bewezen. Het nieuwe kopstation moet daarom eerst expliciete toegang tot beide perronsporen aantonen.

## Ontwikkelkoers

Zie [de vastgelegde ontwerpkeuzes](docs/ontwerpkeuzes.md): compacte tram-/lightrailvormgeving blijft leidend; spoorweguitstraling en extra ruimte zijn geen vanzelfsprekende technische noodzaak.

Tram is de eerste basis vanwege lightrailvoertuigen en mogelijke wegintegratie. Treinspoor blijft een alternatief bij een aangetoonde functionele grens. Een zelfstandig metronetwerk is toegestaan; een trein/tramovergang is geen vereiste. De beoogde verdere stappen zijn dubbele stations/wissels, verkeersafhandeling met meerdere voertuigen, ondergrondse varianten en een Metro-interface.

## Compatibiliteit en afbakening

Deze versie voegt een apart dubbel profiel toe. De werkende enkelspoor- en stationsresources blijven ongewijzigd; bestaande objecten worden niet automatisch geconverteerd. Gebruik een afzonderlijke testsave. Verwijder de mod niet uit een save die zijn constructies of profielen bevat. De mod is nog niet geschikt voor publieke release.

De oudere proefconstructies blijven beschikbaar als vergelijkingsmateriaal. Versie 0.2.2/revision 6 met overlappende tegengestelde curves is ingetrokken wegens een enginecrash. Deze fout is hersteld; zie docs/herstel-023.md en de controle op dubbele edges. De eerdere richting- en aansluitproblemen staan met hun uitkomsten in de genummerde proefdocumenten.

## Diagnose en ontwikkeling

De alleen-lezen diagnose met prefix [UMNET] meet lokale stationpassages en terminalpaden voor tram-, spoortram- en gecombineerde modi. Hij richt zich op de nieuwe Bidirectional Stops en rapporteert opnieuw bij gewijzigde aansluitingen. Het losse meetobject uit proef 05 gebruikt [UMDIR]. De scripts versturen geen wereldcommando's.

Gebruik het VS Code-profiel Transport Fever 3 Modding. Controleer wijzigingen met de passende Lua-tests in tests/ via de Teal-runner; bouw het private pakket met python scripts/package.py. Lokale tests vervangen de native spelproeven niet.
