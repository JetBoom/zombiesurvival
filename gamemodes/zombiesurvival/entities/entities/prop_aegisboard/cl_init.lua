include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

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

function ENT:Draw()
	if MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN then
		local percentage = math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1)
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 270)
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Forward(), 270)
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

		ang:RotateAroundAxis(ang:Right(), 180)

		cam.Start3D2D(vPos - vOffset, ang, 0.05)
		self:DrawHealthBar(percentage)
		if name then
			draw.SimpleText(name, "ZS3D2DFont", 0, 0, COLOR_WHITE, TEXT_ALIGN_CENTER)
		end
		cam.End3D2D()
	else
		self:DrawModel()
	end
end
