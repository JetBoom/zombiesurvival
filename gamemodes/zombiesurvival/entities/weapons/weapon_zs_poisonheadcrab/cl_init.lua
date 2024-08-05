include("shared.lua")

SWEP.PrintName = "포이즌 헤드크랩"
SWEP.ViewModelFOV = 70
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
