# Proef 13: native tramtrack als definitieve onderzoeksbasis

Geteste modversie: 0.6.2 / revision 17, compact kopstation. Geen nieuwe spelcode nodig voor deze uitkomst.

## Vergelijking door de gebruiker

Met twee voertuigen en het eigen UM-verbindingsprofiel rapporteerde de gebruiker een reserveringsblokkade: voertuigen stonden tegenover elkaar stil. De screenshots en gebruikersobservatie wijzen op reservering over een lang traject. De precieze gereserveerde edgeverzamelingen en blokgrenzen zijn niet uitgelezen, dus die detailverklaring is nog niet als native data vastgesteld.

De gebruiker verving het tussenliggende eigen profiel door gewone native tramtrack. Met het bestaande compacte kopstation, lightrailvoertuigen en de lijn werkte het verkeer vervolgens zoals verwacht. Daarna bevestigde de gebruiker dat meerdere voertuigen netjes voor het station wachten zolang de kruisende route bezet is, en pas verderrijden als de kruising vrijkomt. Dit is de eerste bevestigde proef van wachten en weer vrijgeven bij meerdere voertuigen in deze opstelling.

Het native padrapport van 1 november 2026 toont tussen de terminalparen van de stations 86672 en 325745 TRAM/ELECTRIC_TRAM-paden in beide richtingen, afhankelijk van de gekozen perrons 13 tot 15 edges. Dit ondersteunt bereikbaarheid met deze verbinding; de wachttijden en het vrijgeven zijn door de gebruiker in het spel waargenomen.

## Vastgelegde werkende basis

- UM Twin Terminus / Dubbel Kopstation, compacte variant uit revision 17.
- Gewone native elektrische dubbele tramtrack als verbindingsinfrastructuur.
- Bestaande tramremise en Citylink/lightrailvoertuigen.
- Native lijn met de eerder geplaatste waypoint voor het gewenste routeverloop. Er is nog niet afzonderlijk getest of die waypoint in deze native configuratie verwijderd kan worden.
- Native rijden, haltebediening, zelfstandig keren en geobserveerde conflictregeling bij de wisselstraat.

De interne vier-modirijpaden en korte eigen stationsaansluiting blijven vooralsnog nodig in het huidige ontwerp. De bevinding is dat extra reserveringsgedrag op het hele verbindingsspoor niet nodig blijkt en in de eerdere opstelling juist vastlopen gaf. Het is geen bewijs dat elke denkbare reserveringsindeling of eigen spoorvariant onmogelijk is.

## Gevolg voor de mod

Geen extra seinenlaag, nieuw reserveringssysteem of eigen doorgaand spoorprofiel toevoegen op basis van de vastloper. De eigen UM Lightrail-profielen blijven beschikbaar om bestaande testsaves te kunnen laden, maar zijn geen aanbevolen bouwroute. Verder bouwen op het kopstation met gewone game-infrastructuur houdt de mod dichter bij de door de gebruiker gekozen tram/lightrailbasis.

Het nog niet uitgebrachte verkeersdiagnosepakket is teruggenomen voordat het is aangeboden. De code is buiten de mod als werkmateriaal bewaard; er wordt geen extra gamescript of voertuigcommando aan de werkende versie toegevoegd.

## Nog controleren

Sla juist deze configuratie met meerdere voertuigen en native verbindingsspoor op, laad opnieuw en laat enkele rondritten lopen. Het eerdere opslaan/herladen was bevestigd voor een eerdere enkelspooropstelling; deze nieuwe combinatie heeft een eigen persistentieproef nodig. Langdurig verkeer, andere aansluitingen/voertuigen en passagiersafhandeling zijn nog geen breed geteste compatibiliteit.
