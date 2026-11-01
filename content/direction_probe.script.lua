-- Three spatially isolated references. No station bindings, joins or duplicate curves.
local function transform(x,y,z)
 return {1,0,0,0, 0,1,0,0, 0,0,1,0, x,y,z,1}
end
function data()
 return {updateFn=function(_captureParams,_params)
  local rows={
   {y=0,type="STREET",template="mrnickert_ultimate_metro::/edge_test.street_template"},
   {y=20,type="STREET",template="mrnickert_ultimate_metro::/mode_probe.street_template"},
   {y=40,type="TRACK",template="::/infrastructure/track/standard/standard_catenary.street_template"},
  }
  local sub={models={},groundFaces={},terrainAlignmentLists={}}
  local result={edgeLists={},subconstructions={sub},cost=10000,maintenanceCost=0}
  for _,row in ipairs(rows) do
   local params={type=row.template}
   if row.type=="STREET" then params.tramTrackType="ELECTRIC" end
   result.edgeLists[#result.edgeLists+1]={type=row.type,params=params,
    edges={{{-20,row.y,0},{40,0,0}},{{20,row.y,0},{40,0,0}}},
    snapNodes={},freeNodes={}}
   sub.models[#sub.models+1]={id="::/stations/street/small_stops/small_new.mdl",transf=transform(0,row.y+8,0)}
   sub.terrainAlignmentLists[#sub.terrainAlignmentLists+1]={type="EQUAL",slopeLow=0,slopeHigh=0,
    faces={{{-25,row.y-6,0},{25,row.y-6,0},{25,row.y+11,0},{-25,row.y+11,0}}}}
  end
  return result
 end}
end
