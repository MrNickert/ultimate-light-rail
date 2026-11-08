-- Our own station family is the first consumer of the public design contract.
-- Return fresh tables: an add-on must never mutate a shared cached default.
return function()
 return {
  apiVersion=1,id="mrnickert_standard",
  assets={
   platformSurface="mrnickert_ultimate_metro::/surface_platform.mdl",
   headSurface="mrnickert_ultimate_metro::/surface_head_tile.mdl",
   shelter="::/stations/street/small_stops/small_new.mdl",
   elevatedRoof="mrnickert_ultimate_metro::/elevated_platform_roof.mdl",
   elevatedEntranceBench="mrnickert_ultimate_metro::/elevated_entrance.mdl",
   entrancePaving="mrnickert_ultimate_metro::/elevated_paving.mdl",
   undergroundBench="::/assets/buildings/res/grd_frn/bench_c_metal.mdl",
   undergroundTicketMachine="::/assets/stations/street/tickets_era_c_1.mdl",
  },
 }
end
