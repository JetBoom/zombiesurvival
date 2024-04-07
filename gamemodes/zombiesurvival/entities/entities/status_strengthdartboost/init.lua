INC_SERVER()

function ENT:SetDie(fTime)
	if fTime == 0 or not fTime then
		self.DieTime = 0
	elseif fTime == -1 then
		self.DieTime = 999999999
	else
		self.DieTime = CurTime() + fTime
		self:SetDuration(fTime)
	end
end

function ENT:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker ~= self:GetOwner() then return end

	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN --[[and inflictor == wep and wep.IsMelee]] then
		local dmg = dmginfo:GetDamage()
		local extradamage = dmg * 0.25
		dmginfo:SetDamage(dmg + extradamage)

		if self.Applier and self.Applier:IsValidLivingHuman() and ent:IsPlayer() and ent:Team() == TEAM_ZOMBIE then
			local applier = self.Applier

			ent.DamagedBy[applier] = (ent.DamagedBy[applier] or 0) + extradamage
			applier.StrengthBoostDamage = (applier.StrengthBoostDamage or 0) + extradamage
			local points = extradamage / ent:GetMaxHealth() * ent:GetZombieClassTable().Points
			applier.PointQueue = applier.PointQueue + points * 1.5

			local pos = ent:GetPos()
			pos.z = pos.z + 32
			applier.LastDamageDealtPos = pos
			applier.LastDamageDealtTime = CurTime()
		end
	end
end
