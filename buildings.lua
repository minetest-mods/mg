local W = minetest.get_content_id("default:wood")
local WS = minetest.get_content_id("default:water_source")
local S = minetest.get_content_id("farming:soil_wet")
local WH = minetest.get_content_id("farming:wheat_8")
local CO = minetest.get_content_id("farming:cotton_8")
local A = minetest.get_content_id("air")
local I = minetest.get_content_id("ignore")
local G = minetest.get_content_id("default:glass")
local C = minetest.get_content_id("default:cobble")
local T = minetest.get_content_id("default:tree")
local WG = minetest.get_content_id("wool:grey")
local FW = minetest.get_content_id("default:fence_wood")
local WF = minetest.get_content_id("default:water_flowing")
local BS = minetest.get_content_id("default:bookshelf")
local SW = minetest.get_content_id("stairs:slab_wood")
local TRXM = {node={name="default:torch", param2=2}, rotation = "wallmounted"}
local TRXP = {node={name="default:torch", param2=3}, rotation = "wallmounted"}
local TRZM = {node={name="default:torch", param2=5}, rotation = "wallmounted"}
local TRZP = {node={name="default:torch", param2=4}, rotation = "wallmounted"}
local TRU = {node={name="default:torch", param2=1}}
local SWXP = {node={name="stairs:stair_wood", param2=3}, rotation = "facedir"}
local SWXM = {node={name="stairs:stair_wood", param2=1}, rotation = "facedir"}
local SWZP = {node={name="stairs:stair_wood", param2=0}, rotation = "facedir"}
local SWZM = {node={name="stairs:stair_wood", param2=2}, rotation = "facedir"}


local field_cotton = {
	{
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
	},
	{
		{CO, A, CO, CO, A, CO, CO, A, CO},
		{CO, A, CO, CO, A, CO, CO, A, CO},
		{CO, A, CO, CO, A, CO, CO, A, CO},
		{CO, A, CO, CO, A, CO, CO, A, CO},
		{CO, A, CO, CO, A, CO, CO, A, CO},
		{CO, A, CO, CO, A, CO, CO, A, CO},
		{CO, A, CO, CO, A, CO, CO, A, CO},
		{CO, A, CO, CO, A, CO, CO, A, CO},
		{CO, A, CO, CO, A, CO, CO, A, CO},
	},
}

local field = {
	{
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
		{S, WS, S, S, WS, S, S, WS, S},
	},
	{
		{WH, A, WH, WH, A, WH, WH, A, WH},
		{WH, A, WH, WH, A, WH, WH, A, WH},
		{WH, A, WH, WH, A, WH, WH, A, WH},
		{WH, A, WH, WH, A, WH, WH, A, WH},
		{WH, A, WH, WH, A, WH, WH, A, WH},
		{WH, A, WH, WH, A, WH, WH, A, WH},
		{WH, A, WH, WH, A, WH, WH, A, WH},
		{WH, A, WH, WH, A, WH, WH, A, WH},
		{WH, A, WH, WH, A, WH, WH, A, WH},
	},
}

local house = {
	{
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
	},
	{
		{T, W, W, A, W, W, T},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{T, W, W, W, W, W, T},
	},
	{
		{T, C, C, A, C, C, T},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{T, C, G, G, G, C, T},
	},
	{
		{T, C, C, C, C, C, T},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{T, C, G, G, G, C, T},
	},
	{
		{T, C, C, C, C, C, T},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{C, A, A, A, A, A, C},
		{T, C, C, C, C, C, T},
	},
	{
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
		{W, W, W, W, W, W, W},
	},
	{
		{  SW, SWXM, SWXM, SWXM, SWXM, SWXM,   SW},
		{SWZP,    W,    W,    W,    W,    W, SWZM},
		{SWZP,    W,    I,    I,    I,    W, SWZM},
		{SWZP,    W,    I,    I,    I,    W, SWZM},
		{SWZP,    W,    I,    I,    I,    W, SWZM},
		{SWZP,    W,    W,    W,    W,    W, SWZM},
		{  SW, SWXP, SWXP, SWXP, SWXP, SWXP,   SW},
	},
	{
		{I,    I,    I,    I,    I,    I, I},
		{I,   SW, SWXM, SWXM, SWXM,   SW, I},
		{I, SWZP,    W,    W,    W, SWZM, I},
		{I, SWZP,    W,    I,    W, SWZM, I},
		{I, SWZP,    W,    W,    W, SWZM, I},
		{I,   SW, SWXP, SWXP, SWXP,   SW, I},
		{I,    I,    I,    I,    I,    I, I},
	},
	{
		{I, I,    I,    I,    I, I, I},
		{I, I,    I,    I,    I, I, I},
		{I, I,   SW, SWXM,   SW, I, I},
		{I, I, SWZP,    W, SWZM, I, I},
		{I, I,   SW, SWXP,   SW, I, I},
		{I, I,    I,    I,    I, I, I},
		{I, I,    I,    I,    I, I, I},
	},
}

local lamp = {
	{
		{I,  I, I},
		{I, FW, I},
		{I,  I, I},
	},
	{
		{I,  I, I},
		{I, FW, I},
		{I,  I, I},
	},
	{
		{I,  I, I},
		{I, FW, I},
		{I,  I, I},
	},
	{
		{   I, TRXM,    I},
		{TRZP,   WG, TRZM},
		{   I, TRXP,    I},
	},
}

local well = {
	{
		{C, C, C, C},
		{C, C, C, C},
		{C, C, C, C},
		{C, C, C, C},
	},
	{
		{C,  C,  C, C},
		{C, WS, WS, C},
		{C, WS, WS, C},
		{C,  C,  C, C},
	},
	{
		{C,  C,  C, C},
		{C, WS, WS, C},
		{C, WS, WS, C},
		{C,  C,  C, C},
	},
	{
		{C,  C,  C, C},
		{C, WS, WS, C},
		{C, WS, WS, C},
		{C,  C,  C, C},
	},
	{
		{C,  C,  C, C},
		{C, WS, WS, C},
		{C, WS, WS, C},
		{C,  C,  C, C},
	},
	{
		{C,  C,  C, C},
		{C, WS, WS, C},
		{C, WS, WS, C},
		{C,  C,  C, C},
	},
	{
		{C, C, C, C},
		{C, A, A, C},
		{C, A, A, C},
		{C, C, C, C},
	},
	{
		{FW, A, A, FW},
		{ A, A, A,  A},
		{ A, A, A,  A},
		{FW, A, A, FW},
	},
	{
		{FW, A, A, FW},
		{ A, A, A,  A},
		{ A, A, A,  A},
		{FW, A, A, FW},
	},
	{
		{FW, A, A, FW},
		{ A, A, A,  A},
		{ A, A, A,  A},
		{FW, A, A, FW},
	},
	{
		{C, C, C, C},
		{C, C, C, C},
		{C, C, C, C},
		{C, C, C, C},
	},
}

local smallhouse = {
	{
		{C, C, C, C, C},
		{C, C, C, C, C},
		{C, C, C, C, C},
		{C, C, C, C, C},
		{C, C, C, C, C},
	},
	{
		{T, W, W, W, T},
		{W, A, A, A, W},
		{W, A, A, A, W},
		{W, A, A, A, W},
		{T, W, A, W, T},
	},
	{
		{T, W, W, W, T},
		{W, A, A, A, W},
		{G, A, A, A, G},
		{W, A, A, A, W},
		{T, W, A, W, T},
	},
	{
		{W, W, W, W, W},
		{W, A, A, A, W},
		{W, A, A, A, W},
		{W, A, A, A, W},
		{W, W, W, W, W},
	},
	{
		{  SW, SWXM, SWXM, SWXM,   SW},
		{SWZP,    W,    W,    W, SWZM},
		{SWZP,    W,    A,    W, SWZM},
		{SWZP,    W,    W,    W, SWZM},
		{  SW, SWXP, SWXP, SWXP,   SW},
	},
	{
		{I,    I,    I,    I, I},
		{I,   SW, SWXM,   SW, I},
		{I, SWZP,    W, SWZM, I},
		{I,   SW, SWXP,   SW, I},
		{I,    I,    I,    I, I},
	},
}

local house_w_garden = {
	{
		{FW, FW,   FW, FW,   FW, FW},
		{FW,  I,    I,  I,    I, FW},
		{FW,  I,    I,  I,    I, FW},
		{FW,  I,    I,  I,    I, FW},
		{FW,  I,    I,  I,    I, FW},
		{FW,  I,    I,  I, SWXM, FW},
		{ C,  C,    C,  C,    C,  C},
		{ C,  C,    C,  C,    C,  C},
		{ C,  C,    C,  C,    C,  C},
		{ C,  C,    C,  C,    C,  C},
		{ C,  C,    C,  C,    C,  C},
		{ C,  C,    C,  C,    C,  C},
		{ I,  I, SWXP,  I,    I,  I},
	},
	{
		{  I,    I,    I, I, I,   I},
		{  I,    I,    I, I, I,   I},
		{  I,    I,    I, I, I,   I},
		{  I,    I,    I, I, I,   I},
		{  I,    I,    I, I, I,   I},
		{TRU,    I,    I, I, I, TRU},
		{  T,    W,    W, W, A,   T},
		{  W,   BS, SWXP, A, A,   W},
		{  W, SWZM,    A, A, A,   W},
		{  W,    A,    A, A, A,   W},
		{  W,    A,    A, A, A,   W},
		{  T,    W,    A, W, W,   T},
		{  I,    I,    I, I, I,   I},
	},
	{
		{I,   I, I, I, I, I},
		{I,   I, I, I, I, I},
		{I,   I, I, I, I, I},
		{I,   I, I, I, I, I},
		{I,   I, I, I, I, I},
		{I,   I, I, I, I, I},
		{T,   W, G, W, A, T},
		{W, TRU, A, A, A, W},
		{W,   A, A, A, A, G},
		{W,   A, A, A, A, G},
		{W,   A, A, A, A, W},
		{T,   W, A, W, W, T},
		{I,   I, I, I, I, I},
	},
	{
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{T, W, W, W, W, T},
		{W, A, A, A, A, W},
		{W, A, A, A, A, W},
		{W, A, A, A, A, W},
		{W, A, A, A, A, W},
		{T, W, W, W, W, T},
		{I, I, I, I, I, I},
	},
	{
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{T, W, W, W, W, T},
		{W, A, A, A, A, W},
		{W, A, A, A, A, W},
		{W, A, A, A, A, W},
		{W, A, A, A, A, W},
		{T, W, W, W, W, T},
		{I, I, I, I, I, I},
	},
	{
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{SW, SWXM, SWXM, SWXM, SWXM, SW},
		{SWZP, W, W, W, W, SWZM},
		{SWZP, W, A, A, W, SWZM},
		{SWZP, W, A, A, W, SWZM},
		{SWZP, W, W, W, W, SWZM},
		{SW, SWXP, SWXP, SWXP, SWXP, SW},
		{I, I, I, I, I, I},
	},
	{
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
		{I, SW, SWXM, SWXM, SW, I},
		{I, SWZP, W, W, SWZM, I},
		{I, SWZP, W, W, SWZM, I},
		{I, SW, SWXP, SWXP, SW, I},
		{I, I, I, I, I, I},
		{I, I, I, I, I, I},
	},
}

buildings = {
	{sizex= 7, sizez= 7, yoff= 0, ysize= 9, scm=house, orients={0}},
	{sizex= 9, sizez= 9, yoff= 0, ysize= 2, scm=field},
	{sizex= 9, sizez= 9, yoff= 0, ysize= 2, scm=field_cotton},
	{sizex= 3, sizez= 3, yoff= 1, ysize= 4, scm=lamp, weight=1/5, no_rotate=true},
	{sizex= 4, sizez= 4, yoff=-5, ysize=11, scm=well, no_rotate=true, pervillage=1},
	{sizex= 7, sizez= 7, yoff= 0, ysize=11, scm="fountain", weight=1/4, pervillage=3},
	{sizex= 5, sizez= 5, yoff= 0, ysize= 6, scm=smallhouse, orients={2}},
	{sizex=13, sizez= 6, yoff= 1, ysize= 7, scm=house_w_garden, orients={2}},
	{sizex=16, sizez=17, yoff= 0, ysize=12, scm="church", orients={3}, pervillage=1, force_air=true},
	{sizex= 6, sizez= 5, yoff= 1, ysize=16, scm="tower", orients={0}, weight=1/7},
	{sizex= 9, sizez= 9, yoff= 1, ysize= 6, scm="forge", orients={0}, pervillage=2},
	{sizex=11, sizez=13, yoff= 1, ysize= 6, scm="library", orients={1}, pervillage=2},
	{sizex=15, sizez= 7, yoff= 0, ysize=12, scm="inn", orients={1}, force_air=true},
}

local gravel = minetest.get_content_id("default:gravel")
local rgravel = {}
for i = 1, 200 do
	rgravel[i] = gravel
end
local rgravel2 = {}
for i = 1, 200 do
	rgravel2[i] = rgravel
end
local rair = {}
for i = 1, 200 do
	rair[i] = A
end
local rair2 = {}
for i = 1, 200 do
	rair2[i] = rair
end
local road_scm = {rgravel2, rair2}
buildings["road"] = {yoff = 0, ysize = 2, scm = road_scm}

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
