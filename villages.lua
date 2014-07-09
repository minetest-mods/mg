VILLAGE_CHECK_RADIUS = 2
VILLAGE_CHECK_COUNT = 1
VILLAGE_CHANCE = 28
VILLAGE_MIN_SIZE = 20
VILLAGE_MAX_SIZE = 40
FIRST_ROADSIZE = 3
BIG_ROAD_CHANCE = 0

-- Enable that for really big villages (there are also really slow to generate)
--[[VILLAGE_CHECK_RADIUS = 3
VILLAGE_CHECK_COUNT = 3
VILLAGE_CHANCE = 28
VILLAGE_MIN_SIZE = 100
VILLAGE_MAX_SIZE = 150
FIRST_ROADSIZE = 5
BIG_ROAD_CHANCE = 50]]

local function is_village_block(minp)
	local x, z = math.floor(minp.x/80), math.floor(minp.z/80)
	local vcc = VILLAGE_CHECK_COUNT
	return (x%vcc == 0) and (z%vcc == 0)
end

function villages_at_point(minp, noise1)
	if not is_village_block(minp) then return {} end
	local vcr, vcc = VILLAGE_CHECK_RADIUS, VILLAGE_CHECK_COUNT
	-- Check if there's another village nearby
	for xi = -vcr, vcr, vcc do
	for zi = -vcr, 0, vcc do
		if xi ~= 0 or zi ~= 0 then
			local mp = {x = minp.x + 80*xi, z = minp.z + 80*zi}
			local pi = PseudoRandom(get_bseed(mp))
			local s = pi:next(1, 400)
			local x = pi:next(mp.x, mp.x + 79)
			local z = pi:next(mp.z, mp.z + 79)
			if s <= VILLAGE_CHANCE and noise1:get2d({x = x, y = z}) >= -0.3 then return {} end
		end
	end
	end
	local pr = PseudoRandom(get_bseed(minp))
	if pr:next(1, 400) > VILLAGE_CHANCE then return {} end -- No village here
	local x = pr:next(minp.x, minp.x + 79)
	local z = pr:next(minp.z, minp.z + 79)
	if noise1:get2d({x = x, y = z}) < -0.3 then return {} end -- Deep in the ocean
	local type = pr:next(1, 1) -- TODO: actually make them
	local size = pr:next(VILLAGE_MIN_SIZE, VILLAGE_MAX_SIZE) -- TODO: change to type-dependant sizes
	local height = pr:next(5, 20)
	--print("A village spawned at: x = "..x..", z = "..z)
	return {{vx = x, vz = z, vs = size, vh = height, type = type}}
end

--local function dist_center2(ax, bsizex, az, bsizez)
--	return math.max((ax+bsizex)*(ax+bsizex),ax*ax)+math.max((az+bsizez)*(az+bsizez),az*az)
--end

local function inside_village2(bx, sx, bz, sz, village, vnoise)
	return inside_village(bx, bz, village, vnoise) and inside_village(bx+sx, bz, village, vnoise) and inside_village(bx, bz+sz, village, vnoise) and inside_village(bx+sx, bz+sz, village, vnoise)
end

local function choose_building(l, pr)
	--::choose::
	local btype
	while true do
		local p = pr:next(1, 3000)
		for b, i in ipairs(buildings) do
			if i.max_weight >= p then
				btype = b
				break
			end
		end
		if buildings[btype].pervillage ~= nil then
			local n = 0
			for j=1, #l do
				if l[j].btype == btype then
					n = n + 1
				end
			end
			--if n >= buildings[btype].pervillage then
			--	goto choose
			--end
			if n < buildings[btype].pervillage then
				return btype
			end
		else
			return btype
		end
	end
	--return btype
end

local function choose_building_rot(l, pr, orient)
	local btype = choose_building(l, pr)
	local rotation
	if buildings[btype].no_rotate then
		rotation = 0
	else
		if buildings[btype].orients == nil then
			buildings[btype].orients = {0,1,2,3}
		end
		rotation = (orient+buildings[btype].orients[pr:next(1, #buildings[btype].orients)])%4
	end
	local bsizex = buildings[btype].sizex
	local bsizez = buildings[btype].sizez
	if rotation%2 == 1 then
		bsizex, bsizez = bsizez, bsizex
	end
	return btype, rotation, bsizex, bsizez
end

local function placeable(bx, bz, bsizex, bsizez, l, exclude_roads)
	for _, a in ipairs(l) do
		if (a.btype ~= "road" or not exclude_roads) and math.abs(bx+bsizex/2-a.x-a.bsizex/2)<=(bsizex+a.bsizex)/2 and math.abs(bz+bsizez/2-a.z-a.bsizez/2)<=(bsizez+a.bsizez)/2 then return false end
	end
	return true
end

local function road_in_building(rx, rz, rdx, rdz, roadsize, l)
	if rdx == 0 then
		return not placeable(rx-roadsize+1, rz, 2*roadsize-2, 0, l, true)
	else
		return not placeable(rx, rz-roadsize+1, 0, 2*roadsize-2, l, true)
	end
end

local function when(a, b, c)
	if a then return b else return c end
end

local function generate_road(village, l, pr, roadsize, rx, rz, rdx, rdz, vnoise)
	local vx, vz, vh, vs = village.vx, village.vz, village.vh, village.vs
	local calls_to_do = {}
	local rxx = rx
	local rzz = rz
	local mx, m2x, mz, m2z, mmx, mmz
	mx, m2x, mz, m2z = rx, rx, rz, rz
	local orient1, orient2
	if rdx == 0 then
		orient1 = 0
		orient2 = 2
	else
		orient1 = 3
		orient2 = 1
	end
	while inside_village(rx, rz, village, vnoise) and not road_in_building(rx, rz, rdx, rdz, roadsize, l) do
		if roadsize > 1 and pr:next(1, 4) == 1 then
			--generate_road(vx, vz, vs, vh, l, pr, roadsize-1, rx, rz, math.abs(rdz), math.abs(rdx))
			calls_to_do[#calls_to_do+1] = {rx=rx+(roadsize - 1)*rdx, rz=rz+(roadsize - 1)*rdz, rdx=math.abs(rdz), rdz=math.abs(rdx)}
			m2x = rx + (roadsize - 1)*rdx
			m2z = rz + (roadsize - 1)*rdz
			rx = rx + (2*roadsize - 1)*rdx
			rz = rz + (2*roadsize - 1)*rdz
		end
		--else
			--::loop::
			local exitloop = false
			local bx
			local bz
			local tries = 0
			while true do
				if not inside_village(rx, rz, village, vnoise) or road_in_building(rx, rz, rdx, rdz, roadsize, l) then
					exitloop = true
					break
				end
				btype, rotation, bsizex, bsizez = choose_building_rot(l, pr, orient1)
				bx = rx + math.abs(rdz)*(roadsize+1) - when(rdx==-1, bsizex-1, 0)
				bz = rz + math.abs(rdx)*(roadsize+1) - when(rdz==-1, bsizez-1, 0)
				if placeable(bx, bz, bsizex, bsizez, l) and inside_village2(bx, bsizex, bz, bsizez, village, vnoise) then
					break
				end
				if tries > 5 then
					rx = rx + rdx
					rz = rz + rdz
					tries = 0
				else
					tries = tries + 1
				end
				--goto loop
			end
			if exitloop then break end
			rx = rx + (bsizex+1)*rdx
			rz = rz + (bsizez+1)*rdz
			mx = rx - 2*rdx
			mz = rz - 2*rdz
			l[#l+1] = {x=bx, y=vh, z=bz, btype=btype, bsizex=bsizex, bsizez=bsizez, brotate = rotation}
		--end
	end
	rx = rxx
	rz = rzz
	while inside_village(rx, rz, village, vnoise) and not road_in_building(rx, rz, rdx, rdz, roadsize, l) do
		if roadsize > 1 and pr:next(1, 4) == 1 then
			--generate_road(vx, vz, vs, vh, l, pr, roadsize-1, rx, rz, -math.abs(rdz), -math.abs(rdx))
			calls_to_do[#calls_to_do+1] = {rx=rx+(roadsize - 1)*rdx, rz=rz+(roadsize - 1)*rdz, rdx=-math.abs(rdz), rdz=-math.abs(rdx)}
			m2x = rx + (roadsize - 1)*rdx
			m2z = rz + (roadsize - 1)*rdz
			rx = rx + (2*roadsize - 1)*rdx
			rz = rz + (2*roadsize - 1)*rdz
		end
		--else
			--::loop::
			local exitloop = false
			local bx
			local bz
			local tries = 0
			while true do
				if not inside_village(rx, rz, village, vnoise) or road_in_building(rx, rz, rdx, rdz, roadsize, l) then
					exitloop = true
					break
				end
				btype, rotation, bsizex, bsizez = choose_building_rot(l, pr, orient2)
				bx = rx - math.abs(rdz)*(bsizex+roadsize) - when(rdx==-1, bsizex-1, 0)
				bz = rz - math.abs(rdx)*(bsizez+roadsize) - when(rdz==-1, bsizez-1, 0)
				if placeable(bx, bz, bsizex, bsizez, l) and inside_village2(bx, bsizex, bz, bsizez, village, vnoise) then
					break
				end
				if tries > 5 then
					rx = rx + rdx
					rz = rz + rdz
					tries = 0
				else
					tries = tries + 1
				end
				--goto loop
			end
			if exitloop then break end
			rx = rx + (bsizex+1)*rdx
			rz = rz + (bsizez+1)*rdz
			m2x = rx - 2*rdx
			m2z = rz - 2*rdz
			l[#l+1] = {x=bx, y=vh, z=bz, btype=btype, bsizex=bsizex, bsizez=bsizez, brotate = rotation}
		--end
	end
	if road_in_building(rx, rz, rdx, rdz, roadsize, l) then
		mmx = rx - 2*rdx
		mmz = rz - 2*rdz
	end
	mx = mmx or rdx*math.max(rdx*mx, rdx*m2x)
	mz = mmz or rdz*math.max(rdz*mz, rdz*m2z)
	if rdx == 0 then
		rxmin = rx - roadsize + 1
		rxmax = rx + roadsize - 1
		rzmin = math.min(rzz, mz)
		rzmax = math.max(rzz, mz)
	else
		rzmin = rz - roadsize + 1
		rzmax = rz + roadsize - 1
		rxmin = math.min(rxx, mx)
		rxmax = math.max(rxx, mx)
	end
	l[#l+1] = {x = rxmin, y = vh, z = rzmin, btype = "road",
		bsizex = rxmax - rxmin + 1, bsizez = rzmax - rzmin + 1, brotate = 0}
	for _, i in ipairs(calls_to_do) do
		local new_roadsize = roadsize - 1
		if pr:next(1, 100) <= BIG_ROAD_CHANCE then
			new_roadsize = roadsize
		end
		calls[calls.index] = {village, l, pr, new_roadsize, i.rx, i.rz, i.rdx, i.rdz, vnoise}
		calls.index = calls.index+1
	end
end

local function generate_bpos(village, pr, vnoise)
	local vx, vz, vh, vs = village.vx, village.vz, village.vh, village.vs
	local l = {}
	local rx = vx - vs
	local rz = vz
	while inside_village(rx, rz, village, vnoise) do
		rx = rx - 1
	end
	rx = rx + 5
	calls = {index = 1}
	generate_road(village, l, pr, FIRST_ROADSIZE, rx, rz, 1, 0, vnoise)
	i = 1
	while i < calls.index do
		generate_road(unpack(calls[i]))
		i = i+1
	end
	return l
end

local function generate_building(pos, minp, maxp, data, param2_data, a, pr, extranodes)
	local binfo = buildings[pos.btype]
	local scm
	if type(binfo.scm) == "string" then
		scm = import_scm(binfo.scm)
	else
		scm = binfo.scm
	end
	scm = rotate(scm, pos.brotate)
	local c_ignore = minetest.get_content_id("ignore")
	local c_air = minetest.get_content_id("air")
	for x = 0, pos.bsizex-1 do
	for y = 0, binfo.ysize-1 do
	for z = 0, pos.bsizez-1 do
		ax, ay, az = pos.x+x, pos.y+y+binfo.yoff, pos.z+z
		if (ax >= minp.x and ax <= maxp.x) and (ay >= minp.y and ay <= maxp.y) and (az >= minp.z and az <= maxp.z) then
			local t = scm[y+1][x+1][z+1]
			if type(t) == "table" then
				if t.extranode then
					table.insert(extranodes, {node = t.node, meta = t.meta, pos = {x = ax, y = ay, z = az}})
				else
					data[a:index(ax, ay, az)] = t.node.content
					param2_data[a:index(ax, ay, az)] = t.node.param2
				end
			elseif t ~= c_ignore then
				data[a:index(ax, ay, az)] = t
			end
		end
	end
	end
	end
end

local MIN_DIST = 1

local function pos_far_buildings(x, z, l)
	for _, a in ipairs(l) do
		if a.x - MIN_DIST <= x and x <= a.x + a.bsizex + MIN_DIST and
		   a.z - MIN_DIST <= z and z <= a.z + a.bsizez + MIN_DIST then
			return false
		end
	end
	return true
end

function generate_village(village, minp, maxp, data, param2_data, a, vnoise)
	local vx, vz, vs, vh = village.vx, village.vz, village.vs, village.vh
	local seed = get_bseed({x=vx, z=vz})
	local pr_village = PseudoRandom(seed)
	local bpos = generate_bpos(village, pr_village, vnoise)

	local pr = PseudoRandom(seed)
	for _, g in ipairs(village.to_grow) do
		if pos_far_buildings(g.x, g.z, bpos) then
			mg.registered_trees[g.id].grow(data, a, g.x, g.y, g.z, minp, maxp, pr)
		end
	end

	local extranodes = {}
	for _, pos in ipairs(bpos) do
		generate_building(pos, minp, maxp, data, param2_data, a, pr_village, extranodes)
	end
	return extranodes
end
