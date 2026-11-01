# Proef 05: native richtinggedrag vergelijken

Versie 0.4.0 / revision 10. Plaats een UM Direction Probe (Test), Nederlands UM Richtingproef (Test).

## Wat revision 9 daadwerkelijk bewees

De gebruiker plaatste twee directe spoorgebonden tramhaltes en verbond die via gewone elektrische tramtrack. Het log van 1 november 2026 vond voor TRAM en ELECTRIC_TRAM een pad van zes edges van station 327331 naar 256800 en nul edges terug. De gedeelde middenknooppunten van de eigen straatsegmenten werden daadwerkelijk terminalknooppunten. Beide haltes konden in de lijnplanner als stop worden gekozen. Een complete lijn ontbrak wegens de terugweg. Er is nog geen voertuig- of omkeerproef uitgevoerd.

## Onderzoeksvraag

De native treinspoor-template gebruikt net als ons profiel een enkele lane met forward=true. Hij ondersteunt andere vervoersmodi, heeft roadType=TRACK, andere hoogte en spoorstijl en aanvullende spoorinstellingen. De enkele forward-vlag verklaart daarom op zichzelf niet waarom een trein heen en terug kan.

Deze fixture legt drie losse rechte segmenten van 40 meter naast elkaar:

| Rij | Profiel | Doel |
| --- | --- | --- |
| A, lokale y=0 | Werkend eenrichtings-STREET-tramprofiel | Bekende referentie |
| B, lokale y=20 | Hetzelfde profiel met ook TRAM_TRACK en ELECTRIC_TRAM_TRACK in de modeverzamelingen | Is alleen extra modesteun voldoende om een terugpad te krijgen? |
| C, lokale y=40 | Ongewijzigd native elektrisch standaardtreinspoor, type TRACK | Controle voor native spoorgedrag |

A en B verschillen uitsluitend in de vervoersmodusverzamelingen. C is een bredere native referentie: een verschil met C bewijst dus niet dat uitsluitend roadType de oorzaak is. De referenties zijn niet verbonden met elkaar of met een station. Er wordt geen tram/treinovergang gemaakt en er komen geen voertuig-laneLists, omkeerlus of automatische voertuigcommando's bij.

## Uitvoeren

1. Bewaar de huidige geslaagde halve route als referentiesave.
2. Vervang de bestanden in dezelfde staging-modmap met 0.4.0 en laad de testsave opnieuw. De game afsluiten is niet vereist in de werkwijze van de gebruiker.
3. Zoek in het wegstationsmenu naar **UM Direction Probe (Test)** / **UM Richtingproef (Test)**. Het is een meetobject, geen bruikbare halte.
4. Plaats slechts een object op vrije vlakke grond, op afstand van de eerdere opstelling. Het bevat alle drie de referenties.
5. Laat tien seconden ongepauzeerd lopen, pauzeer en meld dat het klaar is. Geen spoor aansluiten, geen remise, geen lijn en geen voertuig nodig.

De alleen-lezen diagnose gebruikt het prefix [UMDIR]. Hij leest de werkelijk door de engine gegenereerde segmentnetwerken, logt forwardOnly en needsReservation, en vraagt voor elk van de vier modi een pad tussen dezelfde edge-endpoints in beide richtingen op. Alleen de eigen direction_probe-constructies worden bemeten. Ontbreekt het segmentnetwerk, dan rapporteert hij dat zonder een richtingconclusie te trekken.

## Beslissen na het resultaat

Een terugpad in B toont hoogstens dat deze modecombinatie op dit geïsoleerde segment werkt. Het bewijst nog geen haltewerking, voertuigomkering, veiligheid, netwerkovergang of complete lijn. Bij een uitsluitend werkende railreferentie C moeten we verder uitzoeken welke native railvoorwaarden nodig zijn. Een nieuwe stationsversie volgt pas nadat de meting een bruikbare hypothese ondersteunt.

De test is niet in de game uitgevoerd. De geometrie en het alleen-lezen karakter zijn lokaal gecontroleerd; engineacceptatie van B en de werkelijke resultaten moeten nog blijken. De eerder geplaatste haltes, hun profielen en alle vorige herstelde prototypes blijven byte voor byte ongewijzigd.

## Uitgevoerd resultaat

De gebruiker plaatste het object. Het native log toont voor B forwardOnly=false en needsReservation=true, met een edge in beide richtingen voor alle vier de gemeten modi. A bleef eenrichtingsverkeer voor tram; C liet alleen spoortrammodi in beide richtingen toe. Uitwerking en vervolgtest staan in proef-06-tweerichtingshalte.md.
