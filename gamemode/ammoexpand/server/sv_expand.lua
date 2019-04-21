util.AddNetworkString("cusammo")
util.AddNetworkString("cusammo_removeall")

local M_Player = FindMetaTable("Player")
local E_GetTable = FindMetaTable("Entity").GetTable

local old_Player_GiveAmmo = M_Player.GiveAmmo
local old_Player_GetAmmoCount = M_Player.GetAmmoCount
local old_Player_RemoveAmmo = M_Player.RemoveAmmo
local old_Player_SetAmmo = M_Player.SetAmmo
local old_Player_RemoveAllAmmo = M_Player.RemoveAllAmmo
local old_Player_StripAmmo = M_Player.StripAmmo

local function GetIDFromNameOrID(id_or_name)
	local ca = CUSTOM_AMMO[id_or_name]
	if ca then
		return ca.index
	end
end

function M_Player:GetAmmoCount(id_or_name)
	local id = GetIDFromNameOrID(id_or_name)
	if id then
		local ca = E_GetTable(self).ca
		if ca then
			return ca[id] or 0
		end

		return 0
	end

	return old_Player_GetAmmoCount(self, id_or_name)
end

function M_Player:GiveAmmo(amount, id_or_name, suppress_sound)
	local id = GetIDFromNameOrID(id_or_name)
	if id then
		local et = E_GetTable(self)
		if not et.ca then et.ca = {} end
		et.ca[id] = (self.ca[id] or 0) + amount

		self:UpdateCustomAmmoCount(id)

		-- Just for the pickup sound to play.
		if not suppress_sound then
			old_Player_GiveAmmo(self, 1, "dummy")
		end
	else
		old_Player_GiveAmmo(self, amount, id_or_name, suppress_sound)
	end
end

function M_Player:RemoveAmmo(amount, id_or_name)
	local id = GetIDFromNameOrID(id_or_name)
	if id then
		local et = E_GetTable(self)
		if not et.ca then et.ca = {} end
		et.ca[id] = math.max((self.ca[id] or 0) - amount, 0)

		self:UpdateCustomAmmoCount(id)
	else
		old_Player_RemoveAmmo(self, amount, id_or_name)
	end
end

function M_Player:SetAmmo(amount, id_or_name)
	local id = GetIDFromNameOrID(id_or_name)
	if id then
		local et = E_GetTable(self)
		if not et.ca then et.ca = {} end
		et.ca[id] = amount

		self:UpdateCustomAmmoCount(id)
	else
		old_Player_SetAmmo(self, amount, id_or_name)
	end
end

function M_Player:RemoveAllAmmo()
	self.ca = nil
	old_Player_RemoveAllAmmo(self)

	net.Start("cusammo_removeall")
	net.Send(self)
end

-- Not sure if there's a difference between RemoveAllAmmo and StripAmmo
function M_Player:StripAmmo()
	self.ca = nil
	old_Player_StripAmmo(self)

	net.Start("cusammo_removeall")
	net.Send(self)
end

function M_Player:UpdateCustomAmmoCount(index)
	net.Start("cusammo")
	net.WriteUInt(index - 128, 6)
	net.WriteUInt(self.ca and self.ca[index] or 0, 10)
	net.Send(self)
end
