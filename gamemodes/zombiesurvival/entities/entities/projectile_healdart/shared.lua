ENT.Type = "anim"

function ENT:ShouldNotCollide(ent)
	return ent:IsValidLivingHuman() and self:GetSeeked():IsValidLivingHuman() and self:GetSeeked() ~= ent
end

AccessorFuncDT(ENT, "HitTime", "Float", 0)
AccessorFuncDT(ENT, "Seeked", "Entity", 0)
