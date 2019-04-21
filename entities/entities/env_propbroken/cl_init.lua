INC_CLIENT()

ENT.NextEmit = 0

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(1.03, 0)

	self.ParticlePositions = {}

	self:RandomizePositions()
end

function ENT:RandomizePositions()
	for i=1, 5 do
		local mins, maxs = self:OBBMins(), self:OBBMaxs()
		mins = mins * 0.75
		maxs = maxs * 0.75
		self.ParticlePositions[i] = Vector(math.Rand(-mins.x, maxs.x), math.Rand(-mins.y, maxs.y), math.Rand(-mins.z, maxs.z))
	end
end

local matDamage = Material("Models/props_debris/concretefloor013a")
function ENT:Draw()
	local sat = 1 - math.abs(math.sin(CurTime() * 3)) * 0.6

	render.ModelMaterialOverride(matDamage)
	render.SetBlend(0.35)
	render.SetColorModulation(1, sat, sat)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
	render.ModelMaterialOverride(0)

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.02

	local emitter = ParticleEmitter(self:GetPos())
	emitter:SetNearClip(16, 24)
	for _, pos in pairs(self.ParticlePositions) do
		local particle = emitter:Add("effects/fire_cloud"..math.random(2), self:LocalToWorld(pos))
		particle:SetDieTime(math.Rand(0.3, 0.4))
		particle:SetGravity(Vector(math.random(-1, 1), math.random(-1, 1), math.random(3, 8)):GetNormal() * 300)
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(4)
		particle:SetEndSize(1)
		particle:SetStartLength(10)
		particle:SetEndLength(18)
		particle:SetColor(0, 255, 0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-20, 20))
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
