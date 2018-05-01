AddCSLuaFile()

SWEP.PrintName = "'Inferno' AUG"
SWEP.Description = "A very accurate assault rifle with great damage output and a high clip size."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.aug_Parent"
	SWEP.HUD3DPos = Vector(-1, -2.5, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_aug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_aug.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_AUG.Single")
SWEP.Primary.Damage = 23
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.095

SWEP.Primary.ClipSize = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 4
SWEP.ConeMin = 1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Inferno' Incendiary Rifle", "Fires incendiary assault rifle rounds, but reduced damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.85

	wept.BulletCallback = function(attacker, tr, dmginfo)
		local ent = tr.Entity
		if SERVER and math.random(6) == 1 and ent:IsValidLivingZombie() then
			ent:Ignite(6)
			for __, fire in pairs(ents.FindByClass("entityflame")) do
				if fire:IsValid() and fire:GetParent() == ent then
					fire:SetOwner(attacker)
					fire:SetPhysicsAttacker(attacker)
					fire.AttackerForward = attacker
				end
			end
		end
	end
end)
