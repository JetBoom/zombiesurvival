INC_CLIENT()

SWEP.HUD3DBone = "ValveBiped.Crossbow_base"
SWEP.HUD3DPos = Vector(1.5, 0.5, 11)
SWEP.HUD3DScale = 0.025

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.IronsightsMultiplier = 0.25

function SWEP:GetViewModelPosition(pos, ang)
	if GAMEMODE.DisableScopes then return end

	if self:IsScoped() then
		return pos + ang:Up() * 256, ang
	end

	return self.BaseClass.GetViewModelPosition(self, pos, ang)
end

local texScope = surface.GetTextureID("zombiesurvival/scope")
function SWEP:DrawHUDBackground()
	if GAMEMODE.DisableScopes then return end
	if not self:IsScoped() then return end

	local scrw, scrh = ScrW(), ScrH()
	local size = math.min(scrw, scrh)

	local hw = scrw * 0.5
	local hh = scrh * 0.5

	surface.SetDrawColor(255, 0, 0, 180)
	surface.DrawLine(0, hh, scrw, hh)
	surface.DrawLine(hw, 0, hw, scrh)
	for i=1, 10 do
		surface.DrawLine(hw, hh + i * 7, hw + (50 - i * 5), hh + i * 7)
	end

	surface.SetTexture(texScope)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect((scrw - size) * 0.5, (scrh - size) * 0.5, size, size)
	surface.SetDrawColor(0, 0, 0, 255)
	if scrw > size then
		local extra = (scrw - size) * 0.5
		surface.DrawRect(0, 0, extra, scrh)
		surface.DrawRect(scrw - extra, 0, extra, scrh)
	end
	if scrh > size then
		local extra = (scrh - size) * 0.5
		surface.DrawRect(0, 0, scrw, extra)
		surface.DrawRect(0, scrh - extra, scrw, extra)
	end
end
