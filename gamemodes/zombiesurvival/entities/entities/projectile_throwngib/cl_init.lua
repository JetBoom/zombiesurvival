INC_CLIENT()

ENT.NextEmit = 0

function ENT:Draw()
	local time = CurTime()

	self:DrawModel()

	if time < self.NextEmit then return end
	self.NextEmit = time + 0.05

	local pos = self:WorldSpaceCenter()
	local dir = VectorRand()
	dir:Normalize()
	dir = dir * math.Rand(1, 4)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(36, 44)

	local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos + dir)
	particle:SetVelocity(dir)
	particle:SetDieTime(math.Rand(0.6, 0.9))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	particle:SetStartSize(math.Rand(2, 5))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-4, 4))
	particle:SetColor(255, 0, 0)
	particle:SetLighting(true)

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
