include("shared.lua")

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))

	self.PixVis = util.GetPixelVisibleHandle()
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

local matLight = Material("sprites/light_ignorez")
function ENT:DrawTranslucent()
	self:DrawModel()

	local epos = self:GetSpotLightPos()
	local LightNrm = self:GetSpotLightAngles():Forward()
	local ViewNormal = epos - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	local ViewDot = ViewNormal:Dot( LightNrm * -1 )

	if ViewDot >= 0 then
		local LightPos = epos + LightNrm * 5

		render.SetMaterial(matLight)
		local Visibile	= util.PixelVisible( LightPos, 16, self.PixVis )	

		if not Visibile then return end

		local Size = math.Clamp(Distance * Visibile * ViewDot * 1.8, 40, 420)

		Distance = math.Clamp(Distance, 32, 800)
		local Alpha = math.Clamp((1000 - Distance) * Visibile * ViewDot, 0, 100)
		local Col = self:GetColor()
		Col.a = Alpha

		render.DrawSprite(LightPos, Size, Size, Col, Visibile * ViewDot)
		render.DrawSprite(LightPos, Size*0.4, Size*0.4, Color(255, 255, 255, Alpha), Visibile * ViewDot)
	end
end
