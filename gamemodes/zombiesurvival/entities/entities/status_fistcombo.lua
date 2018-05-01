AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:AddCounter(counter)
	local owner = self:GetOwner()
	if owner.LastStunned and owner.LastStunned + 3 > CurTime() then return end

	if self:GetCounter() + counter >= 4 then
		owner:AddLegDamage(18)
		owner:AddArmDamage(18)
		owner:EmitSound("weapons/crowbar/crowbar_impact1.wav", 75, math.random(60, 65))
		self:Remove()
	else
		self:SetCounter(self:GetCounter() + counter)
	end
end

function ENT:SetCounter(counter)
	self:SetDTFloat(0, math.max(0, counter))
end

function ENT:GetCounter()
	return self:GetDTFloat(0)
end

if CLIENT then return end

function ENT:Think()
	self.BaseClass.Think(self)

	local owner = self:GetOwner()

	if not owner:Alive() or owner:Team() == TEAM_HUMAN then
		self:Remove()
	end
end
