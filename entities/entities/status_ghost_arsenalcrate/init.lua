AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Think()
	self:RecalculateValidity()

	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:GetActiveWeapon():IsValid() and owner:GetActiveWeapon():GetClass() == "weapon_zs_arsenalcrate") then
		self:Remove()
	end
end
