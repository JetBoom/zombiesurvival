INC_SERVER()

function ENT:Think()
	self:RecalculateValidity()

	local owner = self:GetOwner()
	if not owner:IsValid() then
		self:Remove()
		return
	end

	-- One call to the active weapon instead of three in a row
	-- (IsValid + GetClass, each through the metatable).
	local wep = owner:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() ~= self.GhostWeapon then
		self:Remove()
		return
	end

	self:NextThink(CurTime() + 0.05)
	return true
end