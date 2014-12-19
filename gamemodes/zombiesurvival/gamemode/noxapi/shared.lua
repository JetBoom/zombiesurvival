local meta = FindMetaTable("Player")
if not meta then return end

function meta:IsNoxSupporter()
	if NDB then
		local memberlevel = self:GetMemberLevel()
		return memberlevel == MEMBER_GOLD or memberlevel == MEMBER_DIAMOND
	end

	return self:GetDTBool(15)
end
