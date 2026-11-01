# Installatie 0.7.0

Dit is de opgeschoonde vervanger van de ontwikkelversie 0.6.2. Er zijn geen nieuwe stations of spoorverbindingen nodig voor de bestaande werkende lijn.

1. Bewaar de huidige save met alleen de werkende kopstations en native tramtrack. Oude proefstations en eigen testsporen zijn door de gebruiker al verwijderd.
2. Verplaats de hele oude map **mrnickert_ultimate_metro** naar een backup **buiten staging_area**. Laat daar geen tweede modkopie met dezelfde mod-ID staan.
3. Pak ultimate-metro-0.7.0-clean.zip uit in:

```text
C:\Program Files (x86)\Steam\userdata\87691647\3493540\local\staging_area
```

4. De nieuwe map moet rechtstreeks deze inhoud hebben:

```text
mrnickert_ultimate_metro/
  mod.json
  strings.json
  credits.txt
  _metadata/modinfo.json
  content/twin_terminus.con.lua
  content/twin_terminus.script.lua
  content/lightrail_double.street_template.lua
```

5. Laad dezelfde save opnieuw. De game hoeft volgens de geteste werkwijze niet afgesloten te worden. Controleer dat Ultimate Metro actief is.
6. Controleer de bestaande lijn, voertuigen, keren en passagiers. In het bouwmenu hoort alleen de werkende **Metro Terminus / Metro Kopstation** over te zijn. Het interne aansluitprofiel is verborgen. Plaats de bestaande stations niet opnieuw.

**Alleen de zip over de oude map uitpakken is niet voldoende.** Zip-extractie verwijdert de oude proefbestanden niet; zo zouden de oude diagnosehooks actief blijven. Vervang daarom de complete modmap.

De resource-ID van de werkende stations, de wisselparameter, geometrie, kosten en het opgeslagen interne aansluitprofiel blijven behouden. Bestaande stationsnamen in de save worden niet actief hernoemd. Een native herlaadcontrole van dit nieuwe pakket is nog niet door de gebruiker bevestigd.

Bij een ontbrekende oude testresource: gebruik de backup en de bijbehorende referentiesave om het achtergebleven proefobject of spoor te verwijderen. De oude experimentele resources zitten bewust niet meer in dit pakket. Verwijder Ultimate Metro niet uit een save waarin zijn werkende kopstations nog staan.
