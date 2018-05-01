SWEP.PrintName = "'Broadside' Missile Launcher"
SWEP.Description = "Launches missiles that deal considerable AOE explosive damage. Right click remotely detonates them."

SWEP.UseHands = false

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "rpg"

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Delay = 1.2
SWEP.Primary.ClipSize = 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Damage = 107

SWEP.ReloadSound = Sound("vehicles/tank_readyfire1.wav")
SWEP.Primary.Sound = Sound("weapons/stinger_fire1.wav")

SWEP.ReloadSpeed = 0.55
SWEP.Recoil = 3

SWEP.ConeMin = 0.0001
SWEP.ConeMax = 0.0001

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_RPG

SWEP.WalkSpeed = SPEED_SLOWEST * 0.85

SWEP.FireAnimSpeed = 0.75

SWEP.Tier = 5
SWEP.MaxStock = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Salvo' Micro-missile Launcher", "Rapidly fires miniature missiles that use 33% ammo", function(wept)
	wept.Primary.Delay = wept.Primary.Delay * 0.24
	wept.Primary.Automatic = true
	wept.Recoil = 0
	wept.Primary.Damage = wept.Primary.Damage * 0.3
	wept.FireAnimSpeed = 1.1

	wept.EmitFireSound = function(self)
		self:EmitSound(self.Primary.Sound, 75, math.random(218, 223), 0.6)
		self:EmitSound("weapons/grenade_launcher1.wav", 75, math.random(126, 132), 0.5, CHAN_WEAPON + 20)
	end
	wept.EntModify = function(self, ent)
		ent:SetDTBool(0, true)
		ent.ProjTaper = self.Primary.ProjExplosionTaper

		local owner = self:GetOwner()
		owner.RemoteDetRocket = ent

		self:SetNextSecondaryFire(CurTime() + 0.2)
	end

	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:EmitFireSound()

		local altuse = self:GetDTInt(10)
		if altuse == 0 then
			self:TakeAmmo()
		end
		self:SetDTInt(10, (altuse - 1) % 3)

		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	wept.ConeMax = 3
	wept.ConeMin = 1.5
end)


function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(118, 123), 0.8)
	self:EmitSound("weapons/grenade_launcher1.wav", 80, math.random(76, 82), 0.7, CHAN_WEAPON + 20)
end
