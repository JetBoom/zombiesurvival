INC_SERVER()

function ENT:Initialize()
	local modelid = math.random(#GAMEMODE.HumanGibs)
	self:SetModel(GAMEMODE.HumanGibs[modelid])
	if 4 < modelid then
		self:SetMaterial("models/flesh")
	end
	--self:PhysicsInitSphere(1)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	self:Fire("kill", "", 10)
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end
end

function ENT:Explode(vHitPos, vHitNormal, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:WorldSpaceCenter()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	if eHitEntity:IsValid() then
		eHitEntity:TakeSpecialDamage(4, DMG_CLUB, owner, self)
	end

	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
	util.Blood(vHitPos + vHitNormal, 8, vHitNormal, 100, true)

	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	if not self:HitFence(data, phys) then
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end
