AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.4, 0)

	self:SetModel("models/Items/item_item_crate.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInitSphere(3)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:Alive() and owner:HasWeapon("weapon_zs_arsenalcrate")) then self:Remove() end
end

function ENT:Use(activator, caller)
	if self:GetOwner() ~= activator then
		if gamemode.Call("PlayerCanPurchase", caller) and activator.CrateShare then
			caller:SendLua(GAMEMODE:GetWave() > 0 and "GAMEMODE:OpenPointsShop()" or "MakepWorth()")
		else
			caller:CenterNotify(COLOR_RED, translate.ClientGet(caller, "worth_crateshare3"))
		end
	end
end