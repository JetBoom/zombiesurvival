AddCSLuaFile()

SWEP.PrintName = "'Waraxe' Handgun"
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 50
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.Glock_Slide"
	SWEP.HUD3DPos = Vector(-1.55, 0.25, 0.1)
	SWEP.HUD3DAng = Angle(90, 0, 0)

	SWEP.VElements = {
		["barrel"] = { type = "Model", model = "models/props_phx/wheels/drugster_front.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(0, 0, -4.448), angle = Angle(180, 0, 0), size = Vector(0.019, 0.019, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/props_trainstation/pole_448Connection002b.mdl", bone = "v_weapon.Glock_Slide", rel = "", pos = Vector(3.292, 0.305, -0.005), angle = Angle(13.053, -90.301, 89.9), size = Vector(0.085, 0.045, 0.02), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sides"] = { type = "Model", model = "models/props_trainstation/Column_Arch001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.06, 0, -0.08), angle = Angle(0, 0, 0), size = Vector(0.119, 0.013, 0.09), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["barrel"] = { type = "Model", model = "models/props_phx/wheels/drugster_front.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, -4.448), angle = Angle(180, 0, 0), size = Vector(0.019, 0.019, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/props_trainstation/pole_448Connection002b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 1.71, -3.711), angle = Angle(87.421, -5.053, 0), size = Vector(0.085, 0.045, 0.02), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sides"] = { type = "Model", model = "models/props_trainstation/Column_Arch001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.06, 0, -0.072), angle = Angle(0, 0, 0), size = Vector(0.119, 0.013, 0.09), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 3
SWEP.Primary.Delay = 0.3

SWEP.Primary.ClipSize = 9
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Sound = ")weapons/usp/usp_unsil-1.wav"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.75
SWEP.ConeMin = 1.2
SWEP.HeadshotMulti = 2

SWEP.Tier = 2

SWEP.IronSightsPos = Vector(-5.75, 10, 2.7)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.07)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Halberd' Handgun", "Deals extra damage to zombies with full health, but less overall damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.85

	wept.BulletCallback = function(attacker, tr, dmginfo)
		if SERVER then
			local hitent = tr.Entity
			if hitent:IsValidLivingZombie() and hitent:Health() == hitent:GetMaxHealthEx() and gamemode.Call("PlayerShouldTakeDamage", hitent, attacker) then
				hitent:TakeSpecialDamage(hitent:Health() * 0.1, DMG_DIRECT, attacker, attacker:GetActiveWeapon(), tr.HitPos)
			end
		end
	end
end)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(78, 82))
end
