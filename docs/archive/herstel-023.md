# Herstelpakket 0.2.3 / revision 7

Versie 0.2.2 is ingetrokken wegens een bevestigde enginecrash tijdens plaatsen. Het log noemt Duplicate edge detected voor lane-lijsten 9 t/m 12, gevolgd door de assertion Duplicate edges found in TransportNetworkSystem.cpp. Dat zijn precies de toegevoegde tegengestelde voertuiglanes. De ongeldige hoogteposities in het log verklaren deze duplicate-edge-assertion niet weg; de dubbele curves zijn expliciet gemeld.

1. Houd de game gesloten en vervang de modbestanden met het herstelpakket.
2. Start de game en laad de laatste gewone testsave van voor de crash.
3. Gebruik de automatisch gemaakte crashsave voorlopig niet; die kan de ongeldige constructie bevatten. Er wordt geen opgeslagen geometrie door dit pakket gerepareerd.
4. Plaats geen nieuwe stations voor een routeproef: de lijnverbinding blijft onopgelost. Eerst volgt verder onderzoek naar een ondersteunde omkeerbare tramroute.

Het stationsscript is byte voor byte hersteld uit commit b80d3a1 (0.2.1): uitlijnrichting, grondafwerking en correcte perronhaltepunten blijven behouden. De extra alleen-lezen diagnose uit revision 6 blijft beschikbaar, maar verandert geen wereldobjecten.

De eerdere speltest bewees wel een ingaand pad en geen teruggaand pad. Hij bewees niet dat expliciet overlappende tegengestelde edges toegelaten waren. De lokale controles hadden die enginebeperking niet gemodelleerd. De nieuwe regressiecontrole wijst de oude crashconstructie aantoonbaar af door ook de omgekeerde curvevorm als dubbele geometrie te behandelen.
