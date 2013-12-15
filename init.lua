mg = {}

minetest.register_on_mapgen_init(function(mgparams)
		minetest.set_mapgen_params({mgname="singlenode", flags="nolight", flagmask="nolight"})
end)

function inside_village(x, z, vx, vz, vs, vnoise)
	return x*x + z*z <= 300*300
end

minetest.register_on_mapgen_init(function(mgparams)
	wseed = math.floor(mgparams.seed/10000000000)
end)

function get_bseed(minp)
	return wseed + math.floor(5*minp.x/47) + math.floor(873*minp.z/91)
end

function get_bseed2(minp)
	return wseed + math.floor(87*minp.x/47) + math.floor(73*minp.z/91) + math.floor(31*minp.y/12)
end

c_air = minetest.get_content_id("air")
c_ignore = minetest.get_content_id("ignore")
c_tree = minetest.get_content_id("default:tree")
c_leaves = minetest.get_content_id("default:leaves")

local function add_leaves(data, vi, c_leaves)
	if data[vi]==c_air or data[vi]==c_ignore then
		data[vi] = c_leaves
	end
end

function add_tree(data, a, x, y, z, minp, maxp, pr)
	local th = pr:next(3, 4)
	for yy=math.max(minp.y, y), math.min(maxp.y, y+th) do
		local vi = a:index(x, yy, z)
		data[vi] = c_tree
	end
	local maxy = y+th
	for xx=math.max(minp.x, x-1), math.min(maxp.x, x+1) do
	for yy=math.max(minp.y, maxy-1), math.min(maxp.y, maxy+1) do
	for zz=math.max(minp.z, z-1), math.min(maxp.z, z+1) do
		add_leaves(data, a:index(xx, yy, zz), c_leaves)
	end
	end
	end
	for i=1,8 do
		local xi = pr:next(x-2, x+1)
		local yi = pr:next(maxy-1, maxy+1)
		local zi = pr:next(z-2, z+1)
		for xx=math.max(minp.x, xi), math.min(maxp.x, xi+1) do
		for yy=math.max(minp.y, yi), math.min(maxp.y, yi+1) do
		for zz=math.max(minp.z, zi), math.min(maxp.z, zi+1) do
			add_leaves(data, a:index(xx, yy, zz), c_leaves)
		end
		end
		end
	end
end


dofile(minetest.get_modpath(minetest.get_current_modname()).."/we.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/rotate.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/buildings.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/villages.lua")

local function mg_generate(minp, maxp, emin, emax, vm)
	local a = VoxelArea:new{
		MinEdge={x=emin.x, y=emin.y, z=emin.z},
		MaxEdge={x=emax.x, y=emax.y, z=emax.z},
	}
	local pr = PseudoRandom(get_bseed(minp))
	
	local village_noise = minetest.get_perlin(7635, 5, 0.5, 512)
	
	local data = vm:get_data()
	
	local to_grow = {}

	local c_grass = minetest.get_content_id("default:dirt_with_grass")
	local c_dirt = minetest.get_content_id("default:dirt")
	if minp.y <= 0 and maxp.y>=0 then	
		for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			data[a:index(x, 0, z)] = c_grass
			data[a:index(x, -1, z)] = c_dirt
			if pr:next(1, 50) == 1 then
				to_grow[#to_grow+1] = {x=x, y=1, z=z}
			end
		end
		end
	end
	
	local to_add = generate_village(minp, maxp, data, a, to_grow, village_noise)

	vm:set_data(data)

	vm:calc_lighting(
		{x=minp.x-16, y=minp.y, z=minp.z-16},
		{x=maxp.x+16, y=maxp.y, z=maxp.z+16}
	)

	vm:write_to_map(data)

	local meta
	for _, n in pairs(to_add) do
		minetest.set_node(n.pos, n.node)
		if n.meta ~= nil then
			meta = minetest.get_meta(n.pos)
			meta:from_table(n.meta)
			if n.node.name == "default:chest" then
				local inv = meta:get_inventory()
				local items = inv:get_list("main")
				for i=1, inv:get_size("main") do
					inv:set_stack("main", i, ItemStack(""))
				end
				local numitems = pr:next(3, 20)
				for i=1,numitems do
					local ii = pr:next(1, #items)
					local prob = items[ii]:get_count() % 2 ^ 8
					local stacksz = math.floor(items[ii]:get_count() / 2 ^ 8)
					if pr:next(0, prob) == 0 and stacksz>0 then
						stk = ItemStack({name=items[ii]:get_name(), count=pr:next(1, stacksz), wear=items[ii]:get_count(), metadata=items[ii]:get_metadata()})
						local ind = pr:next(1, inv:get_size("main"))
						while not inv:get_stack("main",ind):is_empty() do
							ind = pr:next(1, inv:get_size("main"))
						end
						inv:set_stack("main", ind, stk)
					end
				end
			end
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	mg_generate(minp, maxp, emin, emax, vm)
end)

local function mg_regenerate(pos, name)
	local minp = {x = 80*math.floor((pos.x+32)/80)-32,
			y = 80*math.floor((pos.y+32)/80)-32,
			z = 80*math.floor((pos.z+32)/80)-32}
	local maxp = {x = minp.x+79, y = minp.y+79, z = minp.z+79}
	local vm = minetest.get_voxel_manip()
	local emin, emax = vm:read_from_map(minp, maxp)
	local data = {}
	for i = 1, (maxp.x-minp.x+1)*(maxp.y-minp.y+1)*(maxp.z-minp.z+1) do
		data[i] = c_air
	end
	vm:set_data(data)
	vm:write_to_map()
	mg_generate(minp, maxp, emin, emax, vm)
	
	minetest.chat_send_player(name, "Regenerating done, fixing lighting. This may take a while...")
	-- Fix lighting
	local nodes = minetest.find_nodes_in_area(minp, maxp, "air")
	local nnodes = #nodes
	local p = math.floor(nnodes/5)
        local dig_node = minetest.dig_node
        for _, pos in ipairs(nodes) do
                dig_node(pos)
                if _%p == 0 then
                	minetest.chat_send_player(name, math.floor(_/nnodes*100).."%")
                end
        end
        minetest.chat_send_player(name, "Done")
end

minetest.register_chatcommand("mg_regenerate", {
	privs = {server = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if player then
			local pos = player:getpos()
			mg_regenerate(pos, name)
		end
	end,
})
