local meta = FindMetaTable("Entity")
if not meta then return end

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

	return math.Clamp(mass * GAMEMODE.BarricadeHealthMassFactor + self:GetVolume() * GAMEMODE.BarricadeHealthVolumeFactor, GAMEMODE.BarricadeHealthMin, GAMEMODE.BarricadeHealthMax)
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

function meta:GhostAllPlayersInMe(timeout, allowrepeat)
	if not allowrepeat then
		if self.GhostedBefore then return end
		self.GhostedBefore = true
	end

	local ent = ents.Create("point_propnocollide")
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:Spawn()
		if timeout then
			ent:SetTimeOut(CurTime() + timeout)
		end
		ent:SetTeam(TEAM_HUMAN)

		ent:SetProp(self)
	end
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
		status:SetEndTime(CurTime() + (self.PackUpTime or 4))

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
		local plpos = pl:GetPos()
		if pl:Alive() and self:NearestPoint(plpos):Distance(plpos) <= 512 then
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
			end
			if attacker:GetZombieClassTable().Name == "Crow" then
				attacker.CrowBarricadeDamage = attacker.CrowBarricadeDamage + dmg
			end
		end
	end
end

meta.OldSetPhysicsAttacker = meta.SetPhysicsAttacker
function meta:SetPhysicsAttacker(ent)
	if string.sub(self:GetClass(), 1, 12) == "func_physbox" and ent:IsValid() then
		self.PBAttacker = ent
		self.NPBAttacker = CurTime() + 1
	end
	self:OldSetPhysicsAttacker(ent)
end

local function randomsort(a, b)
	return a.rand < b.rand
end
local function randomize(t)
	for k, v in pairs(t) do v.rand = math.Rand(0, 1) end
	table.sort(t, randomsort)
end

-- Return true to override default behavior.
function meta:DamageNails(attacker, inflictor, damage, dmginfo)
	if not self:IsNailed() or self.m_NailsDontAbsorb then return end

	if self:GetBarricadeHealth() <= 0 then return end

	if not gamemode.Call("CanDamageNail", self, attacker, inflictor, damage, dmginfo) then
		if dmginfo then
			dmginfo:SetDamage(0)
			dmginfo:SetDamageType(DMG_BULLET)
		end

		return true
	end

	if damage < 0 then
		if dmginfo then
			dmginfo:SetDamage(0)
		end

		return true
	end

	self:ResetLastBarricadeAttacker(attacker, dmginfo)

	local nails = self:GetLivingNails()
	if #nails <= 0 then return end

	self:SetBarricadeHealth(self:GetBarricadeHealth() - damage)
	for i, nail in ipairs(nails) do
		nail:OnDamaged(damage, attacker, inflictor, dmginfo)
	end

	if attacker:IsPlayer() then
		GAMEMODE:DamageFloater(attacker, self, dmginfo)
	end

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
			self:RemoveNail(nail)
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

function meta:RemoveNail(nail, dontremoveentity, removedby)
	if not self:IsNailed() then return end

	if not nail then
		nail = self:GetFirstNail()
	end

	if not nail or not nail:IsValid() then return end

	local cons = nail:GetNailConstraint()
	local othernails = 0
	for _, othernail in pairs(ents.FindByClass("prop_nail")) do
		if othernail ~= nail and not nail.m_IsRemoving and othernail:GetNailConstraint():IsValid() and othernail:GetNailConstraint() == cons then
			othernails = othernails + 1
		end
	end

	-- Only remove the constraint if it's the last nail.
	if othernails == 0 and cons:IsValid() then
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

	return true
end
