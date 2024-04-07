INC_SERVER()

function SWEP:Deploy()
	self:GetOwner():CreateAmbience("ambience_coolwisp")

	return true
end
