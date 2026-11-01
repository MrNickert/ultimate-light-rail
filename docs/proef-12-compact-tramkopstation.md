# Proef 12: compact tramkopstation

Versie 0.6.2 / revision 17. Dezelfde menu-entry: UM Twin Terminus (Test) / UM Dubbel Kopstation (Test). Plaats een nieuw exemplaar; eerder gebouwde grote stations worden niet automatisch verkleind.

## Correctie op de ontwerprichting

De gebruiker wees terecht op de spoorweguitstraling en te grote wisselstraat van revision 16. Die versie gebruikte decoratieve spoorsegmentmodellen met dwarsliggers en spoorwegstootblokken, een spoorafstand van 12 meter en een lange uitwaaiering. Dat waren ontwerpkeuzes van het prototype, geen aangetoonde noodzakelijke trambeperkingen.

De koers blijft een compact tram-/lightrailsysteem met gewone tramspoorafstand en mogelijke wegintegratie. Spoormodi mogen technische ondersteuning leveren zonder spoorweguitstraling of grote railstations als standaard te kiezen. Zie ontwerpkeuzes.md.

## Wat de vorige meting werkelijk toont

Revision 16 is plaatsbaar. Het native log van constructie 327784, station 327785, toont voor de ene ingangslane een route van vijf edges naar terminal 0 en terug, en voor de andere een route van vijf edges naar terminal 1 en terug. De kruiselingse routes ontbreken voor de gemeten modi, ook voor spoortrammodi. De kruiswissel is dus nog niet functioneel bewezen.

De voertuigedges en hun kruisknooppunt bestaan wel in het log. De wisselcurves sluiten echter met schuine raaklijnen op horizontale hoofdsporen aan. Dat is een geometrische knik en een aannemelijke beperking voor routeovergangen; de log heeft die niet expliciet als afwijzingsreden aangewezen.

## Deze versie

- Hartlijnen constant y=-2.5 en y=+2.5, overeenkomstig de normale dubbele tramindeling: 5 meter spoorafstand.
- Rechte dubbele vooraansluiting van 10 meter, van x=-40 tot x=-30.
- Kruiswissel van 30 meter, van x=-30 tot x=0, met gedeeld kruispunt op x=-15,y=0.
- Beide wisselroutes zijn gesplitste vloeiende S-curves. Eindraaklijnen liggen exact parallel aan de rechte hoofdsporen; op het kruispunt zijn de raaklijnen doorlopend.
- Twee zijperrons van 80 meter in plaats van een breed eilandperron. Beide haltepunten blijven op x=40, nu interne nodes {0,3} en {1,3}.
- Publieksroute achter de spooreinden. De totale functionele lengte is ongeveer 130 meter, tegenover ongeveer 230 meter in het vorige prototype.
- Twee kale metalen railstrengen per rijpad liggen vrijwel vlak in het verharde vlak. Het gedeelde single_rail-model heeft geen dwarsliggers en geen transportmetadata. Complete spoorwegsegmenten en stootblokken zijn verwijderd. Bovenleiding en wisseltongen blijven visuele vervolgpunten.

De interne vervoersmodi en reserveringsvlaggen blijven gelijk aan de eerdere plaatsbare variant. De gewone werkende enkelspoorhaltes en infrastructuurprofielen worden niet aangepast. Dit bewijst nog geen correcte wisselroute of conflictveiligheid.

## Speltest

1. Bewaar de huidige testsave en vervang de modbestanden. Laad de save opnieuw.
2. Plaats op vrije vlakke grond een nieuw **UM Twin Terminus (Test)** met **Met kruiswissel**. Het grote eerder gebouwde station mag als vergelijking blijven staan.
3. Controleer de compacte tramuitstraling en het ontbreken van dwarsliggers/stootblokken. De wisselzone hoort dicht voor de perrons te liggen.
4. Laat tien seconden lopen en pauzeer. Nog geen verbinding of voertuig nodig. Meld dat het log klaarstaat, zodat we opnieuw alle kruiselingse aankomst- en vertrekpaden beoordelen.
5. Als de preview niet plaatsbaar is, vergelijk met **Zonder wissel** op dezelfde plek en meld het verschil.

De nieuwe plaatsingsgeometrie moet in de engine worden getest. Een zichtbaar X is geen bewijs van een bruikbaar wisselpad. De eerste functionele maatstaf blijft dat beide ingangslanes beide perronpunten kunnen bereiken en verlaten.
