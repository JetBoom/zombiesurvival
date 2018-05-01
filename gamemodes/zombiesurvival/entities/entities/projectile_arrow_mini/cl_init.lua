INC_CLIENT()

local matTrail = Material("trails/laser")
local colTrail = Color(255, 255, 0)
local matGlow = Material("sprites/light_glow02_add")

local vector_origin = vector_origin

function ENT:Draw()
	self:DrawModel()

	render.SetMaterial(matTrail)
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i+1] then
			colTrail.a = 255 - 255 * (i/#self.TrailPositions)

			render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 6, 1, 0, colTrail)
		end
	end

	render.SetMaterial(matGlow)
	local size = 5 + (CurTime() * 8.5 % 1) * 20
	render.DrawSprite(self:GetPos(), size, size, Color(250, 210, 70))
end

function ENT:Initialize()
	self.Trailing = CurTime() + 0.25
	self.TrailPositions = {}
end

function ENT:Think()
	if self:GetVelocity() == vector_origin and self.Trailing < CurTime() then
		function self:Draw() self.Entity:DrawModel() end
		function self:Think() end
	else
		table.insert(self.TrailPositions, 1, self:GetPos())
		if self.TrailPositions[18] then
			table.remove(self.TrailPositions, 18)
		end

		local dist = 0
		local mypos = self:GetPos()
		for i=1, #self.TrailPositions do
			if self.TrailPositions[i]:DistToSqr(mypos) > dist then
				self:SetRenderBoundsWS(self.TrailPositions[i], mypos, Vector(16, 16, 16))
				dist = self.TrailPositions[i]:DistToSqr(mypos)
			end
		end
	end
end
