AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.5, 0)

	self:SetModel("models/Items/item_item_crate.mdl")
	self:PhysicsInit( SOLID_CUSTOM  )
	self:SetSolid( SOLID_CUSTOM  )
	self:SetMoveType( MOVETYPE_NONE )
	
	self:GetOwner().ShowWarning = true
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:Alive() and owner:HasWeapon("weapon_zs_arsenalcrate")) then self:Remove() end
	
	--[[if owner.NextArseClick ~= nil and owner.NextArseClick <= CurTime() then
		owner.ShowWarning = true
	end]]
end

function ENT:Use(activator, caller)
	local owner = self:GetOwner()
	print(activator, caller, owner)
	if activator and activator:IsValid() then
		if activator:Alive() and activator:Team() == TEAM_HUMAN then
			if GAMEMODE:GetWave() > 0 then
				activator:SendLua("GAMEMODE:OpenPointsShop()")
			--[[else
				if owner.ShowWarning then
					activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "you_cant_purchase_now"))
					owner.NextArseClick = CurTime() + 5
					owner.ShowWarning = false
				end]]
			end
		end
	end
end