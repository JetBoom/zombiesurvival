AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self.DieTime = CurTime() + 15

	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(4)
		phys:SetBuoyancyRatio(0.01)
		phys:EnableDrag(false)
		phys:Wake()
	end
	self.Touched = {}
	self.OriginalAngles = self:GetAngles()

	self:EmitSound("weapons/crossbow/bolt_fly4.wav")
end

function ENT:Think()
	if self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end
	self.Done = true

	phys:EnableMotion(false)
	self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav")
	self.DieTime = CurTime() + 8

	self:SetPos(data.HitPos)
	self:SetAngles(data.HitNormal:Angle())

	local hitent = data.HitEntity
	if hitent and hitent:IsValid() then
		local hitphys = hitent:GetPhysicsObject()
		if hitphys:IsValid() and hitphys:IsMoveable() then
			self:SetParent(hitent)
		end
	end
end

function ENT:StartTouch(ent)
	if not self.Done and not self.Touched[tostring(ent)] and ent:IsValid() then
		local owner = self:GetOwner()
		if not owner:IsValid() then owner = self end

		if ent ~= owner and not (ent:IsPlayer() and ent:Team() == self.Team) then
			ent:TakeDamage(100, owner, self)
			ent:EmitSound("weapons/crossbow/hitbod"..math.random(1,2)..".wav")
			self.Touched[tostring(ent)] = true
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
