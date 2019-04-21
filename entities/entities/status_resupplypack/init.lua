INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.35, 0)

	self:SetModel("models/Items/ammocrate_ar2.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:PhysicsInitSphere(3)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:Alive() and owner:HasTrinket("resupplypack")) then self:Remove() end
end

function ENT:Use(activator, caller)
	if activator:Team() ~= TEAM_HUMAN or not activator:Alive() or GAMEMODE:GetWave() <= 0 then return end

	local owner = self:GetOwner()
	activator:Resupply(owner, self)
end
