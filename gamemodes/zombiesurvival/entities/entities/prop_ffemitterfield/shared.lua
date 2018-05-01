ENT.Type = "anim"

ENT.CanPackUp = true
ENT.PackUpTime = 3

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.IgnoreBullets = true
ENT.IgnoreMelee = true
ENT.IgnoreTraces = true
ENT.FizzleStatusAOE = true

AccessorFuncDT(ENT, "Emitter", "Entity", 0)
AccessorFuncDT(ENT, "LastDamaged", "Float", 0)

function ENT:ShouldNotCollide(ent)
	if ent:IsProjectile() then
		local owner = ent:GetOwner()
		if owner:IsValid() then
			if owner:IsHuman() then
				return true
			elseif self:GetEmitter():IsValid() and self:GetEmitter().GetAmmo and self:GetEmitter():GetAmmo() < 1 then
				return true
			end
		end
	end

	local colgroup = ent:GetCollisionGroup()
	if colgroup == COLLISION_GROUP_PLAYER or colgroup == COLLISION_GROUP_WEAPON or colgroup == COLLISION_GROUP_NONE then
		return true
	end

	return false
end
