# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.2.1 / revision 5.

## Actieve proef

Een nieuwe bovengrondse kopstationconstructie met twee perronsporen en een kruiswissel voor de ingang, aangesloten op gewone elektrische tramtrack. De constructie gebruikt bestaande wachthuisjes en grondtexturen. Beide perrons hebben een eigen terminal. Er is geen keerlus en geen automatisch omkeercommando.

**Plaatsbaarheid, routeverbinding en native omkeren moeten nog in het spel worden bewezen.** Interne rails en bovenleiding hebben nog geen complete 3D-weergave. Test eerst met één voertuig op een afzonderlijke testsave; kruisingsveiligheid is niet bewezen.

Zie [Proef 02: plaatsen en testen](docs/proef-02-kruiswissel.md). Zoek in het menu voor wegstations naar **UM Crossover Terminus (Test)** / **UM Kruiswisselkopstation (Test)**. Plaats twee nieuwe stations, met de ingangen naar elkaar toe, en verbind hun korte standaard tramtrackaansluitingen. De oude UM Surface Stop blijft als vergelijkingsmateriaal beschikbaar en wordt niet verbouwd.

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
