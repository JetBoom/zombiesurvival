AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Meat Hook"

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.363, -5), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.181, 4, -9), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_SLASH

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_junk/meathook001a.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 40
SWEP.MeleeRange = 50
SWEP.MeleeSize = 1.15

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingTime = 0.75
SWEP.SwingHoldType = "grenade"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(95, 105))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.random(120, 130))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_sheet_impact_bullet"..math.random(2)..".wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Health() > self.MeleeDamage then
		hitent:AddLegDamage(30)

		if SERVER then
			local ang = self.Owner:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), 180)

			local ent = ents.Create("prop_meathook")
			if ent:IsValid() then
				ent:SetPos(tr.HitPos)
				ent:Spawn()
				ent:SetOwner(self.Owner)

				local followed = false
				if hitent:GetBoneCount() > 1 then
					local boneindex = hitent:NearestBone(tr.HitPos)
					if boneindex and boneindex > 0 then
						ent:FollowBone(hitent, boneindex)
						ent:SetPos((hitent:GetBonePositionMatrixed(boneindex) * 2 + tr.HitPos) / 3)
						followed = true
					end
				end
				if not followed then
					ent:SetParent(hitent)
				end

				ent:SetAngles(ang)
			end

			self:Remove()
		end
	end
end
