AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Sawhack"

	SWEP.ViewModelFOV = 60

	SWEP.VElements = {
		["base1+"] = { type = "Model", model = "models/props_lab/tpplug.mdl", bone = "ValveBiped.Bip01", rel = "base", pos = Vector(-1.45, 0, -0.25), angle = Angle(270, 0, 0), size = Vector(0.4, 0.4, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base1"] = { type = "Model", model = "models/props_lab/tpplug.mdl", bone = "ValveBiped.Bip01", rel = "base", pos = Vector(-1.45, 0, 0.394), angle = Angle(90, 0, 0), size = Vector(0.4, 0.4, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.956, 2.181, -18.506), angle = Angle(0, -6.212, 90), size = Vector(0.4, 0.4, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base1+"] = { type = "Model", model = "models/props_lab/tpplug.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-1.45, 0, -0.25), angle = Angle(270, 0, 0), size = Vector(0.4, 0.4, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base1"] = { type = "Model", model = "models/props_lab/tpplug.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-1.45, 0, 0.394), angle = Angle(90, 0, 0), size = Vector(0.4, 0.4, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 2, -22.5), angle = Angle(0, 0, 90), size = Vector(0.4, 0.4, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.Primary.Delay = 0.45

SWEP.MeleeDamage = 32
SWEP.MeleeRange = 55
SWEP.MeleeSize = 1.9
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 0.5

SWEP.WalkSpeed = SPEED_FAST

SWEP.SwingTime = 0.15
SWEP.SwingRotation = Angle(0, -35, -50)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.HoldType = "melee2"
SWEP.SwingHoldType = "melee2"

SWEP.HitDecal = "Manhackcut"
SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.NoHitSoundFlesh = true

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(75, 80))
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/manhack/grind"..math.random(5)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitflesh then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetMagnitude(2)
			effectdata:SetScale(1)
		util.Effect("sparks", effectdata)
	end
end
