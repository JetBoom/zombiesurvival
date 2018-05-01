ENT.Type = "anim"

ENT.MaxHealth = 350

ENT.ModelScale = Vector(1, 1, 0.5)

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.IsCreeperNest = true

AccessorFuncDT(ENT, "NestHealth", "Float", 0)
AccessorFuncDT(ENT, "NestBuilt", "Bool", 0)
AccessorFuncDT(ENT, "NestLastDamaged", "Float", 1)
AccessorFuncDT(ENT, "NestOwner", "Entity", 0)

function ENT:SetNestBuilt(b)
	self:SetDTBool(0, b)
	self:CollisionRulesChanged()
end

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() --and (not self:GetNestBuilt() or ent:Team() == TEAM_UNDEAD)
end

function ENT:GetNestMaxHealth()
	return self.MaxHealth
end
