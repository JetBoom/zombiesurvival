INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/props_c17/trappropeller_lever.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(false)

	self:EmitSound("weapons/ar2/fire1.wav", 75, 210)
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end
	self.HitData = data
	self:NextThink(CurTime())
end

function ENT:Explode(hitpos, hitnormal)
	if self.Exploded then return end
	self.Exploded = true

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or self:GetForward()

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		local target = self.HitData.HitEntity

		if target:IsValidLivingZombie() and not target:GetZombieClassTable().NeverAlive then
			target:TakeSpecialDamage(self.ProjDamage or 47, DMG_BULLET, owner, source, hitpos)
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
	util.Effect("hit_jugger", effectdata)
end

function ENT:Think()
	if self.HitData then
		self:Explode(self.HitData.HitPos, self.HitData.HitNormal)
		self:Remove()
	end
end
