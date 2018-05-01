net.Receive("zs_skill_is_desired", function(length, pl)
	local skillid = net.ReadUInt(16)
	local desired = net.ReadBool()

	pl:SetSkillDesired(skillid, desired)
end)

net.Receive("zs_skills_desired", function(length, pl)
	local desired = {}

	for skillid in pairs(GAMEMODE.Skills) do
		if net.ReadBool() then
			table.insert(desired, skillid)
		end
	end
	pl:SetDesiredActiveSkills(desired)
end)

net.Receive("zs_skills_all_desired", function(length, pl)
	if net.ReadBool() then
		pl:SetDesiredActiveSkills(table.Copy(pl:GetUnlockedSkills()))
	else
		local desired = {}
		for _, id in pairs(pl:GetUnlockedSkills()) do
			if GAMEMODE.Skills[id] and GAMEMODE.Skills[id].AlwaysActive then
				desired[#desired + 1] = id
			end
		end

		pl:SetDesiredActiveSkills(desired)
	end
end)

net.Receive("zs_skill_set_desired", function(length, pl)
	local skillset = net.ReadTable()
	local assoc = table.ToAssoc(skillset)

	local desired = {}
	for _, id in pairs(pl:GetUnlockedSkills()) do
		if GAMEMODE.Skills[id] and (GAMEMODE.Skills[id].AlwaysActive or assoc[id]) then
			desired[#desired + 1] = id
		end
	end
	pl:SetDesiredActiveSkills(desired)
end)

net.Receive("zs_skill_is_unlocked", function(length, pl)
	local skillid = net.ReadUInt(16)
	local activate = net.ReadBool()
	local skill = GAMEMODE.Skills[skillid]

	if skill and not pl:IsSkillUnlocked(skillid) and pl:GetZSSPRemaining() >= 1 and pl:SkillCanUnlock(skillid) and not skill.Disabled then
		pl:SetSkillUnlocked(skillid, true)

		local msg = "You've unlocked a skill: "..skill.Name
		pl:CenterNotify(msg)
		pl:PrintMessage(HUD_PRINTTALK, msg)

		if activate then
			pl:SetSkillDesired(skillid, true)
		end
	end
end)

net.Receive("zs_skills_remort", function(length, pl)
	if pl:CanSkillsRemort() then
		pl:SkillsRemort()
	end
end)

net.Receive("zs_skills_reset", function(length, pl)
	if pl:GetZSLevel() < 10 then
		pl:SkillNotify("You must be level 10 to reset your skills.")
		return
	end

	local time = os.time()
	if pl.NextSkillReset and time < pl.NextSkillReset then
		pl:SkillNotify("You must wait before resetting your skills again.")
		return
	end

	pl:SkillsReset()

	net.Start("zs_skills_nextreset")
		net.WriteUInt(pl.NextSkillReset - time, 32)
	net.Send(pl)
end)

net.Receive("zs_skills_refunded", function(length, pl)
	if pl.SkillsRefunded then
		pl:SkillNotify("The skill tree has changed and your skills have been refunded.")
	end

	pl.SkillsRefunded = false
end)

function GM:WriteSkillBits(t)
	t = table.ToAssoc(t)

	for skillid in pairs(GAMEMODE.Skills) do
		if t[skillid] then
			net.WriteBool(true)
		else
			net.WriteBool(false)
		end
	end
end

local meta = FindMetaTable("Player")
if not meta then return end

function meta:SkillNotify(message, green)
	net.Start("zs_skills_notify")
	net.WriteString(message)
	net.WriteBool(not not green)
	net.Send(self)
end

function meta:SetSkillDesired(skillid, desired)
	local desiredskills = self:GetDesiredActiveSkills()

	if desired then
		if self:IsSkillUnlocked(skillid) then
			if not self:IsSkillDesired(skillid) then
				table.insert(desiredskills, skillid)
			end

			self:SendSkillDesired(skillid, true)
		end
	else
		table.RemoveByValue(desiredskills, skillid)

		self:SendSkillDesired(skillid, false)
	end

	self:SetDesiredActiveSkills(desiredskills)
end

function meta:SetSkillUnlocked(skillid, unlocked)
	local unlockedskills = self:GetUnlockedSkills()

	if self:IsSkillUnlocked(skillid) ~= unlocked then
		if unlocked then
			table.insert(unlockedskills, skillid)
		else
			table.RemoveByValue(unlockedskills, skillid)
		end

		self:SendSkillUnlocked(skillid, unlocked)
	end

	self:SetUnlockedSkills(unlockedskills)
end

-- Usually not called
function meta:SetZSLevel(level)
	self:SetZSXP(GAMEMODE:XPForLevel(level))
end

function meta:SetZSRemortLevel(level)
	self:SetDTInt(DT_PLAYER_INT_REMORTLEVEL, level)
end

function meta:SetZSXP(xp)
	self:SetDTInt(DT_PLAYER_INT_XP, math.Clamp(xp, 0, GAMEMODE.MaxXP))
end

function meta:AddZSXP(xp)
	-- TODO: Level change checking. Cache the "XP for next level" in the vault load and compare it here instead of checking every add.
	self:SetZSXP(self:GetZSXP() + xp)
end

-- Done on team switch to anything except human.
-- We don't bother with anything except functions because modifiers typically only modify stats that humans use in one life or are only used by humans.
function meta:RemoveSkills()
	local active = self:GetActiveSkills()
	local gm_functions = GAMEMODE.SkillFunctions

	for _, skillid in pairs(active) do
		local funcs = gm_functions[skillid]
		if funcs then
			for __, func in pairs(funcs) do
				func(self, false)
			end
		end
	end
end

function meta:SendSkillDesired(skillid, desired)
	net.Start("zs_skill_is_desired")
		net.WriteUInt(skillid, 16)
		net.WriteBool(desired)
	net.Send(self)
end

function meta:SendSkillUnlocked(skillid, unlocked)
	net.Start("zs_skill_is_unlocked")
		net.WriteUInt(skillid, 16)
		net.WriteBool(unlocked)
	net.Send(self)
end

function meta:SetDesiredActiveSkills(skills, nosend)
	self.DesiredActiveSkills = table.ToKeyValues(skills)

	if not nosend then
		net.Start("zs_skills_desired")
		GAMEMODE:WriteSkillBits(skills)
		net.Send(self)
	end
end

function meta:SetActiveSkills(skills, nosend)
	self.ActiveSkills = table.ToAssoc(skills) -- Active skills are hash tables for O(1) access.

	if not nosend then
		net.Start("zs_skills_active")
		GAMEMODE:WriteSkillBits(skills)
		net.Send(self)
	end
end

function meta:SetUnlockedSkills(skills, nosend)
	self.UnlockedSkills = table.ToKeyValues(skills)

	if not nosend then
		net.Start("zs_skills_unlocked")
		GAMEMODE:WriteSkillBits(skills)
		net.Send(self)
	end
end

function meta:SkillsRemort()
	local rl = self:GetZSRemortLevel() + 1
	local myname = self:Name()

	self:SetZSRemortLevel(rl)
	self:SetZSXP(0)
	self:SetUnlockedSkills({})
	self:SetDesiredActiveSkills({})
	self.NextSkillReset = nil

	self:CenterNotify(COLOR_CYAN, translate.ClientFormat(self, "you_have_remorted_now_rl_x", rl))
	self:CenterNotify(COLOR_YELLOW, translate.ClientFormat(self, "you_now_have_x_extra_sp", rl))
	for _, pl in pairs(player.GetAll()) do
		if pl ~= self then
			pl:CenterNotify(COLOR_CYAN, translate.ClientFormat(pl, "x_has_remorted_to_rl_y", myname, rl))
		end
	end

	self:EmitSound("weapons/physcannon/energy_disintegrate"..math.random(4, 5)..".wav", 90, 65)
	self:SendLua("util.WhiteOut(2)")
	util.ScreenShake(self:GetPos(), 50, 0.5, 1.5, 800)
end

function meta:SkillsReset()
	self:SetUnlockedSkills({})
	self:SetDesiredActiveSkills({})
	self.NextSkillReset = os.time() + 604800 -- 1 week

	self:CenterNotify(COLOR_CYAN, translate.ClientGet(self, "you_have_reset_all"))
end
