INC_CLIENT()

ENT.SmokeTimer = 0

function ENT:Think()
	local emitter = ParticleEmitter(self:GetPos())
	emitter:SetNearClip(24, 32)

	if self.SmokeTimer < CurTime() then
		self.SmokeTimer = CurTime() + 0.02

		local vOffset = self:GetPos()

		local particle = emitter:Add("sprites/flamelet"..math.random(1,4), vOffset)
		particle:SetDieTime(0.5)
		particle:SetStartSize(math.Rand(4, 7))
		particle:SetEndSize(2)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-5,5))

		particle = emitter:Add("particle/smokestack", vOffset)
		particle:SetDieTime(0.7)
		particle:SetStartAlpha(225)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1)
		particle:SetEndSize(math.Rand(16,18))
		particle:SetColor(30, 30, 30)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-2, 2))
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
