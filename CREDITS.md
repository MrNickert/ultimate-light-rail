# Credits

Transport Fever 3 en de gebruikte native game-assets zijn van Urban Games.

De mod verwijst tijdens het spelen naar:

- ::/stations/street/small_stops/small_new.mdl;
- de native ondergrondse stationsmodellen, trappen, verlengstukken en ingang;
- ::/infrastructure/street/tram/tram_new.street en gedeelde straatgrondtexturen;
- ::/stations/shared/industry_floor_high_priority.gtex;
- ::/infrastructure/track/shared/single_rail.mdl, uitsluitend als kale decoratieve railstreng in het verharde vlak;
- de native station-HUD-configuratie.

Het verborgen lightrail_double.street_template.lua is afgeleid van Urban Games street/tram/tram_new.street_template.lua, met de onderzochte extra tram/spoormodi en zonder publieke bouwmenu-entry. De stationsconstructievorm is onderzocht aan de hand van de meegeleverde tram- en stationsscripts.

Geen native modellen, meshes, materialen of texturen worden gekopieerd in het pakket. De geïnstalleerde game levert deze resources. De ondergrondse layoutdata en voetgangerscurves zijn aangepast uit Urban Games' underground_station.script.lua.

De twee eigen menuillustraties zijn gegenereerd met OpenAI image_gen en als TGA in het pakket opgenomen. Het zijn illustratieve previews, geen screenshots of nieuwe 3D-assets. De gebruikte prompts staan in docs/menu-artwork-prompts.json. De constructiescriptcode, vertalingen, documentatie en controles worden onderhouden in dit project van MrNickert.

Bovengrondse afwerking 0.8.2: de visuele perronwrapper verwijst naar native rail/era_c/perron_5 LOD-meshes en materialen, met lege transportmetadata. De vloer is naar een lage tramperronhoogte geschaald. Straatwerk, meubels, plantenbakken, lampen en masten gebruiken bestaande Urban Games-assets. De dunne decoratieve contactdraad gebruikt een geschaalde bare-rail mesh. Er worden geen native modelbinaries of texturen meegeleverd.

Afwerking 0.8.4: het plein verwijst naar de native perron_10_head_con LOD-meshes en materialen. Appelboompjes, boombakken en azalea zijn native modellen. De nieuwe tramstrook is een oorspronkelijke vierpuntsmesh met het native materiaal new_medium_tram_track; de native binaire meshes en texturen worden niet gekopieerd.

Afwerking 0.8.5 verwijst ook naar het native materiaal new_medium_tram_paving voor de invulling onder de rails. Dit gebruikt dezelfde oorspronkelijke vlakke strookmesh als de railtextuur; native materiaal- en textuurbinaries worden niet meegeleverd.
