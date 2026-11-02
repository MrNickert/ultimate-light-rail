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

0.9.0: native perron_5_underpass LOD-meshes, materials and lighting are referenced by a visual-only wrapper. Passenger curves are adapted from Urban Games addon_platform_passenger_stairs_era_c.module.lua. Terrain openings reference the native hole.gtex. No native binary assets are redistributed.

0.10.0: the public fenced track preserves Urban Games tram_new traffic/layout data. Native industrial fence_metal_4m meshes/materials (uniform scale 0.4) are referenced by a visual-only edge wrapper, not redistributed.

0.10.1: fenced-track menu illustration generated with OpenAI image generation; illustrative preview, not an in-game screenshot.

0.13.0: elevated viaduct, foundations and 82 stair treads reuse native concrete bridge models (c_6_rep_rep, c_6_rep_l/r, c_pillar_small_bot_m) with project-defined assembly/transforms and pedestrian paths. No native mesh or texture binaries are redistributed.

0.13.1 supersedes the loose skinned bridge models: original closed concrete geometry references Urban Games c_concrete_unskinned material/textures. Native shelter LOD references are wrapped as a collision-free entrance visual. No native mesh/texture binaries are redistributed.

0.14.0: modern canopy references Urban Games perron_5_roof LOD meshes/materials/lights; fixed supports are replaced by separately placed era_c_perron_pillar/holder assets. Native apple trees, tree beds, raised planters and azaleas furnish the entrance. Cities Skylines screenshot was inspiration only; no assets from it are included.
