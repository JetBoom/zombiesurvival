INC_SERVER()

function ENT:EntityTakeDamage(ent, dmginfo)
	if ent ~= self:GetOwner() then return end

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
		dmginfo:SetDamage(dmginfo:GetDamage() * self.DamageScale)
	end
end

function ENT:PlayerHurt(victim, attacker, healthleft, damage)
	local applier = self.Applier
	if applier and applier:IsValidLivingZombie() and applier ~= attacker and victim:IsValidLivingHuman() then
		local attributeddamage = damage
		if healthleft < 0 then
			attributeddamage = attributeddamage + healthleft
		end

		if attributeddamage > 0 then
			attributeddamage = attributeddamage - (attributeddamage / self.DamageScale)

			applier.DamageDealt[TEAM_UNDEAD] = applier.DamageDealt[TEAM_UNDEAD] + attributeddamage
			applier:AddLifeHumanDamage(attributeddamage)
		end
	end
end

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
