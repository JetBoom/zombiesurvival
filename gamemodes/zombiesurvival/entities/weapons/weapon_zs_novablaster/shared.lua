SWEP.PrintName = "'Nova Blaster' Pulse Revolver"
SWEP.Description = "Combines the ricochet properties of the magnum into a bouncing pulse projectile, that slows zombies."

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_357.Single")
SWEP.Primary.Delay = 0.65
SWEP.Primary.Damage = 46
SWEP.Primary.NumShots = 1

SWEP.Primary.ClipSize = 27
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 27

SWEP.RequiredClip = 3

SWEP.ConeMax = 3.5
SWEP.ConeMin = 1.75

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-4.65, 4, 0.25)
SWEP.IronSightsAng = Vector(0, 0, 1)

SWEP.Tier = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.7, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.4, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Nova Helix' Pulse Revolver", "Fires two projectiles in a wavy formation", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.6
	wept.Primary.ProjVelocity = 450
	wept.Primary.NumShots = 2
	wept.Primary.ClipSize = 18
	wept.SameSpread = true
	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTBool(0, true)
			ent.Branch = true
		end
	end
end)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 72, 219, 0.75)
	self:EmitSound("weapons/physcannon/superphys_launch1.wav", 72, 208, 0.65, CHAN_AUTO)
end
