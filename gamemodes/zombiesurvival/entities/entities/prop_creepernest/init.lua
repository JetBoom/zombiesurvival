AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.NextDecay = 0
ENT.BuildsThisTick = 0
ENT.HealRadius = 225
ENT.HealedList = {}
ENT.LastNestBonus = 0
ENT.NestBrains = 0

function ENT:Initialize()
	self:SetModel("models/props_wasteland/antlionhill.mdl")
	self:PhysicsInitBox(Vector(-20, -20, 0), Vector(20, 20, 40))
	self:SetCollisionBounds(Vector(-20, -20, 0), Vector(20, 20, 40))
	self:SetUseType(SIMPLE_USE)

	--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged()

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
	local owner = self.Owner
	if CurTime() ~= self.LastBuildTime then
		self.LastBuildTime = CurTime()
		self.BuildsThisTick = 0
	end

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
	
	if self:GetNestBuilt() then
		for _, v in pairs(player.GetAll()) do
			if v:Team() == TEAM_ZOMBIE then
				if v:GetPos():Distance(self:GetPos()) <= self.HealRadius then
					if (v:Health() < v:GetMaxZombieHealth()) and v:Alive() then
						self:Heal(v)
					else
						self:ResetHealedList(v:UniqueID())
					end
				else
					self:ResetHealedList(v:UniqueID())
				end
			end
		end
	end
end

function ENT:ResetHealedList(uid)
	if (self.HealedList[uid] and self.HealedList[uid].nextHeal) then
		self.HealedList[uid].nextHeal = CurTime() + 1
	end
end

function ENT:Heal(zombie)
	local hlist = self.HealedList
	local uid = zombie:UniqueID()
	
	local curtime = CurTime()
	local boss = zombie:GetZombieClassTable().Boss
	
	if !hlist[uid] then
		hlist[uid] = {
			nextHeal = curtime
		}
	end
	
	local heal = 0
	
	if hlist[uid].nextHeal <= curtime and zombie:Health() < zombie:GetMaxZombieHealth() then
		if (hlist[uid] != nil and hlist[uid].nextHeal != nil) then
			if (hlist[uid].nextHeal < curtime) then
				local elapsedtime = curtime - hlist[uid].nextHeal
				
				if (elapsedtime < 0.3) then
					return
				end
				
				heal = ((boss and 1 or 2) * elapsedtime) / (boss and 0.35 or 0.15)
				zombie:SetHealth(math.min(zombie:Health() + heal, zombie:GetMaxZombieHealth()))
				hlist[uid].nextHeal = curtime + (boss and 0.35 or 0.15)
			end
		end
		
		local ed = EffectData()
		
			ed:SetOrigin(zombie:LocalToWorld(zombie:OBBCenter()))
		
		util.Effect("nestheal", ed)
	end
	
	self.HealedList = hlist
end

function ENT:OnTakeDamage(dmginfo)
	if self:GetNestHealth() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
		local owner = self.Owner
		if attacker:GetZombieClassTable().Name ~= "Flesh Creeper" then
			return
		end

		if owner and owner:IsValid() and owner:Team() == TEAM_UNDEAD and owner ~= attacker and not attacker:IsAdmin() and owner:GetZombieClassTable().Name == "Flesh Creeper" and owner:Alive() and owner:GetPos():Distance(self:GetPos()) <= 768 then
			attacker:CenterNotify(COLOR_RED, translate.ClientFormat(attacker, "x_has_built_this_nest_and_is_still_around", owner))
			return
		end

		if #ents.FindByClass(self:GetClass()) == 1 and not attacker:IsAdmin() and owner ~= attacker then
			attacker:CenterNotify(COLOR_RED, translate.ClientGet(attacker, "no_other_nests"))
			return
		end
	end

	self:SetNestHealth(self:GetNestHealth() - dmginfo:GetDamage())
	self:SetNestLastDamaged(CurTime())

	if self:GetNestHealth() <= 0 then
		if self:GetNestBuilt() and attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
			attacker:AddPoints(5)
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
