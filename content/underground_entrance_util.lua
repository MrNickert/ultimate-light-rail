-- Native layout data by Urban Games; adapted for Ultimate Metro.
local vec3 = require "::/scripts/vec3.tl"
local transf = require "::/scripts/mat4.tl"
local laneutil = require "::/scripts/construction/laneutil.lua"
local modulesutil = require "::/scripts/construction/modulesutil.lua"

local constructionutil = require "::/scripts/construction/constructionutil.lua"

local function mul(mat, vec) 
	return {
		mat[1]*vec[1] + mat[5]*vec[2] + mat[ 9]*vec[3] + mat[13],
		mat[2]*vec[1] + mat[6]*vec[2] + mat[10]*vec[3] + mat[14],
		mat[3]*vec[1] + mat[7]*vec[2] + mat[11]*vec[3] + mat[15]
	}
end

local function transform(curve, mat)
	local ret = {}
	for i=1, #curve do
		local points = curve[i]
		local transfCurv = {}
		for j = 1, #points do
			transfCurv[j] = mul(mat, points[j])
		end
		ret[i] = transfCurv
	end

	return ret
end

local function makeCircleEdges(depth, radius, split_deg)
	local function arc_to_bezier(r, a0, a1, depth)
		local theta = a1 - a0
		local mid = (a0 + a1) / 2
		local cos0, sin0 = math.cos(a0), math.sin(a0)
		local cos1, sin1 = math.cos(a1), math.sin(a1)
		local cosM, sinM = math.cos(mid), math.sin(mid)

		local p0 = { r * cos0, r * sin0, depth }
		local p2 = { r * cos1, r * sin1, depth }

		local control_radius = r / math.cos(theta / 2)
		local p1 = { control_radius * math.cos(mid), control_radius * math.sin(mid), depth }

		return { p0, p1, p2 }
	end

	-- Collect all breakpoints (≤45° + custom splits)
	local breaks = {}
	for a = 0, 360, 45 do
		table.insert(breaks, a)
	end
	table.insert(breaks, split_deg % 360)
	table.insert(breaks, (split_deg + 180) % 360)

	-- Sort and deduplicate
	table.sort(breaks)
	local unique = {}
	for _, a in ipairs(breaks) do
		if #unique == 0 or math.abs(a - unique[#unique]) > 1e-6 then
			table.insert(unique, a)
		end
	end
	if unique[#unique] < 360 then
		table.insert(unique, 360)
	end

	-- Create segments
	local segments = {}
	for i = 1, #unique - 1 do
		local a0, a1 = math.rad(unique[i]), math.rad(unique[i + 1])
		table.insert(segments, arc_to_bezier(radius, a0, a1, depth))
	end

	return segments
end

--Begin Generated
local generatedData = {
	["static"] = {
		curves = {
			["ground_face"] = {
				{ { 8.0, 8.0, 0.0 }, { -8.0, 8.0, 0.0 }, { -8.0, 24.0, 0.0 }, { 8.0, 24.0, 0.0 }, },
			},
		},
	},
	["base"] = {
		curves = {
			["passenger_entrance_link"] = {
				-- top level
				{ { 3, 9, 0 }, { 3, 20, 0 }, },
				{ { 3, 20, 0 }, { 0, 20, 0 }, },

			},
			["passenger_entrance"] = {
				-- top level
				{ { -3, 9, 0 }, { -3, 20, 0 }, },
				{ { -3, 20, 0 }, { 0, 20, 0 }, },

				{ { 0, 20, 0 }, { 0, 17.51, 0.057 }, },

				-- stairs
				{ { 0, 17.51, 0.057 }, { 0, 1.5, -9 }, },
				{ { 0, 1.5, -9 }, { 0, 0, -9 }, },

				{ { 0, 0, -9 }, { 1.5, 0, -9 }, },
				{ { 1.5, 0, -9 }, { 6.7, 0, -12 }, },
				{ { 6.7, 0, -12 }, { 8.5, 0, -12 }, },

				{ { 0, 0, -9 }, { -1.5, 0, -9 }, },
				{ { -1.5, 0, -9 }, { -6.7, 0, -12 }, },
				{ { -6.7, 0, -12 }, { -8.5, 0, -12 }, },
			},
			["collider"] = {
				{ 
					{ 8.0, 9.0, 20.0 }, { -8.0, 9.0, 20.0 }, { -8.0, 24.0, 20.0 }, { 8.0, 24.0, 20.0 }, 
					{ 8.0, 9.0, -7.4 }, { -8.0, 9.0, -7.4 }, { -8.0, 24.0, -7.4 }, { 8.0, 24.0, -7.4 }, 
				},
			},
		},
		meshes = {
			["equal"] = {
				{ 
					{ { 8.0, 9.0, 0.0 }, { -8.0, 24.0, 0.0 }, { -8.0, 9.0, 0.0 }, },
					{ { -8.0, 24.0, 0.0 }, { 8.0, 9.0, 0.0 }, { 8.0, 24.0, 0.0 }, },
				}
			},

		},
		models = {
			["::/stations/street/underground_station/models/underground_station_surface.mdl"] = {
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
			},
			["::/assets/stations/rail/era_c_street_pillar.mdl"] = {
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1.5, 8, 0, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, -1.5, 8, 0, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 3.5, 8, 0, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, -3.5, 8, 0, 1, },
			},
			["::/assets/buildings/com/advertisements/column_c_01.mdl"] = {
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 9.5, 0, 1, },
			},
			["::/assets/buildings/res/hedges/hdg_02_3m.mdl"] = {
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 6.5, 11, 0, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -6.5, 11, 0, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 6.5, 17, 0, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -6.5, 17, 0, 1, },
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -5, 23.5, 0, 1, },
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 23.5, 0, 1, },
			},
			["::/assets/buildings/com/misc/trashcan_c_01.mdl"] = {
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, 14, 0, 1, },
				{ -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, -5, 14, 0, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 22, 0, 1, },
			},
			["::/assets/buildings/res/garden_lamp/garden_lamp_c_stand.mdl"] = {
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 5, 11, 0, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 5, 17, 0, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -5, 11, 0, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -5, 17, 0, 1, },
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -3.5, 22, 0, 1, },
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 3.5, 22, 0, 1, },
			},
			["::/assets/buildings/res/grd_frn/bench_c_metal.mdl"] = {
				{ -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 5, 15.5, 0, 1, },
				{ -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 5, 12.5, 0, 1, },
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -5, 15.5, 0, 1, },
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -5, 12.5, 0, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1.5, 22, 0, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, -1.5, 22, 0, 1, },
			},
			["::/assets/buildings/res/hedges/hdg_02.mdl"] = {
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 6.5, 9, 0, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -6.5, 9, 0, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 6.5, 23, 0, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -6.5, 23, 0, 1, },
			},
		}
	},
	["rotated"] = {
		curves = {
			["passenger_passageway"] = {
				-- inside
				{ { 0, 8.5, -12 }, { 0, 11.75, -12 }, },
				{ { 0, 11.75, -12 }, { 3.33, 11.75, -12 }, },
				{ { 3.33, 11.75, -12 }, { 13.33, 11.75, -17.65 }, },
				{ { 13.33, 11.75, -17.65 }, { 14.66, 11.75, -17.65 }, },
				{ { 14.66, 11.75, -17.65 }, { 14.66, 5, -17.65 }, },

				{ { 0, 11.75, -12 }, { -3.33, 11.75, -12 }, },
				{ { -3.33, 11.75, -12 }, { -13.33, 11.75, -17.65 }, },
				{ { -13.33, 11.75, -17.65 }, { -14.66, 11.75, -17.65 }, },
				{ { -14.66, 11.75, -17.65 }, { -14.66, 5, -17.65 }, },

				{ { 0, -8.5, -12 }, { 0, -11.75, -12 }, },
				{ { 0, -11.75, -12 }, { 3.33, -11.75, -12 }, },
				{ { 3.33, -11.75, -12 }, { 13.33, -11.75, -17.65 }, },
				{ { 13.33, -11.75, -17.65 }, { 14.66, -11.75, -17.65 }, },
				{ { 14.66, -11.75, -17.65 }, { 14.66, -5, -17.65 }, },

				{ { 0, -11.75, -12 }, { -3.33, -11.75, -12 }, },
				{ { -3.33, -11.75, -12 }, { -13.33, -11.75, -17.65 }, },
				{ { -13.33, -11.75, -17.65 }, { -14.66, -11.75, -17.65 }, },
				{ { -14.66, -11.75, -17.65 }, { -14.66, -5, -17.65 }, },
			},
			["collider"] = {
				{ 
					{ 20.0, -14.0, -7.5 }, { -20.0, -14.0, -7.5 }, { -20.0, 14.0, -7.5 }, { 20.0, 14.0, -7.5 }, 
					{ 20.0, -14.0, -20.0 }, { -20.0, -14.0, -20.0 }, { -20.0, 14.0, -20.0 }, { 20.0, 14.0, -20.0 }, 
				},
			},
		},
		models = {
			["::/stations/street/underground_station/models/underground_station_stairs.mdl"] = {
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
			},
			["::/assets/stations/street/tickets_era_c_1.mdl"] = {
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 12.7, -12, 1, },
				{ -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -12.7, -12, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 15.4, 12, -17.65, 1, },
				{ 0,-1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -15.4, 12, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 15.4, -12, -17.65, 1, },
				{ 0,-1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -15.4, -12, -17.65, 1, },
			},
			["::/assets/stations/rail/era_c_station_name.mdl"] = {
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, 7.15, -16.15, 1, },
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -5, 7.15, -16.15, 1, },
				
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, -7.15, -16.15, 1, },
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -5, -7.15, -16.15, 1, },
			},
			["::/assets/buildings/com/misc/trashcan_c_01.mdl"] = {
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 10, 6.5, -17.65, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 6.5, -17.65, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -10, 6.5, -17.65, 1, },
				
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 10, -6.5, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, -6.5, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, -10, -6.5, -17.65, 1, },
			},
			["::/assets/buildings/res/grd_frn/bench_c_metal.mdl"] = {
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 11.5, 6.5, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 8.5, 6.5, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1.5, 6.5, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, -1.5, 6.5, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, -11.5, 6.5, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, -8.5, 6.5, -17.65, 1, },

				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 11.5, -6.5, -17.65, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 8.5, -6.5, -17.65, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 1.5, -6.5, -17.65, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -1.5, -6.5, -17.65, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -11.5, -6.5, -17.65, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -8.5, -6.5, -17.65, 1, },
			},
		}
	},
	["extended"] = {
		curves = {
			["collider"] = {
				{ 
					{ 9.0, -10.0, -11.5 }, { 0.0, -10.0, -11.5 }, { 0.0, 10.0, -11.5 }, { 9.0, 10.0, -11.5 }, 
					{ 9.0, -10.0, -20.0 }, { 0.0, -10.0, -20.0 }, { 0.0, 10.0, -20.0 }, { 9.0, 10.0, -20.0 }, 
				},
			},
		},
		models = {
			["::/stations/street/underground_station/models/underground_station_extension.mdl"] = {
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
			},
			["::/assets/stations/rail/era_c_station_name.mdl"] = {
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, 7.15, -16.15, 1, },
				
				{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, -7.15, -16.15, 1, },
			},
			["::/assets/buildings/com/misc/trashcan_c_01.mdl"] = {
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 6.5, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, -6.5, -17.65, 1, },
			},
			["::/assets/buildings/res/grd_frn/bench_c_metal.mdl"] = {
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1.5, 6.5, -17.65, 1, },
				{ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, -1.5, 6.5, -17.65, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 1.5, -6.5, -17.65, 1, },
				{ 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, -1.5, -6.5, -17.65, 1, },
			},
		}
	},
}
--End Generated

-- Adapted from Urban Games' underground_station.script.lua.
-- Default 80m platforms, variable length for the unified station. The concourse
-- stays near the far end; its entrance is rotated along the track axis.
return function(params,options)
 options=options or {}
 -- The native helper requires a seed even for an unrandomized hall.
 if params.seed==nil then
  local config={seed=0}
  for key,value in pairs(params) do config[key]=value end
  params=config
 end
 local L=options.length or 80
 local approach=options.turnback and 30 or 10
 local centre=options.centred and L/2 or L-20
 local shift=transf.transl(vec3.new(centre,0,0))
 local entranceShift=options.streetAligned and transf.transl(vec3.new(0,0,0))
  or transf.mul(shift,transf.rotZ(-math.pi/2))
 local result={models={},laneLists={}}
 local function person(curves,linkable,matrix)
  result.laneLists[#result.laneLists+1]=laneutil.createLane(transform(curves,matrix or shift),{"PERSON"},2,2,linkable)
 end
 if not options.internal then
  person(generatedData.base.curves.passenger_entrance_link,true,entranceShift)
  person(generatedData.base.curves.passenger_entrance,false,entranceShift)
  constructionutil.addModelsAndGroups(params,generatedData.base,result,nil,entranceShift)
  modulesutil.addGroundFaces("::/stations/street/underground_station/underground_station.gtex",generatedData,result,entranceShift)
 end
 if options.entranceOnly then return result end
 person(makeCircleEdges(-12,8.5,-90),false)
 person(generatedData.rotated.curves.passenger_passageway,false)
 -- Keep platforms at world x=0..L; break exactly at the relocated stairs.
 for _,y in ipairs({-5,5}) do
  person({
   {{-centre,y,-17.65},{-14.66,y,-17.65}},
   {{-14.66,y,-17.65},{14.66,y,-17.65}},
   {{14.66,y,-17.65},{L-centre,y,-17.65}},
  },false)
 end
 constructionutil.addModelsAndGroups(params,generatedData.rotated,result,nil,shift)
 -- Native extensions fill the shell from the left throat to the 40m concourse.
 for x=20,(options.through and centre-10+approach or L),10 do
  constructionutil.addModelsAndGroups(params,generatedData.extended,result,nil,
   transf.mul(shift,transf.mul(transf.rotZ(math.pi),transf.transl(vec3.new(x,0,0)))))
 end
 if options.through then
  for x=centre+20,L+approach-10,10 do
   constructionutil.addModelsAndGroups(params,generatedData.extended,result,nil,
    transf.transl(vec3.new(x,0,0)))
  end
 end
 local ends=options.through and {{L+approach,false},{-approach,true}} or {{L,false},{-30,true}}
 for _,endpoint in ipairs(ends) do
  result.models[#result.models+1]={id="::/stations/street/underground_station/models/underground_station_end.mdl",
   transf=transf.mul(transf.transl(vec3.new(endpoint[1],0,0)),transf.rotZ(endpoint[2] and math.pi or 0))}
 end
 -- Close the native tunnel opening visually at the dead-end only.
 -- Existing brick wall mesh: 4m wide, z=-3.2..2, fitted to the 14m head wall.
 if not options.through then
 result.models[#result.models+1]={id="::/assets/buildings/res/misc/wall_2m_m.mdl",
  transf={1,0,0,0,0,3.5,0,0,0,0,5.65/5.2,0,L+0.7,0,-12.5-2*5.65/5.2,1}}
 end
 return result
end
