local function main()
 local function resource(path)
  local env=setmetatable({_ = function(k)return k end},{__index=_G})
  assert(loadfile(path,"t",env))();return env.data()
 end
 local def=resource("content/edge_stop.con.lua")
 assert(#def.params==0,"fixed geometry for the first proof")
 assert(def.updateScript.fileName=="mrnickert_ultimate_metro::/edge_stop.script@updateFn")
 local r=resource("content/edge_stop.script.lua").updateFn({}, {})
 assert(#r.edgeLists==1 and r.edgeLists[1].type=="STREET","ordinary tram street topology")
 local edge=r.edgeLists[1]
 assert(edge.params.type=="::/infrastructure/street/tram/tram_new.street_template" and edge.params.tramTrackType=="ELECTRIC")
 assert(#edge.edges==4,"two real street segments through the whole stop")
 for k=1,3 do assert(edge.edges[2][1][k]==edge.edges[3][1][k],"segments meet exactly") end
 assert(edge.edges[1][1][1]==-40 and edge.edges[4][1][1]==40,"80m approach-to-exit")
 assert(edge.snapNodes[1]==0 and edge.snapNodes[2]==3,"both external endpoints connect")
 local sub=r.subconstructions[1]
 assert(sub.groundFaces and sub.terrainAlignmentLists,"native subconstruction ownership")
 assert(#sub.station.terminals==1,"one direct binding per proof")
 local terminal=sub.station.terminals[1]
 assert(terminal.vehicleNode[1]==-1,"terminal targets root edgeLists")
 local source=edge.edges[terminal.vehicleNode[2]+1]
 assert(source and source[1][1]==0 and source[1][2]==0,"raw root endpoint resolves to construction center")
 for _,lane in ipairs(sub.laneLists) do
  for _,mode in ipairs(lane.transportModes) do assert(mode=="PERSON","no overlapping internal vehicle lanes") end
 end
 for _,id in ipairs(terminal.personNodes) do
  assert(sub.laneLists[id[1]+1].nodes[id[2]+1],"every pedestrian reference exists")
 end
 assert(sub.laneLists[2].linkable,"external passenger connection")
 print("PASS: ordinary tram segments, direct root midpoint reference, no internal vehicle duplicates. STREET terminal binding and direction require native placement verification.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
