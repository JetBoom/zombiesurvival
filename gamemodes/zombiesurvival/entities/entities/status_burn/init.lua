INC_SERVER()

function ENT:Think()
	local owner = self:GetOwner()

	if self:GetDamage() <= 0 or owner:WaterLevel() > 0 or not owner:Alive() or (owner:Team() == self.Damager:Team() and owner ~= self.Damager) then
		self:Remove()
		return
	end

	local dmg = math.Clamp(self:GetDamage(), 1, 2)

	owner:TakeSpecialDamage(dmg, DMG_BURN, self.Damager and self.Damager:IsValid() and self.Damager:IsPlayer() and self.Damager:Team() ~= owner:Team() and self.Damager or owner, self)
	self:AddDamage(-dmg)

	self:NextThink(CurTime() + 0.5)
	return true
end
