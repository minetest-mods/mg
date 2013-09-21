local W = minetest.get_content_id("default:wood")
local WS = minetest.get_content_id("default:water_source")
local S = minetest.get_content_id("farming:soil_wet")
local WH = minetest.get_content_id("farming:wheat_8")
local A = minetest.get_content_id("air")
local G = minetest.get_content_id("default:glass")
local C = minetest.get_content_id("default:cobble")
local T = minetest.get_content_id("default:tree")
local WG = minetest.get_content_id("wool:grey")
local FW = minetest.get_content_id("default:fence_wood")
local TRXM = {node={name="default:torch", param2=2}}
local TRXP = {node={name="default:torch", param2=3}}
local TRZM = {node={name="default:torch", param2=5}}
local TRZP = {node={name="default:torch", param2=4}}
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
lamp = {
	{
		{A,  A, A},
		{A, FW, A},
		{A,  A, A},
	},
	{
		{A,  A, A},
		{A, FW, A},
		{A,  A, A},
	},
	{
		{A,  A, A},
		{A, FW, A},
		{A,  A, A},
	},
	{
		{   A, TRXM,    A},
		{TRZP,   WG, TRZM},
		{   A, TRXP,    A},
	},
}

buildings = {
	{sizex=3, sizez=3, ymin=0, ymax=8, scm=house},
	{sizex=4, sizez=4, ymin=0, ymax=1, scm=field},
	{sizex=1, sizez=1, ymin=1, ymax=4, scm=lamp, chance=5},
}
