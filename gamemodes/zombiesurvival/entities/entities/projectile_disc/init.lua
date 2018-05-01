INC_SERVER()

function ENT:Initialize()
	self:SetModelScale(0.3, 0)
	self:DrawShadow(false)
	self:SetModel("models/props_junk/sawblade001a.mdl")
	self:PhysicsInitSphere(3)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(false)

	self:Fire("kill", "", 0.3)

	self.NextShoot = 0
	self.PostOwner = self:GetOwner()
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

function ENT:OnRemove()
	local hitpos = self.PhysicsData and self.PhysicsData.HitPos or self:GetPos()
	local normal = self.PhysicsData and self.PhysicsData.HitNormal or Vector(0, 0, 1)

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(normal)
	util.Effect("explosion_fusordisc", effectdata)

	local owner = self.PostOwner
	if not owner:IsValidLivingHuman() then owner = self end

	local oldvel = self.PhysicsData and self.PhysicsData.OurOldVelocity or self:GetVelocity()

	local backvel = oldvel:GetNormalized()
	local pos = self:GetPos() - backvel * 10
	local dmg = self.ProjDamage
	local me = self:ProjectileDamageSource()

	for i = 1, 8 do
		timer.Simple(i * 0.05, function()
			backvel.z = backvel.z + 0.001 * i
			backvel = backvel:GetNormalized()

			self:FireBulletsLua(pos, -backvel, 1, 1, dmg/2, owner, 0.01, "tracer_fusor", BulletCallback, nil, nil, nil, nil, me)
		end)
	end
end

function ENT:Explode(hitpos, normal, hitent)
	if self.Exploded then return end
	self.Exploded = true

	self:Remove()
end
