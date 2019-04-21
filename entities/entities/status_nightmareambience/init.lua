INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Think()
	local owner = self:GetOwner()
	local classname = owner:GetZombieClassTable().Name
	if not (owner:Alive() and owner:Team() == TEAM_UNDEAD and (classname == "Nightmare" or classname == "Ancient Nightmare")) then self:Remove() end
end
