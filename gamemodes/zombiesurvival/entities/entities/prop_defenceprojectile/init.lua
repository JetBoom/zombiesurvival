AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Radius = 225
ENT.InterceptRadius = ENT.Radius * 0.3
ENT.Gravity = 1500
ENT.MinGravity = ENT.Gravity / 5

ENT.Projectiles = {}

function ENT:Initialize()
	self:SetModel("models/roller.mdl")
	self:SetMaterial("models/effects/comball_sphere")
	self:PhysicsInit(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetMaxObjectHealth(300)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		local e = EffectData()
		e:SetOrigin(self:GetPos())
		util.Effect("Explosion", e)
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_defenceprojectile")
	pl:GiveAmmo(1, "defenceprojectile")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:DefenceProjectiles()
	local center = self:LocalToWorld(self:OBBCenter())
	
	-- local allent = ents.FindInSphere(center, self.Radius)
	local allproj = ents.FindByClass("projectile_*")
	
	local td = {}
	td.start = center
	td.filter = {self}
	
	-- local sz = 7
	-- td.mins = Vector(-sz, -sz, -sz)
	-- td.maxs = Vector(sz, sz, sz)
	table.Add(td.filter, player.GetAll())
	table.Add(td.filter, game.GetWorld())
	td.mask = MASK_SHOT
	
	for _, v in pairs(allproj) do
		local projpos = v:GetPos()
		if projpos:Distance(self:GetPos()) <= self.Radius then
			td.endpos = projpos
			
			local trace = util.TraceLine(td)
			
			if trace.HitPos == td.endpos then
				trace.Hit = true
				trace.Entity = v
			end
			
			if trace.Entity == v and !v.defproj then
				if !table.HasValue(self.Projectiles, v) then
					local class = v:GetClass()
					if self:GetOwner().twisterOS and !(string.find(class, "bonemesh") or string.find(class, "poison") or string.find(class, "siegeball")) then
						continue
					end
					table.Add(self.Projectiles, {v})	
					self:SetObjectHealth(self:GetObjectHealth() - self:GetMaxObjectHealth() * 0.003)
				end
				if !table.HasValue(td.filter, v) then
					table.Add(td.filter, {v})
				end
				-- v.defproj = true
				local e = EffectData()
					e:SetOrigin(self:GetPos())
					e:SetScale(v:GetPos():Distance(self:GetPos()))
				util.Effect("defenceprojectile", e)
			end
		end
	end
end

function ENT:PhysicsCollide(data, collider)
	local ent = data.HitEntity
	if IsValid(ent) and string.find(ent:GetClass(), "^projectile_") then
		local e = EffectData()
			e:SetOrigin(self:GetPos())
			e:SetScale(ent:GetPos():Distance(self:GetPos()))
		util.Effect("defenceprojectile", e)
		self:EmitSound("npc/scanner/scanner_electric" .. math.random(1, 2) .. ".wav", 100, 100)
		timer.Simple(0, function()
			ent:Remove()
		end)
	end
end

function ENT:ProcessProjectiles()
	local projectiles = self.Projectiles
	local start = self:LocalToWorld(self:OBBCenter())
	for i, v in pairs(projectiles) do
		if IsValid(v) then
			v:SetParent(NULL)
			
			local pos = v:GetPos()
			local dist = start:Distance(pos)
			local phys = v:GetPhysicsObject()
			local angvec = (self:GetPos() - v:GetPos()):GetNormal()
			
			if dist <= self.Radius then
				local mul = 1 - (dist / self.Radius)
				
				if v.Explode and self:GetOwner().pointGravity then
					if self:GetOwner().twisterOS then
						local class = v:GetClass()
						if string.find(class, "poison") or string.find(class, "bonemesh") or string.find(class, "siegeball") then
							v.Explode = function(self) end
						end
					else
						v.Explode = function(self) end
					end
				end
				
				if IsValid(phys) then
					timer.Create("defproj_" .. tostring(v:EntIndex()), (v.LifeTime and v.LifeTime or 10), 1, function()
						v.Explode = function(self) 
							self:Remove()
						end
					end)
					v:SetGravity(0)
					phys:EnableMotion(true)
					v.OriginalGravity = phys:IsGravityEnabled()
					phys:EnableGravity(false)
					phys:AddVelocity((start - pos):GetNormal() * (math.max(self.Gravity * mul, self.MinGravity)))
					phys:AddAngleVelocity(angvec * math.max(self.Gravity * mul, self.MinGravity))
				end
			else
				if IsValid(phys) then
					phys:EnableGravity(v.OriginalGravity or true)
				end
				table.remove(self.Projectiles, i)
			end
		else
			table.remove(self.Projectiles, i)
		end
	end
end

function ENT:Think()
	self:DefenceProjectiles()
	self:ProcessProjectiles()
	if self.Destroyed then
		for _, v in pairs(self.Projectiles) do
			if IsValid(v) then
				local phys = v:GetPhysicsObject()
				
				if IsValid(phys) then
					v:SetGravity(1)
					phys:EnableGravity(true)
				end
			end
		end
		self:Remove()
	end
	self:NextThink(CurTime())
end
