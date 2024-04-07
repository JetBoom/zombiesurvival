INC_SERVER()

function ENT:Think()
	self.BaseClass.Think(self)

	local owner = self:GetOwner()

	if not owner:Alive() then
		self:Remove()
	end
end


function ENT:PlayerSet(pPlayer, bExists)
	pPlayer:Freeze(true)

	pPlayer.LastStunned = CurTime()
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		parent:Freeze(false)
	end
end
