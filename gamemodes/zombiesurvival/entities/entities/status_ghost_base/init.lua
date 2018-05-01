INC_SERVER()

function ENT:Think()
	self:RecalculateValidity()

	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:GetActiveWeapon():IsValid() and owner:GetActiveWeapon():GetClass() == self.GhostWeapon) then
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end
