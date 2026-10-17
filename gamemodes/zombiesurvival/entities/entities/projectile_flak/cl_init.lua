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
	local filled = self.TrailFilled or 0
	for i = 1, filled - 1 do
		colTrail.a = 255 - 255 * (i / filled)
		render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 5, 1, 0, colTrail)
	end
end

function ENT:Initialize()
	self.Trailing = CurTime() + 0.1
	self.TrailPositions = {Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0)}
	self.TrailIdx = 1
	self.TrailFilled = 0
end

function ENT:Think()
	self.TrailPositions[self.TrailIdx] = self:GetPos()
	self.TrailIdx = self.TrailIdx % 6 + 1
	if self.TrailFilled < 6 then self.TrailFilled = self.TrailFilled + 1 end

	local mypos = self:GetPos()
	local dist = 0
	for i = 1, self.TrailFilled do
		local d = self.TrailPositions[i]:DistToSqr(mypos)
		if d > dist then
			self:SetRenderBoundsWS(self.TrailPositions[i], mypos, Vector(16, 16, 16))
			dist = d
		end
	end
end
