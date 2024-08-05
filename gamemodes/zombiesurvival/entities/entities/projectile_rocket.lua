AddCSLuaFile()

ENT.Type = "anim"

ENT.Damage = 250
ENT.Vel = 1000
ENT.BoostVel = 300
ENT.GravityVel = 30
ENT.Radius = 150
ENT.ExplodeVel = 80
ENT.DieTime = 0
ENT.LifeTime = 8
ENT.OwnerDamageMul = 0.03
ENT.PropDamageMul = 0.3
ENT.DieTime = 0

util.PrecacheSound("weapons/rpg/rocketfire1.wav")
util.PrecacheSound("weapons/rpg/rocket1.wav")

if CLIENT then
	function ENT:Draw()
		self.Entity:DrawModel()
	end

	ENT.Particle = "particles/smokey"
	function ENT:Think()
		local pos = self:LocalToWorld(Vector(0, 0, self:OBBMins().z))
		local em = ParticleEmitter(pos)
			local particle = em:Add(self.Particle, pos)
			particle:SetVelocity(self:GetVelocity():GetNormal() * math.Rand(5, 10))
			particle:SetDieTime(1.5)
			particle:SetStartAlpha(math.Rand(1, 10))
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(5, 10))
			particle:SetEndSize(math.Rand(15, 20))
			particle:SetRoll(math.Rand(-0.2, 0.2))
			particle:SetVelocity(VectorRand() * self.Vel / 20)
			particle:SetColor(200, 200, 200)
		em:Finish()
	end
end	

if SERVER then
	
	function ENT:SetupDataTables()
		self:NetworkVar("Entity", 0, "Owner")
		self:NetworkVar("Entity", 1, "Inflictor")
	end
	
	function ENT:Initialize()	
		self:SetModel("models/weapons/w_missile_closed.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetTrigger(true)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(32)
			phys:SetBuoyancyRatio(0.01)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:Wake()
		end
		self.FireSound = CreateSound(self, "weapons/rpg/rocketfire1.wav")
		self.FireSound:Play()
		self.FlySound = CreateSound(self, "weapons/rpg/rocket1.wav")
		
		self.DieTime = CurTime() + self.LifeTime
	end

	function ENT:PhysicsCollide(data, collider)
		local ent = data.HitEntity
		if ent:GetClass() ~= self:GetClass() and data.Speed >= self.ExplodeVel and data.Entity ~= self:GetOwner() then
			self:Explode()
		end
	end
	
	function ENT:StartTouch(ent)
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:Team() ~= self:GetOwner():Team() then
					self:Explode()
				end
			end
		end
	end

	function ENT:Gravity()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddVelocity(Vector(0, 0, -self.GravityVel))
		end
	end

	function ENT:Boost()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			if phys:GetVelocity():Length() < self.Vel then
				phys:SetVelocityInstantaneous(self:GetAngles():Forward() * self.Vel)
			end
			phys:AddVelocity(self:GetAngles():Forward() * self.BoostVel)
			self.FlySound:Play()
		end
	end

	function ENT:CalcDieTime()
		if self.DieTime <= CurTime() then
			self:Explode()
		end
	end
	
	function ENT:Think()
		self:Gravity()
		self:Boost()
		self:CalcDieTime()
	end

	function ENT:Explode()
		local allent = ents.FindInSphere(self:GetPos(), self.Radius)
		local zombies = {}
		local props = {}
		
		local dmginfo = DamageInfo()
		
		local owner = self:GetOwner()
		if IsValid(owner) then
			dmginfo:SetAttacker(self:GetOwner())		
			local infl = self:GetInflictor()
			if IsValid(infl) then
				dmginfo:SetInflictor(infl)
			end
			dmginfo:SetDamage(self.Damage)
			
			local ownerdmg = false
			
			local owner = self:GetOwner()
			
			for _, v in pairs(allent) do
				if IsValid(v) then
					if v:IsPlayer() and v:Team() ~= owner:Team() then
						table.insert(zombies, v)
					elseif !v:IsPlayer() then
						table.insert(props, v)
					end
					
					if v == owner then
						ownerdmg = true
					end
				end
			end
			
			local td = {}
			td.start = self:GetPos()
			td.filter = {self}
			td.mask = MASK_SHOT
			
			for _, v in pairs(zombies) do
				td.endpos = v:LocalToWorld(v:OBBCenter())
				local trace = util.TraceLine(td)
				
				if trace.Hit and trace.Entity == v then
					local mul = 1 - (self:GetPos():Distance(v:NearestPoint(v:GetPos())) / self.Radius)
					
					dmginfo:ScaleDamage(mul)
					v:TakeDamageInfo(dmginfo)
					dmginfo:ScaleDamage(1 / mul)
					table.insert(td.filter, v)
				end
			end
			
			for _, v in pairs(props) do
				td.endpos = v:GetPos()
				local trace = util.TraceLine(td)
				
				if trace.Hit and trace.Entity == v then
					dmginfo:ScaleDamage(0.7)
					v:TakeDamageInfo(dmginfo)
					dmginfo:ScaleDamage(1 / 0.7)
					table.insert(td.filter, v)
				end
			end
			
			if ownerdmg then
				dmginfo:ScaleDamage(self.OwnerDamageMul)
				if IsValid(owner) then
					owner:TakeDamageInfo(dmginfo)
				end
			end
		end
		
		local ed = EffectData()
			ed:SetMagnitude(100)
			ed:SetOrigin(self:GetPos())
		util.Effect("Explosion", ed)
		self.FlySound:Stop()
		self:Remove()
	end
end