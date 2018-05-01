INC_CLIENT()

ENT.NextEmit = 0

function ENT:Draw()
	self:DrawModel()

	if CurTime() >= self.NextEmit and self:GetVelocity():LengthSqr() >= 256 then
		self.NextEmit = CurTime() + 0.05

		local pos = self:WorldSpaceCenter()

		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(16, 24)

		local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(8, 16))
		particle:SetDieTime(0.6)
		particle:SetStartAlpha(230)
		particle:SetEndAlpha(230)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-25, 25))
		particle:SetColor(255, 0, 0)
		particle:SetLighting(true)

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
