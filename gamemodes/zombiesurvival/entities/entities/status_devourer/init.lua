INC_SERVER()

function ENT:Think()
	local owner = self:GetOwner()

	if self:GetDamage() <= 0 or owner:Team() == TEAM_UNDEAD then
		self:Remove()
		return
	end

	if not self:GetPuller():IsValid() then
		return
	end

	local puller = self:GetPuller()
	if puller:GetPos():DistToSqr(owner:GetPos()) < 14000 then
		self:Remove()
		return
	end

	local dir = (puller:GetPos() - owner:GetPos())
	dir.z = math.Clamp(dir.z + 35, 0, 65)
	dir = dir:GetNormalized()

	owner:SetGroundEntity(NULL)
	owner:SetVelocity(dir * 380)
	self:SetDamage(self:GetDamage() - 1)

	self:NextThink(CurTime() + 0.12)
	return true
end
