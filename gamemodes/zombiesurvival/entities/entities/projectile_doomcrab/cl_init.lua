INC_CLIENT()

ENT.NextEmit = 0

function ENT:Initialize()
	self:SetColor(Color(0, 230, 0, 255))
	self:SetMaterial("models/flesh")

	self.AmbientSound = CreateSound(self, "ambient/gas/steam_loop1.wav")
	self.Created = CurTime()
end

function ENT:Think()
	self.AmbientSound:PlayEx(0.75, 90 - math.min(2, CurTime() - self.Created) * 20)

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Draw()
	self:DrawModel()

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.1

	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	local particle = emitter:Add("particles/smokey", pos)
	particle:SetDieTime(math.Rand(0.8, 1))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(15, 20))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 255))
	particle:SetRollDelta(math.Rand(-10, 10))
	particle:SetVelocity((self:GetVelocity():GetNormalized() * -1 + VectorRand():GetNormalized()):GetNormalized() * math.Rand(16, 48))
	particle:SetLighting(true)
	particle:SetColor(30, 255, 30)

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
