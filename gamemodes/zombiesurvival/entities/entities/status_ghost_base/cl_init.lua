include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Think()
	self:RecalculateValidity()

	self:NextThink(CurTime())
	return true
end

function ENT:DrawTranslucent()
	cam.Start3D(EyePos(), EyeAngles())
		render.SuppressEngineLighting(true)
		if self:GetValidPlacement() then
			render.SetBlend(0.75)
			render.SetColorModulation(0, 1, 0)
		else
			render.SetBlend(0.5)
			render.SetColorModulation(1, 0, 0)
		end

		self:DrawModel()

		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)
		render.SuppressEngineLighting(false)
	cam.End3D()
end

CreateClientConVar("_zs_ghostrotation", 0, false, true)
