COLOR_GRAY = Color(190, 190, 190)
COLOR_RED = Color(255, 0, 0)
COLOR_BLUE = Color(0, 0, 255)
COLOR_GREEN = Color(0, 255, 0)
COLOR_LIMEGREEN = Color(50, 255, 50)
COLOR_YELLOW = Color(255, 255, 0)
COLOR_CYAN = Color(0, 255, 255)
COLOR_WHITE = Color(255, 255, 255)
COLOR_PURPLE = Color(255, 0, 255)

COLOR_DARKGRAY = Color(40, 40, 40)
COLOR_DARKRED = Color(185, 0, 0)
COLOR_DARKGREEN = Color(0, 150, 0)
COLOR_DARKBLUE = Color(5, 75, 150)

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

color_white_alpha220 = Color(255, 255, 255, 200)
color_white_alpha200 = Color(255, 255, 255, 200)
color_white_alpha180 = Color(255, 255, 255, 180)
color_white_alpha120 = Color(255, 255, 255, 120)
color_white_alpha90 = Color(255, 255, 255, 90)

function util.ColorCopy(source, dest, copyalpha)
	dest.r = source.r
	dest.g = source.g
	dest.b = source.b
	if copyalpha then
		dest.a = source.a
	end
end
