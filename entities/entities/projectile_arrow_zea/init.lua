INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(false)
	self.LastPhysicsUpdate = UnPredictedCurTime()

	self.NextShoot = CurTime() + 0.05
end

local vecDown = Vector()
function ENT:PhysicsUpdate(phys)
	local dt = UnPredictedCurTime() - self.LastPhysicsUpdate
	self.LastPhysicsUpdate = UnPredictedCurTime()

	vecDown.z = dt * -400
	phys:AddVelocity(vecDown)
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

		local ent = self.HitData.HitEntity
		if ent:IsValidLivingZombie() and not ent:GetZombieClassTable().NeverAlive or ent.ZombieConstruction then
			ent:TakeSpecialDamage((ent:GetStatus("shockdebuff") and 1.25 or 1) * (self.ProjDamage or 125) * 0.65, DMG_SHOCK, owner, source, hitpos)
			ent:EmitSound("ambient/energy/zap1.wav", 70, 240, 0.7, CHAN_AUTO)
		end

		if math.random(3) == 1 then
			for _, pl in pairs(util.BlastAlloc(source, owner, hitpos, 60)) do
				if pl:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", pl, owner) then
					local status = pl:GiveStatus("shockdebuff")
					status.DieTime = CurTime() + 7
				end
			end
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
	util.Effect("hit_zeus", effectdata)
end

function ENT:Think()
	if CurTime() > self.NextShoot then
		self.NextShoot = CurTime() + 1

		local owner = self:GetOwner()
		if not owner:IsValidLivingHuman() then owner = self end

		local phys = self:GetPhysicsObject()
		local source = self:ProjectileDamageSource()

		self:FireBulletsLua(self:GetPos() + self:GetForward() * 1, phys:GetVelocity():GetNormalized(), 0, 1, self.ProjDamage * 0.45, owner, 0.01, "tracer_zapper", BulletCallback, nil, nil, nil, nil, source)
	end

	if self.HitData then
		self:Explode(self.HitData.HitPos, self.HitData.HitNormal)
		self:EmitSound("weapons/physcannon/superphys_small_zap1.wav", 85, 90, 1, CHAN_AUTO)
		self:Remove()
	end

	self:NextThink(CurTime())
end
