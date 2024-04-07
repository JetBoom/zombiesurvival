INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/healthvial.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	self:Fire("kill", "", 10)
end

function ENT:OnRemove()
	local ent = ents.Create("env_mediccloud")
	if ent:IsValid() then
		ent:SetPos(self.HitPos or self:GetPos())
		ent:SetOwner(self.Owner or self:GetOwner())
		ent:Spawn()
	end
end

function ENT:PhysicsCollide(data, phys)
	self.HitPos = self:GetPos() --data.HitPos + data.HitNormal * 8
	self.Owner = self:GetOwner()
	self:Fire("kill", "", 0.01)
end
