INC_SERVER()

ENT.NextDecay = 0
ENT.BuildsThisTick = 0
ENT.ZombieConstruction = true

function ENT:Initialize()
	self:SetModel("models/props_wasteland/antlionhill.mdl")
	self:PhysicsInitBox(Vector(-18, -18, 0), Vector(18, 18, 36))
	self:SetCollisionBounds(Vector(-18, -18, 0), Vector(18, 18, 36))
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.2, 0)
	self:SetUseType(SIMPLE_USE)

	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged() --self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	self:ManipulateBoneScale(0, self.ModelScale)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("flesh")
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetNestHealth(self.MaxHealth)

	self.LastBuild = CurTime()
end

function ENT:BuildUp()
	if CurTime() ~= self.LastBuildTime then
		self.LastBuildTime = CurTime()
		self.BuildsThisTick = 0
	end

	if self:GetNestLastDamaged() + 1 > CurTime() then return end

	if self.BuildsThisTick < 3 then
		self.BuildsThisTick = self.BuildsThisTick + 1

		self:SetNestHealth(math.min(self:GetNestHealth() + FrameTime() * self:GetNestMaxHealth() * 0.1, self:GetNestMaxHealth()))
	end
end

function ENT:Use()
end

function ENT:Think()
	if not self:GetNestBuilt() then
		local time = CurTime()
		if time >= self.LastBuild + 10 and time >= self.NextDecay then
			self.NextDecay = time + 1

			self:TakeDamage(5)
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self:GetNestHealth() <= 0 or dmginfo:GetDamage() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
		local owner = self:GetNestOwner()
		if attacker:GetZombieClassTable().Name ~= "Flesh Creeper" then
			return
		end

		if owner and owner:IsValidZombie() and owner ~= attacker and not attacker:IsAdmin() and owner:GetZombieClassTable().Name == "Flesh Creeper" and owner:Alive() and owner:GetPos():DistToSqr(self:GetPos()) <= 589824 then --768^2
			attacker:CenterNotify(COLOR_RED, translate.ClientFormat(attacker, "x_has_built_this_nest_and_is_still_around", owner:Name()))
			return
		end

		-- Disabled. Small maps can be limited to 1 nest due to their layout and it can result in an indestructible nest that hampers zombie progress.
		--[[if #ents.FindByClass(self:GetClass()) == 1 and not attacker:IsAdmin() and owner ~= attacker then
			attacker:CenterNotify(COLOR_RED, translate.ClientGet(attacker, "no_other_nests"))
			return
		end]]
	end

	local damage = dmginfo:GetDamage() * (dmginfo:GetInflictor().FlyingControllable and 0.3 or 1)
	if self:GetNestBuilt() and attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		local points = damage / self:GetNestMaxHealth() * 5

		attacker.PointQueue = attacker.PointQueue + points

		local pos = self:GetPos()
		pos.z = pos.z + 32

		attacker.LastDamageDealtPos = pos
		attacker.LastDamageDealtTime = CurTime()
	end

	self:SetNestHealth(self:GetNestHealth() - damage)
	self:SetNestLastDamaged(CurTime())

	if self:GetNestHealth() <= 0 then
		if self:GetNestBuilt() and attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
			--attacker:AddPoints(5)
			attacker.NestsDestroyed = attacker.NestsDestroyed + 1
		end

		gamemode.Call("NestDestroyed", self, attacker)

		self:Destroy()
	end
end

function ENT:Destroy()
	self.Destroyed = true

	local pos = self:WorldSpaceCenter()

	local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetOrigin(pos)
	util.Effect("gib_player", effectdata, true, true)

	util.Blood(pos, 100, self:GetUp(), 256)

	self:Fire("kill", "", 0.01)
end

function ENT:OnRemove()
	if self.Destroyed and self:GetNestBuilt() then
		for _, pl in pairs(team.GetPlayers(TEAM_UNDEAD)) do
			pl:CenterNotify(COLOR_RED, translate.ClientFormat(pl, "nest_destroyed", name))
		end

		local pos = self:WorldSpaceCenter()
		for i=1, 8 do
			local ent = ents.CreateLimited("prop_playergib")
			if ent:IsValid() then
				ent:SetPos(pos + VectorRand() * 12)
				ent:SetAngles(VectorRand():Angle())
				ent:SetGibType(math.random(3, #GAMEMODE.HumanGibs))
				ent:Spawn()
			end
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
