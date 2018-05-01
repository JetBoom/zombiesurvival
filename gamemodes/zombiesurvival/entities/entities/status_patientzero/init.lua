INC_SERVER()

function ENT:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker == self:GetOwner() and attacker:IsValidLivingZombie() then
		local dmg = dmginfo:GetDamage()
		local extradamage = dmg * 0.15
		dmginfo:SetDamage(dmg + extradamage)

		if ent:IsValidLivingHuman() and dmg >= 15 and math.random(4) == 1 then
			ent:GiveStatus(math.random(2) == 1 and "enfeeble" or "frightened", 5)
		end
	end

	if ent == self:GetOwner() and attacker:IsValidHuman() then
		if bit.band(dmginfo:GetDamageType(), DMG_SLASH) == 0 and bit.band(dmginfo:GetDamageType(), DMG_CLUB) == 0 then
			dmginfo:SetDamage(dmginfo:GetDamage() * 0.9)
		else
			dmginfo:SetDamage(dmginfo:GetDamage() * 1.2)
		end
	end
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:IsValidLivingZombie() and not owner:GetZombieClassTable().Boss) then self:Remove() end
end
