include("shared.lua")

SWEP.PrintName = "Chem Zombie"
SWEP.DrawCrosshair = false

function SWEP:Think()
end

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
