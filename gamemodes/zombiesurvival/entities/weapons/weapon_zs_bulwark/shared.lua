SWEP.PrintName = "'Bulwark' Minigun"
SWEP.Description = "Incredibly heavy duty minigun. Takes time to spool. Hold right click to spool the gun without firing."

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.Primary.Damage = 24
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.22

SWEP.Primary.ClipSize = 150
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Secondary.Automatic = true

SWEP.ConeMax = 6.15
SWEP.ConeMin = 5.25

SWEP.Recoil = 0.5

SWEP.Tier = 5
SWEP.MaxStock = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.769)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.656)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Citadel' Minicannon", "Uses 3 ammo per shot, shoots slower, but more damage and accuracy", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 2.5
	wept.ConeMin = wept.ConeMin * 0.5
	wept.ConeMax = wept.ConeMax * 0.5
	wept.Primary.Delay = wept.Primary.Delay * 2.65
	wept.Recoil = 4

	wept.TakeAmmo = function(self)
		self:TakeCombinedPrimaryAmmo(3)
	end

	wept.GetFireDelay = function(self)
		return self.BaseClass.GetFireDelay(self) - (self:GetSpool() * 0.35)
	end

	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/m249/m249-1.wav", 75, math.random(47, 49), 0.7)
		self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 75, math.random(85, 87), 0.65, CHAN_WEAPON + 20)
	end
end)

SWEP.WalkSpeed = SPEED_SLOWEST * 0.75
SWEP.FireAnimSpeed = 0.3

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "ambient/machines/spin_loop.wav")
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	if not self:GetSpooling() then
		self:SetSpooling(true)
		self:EmitSound("ambient/machines/spinup.wav", 75, 65)
		self:GetOwner():ResetSpeed()

		self:SetNextPrimaryFire(CurTime() + 0.75)
	else
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	if not self:GetSpooling() then
		self:SetSpooling(true)
		self:EmitSound("ambient/machines/spinup.wav", 75, 65)
		self:GetOwner():ResetSpeed()

		self:SetNextPrimaryFire(CurTime() + 0.75)
	else
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:TakeAmmo()
	self:TakeCombinedPrimaryAmmo(1)
end

function SWEP:CanPrimaryAttack()
	if self:GetPrimaryAmmoCount() <= 0 then
		return false
	end

	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:GetWalkSpeed()
	return self.BaseClass.GetWalkSpeed(self) * (self:GetSpooling() and 0.5 or 1)
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/m249/m249-1.wav", 75, math.random(86, 89), 0.65)
	self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 75, math.random(122, 125), 0.6, CHAN_WEAPON + 20)
end

function SWEP:Reload()
end

function SWEP:Holster()
	self.ChargeSound:Stop()

	return self.BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self.ChargeSound:Stop()
end

function SWEP:SetSpool(spool)
	self:SetDTFloat(9, spool)
end

function SWEP:GetSpool()
	return self:GetDTFloat(9)
end

function SWEP:SetSpooling(isspool)
	self:SetDTBool(1, isspool)
end

function SWEP:GetSpooling()
	return self:GetDTBool(1)
end

function SWEP:GetFireDelay()
	return self.BaseClass.GetFireDelay(self) - (self:GetSpool() * 0.15)
end

function SWEP:CheckSpool()
	if self:GetSpooling() then
		if not self:GetOwner():KeyDown(IN_ATTACK) and not self:GetOwner():KeyDown(IN_ATTACK2) then
			self:SetSpooling(false)
			self:GetOwner():ResetSpeed()
			self:SetNextPrimaryFire(CurTime() + 0.75)
			self:EmitSound("ambient/machines/spindown.wav", 75, 150)
		else
			self:SetSpool(math.min(self:GetSpool() + FrameTime() * 0.12, 1))
		end

		self.ChargeSound:PlayEx(1, math.min(255, 65 + self:GetSpool() * 25))
	else
		self:SetSpool(math.max(0, self:GetSpool() - FrameTime() * 0.36))
		self.ChargeSound:Stop()
	end
end
