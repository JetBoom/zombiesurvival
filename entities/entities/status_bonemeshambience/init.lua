INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:Alive() and owner:Team() == TEAM_UNDEAD and owner:GetZombieClassTable().Name == "Bonemesh") then self:Remove() end
end
