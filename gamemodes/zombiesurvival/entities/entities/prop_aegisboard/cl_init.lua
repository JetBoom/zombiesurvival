INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
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
		if owner:IsValidHuman() then
			name = owner:Name()
		end

		self:DrawModel()

		cam.Start3D2D(vPos + vOffset, ang, 0.05)
			self:Draw3DHealthBar(percentage, name)
		cam.End3D2D()

		ang:RotateAroundAxis(ang:Right(), 180)

		cam.Start3D2D(vPos - vOffset, ang, 0.05)
			self:Draw3DHealthBar(percentage, name)
		cam.End3D2D()
	else
		self:DrawModel()
	end
end
