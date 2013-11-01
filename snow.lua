local function getmp(x)
	return (80 * math.floor((x + 32) / 80)) - 32
end

local function get_minp(pos)
	return {x=getmp(pos.x), y=getmp(pos.y), z=getmp(pos.z)}
end

--[[local snow_timer = 0
local snow_range = 1
minetest.register_globalstep(function(dtime)
	snow_timer = snow_timer + dtime
	if snow_timer < 1 then return end
	snow_timer = 0
	local noise_temperature_raw = minetest.get_perlin(763, 7, 0.5, 512)
	local noise_humidity_raw = minetest.get_perlin(834, 7, 0.5, 512)
	for _, player in ipairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		if pos.y > -50 and pos.y < 150 then
			--local to_update = {}
			--local to_update_index = 1
			local minp = get_minp(pos)
			local biome_table = get_biome_table(minp, noise_humidity_raw, noise_temperature_raw, snow_range+1)
			local vm = minetest.get_voxel_manip()
			local eminp, emaxp = vm:read_from_map({x=minp.x-80*snow_range, y=-50, z=minp.z-80*snow_range}, {x=minp.x+79+80*snow_range, y=150, z=minp.z+79+80*snow_range})
			--print(dump(eminp), dump(emaxp))
			local a = VoxelArea:new{MinEdge=eminp, MaxEdge=emaxp}
			local data = vm:get_data()
			for i = 1, 80*(snow_range+1)*(snow_range+1) do
				local x = math.random(eminp.x, emaxp.x)
				local z = math.random(eminp.z, emaxp.z)
				local biome = get_nearest_biome(biome_table, x, z)
				if biome.t < -0.4 then
					local y = emaxp.y
					while y >= eminp.y and data[a:index(x, y, z)] == c_air do
						y = y - 1
					end
					if y >= eminp.y and y < emaxp.y then
						if data[a:index(x, y, z)] == c_snow then
							if minetest.add_node_level({x=x, y=y, z=z}, 7) ~= 0 then
								--data[a:index(x, y+1, z)] = c_snow
								minetest.set_node({x=x, y=y+1, z=z}, {name = "default:snow"})
							end
						else
							--data[a:index(x, y+1, z)] = c_snow
							minetest.set_node({x=x, y=y+1, z=z}, {name = "default:snow"})
						end
						--to_update[to_update_index] = {x=x,y=y+1,z=z}
						--to_update_index = to_update_index+1
					end
				end
			end
			--vm:set_data(data)
			--vm:write_to_map(data)
			--for _, pos in ipairs(to_update) do
			--	nodeupdate(pos)
			--end
		end
	end
end)]]

local function add_snow_level(pos)
	local level = minetest.get_node_level(pos)
	if level <= 28 then
		minetest.add_node_level(pos, 7)
		return 0
	else
		return 7
	end
end

local is_snowing = false

local to_snow = {}
local to_snow_index = 0
local SNOW_RANGE = 16
local SNOW_BLOCK_SIZE = 4
local SNOW_STEPS = 10
local SNOW_TIMES_PER_BLOCK = 4
minetest.register_globalstep(function(dtime)
	if math.random(1, 5000) == 1 then
		is_snowing = not is_snowing
	end
	if to_snow_index == 0 then
		if is_snowing then
			for _, player in ipairs(minetest.get_connected_players()) do
				local pos = player:getpos()
				if pos.y > -50 and pos.y < 150 then
					local x = SNOW_BLOCK_SIZE*math.floor((pos.x/SNOW_BLOCK_SIZE)+0.5)
					local z = SNOW_BLOCK_SIZE*math.floor((pos.z/SNOW_BLOCK_SIZE)+0.5)
					for xi = -SNOW_RANGE, SNOW_RANGE do
					for zi = -SNOW_RANGE, SNOW_RANGE do
						to_snow_index = to_snow_index + 1
						to_snow[to_snow_index] = {x=x+SNOW_BLOCK_SIZE*xi, y=0, z=z+SNOW_BLOCK_SIZE*zi}
					end
					end
				end
			end
		end
	else
		local noise_temperature_raw = minetest.get_perlin(763, 7, 0.5, 512)
		local noise_humidity_raw = minetest.get_perlin(834, 7, 0.5, 512)
		for s = 1, math.min(SNOW_STEPS, to_snow_index) do
			local pos = to_snow[to_snow_index]
			--print(dump(pos))
			to_snow[to_snow_index] = nil
			to_snow_index = to_snow_index - 1
			local minp = get_minp(pos)
			
			local biome_table = get_biome_table(minp, noise_humidity_raw, noise_temperature_raw)
			local vm = minetest.get_voxel_manip()
			local eminp, emaxp = vm:read_from_map({x=pos.x, y=-50, z=pos.z}, {x=pos.x + SNOW_BLOCK_SIZE - 1, y=150, z=pos.z + SNOW_BLOCK_SIZE - 1})
			--print(eminp.y, emaxp.y)
			--print(dump(eminp),dump(emaxp))
			local a = VoxelArea:new{MinEdge=eminp, MaxEdge=emaxp}
			local data = vm:get_data()
			for i = 1, SNOW_TIMES_PER_BLOCK do
				local x = math.random(pos.x, pos.x + SNOW_BLOCK_SIZE - 1)
				local z = math.random(pos.z, pos.z + SNOW_BLOCK_SIZE - 1)
				local biome = get_nearest_biome(biome_table, x, z)
				if biome.t < -0.4 then
					local y = emaxp.y
					while y >= eminp.y and (data[a:index(x, y, z)] == c_air or data[a:index(x, y, z)] == c_ignore) do
						y = y - 1
					end
					if y >= eminp.y and y < emaxp.y then
						if data[a:index(x, y, z)] == c_snow then
							--if minetest.add_node_level({x=x, y=y, z=z}, 7) ~= 0 then
							if add_snow_level({x=x, y=y, z=z}) ~= 0 then
								-- do nothing, max stack
								--minetest.set_node({x=x, y=y, z=z}, {name = "default:snowblock"})
							end
						elseif data[a:index(x, y, z)] == c_snowblock or data[a:index(x, y, z)] == c_water then
							-- do nothing
						else
							minetest.set_node({x=x, y=y+1, z=z}, {name = "default:snow"})
						end
					end
				end
			end
		end
	end
end)

minetest.register_abm({
	nodenames = {"mg:pineleaves"},
	interval = 2,
	chance = 4,
	action = function(pos, node)
		local above = {x=pos.x, y=pos.y+1, z=pos.z}
		if minetest.get_node(above).name == "default:snow" then
			local level = minetest.get_node_level(above)
			if level >= 14 then
				for i = 1, 15 do
					local p = {x=pos.x, y=pos.y-i, z=pos.z}
					local n = minetest.get_node(p).name
					if n ~= "air" and n ~= "mg:pineleaves" then
						if n == "default:snow" then
							--if minetest.add_node_level(p, 7) == 0 then
							if add_snow_level(p) == 0 then
								minetest.add_node_level(above, -7)
							end
						else
							local above_p = {x=p.x, y=p.y+1, z=p.z}
							if minetest.get_node(above_p).name == "air" then
								minetest.set_node(above_p, {name = "default:snow"})
								minetest.add_node_level(above, -7)
							end
						end
						return
					end
				end
			end
		end
	end
})
