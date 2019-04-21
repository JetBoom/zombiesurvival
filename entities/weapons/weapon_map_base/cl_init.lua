include('shared.lua')

SWEP.Slot = -1
SWEP.SlotPos = -1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = false

local glowmat = Material("sprites/glow04_noz")
function SWEP:DrawWorldModel()
	local owner = self:GetOwner()
	if owner:IsValid() then return end

	local pos = self:GetPos()
	local col = self:GetClass() == "weapon_knife" and Color(0, 255, 0, 200) or Color(255, 125, 63, 200)

	render.SetMaterial(glowmat)
	render.DrawSprite(pos, math.abs(30 + 15 * math.sin(RealTime() * 7 + 1.5)), math.abs(30 + 15 * math.sin(RealTime() * 7)), col)
end

SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel
