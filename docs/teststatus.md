# Teststatus

## Door de gebruiker getest met 0.6.2

- Compacte kopstations met twee perrons en kruiswissel zijn plaatsbaar.
- Native padmetingen vinden aankomst en vertrek van beide ingangslanes naar beide perrons.
- Een lijn met native elektrische tramtrack en een waypoint volgt het gewenste spoorverloop.
- Citylink/lightrail rijdt, stopt, opent en sluit deuren, keert en vertrekt zelfstandig.
- Reizigers bereiken de halte en stappen in de voertuigen.
- Twee drukke kruisende lijnen met veel voertuigen blijven functioneren. Voertuigen wachten bij conflicterende wisselroutes en rijden verder na vrijgave.
- De drukke opstelling is opgeslagen en herladen; volgens de gebruiker loopt het verkeer correct verder.

Dit zijn resultaten in de geteste opstelling. Langdurige algemene compatibiliteit, andere voertuigtypen en passagiersaantallen zijn niet breed onderzocht. De eerdere problemen op eigen doorgaande UM-spoorprofielen zijn opgelost door buiten de stations native tramtrack te gebruiken.

## Opschoning 0.7.0

- Ongewijzigde stationsscriptbron en exact gelijke gegenereerde uitvoer voor crossover=1, crossover=2 en de standaardinstelling.
- Constructiedefinitie gelijk buiten vertaalde presentatievelden.
- Interne vooraansluiting gelijk buiten beschrijving en verborgen bouwmenu.
- Resource-ID's en opgeslagen parameterindices behouden.
- Alleen de drie benodigde contentbestanden en vier metadatabestanden verpakt.
- Lokale resourceverwijzingen en alle Nederlandse/Engelse vertaalkeys gecontroleerd.
- Geen automatische diagnosehooks of worldcommando's in de runtime.
- Nog nodig: dezelfde bestaande testsave openen met de schone modmap en de werking kort nalopen. Dit kan niet door de lokale tests worden bewezen.

De historische onderzoeksproeven staan in archive/. Ze worden niet met de mod meegeleverd.
