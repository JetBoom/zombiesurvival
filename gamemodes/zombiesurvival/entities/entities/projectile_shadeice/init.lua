INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/props_wasteland/rockcliff01g.mdl")
	self:SetModelScale(0.3, 0)
	self:SetMaterial("models/shadertest/shader2")
	self:SetColor(Color(0, 150, 255, 255))
	self:PhysicsInitSphere(10)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:SetCustomCollisionCheck(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(20)
		phys:EnableMotion(true)
		phys:Wake()
	end
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end

	if self.Exploded then
		self:Remove()
	end
end

function ENT:Hit(vHitPos, vHitNormal, hitent)
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
	util.Effect("hit_ice", effectdata)

	if hitent:IsValid() and not hitent:IsPlayer() or (hitent:IsPlayer() and hitent:Team() ~= TEAM_UNDEAD) then
		hitent:TakeSpecialDamage(44 * (hitent.PhysicsDamageTakenMul or 1), DMG_GENERIC, owner, self)

		if hitent.FizzleStatusAOE then return end
	end

	for _, ent in pairs(util.BlastAlloc(self, owner, vHitPos, 110)) do
		if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) and ent ~= owner then
			local nearest = ent:NearestPoint(vHitPos)
			local scalar = ((110 - nearest:Distance(vHitPos)) / 110)

			ent:GiveStatus("frost", scalar * 6)
			ent:AddLegDamageExt(18 * scalar, owner, self, SLOWTYPE_COLD)
		end
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.Control:IsValid() then return end

	self.PhysicsData = data
	self:NextThink(CurTime())
end
