SWEP.PrintName = "'Avelyn' Multi Crossbow"
SWEP.Description = "A triple loaded crossbow. Slow to reload, but very high burst damage."

SWEP.Base = "weapon_zs_baseproj"
DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/crossbow/fire1.wav")
SWEP.Primary.ClipSize = 3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Delay = 0.75
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Damage = 74
SWEP.Primary.BurstShots = 3

SWEP.ConeMax = 2.25
SWEP.ConeMin = 2

SWEP.Recoil = 1

SWEP.ReloadSpeed = 0.4

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.04)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()

	self:SetNextShot(CurTime())
	self:SetShotsLeft(self.Primary.BurstShots)

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:Think()
	BaseClass.Think(self)

	local shotsleft = self:GetShotsLeft()
	if shotsleft > 0 and CurTime() >= self:GetNextShot() then
		self:SetShotsLeft(shotsleft - 1)
		self:SetNextShot(CurTime() + self:GetFireDelay()/6)

		if self:Clip1() > 0 and self:GetReloadFinish() == 0 then
			self:EmitFireSound()
			self:TakeAmmo()
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())

			self.IdleAnimation = CurTime() + self:SequenceDuration()
		else
			self:SetShotsLeft(0)
		end
	end
end

function SWEP:SetNextShot(nextshot)
	self:SetDTFloat(5, nextshot)
end

function SWEP:GetNextShot()
	return self:GetDTFloat(5)
end

function SWEP:SetShotsLeft(shotsleft)
	self:SetDTInt(1, shotsleft)
end

function SWEP:GetShotsLeft()
	return self:GetDTInt(1)
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/crossbow/reload1.wav", 70, 110)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/galil/galil_boltpull.wav", 70, 110)
	end
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/crossbow/fire1.wav", 70, 120, 0.7)
	self:EmitSound("weapons/crossbow/bolt_skewer1.wav", 70, 193, 0.7, CHAN_AUTO)
end
