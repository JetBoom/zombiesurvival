AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.LifeTime = 10
ENT.Radius = 225
ENT.ShootPower = 990
ENT.ShootTime = 0
ENT.Shoot = false
ENT.PushVel = 450
ENT.MaxDmg = 4

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Owner")
end

function ENT:Initialize()
	self:SetModel("models/weapons/w_bugbait.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(true)
	self.DieTime = CurTime() + (self.LifeTime or 10)
	self.ShootTime = self.ShootTime or CurTime() + 1
end

function ENT:ShouldNotCollide(ent)
	return ent:GetClass() == self:GetClass()
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	
	if ent:GetClass() ~= self:GetClass() and (ent:IsWorld() and self.Shoot) and ent ~= self:GetOwner() then
		self:Explode()
	end
end

function ENT:Think()
	if self.DieTime <= CurTime() then
		self:Explode()
	end
	local owner = self:GetOwner()
	
	if !IsValid(owner) or !owner:IsPlayer() or (owner:Team() == TEAM_HUMAN) then
		self:Explode()
	end
	
	if self:WaterLevel() >= 1 then
		self:Explode()
	end
	
	if !self.Shoot then
		self:SetPos(owner:GetShootPos() + owner:GetAimVector() * 10)
	end
	
	if self.ShootTime <= CurTime() and !self.Shoot then
		self:Shot()
	end
end

function ENT:Shot()
	local owner = self:GetOwner()
	
	if !IsValid(owner) or !owner:IsPlayer() then
		self:Explode()
		return
	end
	
	local phys = self:GetPhysicsObject()
	
	if !IsValid(phys) then
		self:Explode()
		return
	end
	phys:Wake()
	phys:SetVelocity(owner:GetVelocity() + owner:GetAimVector() * self.ShootPower)
	phys:AddAngleVelocity(VectorRand() * 1000)
	
	owner:ResetSpeed()
	
	self.Shoot = true
end

function ENT:Explode()
	local owner = self:GetOwner()

	local humans = {}
	
	for _, v in pairs(ents.FindInSphere(self:LocalToWorld(self:OBBCenter()), self.Radius)) do
		if IsValid(v) and v:IsPlayer() and v:Team() == TEAM_HUMAN then
			table.insert(humans, v)
		elseif v == owner then
			v:SetGroundEntity(NULL)
			v:SetVelocity(((v:GetPos() - self:GetPos()):GetNormal() + Vector(0, 0, 0.05)) * self.PushVel)
		end
	end
	
	local td = {}
	td.start = self:LocalToWorld(self:OBBCenter())
	td.filter = {self, owner}
	
	local trace = nil
	
	local validlist = {}
	
	if #humans >= 1 then
		for i, v in pairs(humans) do
			td.endpos = v:LocalToWorld(v:OBBCenter())
			trace = util.TraceLine(td)

			if IsValid(trace.Entity) and trace.Entity == v then
				table.insert(validlist, v)
				table.insert(td.filter, v)
			end
		end
	end
	
	for _, v in pairs(validlist) do
		v:SetGroundEntity(NULL)
		v:SetLocalVelocity(((v:LocalToWorld(v:OBBCenter()) - self:LocalToWorld(self:OBBCenter())):GetNormal() + Vector(0, 0, 0.1)) * self.PushVel)
		local dmg = math.ceil(self.MaxDmg * math.min((1.5 - (v:GetPos():Distance(self:GetPos()) / self.Radius)), 1))
		v:TakeDamage(dmg, owner, self)
	end
	
	local ed = EffectData()
	ed:SetOrigin(self:LocalToWorld(self:OBBCenter()))
	ed:SetScale(100)
	ed:SetMagnitude(200)
	ed:SetNormal(VectorRand())
	util.Effect("siegeball", ed)
	
	self:EmitSound("weapons/bugbait/bugbait_impact" .. tostring(math.random(1, 2) == 1 and 1 or 3) .. ".wav")
	self:Remove()
end