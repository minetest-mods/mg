buildings = {
	{sizex= 7,	sizez= 7,	yoff= 0,	ysize= 9,	scm="house", orients={2}},
	{sizex= 9,	sizez= 9,	yoff= 0,	ysize= 2,	scm="wheat_field"},
	{sizex= 9,	sizez= 9,	yoff= 0,	ysize= 2,	scm="cotton_field"},
	{sizex= 3,	sizez= 3,	yoff= 1,	ysize= 4,	scm="lamp", weight=1/5, no_rotate=true},
	{sizex= 4,	sizez= 4,	yoff=-5,	ysize=11,	scm="well", no_rotate=true, pervillage=1},
	{sizex= 7,	sizez= 7,	yoff= 0,	ysize=11,	scm="fountain", weight=1/4, pervillage=3},
	{sizex= 5,	sizez= 5,	yoff= 0,	ysize= 6,	scm="small_house", orients={3}},
	{sizex= 6,	sizez=12,	yoff= 0,	ysize= 7,	scm="house_with_garden", orients={1}},
	{sizex=16,	sizez=17,	yoff= 0,	ysize=12,	scm="church", orients={3}, pervillage=1},
	{sizex= 5,	sizez= 5,	yoff= 0,	ysize=16,	scm="tower", orients={0}, weight=1/7},
	{sizex= 8,	sizez= 9,	yoff= 0,	ysize= 6,	scm="forge", orients={0}, pervillage=2},
	{sizex=11,	sizez=12,	yoff= 0,	ysize= 6,	scm="library", orients={1}, pervillage=2},
	{sizex=15,	sizez= 7,	yoff= 0,	ysize=12,	scm="inn", orients={1}, pervillage=4, weight=1/2},
	{sizex=22,	sizez=17,	yoff= 0,	ysize= 7,	scm="pub", orients={3}, pervillage=2, weight=1/3},
}

local gravel = minetest.get_content_id("default:gravel")
local rgravel = {}
for i = 1, 2000 do
	rgravel[i] = gravel
end
local rgravel2 = {}
for i = 1, 2000 do
	rgravel2[i] = rgravel
end
local rair = {}
for i = 1, 2000 do
	rair[i] = c_air
end
local rair2 = {}
for i = 1, 2000 do
	rair2[i] = rair
end
local road_scm = {rgravel2, rair2}
buildings["road"] = {yoff = 0, ysize = 2, scm = road_scm}

local rwall = {{minetest.get_content_id("default:stonebrick")}}
local wall = {}
for i = 1, 6 do
	wall[i] = rwall
end
buildings["wall"] = {yoff = 1, ysize = 6, scm = wall}


local total_weight = 0
for _, i in ipairs(buildings) do
	if i.weight == nil then i.weight = 1 end
	total_weight = total_weight+i.weight
	i.max_weight = total_weight
end
local multiplier = 3000/total_weight
for _,i in ipairs(buildings) do
	i.max_weight = i.max_weight*multiplier
end
