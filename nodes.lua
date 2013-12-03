minetest.register_node("mg:savannatree", {
	description = "Savannawood Tree",
	tiles = {"mg_dry_tree_top.png", "mg_dry_tree_top.png", "mg_dry_tree.png"},
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("mg:savannaleaves", {
	description = "Savannawood Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"mg_dry_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	waving = 1,
	drop = {
		max_items = 1,
		items = {
			{
				items = {'mg:savannasapling'},
				rarity = 20,
			},
			{
				items = {'mg:savannaleaves'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("mg:savannawood", {
	description = "Savannawood Planks",
	tiles = {"mg_dry_wood.png"},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = 'mg:savannawood 4',
	recipe = {
		{'mg:savannatree'},
	}
})

minetest.register_node("mg:savannasapling", {
	description = "Savannawood Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"mg_dry_sapling.png"},
	inventory_image = "mg_dry_sapling.png",
	wield_image = "mg_dry_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_abm({
	nodenames = {"mg:savannasapling"},
	interval = 10,
	chance = 50,
	action = function(pos, node)
		local vm = minetest.get_voxel_manip()
		local minp, maxp = vm:read_from_map({x=pos.x-10, y=pos.y, z=pos.z-10}, {x=pos.x+10, y=pos.y+20, z=pos.z+10})
		local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
		local data = vm:get_data()
		add_savannatree(data, a, pos.x, pos.y, pos.z, minp, maxp, PseudoRandom(math.random(1,100000)))
		vm:set_data(data)
		vm:write_to_map(data)
		vm:update_map()
	end
})

minetest.register_node("mg:dirt_with_dry_grass", {
	description = "Dry Grass",
	tiles = {"mg_dry_grass.png", "default_dirt.png", "default_dirt.png^mg_dry_grass_side.png"},
	is_ground_content = true,
	groups = {crumbly=3,soil=1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.25},
	}),
})

minetest.register_node("mg:pinetree", {
	description = "Pine Tree",
	tiles = {"mg_pine_tree_top.png", "mg_pine_tree_top.png", "mg_pine_tree.png"},
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("mg:pineleaves", {
	description = "Pine Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"mg_pine_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	waving = 1,
	drop = {
		max_items = 1,
		items = {
			{
				items = {'mg:pinesapling'},
				rarity = 20,
			},
			{
				items = {'mg:pineleaves'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("mg:pinewood", {
	description = "Pine Planks",
	tiles = {"mg_pine_wood.png"},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = 'mg:pinewood 4',
	recipe = {
		{'mg:pinetree'},
	}
})

minetest.register_node("mg:pinesapling", {
	description = "Pine Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"mg_pine_sapling.png"},
	inventory_image = "mg_pine_sapling.png",
	wield_image = "mg_pine_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_abm({
	nodenames = {"mg:pinesapling"},
	interval = 10,
	chance = 50,
	action = function(pos, node)
		local vm = minetest.get_voxel_manip()
		local minp, maxp = vm:read_from_map({x=pos.x-10, y=pos.y, z=pos.z-10}, {x=pos.x+10, y=pos.y+30, z=pos.z+10})
		local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
		local data = vm:get_data()
		add_pinetree(data, a, pos.x, pos.y, pos.z, minp, maxp, PseudoRandom(math.random(1,100000)), c_air)
		vm:set_data(data)
		vm:write_to_map(data)
		vm:update_map()
	end
})

minetest.register_node("mg:ignore", {
	description = "MG Ignore",
	drawtype = "airlike",
	sunlight_propagates = true,
	groups = {snappy=2,not_in_creative_inventory=1},
})
