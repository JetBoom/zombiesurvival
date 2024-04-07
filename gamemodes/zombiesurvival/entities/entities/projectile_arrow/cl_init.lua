INC_CLIENT()

local matTrail = Material("trails/physbeam")
local colTrail = Color(255, 20, 20)
local matGlow = Material("sprites/light_glow02_add")
local matWhite = Material("models/debug/debugwhite")
local vector_origin = vector_origin

function ENT:Draw()
	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(0.6, 0.2, 0.2)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride(nil)

	if self:GetVelocity():LengthSqr() > 100 then
		self:SetAngles(self:GetVelocity():Angle())

		render.SetMaterial(matGlow)
		render.DrawSprite(self:GetPos(), 15, 2, Color(250, 40, 40))
		render.DrawSprite(self:GetPos(), 2, 30, Color(250, 40, 40))
	end

	render.SetMaterial(matTrail)
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i+1] then
			colTrail.a = 255 - 255 * (i/#self.TrailPositions)

			render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 7, 1, 0, colTrail)
		end
	end
end

function ENT:Initialize()
	self.Trailing = CurTime() + 0.15
	self.TrailPositions = {}
	self.CreateTime = CurTime()
end

function ENT:Think()
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
