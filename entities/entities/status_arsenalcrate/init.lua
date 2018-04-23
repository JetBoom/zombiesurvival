AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.5, 0)

	self:SetModel("models/Items/item_item_crate.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged()
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:Alive() and owner:HasWeapon("weapon_zs_arsenalcrate")) then self:Remove() end
end

function ENT:Use(activator, caller)
	local ishuman = activator:Team() == TEAM_HUMAN and activator:Alive()

	if activator:Team() == TEAM_HUMAN and GAMEMODE:GetWave() > 0 and activator:Alive() then
		activator:SendLua("GAMEMODE:OpenPointsShop()")
	elseif ishuman then
		activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "you_cant_purchase_now"))
	end
end