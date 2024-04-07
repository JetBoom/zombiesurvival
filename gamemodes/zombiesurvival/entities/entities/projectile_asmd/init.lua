INC_SERVER()

function ENT:Initialize()
	self.Bounces = 0

	self:SetModel("models/dav0r/hoverball.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(2, 0)
	self:SetupGenericProjectile(false)

	self:Fire("kill", "", 10)
end

function ENT:Explode(hitpos, hitnormal)
	if self.Exploded then return end
	self.Exploded = true

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or self:GetForward()

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		local ent = self.HitData.HitEntity
		util.BlastDamagePlayer(source, owner, self:GetPos(), 50, (self.ProjDamage or 52) * 0.2, DMG_ALWAYSGIB, 0.96)
		if ent:IsValidLivingZombie() and not ent:GetZombieClassTable().NeverAlive then
			ent:TakeSpecialDamage((self.ProjDamage or 49) * 0.9, DMG_GENERIC, owner, source, hitpos)
		end
	end
end

function ENT:ExplodeAlt()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, self:GetPos(), 124, (self.ProjDamage or 52) * 2.25, DMG_ALWAYSGIB, 0.96)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetForward())
	util.Effect("explosion_shockcore", effectdata)

	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker:IsValidLivingHuman() then
		local inflictor = dmginfo:GetInflictor()

		if inflictor:IsValid() and dmginfo:GetDamageType() == DMG_GENERIC and inflictor.ASMD and attacker == self:GetOwner() then
			self:ExplodeAlt()
		end
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end
	self.HitData = data
	self:NextThink(CurTime())
end

function ENT:Think()
	if self.HitData then
		self:Explode(self.HitData.HitPos, self.HitData.HitNormal)
		self:Remove()
	end
end
