-- This rewrites a few drawing methods to be slightly faster.
-- This file is to be included before everything else.

-- WARNING: Removes the functionality of any drawing functions returning values (except GetFontHeight).
-- This doesn't really matter in most cases because A: nobody uses it and B: they were returning wrong values most of the time anyway.

AddCSLuaFile("buffthefps.lua")

if SERVER or BuffedFPS then return end
BuffedFPS = true

local surface = surface
local Color = Color
local color_white = color_white

local TEXT_ALIGN_LEFT = 0
local TEXT_ALIGN_CENTER	= 1
local TEXT_ALIGN_RIGHT = 2
local TEXT_ALIGN_TOP = 3
local TEXT_ALIGN_BOTTOM	= 4
--[[TEXT_ALIGN_LEFT		= 0
TEXT_ALIGN_CENTER	= 1
TEXT_ALIGN_RIGHT	= 2
TEXT_ALIGN_TOP		= 3
TEXT_ALIGN_BOTTOM	= 4]]

local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetTextPos = surface.SetTextPos
local surface_SetTextColor = surface.SetTextColor
local surface_DrawText = surface.DrawText
local surface_SetTexture = surface.SetTexture
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_GetTextureID = surface.GetTextureID

local string_sub = string.sub

local math_ceil = math.ceil

local Tex_Corner8 = surface_GetTextureID( "gui/corner8" )
local Tex_Corner16 = surface_GetTextureID( "gui/corner16" )
local Tex_white = surface_GetTextureID( "vgui/white" )


-- Just an FYI that this is around 450 times faster than using surface.GetTextSize when cached.
local CachedFontHeights = {}
local function draw_GetFontHeight(font)
	if CachedFontHeights[font] then
		return CachedFontHeights[font] 
	end

	surface_SetFont(font)
	local w, h = surface_GetTextSize("W")
	CachedFontHeights[font] = h

	return h
end

local function draw_SimpleText(text, font, x, y, colour, xalign, yalign)
	surface_SetFont(font)

	if xalign == TEXT_ALIGN_CENTER then
		local w, h = surface_GetTextSize( text )
		x = x - w / 2
	elseif xalign == TEXT_ALIGN_RIGHT then
		local w, h = surface_GetTextSize( text )
		x = x - w
	end

	if yalign == TEXT_ALIGN_CENTER then
		local h = draw_GetFontHeight(font)
		y = y - h / 2
	elseif yalign == TEXT_ALIGN_BOTTOM then
		local h = draw_GetFontHeight(font)
		y = y - h
	end

	surface_SetTextPos(x, y)
	if colour then
		surface_SetTextColor(colour.r, colour.g, colour.b, colour.a)
	else
		surface_SetTextColor(255, 255, 255, 255)
	end
	surface_DrawText(text)
end

local function draw_DrawText(text, font, x, y, colour, xalign )
	local curX = x
	local curY = y
	local curString = ""
	
	surface_SetFont(font)
	local lineHeight = draw_GetFontHeight(font)
	
	for i=1, #text do
		local ch = string_sub(text, i, i)
		if ch == "\n" then
			if #curString > 0 then
				draw_SimpleText(curString, font, curX, curY, colour, xalign)
			end
			
			curY = curY + lineHeight / 2
			curX = x
			curString = ""
		elseif ch == "\t" then
			if #curString > 0 then
				draw_SimpleText(curString, font, curX, curY, colour, xalign)
			end
			local tmpSizeX,tmpSizeY =  surface_GetTextSize(curString)
			curX = math_ceil( (curX + tmpSizeX) / 50 ) * 50
			curString = ""
		else
			curString = curString .. ch
		end
	end	
	if #curString > 0 then
		draw_SimpleText(curString, font, curX, curY, colour, xalign)
	end
end

local function draw_RoundedBox(bordersize, x, y, w, h, color)
	surface_SetDrawColor(color)

	surface_DrawRect(x + bordersize, y, w - bordersize * 2, h)
	surface_DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
	surface_DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)

	surface_SetTexture(bordersize > 8 and Tex_Corner16 or Tex_Corner8)
	surface_DrawTexturedRectRotated( x + bordersize/2 , y + bordersize/2, bordersize, bordersize, 0 ) 
	surface_DrawTexturedRectRotated( x + w - bordersize/2 , y + bordersize/2, bordersize, bordersize, 270 ) 
	surface_DrawTexturedRectRotated( x + bordersize/2 , y + h -bordersize/2, bordersize, bordersize, 90 )
 	surface_DrawTexturedRectRotated( x + w - bordersize/2 , y + h - bordersize/2, bordersize, bordersize, 180 )
end

local function draw_Text(tab)
	local text = tab.text
	local font = tab.font or "DermaDefault"
	local x = tab.pos[1] or 0
	local y = tab.pos[2] or 0
	local xalign = tab.xalign
	local yalign = tab.yalign

	surface_SetFont(font)

	if xalign == TEXT_ALIGN_CENTER then
		local w, h = surface_GetTextSize( text )
		x = x - w / 2
	elseif xalign == TEXT_ALIGN_RIGHT then
		local w, h = surface_GetTextSize( text )
		x = x - w
	end

	if yalign == TEXT_ALIGN_CENTER then
		local h = draw_GetFontHeight(font)
		y = y - h / 2
	end

	surface_SetTextPos(x, y)

	if tab.color then
		surface_SetTextColor(tab.color)
	else
		surface_SetTextColor(255, 255, 255, 255)
	end

	surface_DrawText(text)
end

function draw.WordBox( bordersize, x, y, text, font, color, fontcolor )
	surface_SetFont( font )
	local w, h = surface_GetTextSize( text )
	
	draw_RoundedBox( bordersize, x, y, w+bordersize*2, h+bordersize*2, color )

	surface_SetTextColor( fontcolor.r, fontcolor.g, fontcolor.b, fontcolor.a )
	surface_SetTextPos( x + bordersize, y + bordersize )
	surface_DrawText( text )
end

function draw.TextShadow( tab, distance, alpha )

	alpha = alpha or 200

	local color = tab.color
	local pos 	= tab.pos
	tab.color = Color( 0, 0, 0, alpha )
	tab.pos = { pos[1] + distance, pos[2] + distance }

	draw_Text( tab )
	
	tab.color = color
	tab.pos = pos
	
	draw_Text( tab )
end

function draw.TexturedQuad(tab)
	surface_SetTexture(tab.texture)
	surface_SetDrawColor(tab.color or color_white)
	surface_DrawTexturedRect(tab.x, tab.y, tab.w, tab.h)
end

function draw.NoTexture()
	surface_SetTexture( Tex_white )
end

function draw.RoundedBoxEx( bordersize, x, y, w, h, color, a, b, c, d )
	surface_SetDrawColor(color)
	
	-- Draw as much of the rect as we can without textures
	surface_DrawRect(x + bordersize, y, w - bordersize * 2, h)
	surface_DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
	surface_DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)

	surface_SetTexture(bordersize > 8 and Tex_Corner16 or Tex_Corner8)

	if a then
		surface_DrawTexturedRectRotated( x + bordersize/2 , y + bordersize/2, bordersize, bordersize, 0 ) 
	else
		surface_DrawRect( x, y, bordersize, bordersize )
	end
	
	if b then
		surface_DrawTexturedRectRotated( x + w - bordersize/2 , y + bordersize/2, bordersize, bordersize, 270 ) 
	else
		surface_DrawRect( x + w - bordersize, y, bordersize, bordersize )
	end
 
	if c then
		surface_DrawTexturedRectRotated( x + bordersize/2 , y + h -bordersize/2, bordersize, bordersize, 90 )
	else
		surface_DrawRect( x, y + h - bordersize, bordersize, bordersize )
	end
 
	if d then
		surface_DrawTexturedRectRotated( x + w - bordersize/2 , y + h - bordersize/2, bordersize, bordersize, 180 )
	else
		surface_DrawRect( x + w - bordersize, y + h - bordersize, bordersize, bordersize )
	end
end

function draw.SimpleTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour)
	local steps = (outlinewidth*2) / 3
	if steps < 1 then steps = 1 end
	
	for _x=-outlinewidth, outlinewidth, steps do
		for _y=-outlinewidth, outlinewidth, steps do
			draw_SimpleText(text, font, x + _x, y + _y, outlinecolour, xalign, yalign)
		end
	end
	
	draw_SimpleText(text, font, x, y, colour, xalign, yalign)
end

draw.GetFontHeight = draw_GetFontHeight
draw.SimpleText = draw_SimpleText
draw.DrawText = draw_DrawText
draw.RoundedBox = draw_RoundedBox
draw.Text = draw_Text
