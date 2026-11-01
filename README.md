# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.4.2 / revision 12.

## Actieve proef: terugroute lokaliseren

De nieuwe haltes uit revision 11 zijn geplaatst. Hun native segmenten hebben forwardOnly=false en needsReservation=true. Toch vindt de complete TRAM/ELECTRIC_TRAM-route via gewone tramtrack alleen een heenpad van zes edges en geen terugpad. Een tweerichtingssegment blijkt dus nog geen complete tweerichtingsroute te garanderen.

Revision 12 breidt uitsluitend de alleen-lezen diagnose uit. Lokale paden over een station worden vergeleken met paden tussen de terminals, voor de trammodi, railtrammodi en gecombineerde modeverzamelingen. De bestaande haltes en profielen blijven ongewijzigd.

Zie [Proef 07](docs/proef-07-route-diagnose.md). Sla de huidige opstelling op, vervang de bestanden, laad dezelfde save en laat tien seconden lopen. Niets opnieuw bouwen. De lijnverbinding en voertuigomkering zijn nog niet opgelost.

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
