AddCSLuaFile()

SWEP.Base = "weapon_zs_basetrinket"

SWEP.PrintName = "Night Vision Goggles"
SWEP.Description = "Allows you to see in the dark and reduce the intensity of dim vision."

if CLIENT then
	SWEP.VElements = {
		["perf"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -2.597), angle = Angle(5.843, 90, 0), size = Vector(0.25, 0.15, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["perf"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 0.5, -2), angle = Angle(5, 90, 0), size = Vector(0.25, 0.15, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
end

SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if CLIENT and IsFirstTimePredicted() then
		surface.PlaySound(GAMEMODE.m_NightVision and "items/nvg_off.wav" or "items/nvg_on.wav")
		GAMEMODE.m_NightVision = not GAMEMODE.m_NightVision
	end
end
