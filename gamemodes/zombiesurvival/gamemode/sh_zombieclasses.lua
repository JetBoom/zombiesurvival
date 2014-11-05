GM.RevertableZombieClasses = {}

function GM:IsClassUnlocked(classname)
	local classtab = self.ZombieClasses[classname]
	if not classtab then return false end

	if classtab.IsClassUnlocked then
		local ret = classtab:IsClassUnlocked()
		if ret ~= nil then return ret end
	end

	return not classtab.Locked and (classtab.Unlocked or classtab.Wave and self:GetWave() >= classtab.Wave or not self:GetWaveActive() and self:GetWave() + 1 >= classtab.Wave)
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

	if tab.Wave then tab.Wave = math.floor(tab.Wave * self:GetNumberOfWaves()) end
	table.insert(gm.ZombieClasses, tab)
	tab.Index = #gm.ZombieClasses
	if CLIENT then
		tab.Icon = tab.Icon or "zombiesurvival/killicons/genericundead"
	end

	if tab.IsDefault then
		gm.DefaultZombieClass = tab.Index
	end

	tab.TranslationName = tab.TranslationName or tab.Name

	gm.ZombieClasses[name] = tab
end

function GM:RevertZombieClasses()
	self.ZombieClasses = table.Copy(self.RevertableZombieClasses)
end

function GM:RegisterZombieClasses()
	self.ZombieClasses = {}
	self.DefaultZombieClass = self.DefaultZombieClass or 1

	local included = {}

	local classes = file.Find(self.FolderName.."/gamemode/zombieclasses/*.lua", "LUA")
	table.sort(classes)
	for i, filename in ipairs(classes) do
		AddCSLuaFile("zombieclasses/"..filename)
		CLASS = {}
		include("zombieclasses/"..filename)
		if CLASS.Name then
			self:RegisterZombieClass(CLASS.Name, CLASS)
		else
			ErrorNoHalt("CLASS "..filename.." has no 'Name' member!")
		end
		included[filename] = CLASS
		CLASS = nil
	end

	for k, v in pairs(self.ZombieClasses) do
		local base = v.Base
		if base then
			base = base..".lua"
			if included[base] then
				table.Inherit(v, included[base])
			else
				ErrorNoHalt("CLASS "..tostring(v.Name).." uses base class "..base.." but it doesn't exist!")
			end
		end

		if v.Unlocked or v.Wave == 0 then
			v.UnlockedNotify = true
		end
	end

	self:ReorderZombieClasses()

	self.RevertableZombieClasses = table.Copy(self.ZombieClasses)
end

GM:RegisterZombieClasses()
