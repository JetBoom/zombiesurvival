include("registry.lua")

-- These are inverse functions of eachother!
function GM:LevelForXP(xp)
	--return math.floor(1 + 1 * math.sqrt(xp))
	return math.floor(1 + 0.25 * math.sqrt(xp))
end

function GM:XPForLevel(level)
	--return level * level - 2 * level + 1
	return 16 * level * level - 32 * level + 16
end

function GM:ProgressForXP(xp)
	local current_level = self:LevelForXP(xp)
	if current_level >= self.MaxLevel then return 1 end

	local current_level_xp = self:XPForLevel(current_level)
	local next_level_xp = self:XPForLevel(current_level + 1)

	return (xp - current_level_xp) / (next_level_xp - current_level_xp)
end

GM.MaxLevel = 50
GM.MaxXP = GM:XPForLevel(GM.MaxLevel)

-- Makes sure all skill connections are double linked
function GM:FixSkillConnections()
	for skillid, skill in pairs(self.Skills) do
		for connectid, _ in pairs(skill.Connections) do
			local otherskill = self.Skills[connectid]
			if otherskill and not otherskill.Connections[skillid] then
				otherskill.Connections[skillid] = true
			end
		end
	end
end

function GM:SkillIsNeighbor(skillid, otherskillid)
	local myskill = self.Skills[skillid]
	return myskill ~= nil and self.Skills[otherskillid] ~= nil and myskill.Connections[otherskillid]
end

function GM:SkillCanUnlock(pl, skillid, skilllist)
	local skill = self.Skills[skillid]
	if skill then
		if skill.RemortLevel and pl:GetZSRemortLevel() < skill.RemortLevel then
			return false
		end

		local connections = skill.Connections

		if connections[SKILL_NONE] then
			return true
		end

		for _, myskillid in pairs(skilllist) do
			if connections[myskillid] then
				return true
			end
		end
	end

	return false
end

local meta = FindMetaTable("Player")
if not meta then return end

function meta:IsSkillUnlocked(skillid)
	return table.HasValue(self:GetUnlockedSkills(), skillid)
end

function meta:SkillCanUnlock(skillid)
	return GAMEMODE:SkillCanUnlock(self, skillid, self:GetUnlockedSkills())
end

function meta:IsSkillDesired(skillid)
	return table.HasValue(self:GetDesiredActiveSkills(), skillid)
end

function meta:IsSkillActive(skillid)
	return self:GetActiveSkills()[skillid]-- == true
end

function meta:HasTrinket(trinket)
	return self:HasInventoryItem("trinket_" .. trinket)
end

function meta:CreateTrinketStatus(status)
	for _, ent in pairs(ents.FindByClass("status_" .. status)) do
		if ent:GetOwner() == self then return end
	end

	local ent = ents.Create("status_" .. status)
	if ent:IsValid() then
		ent:SetPos(self:EyePos())
		ent:SetParent(self)
		ent:SetOwner(self)
		ent:Spawn()
	end
end

function meta:ApplyAssocModifiers(assoc)
	local skillmodifiers = {}
	local gm_modifiers = GAMEMODE.SkillModifiers
	for skillid in pairs(assoc) do
		local modifiers = gm_modifiers[skillid]
		if modifiers then
			for modid, amount in pairs(modifiers) do
				skillmodifiers[modid] = (skillmodifiers[modid] or 0) + amount
			end
		end
	end

	for modid, func in pairs(GAMEMODE.SkillModifierFunctions) do
		func(self, skillmodifiers[modid] or 0)
	end
end

-- These are done on human spawn.
function meta:ApplySkills(override)
	if GAMEMODE.ZombieEscape or GAMEMODE.ClassicMode then return end -- Skills not used on these modes

	local allskills = GAMEMODE.Skills
	local desired = override or self:Alive() and self:Team() == TEAM_HUMAN and self:GetDesiredActiveSkills() or {}
	local current_active = self:GetActiveSkills()
	local desired_assoc = table.ToAssoc(desired)

	-- Do we even have these skills unlocked?
	if not override then
		for skillid in pairs(desired_assoc) do
			if not self:IsSkillUnlocked(skillid) or allskills[skillid] and allskills[skillid].Disabled then
				desired_assoc[skillid] = nil
			end
		end
	end

	self:ApplyAssocModifiers(desired_assoc)

	-- All skill function states can easily be kept track of.
	local funcs
	local gm_functions = GAMEMODE.SkillFunctions
	for skillid in pairs(allskills) do

		funcs = gm_functions[skillid]
		if funcs then
			if current_active[skillid] and not desired_assoc[skillid] then -- On but we want it off.
				for _, func in pairs(funcs) do
					func(self, false)
				end
			elseif desired_assoc[skillid] and not current_active[skillid] then -- Off but we want it on.
				for _, func in pairs(funcs) do
					func(self, true)
				end
			end -- Otherwise it's already in the state we want.
		end
	end

	-- Store and sync with client.
	self:SetActiveSkills(desired_assoc, not self.PlayerReady)

	if SERVER and self.ExtraStartingWorth ~= self.LastSentESW then
		self.LastSentESW = self.ExtraStartingWorth
		net.Start("zs_extrastartingworth")
			net.WriteUInt(self.ExtraStartingWorth, 16)
		net.Send(self)
	end
end

-- For trinkets, these apply after your skills, and they need to work differently so they can't be used to "update" your skills midgame.
function meta:ApplyTrinkets(override)
	if GAMEMODE.ZombieEscape or GAMEMODE.ClassicMode then return end -- Skills not used on these modes

	local allskills = GAMEMODE.Skills
	local current_active = self:GetActiveSkills()
	local real_assoc = table.ToAssoc(current_active)

	if not override then
		for skillid, skilltbl in pairs(allskills) do
			if skilltbl.Trinket then
				local hastrinket = self:HasTrinket(skilltbl.Trinket)
				real_assoc[skillid] = hastrinket and true or nil

				if SERVER then
					if skilltbl.PairedWeapon then
						local pairedwep = "weapon_zs_t_"..skilltbl.Trinket
						if hastrinket and not self:HasWeapon(pairedwep) then
							self:Give(pairedwep)
						elseif not hastrinket and self:HasWeapon(pairedwep) then
							self:StripWeapon(pairedwep)
						end
					end

					if hastrinket and skilltbl.Status then
						self:CreateTrinketStatus(skilltbl.Status)
					end
				end
			end
		end
	end

	self:ApplyAssocModifiers(real_assoc)

	local funcs
	local gm_functions = GAMEMODE.SkillFunctions
	for skillid in pairs(allskills) do

		funcs = gm_functions[skillid]
		if funcs then
			if not real_assoc[skillid] then -- On but we want it off.
				for _, func in pairs(funcs) do
					func(self, false)
				end
			elseif real_assoc[skillid] then -- Off but we want it on.
				for _, func in pairs(funcs) do
					func(self, true)
				end
			end
		end
	end
end

function meta:CanSkillsRemort()
	return self:GetZSLevel() >= GAMEMODE.MaxLevel
end
meta.CanSkillRemort = meta.CanSkillsRemort

function meta:SetSkillActive(skillid, active, nosend)
	local skills = table.ToAssoc(self:GetActiveSkills())
	skills[active] = active
	self:SetActiveSkills(skills, nosend)
end

function meta:GetZSLevel()
	return math.floor(GAMEMODE:LevelForXP(self:GetZSXP()))
end

function meta:GetZSRemortLevel()
	return self:GetDTInt(DT_PLAYER_INT_REMORTLEVEL)
end

function meta:GetZSRemortLevelGraded()
	return math.floor(self:GetZSRemortLevel() / 4)
end

function meta:GetZSXP()
	return self:GetDTInt(DT_PLAYER_INT_XP)
end

function meta:GetZSSPUsed()
	return #self:GetUnlockedSkills()
end

function meta:GetZSSPRemaining()
	return self:GetZSSPTotal() - self:GetZSSPUsed()
end

function meta:GetZSSPTotal()
	return self:GetZSLevel() + self:GetZSRemortLevel()
end

function meta:GetDesiredActiveSkills()
	return self.DesiredActiveSkills or {}
end

function meta:GetActiveSkills()
	return self.ActiveSkills or {}
end

function meta:GetUnlockedSkills()
	return self.UnlockedSkills or {}
end

function meta:GetTotalAdditiveModifier(...)
	local totalmod = 1
	for i, modifier in ipairs({...}) do
		totalmod = totalmod + (self[modifier] or 1) - 1
	end
	return totalmod
end
