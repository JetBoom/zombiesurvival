AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.LifeTime = 4
ENT.NextTickSound = 0
ENT.GrenadeDamage = 45
ENT.GrenadeRadius = 256

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self.DieTime = CurTime() + self.LifeTime
end

if SERVER then

function ENT:Think()
	if self.Exploded then
		self:Remove()
	elseif self.DieTime <= CurTime() then
		self:Explode()
		self.Owner:Kill()
	elseif not self.Owner:Alive() or not self.Owner:IsValid() then 
		self:Remove()
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValid() and owner:IsPlayer() and owner:Team() == TEAM_UNDEAD then
		local pos = self:GetPos()

		util.PoisonBlastDamage(self, owner, pos, self.GrenadeRadius, self.GrenadeDamage, true)
		
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata)
	end
end

end

if not CLIENT then return end

function ENT:Think()
	
	local curtime = CurTime()

	if curtime >= self.NextTickSound then
		local delta = self.DieTime - curtime

		self.NextTickSound = curtime + math.max(0.2, delta * 0.25)
		self:EmitSound("weapons/grenade/tick1.wav", 75, math.Clamp((1 - delta / self.LifeTime) * 160, 100, 160))
	end
	

end