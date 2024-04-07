INC_CLIENT()

ENT.NextEmit = 0
ENT.DoEmit = false

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "items/medcharge4.wav")
end

function ENT:Think()
	if self.DoEmit then
		self.DoEmit = false

		self:EmitSound("ambient/machines/thumper_dust.wav", 70, 120)
	end

	self.AmbientSound:PlayEx(0.70, 80 + CurTime() % 1)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Draw()
	local time = CurTime()
	local pos = self:GetPos()
	--pos.z = pos.z + 32

	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		dlight.Pos = pos
		dlight.r = 30
		dlight.g = 255
		dlight.b = 30
		dlight.Brightness = 8
		dlight.Size = self.Radius / 2
		dlight.Decay = self.Radius * 2
		dlight.DieTime = time + 0.75
	end

	if time < self.NextEmit then return end
	self.NextEmit = time + 1
	self.DoEmit = true

	local offset, particle
	local axis = AngleRand()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(12, 16)

	for i=1, 180 do
		axis.roll = axis.roll + 2
		offset = axis:Up()

		particle = emitter:Add("sprites/glow04_noz", pos + offset)
		particle:SetVelocity(offset * math.Rand(500, 600))
		particle:SetColor(30, 225, 30)
		particle:SetAirResistance(300)
		particle:SetDieTime(math.Rand(1.25, 2.5))
		particle:SetStartAlpha(245)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1)
		particle:SetEndSize(math.Rand(12, 15))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-10, 10))
		--particle:SetCollide(true)
	end

	for i=1, 20 do
		particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetVelocity(VectorRand() * 8)
		particle:SetColor(60, 255, 60)
		particle:SetDieTime(2)
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(255)
		particle:SetStartSize(24)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
