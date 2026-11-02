# Ultimate Light Rail

Versie 0.14.2, revision 43. Tramgebaseerde lightrailinfrastructuur voor Transport Fever 3. Interne mod-ID blijft `mrnickert_ultimate_metro` voor savecompatibiliteit.

## EÃƒÂ©n configureerbaar station

Zoek **Lightrailstation / Light Rail Station** in het wegstationsmenu. Het native instellingenpaneel heeft vier keuzes:

| Instelling | Keuzes |
| --- | --- |
| Ligging | Bovengronds / Ondergronds / Verhoogd |
| Stationstype | Doorgaand / Kopstation |
| Perronlengte | 40 / 60 / 80 / 100 / 120 meter |
| Hek langs aansluiting | Nee / Ja; uitgeschakeld ondergronds |

Kopstations hebben altijd een kruiswissel, doorgaande stations nooit. Er is geen aparte wisselkeuze in het nieuwe menu. Standaard: bovengronds kopstation met hek. Perrons zijn standaard 80m lang en hebben twee perronsporen; de lengte is bij nieuwe plaatsing instelbaar. Bestaande opgeslagen stations zonder lengteparameter blijven 80m. De opties gelden bij nieuwe plaatsing; bestaande stations worden niet automatisch verbouwd.

Bovengronds gebruikt de doorgaande variant de geteste voetgangersonderdoorgang met drie straataansluitingen per perron. Het kopstation houdt het ingerichte kopplein. Hekken stoppen bij de perrons; de native randdecoratie verzorgt aansluitingen aan het netwerk.

Ondergronds liggen de rails op 18m diepte met een ingang aan straatniveau en native stationsmodellen/voetgangersroutes. De doorgaande ondergrondse variant is nieuw: twee tunnelverbindingen en geen gesloten kopwand. Gebruik de ondergrondse weergave in de werkbalk bij het aansluiten van tunnels. De liggingknop verandert de constructie, maar schakelt deze aparte weergaveknop niet automatisch om.

Het native onderdoorgang-icoon en de preview van het eerdere doorgaande station worden hergebruikt; geen nieuwe beeldgeneratie. De afbeelding wisselt niet mee met elke parameterkeuze.

## Verhoogd station

Kies **Verhoogd / Elevated** bij Ligging. Het spoor ligt op +12m en de perronvloer op +12,25m. Een echt betonnen viaductdek rust op draagbalken en pijlers. Twee zichtbare trapvluchten hebben samen 122 treden en betonnen ondersteuningsplaten; de trapopeningen blijven vrij in het dek. EÃƒÂ©n ingang op maaiveld staat halverwege de stationslengte, aan ÃƒÂ©ÃƒÂ©n zijkant, en vertakt beneden naar beide perrons. Er zijn geen andere publieke ingangen op perronhoogte.

Eigen gesloten, starre betonunits vormen dek, balken, pijlers, trapdelen en lage betonnen randen langs het spoorbed. Ze gebruiken het native betonmateriaal zonder brug-skinning; de losse vervormbare brugmodellen uit 0.13.0 zijn vervangen. De entreevloer en overkapping zijn visueel zonder botsingsvolume, terwijl de draagconstructie wel solid colliders houdt. Dit is een aparte constructie, met terreinbewerking alleen bij entree/pijlerfunderingen; geen opgehoogde grond onder het hele station. De veiligheidsleuningen op perrons en trappen zijn altijd aanwezig. De instelling Hek blijft uitsluitend voor de spooraansluitingen. Kop/doorgaand en alle vijf lengtes zijn beschikbaar. Het bestaande native menu-icoon blijft behouden; geen nieuwe beeldgeneratie.

De laagste draagbalk laat circa **10,4m vrije hoogte** over. Native straatlampen zijn circa 7,18m hoog en een tram-bovenleidingpaal 8,5m; de vorige +8m spoorhoogte liet slechts 6,4m onder de balk vrij.

De straatsnap ligt langs de voorrand van het centrale entreeplein; de publieke voetgangersknoop ligt 1m naar binnen, volgens de native straatingangconventie. In 0.13.1 was dit frame nog gedraaid als een spooraansluiting, waardoor de voorgestelde weg dwars onder het station/pijlers kon belanden. De nieuwe oriÃƒÂ«ntatie en stoepkoppeling zijn nog in-game te controleren.

Begin op vlak terrein. Sluit een straat aan bij de centrale ingang en elektrische tramtrack op bruggen op +12m. Native brugaansluitingen en de nieuwe constructie moeten nog in-game op plaatsing, botsingen, visuele continuÃƒÂ¯teit, looproutes, stoppen en instappen worden beoordeeld. Basisprijzen en capaciteit blijven voor dit prototype gelijk aan bovengronds.

## Aankleding elevated 0.14.0

De verhoogde perronvloeren, buitenleuningen en native moderne treinstationkappen lopen over de hele constructie: bij doorgaand x=-10..L+10, bij kopstation x=-30..L+4. Ook naast de kruiswissel ligt dus perronvloer. De lengtekeuze blijft de bruikbare stop-/wachtlengte x=0..L; rijpaden en stopposities veranderen niet.

De native dakdelen behouden hun breedte/hoogte en verlichting. Hun vaste kolommen zijn uit de wrapper gehaald; aparte native perronkolommen/liggers staan buiten de trapgaten. Bovenleidingpalen staan op concrete consoles buiten de dakrand, met armen naar dezelfde contactdraad. Twee kleine appelbomen, vier plantenbakken en azalea's kleden het maaiveldplein aan. De centrale looproute en straatstrook blijven vrij.

Er is op verzoek ruimte/wachtruimte voor een **losse native bushalte** bij de entree. Die plaats je zelf met het gewone bushaltegereedschap op de aansluitende straat. Het wachthokje op het entreeplein is geen functionele busstop en voegt geen busstation of extra publiek toegangspunt toe.

De gebruiker bevestigde automatisch snappen en plaatsen van 0.13.2. Voor de nieuwe aankleding opnieuw een elevated station plaatsen; de kap-/paal-/groenbotsingen en uitstraling moeten nog in-game worden bekeken. De centrale ingang, straat-snap, effectieve halteposities en bestaande boven-/ondergrondse varianten zijn behouden.

## Correcties elevated 0.14.1

De twee pijlerlijnen blijven naast het entreeplein. Hun eerste rijen staan bij de zijranden van het 21m brede plein; vervolgrijen staan telkens 20m verder naar buiten. Tussen de 1,8m brede funderingen blijft 18,2m vrij voor de standaardweg van 16m inclusief stoepen. Losse eindpijlers vervallen. Dit garandeert geen ruimte voor bredere wegen.

De entree krijgt een 15cm hoge stoep met native perronbestrating op oorspronkelijke vierkante tegelvlakken. Trappen, aankleding en voetgangersroutes sluiten op die hoogte aan; de werkende straatsnap blijft op maaiveld. De onderste dwarse looproute schuift 1m naar binnen om de nieuwe pijlers te ontwijken.

Het betonnen spoorbed loopt nu door langs de trapmodules, 4cm onder de oorspronkelijke spoorhoogte. De tramrails houden hun positie en rijpaden; meer afstand tot het beton moet doorschijnende dekdriehoeken voorkomen. De gemelde afwijking in de railweergave is hiermee nog niet in-game bevestigd opgelost. Plaats een nieuw station om de drie correcties te testen.

## Lengte van de perrons

40m (klein), 60m (compact), 80m (standaard), 100m (groot) en 120m (extra groot) gelden voor alle ligging/type-combinaties. De 30m kruiswissel blijft even groot. Stopposities staan in het midden van de perrons; de kop, tweede spooraansluiting, ingang, hekjes en terreinvlakken volgen de lengte. Vlakke perronstukken worden aangevuld; de native 40m trapmodule en het meubilair worden niet uitgerekt. Op de kortste doorgaande variant ligt de onderdoorgang in de hele perronlengte, met toegangspunten op bestaande native loopknooppunten.

Bouwkosten, onderhoud en capaciteit blijven voor deze stap gelijk. De keuze verandert nieuwe plaatsingen; er is geen automatische verbouwing van bestaande stations. De lengtes zijn door de gebruiker werkend bevestigd voor boven- en ondergronds. Te lange voertuigen kunnen vastlopen op korte kopstations: kies een perron waar het hele voertuig past en de wisselstraat vrij kan komen.

## Bestaande saves

De drie afzonderlijke stations verdwijnen uit het bouwmenu, maar hun resource-ID's, oude parameters en scripts blijven aanwezig voor geplaatste stations. De oude kopstations behouden dus ook hun opgeslagen wisselkeuze. EÃƒÂ©n nieuw constructiebestand bewaart de instellingen. Er zijn geen automatische wereldwijzigingen of migratiehooks.

Gebruik [installatie-instructies](docs/installatie.md) en [teststatus](docs/teststatus.md). De gebruiker heeft 0.11.0 met het gecombineerde menu en alle stationvarianten getest en als foutloos bevestigd. De gebruiker heeft ook alle lengtes van 0.12.0 als werkend bevestigd. Elevated in 0.13.0 is nieuw en nog in-game te testen. Lokale vergelijking bevestigt dat alle acht 80m-keuzes exact gelijk zijn aan de gecommitte 0.11.1-implementatie, inclusief modellen en transforms.

## Lightrailspoor

De losse **Lightrail / Light Rail**-optie blijft naast gewone tramtrack staan (vanaf 1925). Native rijstroken, richtingen, snelheid, trammodi, kosten en materialen blijven gelijk. Lage metalen buitenhekken gebruiken het native fence_metal_4m, proportioneel verkleind tot circa 1,36m. Geen extra onderhoud of snelheidsbonus; tunnels krijgen geen hek.

## Ontwikkelen

```powershell
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_terminus.lua
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_through_station.lua
python scripts/test_native_layout.py
python scripts/package.py
```

De native test draait ook de configuratiematrix: 60 combinaties (vijf lengtes Ãƒâ€” drie liggingen Ãƒâ€” type Ãƒâ€” hek), automatische kruiswissel, ongewijzigde oude lay-outs, hekken zonder rijpadwijzigingen, beide bereikbare ondergrondse perrons en twee open tunnelaansluitingen. Het pakket bevat 45 runtimebestanden; alle lokale afhankelijkheden, vertalingen en native assetverwijzingen worden gecontroleerd. Deze controles bewijzen geen engineplaatsing, menuweergave of passagiersinstap van de nieuwe ondergrondse variant.

Stationslanen gebruiken 80 en kruiswissels 40 volgens de native constructieconventie; straatprofielsnelheden blijven m/s. Gebruiker bevestigde eerder beter rijgedrag; exacte maxima zijn niet gemeten. De losse historische Speed Probe zit niet in het hoofdpakket. Zie [credits](CREDITS.md) en [architectuur](docs/architectuur.md).


## Entreebankje 0.14.2

De gebruiker bevestigde werking van 0.14.1. Het ontbrekende entreemodel (placeholderblok) is vervangen door een native parkbankje met correcte base-namespaceverwijzingen. Het bankje staat naast de centrale looproute en kijkt naar de straat. De bestaande resource-ID blijft behouden.
