AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Mechanic's Wrench"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_c17/tools_wrench01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 2, 0), angle = Angle(190, 0, 90), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_c17/tools_wrench01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 1, 0), angle = Angle(190, 90, 90), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} }
	}

	SWEP.Description = "This tool can be used to repair deployables as long as they were not damaged recently."
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_c17/tools_wrench01a.mdl"
SWEP.ModelScale = 1.5
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.Primary.Delay = 0.8
SWEP.MeleeDamage = 28
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingTime = 0.19
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingHoldType = "grenade"

SWEP.HealStrength = 13

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(4)..".ogg", 75, math.random(120, 125))
end

function SWEP:PlayRepairSound(hitent)
	hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
end

if CLIENT then return end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsValid() then return end

	if hitent.HitByWrench and hitent:HitByWrench(self, self.Owner, tr) then
		return
	end

	if hitent.GetObjectHealth then
		local oldhealth = hitent:GetObjectHealth()
		if oldhealth <= 0 or oldhealth >= hitent:GetMaxObjectHealth() or hitent.m_LastDamaged and CurTime() < hitent.m_LastDamaged + 4 then return end

		local healstrength = (self.Owner.HumanRepairMultiplier or 1) * self.HealStrength * (hitent.WrenchRepairMultiplier or 1)

		hitent:SetObjectHealth(math.min(hitent:GetMaxObjectHealth(), hitent:GetObjectHealth() + healstrength))
		local healed = hitent:GetObjectHealth() - oldhealth
		self:PlayRepairSound(hitent)
		gamemode.Call("PlayerRepairedObject", self.Owner, hitent, healed / 2, self)

		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetMagnitude(1)
		util.Effect("nailrepaired", effectdata, true, true)

		return true
	end
end
