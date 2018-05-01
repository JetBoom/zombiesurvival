INC_SERVER()

function ENT:EntityTakeDamage(ent, dmginfo)
	if ent ~= self:GetOwner() then return end

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValidHuman() then
		dmginfo:SetDamage(dmginfo:GetDamage() * 1.25)
	end
end

function ENT:PlayerHurt(victim, attacker, healthleft, damage)
	local applier = self.Applier
	if applier and applier:IsValidLivingHuman() and applier ~= attacker and victim:IsValidLivingZombie() then
		local attributeddamage = damage
		if healthleft < 0 then
			attributeddamage = attributeddamage + healthleft
		end

		if attributeddamage > 0 then
			attributeddamage = attributeddamage - (attributeddamage / 1.25)

			applier.DamageDealt[TEAM_HUMAN] = applier.DamageDealt[TEAM_HUMAN] + attributeddamage
			victim.DamagedBy[applier] = (victim.DamagedBy[applier] or 0) + attributeddamage

			local points = attributeddamage / victim:GetMaxHealth() * victim:GetZombieClassTable().Points
			applier.PointQueue = applier.PointQueue + points

			local pos = victim:GetPos()
			pos.z = pos.z + 32
			applier.LastDamageDealtPos = pos
			applier.LastDamageDealtTime = CurTime()
		end
	end
end
