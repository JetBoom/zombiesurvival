local draw_SimpleText = draw.SimpleText
local draw_DrawText = draw.DrawText

local FontBlurX = 0
local FontBlurX2 = 0
local FontBlurY = 0
local FontBlurY2 = 0

timer.Create("fontblur", 0.1, 0, function()
	FontBlurX = math.random(-8, 8)
	FontBlurX2 = math.random(-8, 8)
	FontBlurY = math.random(-8, 8)
	FontBlurY2 = math.random(-8, 8)
end)

local color_blur1 = Color(60, 60, 60, 220)
local color_blur2 = Color(40, 40, 40, 140)
function draw.SimpleTextBlur(text, font, x, y, col, xalign, yalign)
	if GAMEMODE.FontEffects then
		color_blur1.a = col.a * 0.85
		color_blur2.a = col.a * 0.55
		draw_SimpleText(text, font, x + FontBlurX, y + FontBlurY, color_blur1, xalign, yalign)
		draw_SimpleText(text, font, x + FontBlurX2, y + FontBlurY2, color_blur2, xalign, yalign)
	end
	draw_SimpleText(text, font, x, y, col, xalign, yalign)
end

function draw.DrawTextBlur(text, font, x, y, col, xalign)
	if GAMEMODE.FontEffects then
		color_blur1.a = col.a * 0.85
		color_blur2.a = col.a * 0.55
		draw_DrawText(text, font, x + FontBlurX, y + FontBlurY, color_blur1, xalign)
		draw_DrawText(text, font, x + FontBlurX2, y + FontBlurY2, color_blur2, xalign)
	end
	draw_DrawText(text, font, x, y, col, xalign)
end

local colBlur = Color(0, 0, 0)
function draw.SimpleTextBlurry(text, font, x, y, col, xalign, yalign)
	if GAMEMODE.FontEffects then
		colBlur.r = col.r
		colBlur.g = col.g
		colBlur.b = col.b
		colBlur.a = col.a * math.Rand(0.35, 0.6)

		draw_SimpleText(text, font.."Blur", x, y, colBlur, xalign, yalign)
	end
	draw_SimpleText(text, font, x, y, col, xalign, yalign)
end

function draw.DrawTextBlurry(text, font, x, y, col, xalign)
	if GAMEMODE.FontEffects then
		colBlur.r = col.r
		colBlur.g = col.g
		colBlur.b = col.b
		colBlur.a = col.a * math.Rand(0.35, 0.6)

		draw_DrawText(text, font.."Blur", x, y, colBlur, xalign)
	end
	draw_DrawText(text, font, x, y, col, xalign)
end
