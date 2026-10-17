local M_Weapon = FindMetaTable("Weapon")
local M_Entity = FindMetaTable("Entity")
local E_GetTable = M_Entity.GetTable
local E_GetOwner = M_Entity.GetOwner

function M_Weapon:__index(key)
	local val = M_Weapon[key]
	if val ~= nil then return val end

	val = M_Entity[key]
	if val ~= nil then return val end

	if key == "Owner" then return E_GetOwner(self) end

	local wt = E_GetTable(self)
	if wt then
		return wt[key]
	end
end