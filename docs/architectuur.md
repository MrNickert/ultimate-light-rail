# Architectuur 0.8.0

De bestaande resources `twin_terminus.con.lua` en `twin_terminus.script.lua` blijven bestaan. Het script gebruikt nu de gedeelde bouwer `terminus_util.lua`. Die levert dezelfde 80m perrons, 30m kruiswissel, interne voertuiglanen en korte dubbele externe STREET-aansluiting.

`underground_terminus.script.lua` gebruikt dezelfde bouwer, verplaatst de voertuiglanen naar z=-18 en maakt de vooraansluiting een tunnel. Terminals behouden dezelfde voertuigknopen. De voetgangerslanen en stationshal komen uit `underground_entrance_util.lua`: layoutdata aangepast uit het native ondergrondse station, met directe verwijzingen naar geïnstalleerde modellen. De native hal is op x=60 gecentreerd, met 90 graden gedraaide ingang boven de kop (straatvlak x=69..84, y=-8..8); verlengstukken bedekken het wisselgedeelte. De publieke ingang en het kleine terreinvlak blijven op straatniveau. De perronpaden blijven op x=0..80, met knopen bij de verplaatste trappen. De gesloten achterkant krijgt een native muur voor de oorspronkelijke tunnelopening; alleen de andere kant heeft een spooraansluiting. De terminalverwijzingen worden naar de twee native perronpaden omgezet.

Het interne, verborgen `lightrail_double.street_template.lua` behoudt zijn ID voor bestaande saves. De vier tramvervoersmodi zijn alleen binnen het station en de korte aansluiting nodig om omkeren mogelijk te maken. Gebruik tussen stations de gewone native tramtrack. Er is geen voertuigpatch, trein-tramovergang, routeplannerpatch, automatische verbouwing of diagnosehook.

Voertuiglanen en aansluiting: 80/3,6 m/s; kruiswissels: 40/3,6 m/s. Bestaande opgeslagen constructiegeometrie wordt niet automatisch herbouwd.

## Bovengrondse afwerking 0.8.2

De publieke surface-adapter roept na de gedeelde bouwer `surface_station_util.lua` aan. Alleen deze adapter kent de nieuwe aankleding. Het module verandert geen voertuiglanen, externe sporen, terminals, kosten of snelheden. Bestaande voetgangerspunten en shelters komen op z=0,25. `surface_platform.mdl` bevat uitsluitend de native moderne perron-LOD-meshes en materiaalverwijzingen, zonder de native transportmetadata. Vier 40m modules vormen twee perrons en een brede module vormt het kopplein. Vanaf 0.8.3 gebruikt het spoorbed uitsluitend de native asfaltgrondtextuur; drie afgeplatte modellen zijn verwijderd omdat hun vloer met het terrein samenviel. De ondergrondse updater gebruikt rechtstreeks de gedeelde bouwer en krijgt deze modellen niet.

## Tramweergave en plein 0.8.4

De oppervlakte-adapter verwijdert de kale railmodellen op maaiveld uit het gedeelde bouwresultaat, zonder de rijlanen te veranderen. Kleine vlakke strips van 0,5m volgen de Hermite-curven. De oorspronkelijke stripmesh gebruikt het native transparante new_medium_tram_track-materiaal. De stroken liggen 15-18mm boven het asfalt; elke wisselroute krijgt een eigen laag om coplanaire overlap bij het kruis te vermijden. De decoratieve bovenleidingsdraden blijven bestaan.

Vier native 5x10m head_con-modules bedekken x=80..90, y=-9..9; alleen de breedte schaalt 10% om het tegelpatroon vrijwel gelijk te houden. De oude tot 10x18m vervormde 40m perronmodule is verwijderd. Twee boompjes met boomroosters staan op x=88,5, y=+/-5,5. Vier bakken met azalea staan op x=82/88, y=+/-8,2. De wandelverbinding op x=85 en toegang op y=0 blijven vrij van meubels en stammen. De kroon blijft achter het einde van de bovenleiding op x=80.
