function data()
 return {
  availability={yearFrom=0,yearTo=0},
  description={name="ULR Component Kit Example",description="20m component contract test: covered or minimal surface platforms.",
   icon="::/stations/rail/modular_station/addon_platform_passenger_stairs_era_c.tga"},
  menuCategory={categories={{category="road_buildings",filterCategories={"passenger","station"},order=1017}}},
  params={
   {key="layout",name="Station type",values={"Through","Terminus"},defaultIndex=1,uiType="Button",displayMode="Horizontal"},
   {key="length",name="Platform length",values={"40 m","60 m","80 m","100 m","120 m"},defaultIndex=3,uiType="Button",displayMode="Horizontal"},
   {key="appearance",name="Component kit",values={"Covered","Minimal"},defaultIndex=1,uiType="Button",displayMode="Horizontal"},
  },
  updateScript={fileName="ulr_contract_example::/kit_example.script@updateFn"},
 }
end
