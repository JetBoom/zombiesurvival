INC_CLIENT()

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

local vOffset = Vector(-1, 0, 8)
local aOffset = Angle(180, 90, 90)

function ENT:RenderInfo(pos, ang, owner)
	local ammo = self:GetAmmo()

	cam.Start3D2D(pos, ang, 0.075)
		local name = ""
		if owner:IsValid() and owner:IsPlayer() then
			name = owner:ClippedName()
		end

		if ammo > 0 then
			draw.SimpleTextBlurry("["..ammo.." / "..self.MaxAmmo.."]", "ZS3D2DFontSmall", 0, 120, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleTextBlurry(translate.Get("empty"), "ZS3D2DFontSmall", 0, 120, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		self:Draw3DHealthBar(math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1), name)
	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN then return end

	local owner = self:GetObjectOwner()
	local ang = self:LocalToWorldAngles(aOffset)

	self:RenderInfo(self:LocalToWorld(vOffset), ang, owner)
end
