include("shared.lua")

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))

	self.PixVis = util.GetPixelVisibleHandle()
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

function ENT:DrawHealthBar(percentage)
	local y = -50
	local maxbarwidth = 560
	local barheight = 30
	local barwidth = maxbarwidth * percentage
	local startx = maxbarwidth * -0.5

	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect(startx, y, maxbarwidth, barheight)
	surface.SetDrawColor((1 - percentage) * 255, percentage * 255, 0, 220)
	surface.DrawRect(startx + 4, y + 4, barwidth - 8, barheight - 8)
	surface.DrawOutlinedRect(startx, y, maxbarwidth, barheight)
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
	
	if MySelf:IsValid() then --and MySelf:Team() == TEAM_HUMAN then
		local percentage = math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1)
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 270)
		ang:RotateAroundAxis(ang:Right(), 180)
		ang:RotateAroundAxis(ang:Forward(), 180)
		local vPos = self:GetPos()
		local vOffset = self:GetForward() * self:OBBMaxs().x
		local name
		local owner = self:GetObjectOwner()
		if owner:IsValid() and owner:IsPlayer() and owner:Team() == TEAM_HUMAN then
			name = owner:Name()
		end

		self:DrawModel()

		cam.Start3D2D(vPos + vOffset, ang, 0.05)
			self:DrawHealthBar(percentage)
			if name then
				draw.SimpleText(name, "ZS3D2DFont", 0, 0, COLOR_WHITE, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
	
end
