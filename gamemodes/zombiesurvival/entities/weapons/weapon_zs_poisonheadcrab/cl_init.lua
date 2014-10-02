include("shared.lua")

SWEP.PrintName = "Poison Headcrab"
SWEP.ViewModelFOV = 70
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
