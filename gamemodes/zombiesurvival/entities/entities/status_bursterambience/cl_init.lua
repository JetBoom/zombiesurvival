INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.NextEmit = 0

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "npc/zombie_poison/pz_breathe_loop2.wav")
	self.AmbientSound:PlayEx(0.55, 85)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsValid() then
		self.AmbientSound:PlayEx(0.55, 85 + math.sin(RealTime()))
	end
end

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() or owner.SpawnProtection then return end

	local pos = owner:WorldSpaceCenter()
	pos.z = pos.z + 5

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.12

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 24)

	local particle = emitter:Add("particle/smokestack", pos + VectorRand() * 5)
	particle:SetDieTime(math.Rand(0.95, 1.35))
	particle:SetStartAlpha(190)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(17, 19))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-3, 3))
	particle:SetVelocity(Vector(0, 0, 45))
	particle:SetGravity(Vector(0, 0, -65))
	particle:SetCollide(true)
	particle:SetBounce(0.45)
	particle:SetAirResistance(12)
	particle:SetColor(100, 235, 100)
	particle:SetLighting(true)

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
