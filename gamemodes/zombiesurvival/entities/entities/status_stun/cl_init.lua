INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	render.SetColorModulation(1, 0, 0)
	render.SuppressEngineLighting(true)

	self:SetRenderOrigin(owner:GetPos() + Vector(0, 0, owner:OBBMaxs().z))
	self:SetRenderAngles(Angle(0, CurTime() * 500, 0))
	self:DrawModel()

	render.SuppressEngineLighting(false)
	render.SetColorModulation(1, 1, 1)
end
