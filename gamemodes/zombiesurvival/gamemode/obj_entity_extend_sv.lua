local meta = FindMetaTable("Entity")

--[[local o = meta.SetCollisionGroup
function meta:SetCollisionGroup(g)
	print(self, g)
	debug.Trace()
	o(self, g)
end]]

function meta:IsDoorLocked()
	return self:GetSaveTable().m_bLocked
end

function meta:HealPlayer(pl, amount, pointmul, nobymsg, poisononly)
	local healed, rmv = 0, 0

	local health, maxhealth = pl:Health(), pl:IsSkillActive(SKILL_D_FRAIL) and math.floor(pl:GetMaxHealth() * 0.25) or pl:GetMaxHealth()
	local missing_health = maxhealth - health
	local poison = pl:GetPoisonDamage()
	local bleed = pl:GetBleedDamage()

	local healrec = (pl.HealingReceived or 1) - (pl:GetPhantomHealth() > 0.5 and 0.5 or 0) - (pl:GetStatus("sickness") and 0.5 or 0)
	local healmul = self.MedicHealMul or 1
	local multiplier = healmul + healrec - 1
	local regamount = healmul * amount

	amount = amount * multiplier

	-- Heal bleed first.
	if not poisononly and bleed > 0 then
		rmv = math.min(amount, bleed)
		pl:AddBleedDamage(-rmv)
		healed = healed + rmv
		amount = amount - rmv
	end

	-- Heal poison next.
	if poison > 0 and amount > 0 then
		rmv = math.min(amount, poison)
		pl:AddPoisonDamage(-rmv)
		healed = healed + rmv
		amount = amount - rmv
	end

	-- Then heal missing health.
	if not poisononly and missing_health > 0 and amount > 0 then
		rmv = math.min(amount, missing_health)
		pl:SetHealth(health + rmv)
		healed = healed + rmv
		amount = amount - rmv
	end

	pointmul = (pointmul or 1) / (math.max(healed, regamount) / regamount)

	if healed > 0 and self:IsPlayer() then
		gamemode.Call("PlayerHealedTeamMember", self, pl, healed, self:GetActiveWeapon(), pointmul, nobymsg, healed >= 10)
		pl:SetPhantomHealth(math.max(0, pl:GetPhantomHealth() - healed))
	end

	return healed
end

local healthpropscalar = {
	["models/props_c17/door01_left.mdl"] = 0.7
}

function meta:GetDefaultBarricadeHealth()
	local mass = 2
	if self._OriginalMass then
		mass = self._OriginalMass
	else
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			mass = phys:GetMass()
		end
	end

	local mdl = string.lower(self:GetModel())
	local scalar = healthpropscalar[mdl] or 1

	return math.Clamp((mass * GAMEMODE.BarricadeHealthMassFactor + self:GetVolume() * GAMEMODE.BarricadeHealthVolumeFactor) * scalar, GAMEMODE.BarricadeHealthMin, GAMEMODE.BarricadeHealthMax)
end

function meta:HitFence(data, phys)
	local pos = phys:GetPos()
	local vel = data.OurOldVelocity
	local endpos = data.HitPos + vel:GetNormalized()
	if util.TraceLine({start = pos, endpos = endpos, mask = MASK_SOLID, filter = self}).Hit and not util.TraceLine({start = pos, endpos = endpos, mask = MASK_SHOT, filter = self}).Hit then -- Essentially hit a fence or passable object.
		self:SetPos(data.HitPos)
		phys:SetPos(data.HitPos)
		phys:SetVelocityInstantaneous(vel)

		return true
	end

	return false
end

function meta:FakePropBreak()
	local ent = ents.Create("prop_physics")
	if ent:IsValid() then
		ent:SetModel(self:GetModel())
		ent:SetMaterial(self:GetMaterial())
		ent:SetAngles(self:GetAngles())
		ent:SetPos(self:GetPos())
		ent:SetSkin(self:GetSkin() or 0)
		ent:SetColor(self:GetColor())
		ent:Spawn()
		ent:Fire("break", "", 0)
		ent:Fire("kill", "", 0.1)
	end
end

function meta:SetBarricadeHealth(m)
	self:SetDTFloat(1, m)
end

function meta:SetMaxBarricadeHealth(m)
	self:SetDTFloat(2, m)
end

function meta:SetBarricadeRepairs(m)
	self:SetDTFloat(3, m)
end

function meta:GhostAllPlayersInMe(timeout, allowrepeat)
	if not allowrepeat then
		if self.GhostedBefore then return end
		self.GhostedBefore = true
	end

	if self.PreHoldCollisionGroup and self.PreHoldCollisionGroup == COLLISION_GROUP_DEBRIS_TRIGGER then return end -- No need to ghost.

	local ent = ents.Create("point_propnocollide")
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:Spawn()
		if timeout then
			ent:SetTimeOut(CurTime() + timeout)
		end
		ent:SetTeam(TEAM_HUMAN)

		ent:SetProp(self)

		return ent
	end
end

function meta:AddUselessDamage(damage)
	self.UselessDamage = (self.UselessDamage or 0) + damage
end

function meta:RemoveUselessDamage(damage)
	if self.UselessDamage then
		damage = math.min(self.UselessDamage, damage)
		self.UselessDamage = self.UselessDamage - damage

		return damage
	end

	return 0
end

function meta:ClearUselessDamage()
	self.UselessDamage = nil
end

local function SortItems(a, b)
	if a.CleanupPriority == b.CleanupPriority then
		return a.Created < b.Created
	end

	return a.CleanupPriority < b.CleanupPriority
end
local function CheckItemCreated(self)
	if not self:IsValid() or self.PlacedInMap then return end

	local tab = {}
	for _, ent in pairs(ents.FindByClass("prop_ammo")) do
		if not ent.PlacedInMap then
			table.insert(tab, ent)
		end
	end
	for _, ent in pairs(ents.FindByClass("prop_weapon")) do
		if not ent.PlacedInMap then
			table.insert(tab, ent)
		end
	end

	if #tab > GAMEMODE.MaxDroppedItems then
		table.sort(tab, SortItems)
		for i = 1, GAMEMODE.MaxDroppedItems do
			tab[i]:Remove()
		end
	end
end
function meta:ItemCreated()
	self.Created = self.Created or CurTime()
	timer.Simple(0, function() CheckItemCreated(self) end)
end

function meta:FireOutput(outpt, activator, caller, args)
	local intab = self[outpt]
	if intab then
		for key, tab in pairs(intab) do
			local param = ((tab.args == "") and args) or tab.args
			for __, subent in pairs(self:FindByNameHammer(tab.entityname, activator, caller)) do
				local delay = tonumber(tab.delay)
				if delay == nil or delay <= 0 then
					subent:Input(tab.input, activator, caller, param)
				else
					local inp = tab.input
					timer.Simple(delay, function() if subent:IsValid() then subent:Input(inp, activator, caller, param) end end)
				end
			end
		end
	end
end

function meta:AddOnOutput(key, value)
	self[key] = self[key] or {}
	local tab = string.Explode(",", value)
	table.insert(self[key], {entityname=tab[1], input=tab[2], args=tab[3], delay=tab[4], reps=tab[5]})
end

function meta:FindByNameHammer(name, activator, caller)
	if name == "!self" then return {self} end
	if name == "!activator" then return {activator} end
	if name == "!caller" then return {caller} end
	return ents.FindByName(name)
end

function meta:IsNailed()
	if self:IsValid() and self.Nails then -- In case we're the world.
		for _, nail in pairs(self.Nails) do
			if nail and nail:IsValid() and (nail:GetAttachEntity() == self or nail:GetBaseEntity() == self) then
				return true
			end
		end
	end

	return false
end

function meta:IsNailedToWorld(hierarchy)
	if self:IsNailed() then
		for _, nail in pairs(self.Nails) do
			if nail:GetAttachEntity():IsWorld() then
				return true
			end
		end
	end

	if hierarchy then
		for _, ent in pairs(self:GetAllConstrainedEntities()) do
			if ent ~= self and ent:IsValid() and ent:IsNailedToWorld() then return true end
		end
	end

	return false
end

function meta:IsNailedToWorldHierarchy()
	return self:IsNailedToWorld(true)
end

function meta:GetNailFrozen()
	return self.m_NailFrozen
end
meta.IsNailFrozen = meta.GetNailFrozen

function meta:SetNailFrozen(frozen)
	if frozen then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() and phys:IsMoveable() then
			self.m_NailFrozen = true
			phys:EnableMotion(false)
		end
	elseif self:IsNailFrozen() then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			self.m_NailFrozen = false
			phys:EnableMotion(true)
			phys:Wake()
		end
	end
end

function constraint.GetAllConstrainedEntitiesOrdered(ent)
	local allcons = constraint.GetAllConstrainedEntities(ent)

	local tab = {}

	if allcons then
		for k, v in pairs(allcons) do
			table.insert(tab, v)
		end
	end

	return tab
end

function meta:GetAllConstrainedEntities()
	local allcons = constraint.GetAllConstrainedEntitiesOrdered(self)
	if not allcons or #allcons == 0 then
		return {self}
	end

	return allcons
end

function meta:PackUp(pl)
	if not self.CanPackUp then return end

	local cur = pl:GetStatus("packup")
	if cur and cur:IsValid() then return end

	local status = pl:GiveStatus("packup")
	if status:IsValid() then
		status:SetPackUpEntity(self)
		status:SetEndTime(CurTime() + (self.PackUpTime or 3) * (not self.IgnorePackTimeMul and pl.DeployablePackTimeMul or 1))

		if self.GetObjectOwner then
			local owner = self:GetObjectOwner()
			if owner:IsValid() and owner:Team() == TEAM_HUMAN and owner ~= pl and not gamemode.Call("PlayerIsAdmin", pl) then
				status:SetNotOwner(true)
			end
		end
	end
end

function meta:GetPropsInContraption()
	local allcons = constraint.GetAllConstrainedEntities(self)
	if not allcons or #allcons == 0 then
		return 1
	end

	return #allcons
end

function meta:HumanNearby()
	for _, pl in pairs(team.GetPlayers(TEAM_HUMAN)) do
		if pl:Alive() and self:GetPos():DistToSqr(pl:GetPos()) <= 262144 then -- 512^2
			return true
		end
	end
end

function meta:ResetLastBarricadeAttacker(attacker, dmginfo)
	if attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
		self.m_LastDamagedByZombie = CurTime()

		if self:HumanNearby() then
			local dmg = math.ceil(dmginfo:GetDamage())
			attacker.BarricadeDamage = attacker.BarricadeDamage + dmg
			if attacker.LifeBarricadeDamage ~= nil then
				attacker:AddLifeBarricadeDamage(dmg)
				GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_ZOMBIECLASS, attacker:GetZombieClassTable().Name, "BarricadeDamage", dmg)
			end
		end
	end
end

meta.OldSetPhysicsAttacker = meta.SetPhysicsAttacker
function meta:SetPhysicsAttacker(ent)
	if string.sub(self:GetClass(), 1, 12) == "func_physbox" and ent:IsValid() then
		self.PBAttacker = ent
		self.NPBAttacker = CurTime() + 5
	end
	self:OldSetPhysicsAttacker(ent)
end

-- Return true to override default behavior.
function meta:DamageNails(attacker, inflictor, damage, dmginfo)
	if not self:IsNailed() or self.m_NailsDontAbsorb then return end

	-- Props that don't have barricade health yet might still be nailed to something.
	local nails = self:GetLivingNails()
	local isattach = false
	for i, nail in ipairs(nails) do
		isattach = self == nail:GetAttachEntity() or isattach
	end

	if self:GetBarricadeHealth() <= 0 and not isattach then return end

	if not gamemode.Call("CanDamageNail", self, attacker, inflictor, damage, dmginfo) then
		if dmginfo then
			dmginfo:SetDamage(0)
			dmginfo:SetDamageType(DMG_GENERIC)
		end

		return true
	end

	-- No physics damage to props. Stops ramming/thrown weapons damaging them.
	if damage < 0 or dmginfo:GetDamageType() == DMG_CRUSH then
		if dmginfo then
			dmginfo:SetDamage(0)
		end

		return true
	end

	if self.ReinforceEnd and CurTime() < self.ReinforceEnd and self.ReinforceApplier and self.ReinforceApplier:IsValidLivingHuman() then
		local applier = self.ReinforceApplier
		local multi = 0.92
		local dmgbefore = damage * 0.08
		local points = dmgbefore / 8

		dmginfo:SetDamage(dmginfo:GetDamage() * multi)
		damage = damage * multi

		applier.PropDef = (applier.PropDef or 0) + dmgbefore
		applier:AddPoints(points)
	end

	if gamemode.Call("IsEscapeDoorOpen") then
		local multi = gamemode.Call("GetEscapeStage") * 1.5

		dmginfo:SetDamage(dmginfo:GetDamage() * multi)
		damage = damage * multi
	end

	self:ResetLastBarricadeAttacker(attacker, dmginfo)

	if #nails <= 0 then return end

	if attacker:IsPlayer() then
		-- :O)
		if attacker.SpawnProtection then
			damage = damage * 5
			dmginfo:SetDamage(damage)
			self:AddUselessDamage(damage)
		end

		GAMEMODE:DamageFloater(attacker, self, dmginfo:GetDamagePosition(), dmginfo:GetDamage())
	end

	self:SetBarricadeHealth(self:GetBarricadeHealth() - damage)
	for i, nail in ipairs(nails) do
		nail:OnDamaged(damage, attacker, inflictor, dmginfo)
	end

	-- No points for repairing damage from fire, trigger_hurt, etc.
	if not attacker:IsZombie() then
		self:AddUselessDamage(damage)
	end

	attacker.LastBarricadeHit = CurTime()

	if dmginfo then dmginfo:SetDamage(0) end

	if self:GetBarricadeHealth() <= 0 then
		if self:GetModel() ~= "" and self:GetModel() ~= "models/error.mdl" then
			if self:GetName() == "" and self:GetVolume() < 100 then
				self:Fire("break", "", 0.01)
				self:Fire("kill", "", 0.05)
			else
				local ent = ents.Create("env_propbroken")
				if ent:IsValid() then
					ent:Spawn()
					ent:AttachTo(self)
				end
			end
		end

		for _, nail in pairs(nails) do
			self:RemoveNail(nail, nil, nil, true)
		end
	end

	return true
end

function meta:GetNails()
	local tab = {}

	if self.Nails then
		for _, nail in pairs(self.Nails) do
			if nail and nail:IsValid() then
				table.insert(tab, nail)
			end
		end
	end

	return tab
end

function meta:GetLivingNails()
	local tab = {}

	if self.Nails then
		for _, nail in pairs(self.Nails) do
			if nail and nail:IsValid() and nail:GetNailHealth() > 0 then
				table.insert(tab, nail)
			end
		end
	end

	return tab
end

function meta:NumLivingNails()
	local amount = 0

	if self.Nails then
		for _, nail in pairs(self.Nails) do
			if nail and nail:IsValid() and nail:GetNailHealth() > 0 then
				amount = amount + 1
			end
		end
	end

	return amount
end

function meta:GetFirstNail()
	if self.Nails then
		for i, nail in ipairs(self.Nails) do
			if nail and nail:IsValid() and not nail:GetAttachEntity():IsValid() then return nail end
		end
		for i, nail in ipairs(self.Nails) do
			if nail and nail:IsValid() then return nail end
		end
	end
end

local function GetNailOwner(nail, filter)
	for _, ent in pairs(ents.GetAll()) do
		if ent and ent ~= filter and ent.Nails and ent:IsValid() then
			for __, n in pairs(ent.Nails) do
				if n == nail then
					return ent
				end
			end
		end
	end

	return game.GetWorld()
end

function meta:RemoveNail(nail, dontremoveentity, removedby, forceremoveconstraint)
	if not self:IsNailed() then return end

	if not nail then
		nail = self:GetFirstNail()
	end

	if not nail or not nail:IsValid() then return end

	local cons = nail:GetNailConstraint()
	local othernails = 0
	if not forceremoveconstraint then
		for _, othernail in pairs(ents.FindByClass("prop_nail")) do
			if othernail ~= nail and not nail.m_IsRemoving and othernail:GetNailConstraint():IsValid() and othernail:GetNailConstraint() == cons then
				othernails = othernails + 1
			end
		end
	end

	-- Only remove the constraint if it's the last nail.
	if othernails == 0 and cons:IsValid() then
		if self.PropHealth and self:GetBarricadeHealth() > 0 then
			local repairs_frac = self:GetBarricadeRepairs() / self:GetMaxBarricadeRepairs()

			if repairs_frac < 0.5 then
				self.PropHealth = math.min(self.PropHealth, self:GetBarricadeHealth())

				local brit = math.Clamp(self.PropHealth / self.TotalHealth, 0, 1)
				local col = self:GetColor()
				col.r = 255
				col.g = 255 * brit
				col.b = 255 * brit
				self:SetColor(col)
			end
		end
		cons:Remove()
	end

	local ent2 = GetNailOwner(nail, self)

	for i, n in ipairs(self.Nails) do
		if n == nail then
			table.remove(self.Nails, i)
			break
		end
	end

	if ent2 and ent2.Nails then
		for i, n in ipairs(ent2.Nails) do
			if n == nail then
				table.remove(ent2.Nails, i)
				ent2:TemporaryBarricadeObject()
				break
			end
		end
	end

	self:TemporaryBarricadeObject()

	gamemode.Call("OnNailRemoved", nail, self, ent2, removedby)

	if not dontremoveentity then
		nail:Remove()
		nail.m_IsRemoving = true
	end

	self:RecalculateNailBonuses()
	self:CollisionRulesChanged()

	if ent2 and ent2:IsValid() then
		ent2:CollisionRulesChanged()
	end

	return true
end

function meta:RemoveNextFrame(time)
	self.Removing = true
	self:Fire("kill", "", time or 0.01)
end

local function barricadetimer(self, timername)
	if self:IsValid() then
		for _, e in pairs(ents.FindInBox(self:WorldSpaceAABB())) do
			if e and e:IsValid() and e:IsPlayer() and e:Alive() then
				return
			end
		end

		self.IsBarricadeObject = nil
		self:CollisionRulesChanged()
	end

	timer.Remove(timername)
end
function meta:TemporaryBarricadeObject()
	if self.IsBarricadeObject then return end

	for _, e in pairs(ents.FindInBox(self:WorldSpaceAABB())) do
		if e and e:IsValid() and e:IsPlayer() and e:Alive() then
			self.IsBarricadeObject = true
			self:CollisionRulesChanged()

			local timername = "TemporaryBarricadeObject"..self:GetCreationID()
			timer.Create(timername, 0, 0, function() barricadetimer(self, timername) end)

			return
		end
	end
end

function meta:RecalculateNailBonuses()
	local max_health = self:GetMaxBarricadeHealth()
	if max_health == 0 then return end

	local num_extra_nails = math.Clamp(self:NumLivingNails() - 1, 0, 3)
	local repairs_frac = self:GetBarricadeRepairs() / self:GetMaxBarricadeRepairs()

	self.OriginalMaxHealth = self.OriginalMaxHealth or max_health
	self.OriginalMaxBarricadeRepairs = self.OriginalMaxBarricadeRepairs or max_repairs

	local health = self:GetBarricadeHealth()
	local new_max_health = self.OriginalMaxHealth + num_extra_nails * GAMEMODE.ExtraHealthPerExtraNail
	self:SetMaxBarricadeHealth(new_max_health)
	self:SetBarricadeHealth(health / max_health * new_max_health)

	self:SetBarricadeRepairs(repairs_frac * self:GetMaxBarricadeRepairs())
end

function meta:SetupDeployableSkillHealth(extramodifier)
	local owner = self:GetObjectOwner()
	local newmaxhealth = self.MaxHealth or self:GetMaxObjectHealth()
	local currentmaxhealth = self:GetMaxObjectHealth()

	if owner:IsValid() then
		newmaxhealth = newmaxhealth * owner:GetTotalAdditiveModifier("DeployableHealthMul", extramodifier)
	end

	newmaxhealth = math.ceil(newmaxhealth)
	self:SetMaxObjectHealth(newmaxhealth)
	self:SetObjectHealth(self:GetObjectHealth() / currentmaxhealth * newmaxhealth)
end

function meta:DealProjectileTraceDamage(damage, tr, owner)
	local ent = tr.Entity

	local damageinfo = DamageInfo()
	damageinfo:SetDamageType(DMG_BULLET)
	damageinfo:SetDamage(damage)
	damageinfo:SetDamagePosition(tr.HitPos)
	damageinfo:SetAttacker(owner)
	damageinfo:SetInflictor(self:ProjectileDamageSource())

	local vel
	if ent:IsPlayer() then
		ent:SetLastHitGroup(tr.HitGroup)
		if tr.HitGroup == HITGROUP_HEAD then
			ent:SetWasHitInHead()
		end

		vel = ent:GetVelocity()
	end

	ent:DispatchTraceAttack(damageinfo, tr, tr.Normal)

	if vel and ent:IsPlayer() and owner ~= ent then
		ent:SetLocalVelocity(vel)
	end
end

GM.ProjectileThickness = 3

function meta:ProjectileTraceAhead(phys)
	if not self.Touched then
		local vel = self.PreVel or phys:GetVelocity()
		if self.PreVel then self.PreVel = nil end

		local velnorm = vel:GetNormalized()

		local ahead = (vel:LengthSqr() * FrameTime()) / 1200
		local fwd = velnorm * ahead
		local start = self:GetPos() - fwd
		local side = vel:Angle():Right() * GAMEMODE.ProjectileThickness

		local proj_trace = {mask = MASK_SHOT, filter = {self, team.GetPlayers(TEAM_HUMAN)}}

		proj_trace.start = start - side
		proj_trace.endpos = start - side + fwd

		local tr = util.TraceLine(proj_trace)

		proj_trace.start = start + side
		proj_trace.endpos = start + side + fwd

		local tr2 = util.TraceLine(proj_trace)
		local trs = {tr, tr2}

		for _, trace in pairs(trs) do
			if trace.Entity then
				local ent = trace.Entity

				if ent:IsValidLivingZombie() or ent.ZombieConstruction then
					self.Touched = trace
				end

				break
			end
		end
	end
end

-- Cache invisible entities every so often, for TrueVisible functions. Fixes a few issues and improves performance.
GM.CachedInvisibleEntities = {}
timer.Create("CachedInvisibleEntities", 1, 0, function()
	if not GAMEMODE then return end
	GAMEMODE.CachedInvisibleEntities = {}

	local invisents = player.GetAll()
	for _, ent in pairs(ents.GetAll()) do
		if ent.IgnoreTraces or ent.NoBlockExplosions then
			invisents[#invisents + 1] = ent
		end
	end

	GAMEMODE.CachedInvisibleEntities = invisents
end)
