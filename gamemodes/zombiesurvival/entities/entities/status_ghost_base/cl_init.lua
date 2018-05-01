INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Think()
	self:RecalculateValidity()

	self:NextThink(CurTime())
	return true
end

local colValid = Color(50, 255, 50, 50)
local colInvalid = Color(255, 50, 50, 50)
function ENT:DrawTranslucent()
	local validp = self:GetValidPlacement()

	cam.Start3D(EyePos(), EyeAngles())
		render.SuppressEngineLighting(true)
		if validp then
			render.SetBlend(0.75)
			render.SetColorModulation(0, 1, 0)
		else
			render.SetBlend(0.5)
			render.SetColorModulation(1, 0, 0)
		end

		if self.GhostArrow then
			local angs = self:GetAngles()
			angs:RotateAroundAxis(self:GetRight(), self.GhostArrowUp and 270 or 0)

			cam.Start3D2D(self:WorldSpaceCenter(), angs, 0.2)
				surface.SetDrawColor(validp and colValid or colInvalid)
				surface.DrawRect( 0, -1, 128, 2 )
			cam.End3D2D()
		end

		self:DrawModel()

		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)
		render.SuppressEngineLighting(false)
	cam.End3D()
end

CreateClientConVar("_zs_ghostrotation", 0, false, true)
