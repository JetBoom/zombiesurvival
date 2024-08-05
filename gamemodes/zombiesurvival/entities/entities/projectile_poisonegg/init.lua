AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.LifeTime = 0.9
ENT.SlowDownScale = 2

function ENT:Initialize()
	self:SetModel("models/props/cs_italy/orange.mdl")
	self:PhysicsInitSphere(6)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:SetModelScale(1, 0)
	self:SetCustomCollisionCheck(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(5)
		phys:SetBuoyancyRatio(0.002)
		phys:EnableMotion(true)
		phys:Wake()
	end
	self:SetMaterial("Models/Barnacle/barnacle_sheet")
	self.DeathTime = CurTime() + 2
	self.ExplodeTime = CurTime() + self.LifeTime
end

function ENT:Think()
	if self.DeathTime <= CurTime() then
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Explode(eHitEntity)
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0
	local pos = self:GetPos()
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
	if eHitEntity:IsValid() and eHitEntity:IsPlayer() and eHitEntity:Team() ~= TEAM_UNDEAD then
		eHitEntity:PoisonDamage(20, owner, self)
		eHitEntity:AddLegDamage(20)
		local dice = math.random(5)
		if dice == 5 then eHitEntity:KnockDown(2) end
	end
	util.Blood(pos, 50, Vector(0, 0, 1), 300, true)
	local effectdata = EffectData()
end
function ENT:PhysicsCollide(data, physobj)
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 74, math.Rand(95, 105))
	local ent = data.HitEntity
	if ent and ent:IsValid() and ent:IsPlayer() and ent:Team() ~= TEAM_UNDEAD then
		self:Explode(ent)
		self:NextThink(CurTime())
	end
end
