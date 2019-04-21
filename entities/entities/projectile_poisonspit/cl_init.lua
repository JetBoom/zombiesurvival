INC_CLIENT()

ENT.NextEmit = 0

function ENT:Initialize()
	self:SetColor(Color(0, 255, 0, 255))
end

function ENT:Draw()
	self:DrawModel()

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.025

	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	local particle = emitter:Add("particles/smokey", pos)
	particle:SetDieTime(math.Rand(0.4, 0.5))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(3, 5))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 255))
	particle:SetRollDelta(math.Rand(-10, 10))
	particle:SetVelocity((self:GetVelocity():GetNormalized() * -1 + VectorRand():GetNormalized()):GetNormalized() * math.Rand(16, 48))
	particle:SetLighting(true)
	particle:SetColor(30, 255, 30)

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
