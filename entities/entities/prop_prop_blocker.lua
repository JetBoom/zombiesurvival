AddCSLuaFile()

ENT.Type = "anim"

ENT.IgnoreMelee = true
ENT.IgnoreBullets = true
ENT.IgnoreTraces = true
ENT.Sigil = true

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetNoDraw(true)

	if SERVER then
		self:PhysicsInitBox(Vector(-20, -20, 0), Vector(20, 20, 86))
	end

	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged()
	--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	end
end

function ENT:ShouldNotCollide(ent)
	return --[[ent:GetCollisionGroup() ~= COLLISION_GROUP_NONE or]] ent:IsPlayer() or ent:IsProjectile()
end
