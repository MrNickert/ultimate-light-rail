# Ultimate Metro

Versie 0.7.0, revision 18. Een compact **Metro Kopstation** voor omkeerbare lightrail op gewone elektrische tramtrack in Transport Fever 3.

Het station heeft twee zijperrons van 80 meter, 5 meter spoorafstand en een optionele kruiswissel van 30 meter. Sluit de native elektrische tramtrack aan op de dubbele vooringang. Gebruik een omkeerbaar lightrailvoertuig zoals Citylink. Er is geen eigen verbindingsspoor of keerlus nodig.

## In het spel

Zoek **Metro Terminus** / **Metro Kopstation** in het wegstationsmenu. De optie Kruiswissel staat standaard aan. Verbind twee stations met native elektrische tramtrack en sluit een gewone tramremise aan. Een waypoint kan het gewenste spoorgebruik van de lijn sturen; een vaste rijrichting per spoor wordt niet door de mod afgedwongen.

De gebruikersproef bevestigde rijden, deuren en keren, passagiers die de halte bereiken en instappen, twee drukke kruisende lijnen met meerdere voertuigen, wachten en verderrijden bij conflicterende wisselroutes, en opslaan/herladen met doorgaand verkeer. Zie [teststatus](docs/teststatus.md). Dit is een vroege mod; vormgeving, bovenleiding en compatibiliteit zijn nog niet volledig afgewerkt.

## Deze opschoning installeren

Volg [de installatie-instructie](docs/installatie.md). **Vervang de volledige oude modmap; alleen bestanden overschrijven laat oude diagnosescripts achter.** De gebruiker heeft de oude proefobjecten en testsporen uit de save verwijderd. De werkende stations en hun interne profiel behouden hun resource-ID, parameters, geometrie en kosten.

Het pakket bevat alleen zeven runtimebestanden. Oude bouwopties, losse proefprofielen en automatische diagnoselogging zijn verwijderd. Het interne stationsprofiel blijft aanwezig voor bestaande stations, maar staat niet in het bouwmenu. Verwijder de mod niet zolang de save zijn stations bevat.

## Ontwikkelen

Open deze map met het VS Code-profiel Transport Fever 3 Modding. Gebruik de lokale game-definities zoals ingesteld in tlconfig.lua en .vscode/settings.json.

```powershell
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_terminus.lua
python scripts/package.py
```

De geometriecontrole test de twee wisselopties, halteverwijzingen, rijpaden, decoratieve modellen en interne aansluiting. Het bouwscript controleert de zeven pakketbestanden, lokale afhankelijkheden en vertalingen. Een save/herlaadcontrole van het nieuwe pakket blijft nodig; lokale controles vervangen de spelengine niet.

Zie [architectuur](docs/architectuur.md), [ontwerpkeuzes](docs/ontwerpkeuzes.md) en [credits](CREDITS.md). De genummerde onderzoeksproeven staan in [docs/archive](docs/archive) en zijn historisch. Actieve ontwikkelrichting: verdere afwerking van de tramgebaseerde metro, later een ondergrondse variant en eigen interface waar technisch mogelijk.
