INC_CLIENT()

ENT.NextEmit = 0
ENT.DoEmit = false

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "ambient/fire/fire_med_loop1.wav")
end

function ENT:Think()
	if self.DoEmit then
		self.DoEmit = false

		self:EmitSound("ambient/machines/thumper_dust.wav", 70, 170)
	end

	self.AmbientSound:PlayEx(0.80, 60 + CurTime() % 1)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Draw()
	local time = CurTime()
	local pos = self:GetPos()

	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 190
		dlight.b = 30
		dlight.Brightness = 8
		dlight.Size = self.Radius / 2
		dlight.Decay = self.Radius * 2
		dlight.DieTime = time + 0.75
	end

	if time < self.NextEmit then return end
	self.NextEmit = time + 0.65
	self.DoEmit = true

	local particle
	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(12, 16)

	for i=1, 75 do
		local angler = AngleRand()
		local dist = math.Rand(0, self.Radius)
		particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), pos + Vector(math.cos(angler.y) * dist, math.sin(angler.y) * dist, 0))
		particle:SetColor(255, 220, 140)
		particle:SetDieTime(math.Rand(1.35, 1.7))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(math.Rand(18, 24))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetCollide(true)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
