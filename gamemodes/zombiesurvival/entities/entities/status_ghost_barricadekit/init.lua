INC_SERVER()

function ENT:Think()
	self:RecalculateValidity()

	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:GetActiveWeapon():IsValid() and owner:GetActiveWeapon():GetClass() == "weapon_zs_barricadekit") then
		self:Remove()
		return
	end
	self:NextThink(CurTime() + 0.05)
	return true
end
