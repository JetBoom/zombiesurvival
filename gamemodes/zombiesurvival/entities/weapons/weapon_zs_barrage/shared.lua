SWEP.PrintName = "'Barrage' Grenade Launcher"
SWEP.Description = "Fires multiple grenades that detonate on impact with enemies or on the third bounce."

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.Delay = 0.7
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Damage = 31
SWEP.Primary.NumShots = 3

SWEP.ConeMax = 8
SWEP.ConeMin = 7.5

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4
SWEP.MaxStock = 3

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/grenade_launcher1.wav", 70, math.random(118, 124), 0.3)
	self:EmitSound("npc/attack_helicopter/aheli_mine_drop1.wav", 70, 100, 0.7, CHAN_AUTO + 20)
end
