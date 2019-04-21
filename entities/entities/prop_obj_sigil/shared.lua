ENT.Type = "anim"

ENT.MaxHealth = 2000
ENT.HealthRegen = 40
ENT.RegenDelay = 2

ENT.ModelScale = 0.55

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.IsBarricadeObject = true

AccessorFuncDT(ENT, "SigilHealthBase", "Float", 0)
AccessorFuncDT(ENT, "SigilHealthRegen", "Float", 1)
AccessorFuncDT(ENT, "SigilLastDamaged", "Float", 2)

function ENT:SetSigilCorrupted(corrupt)
	self.IsBarricadeObject = not corrupt

	if SERVER then
		self:SetCollisionGroup(corrupt and COLLISION_GROUP_DEBRIS_TRIGGER or COLLISION_GROUP_NONE)
	end

	self:CollisionRulesChanged()

	self:SetDTBool(0, corrupt)
end

function ENT:GetSigilCorrupted()
	return self:GetDTBool(0)
end

function ENT:SetSigilHealth(health)
	self:SetSigilHealthBase(health)

	self:SetSigilLastDamaged(math.max(self:GetSigilLastDamaged(), self:GetSigilHealthRegen() - self.RegenDelay))
end

function ENT:GetSigilHealth()
	local base = self:GetSigilHealthBase()
	if base == 0 then return 0 end

	return math.Clamp(base + self:GetSigilHealthRegen() * math.max(0, CurTime() - (self:GetSigilLastDamaged() + self.RegenDelay)), 0, self.MaxHealth)
end

function ENT:GetSigilMaxHealth()
	return self.MaxHealth
end

function ENT:CanBeDamagedByTeam(teamid)
	if self:GetSigilCorrupted() then
		return teamid == TEAM_HUMAN
	end

	return teamid == TEAM_UNDEAD
end
