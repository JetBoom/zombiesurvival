INC_CLIENT()

SWEP.ViewModelFlip = false

SWEP.HUD3DPos = Vector(4, 0, 15)
SWEP.HUD3DAng = Angle(0, 180, 180)
SWEP.HUD3DScale = 0.04
SWEP.HUD3DBone = "base"

function SWEP:DrawHUD()
	if GetConVar("crosshair"):GetInt() == 1 then
		self:DrawCrosshairDot()
	end
end

function SWEP:DrawHUD()
	local wid, hei = 384, 16
	local x, y = ScrW() - wid - 128, ScrH() - hei - 128
	local texty = y - 4 - draw.GetFontHeight("ZSHUDFont")

	local c = 0
	if not self.NextMineCheckTime or self.NextMineCheckTime < CurTime() then
		for _, ent in pairs(ents.FindByClass("projectile_impactmine")) do
			if (CLIENT or ent.CreateTime + 300 > CurTime()) and ent:GetOwner() == self:GetOwner() then
				c = c + 1
			end
		end
		self.CachedMines = c
		self.NextMineCheckTime = CurTime() + 1
	else
		c = self.CachedMines
	end

	local charges = self:GetPrimaryAmmoCount()
	local chargetxt = "Mines: " .. c .. " / " .. self.MaxMines
	if charges > 0 then
		draw.SimpleText(chargetxt, "ZSHUDFont", x + wid, texty, COLOR_CYAN, TEXT_ALIGN_RIGHT)
	end

	if GAMEMODE:ShouldDraw2DWeaponHUD() then
		self:Draw2DHUD()
	end

	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end
