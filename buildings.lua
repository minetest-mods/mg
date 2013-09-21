local W = minetest.get_content_id("default:wood")
local WS = minetest.get_content_id("default:water_source")
local S = minetest.get_content_id("farming:soil_wet")
local WH = minetest.get_content_id("farming:wheat_8")
local A = minetest.get_content_id("air")
local G = minetest.get_content_id("default:glass")
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
		{W, W, W, A, W, W, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, W, W, W, W, W, W},
	},
	{
		{W, W, W, A, W, W, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{G, A, A, A, A, A, G},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, W, G, G, G, W, W},
	},
	{
		{W, W, W, W, W, W, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, A, A, A, A, A, W},
		{W, W, W, W, W, W, W},
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
}

buildings = {lenght = 2,
	{sizex=3, sizez=3, ymin=0, ymax=4, scm=house},
	{sizex=4, sizez=4, ymin=0, ymax=1, scm=field}
}
