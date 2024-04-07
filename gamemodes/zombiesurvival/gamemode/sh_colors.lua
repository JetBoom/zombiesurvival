COLOR_GRAY = Color(190, 190, 190)
COLOR_RED = Color(255, 0, 0)
COLOR_BLUE = Color(0, 0, 255)
COLOR_GREEN = Color(0, 255, 0)
COLOR_LIMEGREEN = Color(50, 255, 50)
COLOR_YELLOW = Color(255, 255, 0)
COLOR_CYAN = Color(0, 255, 255)
COLOR_WHITE = Color(255, 255, 255)
COLOR_PURPLE = Color(255, 0, 255)
COLOR_PINK = Color(255, 20, 100)
COLOR_ORANGE = Color(255, 200, 0)
COLOR_BROWN = Color(168, 94, 0)
COLOR_TAN = Color(210, 180, 140)
COLOR_LBLUE = Color(25, 50, 255)
COLOR_SOFTRED = Color(255, 40, 40)

COLOR_RPURPLE = Color(200, 0, 200)
COLOR_RPINK = Color(255, 100, 255)
COLOR_RORANGE = Color(255, 128, 0)

COLOR_DARKGRAY = Color(40, 40, 40)
COLOR_DARKRED = Color(185, 35, 35)
COLOR_DARKGREEN = Color(0, 150, 0)
COLOR_DARKBLUE = Color(5, 75, 150)

COLOR_MIDGRAY = Color(140, 140, 140)

COLOR_FRIENDLY = COLOR_DARKGREEN
COLOR_HEALTHY = COLOR_DARKGREEN
COLOR_SCRATCHED = Color(80, 210, 0)
COLOR_HURT = Color(150, 50, 0)
COLOR_CRITICAL = COLOR_DARKRED

color_black_alpha220 = Color(0, 0, 0, 180)
color_black_alpha200 = Color(0, 0, 0, 180)
color_black_alpha180 = Color(0, 0, 0, 180)
color_black_alpha120 = Color(0, 0, 0, 120)
color_black_alpha90 = Color(0, 0, 0, 90)

color_white_alpha230 = Color(255, 255, 255, 230)
color_white_alpha200 = Color(255, 255, 255, 200)
color_white_alpha180 = Color(255, 255, 255, 180)
color_white_alpha120 = Color(255, 255, 255, 120)
color_white_alpha90 = Color(255, 255, 255, 90)

COLORID_WHITE = 0
COLORID_BLACK = 1
COLORID_RED = 2
COLORID_GREEN = 3
COLORID_BLUE = 4
COLORID_YELLOW = 5
COLORID_PURPLE = 6
COLORID_CYAN = 7
COLORID_GRAY = 8

local colidtocolor = {
	[COLORID_WHITE] = COLOR_WHITE,
	[COLORID_BLACK] = color_black,
	[COLORID_RED] = COLOR_RED,
	[COLORID_GREEN] = COLOR_GREEN,
	[COLORID_BLUE] = COLOR_BLUE,
	[COLORID_YELLOW] = COLOR_YELLOW,
	[COLORID_PURPLE] = COLOR_PURPLE,
	[COLORID_CYAN] = COLOR_CYAN,
	[COLORID_GRAY] = COLOR_GRAY
}
function util.ColorIDToColor(id, default)
	return colidtocolor[id] or default or COLOR_WHITE
end

function util.ColorCopy(source, dest, copyalpha)
	dest.r = source.r
	dest.g = source.g
	dest.b = source.b
	if copyalpha then
		dest.a = source.a
	end
end
