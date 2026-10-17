local M_Player = FindMetaTable("Player")
local M_Entity = FindMetaTable("Entity")
local E_GetTable = M_Entity.GetTable

function M_Player:__index(key)
	local val = M_Player[key]
	if val ~= nil then return val end

	val = M_Entity[key]
	if val ~= nil then return val end

	local pt = E_GetTable(self)
	if pt then
		return pt[key]
	end
end