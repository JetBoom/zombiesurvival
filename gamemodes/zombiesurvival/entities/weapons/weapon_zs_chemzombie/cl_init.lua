INC_CLIENT()

SWEP.PrintName = ""..translate.Get("wpnc_chemzombie_name")
SWEP.DrawCrosshair = false

function SWEP:Think()
end

function SWEP:DrawHUD()
	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end
