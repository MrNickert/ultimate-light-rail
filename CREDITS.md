# Credits en bronvermelding

Transport Fever 3 is van Urban Games. Dit prototype gebruikt de volgende originele resources bij het uitvoeren:

- ::/stations/street/small_stops/small_new.mdl en bijbehorende menuafbeeldingen.
- ::/infrastructure/street/tram/tram_new.street en gedeelde grondtexturen.
- ::/stations/shared/industry_floor_high_priority.gtex.

Het interne test_track.street_template.lua is afgeleid van street/tram/tram_new.street_template.lua in base/content/infrastructure/street.zip, met gewijzigde lane-offsets en zonder eigen bouwmenu-entry. De schema's voor de stationconstructie zijn onderzocht in de meegeleverde stationsscripts.

Geen meshes, texturen of modellen uit het spel worden meegedistribueerd. De geïnstalleerde game levert die resources. De eigen testhalte, documentatie en controles zijn gemaakt voor dit prototype van MrNickert.

Het interne edge_test.street_template.lua gebruikt dezelfde Urban Games-basis, met een enkele voorwaartse lane voor de directe haltebindingsproef. Er worden geen game-assets gekopieerd.

mode_probe.street_template.lua is afgeleid van het eigen edge_test-profiel en dezelfde Urban Games-basis; uitsluitend de vervoersmodusverzamelingen zijn uitgebreid. De richtingproef verwijst daarnaast naar het native standard_catenary.street_template, zonder dat bestand of de railassets mee te leveren.
