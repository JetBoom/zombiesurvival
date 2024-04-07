AddCSLuaFile()

SWEP.Base = "weapon_zs_basetrinket"

SWEP.PrintName = "Doom Organ"
SWEP.Description = "Reduces the duration of Dim Vision and allows you to cleanse harmful statuses every 20 seconds."

if CLIENT then
	SWEP.VElements = {
		["doom_organ"] = { type = "Model", model = "models/weapons/w_bugbait.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(0, 0, -2), angle = Angle(0, 0, 0), size = Vector(0.885, 0.8, 1.08), color = Color(65, 45, 36, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["doom_organ++"] = { type = "Model", model = "models/weapons/w_bugbait.mdl", bone = "ValveBiped.Grenade_body", rel = "doom_organ", pos = Vector(0, 0, 3.635), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 1), color = Color(45, 35, 25, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["doom_organ+++"] = { type = "Model", model = "models/weapons/w_bugbait.mdl", bone = "ValveBiped.Grenade_body", rel = "doom_organ", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.15, 0.2, 4.193), color = Color(65, 55, 45, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["doom_organ+"] = { type = "Model", model = "models/weapons/w_bugbait.mdl", bone = "ValveBiped.Grenade_body", rel = "doom_organ", pos = Vector(0, 0, -3), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 1), color = Color(45, 35, 25, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["doom_organ"] = { type = "Model", model = "models/weapons/w_bugbait.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.5, 0.518), angle = Angle(0, 0, 0), size = Vector(0.885, 0.8, 1.08), color = Color(65, 45, 36, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["doom_organ++"] = { type = "Model", model = "models/weapons/w_bugbait.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "doom_organ", pos = Vector(0, 0, 3.635), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 1), color = Color(45, 35, 25, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["doom_organ+++"] = { type = "Model", model = "models/weapons/w_bugbait.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "doom_organ", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.15, 0.2, 4.193), color = Color(65, 55, 45, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["doom_organ+"] = { type = "Model", model = "models/weapons/w_bugbait.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "doom_organ", pos = Vector(0, 0, -3), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 1), color = Color(45, 35, 25, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
end

SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local owner = self:GetOwner()
	if SERVER and not owner.LastDoomOrganCleanse or (owner.LastDoomOrganCleanse and owner.LastDoomOrganCleanse + 20 < CurTime()) then
		owner.LastDoomOrganCleanse = CurTime()
		owner:EmitSound("weapons/bugbait/bugbait_squeeze3.wav", 70, 70)
		owner:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav", 65, 135, 1, CHAN_AUTO)

		owner:SendLua("util.WhiteOut(0.25)")

		local statuses = {"enfeeble", "slow", "dimvision", "frost"}
		for _, status in pairs(statuses) do
			if owner:GetStatus(status) then
				owner:RemoveStatus(status)
			end
		end
	end
end
