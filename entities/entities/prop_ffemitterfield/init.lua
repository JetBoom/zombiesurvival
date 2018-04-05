AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_junk/TrashDumpster02b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)

	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end
