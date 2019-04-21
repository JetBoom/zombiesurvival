AddCSLuaFile()

SWEP.PrintName = "Glass Bottle"
SWEP.Description = "A glass bottle."

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/glassbottle01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.799, 0.899, -7), angle = Angle(8.182, -12.858, 8.182), size = Vector(1.144, 1.144, 1.144), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/glassbottle01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.4, 1.557, -5.715), angle = Angle(0, 0, 0), size = Vector(1.274, 1.274, 1.274), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_junk/glassbottle01a.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.MeleeDamage = 40
SWEP.MeleeRange = 48
SWEP.MeleeSize = 0.875

SWEP.WalkSpeed = SPEED_FASTEST

SWEP.Primary.Delay = 0.85
SWEP.SwingTime = 0
SWEP.SwingHoldType = "grenade"

SWEP.NoHitSoundFlesh = true

SWEP.NoGlassWeapons = true

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/glass/glass_bottle_break2.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/glass/glass_bottle_break2.wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() then
		if SERVER then
			local owner = self:GetOwner()
			timer.Simple(0, function()
				owner:StripWeapon(self:GetClass())
			end)

			owner:Give("weapon_zs_crackedbottle")
			owner:SelectWeapon("weapon_zs_crackedbottle")
		end
	end
end
