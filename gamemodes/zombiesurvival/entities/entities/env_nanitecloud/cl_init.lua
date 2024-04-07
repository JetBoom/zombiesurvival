INC_CLIENT()

ENT.NextEmit = 0
ENT.DoEmit = false

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "items/suitchargeno1.wav")
end

function ENT:Think()
	if self.DoEmit then
		self.DoEmit = false

		self:EmitSound("npc/scanner/scanner_scan2.wav", 70, 50)
	end

	self.AmbientSound:PlayEx(0.70, 60 + CurTime() % 1)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Draw()
	local time = CurTime()
	local pos = self:GetPos()

	if time < self.NextEmit then return end
	self.NextEmit = time + 1
	self.DoEmit = true

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(12, 16)

	for i=1, 95 do
		local dir = VectorRand():GetNormalized()
		particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetVelocity(dir * 205)
		particle:SetGravity(dir * -210)
		particle:SetDieTime(0.7)
		particle:SetColor(225,150,255)
		particle:SetStartAlpha(80)
		particle:SetEndAlpha(0)
		particle:SetStartSize(5)
		particle:SetEndSize(15)
		particle:SetCollide(false)
		particle:SetBounce(0)
	end

	for i=1, 30 do
		local dir = VectorRand():GetNormalized()
		particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetDieTime(math.Rand(1.8, 2.5))
		particle:SetColor(145,155,255)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(15)
		particle:SetEndSize(0)
		particle:SetGravity(dir * -6)
		particle:SetVelocity(dir * 5)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
