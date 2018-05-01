INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.4, 0)

	self:SetModel("models/Items/item_item_crate.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:PhysicsInitSphere(3)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:Alive() and owner:HasTrinket("arsenalpack")) then self:Remove() end
end
