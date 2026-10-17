INC_SERVER()

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.Revive = self
end

function ENT:Think()
	local fCurTime = CurTime()
	local owner = self:GetOwner()

	if owner:IsValid() then
		if self:GetReviveTime() <= fCurTime or not owner:Alive() then
			self:Remove()
			return
		end

		if self.GodDisableTime and fCurTime >= self.GodDisableTime then
			owner:GodDisable()
			self.GodDisableTime = nil
		end

		-- Heal tick once every 0.1s instead of every frame.
		-- Same speed, but 6 times fewer Think calls.
		local dt = 0.1
		self.HealCarryOver = self.HealCarryOver + dt * self:GetReviveHeal()
		if self.HealCarryOver >= 1 then
			local toheal = math.floor(self.HealCarryOver)
			owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + toheal))
			self.HealCarryOver = self.HealCarryOver - toheal
		end
	end

	self:NextThink(fCurTime + 0.1)
	return true
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		parent.Revive = nil
		if not parent:Alive() then
			parent:SecondWind()
		end
	end
end
