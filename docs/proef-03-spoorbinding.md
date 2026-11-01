# Proef 03: directe haltebinding op gewone tramtrack

Versie 0.3.0 / revision 8. Een afzonderlijke onderzoeksconstructie: UM Track-bound Stop (Test), Nederlands UM Spoorgebonden Halte (Test).

## Onderzoeksvraag

Een native treinstation gebruikt echte TRACK-edgeLists en verwijst vanuit de terminal met vehicleNode={-1,n} rechtstreeks naar een endpoint in die lijsten. De raw zero-based index n wordt afgeleid uit de segmentuiteinden. De bestaande tramhalte gebruikt eigen interne voertuig-laneLists. In ons kopstation blijken die voor de geteste TRAM-paden slechts in de getekende richting bruikbaar. Expliciet exact tegengestelde voertuigcurves veroorzaken dubbele edges en een enginecrash; die aanpak is ingetrokken.

Deze proef neemt alleen de directe halteverwijzing over. Het spoor blijft de standaard STREET-tramtemplate, inclusief beide native richtingslanes en elektrische infrastructuur. Twee echte segmenten beslaan de hele 80 meter, met een gedeeld middenpunt. Er zijn geen interne voertuig-laneLists, geen nieuwe spoorprofielen, geen tegenrichtingduplicaten, geen spoorovergang naar treinrails en geen wissels.

**Niet bewezen:** accepteert de engine de railstationverwijzing voor een STREET-tramtemplate? Naar welke van de twee gegenereerde richtinglanes verwijst het haltepunt? Krijgt de terminal de juiste modus en kan een tram er stoppen? Het lokale spelmateriaal bevat geen bevestigde STREET-stationimplementatie met deze negatieve lane-index. De native railcode maakt het een gerichte hypothese, geen garantie op een geldige constructie. Het kopstationgedrag is hiermee nog niet opgelost.

## Eerste speltest: alleen plaatsen

1. Bewaar je gewone testsave van voor de eerdere crash en sluit het spel. Vervang de bestanden van dezelfde mod met dit pakket. Gebruik niet de ongeldige crashsave uit 0.2.2.
2. Open een aparte kopie of kleine lege testkaart. Zoek in het wegstationsmenu naar **UM Track-bound Stop (Test)** / **UM Spoorgebonden Halte (Test)**. De oudere prototypehaltes blijven beschikbaar, maar horen niet bij deze proef.
3. Plaats slechts een nieuwe halte op vlakke, vrije grond. De hele halte hoort standaard tramsporen te tonen, met een perron en wachthuisje ernaast. Aansluiten op een bestaand netwerk is voor deze eerste controle niet nodig.
4. Als plaatsen lukt: laat vijf tot tien seconden ongepauzeerd lopen, pauzeer en meld dat het klaarstaat. De diagnose wacht voor dit nieuwe type niet op twee haltes.
5. Bouw nog geen tweede halte en maak nog geen lijn. Eerst moet het log aantonen waar de terminal daadwerkelijk gekoppeld is. Een mislukt of verkeerd gekoppeld haltepunt heeft geen routeproef nodig.

Deze combinatie is nog niet in de engine getest. De lokale controles kunnen een native fout of crash niet uitsluiten. Bij een crash bewaren we het log en stoppen we de proef; de oudere constructies worden niet automatisch aangepast. Het herstelpakket 0.2.3 blijft als aparte terugval beschikbaar.

## Beoordeling na plaatsen

Het rapport vermeldt het nieuwe constructietype, twee bevroren straatsegmenten, het werkelijk toegewezen terminalknooppunt, voertuigedges en richtingproeven. We controleren of de terminal op het middenpunt van de native tramlanes ligt en welke richting bruikbaar is. Alleen bij een geldige koppeling volgt een afzonderlijke proef met twee haltes en een doorlopend netwerk. Native keren vergt daarna nog een aparte oplossing en mag niet uit een doorgaande halte worden afgeleid.

## Bronnen en afbakening

Lokale TF3-build: base/content/stations/rail.zip, rail/modular_station/modular_station.script.lua, edgeLists.type=TRACK en terminal.vehicleNode={-1,...}; base/content/infrastructure/street.zip, street/tram/tram_new.street_template.lua; api/tealdef voor Terminal.vehicleNodeId en pathfinding.findPathNodeToNode. De nieuwe code is een minimale eigen constructie, zonder overgenomen volledige treinstationlogica of nieuwe 3D-assets.
