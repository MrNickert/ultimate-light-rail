-- Our bundled designs use the same concrete models/20m rules as external kits.
-- No placement argument returns the context-default selector for existing callers.
return function(placement)
 if placement==nil then
  return {apiVersion=1,id="mrnickert_standard",components={
   platform="default",shelter="default",canopy="default",trees="default",
   planters="default",benches="default",bins="default",lights="default",
  }}
 end
 if placement=="underground" then
  -- The native underground hall is a fixed core assembly in API v1.
  return {apiVersion=1,id="mrnickert_underground",components={}}
 end
 assert(placement=="surface" or placement=="elevated","unsupported standard-kit placement")
 local elevated=placement=="elevated"
 local components={
  platform={model="mrnickert_ultimate_metro::/platform20.mdl",moduleLength=20},
  shelter={model="::/stations/street/small_stops/small_new.mdl"},
  canopy=false,
  trees={model="::/assets/vegetation/trees/apple_01/apple_01.mdl"},
  planters={model="::/assets/buildings/res/flower_pots/raised_bed_c.mdl"},
  benches={model="::/assets/buildings/res/grd_frn/bench_c_metal.mdl",entranceModel="mrnickert_ultimate_metro::/elevated_entrance.mdl"},
  bins={model="::/assets/buildings/com/misc/trashcan_c_01.mdl"},
  lights={model="::/assets/buildings/res/garden_lamp/garden_lamp_c_stand.mdl"},
 }
 if elevated then
  components.shelter=false
  components.canopy={model="mrnickert_ultimate_metro::/platform_roof20.mdl",moduleLength=20}
 end
 return {apiVersion=1,id=elevated and "mrnickert_elevated" or "mrnickert_surface",components=components}
end
