function deepcopy(orig)
    return minetest.deserialize(minetest.serialize(orig))
end

function rotate_facedir(facedir)
	return ({1, 2, 3, 0,
		13, 14, 15, 12,
		17, 18, 19, 16,
		9, 10, 11, 8,
		5, 6, 7, 4,
		21, 22, 23, 20})[facedir+1]
end

function rotate_wallmounted(wallmounted)
	return ({0, 1, 5, 4, 2, 3})[wallmounted+1]
end

function rotate_scm(scm)
	local ysize = #scm
	local xsize = #scm[1]
	local zsize = #scm[1][1]
	new_scm = {}
	for i=1, ysize do
		new_scm[i] = {}
		for j=1, zsize do
			new_scm[i][j] = {}
		end
	end
	
	for y = 1, ysize do
	for x = 1, xsize do
	for z = 1, zsize do
		local old = scm[y][x][z]
		local newx = z
		local newz = xsize-x+1
		if type(old) ~= "table" or old.rotation == nil then
			new_scm[y][newx][newz] = old
		elseif old.rotation == "wallmounted" then
			new = deepcopy(old)
			new.node.param2 = rotate_wallmounted(new.node.param2)
			new_scm[y][newx][newz] = new
		elseif old.rotation == "facedir" then
			new = deepcopy(old)
			new.node.param2 = rotate_facedir(new.node.param2)
			new_scm[y][newx][newz] = new
		end
	end
	end
	end
	return new_scm
end

function rotate(scm, times)
	for i=1, times do
		scm = rotate_scm(scm)
	end
	return scm
end
