INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/dav0r/hoverball.mdl")
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:Alive() and owner:Team() == TEAM_UNDEAD and owner:GetZombieClassTable().Name == "Wil O' Wisp") then self:Remove() end
end
