# Diagnose 01 — lijn kan haltes niet verbinden

Bevinding in de game: beide prototypehaltes zijn geplaatst en als lijnhaltes geselecteerd, maar TF3 meldt Could not connect stations. De eerdere plaatsingsmelding Too Much Curvature is ook vastgelegd. Het spel-log bevat geen specifieke fout die de ontbrekende route al verklaart.

Revision 2 is een diagnosepakket, geen bewezen reparatie. De stationgeometrie, het interne straatprofiel en de haltepunten zijn ongewijzigd ten opzichte van revision 1.

Vervang alleen de modbestanden, laad dezelfde testsave en laat de simulatie ongeveer vijf seconden lopen. De twee haltes hoeven niet opnieuw geplaatst te worden. Het gamescript leest uitsluitend bestaande componenten en vraagt routes op; het verstuurt geen wijzigingsopdrachten.

Het rapport in stdout.txt begint met [UMNET]. Per prototypeconstructie worden eigen stubs, hun basisknooppunten en het aantal aangrenzende segmenten gelogd. Per halte volgen vehicleNodeId en voertuigedges met richting, reservering en geometrie. Tenslotte wordt tussen de eerste maximaal vier prototypehaltepunten een pad in beide richtingen opgevraagd voor TRAM en ELECTRIC_TRAM.

Een basisknooppunt met alleen het eigen stubsegment kan een niet aangesloten uiteinde aangeven; binnenste stubknooppunten kunnen juist bewust zo zijn omdat daar het interne transportnetwerk begint. Een positieve padlengte bewijst alleen netwerkbereikbaarheid, niet dat een normale dienstregeling of eindpuntomkering werkt. Het resultaat bepaalt de volgende gerichte wijziging.

De diagnose gebruikt alleen de gedeclareerde componenten en pathfinding-leesfuncties uit de meegeleverde TF3-API. Beschikbaarheid van iedere leesfunctie in de runtime wordt via foutafhandeling in het log gemeld.
