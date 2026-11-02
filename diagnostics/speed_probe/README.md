# Tijdelijke snelheidsmeting

Deze losse mod leest de effectieve speedLimit en curveSpeedLimit uit van maximaal acht bestaande Ultimate Metro-stations, inclusief hun aansluitranden. Hij verandert geen spelobjecten, snelheid, voertuig, resource of constructie en schrijft geen eigen opgeslagen meetstaat.

Bouwen: `python scripts/package_speed_probe.py`.

Pak de zip naast Ultimate Metro uit in staging_area, activeer Ultimate Metro Speed Probe bij het laden van de save en laat circa 10 seconden doorlopen. Het eenmalige rapport staat met prefix [UMSPEED] in crash_dump/stdout.txt. Het rapporteert zowel de ruwe waarden als de omrekening naar km/u. Zo kunnen de ingestelde maximumsnelheid en engine-bochtlimiet worden onderscheiden van optrekken, afremmen en reserveringen. De helper verandert geen limieten en lost de snelheidsvraag op zichzelf niet op.

Schakel na de diagnose de helper weer uit. De hoofdmod blijft zonder automatische diagnosehooks. De kleine lokale test controleert alleen de callback en rapportage; de daadwerkelijke engine-uitvoer moet nog worden verzameld.
