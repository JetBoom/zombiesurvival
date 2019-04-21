INC_SERVER()

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	local secondary = self:IsCharging()

	if secondary then
		self.OriginalMeleeDamage = self.MeleeDamage
		self.OriginalMeleeKnockBack = self.MeleeKnockBack
		self.MeleeDamage = self.MeleeDamage * self.MeleeDamageSecondaryMul
		self.MeleeKnockBack = self.MeleeKnockBack * self.MeleeKnockBackSecondaryMul
	end

	local owner = self:GetOwner()
	if hitent:IsValid() and hitent:IsPlayer() then
		hitent:AddLegDamageExt(secondary and 18 or 15, owner, self, SLOWTYPE_COLD)
	end

	if tr.HitWorld and tr.HitNormal.z > 0.8 and hitent == Entity(0) and secondary then
		local ice = ents.Create("env_protrusionspike")
		if ice:IsValid() then
			ice:SetPos(tr.HitPos)
			ice:SetOwner(owner)
			ice.Damage = self.MeleeDamage * 0.85
			ice.Team = owner:Team()
			ice:Spawn()
		end
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if self:IsCharging() then
		self.MeleeDamage = self.OriginalMeleeDamage
		self.MeleeKnockBack = self.OriginalMeleeKnockBack
	end
end
