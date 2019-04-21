INC_SERVER()

function ENT:Think()
	local owner = self:GetOwner()

	if owner:GetStatus("shockdebuff") or self:GetHealLeft() <= 0 or owner.BossHealRemaining and owner.BossHealRemaining <= 0 then
		self:Remove()
		return
	end

	local zombieclasstbl = owner:GetZombieClassTable()
	local heal = math.Clamp(self:GetHealLeft(), 1, 5) * (zombieclasstbl.SkeletalRes and 0.36 or 1)

	local ehp = zombieclasstbl.Boss and owner:GetMaxHealth() * 0.4 or owner:GetMaxHealth() * 1.25

	if owner.BossHealRemaining and owner.BossHealRemaining > 0 then
		owner.BossHealRemaining = owner.BossHealRemaining - heal
	end

	owner:SetHealth(math.min(ehp, owner:Health() + heal))
	self:SetHealLeft(self:GetHealLeft() - heal)

	self:NextThink(CurTime() + 0.1)
	return true
end
