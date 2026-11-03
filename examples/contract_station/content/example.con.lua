local stationApi=require "mrnickert_ultimate_metro::/station_menu.lua"
function data()
 return {
  availability={yearFrom=0,yearTo=0},
  description={name="ULR Contract Example",description="Independent API v1 consumer: surface through station, 80m.",
   icon="::/stations/rail/modular_station/addon_platform_passenger_stairs_era_c.tga"},
  menuCategory=stationApi.getMenuCategory(1016),
  params={},updateScript={fileName="ulr_contract_example::/example.script@updateFn"},
 }
end
