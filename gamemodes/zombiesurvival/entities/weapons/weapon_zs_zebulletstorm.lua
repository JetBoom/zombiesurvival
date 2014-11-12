AddCSLuaFile()

SWEP.Base = "weapon_zs_bulletstorm"

SWEP.Primary.Damage = 60

SWEP.WalkSpeed = SPEED_ZOMBIEESCAPE_SLOW

SWEP.Primary.KnockbackScale = ZE_KNOCKBACKSCALE
SWEP.Primary.DefaultClip = 99999

function SWEP:SetIronsights(b)
	if self:GetIronsights() ~= b then
		if b then
			self.Primary.NumShots = self.Primary.IronsightsNumShots
			self.Primary.Delay = self.Primary.IronsightsDelay

			self:EmitSound("npc/scanner/scanner_scan4.wav", 40)
		else
			self.Primary.NumShots = self.Primary.DefaultNumShots
			self.Primary.Delay = self.Primary.DefaultDelay

			self:EmitSound("npc/scanner/scanner_scan2.wav", 40)
		end
	end

	self:SetDTBool(0, b)

	if self.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(self.IronSightsHoldType)
		else
			self:SetWeaponHoldType(self.HoldType)
		end
	end

	gamemode.Call("WeaponDeployed", self.Owner, self)
end

function SWEP:CanPrimaryAttack()
	if self:GetIronsights() and self:Clip1() == 1 then
		self:SetIronsights(false)
	end

	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:TakeAmmo()
	if self:GetIronsights() then
		self:TakePrimaryAmmo(2)
	else
		self:TakePrimaryAmmo(1)
	end
end
