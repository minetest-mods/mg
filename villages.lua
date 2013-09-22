function village_at_point(minp, noise1)
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
	if noise1:get2d({x=x, y=z})<0 then return 0,0,0,0 end
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
		if buildings[btype].pervillage ~= nil then
			local n = 0
			for j=1, #l do
				if l[j].btype == btype then
					n = n + 1
				end
			end
			if n >= buildings[btype].pervillage then
				goto choose
			end
		end
		bsizex = buildings[btype].sizex
		bsizez = buildings[btype].sizez
		if dist_center2(bx-vx, bsizex, bz-vz, bsizez)>vs*vs then goto out end
		for _, a in ipairs(l) do
			if math.abs(bx-a.x)<=(bsizex+a.bsizex)/2+2 and math.abs(bz-a.z)<=(bsizez+a.bsizez)/2+2 then goto out end
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
	local xx, yy, zz
	local t
	for x = 0, pos.bsizex-1 do
	for y = 0, binfo.ysize-1 do
	for z = 0, pos.bsizez-1 do
		ax, ay, az = pos.x+x, pos.y+y+binfo.yoff, pos.z+z
		if (ax >= minp.x and ax <= maxp.x) and (ay >= minp.y and ay <= maxp.y) and (az >= minp.z and az <= maxp.z) then
			xx, yy, zz = pfunc(x+1, y+1, z+1)
			t = scm[yy][xx][zz]
			if type(t) == "table" then
				table.insert(extranodes, {node=t.node, meta=t.meta, pos={x=ax, y=ay, z=az},})
			else
				data[a:index(ax, ay, az)] = t
			end
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
