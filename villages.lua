function village_at_point(minp)
	local bseed
	for xi = -2, 2 do
	for zi = -2, 0 do
		if xi~=0 or zi~=0 then
			local pi = PseudoRandom(get_bseed({x=minp.x+80*xi, z=minp.z+80*zi})) 
			if pi:next(1,400)<=10 then return 0,0,0,0 end
		end
	end
	end
	local pr = PseudoRandom(get_bseed(minp))
	if pr:next(1,400)>10 then return 0,0,0,0 end
	local x = pr:next(minp.x, minp.x+79)
	local z = pr:next(minp.z, minp.z+79)
	local size = pr:next(20, 40)
	local height = pr:next(5, 20)
	print("A village spawned at: x="..x..", z="..z)
	return x,z,size,height
end

local function dist_center2(ax, bsizex, az, bsizez)
	return math.max((ax+bsizex)*(ax+bsizex),(ax-bsizex)*(ax-bsizex))+math.max((az+bsizez)*(az+bsizez),(az-bsizez)*(az-bsizez))
end

local function generate_bpos(vx, vz, vs, vh, pr)
	local l={}
	for i=1, 100 do
		bx = pr:next(vx-vs, vx+vs)
		bz = pr:next(vz-vs, vz+vs)
		::choose::
		btype = pr:next(1, #buildings)
		if buildings[btype].chance ~= nil then
			if pr:next(1, buildings[btype].chance) ~= 1 then
				goto choose
			end
		end
		bsizex = buildings[btype].sizex
		bsizez = buildings[btype].sizez
		if dist_center2(bx-vx, bsizex, bz-vz, bsizez)>vs*vs then goto out end
		for _, a in ipairs(l) do
			if math.abs(bx-a.x)<=bsizex+a.bsizex+2 and math.abs(bz-a.z)<=bsizez+a.bsizez+2 then goto out end
		end
		l[#l+1] = {x=bx, y=vh, z=bz, btype=btype, bsizex=bsizex, bsizez=bsizez}
		::out::
	end
	return l
end

local function generate_building(pos, minp, maxp, data, a, pr, extranodes)
	local binfo = buildings[pos.btype]
	if binfo.no_rotate == nil then
		rot = pr:next(1, 2)
		if rot == 1 then
			pfunc = function(x,y,z) return x,y,z end
		elseif rot == 2 then
			pfunc = function(x,y,z) return z,y,x end
		end
	else
		pfunc = function(x,y,z) return x,y,z end
	end
	local scm = binfo.scm
	local minx = pos.x-pos.bsizex-1
	local miny = pos.y+binfo.ymin-1
	local minz = pos.z-pos.bsizez-1
	local xx, yy, zz
	local t
	for x = math.max(pos.x-pos.bsizex, minp.x), math.min(pos.x+pos.bsizex, maxp.x) do
	for y = math.max(pos.y+binfo.ymin, minp.y), math.min(pos.y+binfo.ymax, maxp.y) do
	for z = math.max(pos.z-pos.bsizez, minp.z), math.min(pos.z+pos.bsizez, maxp.z) do
		xx, yy, zz = pfunc(x-minx, y-miny, z-minz)
		t = scm[yy][xx][zz]
		if type(t) == "table" then
			table.insert(extranodes, {node=t.node, meta=t.meta, pos={x=x, y=y, z=z},})
		else
			data[a:index(x,y,z)] = t
		end
	end
	end
	end
end

function generate_village(vx, vz, vs, vh, minp, maxp, data, a)
	local seed = get_bseed({x=vx, z=vz})
	local pr = PseudoRandom(seed)
	local bpos = generate_bpos(vx, vz, vs, vh, pr)
	local extranodes = {}
	for _, pos in ipairs(bpos) do
		generate_building(pos, minp, maxp, data, a, pr, extranodes)
	end
	return extranodes
end
