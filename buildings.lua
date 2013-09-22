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
local TRXM = {node={name="default:torch", param2=2}}
local TRXP = {node={name="default:torch", param2=3}}
local TRZM = {node={name="default:torch", param2=5}}
local TRZP = {node={name="default:torch", param2=4}}
local TRU = {node={name="default:torch", param2=1}}
local WS_ = {node={name="default:water_source"}}

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
		{A, A, A, A, A, A, A},
		{A, W, W, W, W, W, A},
		{A, W, A, A, A, W, A},
		{A, W, A, A, A, W, A},
		{A, W, A, A, A, W, A},
		{A, W, W, W, W, W, A},
		{A, A, A, A, A, A, A},
	},
	{
		{A, A, A, A, A, A, A},
		{A, A, A, A, A, A, A},
		{A, A, W, W, W, A, A},
		{A, A, W, A, W, A, A},
		{A, A, W, W, W, A, A},
		{A, A, A, A, A, A, A},
		{A, A, A, A, A, A, A},
	},
	{
		{A, A, A, A, A, A, A},
		{A, A, A, A, A, A, A},
		{A, A, A, A, A, A, A},
		{A, A, A, W, A, A, A},
		{A, A, A, A, A, A, A},
		{A, A, A, A, A, A, A},
		{A, A, A, A, A, A, A},
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

local fountain = {
	{
		{C, C, C, C, C},
		{C, C, C, C, C},
		{C, C, C, C, C},
		{C, C, C, C, C},
		{C, C, C, C, C},
	},
	{
		{C, C, C, C, C},
		{C, A, A, A, C},
		{C, A, W, A, C},
		{C, A, A, A, C},
		{C, C, C, C, C},
	},
	{
		{TRU, A, A, A, TRU},
		{  A, A, A, A,   A},
		{  A, A, W, A,   A},
		{  A, A, A, A,   A},
		{TRU, A, A, A, TRU},
	},
	{
		{A, A, A, A, A},
		{A, A, A, A, A},
		{A, A, W, A, A},
		{A, A, A, A, A},
		{A, A, A, A, A},
	},
	{
		{A, A,   A, A, A},
		{A, A,   A, A, A},
		{A, A, WS_, A, A},
		{A, A,   A, A, A},
		{A, A,   A, A, A},
	},
}

buildings = {
	{sizex=7, sizez=7, yoff= 0, ysize= 9, scm=house},
	{sizex=9, sizez=9, yoff= 0, ysize= 2, scm=field},
	{sizex=9, sizez=9, yoff= 0, ysize= 2, scm=field_cotton},
	{sizex=3, sizez=3, yoff= 1, ysize= 4, scm=lamp, weight=1/5, no_rotate=true},
	{sizex=4, sizez=4, yoff=-5, ysize=11, scm=well, no_rotate=true, pervillage=1},
	{sizex=7, sizez=7, yoff= 0, ysize=5, scm=fountain, weight=1/2, pervillage=2},
}
