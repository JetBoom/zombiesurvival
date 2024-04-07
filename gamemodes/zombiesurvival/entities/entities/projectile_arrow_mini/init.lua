INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:SetModelScale(0.55, 0)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	self:EmitSound("weapons/crossbow/bolt_fly4.wav", 75, 125)

	self:Fire("kill", "", 15)
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

		util.BlastDamagePlayer(source, owner, hitpos, 56, self.ProjDamage * 0.4, DMG_ALWAYSGIB, 0.95)
		local ent = self.HitData.HitEntity
		if (ent:IsValidLivingZombie() and not ent:GetZombieClassTable().NeverAlive) or ent.ZombieConstruction then
			ent:TakeSpecialDamage(self.ProjDamage * 0.65, DMG_GENERIC, owner, source, hitpos)
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
	util.Effect("HelicopterMegaBomb", effectdata)
	self:EmitSound(")weapons/explode3.wav", 80, 180)
end

function ENT:Think()
	if self.HitData then
		self:Explode(self.HitData.HitPos, self.HitData.HitNormal)
		self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 100, 240, 0.7, CHAN_AUTO)
		self:Remove()
	end
end
