-- Run with installed native construction helpers by test_underground.lua.
return function(resource)
 local script=resource("light_rail_station.script.lua")
 local con=resource("light_rail_station.con.lua")
 assert(con.params[3].key=="platformLength" and con.params[3].defaultIndex==3)
 local function key(p)return string.format("%.5f,%.5f,%.5f",p[1]+0,p[2]+0,p[3]+0)end
 local function equal(a,b)
  assert(type(a)==type(b))
  if type(a)~="table" then assert(a==b);return end
  for k,v in pairs(a) do equal(v,b[k]) end
  for k in pairs(b) do assert(a[k]~=nil) end
 end
 local lengths={40,60,80,100,120}
 for index,L in ipairs(lengths) do
  assert(con.params[3].values[index]==L.." m")
  for placement=1,2 do for stationType=1,2 do for fence=1,2 do
   local params={placement=placement,stationType=stationType,fence=fence,platformLength=index,seed=42}
   local r=script.updateFn({},params)
   assert(params.platformLength==index,"saved index must not be overwritten by metres")
   local sub=r.subconstructions[1]
   local vehicles=stationType==1 and 2 or 4
   local z=placement==2 and -18 or 0
   assert(#sub.station.terminals==2)
   for i=1,vehicles do
    local lane=sub.laneLists[i]
    assert(lane.forwardOnly==(stationType==1) and lane.needsReservation==(stationType==2))
    assert(lane.speedLimit==(i<=2 and 80 or 40))
    for j=1,#lane.nodes,2 do
     local a,b=lane.nodes[j],lane.nodes[j+1]
     assert(a[1][3]==z and b[1][3]==z)
     assert(key(a[1])~=key(b[1]),"no zero-length vehicle edge")
    end
   end
   for _,terminal in ipairs(sub.station.terminals) do
    local v=terminal.vehicleNode
    assert(sub.laneLists[v[1]+1].nodes[v[2]+1][1][1]==L/2,"stop at platform midpoint")
    assert(terminal.capacity==100,"length feature leaves capacity rebalance out of scope")
    for _,ref in ipairs(terminal.personEdges) do
     local lane=sub.laneLists[ref[1]+1]
     assert(lane and ref[2]>=0 and ref[2]<#lane.nodes/2)
    end
   end
   if stationType==1 then
    equal(r.edgeLists[1].edges,{{{-20,0,z},{10,0,0}},{{-10,0,z},{10,0,0}}})
    equal(r.edgeLists[2].edges,{{{L+10,0,z},{10,0,0}},{{L+20,0,z},{10,0,0}}})
    assert(r.edgeLists[1].snapNodes[1]==0 and r.edgeLists[2].snapNodes[1]==1)
   else
    equal(r.edgeLists[1].edges,{{{-40,0,z},{10,0,0}},{{-30,0,z},{10,0,0}}})
    -- The crossover footprint/curves never grow with platform length.
    for i=3,4 do for _,n in ipairs(sub.laneLists[i].nodes) do assert(n[1][1]>=-30 and n[1][1]<=0) end end
   end
   -- No duplicate/zero-length passenger curves; all public entries must
   -- reach both platform waiting areas through the real native graph.
   local graph,curves={},{}
   local public={}
   for i=vehicles+1,#sub.laneLists do
    local lane=sub.laneLists[i]
    assert(lane.transportModes[1]=="PERSON")
    if lane.linkable then public[#public+1]=key(lane.nodes[1][1]) end
    for j=1,#lane.nodes,2 do
     local a,b=lane.nodes[j],lane.nodes[j+1]
     local ak,bk=key(a[1]),key(b[1])
     assert(ak~=bk,"no zero-length pedestrian curve at shortest layout")
     local function neg(t)return{-t[1],-t[2],-t[3]}end
     local forward=ak.."|"..key(a[2]).."|"..bk.."|"..key(b[2])
     local reverse=bk.."|"..key(neg(b[2])).."|"..ak.."|"..key(neg(a[2]))
     assert(not curves[forward] and not curves[reverse],"no duplicate pedestrian curves")
     curves[forward]=true
     graph[ak]=graph[ak] or {};graph[bk]=graph[bk] or {};graph[ak][bk]=true;graph[bk][ak]=true
    end
   end
   assert(#public==(placement==1 and stationType==1 and 6 or 1))
   for _,start in ipairs(public) do
    local seen,queue={},{start}
    while #queue>0 do
     local p=table.remove(queue)
     if not seen[p] then seen[p]=true;for n in pairs(graph[p] or {}) do queue[#queue+1]=n end end
    end
    for _,terminal in ipairs(sub.station.terminals) do for _,ref in ipairs(terminal.personNodes) do
     local point=sub.laneLists[ref[1]+1].nodes[ref[2]+1][1]
     assert(point[1]>=-1e-6 and point[1]<=L+1e-6,"waiting nodes must lie on selected platform length")
     assert(seen[key(point)],"each public access reaches both platforms")
    end end
   end
   if placement==1 then
    local coverage={[-1]={},[1]={}}
    local floors=resource("surface_platform.mdl").boundingInfo
    assert(floors.bbMin[1]==0 and floors.bbMax[1]==40)
    local hasWall=false
    for _,m in ipairs(sub.models) do
     local t=m.transf
     if m.id=="mrnickert_ultimate_metro::/surface_platform.mdl" or m.id=="mrnickert_ultimate_metro::/platform20.mdl" then
      local side=t[14]<0 and -1 or 1
      coverage[side][#coverage[side]+1]={t[13],t[13]+(m.id=="mrnickert_ultimate_metro::/platform20.mdl" and 20 or 40)*t[1]}
     elseif m.id=="mrnickert_ultimate_metro::/surface_underpass.mdl" then
      assert(t[1]==1 and t[6]==1 and t[11]==1,"stairs must not be stretched")
      local side=t[14]<0 and -1 or 1
      coverage[side][#coverage[side]+1]={t[13],t[13]+40}
     elseif m.id=="mrnickert_ultimate_metro::/lightrail_fence.mdl" then
      assert(fence==2)
      local left,right=t[13]-0.805*t[1],t[13]+0.814*t[1]
      assert(right<=0 or left>=L,"fence stops at selected platform ends")
     elseif m.id=="::/assets/streets/tram_pole_crossbar.mdl" and stationType==1 then
      assert(t[13]<L/2-10 or t[13]>L/2+10,"pole cannot stand in stair opening")
     end
     if m.id=="mrnickert_ultimate_metro::/surface_head_tile.mdl" then
      hasWall=true;assert(t[13]==L+5,"head plaza follows actual platform end")
     end
    end
    assert(hasWall==(stationType==2))
    for _,bench in ipairs(sub.models) do
     if bench.id=="::/assets/buildings/res/grd_frn/bench_c_metal.mdl" then
      for _,shelter in ipairs(sub.models) do
       if shelter.id=="::/stations/street/small_stops/small_new.mdl" and shelter.transf[14]*bench.transf[14]>0 then
        assert(math.abs(bench.transf[13]-shelter.transf[13])>=5,"bench must not overlap the shelter on a short platform")
       end
      end
     end
    end
    for _,segments in pairs(coverage) do
     table.sort(segments,function(a,b)return a[1]<b[1]end)
     local endX=0
     for _,segment in ipairs(segments) do
      assert(math.abs(segment[1]-endX)<1e-6,"visible platform has no gap or overlapping slab")
      endX=segment[2]
     end
     assert(math.abs(endX-L)<1e-6,"visible platform length matches selection")
    end
   else
    local ends,wall={},nil
    for _,m in ipairs(sub.models) do
     if m.id=="::/stations/street/underground_station/models/underground_station_end.mdl" then ends[m.transf[13]]=true end
     if m.id=="::/assets/buildings/res/misc/wall_2m_m.mdl" then wall=m end
    end
    assert(ends[stationType==1 and -10 or -30] and ends[stationType==1 and L+10 or L])
    assert((wall~=nil)==(stationType==2))
    if wall then assert(wall.transf[13]==L+0.7) end
    assert(r.snapPoint.transf[13]==L-12,"surface entrance follows concourse")
    assert(r.cost==900000 and r.maintenanceCost==180000)
   end
   for _,m in ipairs(sub.models) do for _,v in ipairs(m.transf) do assert(v==v and math.abs(v)<1e6) end end
  end end end
 end
 equal(script.updateFn({},{}),script.updateFn({}, {platformLength=3}),"old saves default to 80m")
 for _,invalid in ipairs({0,6,80,-1,2.5,"invalid"}) do
  equal(script.updateFn({},{}),script.updateFn({}, {platformLength=invalid}))
 end
 print("PASS: 40 length/type/placement/fence combinations; exact deck coverage and midpoint stops; unchanged switches, all public accesses, no duplicate curves or poles in stair holes; old-save 80m default.")
end
