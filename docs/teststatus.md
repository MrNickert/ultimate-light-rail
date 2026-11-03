# Teststatus — release 1.0.0

## Automatische controles

- 72 functionele stationsgevallen worden vergeleken met vastgelegde referentie-uitvoer; routing, terminals en andere niet-visuele bouwdata blijven gelijk.
- 27 vaste ondergrondse/interne layouts hebben ook volledige uitvoervergelijking.
- Native resources, meshbuffers, perron-/dakdekking, vaste trappen, vrije mastzones, hekken en alle opgegeven lengtes worden gecontroleerd.
- API-validatie, standaardselecties, modelvervanging en ongewijzigde caller-tabellen zijn getest.
- De GUI-tests controleren één gecombineerd menu, depot-tijdperken, externe categorieherkenning, herhaald opbouwen zonder verlies of duplicaten, resource-`data()` en beide UI-vervangingen.
- De stylesheetfuncties worden uitgevoerd met testafhankelijkheden; globale animatienamen en verwijzingen worden gecontroleerd. Het bouwvenster wordt getest zonder actief Construction-gereedschap.
- Verpakking controleert de runtimebestandslijst, eigen resourceverwijzingen, vertalingen, transparant icoon, ZIP-inhoud en CRC.

## In-game bevestigd door de gebruiker

Alle drie de stationsliggingen zijn geplaatst en werkend bevestigd. Alle perronlengtes zijn visueel geplaatst. Er is getest met instappen/uitstappen, native aansluiting, keren, meerdere lijnen/voertuigen, kruisende rijwegen en opslaan/herladen. De onafhankelijke componentenvoorbeelden zijn op 40m/80m met en zonder dak geplaatst; instappen en wissels zijn bevestigd voor twee varianten.

De eigen Light Rail-knop, het compacte icoon en het gecombineerde overzicht met tramremise, spoor en station zijn in-game bevestigd.

## Reikwijdte

De geïntegreerde 1.0.0-hoofdmod moet na installatie nog één korte eindcontrole krijgen: aparte UI Preview uit, menu openen, remise/spoor/station kiezen, plaatsen, lijn laten rijden en save herladen. De integratie gebruikt de geteste UI-code in de hoofdmodnamespace en een gedeelde categoriehelper.

Niet iedere combinatie van lengte, voertuig en extern model is afzonderlijk in de engine getest. Automatische tests vervangen die praktijktest niet. Te lange voertuigen kunnen kopstationwissels blokkeren. Externe colliders kunnen looproutes blokkeren. Andere UI-vervangingsmods en toekomstige game-updates vragen een eigen controle.
