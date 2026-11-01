# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.6.2 / revision 17.

## Bewezen enkelspoorbasis

De combinatie UM Bidirectional Stop (Test) en UM Lightrail (Test) levert in het native log paden in beide richtingen. De gebruiker bevestigde een geldige lijn, aansluiting op een tramremise, een rijdend lightrailvoertuig/Citylink, stoppen met deurbediening, zelfstandig keren en vertrek over hetzelfde spoor. Opslaan en herladen is eveneens getest en blijft werken. Dit is bereikt op trambasis, zonder verborgen keerlus of automatische voertuigcommando's.

Dit bewijst nog geen verkeer met meerdere voertuigen, dubbelspoorbedrijf, reizigersafhandeling of algemene wegintegratie.

## Werkende basis: kopstation met native tramtrack

De compacte **UM Twin Terminus (Test)** / **UM Dubbel Kopstation (Test)** uit versie 0.6.2 is plaatsbaar. Het native log bevestigt routes tussen elk ingangsspoor en beide perrons. De gebruiker heeft een complete lijn met een waypoint, Citylink-ritten over beide sporen, stoppen, deurbediening en zelfstandig keren op beide nieuwe stations getest.

Met meerdere voertuigen op het eigen UM-verbindingsprofiel ontstond een blokkade. De gebruiker verving alleen het verbindingsspoor door gewone native tramtrack; daarna werkte het verkeer zoals verwacht. De voertuigen wachten volgens de spelwaarneming voor het kopstation als de kruisende route bezet is, en rijden verder zodra die vrij is.

Gebruik daarom **gewone native elektrische tramtrack tussen de kopstations**. De eigen UM Lightrail-profielen blijven voor oude testsaves beschikbaar, maar worden niet als doorgaand verbindingsspoor aanbevolen. Er is geen nieuw pakket nodig voor deze configuratie. Zie [Proef 13](docs/proef-13-native-verbindingsspoor.md).

De volgende controle is opslaan/herladen van juist deze configuratie met meerdere voertuigen en native tramtrack, gevolgd door enkele rondritten. Langdurig bedrijf en algemene compatibiliteit zijn nog niet breed getest.

## Vormgeving

Het station gebruikt 5 meter spoorafstand, een wisselzone van 30 meter, twee zijperrons en kale rails in verharding. De totale lengte is circa 130 meter inclusief 80m perrons en voetgangerstoegang. De weergave en interne bovenleiding/wisseltongen zijn nog voorlopig; er zijn geen dwarsliggersegmenten of spoorwegstootblokken. De interne spoorgeometrie gebruikt gemengde vervoersmodi voor de native keerfunctie, terwijl het externe verbindingsnet gewone tramtrack blijft.

## Ontwikkelkoers

Zie [de vastgelegde ontwerpkeuzes](docs/ontwerpkeuzes.md): compacte tram-/lightrailvormgeving blijft leidend; spoorweguitstraling en extra ruimte zijn geen vanzelfsprekende technische noodzaak.

Tram is de eerste basis vanwege lightrailvoertuigen en mogelijke wegintegratie. Treinspoor blijft een alternatief bij een aangetoonde functionele grens. Een zelfstandig metronetwerk is toegestaan; een trein/tramovergang is geen vereiste. De beoogde verdere stappen zijn dubbele stations/wissels, verkeersafhandeling met meerdere voertuigen, ondergrondse varianten en een Metro-interface.

## Compatibiliteit en afbakening

Deze versie voegt een apart dubbel profiel toe. De werkende enkelspoor- en stationsresources blijven ongewijzigd; bestaande objecten worden niet automatisch geconverteerd. Gebruik een afzonderlijke testsave. Verwijder de mod niet uit een save die zijn constructies of profielen bevat. De mod is nog niet geschikt voor publieke release.

De oudere proefconstructies blijven beschikbaar als vergelijkingsmateriaal. Versie 0.2.2/revision 6 met overlappende tegengestelde curves is ingetrokken wegens een enginecrash. Deze fout is hersteld; zie docs/herstel-023.md en de controle op dubbele edges. De eerdere richting- en aansluitproblemen staan met hun uitkomsten in de genummerde proefdocumenten.

## Diagnose en ontwikkeling

De alleen-lezen diagnose met prefix [UMNET] meet lokale stationpassages en terminalpaden voor tram-, spoortram- en gecombineerde modi. Hij richt zich op de nieuwe Bidirectional Stops en rapporteert opnieuw bij gewijzigde aansluitingen. Het losse meetobject uit proef 05 gebruikt [UMDIR]. De scripts versturen geen wereldcommando's.

Gebruik het VS Code-profiel Transport Fever 3 Modding. Controleer wijzigingen met de passende Lua-tests in tests/ via de Teal-runner; bouw het private pakket met python scripts/package.py. Lokale tests vervangen de native spelproeven niet.
