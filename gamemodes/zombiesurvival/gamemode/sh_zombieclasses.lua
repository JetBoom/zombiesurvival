GM.RevertableZombieClasses = {}

function GM:IsClassUnlocked(classname)
	local classtab = self.ZombieClasses[classname]
	if not classtab then return false end

	if classtab.Boss then return true end

	if classtab.IsClassUnlocked then
		local ret = classtab:IsClassUnlocked()
		if ret ~= nil then return ret end
	end

	if classtab.Locked then return false end

	return classtab.Unlocked
	or classtab.Wave and self:GetWave() >= classtab.Wave
	or classtab.Wave and not self:GetWaveActive() and self:GetWave() + 1 >= classtab.Wave
	or classtab.Sanity and self:GetUseSigils() and self:NumSigilsCorrupted() / self.MaxSigils >= classtab.Sanity
	--or classtab.Sanity and self:GetUseSigils() and self:GetSigilsDestroyed() / self.MaxSigils >= classtab.Sanity
end

function GM:ClassUnlocksUpdate(pl)
	for k,v in ipairs(GAMEMODE.ZombieClasses) do
		net.Start("zs_classunlockstate")
			net.WriteInt(k, 8)
			net.WriteBool(v.Unlocked)
		if pl then
			net.Send(pl)
		else
			net.Broadcast()
		end
	end
end

local function ReorderZombieClassesSort(a, b)
	if (a.Order or b.Order) and a.Order ~= b.Order then
		return (a.Order or 255) < (b.Order or 255)
	end

	if (a.Wave or b.Wave) and a.Wave ~= b.Wave then
		return (a.Wave or 255) < (b.Wave or 255)
	end

	return a.Name < b.Name
end
function GM:ReorderZombieClasses()
	table.sort(self.ZombieClasses, ReorderZombieClassesSort)
	for k, v in pairs(self.ZombieClasses) do
		if type(k) == "number" then
			self.ZombieClasses[v.Name] = v
			v.Index = k

			if v.IsDefault then
				self.DefaultZombieClass = k
			end
		end
	end
end

function GM:RegisterZombieClass(name, tab)
	local gm = GAMEMODE or GM

	if tab.Wave then tab.Wave = math.floor(tab.Wave * self.NumberOfWaves) end
	table.insert(gm.ZombieClasses, tab)
	tab.Index = #gm.ZombieClasses
	if CLIENT then
		tab.Icon = tab.Icon or "zombiesurvival/killicons/genericundead"
	end

	if tab.IsDefault then
		gm.DefaultZombieClass = tab.Index
	end

	tab.TranslationName = tab.TranslationName or tab.Name
	tab.Points = tab.Points or 0

	gm.ZombieClasses[name] = tab
end

function GM:RevertZombieClasses()
	self.ZombieClasses = table.Copy(self.RevertableZombieClasses)
end

function GM:RegisterZombieClasses()
	self.ZombieClasses = {}
	self.DefaultZombieClass = self.DefaultZombieClass or 1

	local included = {}

	local classfiles, classdirectories = file.Find(self.FolderName.."/gamemode/zombieclasses/*", "LUA")
	table.sort(classfiles)
	table.sort(classdirectories)

	for i, filename in ipairs(classfiles) do
		if string.sub(filename, -4) == ".lua" then -- Just in case
			CLASS = {}

			AddCSLuaFile("zombieclasses/"..filename)
			include("zombieclasses/"..filename)

			if CLASS.Name then
				self:RegisterZombieClass(CLASS.Name, CLASS)
			else
				ErrorNoHalt("CLASS "..filename.." has no 'Name' member!")
			end

			included[filename] = CLASS
			CLASS = nil
		end
	end

	for i, foldername in ipairs(classdirectories) do
		local basefn = "zombieclasses/"..foldername.."/"

		CLASS = {}
		if CLIENT then
			include(basefn.."client.lua")
		end
		if SERVER then
			AddCSLuaFile(basefn.."client.lua")
			include(basefn.."server.lua")
		end

		if CLASS.Name then
			self:RegisterZombieClass(CLASS.Name, CLASS)
		else
			ErrorNoHalt("CLASS "..foldername.." has no 'Name' member!")
		end

		included[foldername..".lua"] = CLASS
		CLASS = nil
	end

	for k, v in pairs(self.ZombieClasses) do
		local base = v.Base
		if base then
			base = base..".lua"
			if included[base] then
				local old_BetterVersion = v.BetterVersion
				local old_Infliction = v.Infliction
				local old_Hidden = v.Hidden
				local old_Unlocked = v.Unlocked
				local old_Disabled = v.Disabled
				local old_Order = v.Order
				local old_IsDefault = v.IsDefault

				table.Inherit(v, included[base])

				-- Don't inherit these.
				v.BetterVersion = old_BetterVersion
				v.Infliction = old_Infliction
				v.Hidden = old_Hidden
				v.Unlocked = old_Unlocked
				v.Disabled = old_Disabled
				v.Order = old_Order
				v.IsDefault = old_IsDefault
			else
				ErrorNoHalt("CLASS "..tostring(v.Name).." uses base class "..base.." but it doesn't exist!")
			end
		end

		if v.Unlocked or v.Wave == 0 then
			v.UnlockedNotify = true
		end
	end

	for k, v in pairs(self.ZombieClasses) do
		if v.BetterVersion and self.ZombieClasses[v.BetterVersion] then
			self.ZombieClasses[v.BetterVersion].BetterVersionOf = v.Name
		end
	end

	self:ReorderZombieClasses()

	self.RevertableZombieClasses = table.Copy(self.ZombieClasses)
end

if not GAMEMODE or (GAMEMODE and not GAMEMODE.ZombieClasses) then
	GM:RegisterZombieClasses()
end
