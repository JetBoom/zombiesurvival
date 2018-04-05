AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.5, 0)

	self:SetModel("models/props_c17/canister01a.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:Alive() and owner:HasWeapon("weapon_zs_oxygentank")) then self:Remove() end
end
