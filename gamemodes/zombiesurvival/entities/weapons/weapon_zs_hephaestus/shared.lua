SWEP.PrintName = "'Hephaestus' Tau Cannon"
SWEP.Description = "Also known as the Gauss Gun. Launches tau projectiles at incredibly high speeds."

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/gauss/fire1.wav")
SWEP.Primary.Damage = 26.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 30

SWEP.ConeMax = 3
SWEP.ConeMin = 1.5

SWEP.HeadshotMulti = 1.5

SWEP.ChargeDelay = 0.12

SWEP.Tier = 5

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Prometheus' Tau Cannon", "Bounces at low angles, three weaker shots, charges faster, increased fire delay", function(wept)
	wept.Primary.Delay = wept.Primary.Delay * 1.4
	wept.Primary.Damage = wept.Primary.Damage * 1.2/3
	wept.Primary.NumShots = 3

	wept.ChargeDelay = 0.08

	local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
		attacker.RicochetBullet = true
		if attacker:IsValid() then
			attacker:FireBulletsLua(hitpos, 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, 0, 1, damage, nil, nil, "tracer_heph_alt", nil, nil, nil, nil, nil, attacker:GetActiveWeapon())
		end
		attacker.RicochetBullet = nil
	end
	wept.BulletCallback = function(attacker, tr, dmginfo)
		if SERVER and tr.HitWorld and not tr.HitSky and tr.HitNormal:Dot(tr.Normal) > -0.2 then
			local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * 1.2
			timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
		end

		return {impact = false}
	end
end)

SWEP.WalkSpeed = SPEED_SLOW
SWEP.FireAnimSpeed = 1

SWEP.TracerName = "tracer_heph"

function SWEP:TakeAmmo()
	self:TakeCombinedPrimaryAmmo(1)

	if CLIENT then
		self.LastVel = 7
	end
end

function SWEP:Reload()
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "weapons/gauss/chargeloop.wav")
end

function SWEP:CanPrimaryAttack()
	if self:GetPrimaryAmmoCount() <= 0 then
		return false
	end

	if self:GetCharging() or self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() or self:GetCharging() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:SetLastChargeTime(CurTime())
	self:TakeAmmo()
	self:SetCharging(true)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	return {impact = false}
end

function SWEP:CheckCharge()
	if self:GetCharging() then
		local owner = self:GetOwner()
		if not owner:KeyDown(IN_ATTACK2) then
			self:EmitFireSound()

			self.FireAnimSpeed = 0.3
			self:ShootBullets(self.Primary.Damage * self:GetGunCharge(), self.Primary.NumShots, self:GetCone())
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self.FireAnimSpeed = 1

			owner:SetGroundEntity(NULL)
			owner:SetVelocity(-34 * self:GetGunCharge() * owner:GetAimVector())

			self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 4)
			self:SetCharging(false)
			self:SetLastChargeTime(CurTime())
			self:SetGunCharge(0)
		elseif self:GetGunCharge() < 13 and self:GetPrimaryAmmoCount() ~= 0 and self:GetLastChargeTime() + self.ChargeDelay < CurTime() then
			self:SetGunCharge(self:GetGunCharge() + 1)
			self:SetLastChargeTime(CurTime())
			self:TakeAmmo()
		end

		self.ChargeSound:PlayEx(1, math.min(255, 47 + self:GetGunCharge() * 16))
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
	local deduct = self:GetCharging() and 100 - self:GetGunCharge() or 100
	local owner = self:GetOwner()

	self:EmitSound("weapons/gauss/fire1.wav", 75, deduct, 0.9)
	timer.Simple(0.2, function()
		if self:IsValid() and owner:IsValid() and not owner:KeyDown(IN_ATTACK) then
			self:EmitSound("weapons/zs_heph/electro"..math.random(4,6)..".wav", 75, deduct, 0.75, CHAN_WEAPON + 20)
		end
	end)
end
