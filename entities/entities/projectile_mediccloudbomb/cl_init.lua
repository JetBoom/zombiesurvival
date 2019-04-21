INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local matGlow = Material("sprites/light_glow02_add")
function ENT:DrawTranslucent()
	self:DrawModel()

	render.SetMaterial(matGlow)
	render.DrawSprite(self:GetPos(), 64, 64, COLOR_GREEN)
end
