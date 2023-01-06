INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
end

local classes = {"Eradicator", "Eradicator II", "Eradicator III"}

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:Alive() and owner:Team() == TEAM_UNDEAD and classes[owner:GetZombieClassTable().Name]) then self:Remove() end
--	and owner:GetZombieClassTable().Name == "Eradicator"
end

