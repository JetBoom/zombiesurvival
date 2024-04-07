INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/props_junk/glassbottle01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	self:Fire("kill", "", 30)
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	end
end

function ENT:PhysicsCollide(data, phys)
	--if data.Speed >= 50 then
		self.PhysicsData = data
		self.Owner = self:GetOwner()
		self:NextThink(CurTime())
	--end
end

function ENT:OnRemove()
	local ent = ents.Create("env_molotovflame")
	if ent:IsValid() then
		ent:SetPos(self.PhysicsData.HitPos or self:GetPos())
		ent:SetOwner(self.Owner or self:GetOwner())
		ent:Spawn()
		ent:DropToFloor()
	end
end

function ENT:Explode(hitpos, hitnormal)
	if self.Exploded then return end
	self.Exploded = true

	self:Fire("kill", "", 0.01)

	local owner = self:GetOwner()

	hitpos = hitpos or self:GetPos()
	if not hitnormal then
		hitnormal = self:GetVelocity():GetNormalized() * -1
	end

	--hitpos = hitpos + hitnormal

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
	util.Effect("hit_glass", effectdata)

	if owner:IsValidHuman() then
		for ent, dmg in pairs(util.BlastDamageExAlloc(self, owner, hitpos, 128, 60, DMG_SLASH)) do
			if ent:IsValidLivingPlayer() and (ent:Team() == TEAM_UNDEAD or ent == owner) then
				ent:Ignite(dmg / 7)
				for __, fire in pairs(ents.FindByClass("entityflame")) do
					if fire:IsValid() and fire:GetParent() == ent then
						fire:SetOwner(owner)
						fire:SetPhysicsAttacker(owner)
						fire.AttackerForward = owner
					end
				end
			end
		end
	end

	self:NextThink(CurTime())
end
