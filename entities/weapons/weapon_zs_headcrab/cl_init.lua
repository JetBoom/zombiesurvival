INC_CLIENT()

SWEP.PrintName = "Headcrab"
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end
