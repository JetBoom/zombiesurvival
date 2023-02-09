INC_SERVER()

ENT.Heal = 10
ENT.PointsMultiplier = 1.25
ENT.Gravity = false

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

		if eHitEntity:IsPlayer() then
			if eHitEntity:Team() == TEAM_UNDEAD then
				if self.PointsMultiplier then
					POINTSMULTIPLIER = self.PointsMultiplier
				end
				eHitEntity:TakeSpecialDamage(self.ProjDamage or 60, DMG_GENERIC, owner, source, hitpos)
				if self.PointsMultiplier then
					POINTSMULTIPLIER = nil
				end

				local status = eHitEntity:GiveStatus(alt and "zombiestrdebuff" or "zombiedartdebuff")
				status.DieTime = CurTime() + (self.BuffDuration or 10)
				status.Applier = owner
			elseif eHitEntity:Team() == TEAM_HUMAN then
				local ehithp, ehitmaxhp = eHitEntity:Health(), eHitEntity:GetMaxHealth()

				if eHitEntity:IsSkillActive(SKILL_D_FRAIL) and ehithp >= ehitmaxhp * 0.25 then
					owner:CenterNotify(COLOR_RED, translate.Format("frail_healdart_warning", eHitEntity:GetName()))
					self:EmitSound("buttons/button8.wav", 70, math.random(115,128))
					self:DoRefund(owner)
				elseif not (owner:IsSkillActive(SKILL_RECLAIMSOL) and ehithp >= ehitmaxhp) then
					local status = eHitEntity:GiveStatus(alt and "strengthdartboost" or "medrifledefboost", (alt and 1 or 2) * (self.BuffDuration or 10))
					status.Applier = owner

					owner:HealPlayer(eHitEntity, self.Heal)

					local txt = alt and "Strength Rifle" or "Medical Rifle"

					net.Start("zs_buffby")
						net.WriteEntity(owner)
						net.WriteString(txt)
					net.Send(eHitEntity)

					net.Start("zs_buffwith")
						net.WriteEntity(eHitEntity)
						net.WriteString(txt)
					net.Send(owner)
				else
					self:DoRefund(owner)
				end
			end
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
	util.Effect(alt and "hit_strengthdart" or "hit_healdart2", effectdata)
end
