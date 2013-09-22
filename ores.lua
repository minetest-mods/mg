function in_cuboid(pos, minp, maxp)
	return (pos.x>=minp.x and pos.y>= minp.y and pos.z>=minp.z and pos.x<=maxp.x and pos.y<=maxp.y and pos.z<=maxp.z)
end

function round_pos(p)
	return {x=math.floor(p.x+0.5),y=math.floor(p.y+0.5),z=math.floor(p.z+0.5)}
end

function draw_sphere(name, wherein, center, radius, data, a, insideva)
	local rad2=radius*radius
	radius = math.ceil(radius)
	pos0={}
	for x=-radius, radius do
	pos0.x=center.x+x
	for y=-radius, radius do
	pos0.y=center.y+y
	for z=-radius, radius do
		pos0.z=center.z+z
		if x*x+y*y+z*z<=rad2 and insideva:containsp(pos0) and ((wherein == c_ignore and data[a:indexp(pos0)] ~= c_water) or data[a:indexp(pos0)] == wherein) then
			data[a:indexp(pos0)] = name
		end
	end
	end
	end
end

function place_segment(name, wherein, pos1, pos2, minp, maxp, radius, data, a, insideva)
	local d={x=pos2.x-pos1.x, y=pos2.y-pos1.y, z=pos2.z-pos1.z}
	local N=math.max(math.abs(d.x),math.abs(d.y),math.abs(d.z))
	local s={x=d.x/N,y=d.y/N,z=d.z/N}
	local p=pos1
	draw_sphere(name,wherein,pos1,radius, data, a, insideva)
	for i=1,N do
		p={x=p.x+s.x,y=p.y+s.y,z=p.z+s.z}
		p0=round_pos(p)
		if not in_cuboid(p0, minp, maxp) then return end
		draw_sphere(name,wherein,p0,radius, data, a, insideva)
	end
end

function generate_vein_segment(name, wherein, minp, maxp, pr, pos, angle, rem_size, options, data, a, insideva)
	if rem_size<=0 then return end
	local Ln=options.seglenghtn
	local Ldev=options.seglenghtdev
	local L=pr:next(Ln-Ldev,Ln+Ldev)
	local incln=options.segincln*100
	local incldev=options.segincldev*100
	local incl=pr:next(incln-incldev,incln+incldev)/100
	local turnangle=options.turnangle
	local forkturnangle=options.forkturnangle
	local fork_chance=options.fork_chance*100
	local forkmultn=options.forkmultn*100
	local forkmultdev=options.forkmultdev*100
	local radius=options.radius
	
	local end_pos={x=pos.x+L*math.cos(angle), y=pos.y-L*incl, z=pos.z+L*math.sin(angle)}
	place_segment(name, wherein, round_pos(pos), round_pos(end_pos), minp, maxp, radius, data, a, insideva)
	if not in_cuboid(end_pos, minp, maxp) then return end
	local new_angle=(math.pi*pr:next(-turnangle,turnangle)/180)+angle
	generate_vein_segment(name, wherein, minp, maxp, pr, end_pos, new_angle, rem_size-L, options, data, a, insideva)
	local numforks=math.floor(fork_chance/100)+1
	fork_chance=fork_chance/numforks
	if pr:next(1,100)<=fork_chance then
		for f=1,numforks do
			local new_angle=(math.pi*pr:next(-forkturnangle,forkturnangle)/180)+angle
			local forkmult=pr:next(forkmultn-forkmultdev, forkmultn+forkmultdev)/100
			if forkmult>1 then forkmult=1 end
			generate_vein_segment(name, wherein, minp, maxp, pr, end_pos, new_angle, forkmult*(rem_size-L), options, data, a, insideva)
		end
	end
end

function generate_vein(name, wherein, minp, maxp, seeddiff, options, data, a, insideva, second_call)
	local seed = get_bseed2(minp)+seeddiff
	options=get_or_default(options)
	
	local numperblock=options.numperblock*1000
	local maxhdistance=options.maxhdistance
	local maxvdistance=options.maxvdistance
	local numbranchesn=options.numbranchesn
	local numbranchesdev=options.numbranchesdev
	local mothersizen=options.mothersizen*10
	local mothersizedev=options.mothersizedev*10
	local sizen=options.sizen
	local sizedev=options.sizedev
	
	if second_call==nil then
		local hblocks=math.floor(maxhdistance/80)+1
		local vblocks=math.floor(maxvdistance/80)+1
		for xblocksdiff=-hblocks,hblocks do
		for yblocksdiff=-vblocks,vblocks do
		for zblocksdiff=-hblocks,hblocks do
			if xblocksdiff~=0 or yblocksdiff~=0 or zblocksdiff~=0 then
				new_minp={x=minp.x+xblocksdiff*80,y=minp.y+yblocksdiff*80,z=minp.z+zblocksdiff*80}
				new_maxp={x=maxp.x+xblocksdiff*80,y=maxp.y+yblocksdiff*80,z=maxp.z+zblocksdiff*80}
				generate_vein(name, wherein, new_minp, new_maxp, seeddiff, options, data, a, insideva, true)
			end
		end
		end
		end
	end
	
	local pr = PseudoRandom(seed)
	
	local numveins=math.floor(numperblock/1000)
	numperblock=numperblock-1000*numveins
	if pr:next(1,1000)<=numperblock then
		numveins=numveins+1
	end
	if numveins>0 then
		local min_y=math.max(options.minheight,minp.y)
		local max_y=math.min(options.maxheight,maxp.y)
		if min_y>max_y then return end
		for v=1,numveins do
			local vein_pos={x=pr:next(minp.x,maxp.x),y=pr:next(min_y,max_y),z=pr:next(minp.z,maxp.z)}
			local numbranches=pr:next(numbranchesn-numbranchesdev,numbranchesn+numbranchesdev)
			local mothersize=pr:next(mothersizen-mothersizedev,mothersizen+mothersizedev)/10
			
			if mothersize>=0 then
				draw_sphere(name, wherein,vein_pos, mothersize, data, a, insideva)
			end
		
			local minpos = {x=vein_pos.x-maxhdistance,y=vein_pos.y-maxvdistance,z=vein_pos.z-maxhdistance}
			local maxpos = {x=vein_pos.x+maxhdistance,y=vein_pos.y+maxvdistance,z=vein_pos.z+maxhdistance}
			for i=1,numbranches do
				local start_angle=math.pi*pr:next(0,359)/180
				local size=pr:next(sizen-sizedev,sizen+sizedev)
				generate_vein_segment(name, wherein, minpos, maxpos, pr, vein_pos, start_angle, size, options, data, a, insideva)
			end
		end
	end
end

function get_or_default(options)
	if options.numperblock==nil then options.numperblock=0.3 end
	if options.maxhdistance==nil then options.maxhdistance=32 end
	if options.maxvdistance==nil then options.maxvdistance=32 end
	if options.numbranchesn==nil then options.numbranchesn=3 end
	if options.numbranchesdev==nil then options.numbranchesdev=2 end
	if options.mothersizen==nil then options.mothersizen=1 end
	if options.mothersizedev==nil then options.mothersizedev=0.5 end
	if options.sizen==nil then options.sizen=120 end
	if options.sizedev==nil then options.sizedev=60 end
	if options.seglenghtn==nil then options.seglenghtn=6 end
	if options.seglenghtdev==nil then options.seglenghtdev=2 end
	if options.segincln==nil then options.segincln=0.2 end
	if options.segincldev==nil then options.segincldev=0.1 end
	if options.turnangle==nil then options.turnangle=20 end
	if options.forkturnangle==nil then options.forkturnangle=90 end
	if options.fork_chance==nil then options.fork_chance=0.2 end
	if options.forkmultn==nil then options.forkmultn=0.75 end
	if options.forkmultdev==nil then options.forkmultdev=0.25 end
	if options.minheight==nil then options.minheight=-31000 end
	if options.maxheight==nil then options.maxheight=31000 end
	if options.radius==nil then options.radius=0 end
	return options
end
