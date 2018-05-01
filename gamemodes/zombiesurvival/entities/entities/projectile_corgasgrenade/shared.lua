ENT.Type = "anim"

ENT.Radius = 75

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer()
end

function ENT:SetGasEmit(emit)
	self:SetDTBool(0, emit)
end

function ENT:GetGasEmit()
	return self:GetDTBool(0)
end
