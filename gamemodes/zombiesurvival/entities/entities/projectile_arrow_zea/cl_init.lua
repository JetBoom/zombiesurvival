INC_CLIENT()

local matTrail = Material("trails/electric")
local colTrail = Color(70, 255, 255)
local matGlow = Material("sprites/light_glow02_add")

local vector_origin = vector_origin

function ENT:Draw()
	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(0.5, 0.7, 1)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride(nil)

	render.SetMaterial(matTrail)
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i+1] then
			colTrail.a = 255 - 255 * (i/#self.TrailPositions)

			render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 3, 1, 0, colTrail)
		end
	end

	local velo = self:GetVelocity()
	local heading = velo:GetNormal() * -1.3
	local pos = self:GetPos() + heading * -10
	for i=1, 8 do
		local dir = (VectorRand() + heading):GetNormal()
		render.DrawBeam(pos, pos + dir * 24, 8, i, 2 + i, Color(90, 120, 250))
	end

	if velo:LengthSqr() > 100 then
		self:SetAngles(self:GetVelocity():Angle())

		render.SetMaterial(matGlow)
		render.DrawSprite(pos, 95, 9, Color(60, 120, 250, 255))
		render.DrawSprite(pos, 9, 95, Color(60, 120, 250, 255))

		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)
		local particle
		for i=0, 1 do
			particle = emitter:Add(matGlow, pos)
			particle:SetVelocity(VectorRand() * 15)
			particle:SetDieTime(0.2)
			particle:SetStartAlpha(125)
			particle:SetEndAlpha(0)
			particle:SetStartSize(10)
			particle:SetEndSize(0)
			particle:SetRollDelta(math.Rand(-10, 10))
			particle:SetColor(45, 90, 255)
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end

function ENT:Initialize()
	self.Trailing = CurTime() + 0.25
	self.TrailPositions = {}
end

function ENT:Think()
	table.insert(self.TrailPositions, 1, self:GetPos())
	if self.TrailPositions[24] then
		table.remove(self.TrailPositions, 24)
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
