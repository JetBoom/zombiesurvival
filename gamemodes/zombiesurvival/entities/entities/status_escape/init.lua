INC_SERVER()

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer:SendLua("MySelf:EmitSound(\"doors/door_latch3.wav\", 50, 35, 0.5)")

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	hook.Add("EntityTakeDamage", self, self.EntityTakeDamage)
end

function ENT:Think()
	local owner = self:GetOwner()
	local froms = self:GetFromExit()

	if CurTime() >= self:GetEndTime() then

		self:Remove()
	end

	if froms and froms:IsValid() and not froms:IsWeapon() and (froms:GetSigilCorrupted() or owner:GetPos():DistToSqr(froms:GetPos()) > 16384) then
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end

