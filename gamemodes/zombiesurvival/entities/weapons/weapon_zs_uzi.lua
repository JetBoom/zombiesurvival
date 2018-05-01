AddCSLuaFile()

SWEP.PrintName = "'Sprayer' Uzi 9mm"
SWEP.Description = "Quite inaccurate, but has good, cheap and reliable firepower potential."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.mac10_bolt"
	SWEP.HUD3DPos = Vector(-1.45, 1.25, 0)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_MAC10.Single")
SWEP.Primary.Damage = 17
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.075

SWEP.Primary.ClipSize = 35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 5.5
SWEP.ConeMin = 2.5

SWEP.FireAnimSpeed = 1.5

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.Tier = 2

SWEP.IronSightsPos = Vector(-7, 15, 0)
SWEP.IronSightsAng = Vector(3, -3, -10)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.58, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.27, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 3, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Disperser' Uzi", "Decreases the clip size but increases the fire rate, and the last few shots bounce", function(wept)
	wept.Primary.ClipSize = math.floor(wept.Primary.ClipSize * 0.53)
	wept.Primary.Delay = 0.06

	local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
		attacker.RicochetBullet = true
		if attacker:IsValid() then
			attacker:FireBulletsLua(hitpos, 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, 0, 1, damage, nil, nil, "tracer_rico", nil, nil, nil, nil, nil, attacker:GetActiveWeapon())
		end
		attacker.RicochetBullet = nil
	end
	wept.BulletCallback = function(attacker, tr, dmginfo)
		if SERVER and tr.HitWorld and not tr.HitSky and attacker:GetActiveWeapon():Clip1() < 8 then
			local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * 1.5
			timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
		end
	end
end)
