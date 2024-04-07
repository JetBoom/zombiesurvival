ENT.Base = "projectile_impactmine"

function ENT:GetStartPos()
	return self:GetPos() + self:GetUp() * 5
end
