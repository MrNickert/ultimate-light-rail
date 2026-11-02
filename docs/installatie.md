# Installatie 0.13.2

1. Bewaar de werkende testsave als terugvalpunt.
2. Pak `ultimate-light-rail-0.13.2.zip` uit in de bestaande staging_area en overschrijf de modbestanden. De map blijft `mrnickert_ultimate_metro`.
3. Herlaad je save met Ultimate Light Rail actief. De game hoeft niet afgesloten.
4. Open **Lightrailstation / Light Rail Station**. Kies Ligging **Verhoogd / Elevated**. De bestaande keuzes 1=Bovengronds en 2=Ondergronds behouden hun betekenis; Elevated is keuze 3.
5. Plaats een **nieuw** station; al geplaatste 0.13.0-stations kunnen hun oude modellen behouden. Begin met een nieuw doorgaand station van 80m op vlak terrein. Het spoor ligt op +12m; de centrale ingang bevindt zich halverwege de lengte op maaiveld, aan één zijkant.
6. Test eerst de automatische straatsnap op een rechte, bestaande maaiveldweg: de weg moet nu langs de centrale entree worden aangeboden, niet door de pijlerlijnen. Controleer na plaatsen de voetgangersverbinding met de stoep en instappen op beide perrons. Deze nieuwe snapcorrectie vereist een nieuw station. De vrije hoogte onder de draagbalken is circa **10,4m**; de spoorhoogte is +12m. Test ook direct aanklikken aan de bestaande maaiveldstraat: entreevloer en overkapping hebben nu geen botsingsvolume. Sluit een gewone straat aan bij de centrale ingang. Sluit de twee spooruiteinden aan met elektrische tramtrack op bruggen op +12m. Controleer dat de preview bouwbaar is, de aansluitingen aansluiten en geen grondwal ontstaat.
7. Controleer dat de sporen overal in een gesloten betonnen bak liggen, ook ingezoomd en van onderen. De oude gaten zijn vervangen door een volledig gesloten starre mesh. Controleer dek, pijlers, 2 zichtbare trapvluchten, trapopeningen en leuningen. Laat een voertuig rijden en controleer instappen op beide perrons vanuit de centrale ingang. Het perron heeft geen andere publieke aansluitingen op hoogte.
8. Test vervolgens elevated kopstation (met vaste kruiswissel), 40m/120m en Hek uit/aan. Veiligheidsleuningen bij perrons/trappen blijven in beide standen aanwezig; de hekoptie is voor de spooraansluitingen.
9. Sla op en laad opnieuw. Controleer bestaande bovengrondse/ondergrondse stations en een nieuw elevated station.

Staging-map:

```text
C:\Program Files (x86)\Steam\userdata\87691647\3493540\local\staging_area
```

Elevated is nog niet in de game gevalideerd. De lokale controles toetsen modelverwijzingen, native onderdeelafmetingen, 20 elevated-combinaties, spoorgeometrie/hoogte, 122 treden met ondersteuningsplaten, vrije trapgaten en de voetgangersgraph van één grondingang naar beide perrons. Ze bewijzen geen engineplaatsing of boarding. Bestaande stations worden niet automatisch verbouwd.

Alle lengtes uit 0.12.0 zijn door de gebruiker als werkend bevestigd. Voertuigen die te lang zijn voor een kopstation kunnen de wisselstraat blokkeren; gebruik een passende perronlengte.
