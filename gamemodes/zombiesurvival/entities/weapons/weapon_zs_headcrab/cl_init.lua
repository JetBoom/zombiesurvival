include("shared.lua")

SWEP.PrintName = "헤드크랩"
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
