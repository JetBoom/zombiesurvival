AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.5, 0)

	self:SetModel(Model("models/Items/item_item_crate.mdl"))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(50)
		phys:EnableMotion(false)
		phys:Wake()
	end
	
	self:SetCollisionGroup(COLLISION_GROUP_WORLD) 		
	self:CollisionRulesChanged()  
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:Alive() and owner:HasWeapon("weapon_zs_arsenalcrate")) then self:Remove() end
end

function ENT:Use(activator, caller)
	if gamemode.Call("PlayerCanPurchase", caller) and activator.CrateShare then
		caller:SendLua(GAMEMODE:GetWave() > 0 and "GAMEMODE:OpenPointsShop()" or "MakepWorth()")
		else
		caller:CenterNotify(COLOR_RED, translate.ClientGet(caller, "worth_crateshare3"))
	end
end