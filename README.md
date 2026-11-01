# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.4.0 / revision 10.

## Actieve proef: richtinggedrag meten

Revision 9 bevestigde directe terminalbinding aan een enkele tram-lane, beide haltes in de lijnplanner en een pad van zes edges via gewone elektrische tramtrack in een richting. Het terugpad en daadwerkelijk keren zijn nog niet bewezen.

Revision 10 voegt een los vergelijkingsobject toe: **UM Direction Probe (Test)** / **UM Richtingproef (Test)**. Het bevat drie gescheiden segmenten: A het werkende enkele tramprofiel, B hetzelfde met extra TRAM_TRACK/ELECTRIC_TRAM_TRACK-modi, C native elektrisch treinspoor als referentie. Het is geen halte of tram/treinovergang. Het verschil tussen A en B is beperkt tot de modeverzamelingen; de vergelijking met C is breder.

Zie [Proef 05](docs/proef-05-richting.md). Vervang de bestanden, laad de testsave opnieuw, plaats een proefobject op vrije vlakke grond en laat tien seconden lopen. Geen lijn of aansluiting nodig. De nieuwe alleen-lezen diagnose logt met [UMDIR] de daadwerkelijke netwerken en padresultaten per richting en modus.

De werkende spoorgebonden haltes en hun profiel worden niet gewijzigd. De native speltest van deze nieuwe fixture moet nog plaatsvinden. Lokale controles bewijzen geen voertuigomkering.

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
