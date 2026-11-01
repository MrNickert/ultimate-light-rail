# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.4.3 / revision 13.

## Actieve proef: eigen lightrailverbinding

Revision 12 toont dat beide nieuwe haltes lokaal in beide richtingen bereikbaar zijn. Alleen de volledige verbinding via gewone dubbele tramtrack blijft eenrichtingsverkeer, ook voor gecombineerde modevragen. De gebruikerswaarneming dat omdraaien van een halte de gekozen tussenliggende rijstrook verandert past bij een richtingsafhankelijke aansluiting; de precieze oorzaak is nog niet bewezen.

Revision 13 voegt **UM Lightrail (Test)** als bouwbaar profiel toe in dezelfde categorie als de normale tramtrack. De simulatievelden zijn exact gelijk aan het profiel in de tweerichtingshaltes; alleen naam/beschrijving en menu verschillen. De bestaande haltes en profielen worden niet gewijzigd.

Zie [Proef 08](docs/proef-08-lightrailverbinding.md). Vervang de modbestanden en laad de testsave opnieuw. Laat de haltes staan en vervang alleen de gewone tussenliggende tramtrack door de elektrische UM Lightrail (Test)-verbinding. Laat tien seconden lopen en beoordeel de diagnose. Nog geen voertuig inzetten.

Complete netwerkbereikbaarheid, lijnwerking, voertuigomkering en wegintegratie moeten nog worden getest.

## Ontwikkelkoers

Eerst tram als basis voor lightrail en eventuele wegintegratie. Alleen bij een aantoonbare beperking die metrogedrag blokkeert onderzoeken we treinspoor als alternatieve basis. Een zelfstandig netwerk is toegestaan; een trein/tramovergang is geen vereiste. Een eigen lightrail-bouwoptie volgt op bewezen werking, niet alleen op een nieuwe naam.

## Herstel na crash in revision 6

Versie 0.2.2 / revision 6 is ingetrokken: de expliciete tegengestelde lanes leveren geometrisch dubbele edges op. TF3 stopt daarop met de native assertion Duplicate edges found. Revision 7 herstelt exact het stationsscript van revision 5, dat in de speltest wel geplaatst kon worden. Er is geen nieuwe poging om de router te omzeilen toegevoegd.

Vervang de modbestanden terwijl de game gesloten is en laad de laatste normale save van voor de crash. Gebruik de crashsave voorlopig niet: die kan de ongeldige constructie bevatten. Dit pakket repareert zulke opgeslagen constructies niet. Een nieuwe stationsproef is nu niet nodig; de lijnverbinding en het omkeren blijven onopgelost.

Een extra lokale controle vergelijkt de geometrie van voertuigedges ook tegen hun omgekeerde vorm. De controle moet de revision-6-constructie afwijzen en de herstelde constructie accepteren. Dit is een gerichte regressiecontrole; het bewijst niet dat alle enginevoorwaarden zijn afgedekt.

## Plaatsingscorrectie in revision 5

Corrigeert de uitlijnrichting, grondafwerking en perronhaltepunten. De voertuiglanes gebruiken nu de native traminstelling zonder expliciete spoorreservering. Het verbinden en omkeren is nog niet in het spel bewezen. Voor deze versie moeten twee nieuwe kruiswisselkopstations worden geplaatst: een opgeslagen constructie wordt niet automatisch opnieuw opgebouwd.

## Diagnose

Het alleen-lezen gamescript wacht op twee eigen proefconstructies en rapporteert aansluitingen en TRAM/ELECTRIC_TRAM-paden met het prefix [UMNET]. Om de vijf seconden controleert het de aansluitingen; een wijziging levert een nieuw rapport op. Het geeft voorrang aan de terminals van de nieuwe kruiswisselkopstations en test daarnaast afzonderlijke interne edges en trajecten van twee edges. Het rapport bewijst op zichzelf geen werkende lijn of omkeerbeweging.

## Afbakening

Geen wijzigingen aan bestaande gamehaltes, voertuigen, lijnen of onderhoudsgegevens. Verwijder de mod niet uit een save die zijn constructies bevat; herstel je oorspronkelijke testsave om terug te draaien. Niet publiek publiceren.

De eerdere proef met een centraal rijpad kon geen lijnverbinding maken. Die resources en het eigen interne straatprofiel blijven beschikbaar voor oude testsaves. De nieuwe constructie gebruikt het standaard tramprofiel aan de ingang.

## Ontwikkeling

Gebruik het VS Code-profiel Transport Fever 3 Modding en de lokale TF3-definities. Controleer tests/test_crossover_stop.lua, tests/test_surface_stop.lua en tests/test_diagnostics.lua met de Teal-runner; bouw het pakket met python scripts/package.py.

## Later

Een Metro-interface, ondergrondse variant, uitbreidbare stations en eventueel meerdere niveaus volgen nadat de basis werkt. De tramtrackroute blijft leidend.
