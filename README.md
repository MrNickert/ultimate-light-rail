# Ultimate Metro

Private technische proefmod voor Transport Fever 3, versie 0.1.0 / revision 1.

## Huidige scope

Een nieuwe bovengrondse tramhalte met één centraal rijpad en één logische terminal, bedoeld om aankomst en vertrek in beide richtingen te onderzoeken. De halte gebruikt een bestaande vanilla wachtruimte, grondtexturen en infrastructuurstijl. Er zijn geen nieuwe 3D-modellen ontworpen.

**Dit is geen bewezen werkend metrosysteem.** De native tramrouter, het verbinden van de gecentreerde interne rijpaden met normale tramtrack en de reizigerstoegang moeten in het spel worden getest. De middenstrook heeft voorlopig een eenvoudige grondafwerking; de complete rail-/bovenleidingweergave is nog niet uitgewerkt. Dit is een functionele onderzoeksasset.

De mod voegt uitsluitend resources toe onder de eigen mod-ID. Er worden geen bestaande haltes, voertuigen, lijnen of onderhoudsgegevens aangepast. Er is geen verborgen keerlus en geen script dat voertuigen automatisch omkeert.

## Testen

Zie [de eerste speltest](docs/proef-01.md). Gebruik een nieuwe kaart of een kopie van je save, één omkeerbare Citylink en twee nieuwe testhaltes. Zoek in het bestaande bouwmenu voor wegstations naar **UM Surface Stop (Test)**. De haltes hebben lengtes van 60, 80 of 120 meter.

Deze prototypeversie voegt een eigen constructie en intern straatprofiel toe. Verwijder de mod niet uit een save die deze objecten nog bevat; gebruik voor terugdraaien je originele testsave. De verwijderwaarschuwing is daarom conservatief op Critical gezet. Niet publiek publiceren.

## Later

Eigen Metro-interface en filters, een ondergrondse variant en daarna uitbreidbare stations. Meer perronsporen, twee haakse niveaus en aanvullende assets zijn vervolgwerk. De eerder besproken overstap naar treinspoor is niet de huidige proefroute.

## Ontwikkeling

Open deze map met het profiel Transport Fever 3 Modding. Lua- en Teal-extensies en de lokale TF3-definities zijn voorbereid. De prototypegeometrie is gewone Lua, zoals de oorspronkelijke stationsscripts.

```powershell
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_surface_stop.lua
python scripts/package.py
```

De controles buiten het spel testen configuratie, topologie en afbakening. Ze bewijzen niet dat TF3 de verbindingen en het keren accepteert.
