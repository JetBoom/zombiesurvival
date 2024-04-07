INC_CLIENT()

function ENT:Initialize()
	self:SetMaterial("models/shadertest/shader2")
	self:SetColor(Color(0, 150, 255, 255))
	self:SetModelScale(0.3, 0)
end

function ENT:DrawTranslucent()
	render.SetBlend(0.95)
	self:DrawModel()
	render.SetBlend(1)
end