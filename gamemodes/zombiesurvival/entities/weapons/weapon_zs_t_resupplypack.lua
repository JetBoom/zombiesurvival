AddCSLuaFile()

SWEP.Base = "weapon_zs_basetrinket"

SWEP.PrintName = "Resupply Pack"
SWEP.Description = "Allows humans to resupply from you.\nPress LMB with the pack in your hand to resupply yourself."

if CLIENT then
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/Items/ammocrate_ar2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/Items/ammocrate_ar2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
end

SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if CLIENT then return end

	local owner = self:GetOwner()
	for _, ent in pairs(ents.FindByClass("status_resupplypack")) do
		if ent:GetOwner() == owner then
			owner:Resupply(owner, ent)
		end
	end
end
