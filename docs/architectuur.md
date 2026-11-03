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

## Compacte kop en trambestrating 0.8.5

De koptegels bedekken x=80..85 in plaats van 80..90. De voetgangerskruising ligt op x=81,5, de publieke link eindigt op x=85 en het terrein-/grondvlak eindigt op x=87. Gedeelde voetgangerspunten worden eenmaal verplaatst en alle rechte voetgangerstangenten opnieuw berekend. Perrons en voertuiglanen blijven gelijk. De bomen staan op x=83,8 en de bloemvakken op x=81,2/83,8; y-posities en aantallen zijn behouden.

De native tram-street verwijst naar zowel new_medium_tram_paving als new_medium_tram_track. De grondtextuur street_fill verwijst naar gravel_03. Daarom vormt alleen die grondtextuur niet de zichtbare native kleurinvulling. tram_paving.mdl deelt de oorspronkelijke stripmesh met tram_ribbon.mdl, maar gebruikt het native bestratingsmateriaal op z=0,008..0,0086. De railtextuur ligt op z=0,015..0,018. Zo loopt de native vulling ook langs de wisselcurven door zonder coplanair terrein te bedekken. Beide materialen en de externe aansluitbreedte zijn direct uit de geïnstalleerde tramresources gecontroleerd.

## Stationfamilie en doorgaande variant 0.9.0

`through_station.con.lua` is een eigen savebestendige adapter. `through_station_util.lua` definieert de nieuwe rij-/perronindeling; `passenger_underpass_util.lua` bouwt de voetgangersverbinding. `surface_station_util.lua` deelt de aankleding en accepteert expliciete variantenopties. De standaardaanroep van het bestaande kopstation heeft identieke uitvoer gehouden.

De doorgaande variant heeft twee gewone gerichte TRAM/ELECTRIC_TRAM-lanen en native tram-straatranden aan beide uiteinden. Geen kruiswissel, kopplein, keerfunctie of gemengde treinmodi. In de middenstukken van beide perrons vervangt het native underpass-model het vlakke perron. De native trapcurves zijn aangepast uit addon_platform_passenger_stairs_era_c.module.lua. Een verbinding onder de sporen sluit aan op de onderste trapknooppunten. Alleen bovenliggende perroncurves tellen als wacht-/instappunten. De twee openbare toegangspaden liggen op x=4, buiten de shelter op x=10.

De native module plaatst voetgangers op z=1,1. Het nieuwe station verplaatst het ongeschaalde trapmodel en de trappaden naar een vloer van z=0,25. De native ondergrondse knopen van -7 en -7,00125 zijn voor deze eigen samenvoeging naar één exact niveau genormaliseerd, z=-7,85. Native hole.gtex snijdt alleen de twee trapopeningen in de perrons, zonder het spoorbed open te breken. Er is geen eigen vlakke perronmesh over de trappen geplaatst.

Vervolgontwerp voor één configureerbare bouwoptie: een gedeelde layoutconfiguratie met `kind` (kop/doorgaand), `level` (boven/ondergronds), `length` en `platformTracks`. Bestaande constructie-ID's blijven als adapters behouden zodat huidige saves blijven laden. Vandaag is alleen de doorgaande 80m/twee-perronvariant geïmplementeerd; geen onbewezen lengte-/perronaantalkeuzes in de UI.

## Snelheidsvelden 0.9.1

Belangrijk onderscheid: de native ondergrondse stationsbouwer roept laneutil.createLane aan met speedLimit=40, zonder omzetting. Het native tram-straatprofiel gebruikt LaneConfig.speed=27,77778 voor 100 km/u. Na de gemelde circa 23 km/u op onze rechte doorgaande stationslanen is de stationswaarde 80/3,6 vervangen door rechtstreeks 80. Wissellanen krijgen rechtstreeks 40. Het eigen straatprofiel houdt speed=80/3,6. De geometrie en voertuigconfiguratie zijn niet aangepast. De precieze engine-interpretatie/effectieve snelheidswinst blijft een in-game controlepunt; de oude algemene aanname dat elk snelheidsveld dezelfde conversie nodig heeft geldt niet langer als vastgesteld.

## Zes openbare toegangen 0.9.2

De platformverlenging aan de achterzijde is gesplitst bij x=76. Linkbare voetgangerslanen worden per zijde aangemaakt op x=4/40/76. Begin- en eindtoegangen lopen van y=+/-11 via de perronrand +/-9 naar het loopspoor +/-5,5. De middentoegang eindigt op de bestaande native randknoop (40,+/-9): het native pad naar (40,+/-7,5) wordt hergebruikt. Daardoor ontstaat geen dubbele reverse edge en loopt de nieuwe toegang niet door het trapgat. De straatconnector kiest de daadwerkelijke korte verbinding naar nabijgelegen wegknopen. Het catchment-middelpunt is (40,0,0), met ongewijzigde straal160. De terminalreferenties worden zoals voorheen uit de gegenereerde bovenliggende wachtpaden afgeleid.

## Merknaam 0.9.3

De zichtbare modnaam is Ultimate Light Rail. De mod-ID mrnickert_ultimate_metro en alle contentresource-ID's blijven intact. Het installatiearchief heet nu ultimate-light-rail-0.9.3.zip, met dezelfde interne map. Dit is een metadata-/documentatiewijziging zonder migratie van wereldobjecten. Stationsnamen en de afzonderlijke historische Speed Probe zijn niet hernoemd.

## Afzonderlijk lightrailspoor 0.10.0

`lightrail_fenced.street_template.lua` behoudt native tram_new volledig qua verkeer; alleen beschrijving, menuvolgorde en defaultEdgeDecorations veranderen. `lightrail_fence.edge.lua` laat de engine de herhaling en aansluitingen verzorgen. De visuele wrapper gebruikt native metalen hekpanelen zonder transportmetadata. Het oude verborgen gemengde stationsprofiel wordt niet voor publieke rails gebruikt. Geen wereldmigratie of wijziging aan native resources.

## Configureerbaar station 0.11.0

Een nieuwe stabiele .con-ID bewaart drie 1-gebaseerde selecties: placement (1 boven, 2 onder), stationType (1 doorgaand, 2 kop), fence (1 nee, 2 ja). Defaults boven/kop/ja. `station_config_util` kopieert parameters en forceert het wisseltype op basis van stationType; een meegegeven oude crossoverwaarde kan dit niet overrulen. Boven gebruikt het de bestaande builders; zonder hek verwijdert het uitsluitend de visuele hekken en kiest het gelijkwaardige ongedecoreerde aansluitprofielen. De ondergrondse adapter deelt native ingang/circulatie voor beide typen, heeft geen hekken en forceert tunnels.

`underground_entrance_util(params, options)` houdt zijn oude standaardlay-out. `options.through` verkort de westelijke shell, verlengt de oostelijke shell en laat de kopwand weg. Persoonlijke lanes/terminalrefs blijven op de vaste 80m perrons. Legacy scripts blijven intact en legacy .con's zijn alleen uit het menu verborgen. Geen conversie/migratie van geplaatste objecten; geen postConstructionModifiable voor de nieuwe opties. Native checkEnabledScript verwerkt captureParams gevolgd door actuele menukeuzes. Het paneel gebruikt drie Button/Horizontal ScriptParams. De bestaande ondergrondse werkbalkweergave is onafhankelijk en wordt niet door een wereldhook gestuurd.

## Perronlengte 0.12.0

platformLength is een opgeslagen 1-gebaseerde index met default 3. Alleen station_config_util vertaalt deze naar 40/60/80/100/120m en geeft een aparte layoutoptie door. Legacy-scriptparameters blijven onaangeraakt en krijgen standaard L=80. Bounds, stopnode, voetgangersrefs, decks, tunnelmonden en ingang volgen L; de wisselstraat blijft vast. Vlakke platforms worden in maximaal 40m lange modelstukken opgebouwd; de native 40m-onderdoorgang en meubels houden hun schaal. Voor de 40m-doorgang zijn publieke toegangspunten op bestaande native loopknopen nodig om nul-lengte/verkeerd aangesloten extensies te vermijden. Parametrisering bewaart exact de oorspronkelijke 80m-resultaten (ook modelvolgorde/transforms), onafhankelijk gecontroleerd tegen de vorige commit. Geen nieuwe runtimebestanden, afbeeldingen of migratiehooks.

## Elevated 0.13.0

placement=3 dispatcht uitsluitend naar elevated_station_util; geen mutatie van bestaande boven-/ondergrondse builders. De adapter hergebruikt gevalideerde voertuiggeometrie en tramvisuals, vervangt de persoonspaden/platformbasis en bouwt de eigen constructie. Twee wachtlanen op +8.25m, twee rechte traplanen, een onderste cross-passage en precies één linkable ingang op maaiveld. Twee echte trapgaten van 12×2.4m; native betonunits vormen 41 treden per vlucht en een schuin afgeschoven draagplaat. Slabs worden in maximaal 6m delen herhaald. Native pier bot_m wordt naar de dwarsbalkhoogte geschaald; pijlers/balken vermijden het trappenhuis. Veiligheidsfascia's en trapleuningen altijd aanwezig, optionele hekken alleen bij de aansluiting. Grondconcourse/kleine pijlerpads blijven op z=0; geen terrein op spoorhoogte. Geometrie, gebouwde modelrefs en loopgraph zijn lokaal getest; native brug-/plaatsingsgenerator en visualisatie blijven een engineproef.

## Rigid elevated-constructie 0.13.1

Losse brugmodellen met skin/skinMaterials zijn vervangen door een originele gesloten boxmesh met de niet-skinned native betonshader. Een solid en een visual-only .mdl delen dezelfde mesh; alleen entreevloer gebruikt visual-only. De entreeoverkapping is een native visuele wrapper met nul collider/metadata. Pijlers, draagbalken, trapwaists en de betonbak gebruiken solid units. Sparse native bridge references blijven alleen in edgeTypeName voor echte brugranden. Spoorhoogte12, platform12.25, traprun18, 61 treden per vlucht; beamtop H-.8 en piertop H-1.6. Terrain blijft maaiveld. Code reproduceert alleen originele geometrie; geen gekopieerde native mesh/texture-binaries.

## Straatsnap-frame 0.13.2

Elevated-apronvoorrand is lokaal evenwijdig aan X op y=-14. Het native straatsnap-frame moet daarom identity zijn (X tangent, +Y naar binnen), op y=-15; publieke voetgangersknoop y=-14. Het oude -90° rail-eindframe bood de straat in de verkeerde richting aan. Geometrische tests koppelen frame-assen aan de werkelijke apronvoorrand en publieke knoop; geen model-/spoorverplaatsing of uitschakelen van constructieve collision.

## Elevated-aankleding 0.14.0

De visuele perron-/kapgrenzen volgen first/last van het volledige vaste constructiedek; operationele wacht- en voertuignetwerken blijven 0..L. De root-BRIDGE-stukken blijven vrij van extra vaste modellen. elevated_platform_roof.mdl behoudt native roof-meshes en verlichting, verwijdert geïntegreerde feets en krijgt een nauwkeurige collider boven de loopvloer. De builder plaatst losse native kolommen buiten de traprange. Catenarymasten zijn buitenwaarts geplaatst, armen herberekend en consoles toegevoegd; geen aanpassing van de voertuigbanen. Groen alleen op maaiveld naast vrijgehouden publieke route/straatfront; geen busnetwerkmutatie. Huidige menuafbeelding behouden.


## Stationscontract 0.15.0

De publieke configureerbare stationadapter normaliseert opgeslagen indices en roept station_api_v1 aan met station_standard_design. De API valideert de expliciete configuratie en roept private station_layout_builder aan. Deze dispatch hergebruikt ongewijzigde geometriebouwers. Zes visuele rollen vervangen uitsluitend model-ID's; de kern levert transforms en netwerken. Legacy scripts blijven behouden. Zie station-api-v1.md voor scope, beperkingen en het externe voorbeeld. De volledige 0.14.2-uitvoer is voor 72 gevallen vastgelegd vóór de refactor en blijft gelijk.


## Componenten 0.16.0

De standaardadapter gebruikt station_standard_kit met componentwaarden default. station_api_v1 accepteert assets of components, nooit beide. station_components valideert de vaste sleutels en 20m-declaraties en past uitsluitend sub.models aan. De klassieke assetconsumers en 72 volledige standaardresultaten blijven gelijk. Eigen hele 20m-perronstukken vervangen alleen volledige, vlakke en volle-breedtestukken; korte resten/trapstroken blijven kern. Generieke daken herhalen 0..L en delen native vaste supports. Bovengrondse masts verhuizen buiten de kap met behoud van contactdraadpositie. Elevated kapfalse verwijdert kappen plus hun losse supports; draagpijlers en veiligheid blijven. Ondergrondse hal accepteert uitsluitend defaults. Zie asset-kit-v1.md voor alle beperkingen.


## Expliciete standaardbouwsets 0.17.0

station_standard_kit(placement) geeft concrete modellen/afwezigheid voor surface/elevated en de vaste underground-halkern. De save-adapter gebruikt deze profielen rechtstreeks. Context-defaults uit externe componentontwerpen worden naar dezelfde profielen opgelost; false blijft expliciete afwezigheid. De standaardperrons/kappen zijn nu 20m-units, dezelfde API-route als add-ons. Het entreebankje behoudt zijn eigen model via de optionele benches.entranceModel-variant. Kopplein en vaste perronpasstukken sluiten op dezelfde 0,25m-vloer aan. De oorspronkelijke assets-contractvorm en verborgen legacy-scriptpaden blijven voor compatibiliteit behouden.

Vóór runtimewijzigingen is een afzonderlijke functionele 0.16.0-nulmeting vastgelegd. De 72 resultaten blijven gelijk met alleen models uitgezonderd; 27 underground/legacy-resultaten worden nog volledig tegen 0.14.2 vergeleken. De oude volledige manifest is bewaard. Dit maakt de bewuste modelmigratie apart reviewbaar van het behoud van functionele data.
