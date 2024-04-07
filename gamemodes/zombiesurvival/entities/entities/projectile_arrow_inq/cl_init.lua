INC_CLIENT()

local matTrail = Material("trails/laser")
local matGlow = Material("sprites/light_glow02_add")
local vector_origin = vector_origin

function ENT:Draw()
	self:DrawModel()
	local alt = self:GetDTBool(0)
	local col = Color(250, alt and 230 or 178, alt and 170 or 70)

	if self:GetVelocity():LengthSqr() > 100 then
		self:SetAngles(self:GetVelocity():Angle())

		render.SetMaterial(matGlow)
		render.DrawSprite(self:GetPos(), 10, 10, col)
	end

	render.SetMaterial(matTrail)
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i+1] then
			col.a = 255 - 255 * (i/#self.TrailPositions)

			render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 2, 1, 0, col)
		end
	end
end

function ENT:Initialize()
	self.Trailing = CurTime() + 0.15
	self.TrailPositions = {}
end

function ENT:Think()
	table.insert(self.TrailPositions, 1, self:GetPos())
	if self.TrailPositions[12] then
		table.remove(self.TrailPositions, 12)
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
