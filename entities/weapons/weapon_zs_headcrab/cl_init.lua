include("shared.lua")

SWEP.PrintName = translate.Get("wn_headcrab")
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
