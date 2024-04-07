ENT.Type = "anim"
ENT.Base = "status__base"

ENT.DamagePerTick = 3

ENT.Ephemeral = true

function ENT:Initialize()
	self:DrawShadow(false)
	if self:GetDTFloat(1) == 0 then
		self:SetDTFloat(1, CurTime())
	end
end

function ENT:AddDamage(damage, attacker)
	self:SetDamage(self:GetDamage() + damage)

	if SERVER and attacker then
		self.Attackers[attacker] = (self.Attackers[attacker] or 0) + damage
	end
end

function ENT:SetDamage(damage)
	self:SetDTFloat(0, math.min(GAMEMODE.MaxPoisonDamage or 1000, damage))
end

function ENT:GetDamage()
	return self:GetDTFloat(0)
end
