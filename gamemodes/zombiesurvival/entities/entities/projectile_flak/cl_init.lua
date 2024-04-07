INC_CLIENT()

local matTrail = Material("trails/laser")
local colTrail = Color(255, 205, 120)
local matGlow2 = Material("sprites/glow04_noz")
local matWhite = Material("models/debug/debugwhite")
local vector_origin = vector_origin

function ENT:Draw()
	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(0.7, 0.5, 0.2)
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride(nil)

	if self:GetVelocity() ~= vector_origin then
		render.SetMaterial(matGlow2)
		render.DrawSprite(self:GetPos(), 10, 10, Color(255, 205, 100, 18))
	end

	render.SetMaterial(matTrail)
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i+1] then
			colTrail.a = 255 - 255 * (i/#self.TrailPositions)

			render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 5, 1, 0, colTrail)
		end
	end
end

function ENT:Initialize()
	self.Trailing = CurTime() + 0.1
	self.TrailPositions = {}
end

function ENT:Think()
	table.insert(self.TrailPositions, 1, self:GetPos())
	if self.TrailPositions[1] then
		table.remove(self.TrailPositions, 7)
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
