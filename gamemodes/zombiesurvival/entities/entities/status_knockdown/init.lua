INC_SERVER()

function ENT:SetDie(fTime)
	if fTime == 0 or not fTime then
		self.DieTime = 0
	elseif fTime == -1 then
		self.DieTime = 999999999
	else
		self.DieTime = CurTime() + fTime
		self:SetDuration(fTime)
	end
end

function ENT:PlayerSet(pPlayer, bExists)
	self:SetStartTime(CurTime())

	pPlayer.KnockedDown = self
	--pPlayer:Freeze(true)

	pPlayer:DrawWorldModel(false)
	pPlayer:DrawViewModel(false)

	local lifetime = self.DieTime - CurTime()
	self.DieTime = CurTime() + lifetime * (pPlayer.KnockdownRecoveryMul or 1)
	self:SetDTFloat(1, self.DieTime)

	if not bExists then
		pPlayer:CreateRagdoll()
	end
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		--parent:Freeze(false)
		parent.KnockedDown = nil

		if parent:Alive() then
			parent:DrawViewModel(true)
			parent:DrawWorldModel(true)

			local rag = parent:GetRagdollEntity()
			if rag and rag:IsValid() then
				rag:Remove()
			end
		end
	end
end
