INC_CLIENT()

ENT.NextEmit = 0

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end
	if owner:GetZombieClassTable().IgnoreTargetAssist then return end

	if owner.SpawnProtection then return end
	local pos = owner:WorldSpaceCenter()

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.25

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 24)

	local dir = (VectorRand() * 20 + Vector(0, 0, 40)):GetNormal()

	for i = 1, 10 do
		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetVelocity(dir * 120)
		particle:SetDieTime(math.Rand(1.1, 1.4))
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(6, 7))
		particle:SetEndSize(12)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-5, 5))
		particle:SetGravity(Vector(0, 0, 25))
		particle:SetCollide(true)
		particle:SetBounce(0.45)
		particle:SetAirResistance(300)
		particle:SetColor(30, 60, 30)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
