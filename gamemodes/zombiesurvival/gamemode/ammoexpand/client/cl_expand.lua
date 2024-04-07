local M_Player = FindMetaTable("Player")

local E_GetTable = FindMetaTable("Entity").GetTable

local old_Player_SetAmmo = M_Player.SetAmmo
local old_Player_GetAmmoCount = M_Player.GetAmmoCount
local old_Player_RemoveAmmo = M_Player.RemoveAmmo

local CUSTOM_AMMO_COUNT = {}

local function GetIDFromNameOrID(id_or_name)
	local ca = CUSTOM_AMMO[id_or_name]
	if ca then
		return ca.index
	end
end

function M_Player:GetAmmoCount(id_or_name)
	if LocalPlayer() ~= self then return 0 end

	local id = GetIDFromNameOrID(id_or_name)
	if id then
		return CUSTOM_AMMO_COUNT[id] or 0
	end

	return old_Player_GetAmmoCount(self, id_or_name)
end

function M_Player:SetAmmo(amount, id_or_name)
	if LocalPlayer() ~= self then return end

	local id = GetIDFromNameOrID(id_or_name)
	if id then
		CUSTOM_AMMO_COUNT[id] = amount
	else
		old_Player_SetAmmo(self, amount, id_or_name)
	end
end

function M_Player:RemoveAmmo(amount, id_or_name)
	if LocalPlayer() ~= self then return end

	local id = GetIDFromNameOrID(id_or_name)
	if id then
		CUSTOM_AMMO_COUNT[id] = math.max((CUSTOM_AMMO_COUNT[id] or 0) - amount, 0)
	else
		old_Player_RemoveAmmo(self, amount, id_or_name)
	end
end

net.Receive("cusammo", function(length)
	local index = net.ReadUInt(6) + 128
	local amount = net.ReadUInt(10)

	CUSTOM_AMMO_COUNT[index] = amount
end)

net.Receive("cusammo_removeall", function(length)
	CUSTOM_AMMO_COUNT = {}
end)
