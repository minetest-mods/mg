local DMAX = 20
local AREA_SIZE = 80

minetest.register_on_mapgen_init(function(mgparams)
        minetest.set_mapgen_params({mgname="singlenode", flags="nolight", flagmask="nolight"})
end)

local cache = {}

local function cliff(x, n)
	--return (n+0.05)*0.4*x*x + 2*x + 4 + 4*n
	return 0.2*x*x - x + n*x - n*n*x*x - 0.01 * math.abs(x*x*x) + math.abs(x)*100*n*n*n*n
end

local function get_base_surface_at_point(x, z, noise1, noise2, noise3, noise4)
	local index = 65536*x+z
	if cache[index] ~= nil then return cache[index] end
	cache[index] = 25*(noise1:get2d({x=x, y=z})+noise2:get2d({x=x, y=z})*noise3:get2d({x=x, y=z})/3)
	if noise4:get2d({x=x, y=z}) > 0.8 then
		cache[index] = cliff(cache[index], noise4:get2d({x=x, y=z})-0.8)
	end
	return cache[index]
end

local function surface_at_point(x, z, ...)
	--[[if -AREA_SIZE<x and x<AREA_SIZE and -AREA_SIZE<z and z<AREA_SIZE then
		if flat_height~=nil then return flat_height end
		local s=0
		local n=0
		for x1=-AREA_SIZE, AREA_SIZE do
			n=n+2
			s=s+get_base_surface_at_point(x1, -AREA_SIZE, unpack({...}))+get_base_surface_at_point(x1, AREA_SIZE, unpack({...}))
		end
		for y1=-AREA_SIZE+1, AREA_SIZE-1 do
			n=n+2
			s=s+get_base_surface_at_point(-AREA_SIZE, y1, unpack({...}))+get_base_surface_at_point(AREA_SIZE, y1, unpack({...}))
		end
		flat_height = s/n
		return s/n
	end]]
	return get_base_surface_at_point(x, z, unpack({...}))
end

local SMOOTHED = AREA_SIZE+2*DMAX
local HSMOOTHED = AREA_SIZE+DMAX
local INSIDE = AREA_SIZE-DMAX

local function smooth(x, z, ...)
	local s=0
	local w=0
	for xi=-DMAX, DMAX do
	for zi=-DMAX, DMAX do
		local d2=xi*xi+zi*zi
		if d2<DMAX*DMAX then
			local w1 = 1-d2/(DMAX*DMAX)
			local w2 = 15/16*w1*w1
			w = w+w2
			s=s+w2*surface_at_point(x+xi, z+zi, unpack({...}))
		end
	end
	end
	return s/w
end

local function smooth_surface(x, z, ...)
	return surface_at_point(x, z, unpack({...}))
	--[[if -SMOOTHED>x or x>SMOOTHED or -SMOOTHED>z or z>SMOOTHED then return surface_at_point(x, z, unpack({...})) end
	if -INSIDE<x and x<INSIDE and -INSIDE<z and z<INSIDE then return surface_at_point(x, z, unpack({...})) end
	if -HSMOOTHED>x or x>HSMOOTHED or -HSMOOTHED>z or z>HSMOOTHED then
		local s = surface_at_point(x, z, unpack({...}))
		local s1 = smooth(x, z, unpack({...}))
		local m = math.max(math.abs(x), math.abs(z))
		return ((m-HSMOOTHED)*s+(SMOOTHED-m)*s1)/DMAX
	end
	return smooth(x, z, unpack({...}))]]
end

--[=[local tree_model={
	axiom="FFFFFBFB",
	rules_a="[&&&GGF[++^Fd][--&Fd]//Fd[+^Fd][--&Fd]]////[&&&GGF[++^Fd][--&Fd]//Fd[+^Fd][--&Fd]]////[&&&GGF[++^Fd][--&Fd]//Fd[+^Fd][--&Fdd]]",
	rules_b="[&&&F[++^Fd][--&d]//d[+^d][--&d]]////[&&&F[++^Fd][--&d]//d[+^d][--&d]]////[&&&F[++^Fd][--&Fd]//d[+^d][--&d]]",
	rules_c="/",
	rules_d="F",
	trunk="default:tree",
	leaves="default:leaves",
	angle=30,
	iterations=2,
	random_level=0,
	trunk_type="single";
	thin_branches=true;
}

minetest.register_node(":test_mapgen:sapling", {
	drawtype = "airlike",
	is_ground_content = true,
	buildable_to = true,
	groups = {not_in_creative_inventory=1},
})

minetest.register_abm({
	nodenames = {"test_mapgen:sapling"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name="air"})
		minetest.spawn_tree(pos, tree_model)
	end,
})]=]--

minetest.register_on_generated(function(minp, maxp, seed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local a = VoxelArea:new{
		MinEdge={x=emin.x, y=emin.y, z=emin.z},
		MaxEdge={x=emax.x, y=emax.y, z=emax.z},
	}
	
	local pr = PseudoRandom(seed)
	
	local noise1 = minetest.get_perlin(12345, 6, 0.5, 256)
	local noise2 = minetest.get_perlin(56789, 6, 0.5, 256)
	local noise3 = minetest.get_perlin(42, 3, 0.5, 32)
	local noise4 = minetest.get_perlin(8954, 8, 0.5, 1024)
	
	local noise_top_layer = minetest.get_perlin(654, 6, 0.5, 256)
	local noise_second_layer = minetest.get_perlin(123, 6, 0.5, 256)
	
	local noise_temperature = minetest.get_perlin(763, 6, 0.5, 256)
	local noise_humidity = minetest.get_perlin(834, 6, 0.5, 256)
	local noise_beach = minetest.get_perlin(452, 6, 0.5, 256)
	
	local data = vm:get_data()

	local c_air  = minetest.get_content_id("air")
	local c_grass  = minetest.get_content_id("default:dirt_with_grass")
	local c_dirt_snow  = minetest.get_content_id("default:dirt_with_snow")
	local c_snow  = minetest.get_content_id("default:snow")
	local c_sapling  = minetest.get_content_id("default:sapling")
	local c_jungle_sapling  = minetest.get_content_id("default:junglesapling")
	local c_dirt  = minetest.get_content_id("default:dirt")
	local c_stone  = minetest.get_content_id("default:stone")
	local c_water  = minetest.get_content_id("default:water_source")
	local c_ice  = minetest.get_content_id("default:ice")
	local c_sand  = minetest.get_content_id("default:sand")
	local c_sandstone  = minetest.get_content_id("default:sandstone")
	local c_desert_sand  = minetest.get_content_id("default:desert_sand")
	local c_desert_stone  = minetest.get_content_id("default:desert_stone")

	local ni = 1
	local above_top
	local liquid_top
	local top
	local top_layer
	local second_layer
	local humidity
	local temperature
	for z = minp.z, maxp.z do
	for x = minp.x, maxp.x do
		local y=math.floor(smooth_surface(x, z, noise1, noise2, noise3, noise4))
		humidity = noise_humidity:get2d({x=x,y=z})
		temperature = noise_temperature:get2d({x=x,y=z}) - math.max(y, 0)/50
		if y < -1 then
			above_top = c_air
			top = c_dirt
			top_layer = c_dirt
			second_layer = c_stone
			if temperature<-0.4 then
				liquid_top = c_ice
			else
				liquid_top = c_water
			end
		elseif y < 3 and noise_beach:get2d({x=x, y=z})<0.2 then
			if temperature<-0.4 then
				above_top = c_snow
			else
				above_top = c_air
			end
			top = c_sand
			top_layer = c_sand
			second_layer = c_sandstone
			if temperature<-0.4 then
				liquid_top = c_ice
			else
				liquid_top = c_water
			end
		else
			if temperature>0.4 then
				if humidity<-0.4 then
					above_top = c_air
					top = c_desert_sand
					top_layer = c_desert_sand
					second_layer = c_desert_stone
				elseif humidity<0.4 then
					above_top = c_air
					top = c_grass
					top_layer = c_dirt
					second_layer = c_stone
				else
					if pr:next(1, 10) == 1 then
						above_top = c_sapling
					elseif pr:next(1, 10) == 1 then
						above_top = c_jungle_sapling
					else
						above_top = c_air
					end
					top = c_grass
					top_layer = c_dirt
					second_layer = c_stone
				end
			elseif temperature<-0.4 then
				above_top = c_snow
				top = c_dirt_snow
				top_layer = c_dirt
				second_layer = c_stone
			else
				if humidity<-0.4 then
					above_top = c_air
				elseif humidity>0.4 then
					above_top = c_air
				else
					if pr:next(1, 20) == 1 then
						above_top = c_sapling
					else
						above_top = c_air
					end
				end
				top = c_grass
				top_layer = c_dirt
				second_layer = c_stone
			end
		end
		if y<=maxp.y and y>=minp.y then
        		local vi = a:index(x, y, z)
        		data[vi] = top
		end
		if y+1<=maxp.y and y+1>=minp.y then
        		local vi = a:index(x, y+1, z)
        		data[vi] = above_top
		end
		if y<0 and minp.y<=0 and maxp.y>y then
			for yy = math.max(y+1, minp.y), math.min(0, maxp.y) do
				local vi = a:index(x, yy, z)
				data[vi] = c_water
			end
			if maxp.y>=0 then
				data[a:index(x, 0, z)] = liquid_top
			end
		end
		local tl = math.floor((noise_top_layer:get2d({x=x,y=z})+2.5)*2)
		if y-tl-1<=maxp.y and y-1>=minp.y then
			for yy = math.max(y-tl-1, minp.y), math.min(y-1, maxp.y) do
				local vi = a:index(x, yy, z)
				data[vi] = top_layer
			end
		end
		local sl = math.floor((noise_second_layer:get2d({x=x,y=z})+5)*3)
		if y-sl-1<=maxp.y and y-tl-2>=minp.y then
			for yy = math.max(y-sl-1, minp.y), math.min(y-tl-2, maxp.y) do
				local vi = a:index(x, yy, z)
				data[vi] = second_layer
			end
		end
		if y-sl-2>=minp.y then
			for yy = minp.y, math.min(y-sl-2, maxp.y) do
				local vi = a:index(x, yy, z)
				data[vi] = c_stone
			end
		end
	end
	end
        
	vm:set_data(data)
       
	vm:calc_lighting(
		{x=minp.x-16, y=minp.y, z=minp.z-16},
		{x=maxp.x+16, y=maxp.y, z=maxp.z+16}
	)
        
        vm:write_to_map(data)
end)
