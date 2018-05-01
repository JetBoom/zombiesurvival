INC_CLIENT()

ENT.NextEmit = 0

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "ambient/levels/citadel/citadel_ambient_scream_loop1.wav")
	self.AmbientSound:PlayEx(1, 88)

	self:GetOwner().status_shadeambience = self
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Draw()
	if CurTime() < self.NextEmit then return end

	local delta = CurTime() - self:GetLastDamaged()
	if delta < 1 then
		local power = (1 - delta) * math.min(1, self:GetLastDamage() / 12)
		self.NextEmit = CurTime() + 0.02 + (1 - power) * 0.3

		local owner = self:GetOwner()
		if owner:IsValid() then
			local radius = owner:BoundingRadius() / 2

			local pos = owner:LocalToWorld(owner:OBBCenter()) + VectorRand():GetNormalized() * math.Rand(-radius, radius)

			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(24, 32)

			local particle = emitter:Add("sprites/glow04_noz", pos)
			particle:SetDieTime(math.Rand(0.2, 0.4))
			particle:SetStartSize(1)
			particle:SetEndSize(power * 16)
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-5, 5))
			particle:SetColor(255, 255, 190)

			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
	end
end
