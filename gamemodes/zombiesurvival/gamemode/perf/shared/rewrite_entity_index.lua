local M_Entity = FindMetaTable("Entity")
local E_GetTable = M_Entity.GetTable

function M_Entity:__index(key)
	local val = M_Entity[key]
	if val ~= nil then return val end

	local et = E_GetTable(self)
	if et then
		return et[key]
	end
end