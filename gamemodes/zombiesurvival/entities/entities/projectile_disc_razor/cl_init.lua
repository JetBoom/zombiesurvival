INC_CLIENT()

function ENT:Draw()
	render.SetColorModulation(0.65, 0.65, 0.65)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
end

function ENT:Initialize()
	self:SetModelScale(0.3, 0)
	self:DrawShadow(false)
end
