AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.ChargeTime = 2

function SWEP:PrimaryAttack()
	if self:GetChargeStart() == 0 then
		self:SetChargeStart(CurTime())
		self.Owner:EmitSound("weapons/cguard/charging.wav", 80, 60)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:Think()
	if self:GetCharge() >= 1 then
		self.Owner:Kill()
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:IsMoaning()
	return false
end

function SWEP:Move(mv)
	local charge = self:GetCharge()
	if charge > 0 then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * math.max(0, 1 - charge * 2))
		mv:SetMaxClientSpeed(mv:GetMaxSpeed())
	end
end

function SWEP:SetChargeStart(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetChargeStart()
	return self:GetDTFloat(0)
end

function SWEP:GetCharge()
	if self:GetChargeStart() == 0 then return 0 end

	return math.Clamp((CurTime() - self:GetChargeStart()) / self.ChargeTime, 0, 1)
end
