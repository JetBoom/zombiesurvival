INC_SERVER()

ENT.NextHeal = 0

function ENT:OnInitialize()
	hook.Add("Move", self, self.Move)
end

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.FeignDeath = self
	pPlayer:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	pPlayer:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)

	if pPlayer:KeyDown(IN_BACK) then
		self:SetDirection(DIR_BACK)
	elseif pPlayer:KeyDown(IN_MOVERIGHT) then
		self:SetDirection(DIR_RIGHT)
	elseif pPlayer:KeyDown(IN_MOVELEFT) then
		self:SetDirection(DIR_LEFT)
	else
		self:SetDirection(DIR_FORWARD)
	end
end

function ENT:Think()
	local fCurTime = CurTime()
	local owner = self:GetOwner()

	if owner:IsValid() then
		if self:GetStateEndTime() <= fCurTime and self:GetState() == 1 or not owner:Alive() or owner:Team() ~= TEAM_UNDEAD or not owner:GetZombieClassTable().CanFeignDeath then
			self:Remove()
			return
		end

		if fCurTime >= self.NextHeal then
			self.NextHeal = fCurTime + 0.25

			if owner:Health() < owner:GetMaxHealth() and not owner:GetZombieClassTable().Boss then
				owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + math.min(owner:GetMaxHealth() * 0.035, 3)))
			end
		end
	end

	self:NextThink(fCurTime)
	return true
end

function ENT:OnRemove()
	local parent = self:GetOwner()
	if parent:IsValid() then
		parent.FeignDeath = nil
		parent:TemporaryNoCollide(true)
	end
end
