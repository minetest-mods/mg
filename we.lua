local function import_scm(scm)
	local f, err = io.open(minetest.get_modpath("mg").."/schems/"..scm..".we", "r")
	if not f then
		error("Could not open schematic '" .. scm .. ".we': " .. err)
	end
	value = f:read("*a")
	f:close()
	value = value:gsub("return%s*{", "", 1):gsub("}%s*$", "", 1)
	local escaped = value:gsub("\\\\", "@@"):gsub("\\\"", "@@"):gsub("(\"[^\"]*\")", function(s) return string.rep("@", #s) end)
	local startpos, startpos1, endpos = 1, 1
	local nodes = {}
	while true do
		startpos, endpos = escaped:find("},%s*{", startpos)
		if not startpos then
			break
		end
		local current = value:sub(startpos1, startpos)
		table.insert(nodes, minetest.deserialize("return " .. current))
		startpos, startpos1 = endpos, endpos
	end
	table.insert(nodes, minetest.deserialize("return " .. value:sub(startpos1)))
	scm = {}
	local maxx, maxy, maxz = -1, -1, -1
	for i = 1, #nodes do
		local ent = nodes[i]
		if ent.x > maxx then
			maxx = ent.x
		end
		if ent.y > maxy then
			maxy = ent.y
		end
		if ent.z > maxz then
			maxz = ent.z
		end
		if scm[ent.y] == nil then
			scm[ent.y] = {}
		end
		if scm[ent.y][ent.x] == nil then
			scm[ent.y][ent.x] = {}
		end
		if ent.param2 == nil then
			ent.param2 = 0
		end
		if ent.meta == nil then
			ent.meta = {fields={}, inventory={}}
		end
		if ent.param2 == 0 and #ent.meta.fields == 0 and #ent.meta.inventory == 0 then
			scm[ent.y][ent.x][ent.z] = minetest.get_content_id(ent.name)
		else
			scm[ent.y][ent.x][ent.z] = {node={name=ent.name, param2=ent.param2}, meta=ent.meta}
		end
	end
	local c_ignore = minetest.get_content_id("ignore")
	for x = 1, maxx do
		for y = 1, maxy do
			for z = 1, maxz do
				if scm[y] == nil then
					scm[y] = {}
				end
				if scm[y][x] == nil then
					scm[y][y] = {}
				end
				if scm[y][x][z] == nil then
					scm[y][x][z] = c_ignore
				end
			end
		end
	end
	return scm
end
