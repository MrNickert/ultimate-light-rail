# Architectuur

## Runtime

Er zijn drie contentresources:

| Resource | Functie |
| --- | --- |
| twin_terminus.con.lua | Bouwmenu, vertaalde omschrijving, wisselparameter en native stationiconen |
| twin_terminus.script.lua | Externe aansluiting, interne voertuig- en reizigerspaden, haltepunten, grondafwerking en railweergave |
| lightrail_double.street_template.lua | Verborgen interne vooraansluiting; deze bestaande ID blijft nodig voor opgeslagen stationsegmenten |

De mod-ID blijft mrnickert_ultimate_metro. De constructie blijft mrnickert_ultimate_metro::/twin_terminus.con. Het interne profiel behoudt de oude bestandsnaam omdat bestaande saves die resource op hun bevroren segmenten vastleggen. De naam is dus een compatibiliteitskeuze, geen publieke bouwoptie.

## Rijpaden

Een rechte externe STREET-aansluiting loopt van x=-40 tot x=-30. De interne sporen liggen op y=-2.5/+2.5 en eindigen op x=80. De kruislings lopende S-curves liggen tussen x=-30 en x=0 en sluiten tangentieel aan op beide hoofdsporen. Het midden op x=-15,y=0 wordt gedeeld als kruiscoordinaat.

Alle interne voertuiglanes gebruiken TRAM, ELECTRIC_TRAM, TRAM_TRACK en ELECTRIC_TRAM_TRACK, met forwardOnly=false en needsReservation=true. Deze combinatie maakte native keren en de geteste interne wisselroutes mogelijk. Het verbindingsnet buiten de stations gebruikt normale native tramtrack; de oude eigen doorgaande profielen veroorzaakten in de proef reserveringsblokkades.

De twee terminals verwijzen naar {0,3} en {1,3}: de ruwe midden-node op x=40 van elke interne hoofd-laneList. De opgeslagen parameter crossover behoudt index 1=zonder en 2=met kruiswissel, standaard 2. Reizigers wachten op de zijperrons en bereiken de publieksingang via een voetroute achter de spooreinden.

## Weergave en afbakening

Bestaande Urban Games-wachthuisjes en kale railmodellen verzorgen de weergave. Railmodellen zijn decoratief en bouwen geen treinsporen. Het modpakket bevat geen gekopieerde meshes of texturen. Interne bovenleiding, wisseltongen en algemene presentatie zijn nog vervolgwerk.

Er zijn geen .gs.lua-hooks, runtime-worldcommando's, globale resource-modifiers, voertuigscripts of automatische reverse-opdrachten. De game beheert routes, keren en verkeer. De mod introduceert geen eigen METRO-carriertype.

## Opschoning 0.7.0

De stationsscript-output is vergeleken met de werkende 0.6.2-uitvoer voor beide wisselopties en de standaardinstelling: exact gelijk, inclusief geometrie, modellen, haltepunten en kosten. De constructiedefinitie wijzigt alleen vertaalde labels. Het interne profiel wijzigt alleen beschrijving en bouwmenuzichtbaarheid. De oude proefobjecten zijn op verzoek verwijderd nadat de gebruiker ze uit de save verwijderde.

Historische hypotheses en metingen staan in archive/. Zij beschrijven eerdere varianten en zijn geen actuele installatie-instructies.
