AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self.DieTime = CurTime() + 30

	self:SetModel("models/props_junk/glassbottle01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(4)
		phys:SetBuoyancyRatio(0.01)
		phys:EnableDrag(false)
		phys:Wake()
	end
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	end

	if self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed >= 50 then
		self.PhysicsData = data
		self:NextThink(CurTime())
	end
end

function ENT:StartTouch(ent)
	if self.DieTime ~= 0 and ent:IsValid() and ent:IsPlayer() and ent:Alive() then
		local owner = self:GetOwner()
		if not owner:IsValid() then owner = self end

		if ent ~= owner and ent:Team() ~= self.Team then
			ent:TakeSpecialDamage(self.Damage, DMG_CLUB, owner, self)
			self:Explode()
		end
	end
end

function ENT:Explode(hitpos, hitnormal)
	if self.DieTime == 0 then return end
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end
	self.DieTime = 0

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or (self:GetVelocity():GetNormalized() * -1)

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
	util.Effect("hit_glass", effectdata)
	
	for _, ent in pairs(ents.FindInSphere(hitpos,128)) do
		if owner:IsValid() and owner:IsPlayer() and owner:Team() == TEAM_HUMAN and ent:IsPlayer() and ent:Alive() and (ent:Team() ~= owner:Team() or ent == owner) and TrueVisible(hitpos, ent:NearestPoint(hitpos)) then
			local burn = ent:GiveStatus("burn")
			if burn and burn:IsValid() then
				burn:AddDamage(25)
				if owner:IsValid() and owner:IsPlayer() then
					burn.Damager = owner
				end
			end
		end
	end

	self:NextThink(CurTime())
end
