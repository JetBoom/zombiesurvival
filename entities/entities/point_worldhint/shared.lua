ENT.Type = "anim"

AccessorFuncDT(ENT, "Viewable", "Int", 0)
AccessorFuncDT(ENT, "Hint", "String", 0)
AccessorFuncDT(ENT, "Range", "Float", 0)
AccessorFuncDT(ENT, "Translated", "Bool", 0)

function ENT:GetHint()
	local hint = self:GetDTString(0)

	if self:GetTranslated() then return translate.Get(hint) end

	return hint
end
