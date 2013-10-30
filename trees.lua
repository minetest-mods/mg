mg.register_tree({
	max_biome_humidity = -0.4,
	min_biome_temperature = 0.4,
	min_height = 4,
	max_height = 40,
	grows_on = c_desert_sand,
	chance = 50,
	grow = function(data, a, x, y, z, minp, maxp, pr)
		-- Cactus
		local ch = pr:next(1, 4)
		for yy = math.max(y, minp.y), math.min(y+ch-1, maxp.y) do
			data[a:index(x, yy, z)] = c_cactus
		end
	end
})

mg.register_tree({
	max_biome_humidity = -0.4,
	min_biome_temperature = 0.4,
	min_height = 2,
	max_height = 30,
	grows_on = c_desert_sand,
	chance = 50,
	can_be_in_village = true,
	grow = function(data, a, x, y, z, minp, maxp, pr)
		-- Dry shrub
		if minp.y <= y and y <= maxp.y then
			data[a:index(x, y, z)] = c_dry_shrub
		end
	end
})

mg.register_tree({
	min_biome_humidity = -0.4,
	max_biome_humidity = 0.4,
	min_biome_temperature = 0.4,
	min_height = 2,
	max_height = 12,
	grows_on = c_dry_grass,
	chance = 1000,
	grow = add_savannatree
})

mg.register_tree({
	min_biome_humidity = -0.4,
	max_biome_humidity = 0.4,
	min_biome_temperature = 0.4,
	min_height = 13,
	max_height = 30,
	grows_on = c_dry_grass,
	chance = 250,
	grow = add_savannatree
})

mg.register_tree({
	min_biome_humidity = -0.4,
	max_biome_humidity = 0.4,
	min_biome_temperature = 0.4,
	min_height = 2,
	max_height = 40,
	grows_on = c_dry_grass,
	chance = 1500,
	grow = add_savannabush
})

mg.register_tree({
	min_biome_humidity = 0.4,
	min_biome_temperature = 0.4,
	min_height = 1,
	max_height = 40,
	grows_on = c_grass,
	chance = 14,
	grow = add_tree
})

mg.register_tree({
	min_biome_humidity = 0.4,
	min_biome_temperature = 0.4,
	min_height = 1,
	max_height = 25,
	grows_on = c_grass,
	chance = 16,
	grow = add_jungletree
})

mg.register_tree({
	min_biome_humidity = 0.4,
	min_biome_temperature = 0.4,
	min_height = 1,
	max_height = 25,
	grows_on = c_grass,
	chance = 30,
	can_be_in_village = true,
	grow = function(data, a, x, y, z, minp, maxp, pr)
		-- Jungle grass
		if minp.y <= y and y <= maxp.y then
			data[a:index(x, y, z)] = c_jungle_grass
		end
	end
})

mg.register_tree({
	min_biome_humidity = -0.4,
	max_biome_temperature = -0.4,
	min_height = 3,
	max_height = 55,
	grows_on = c_dirt_snow,
	chance = 40,
	grow = add_pinetree
})

mg.register_tree({
	max_biome_humidity = -0.4,
	max_biome_temperature = -0.4,
	min_height = 3,
	max_height = 55,
	grows_on = c_dirt_snow,
	chance = 500,
	grow = add_pinetree
})

mg.register_tree({
	max_biome_humidity = -0.4,
	min_biome_temperature = -0.4,
	max_biome_temperature = 0.4,
	min_height = 1,
	max_height = 40,
	grows_on = c_grass,
	chance = 250,
	grow = add_tree
})

mg.register_tree({
	max_biome_humidity = -0.4,
	min_biome_temperature = -0.4,
	max_biome_temperature = 0.4,
	min_height = 1,
	max_height = 40,
	grows_on = c_grass,
	chance = 60,
	can_be_in_village = true,
	grow = function(data, a, x, y, z, minp, maxp, pr)
		-- Grass 1-4
		if minp.y <= y and y <= maxp.y then
			data[a:index(x, y, z)] = c_grasses[pr:next(1, 4)]
		end
	end
})

mg.register_tree({
	min_biome_humidity = 0.4,
	min_biome_temperature = -0.4,
	max_biome_temperature = 0.4,
	min_height = 1,
	max_height = 40,
	grows_on = c_grass,
	chance = 250,
	grow = add_tree
})

mg.register_tree({
	min_biome_humidity = 0.4,
	min_biome_temperature = -0.4,
	max_biome_temperature = 0.4,
	min_height = 3,
	max_height = 40,
	grows_on = c_grass,
	chance = 3,
	can_be_in_village = true,
	grow = function(data, a, x, y, z, minp, maxp, pr)
		-- Grass 3-5
		if minp.y <= y and y <= maxp.y then
			data[a:index(x, y, z)] = c_grasses[pr:next(3, 5)]
		end
	end
})

mg.register_tree({
	min_biome_humidity = -0.4,
	max_biome_humidity = 0.4,
	min_biome_temperature = -0.4,
	max_biome_temperature = 0.4,
	min_height = 3,
	max_height = 40,
	grows_on = c_grass,
	chance = 20,
	grow = add_tree
})

mg.register_tree({
	min_height = 1,
	max_height = 1,
	grows_on = c_grass,
	chance = 10,
	grow = function(data, a, x, y, z, minp, maxp, pr)
		-- Papyrus
		local ph = pr:next(2, 4)
		for yy = math.max(y, minp.y), math.min(y+ph-1, maxp.y) do
			data[a:index(x, yy, z)] = c_papyrus
		end
	end
})

function mg.get_spawn_tree_func(treedef)
	return function(data, a, x, y, z, minp, maxp, pr)
		if minp.y <= y and y <= maxp.y then
			minetest.after(0, minetest.spawn_tree, {x=x, y=y, z=z}, treedef)
		end
	end
end

if minetest.get_modpath("moretrees") then
	mg.register_tree({
		min_humidity = 0,
		min_temperature = 0.2,
		min_height = 1,
		max_height = 5,
		grows_on = c_grass,
		chance = 800,
		grow = mg.get_spawn_tree_func(moretrees.rubber_tree_model)
	})
end
