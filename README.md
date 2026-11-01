# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.3.1 / revision 9.

## Actieve proef: directe haltebinding met een tramrijstrook

De gewone tramtemplate uit revision 8 werd door TF3 afgewezen: de directe verwijzing uit een treinstation is niet eenduidig bij twee passende tramlanes. Revision 9 geeft de aparte doorgaande testhalte daarom een eigen interne STREET-tramtemplate met een enkele voorwaartse lane. De echte tramsegmenten lopen door de hele halte. Er zijn geen interne voertuig-laneLists of overlappende tegenrichtingcurves.

Lees [Proef 04](docs/proef-04-een-rijstrook.md). Vervang de bestanden en laad de lege testsave opnieuw. Selecteer **UM Track-bound Stop (Test)** / **UM Spoorgebonden Halte (Test)** en controleer of de preview verschijnt. Plaats daarna slechts een halte en laat vijf tot tien seconden lopen. Nog geen lijn bouwen: eerst beoordelen we de werkelijke terminalbinding in het log.

Dit is een eenrichtingsproef, geen bewezen oplossing voor een metro, kopstation of keermogelijkheid. Engineacceptatie van het aangepaste profiel is nog niet getest. De eerdere constructies blijven onveranderd als vergelijkingsmateriaal.

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
