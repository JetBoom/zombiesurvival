INC_CLIENT()

local matTrail = Material("trails/physbeam")
local colTrail = Color(230, 35, 45)
local matGlow = Material("sprites/light_glow02_add")

local vector_origin = vector_origin

function ENT:Draw()
	render.SetBlend(0.4)
	self:DrawModel()
	render.SetBlend(1)

	render.SetMaterial(matTrail)
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i+1] then
			colTrail.a = 255 - 255 * (i/#self.TrailPositions)

			render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 5, 1, 0, colTrail)
		end
	end

	local pos = self:GetPos()

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 5, 5, Color(230, 55, 35))
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
		if self.TrailPositions[16] then
			table.remove(self.TrailPositions, 16)
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
