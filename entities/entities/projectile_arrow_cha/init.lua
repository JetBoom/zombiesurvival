INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	self:EmitSound("weapons/crossbow/bolt_fly4.wav", 75, 130)
end

function ENT:PhysicsUpdate(phys)
	self:ProjectileTraceAhead(phys)
end

function ENT:Explode(hitpos, hitnormal)
	if self.Exploded then return end
	self.Exploded = true

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or self:GetForward()

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
	util.Effect("hit_charon", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end
	if not self:HitFence(data, phys) then
		self.HitData = data
	end

	self:NextThink(CurTime())
end

function ENT:Think()
	self:NextThink(CurTime())

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if self.Touched and not self.Damaged then
		self.Damaged = true

		local tr = self.Touched

		self:DealProjectileTraceDamage(self.ProjDamage or 77, tr, owner)

		tr.Entity:EmitSound(math.random(2) == 1 and "weapons/crossbow/hitbod"..math.random(2)..".wav" or "ambient/machines/slicer"..math.random(4)..".wav", 75, 150)

		util.Blood(tr.Entity:WorldSpaceCenter(), math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)

		self:Explode()
		self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 70, 250)
		self:Remove()
	elseif self.HitData then
		self:Explode(self.HitData.HitPos, self.HitData.HitNormal)
		self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 70, 250)
		self:Remove()
	end
	return true
end
