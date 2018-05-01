-- Weapons right now don't need this system. Only used for components.

CUSTOM_AMMO = {}

local CUSTOM_AMMO = CUSTOM_AMMO
local CUSTOM_AMMO_NUM = 128

local M_Weapon = FindMetaTable("Weapon")
local M_Player = FindMetaTable("Player")
local M_Entity = FindMetaTable("Entity")

local E_GetTable = M_Entity.GetTable

local old_game_AddAmmoType = game.AddAmmoType
local old_game_GetAmmoID = game.GetAmmoID
local old_game_GetAmmoMax = game.GetAmmoMax
local old_game_GetAmmoName = game.GetAmmoName

local old_Weapon_GetPrimaryAmmoType = M_Weapon.GetPrimaryAmmoType
local old_Weapon_GetSecondaryAmmoType = M_Weapon.GetSecondaryAmmoType

local old_Player_GetAmmoCount = M_Player.GetAmmoCount

local added = 0
function game.AddAmmoType(data)
	added = added + 1
	if added < 35 then
		--print('adding ' .. data.name .. ' via old')
		old_game_AddAmmoType(data)
	else
		--print('adding ' .. data.name .. ' via new')
		game.AddExpandedAmmoType(data)
	end
end

function game.AddExpandedAmmoType(data)
	CUSTOM_AMMO_NUM = CUSTOM_AMMO_NUM + 1

	data.index = CUSTOM_AMMO_NUM
	data.maxcarry = data.maxcarry or 9999
	CUSTOM_AMMO[CUSTOM_AMMO_NUM] = data
	CUSTOM_AMMO[data.name] = data
end

function game.GetAmmoID(name)
	return CUSTOM_AMMO[name] and CUSTOM_AMMO[name].index or old_game_GetAmmoID(name)
end

function game.GetAmmoMax(name)
	return CUSTOM_AMMO[name] and CUSTOM_AMMO[name].maxcarry or old_game_GetAmmoMax(name)
end

function game.GetAmmoName(id)
	return CUSTOM_AMMO[id] and CUSTOM_AMMO[id].name or old_game_GetAmmoName(id)
end

function M_Weapon:GetPrimaryAmmoType()
	local t = E_GetTable(self)
	if t.Primary and t.Primary.Ammo and CUSTOM_AMMO[t.Primary.Ammo] then return CUSTOM_AMMO[t.Primary.Ammo].index end

	return old_Weapon_GetPrimaryAmmoType(self)
end

function M_Weapon:GetSecondaryAmmoType()
	local t = E_GetTable(self)
	if t.Secondary and t.Secondary.Ammo and CUSTOM_AMMO[t.Secondary.Ammo] then return CUSTOM_AMMO[t.Secondary.Ammo].index end

	return old_Weapon_GetSecondaryAmmoType(self)
end

--[[function M_Weapon:HasAmmo()
	-- TODO
end

function M_Weapon:Clip1()
	-- TODO
end

function M_Weapon:Clip2()
	-- TODO
end]]
