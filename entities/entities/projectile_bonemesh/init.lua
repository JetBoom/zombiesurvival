AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.LifeTime = 3

function ENT:Initialize()
	self:SetModel("models/Gibs/HGIBS.mdl")
	self:PhysicsInitSphere(13)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:SetModelScale(2.5, 0)
	self:SetCustomCollisionCheck(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(20)
		phys:SetBuoyancyRatio(0.002)
		phys:EnableMotion(true)
		phys:Wake()
	end

	self:SetMaterial("models/flesh")

	self.DeathTime = CurTime() + 30
	self.ExplodeTime = CurTime() + self.LifeTime
end

function ENT:Think()
	if self.ExplodeTime <= CurTime() then
		self:Explode()
	end

	if self.DeathTime <= CurTime() then
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0

	local pos = self:GetPos()
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	util.BlastDamageEx(self, owner, pos, 100, 15, DMG_SLASH)

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("bonemeshexplode", effectdata)

	util.Blood(pos, 150, Vector(0, 0, 1), 300, true)

	for i=1, 4 do
		local ent = ents.CreateLimited("prop_playergib")
		if ent:IsValid() then
			ent:SetPos(pos + VectorRand() * 4)
			ent:SetAngles(VectorRand():Angle())
			ent:SetGibType(math.random(3, #GAMEMODE.HumanGibs))
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:SetVelocityInstantaneous(VectorRand():GetNormalized() * math.Rand(120, 620))
				phys:AddAngleVelocity(VectorRand() * 360)
			end
		end
	end
end

function ENT:PhysicsCollide(data, physobj)
	if 20 < data.Speed and 0.2 < data.DeltaTime then
		self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 74, math.Rand(95, 105))
	end

	local ent = data.HitEntity
	if ent and ent:IsValid() and ent:IsPlayer() and ent:Team() ~= TEAM_UNDEAD then
		self.ExplodeTime = 0
		self:NextThink(CurTime())
	else
		local normal = data.OurOldVelocity:GetNormalized()
		local DotProduct = data.HitNormal:Dot(normal * -1)

		physobj:SetVelocityInstantaneous((2 * DotProduct * data.HitNormal + normal) * math.max(100, data.Speed) * 0.9)
	end
end
