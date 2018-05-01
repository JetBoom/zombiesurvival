INC_SERVER()

function SWEP:Deploy()
	self:GetOwner():CreateAmbience("ambience_wow")

	return true
end
