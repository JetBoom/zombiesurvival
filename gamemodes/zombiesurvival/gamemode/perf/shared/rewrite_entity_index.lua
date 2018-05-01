local M_Entity = FindMetaTable("Entity")

local E_GetTable = M_Entity.GetTable

local val
local et
function M_Entity:__index(key)
	val = M_Entity[key]
	if val ~= nil then return val end

	et = E_GetTable(self)
	if et then
		return et[key]
	end

	-- Obsolete
	--if key == "Owner" then return M_Entity.GetOwner( self ) end
end
