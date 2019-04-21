include("shared.lua")

CLASS.Icon = "sprites/glow04_noz"
CLASS.IconColor = Color(0, 180, 255)

function CLASS:PrePlayerDraw(pl)
	return true
end
