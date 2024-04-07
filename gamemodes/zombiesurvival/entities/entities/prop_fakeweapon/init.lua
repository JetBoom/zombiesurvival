INC_SERVER()
AddCSLuaFile("cl_animations.lua")

function ENT:Initialize()
	local weptab = weapons.Get(self:GetWeaponType())
	if weptab and not weptab.BoxPhysicsMax then
		self:PhysicsInit(SOLID_VPHYSICS)
	end
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("material")
		phys:EnableMotion(not self.Restrained)
		phys:SetMass(25)
		phys:Wake()
	end

	self:Fire("kill", "", 3)
end

function ENT:SetupPhysics(weptab)
	if weptab.BoxPhysicsMax then
		self:PhysicsInitBox(weptab.BoxPhysicsMin, weptab.BoxPhysicsMax)
		self:SetCollisionBounds(weptab.BoxPhysicsMin, weptab.BoxPhysicsMax)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	end
end
