# Actieve proef vanaf revision 17

De plaatsbare interne kopstationvariant gaf geen kruiselingse perronroutes. Revision 17 corrigeert de hoekige wisselaansluitingen en keert terug naar compacte tramvormgeving: 5m spoorafstand, 30m wisselzone, zijperrons en railstrengen in verharding. Geen spoorwegsegmentmodellen of buffers. Zie proef-12-compact-tramkopstation.md en ontwerpkeuzes.md. De nieuwe native wisselwerking is nog niet bewezen.

# Actieve proef vanaf revision 16

De root-STREET-wisselstraat uit revision 15 was niet plaatsbaar; er is geen specifieke afwijzingsreden gelogd. De nieuwe variant heeft een enkele rechte externe dubbele straataansluiting en interne voertuiglanes met vier modi volgens de native halteconstructievorm. Decoratieve railmodellen zijn gescheiden van de transportgeometrie. Plaatsbaarheid en interne heen-/terugroutes moeten nog worden gemeten. Zie proef-11-interne-wissels.md.

# Actieve proef vanaf revision 15

Een afzonderlijk tweesporig kopstation gebruikt echte root-STREET-segmenten, twee eigen direct gebonden perronpunten en twee kruiswisselroutes met een gedeelde kruiscoordinaat. Het is een nieuwe combinatie van werkende profielen; native vertakkingen/kruisingen en beide terminalroutes zijn nog niet bewezen. Eerst een station plaatsen en per ingangslane toegang tot beide terminals meten. Zie proef-10-kopstation.md.

# Actieve proef vanaf revision 14

De enkelspoorbasis is door de gebruiker getest met een complete lijn, remise-aansluiting, rijdend voertuig, deurbediening, zelfstandig keren en opslaan/herladen. Nieuw is een afzonderlijk dubbel STREET-tramprofiel met twee native gescheiden lane-offsets en de gemeten extra spoortrammodi. De haltes blijven in deze proef enkelsporig; tweesporige stations, wissels en spoorgebruik per richting volgen afzonderlijk. Zie proef-09-dubbelspoor.md.

# Actieve proef vanaf revision 13

De stationpassages blijken lokaal voor alle gemeten modi in beide richtingen bereikbaar. Het totale pad via gewone dubbele tramtrack blijft eenrichtingsverkeer. Een bouwbare kopie van precies het stationprofiel, UM Lightrail (Test), maakt een vergelijking met een uniform tussenstuk mogelijk. Zie proef-08-lightrailverbinding.md. Er zijn nog geen bewezen complete lijn, voertuigen die keren of integratie met gewone wegtramtrack.

# Actieve proef vanaf revision 12

De tweerichtingshalte is plaatsbaar, maar de complete verbinding via gewone tramtrack blijft voor TRAM/ELECTRIC_TRAM in een richting onvindbaar. De segmentvlaggen alleen verklaren dit niet. Proef-07-route-diagnose.md vergelijkt lokale stationpaden, terminalpaden en verschillende modeverzamelingen zonder geometrie te wijzigen. Terugroute en voertuigomkering blijven onopgelost.

# Actieve proef vanaf revision 11

De vergelijkingsproef toonde tweeweg-TRAM/ELECTRIC_TRAM-paden op het STREET-profiel met extra railtrammodi: de engine genereerde forwardOnly=false, needsReservation=true. De nieuwe afzonderlijke bidirectional_stop koppelt dit exacte profiel aan de eerder geaccepteerde directe terminalbinding. Zie proef-06-tweerichtingshalte.md. Lijnwerking en voertuigomkering zijn nog niet bewezen. De gebruikerskeuze is tram eerst, trein alleen als alternatief bij een aangetoonde functionele grens; een trein/tramovergang is geen verplichte scope.

# Actieve proef vanaf revision 10

Directe binding aan een enkele tram-lane is in de engine geaccepteerd en een route via gewone tramtrack is in een richting gevonden. Zie proef-05-richting.md voor een afzonderlijke vergelijking van de werkende STREET-tram-lane, hetzelfde profiel met extra railtrammodi en standaard native TRACK. Er is nog geen werkend terugpad, voertuigomkering of tram/treinovergang. De bestaande stationresources blijven ongewijzigd.

# Actieve proef vanaf revision 9

De engine wijst de directe railstationverwijzing op een standaard dubbele tramtemplate af omdat meerdere lanes dezelfde terminalmodi ondersteunen. De nieuwe minimale proef gebruikt daarom een eigen STREET-template met een enkele voorwaartse tram-lane, zonder voertuig-laneLists of dubbele tegenrichtingcurves. Zie proef-04-een-rijstrook.md. Het is nog geen bewijs van engineacceptatie, native keren of aansluiting op een bestaand netwerk.

# Actieve proef vanaf revision 8

Zie proef-03-spoorbinding.md. Een aparte doorgaande tramhalte gebruikt echte STREET-tramsegmenten en de railstationconventie voor een directe terminalverwijzing naar de root edgeLists. De engineondersteuning van die combinatie is nog niet bewezen. Eerste proef: slechts een halte plaatsen en het werkelijke terminalknooppunt beoordelen. Dit hergebruikt de bindingsvorm van treinstations, maar neemt geen treinrouter of railvervoer over.

De kruiswisselproef hieronder is historisch. Revision 6 met expliciet tegengestelde overlappende lanes is ingetrokken wegens een bevestigde Duplicate edges found-crash. Vanaf revision 7 staat voor dat station weer het plaatsbare script van revision 5. Er is nog geen werkende kopstationroute.

# Actieve architectuur vanaf revision 4

De huidige proef is een afzonderlijk tweesporig kopstation met een kruiswissel en een standaard tramtrackaansluiting. Zie proef-02-kruiswissel.md. De gecentreerde aansluiting hieronder beschrijft uitsluitend de eerste proef, die in het spel geen routeverbinding opleverde. De nieuwe constructie wijzigt deze oude resources niet.

# Richting van Ultimate Metro

Keuze van de gebruiker: bestaande tramtrack behouden, met een nieuwe bovengrondse halte als experimenteel eindpunt. De eerdere gedachte aan lightrail op treinspoor is niet de actieve ontwikkelroute; een bruikbare tram/spoor-overgang was niet in het spel bewezen.

De nieuwe constructie heeft een eigen resource-ID en intern straatprofiel. Dat profiel hergebruikt de vanilla tramstijl, maar centreert beide logische richtingen op dezelfde fysieke hartlijn. Binnen het station is één voertuig-laneList met forwardOnly=false en needsReservation=true en één haltepositie. Dit zijn beschikbare configuratievelden, geen bewijs dat de C++-tramrouter daadwerkelijk op deze manier kan omkeren. De normale tramtrack buiten de halte blijft ongewijzigd.

De native Underground Stop toont de bruikbare constructievorm: korte externe STREET-aansluitingen, interne laneLists, één station met terminals en expliciete reizigersroutes. Het prototype gebruikt dat schema op maaiveld. Een standaard wachtruimte uit de bovengrondse halte verzorgt de eerste zichtbare asset; de visuele afwerking blijft voorlopig beperkt.

De constructie verandert geen bestaande modelresources of voertuigen en voert geen commando's op de spelwereld uit. Eén omkeerbare Citylink is het eerste testvoertuig. Er is geen nieuw METRO-carriertype nodig voor deze proef.

Bij succes onderzoeken we de Metro-interface. De spelbestanden bevatten al een Light Rail-filter en een MainModButtonAreaExtension. Eigen bouwcategorieën zijn technisch configureerbaar; vervanging van de hele routeplanner is niet als gedocumenteerde extensie aangetroffen. Een reverse-command alleen is geen oplossing voor ontbrekende routeverbindingen.

Stations zoals modulaire treinstations, meer perronsporen en twee niveaus met haaks gedraaide sporen zijn vervolgwerk. De gebruiker heeft gevraagd eerst de Metro-laag te onderzoeken.

Bronnen: TF3 Steam-build 26129055; base/content/stations/street.zip (small_stops, underground_station); base/content/infrastructure/street.zip (tram_new.street_template.lua); api/tealdef en base/tealdef voor LaneList, stations, voertuigmodi en GUI. Zie credits voor de gebruikte basisresources.
