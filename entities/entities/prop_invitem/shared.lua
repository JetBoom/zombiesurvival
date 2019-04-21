ENT.Type = "anim"
ENT.Base = "prop_baseoutlined"

ENT.NoNails = true

function ENT:HumanHoldable(pl)
	return pl:KeyDown(GAMEMODE.UtilityKey)
end

function ENT:SetInventoryItemType(type)
	local invdata = GAMEMODE.ZSInventoryItemData[type]

	if not invdata then return end
	local droppedeles = invdata.DroppedEles

	-- String or based on grenade for override
	self:SetModel(istable(droppedeles) and "models/weapons/w_grenade.mdl" or droppedeles)
	self:PhysicsInit(SOLID_VPHYSICS)

	self:SetDTString(0, type)

	return true
end

function ENT:GetInventoryItemType()
	return self:GetDTString(0)
end
