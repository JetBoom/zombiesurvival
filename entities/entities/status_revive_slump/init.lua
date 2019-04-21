INC_SERVER()

function ENT:PlayerSet(pPlayer, bExists)
	self.HealCarryOver = self.HealCarryOver or 0

	pPlayer.Revive = self
	--pPlayer:Freeze(true)
	if not bExists then
		pPlayer:GodEnable()
		self.GodDisableTime = CurTime() + 0.1
	end

	pPlayer:CallWeaponFunction("KnockedDown", self, bExists)
	pPlayer:CallZombieFunction("KnockedDown", self, bExists)
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

		self.HealCarryOver = self.HealCarryOver + FrameTime() * self:GetReviveHeal()
		if self.HealCarryOver >= 1 then
			local toheal = math.floor(self.HealCarryOver)
			owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + toheal))
			self.HealCarryOver = self.HealCarryOver - toheal
		end
	end

	self:NextThink(fCurTime)
	return true
end

function ENT:OnRemove()
	local parent = self:GetOwner()
	if parent:IsValid() then
		parent.Revive = nil
		--parent:Freeze(false)
		parent:GodDisable()
		parent:AddFlags(FL_ONGROUND)
	end
end
