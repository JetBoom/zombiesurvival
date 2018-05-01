INC_SERVER()

function SWEP:PlayRepairSound(hitent)
	hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if CLIENT or not hitent:IsValid() then return end

	local owner = self:GetOwner()

	if hitent.HitByWrench and hitent:HitByWrench(self, owner, tr) then
		return
	end

	if hitent.GetObjectHealth then
		local oldhealth = hitent:GetObjectHealth()
		if oldhealth <= 0 or oldhealth >= hitent:GetMaxObjectHealth() or hitent.m_LastDamaged and CurTime() < hitent.m_LastDamaged + 4 then return end

		local healstrength = self.HealStrength * (owner.RepairRateMul or 1) * (hitent.WrenchRepairMultiplier or 1)

		hitent:SetObjectHealth(math.min(hitent:GetMaxObjectHealth(), hitent:GetObjectHealth() + healstrength))
		local healed = hitent:GetObjectHealth() - oldhealth
		self:PlayRepairSound(hitent)
		gamemode.Call("PlayerRepairedObject", owner, hitent, healed / 2, self)

		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetMagnitude(1)
		util.Effect("nailrepaired", effectdata, true, true)

		return true
	end
end
