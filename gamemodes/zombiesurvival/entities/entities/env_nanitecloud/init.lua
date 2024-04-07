INC_SERVER()

ENT.TickTime = 1
ENT.Ticks = 10
ENT.HealPower = 17.5

function ENT:Initialize()
	local owner = self:GetOwner()

	self:DrawShadow(false)
	self.Ticks = math.floor(self.Ticks * (owner:IsValidLivingHuman() and owner.CloudTime or 1))

	self:Fire("heal", "", self.TickTime)
	self:Fire("kill", "", self.TickTime * self.Ticks + 0.01)
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name ~= "heal" then return end

	self.Ticks = self.Ticks - 1

	local owner = self:GetOwner()
	if not owner:IsValidLivingHuman() then owner = self end

	local pos = self:GetPos()
	local totalheal = self.HealPower * (self:GetOwner().RepairRateMul or 1)

	for _, hitent in pairs(ents.FindInSphere(pos, self.Radius * (owner.CloudRadius or 1))) do
		if not hitent:IsValid() or hitent == self or not WorldVisible(pos, hitent:NearestPoint(pos)) then
			continue
		end

		local healed = false

		if hitent:IsNailed() then
			local oldhealth = hitent:GetBarricadeHealth()
			if oldhealth <= 0 or oldhealth >= hitent:GetMaxBarricadeHealth() or hitent:GetBarricadeRepairs() <= 0.01 then continue end

			hitent:SetBarricadeHealth(math.min(hitent:GetMaxBarricadeHealth(), hitent:GetBarricadeHealth() + math.min(hitent:GetBarricadeRepairs(), totalheal)))
			healed = hitent:GetBarricadeHealth() - oldhealth
			hitent:SetBarricadeRepairs(math.max(hitent:GetBarricadeRepairs() - healed, 0))

		elseif hitent.GetObjectHealth then
			-- Taking the nil tr parameter for granted for now
			if hitent.HitByWrench and hitent:HitByWrench(self, owner, nil) then continue end

			local oldhealth = hitent:GetObjectHealth()
			if oldhealth <= 0 or oldhealth >= hitent:GetMaxObjectHealth() or hitent.m_LastDamaged and CurTime() < hitent.m_LastDamaged + 4 then continue end

			hitent:SetObjectHealth(math.min(hitent:GetMaxObjectHealth(), hitent:GetObjectHealth() + totalheal/2))
			healed = hitent:GetObjectHealth() - oldhealth
		end

		if healed and owner:IsValidLivingHuman() then
			hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
			gamemode.Call("PlayerRepairedObject", owner, hitent, healed, self)

			local effectdata = EffectData()
				effectdata:SetOrigin(hitent:GetPos())
				effectdata:SetNormal((self:GetPos() - hitent:GetPos()):GetNormalized())
				effectdata:SetMagnitude(1)
			util.Effect("nailrepaired", effectdata, true, true)
		end
	end

	if self.Ticks > 0 then
		self:Fire("heal", "", self.TickTime)
	end

	return true
end
