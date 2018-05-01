SWEP.PrintName = "'Smelter' Flak Cannon"
SWEP.Description = "Launches a spray of hot shards of scrap in a flak pattern."

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "crossbow"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"

SWEP.UseHands = false

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_Crossbow.Single")
SWEP.Primary.Delay = 1.25
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 20.5
SWEP.Primary.NumShots = 7

SWEP.Primary.ClipSize = 6
SWEP.Primary.Ammo = "scrap"
SWEP.Primary.DefaultClip = 15

SWEP.Recoil = 7

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 5
SWEP.MaxStock = 2

SWEP.ConeMax = 6.5
SWEP.ConeMin = 5.75

SWEP.ReloadSpeed = 0.45

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05)

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/g3sg1/g3sg1_slide.wav", 75, 45, 1, CHAN_WEAPON + 23)
		self:EmitSound("weapons/ump45/ump45_boltslap.wav", 70, 47, 0.85, CHAN_WEAPON + 24)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/galil/galil_boltpull.wav", 70, 110)
		self:EmitSound("weapons/zs_flak/load1.wav", 75, 100, 0.85, CHAN_WEAPON + 20)
	end
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed * 0.25)

	timer.Simple(0.4, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_DRAW)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed * 10.5)
		end
	end)

	timer.Simple(0.55, function()
		if IsValid(self) and self:GetOwner() == MySelf and self:Clip1() > 0 then
			self:EmitSound("weapons/zs_flak/load1.wav", 75, 100, 0.85, CHAN_WEAPON + 20)
		end
	end)
end

function SWEP:EmitFireSound(secondary)
	self:EmitSound(secondary and "weapons/stinger_fire1.wav" or "doors/door_metal_thin_close2.wav", 75, secondary and 250 or 70, 0.65)
	self:EmitSound("weapons/shotgun/shotgun_fire6.wav", 75, secondary and 105 or 115, 0.55, CHAN_WEAPON + 20)
	self:EmitSound("weapons/zs_flak/shot1.wav", 70, secondary and 65 or 100, 0.65, CHAN_WEAPON + 21)
end

function SWEP:SetLastFired(float)
	self:SetDTFloat(8, float)
end

function SWEP:GetLastFired()
	return self:GetDTFloat(8)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:SetLastFired(CurTime())

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SecondaryAttack()
	if self:Clip1() <= 1 or not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 1.2)
	self:SetLastFired(CurTime())

	self:EmitFireSound(true)
	self:TakeAmmo(); self:TakeAmmo()

	self.Primary.Projectile = "projectile_flakbomb"
	self.Primary.ProjVelocity = 1000

	self:ShootBullets(self.Primary.Damage, 1, self:GetCone()/2)

	self.Primary.Projectile = "projectile_flak"
	self.Primary.ProjVelocity = 1500

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end
