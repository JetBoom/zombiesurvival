INC_SERVER()

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer:SendLua("MySelf:EmitSound(\"buttons/button1.wav\", 50, 35, 0.5)")

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	hook.Add("EntityTakeDamage", self, self.EntityTakeDamage)
end

function ENT:Think()
	local owner = self:GetOwner()
	local froms = self:GetFromSigil()

	if CurTime() >= self:GetEndTime() then
		if self:GetTargetSigil():IsValid() then
			owner:DoSigilTeleport(self:GetTargetSigil(), froms, self:GetClass() == "status_corruptedteleport")
		end

		self:Remove()
	end

	if froms and froms:IsValid() and not froms:IsWeapon() and (froms:GetSigilCorrupted() or owner:GetPos():DistToSqr(froms:GetPos()) > 16384) then
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end

function ENT:EntityTakeDamage(ent, dmginfo)
	if ent == self:GetOwner() and not dmginfo:GetInflictor().IsStatus then
		self:SetStartTime(CurTime())
		self:SetEndTime(CurTime() + 2 * (ent.SigilTeleportTimeMul or 1))
	end
end
