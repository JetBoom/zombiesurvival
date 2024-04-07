AddCSLuaFile()

-- thanks for fixing this bug that's been there for months, garry!

-- Change this to an entity to check for to determine if our entities didn't get loaded.
local ENTITYCLASS = "prop_nail"

hook.Add("Initialize", "workshop", function()

if scripted_ents.GetStored(ENTITYCLASS) ~= nil then return end

print("Workshop version...")

local gmfoldername = GAMEMODE.FolderName

local entitiespath = gmfoldername.."/entities/entities/"
local effectspath = gmfoldername.."/entities/effects/"
local weaponspath = gmfoldername.."/entities/weapons/"

-- ENTITIES
local files, folders = file.Find(entitiespath.."*", "LUA")

for _, filename in pairs(files) do
	ENT = {}
	ENT.Folder = entitiespath
	ENT.FolderName = filename

	include(entitiespath..filename)

	scripted_ents.Register(ENT, string.StripExtension(filename))
end

for _, foldername in pairs(folders) do
	ENT = {}
	ENT.Folder = entitiespath..foldername
	ENT.FolderName = foldername

	if SERVER then
		if file.Exists(entitiespath..foldername.."/init.lua", "LUA") then
			include(entitiespath..foldername.."/init.lua")
		elseif file.Exists(entitiespath..foldername.."/shared.lua", "LUA") then
			include(entitiespath..foldername.."/shared.lua")
		end
	end

	if CLIENT then
		if file.Exists(entitiespath..foldername.."/cl_init.lua", "LUA") then
			include(entitiespath..foldername.."/cl_init.lua")
		elseif file.Exists(entitiespath..foldername.."/shared.lua", "LUA") then
			include(entitiespath..foldername.."/shared.lua")
		end
	end

	scripted_ents.Register(ENT, foldername)
end

-- EFFECTS
files, folders = file.Find(effectspath.."*", "LUA")

for _, filename in pairs(files) do
	if SERVER then
		AddCSLuaFile(effectspath..filename)
	end
	if CLIENT then
		EFFECT = {}
		EFFECT.Folder = effectspath
		EFFECT.FolderName = filename

		include(effectspath..filename)

		effects.Register(EFFECT, string.StripExtension(filename))
	end
end

for _, foldername in pairs(folders) do
	if SERVER and file.Exists(effectspath..foldername.."/init.lua", "LUA") then
		AddCSLuaFile(effectspath..foldername.."/init.lua")
	end

	if CLIENT and file.Exists(effectspath..foldername.."/init.lua", "LUA") then
		EFFECT = {}
		EFFECT.Folder = effectspath..foldername
		EFFECT.FolderName = foldername

		include(effectspath..foldername.."/init.lua")

		effects.Register(EFFECT, foldername)
	end
end

-- WEAPONS
files, folders = file.Find(weaponspath.."*", "LUA")

for _, filename in pairs(files) do
	SWEP = {}
	SWEP.Folder = weaponspath
	SWEP.FolderName = filename
	SWEP.Base = "weapon_base"

	SWEP.Primary = {}
	SWEP.Secondary = {}
	--[[SWEP.Primary.ClipSize		= 8
	SWEP.Primary.DefaultClip	= 32
	SWEP.Primary.Automatic		= false
	SWEP.Primary.Ammo			= "Pistol"
	SWEP.Secondary.ClipSize		= 8
	SWEP.Secondary.DefaultClip	= 32
	SWEP.Secondary.Automatic	= false
	SWEP.Secondary.Ammo			= "Pistol"]]

	include(weaponspath..filename)

	weapons.Register(SWEP, string.StripExtension(filename))
end

for _, foldername in pairs(folders) do
	SWEP = {}
	SWEP.Folder = weaponspath..foldername
	SWEP.FolderName = foldername
	SWEP.Base = "weapon_base"

	SWEP.Primary = {}
	SWEP.Secondary = {}

	if SERVER then
		if file.Exists(weaponspath..foldername.."/init.lua", "LUA") then
			include(weaponspath..foldername.."/init.lua")
		elseif file.Exists(weaponspath..foldername.."/shared.lua", "LUA") then
			include(weaponspath..foldername.."/shared.lua")
		end
	end

	if CLIENT then
		if file.Exists(weaponspath..foldername.."/cl_init.lua", "LUA") then
			include(weaponspath..foldername.."/cl_init.lua")
		elseif file.Exists(weaponspath..foldername.."/shared.lua", "LUA") then
			include(weaponspath..foldername.."/shared.lua")
		end
	end

	weapons.Register(SWEP, foldername)
end

ENT = nil
EFFECT = nil
SWEP = nil

end)