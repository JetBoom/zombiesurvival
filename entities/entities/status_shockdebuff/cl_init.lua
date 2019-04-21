INC_CLIENT()

ENT.NextEmit = 0

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end
	if owner:GetZombieClassTable().IgnoreTargetAssist then return end

	if owner.SpawnProtection then return end

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.15

	local pos = owner:WorldSpaceCenter()
	pos.z = pos.z + 12

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 24)

	for i = 1, 3 do
		particle = emitter:Add("trails/electric", pos + VectorRand() * 8)
		particle:SetDieTime(0.1)
		particle:SetStartAlpha(230)
		particle:SetEndAlpha(0)
		particle:SetStartSize(2)
		particle:SetEndSize(0)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetAirResistance(300)
		particle:SetStartLength(12)
		particle:SetEndLength(12)
		particle:SetColor(150, 255, 150)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
