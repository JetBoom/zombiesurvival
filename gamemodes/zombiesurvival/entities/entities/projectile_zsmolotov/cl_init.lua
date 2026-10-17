INC_CLIENT()

ENT.SmokeTimer = 0

function ENT:Think()
	local alt = self:GetDTBool(0)

	if self.SmokeTimer >= CurTime() then return end
	self.SmokeTimer = CurTime() + (alt and 0.3 or 0.05)

	local pos = self:GetPos()
	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	local particle = emitter:Add("sprites/flamelet"..math.random(1,4), pos)
	particle:SetDieTime(0.5)
	particle:SetStartSize(math.Rand(4, 7))
	particle:SetEndSize(2)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-5,5))

	particle = emitter:Add("particle/smokestack", pos)
	particle:SetDieTime(0.7)
	particle:SetStartAlpha(225)
	particle:SetEndAlpha(0)
	particle:SetStartSize(1)
	particle:SetEndSize(math.Rand(16,18))
	particle:SetColor(30, 30, 30)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-2, 2))

	emitter:Finish()
end
