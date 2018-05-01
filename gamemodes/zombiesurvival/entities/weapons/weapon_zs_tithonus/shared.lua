DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.PrintName = "'Tithonus' Charged Shotgun"
SWEP.Description = "Charges a up shotgun blast of pulse projectiles."

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_357.Single")
SWEP.Primary.Damage = 17.5
SWEP.Primary.NumShots = 4
SWEP.Primary.Delay = 0.85

SWEP.Primary.ClipSize = 18
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 18

SWEP.RequiredClip = 3

SWEP.ConeMax = 5.5
SWEP.ConeMin = 4.25

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-4.65, 4, 0.25)
SWEP.IronSightsAng = Vector(0, 0, 1)

SWEP.Tier = 4

SWEP.ReloadSpeed = 0.2
SWEP.FireAnimSpeed = 0.35
SWEP.MaxCharge = 3
SWEP.ChargeTime = 0.6

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.02)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Triton' Charged Shotgun", "Focuses on firing quickly charged blasts, but reloads slower and has limited range", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 1.3
	wept.Primary.ProjVelocity = 1000
	wept.Primary.NumShots = 3
	wept.Primary.ClipSize = 15
	wept.MaxCharge = 5
	wept.ChargeTime = 0.4
	wept.ReloadSpeed = wept.ReloadSpeed * 0.8
	wept.Primary.Projectile = "projectile_drone_pulse"
end)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "ambient/levels/citadel/extract_loop1.wav")
end

function SWEP:CanPrimaryAttack()
	if self:GetCharging() or self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	if self:Clip1() < self.RequiredClip then
		self:EmitSound(self.DryFireSound)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() or self:GetCharging() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:SetGunCharge(1)
	self:SetLastChargeTime(CurTime())
	self:TakeAmmo()
	self:SetCharging(true)
end

function SWEP:CheckCharge()
	if self:GetCharging() then
		if not self:GetOwner():KeyDown(IN_ATTACK2) then
			self:EmitFireSound()
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * self:GetGunCharge(), self:GetCone())
			self.IdleAnimation = CurTime() + self:SequenceDuration()

			self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
			self:SetCharging(false)
			self:SetLastChargeTime(CurTime())
			self:SetGunCharge(0)
		elseif self:GetGunCharge() < self.MaxCharge and self:Clip1() ~= 0 and self:GetLastChargeTime() + self.ChargeTime < CurTime() then
			self:SetGunCharge(self:GetGunCharge() + 1)
			self:SetLastChargeTime(CurTime())
			self:TakeAmmo()
		end

		self.ChargeSound:PlayEx(1, math.min(255, 165 + self:GetGunCharge() * 18))
	else
		self.ChargeSound:Stop()
	end
end

function SWEP:SetLastChargeTime(lct)
	self:SetDTFloat(8, lct)
end

function SWEP:GetLastChargeTime()
	return self:GetDTFloat(8)
end

function SWEP:SetGunCharge(charge)
	self:SetDTInt(1, charge)
end

function SWEP:GetGunCharge(charge)
	return self:GetDTInt(1)
end

function SWEP:SetCharging(charge)
	self:SetDTBool(1, charge)
end

function SWEP:GetCharging()
	return self:GetDTBool(1)
end

function SWEP:EmitFireSound()
	local deduct = (self:GetGunCharge() - 1) * 15

	self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 72, 111 - deduct, 0.75)
	--self:EmitSound("weapons/physcannon/superphys_launch1.wav", 72, 141 - deduct, 0.65, CHAN_AUTO)
	self:EmitSound("weapons/zs_inner/innershot.ogg", 72, 151 - deduct, 0.65, CHAN_AUTO)
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/physcannon/physcannon_charge.wav", 70, 95, 0.65, CHAN_WEAPON + 21)
		self:EmitSound("items/battery_pickup.wav", 70, 57, 0.85, CHAN_WEAPON + 22)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/ump45/ump45_boltslap.wav", 70, 72)
	end
end
