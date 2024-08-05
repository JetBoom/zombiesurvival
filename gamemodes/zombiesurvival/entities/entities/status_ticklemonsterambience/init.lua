AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
ENT.Raged = nil
function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:Alive() and owner:Team() == TEAM_UNDEAD and owner:GetZombieClassTable().Name == "The Tickle Monster") then self:Remove() end
	if self.Owner:Health()<self.Owner:GetMaxHealth()*0.2 then
		self.Raged = true
	else self.Raged = nil 
	end
end
