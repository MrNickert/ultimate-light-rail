## 0.13.2: straatsnap-frame bij maaiveldingang — engineproef open

Gebruiker bevestigt 0.13.1-stationsuiterlijk goed, maar automatische snap aan een weg blijft onplaatsbaar. Een andere straatopstelling kan wel geplaatst worden, maar lijkt geen voetgangersrouting te geven. Gebruiker vermoedt clash met betonpalen.

Broncontrole: native underground_station gebruikt een identity straatsnap-frame aan de voorrand van zijn ingang, met voetgangersknoop 1m naar binnen. Onze elevated-ingang ligt aan negatieve Y en de voorrand loopt langs X, maar zijn snap-frame was nog -90 graden gedraaid als een rail-eindaansluiting. Dat biedt de weg dwars over de stations-/pijlerindeling aan. Correctie: identity frame op (L/2,-15,0), publieke ingang blijft (L/2,-14,0). Geen wijziging aan spoor, betonbak, palen, hoogte, trappen of interne routes.

Nieuwe geometrische regressiechecks toetsen dat de straattangent evenwijdig aan de entreevoorrand loopt, de voetgangersknoop gecentreerd en 1m naar binnen ligt, en lage solid onderdelen buiten de aangeboden straatvoorrand blijven. Alle 20 elevated-keuzes en bestaande tests worden behouden. Dit bewijst geen native engine-snap of stoepkoppeling.

Nog in-game: NIEUW elevated-station direct aan een rechte maaiveldweg laten snappen; weg moet langs centrale entree lopen. Plaatsing zonder Collision, zichtbare/native voetgangerslink en instappen via beide trappen bevestigen. De handmatig bruikbare straatopstelling uit 0.13.1 is geen bewijs voor de automatische snap.

## 0.13.1: starre betonbak, entreecollision en +12m — nieuwe engineproef

Gebruiker: verhoogd station snapt aan straat maar weigert plaatsing (Collision). Los plaatsen lukt; grote gaten/ontbrekende ondergrond, spooraansluiting werkt wel. Vraag of +8m voldoende is voor de weg.

Oorzaken/onderbouwing: native c_6_rep_rep gebruikt skin/skinMaterials en SKINNING_PHYS_NRML_MAP, bedoeld voor de native brugrenderer; bounding boxes alleen bewijzen geen correct standalone renderen. De nieuwe originele gesloten mesh heeft 24 vertices / 12 driehoeken, harde normalen, atlas-UVs in het egale betongebied en het native c_concrete_unskinned-materiaal. Geen skin of bone-afhankelijkheid. Ook piers/fascia's zijn starre betonunits; spoorbed heeft een volledige bodem en lage opstaande betonranden. Brugranden zelf blijven native BRIDGE; aansluiting niet verplaatst in x/y.

Hoogte: 0.13.0 spoor +8m gaf onder de balken slechts 6.4m. Native street_light_eu_c is 7.17608m, tram_pole_crossbar 8.5m. Daarom spoor nu +12m, perron +12.25m en balkonderkant +10.4m. Twee trapvluchten zijn 18m lang met 61 treden per vlucht (circa 29.5cm diep/20.1cm hoog), ondersteuningsplaten en verplaatste pijlers buiten het grotere trapgat. Eén centrale ingang en bestaande spoorlogica behouden.

Collisioncorrectie bij ingang: de grondvloer gebruikt een aparte zero-collider visual en het native shelter-uiterlijk krijgt een zero-collider wrapper zonder transportmetadata. Structurele betononderdelen blijven solid. Dit voorkomt dat decoratieve entreeonderdelen de straataansluiting blokkeren; de echte plaatsing moet nog in-game worden bevestigd. Grondpad is verbreed zodat beide trapvoeten erop staan.

Controles: alle 60 combinaties slagen; extra controles op daadwerkelijk gesloten mesh (manifold edges, winding/normals, volume en UVs), uitsluitend ongeskinde betonmaterialen/meshes, doorlopend spoorbed onder beide rails, nul entreecolliders en native wegmeubilair met minimaal 1m marge onder de balken. Geen wijziging aan bestaande boven-/ondergrondse stations. Pakket: 44 bestanden.

Nog in-game: NIEUW station direct aan bestaande maaiveldweg, ook met lampen/bovenleiding, doorlopende zichtbare betonbak, trap/pijler-aansluitingen, spoor op +12m, route/boarding en opslaan/herladen. Niet als bewezen opgelost rapporteren vóór deze proef.

## 0.13.0: Elevated — engineproef open

Eerder: gebruiker bevestigt alle lengtes van 0.12.0 werkend, boven- en ondergronds. Te lange toestellen lopen vast op korte kopstations; bekende gebruiksbeperking (passende lengte kiezen), geen wijziging aan reserveringslogica.

Nieuw: placement=3 (bestaande indices 1/2 blijven gelijk), alle vijf lengtes en kop/doorgaand. Spoor +8m, perron +8.25m. Native betonnen brugdelen bouwen een aparte dekconstructie, dwarsbalken en pijlers. Trapgaten zijn echte openingen in het horizontale dek. Twee trapvluchten met samen 82 zichtbare treden (circa 29.3cm diep / 20.1cm hoog) en twee schuine betonnen ondersteuningsplaten lopen van maaiveld tot perron. Eén linkable publieke grondingang op (L/2,-14,0) bereikt via een concourse beide trappen/perrons. Geen voetgangersaansluitingen op hoogte, geen grondwal. Kleine terrainpads alleen bij ingang en pijlerfunderingen. Native BRIDGE-approaches verwijzen naar de concrete bridge resource. Verplichte veiligheidsleuningen staan los van optionele aansluithekken. Basisprijzen/capaciteit gelijk aan bovengronds voor dit prototype.

Onderzoek: native perron_5_underpass-mesh loopt zichtbaar slechts tot z=-2.9; de native loopcurves gaan tot -7. Daarom is die verborgen onderdoorgang niet als elevated-trap gebruikt. De nieuwe eigen trapopbouw gebruikt uitsluitend native concrete meshes/materials via modelverwijzingen; geen nieuwe afbeelding of native binaries gedistribueerd.

Lokale checks: alle 20 elevated-combinaties; dezelfde voertuigposities/tangenten/rijrichtingen/reserveringen als bovengronds, verschoven naar +8m; één publieke grondingang naar beide wachtperrons; 82 zichtbare treden, twee dragende trapplaten, geen horizontaal dek in trapgaten, pijlers buiten centrale trappen/concourse, native brugranden en leuningen. De native modelafmetingen waarop de schaalberekeningen steunen worden tegen de geïnstalleerde game gecontroleerd. Alle bestaande 40 combinaties plus legacy-tests blijven groen. Pakket: 39 bestanden, complete native/lokale resourceverwijzingen en lokalisatie.

Nog in-game: nieuwe elevated-plaatsing op vlak terrein, native BRIDGE-randen/brugkeuze en aansluitingen op +8m, botsingen bij grondstraat en pijlers, uitstraling/hoogte van dek en trapdelen, daadwerkelijke boarding op beide perrons via de centrale ingang, meerdere voertuigen, kopstation en alle lengtes, opslaan/herladen. Lokale tests bewijzen deze punten niet.

## 0.12.0: vijf perronlengtes — engineproef open

Nieuwe vierde menuparameter platformLength: 1=40, 2=60, 3=80 (default), 4=100, 5=120 meter. Sleutel ontbreekt in bestaande saves: 80m. Onbekende index valt terug op 80m. Alleen de configuratieadapter zet de index om naar een lengte; bestaande losse adapters blijven standaard 80m.

Perrons worden opgebouwd uit vlakke deckstukken en de ongeschaalde native 40m-trapmodule. Bij 40m doorgaand vervallen losse deckverlengingen; twee buitenste toegangen gebruiken bestaande native loopknopen op 1.5/38.5m. Bovenleidingpalen staan buiten trapopeningen. De wisselstraat blijft 30m; vehicleNode blijft dezelfde index met coördinaat L/2. Ingangen/kop/tweede spooraansluiting, hekken, footprint en wachtposities volgen L. Ondergrondse shell wordt aangevuld met native modules; trappen/meubilair worden niet opgerekt. Bouwkosten, onderhoud, capaciteit, snelheid, rijrichting en reserveringsgedrag blijven gelijk.

Lokale tests: 40 combinaties van lengte × ligging × stationstype × hek met echte native helpers. Zichtbare perrondekking exact 0..L zonder gaten/overlap, geldige terminalrefs, middenstop, vaste wisselvorm, alle publieke ingangen bereiken beide perrons, geen dubbele of nul-lengte loopcurves, juiste tunnel-/hek-/kopposities en eindige modeltransforms. Een eenmalige onafhankelijke vergelijking met uitgepakte content uit de gecommitte 0.11.1-versie bevestigt voor alle acht standaard-80m-resultaten exacte gelijkheid, inclusief alle modellen en native geometrie.

Nog in-game: de vier nieuwe lengtes, vooral 40 en 120m, voor alle vier stationstypen. Plaatsing, visualisatie, aansluitingen, voertuigstop/boarding, opslaan/herladen en bestaande 80m-stations. Het menu en de 80m-varianten waren door gebruiker eerder als foutloos getest geaccepteerd; dat bewijst de nieuwe maten niet.

## 0.11.1: native stationsicoon; gameproef 0.11.0 geslaagd

Gebruiker bevestigt: alles van 0.11.0 getest en foutloos. Hiermee is het gecombineerde menu met de stationvarianten als geslaagd geaccepteerd. Dit is een gebruikersbevestiging, geen afzonderlijke telemetrie/meting per functie.

Op verzoek gebruikt het nieuwe stationmenu nu hetzelfde native onderdoorgang-icoon en preview als het eerdere doorgaande station: addon_platform_passenger_stairs_era_c. Geen beeldgeneratie. Geen wijzigingen aan rijpaden, geometrie, instellingen of kosten. Oude open gameproeven hieronder beschrijven de status vóór deze bevestiging.

## 0.11.0: één stationmenu en ondergronds doorgaand — engineproef open

Nieuw `light_rail_station.con.lua` met precies drie native knopgroepen: placement, stationType, fence. Het hek wordt via de native checkEnabledScript-callback uitgeschakeld ondergronds; de builder negeert die keuze daar ook. Geen publieke crossoverparameter: terminus forceert 2 (kruiswissel), doorgaand 1 (geen). Parameters worden gekopieerd, niet gemuteerd.

De oude drie .con-ID's blijven bestaan met dezelfde parameters/updateScript; uitsluitend hun menucategorieën zijn leeg gemaakt. Bestaande .script-bestanden zijn ongewijzigd. De bestaande entrance-util krijgt een optionele through-layout, met ongewijzigd gedrag zonder opties. De aparte weergaveknop voor ondergronds schakelt niet automatisch mee met de nieuwe liggingparameter.

Lokale configuratietest gebruikt de echte uitgepakte native lane/model/terrain-helpers. Alle acht combinaties slagen. Bovengronds met hek en ondergronds terminus worden volledig vergeleken met de bestaande builders. Rijpaden en terminalreferenties zijn bij hek aan/uit gelijk. Nieuwe ondergrondse doorgang: twee native tramlanen op -18m, twee tunnelranden, native shell tot beide interne aansluitingen (-10/90), geen gesloten kopwand, voetgangersgraph van publieke ingang naar beide wachtperrons op -17.65m. Packagecontrole telt 38 bestanden en complete lokale/native verwijzingen en lokalisatie.

Nog door gebruiker in-game te bevestigen: één menu-entry/knoppen, grijze hekoptie ondergronds, alle vier ligging/type-combinaties, hekken aan/uit zonder openingen op verkeerde plekken, ondergronds doorgaand met twee tunnels, lijn/instappen op beide perrons, opslaan/herladen en behoud oude stations. Hoofd-risico nieuw ondergronds doorgaand: visuele shell-/tunnelovergangen en enginevalidatie van plaatsing/voetgangertoegang. Bestaande 0.10.4 door gebruiker goedgekeurd.

## 0.10.4: tweede uiteinde doorgaand station — engineproef open

Gebruiker bevestigt voor 0.10.3: terminus goed, aanklikkant doorgaand station goed, andere uiteinde nu een gat in beide hekzijden. De twee niet-aaneengesloten straatsegmenten zaten samen in één edgeList. Hypothese: decoratie van die lijst wordt niet voor beide losse segmenten gelijk verwerkt.

Wijziging uitsluitend in het doorgaande station: twee afzonderlijke edgeLists, elk één native STREET-segment met hetzelfde lightrailprofiel. Alle posities, tangenten, buitenste snap/free-eindpunten, interne rijpaden, snelheden, hekken en voetgangerstoegang blijven gelijk. Terminus en afbeeldingen ongewijzigd. Lokale controles toetsen expliciet de oorspronkelijke vier posities en tangenten plus correcte lokale snap-indexen. Dit bewijst de enginehypothese niet.

Nog in-game: nieuw doorgaand station direct aansluiten, hek aan beide uiteinden controleren, voertuigen in beide richtingen, opslaan/herladen. De eerder goedgekeurde terminus hoeft niet opnieuw geplaatst.

## 0.10.3: hek bij automatische aansluitingen — nog in-game testen

Gebruiker bevestigt dat 0.10.2 op NIEUWE stations aan de automatisch aanklikkende kant een hekgat toont (beide spoorzijden), en een Collision bij direct plaatsen aan een bestaand netwerk. Zowel doorgaand als terminus. Rechteruiteinde sloot wel goed aan. Vaste hekmodellen stonden op aanklikbare straatranden; vermoedelijke oorzaak is overlap met gegenereerde junctiongeometrie.

Wijziging: vaste hekken uitsluitend langs interne rijpaden (terminus -30..0, doorgaand -10..0 en 80..90). De buitenste 10m straatranden krijgen native randdecoraties zodat de engine de junctionopeningen kan bepalen. Nieuwe verborgen SURFACE-aanloopvariant behoudt alle bestaande terminusmodi; origineel gedeeld/ondergronds profiel blijft ongewijzigd. Doorgaande buitenranden gebruiken het geteste native-equivalente lightrailprofiel. Hekmodel heeft nul botsingsvolume, zoals tramdecals. Perrons/toegangen blijven vrij. Menuillustratie: palen buiten hek, twee contactdraden en dwarskabels, korter stuk.

Lokale controles toetsen onveranderde profieldata, rijpaden, voetgangertoegang, nul hekcollider en geen vaste hekmodellen op snapranden. Dit bewijst geen engineplaatsing: opnieuw direct aanklikken links/rechts, beide stationstypes, aansluiting op gewone tramtrack en lightrail, T-kruising, rijden en opslaan/herladen testen. Gebruik een nieuw station.

## 0.10.2: stationsaansluitingen tot aan perron

Gebruiker bevestigt in 0.10.1 de hekoriëntatie en vrije kruisingen; screenshot toont ook een voertuig op het spoor. Op verzoek alleen hek langs de bovengrondse stationsaansluitingen, niet langs de perrons: kopstation x=-40..0; doorgaand x=-20..0 en x=80..100, beide buitenzijden y=±5.65. Perrons, alle zes publieke toegangen, kopplein en ondergrondse constructie blijven vrij/ongewijzigd. Alleen visuele modellen toegevoegd; geen lanen, reserveringen, aansluitprofielen of kosten gewijzigd. Menuafbeelding gespiegeld met kortere sectie.

Nog in-game: nieuw kopstation en doorgaand station plaatsen, hekcontinuïteit met aansluitende rails en hekstop vóór de perrons controleren. Bestaande stations worden niet automatisch verbouwd.

## 0.10.1: draaiing hek en eigen menuafbeelding

Gebruiker bevestigt op screenshots van 0.10.0: hek langs beide buitenzijden en vrije kruisingen. Panelen staan echter dwars op de railrichting. De oorspronkelijke model-Y-as moet naar de X-as van de edge-herhaling worden gedraaid. De wrapper roteert nu 90 graden, inclusief bounding box/collider; lengte, offset en edge-instellingen blijven gelijk. Nieuwe regressiecontrole transformeert de native paneeluiteinden en controleert richting, herhaallengte en alle bounding-boxhoeken. Eigen transparante menuafbeelding en preview toegevoegd.

Nog in-game: een nieuw stuk spoor tekenen, doorlopend hek in lengterichting beoordelen, kruising opnieuw controleren, bocht/helling, aansluitingen en meerdere voertuigen. Bestaande plaatsingen kunnen gecachte geometrie behouden; voor een duidelijke vergelijking een nieuw stuk tekenen.

## 0.10.0: lightrail met hek — engineproef nog open

De nieuwe publieke lightrailoptie is afgeleid van native tram_new; alleen naam, menuvolgorde en twee buitenste randdecoraties verschillen. Het verborgen gemengde stationsaansluitprofiel wordt hiervoor niet gebruikt. Bestaande stations en rails zijn ongewijzigd.

Nog in-game: plaatsing vanaf het menu, hek aan beide buitenzijden, curves/hellingen, vrije kruisingen/wegovergangen, stationsaansluitingen, tunnel/brug en meerdere trams zonder blokkades; vervolgens opslaan/herladen. De native metalen hekpanelen moeten nog op uitstraling worden beoordeeld.

# Teststatus 0.9.3 — Ultimate Light Rail

## Actuele bevestiging — 2 november 2026

De gebruiker meldt dat in-/uitstappen ook op het andere perron werkt en beschouwt de uitgebreide doorgaande-stationproef als geslaagd. Daarmee is het functioneren van de verbinding en beide perrons door de gebruiker geaccepteerd. De lokale controles bevestigen bovendien dat alle zes toegangen beide perrons via de onderdoorgang kunnen bereiken; niet elk individueel toegangspunt of traptraject is afzonderlijk als spelproef vastgelegd.

De gebruiker meldt ook dat de snelheid na 0.9.1 beter voelt. Exacte maximumsnelheden zijn niet gemeten. Opslaan/herladen van de laatste doorgaande variant is niet afzonderlijk bevestigd. Deze punten worden niet als uitgevoerde proeven gerapporteerd.

Versie 0.9.3 hernoemt de mod naar Ultimate Light Rail. Alle stationsbestanden, snelheden, vervoersnetwerken, interne mod-ID en resourceverwijzingen blijven gelijk aan 0.9.2. Voor de hernoeming is geen nieuwe plaatsingsproef nodig.

## Historische testnotities

De onderstaande notities bevatten eerdere open punten en tussenresultaten; de actuele stand staat hierboven.

## Historische proef 0.9.0

De kopstationbasis blijft geaccepteerd. De doorgaande variant met native onderdoorgang is nu toegevoegd en lokaal gecontroleerd, maar nog niet in de game getest. De eerste spelproef staat in docs/installatie.md. Instelbare lengte, type en aantal perronsporen blijven vervolgwerk.

## Afgeronde basis — 2 november 2026

De gebruiker accepteert de vormgeving van het bovengrondse kopstation in 0.8.6, inclusief de aansluitende bredere wisselondergrond, doorlopende trambestrating, het compacte kopplein en het groen. Instappen via de verkorte toegang is bevestigd op 0.8.5. De bestaande rij-/keer-/conflictproeven blijven referenties. Deze afwerkingsronde is op verzoek van de gebruiker afgerond.

Open, apart vervolgonderzoek: circa 13 km/u bij binnenkomst en 23 km/u bij vertrek. In het gecontroleerde stdout.txt stond geen [UMSPEED]-rapport. De oorzaak is niet vastgesteld en de snelheid is niet als opgelost gemarkeerd. De meetmod blijft optioneel; er wordt in deze afronding geen geometrie, voertuig of limiet veranderd.

Een doorgaande metrovariant is besproken als mogelijke volgende stap. De gebruiker vraagt eerst naar het functionele verschil met de standaard tramhalte; er was op dat moment nog geen nieuwe stationsvariant geïmplementeerd. Het directe onderscheid zou vooral de consistente 80m perrons, vormgeving en toegang zijn.

Onderstaande secties beschrijven eerdere versies en controles; open punten daarin zijn historisch tenzij hierboven genoemd.

## Door de gebruiker bevestigd op het bovengrondse station

- Omkeren aan het perron, deuren en verlichting.
- Gewone native tramtrack en tramremise aansluiten.
- Meerdere voertuigen op twee drukke kruisende lijnen: wachten en verderrijden bij vrijgegeven wisselroutes.
- Voetgangers bereiken de halte en stappen in.
- Opslaan/herladen en opschoning van oude proefobjecten.

## Lokaal gecontroleerd in 0.8.1

- Bestaande station-ID, parameters, wisselopties en geometrie blijven behouden.
- Ondergronds zijn alle voertuigposities exact 18m lager, met dezelfde tangenten en reserveringsvlaggen.
- Native voetgangerslanen verbinden de publieke ingang op z=0 met beide perrons op z=-17,65.
- Native model-, botsings- en terreingeometrie wordt opgebouwd met de geïnstalleerde Lua-hulpfuncties. Alleen het ingangsvlak wordt bovengronds uitgelijnd.
- Snelheidsgrenzen: 80 km/u recht, 40 km/u wissel; omrekening naar m/s.
- Beide wisselopties, lokale afhankelijkheden, vertalingen, afbeeldingsformaten en zip-inhoud.

## Nog in de game te testen

Plaatsbaarheid van de ondergrondse versie, uitlijning en beeld van hal/wissel, tunnel aansluiten en doorrijden, openbare weg naar de ingang, instappen op beide perrons en opslaan/herladen met het nieuwe station. De lokale voetgangerscontrole bevestigt een verbonden pad, maar vervangt geen proef met passagiers in de game. Snelheidslimieten zijn maxima: voertuigen remmen ook voor de halte, bochten en reserveringen.

## Gebruikersproef en wijziging 0.8.1

De gebruiker bevestigde dat het ondergrondse station functioneert zoals verwacht en de hogere wisselsnelheid beter werkt. Versie 0.8.1 behoudt alle voertuigpaden en snelheden. Alleen de native stationshal en voetgangersingang zijn naar de kop verplaatst en gedraaid, met een zichtbare afsluitmuur. De nieuwe ingang en plaatsing moeten nog in de game worden getest. Menu-iconen en previews hebben nu echte alpha-transparantie.

## 0.8.2 bovengrondse aankleding

De gedeelde voertuigbouwer en de volledige ondergrondse variant blijven gelijk aan 0.8.1. De bovengrondse adapter voegt visuele perronvlakken en inrichting toe en zet alleen de bestaande voetgangerspunten op 0,25m hoogte. De visuele perrondefinitie bevat geen native transportmetadata. Bovenleidingsdraden zijn decoratieve modellen; de bestaande elektrische vervoersmodi blijven de werking bepalen. Nieuw te testen: visuele uitlijning, perronhoogte, vrije doorgang langs meubels, aansluiting van de verhoogde voetgangersingang op de straat en instappen.

## 0.8.4 spoorbedweergave

Gebruikersbeeld: zwarte en witte strepen op het spoorbed. De afgeplatte native perronvloer was op exact z=0 geplaatst, gelijk aan het terreinoppervlak. De drie extra spoorbedmodellen zijn verwijderd; de native asfaltgrondtextuur blijft actief. De controle bewaakt dat alleen de vier verhoogde perronmodules en het kopplein als perronmesh voorkomen. De visuele bevestiging van de hotfix volgt nog in de game.

## 0.8.4 tegelpatroon, tramstroken en groen

De vervormde pleinmodule wordt vervangen door vier native 5x10m verbindingsstukken (100% lengte, 90% breedte). Een oorspronkelijke vierpuntsstrook gebruikt het bestaande native tramspoor-materiaal, zonder spoorwegmodellen op maaiveld. Bomen, boombakken, plantenbakken en bloemstruiken staan alleen op het kopplein. Controleer in de game de decalweergave, wisselovergangen en wandelruimte; lokale controles vervangen de beeldproef niet.

## 0.8.5 compact plein en native kleurinvulling

Eén rij koptegels is verwijderd. De bomen en bloembakken staan dichter bij elkaar; de wandelverbinding loopt op x=81,5 naar een publieke toegang op x=85. Gedeelde voetgangerspunten worden één keer verplaatst, met opnieuw berekende tangenten. De native .street gebruikt zowel new_medium_tram_track als new_medium_tram_paving; de laatste ontbrak in de interne weergave. Beide lagen worden nu langs elk bestaand rijpad opgebouwd, op verschillende hoogten boven de grindgrond. Geen aanpassing aan voertuigroutes of de ondergrondse variant.

## Gebruikersbevestiging 0.8.5 en vervolg 0.8.6

Instappen via het compacte kopplein is bevestigd. De gebruiker ziet bij de wissel circa 13 km/u bij binnenkomst en 23 km/u bij vertrek; de tram versnelt zodra ongeveer 80% voorbij de wissel is. Dit bewijst nog niet welke engine-limiet de oorzaak is. De gewone 0.8.6 verandert de snelheid en rijgeometrie niet. Alleen de wisselondergrond wordt 11m breed. Een afzonderlijke read-only probe leest effectieve ingestelde en bochtlimieten uit; het engine-rapport is nog nodig voordat een snelheidsoplossing gekozen wordt.

## Doorgaand station 0.9.0

Nieuwe prototypevariant, nog geen bevestigde spelproef. De lokale test controleert twee native spoorverbindingen, tegenovergestelde gerichte tramlanen zonder railmodi/reserveringsvlag, twee terminalpunten op de perronmiddens, bereikbaarheid van alle wachtpunten vanaf beide zijingangen, uitsluitend ondergrondse passage tussen de perrons, eindige traptangenten en twee terreinopeningen buiten het spoorbed. Het zichtmodel bevat geen eigen transportmetadata en vult de perronopening niet met extra vlakke modellen.

De bestaande bovengrondse kopstationuitvoer is volledig vergeleken met de vorige commit voor beide wisselinstellingen: modellen, voetgangerspunten, rijpaden en alle overige resultaatvelden zijn identiek. De bestaande ondergrondse helper en voertuigbouwer zijn niet aangepast. De reguliere controles en verpakking zijn groen.

Nog in de game te testen: plaatsen, beide aansluitingen, heen/terug-lijnroute, passagiers en trap-/terreinuitlijning, instappen en opslaan/herladen. De native trapgeometrie is ongeschaald; de vloer is door verticale verplaatsing op de lage metroperrons afgestemd.

## Gebruikersproef 0.9.0 en snelheidscorrectie 0.9.1

De gebruiker meldt dat de doorgaande variant direct werkt en toont voertuigen op beide sporen. Afzonderlijke bevestiging van voetgangers door de onderdoorgang en save/herladen blijft open. Ook op het rechte station blijft de tram circa 23 km/u rijden. Omdat de stationsbouwcode 80/3,6 = 22,22 doorgaf, wordt vanaf 0.9.1 voor dit veld de directe native conventie gebruikt: recht 80 en wissel 40. Straatprofielen houden hun aparte m/s-conversie. Lokale tests bewaken dit onderscheid. De daadwerkelijke snelheid na deze wijziging moet nog in de game worden bevestigd; er is nog geen UMSPEED-rapport beschikbaar. Geometrie, reserveringsvlaggen en voertuigprestaties veranderen niet.

## Toegangen 0.9.2 en gebruikerswaarneming snelheid

De gebruiker meldt dat de snelheid na 0.9.1 beter voelt; er is nog geen exacte meting van de maxima. De doorgaande variant krijgt zes afzonderlijke linkbare voetgangerslanen, drie per perron. De lokale graaftest controleert dat elk toegangspunt alle wachtpunten op beide perrons bereikt, dat de middentoegang geen bestaande native randcurve dupliceert en dat passage tussen de perrons uitsluitend ondergronds verloopt. De nieuwe automatische straatverbindingen moeten nog in de game worden bevestigd.
