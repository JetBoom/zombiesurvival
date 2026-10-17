INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Think()
	local owner = self:GetOwner()
	if not owner:IsValid() then
		self:Remove()
		return
	end

	-- Client-side predictive reconstruction is needed only for its OWN
	-- ghost. For other entities, the position has already arrived from the server, and
	-- client-side traces at the interpolated angles/position of the owner
	-- would only overwrite it and give false validity.
	if MySelf == owner then
		self:RecalculateValidity()
	end

	self:NextThink(CurTime() + 0.05)
	return true
end

local colValid   = Color(50, 255, 50, 50)
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
				surface.DrawRect(0, -1, 128, 2)
			cam.End3D2D()
		end

		self:DrawModel()

		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)
		render.SuppressEngineLighting(false)
	cam.End3D()
end

CreateClientConVar("_zs_ghostrotation", 0, false, true)