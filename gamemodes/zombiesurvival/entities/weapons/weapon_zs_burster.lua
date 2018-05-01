AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.ChargeTime = 2.1

function SWEP:PrimaryAttack()
	if self:GetChargeStart() == 0 then
		self:SetChargeStart(CurTime())

		self.m_ViewAngles = self:GetOwner():EyeAngles()

		if IsFirstTimePredicted() then
			self:EmitSound(")ambient/levels/labs/teleport_mechanism_windup5.wav", 80, 185, 0.75)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:Think()
	if self:GetCharge() >= 1 then
		self:GetOwner():Kill()
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
		local mul = 1 + charge * 0.7
		mv:SetMaxSpeed(mv:GetMaxSpeed() * mul)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * mul)
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
