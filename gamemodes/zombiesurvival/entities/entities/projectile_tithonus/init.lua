INC_SERVER()

ENT.PointsMultiplier = 1.25

function ENT:Initialize()
	self:Fire("kill", "", 2)

	self:SetModel("models/dav0r/hoverball.mdl")
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.2, 0)
	self:SetupGenericProjectile(false)
	self.LastPhysicsUpdate = UnPredictedCurTime()
end

local vecDown = Vector()
function ENT:PhysicsUpdate(phys)
	self:ProjectileTraceAhead(phys)

	local dt = UnPredictedCurTime() - self.LastPhysicsUpdate
	self.LastPhysicsUpdate = UnPredictedCurTime()

	vecDown.z = dt * -200
	phys:AddVelocity(vecDown)
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end
	self.HitData = data

	self:NextThink(CurTime())
end

function ENT:OnRemove()
	local effectdata = EffectData()
		effectdata:SetOrigin(self.HitData and self.HitData.HitPos or self:GetPos())
		effectdata:SetNormal(self.HitData and self.HitData.HitNormal or Vector(0, 0, 0))
	util.Effect("hit_tithonus", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end
	self.HitData = data
	self:NextThink(CurTime())
end

function ENT:Think()
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if self.Touched and not self.Damaged then
		self.Damaged = true

		local tr = self.Touched

		if self.PointsMultiplier then
			POINTSMULTIPLIER = self.PointsMultiplier
		end
		self:DealProjectileTraceDamage(self.ProjDamage or 77, tr, owner)
		if tr.Entity:IsPlayer() then
			tr.Entity:AddLegDamageExt(5.5, owner, source, SLOWTYPE_PULSE)
		end
		if self.PointsMultiplier then
			POINTSMULTIPLIER = nil
		end

		util.Blood(tr.Entity:WorldSpaceCenter(), math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)

		self:Remove()
	elseif self.HitData then
		self:Remove()
	end
end
