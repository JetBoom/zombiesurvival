INC_SERVER()

function ENT:Hit(vHitPos, vHitNormal, eHitEntity, vOldVelocity)
	if self:GetHitTime() ~= 0 then return end
	self:SetHitTime(CurTime())

	self:Fire("kill", "", 10)

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = (vHitNormal or Vector(0, 0, -1)) * -1

	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)

	self:SetPos(vHitPos + vHitNormal)

	local alt = self:GetDTBool(0)
	if eHitEntity:IsValid() then
		self:AttachToPlayer(vHitPos, eHitEntity)

		if eHitEntity:IsPlayer() and eHitEntity:Team() ~= TEAM_UNDEAD then
			local strstatus = eHitEntity:GiveStatus(alt and "medrifledefboost" or "strengthdartboost", (alt and 2 or 1) * (self.BuffDuration or 10))
			strstatus.Applier = owner

			local txt = alt and "Defence Shot Gun" or "Strength Shot Gun"

			net.Start("zs_buffby")
				net.WriteEntity(owner)
				net.WriteString(txt)
			net.Send(eHitEntity)

			net.Start("zs_buffwith")
				net.WriteEntity(eHitEntity)
				net.WriteString(txt)
			net.Send(owner)

			eHitEntity:GiveStatus("healdartboost", (self.BuffDuration or 10)/2)
		else
			self:DoRefund(owner)
		end
	else
		self:DoRefund(owner)
	end

	self:SetAngles(vOldVelocity:Angle())

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
		if eHitEntity:IsValid() then
			effectdata:SetEntity(eHitEntity)
		else
			effectdata:SetEntity(NULL)
		end
	util.Effect(alt and "hit_healdart2" or "hit_strengthdart", effectdata)
end
