include("shared.lua")

ENT.NextGas = 0
ENT.NextSound = 0

function ENT:Think()
	if GAMEMODE.ZombieEscape then return end

	if self.NextSound <= CurTime() then
		self.NextSound = CurTime() + math.Rand(4, 6)

		if 0 < GAMEMODE:GetWave() and MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN and MySelf:Alive() then
			local mypos = self:GetPos()
			local eyepos = MySelf:NearestPoint(mypos)
			if eyepos:Distance(mypos) <= self:GetRadius() + 72 and WorldVisible(eyepos, mypos) then
				MySelf:EmitSound("ambient/voices/cough"..math.random(4)..".wav")
			end
		end
	end
end

function ENT:Draw()
	if GAMEMODE.ZombieEscape or CurTime() < self.NextGas then return end
	self.NextGas = CurTime() + math.Rand(0.08, 0.2)

	local radius = self:GetRadius()

	local randdir = VectorRand()
	randdir.z = math.abs(randdir.z)
	randdir:Normalize()
	local emitpos = self:GetPos() + randdir * math.Rand(0, radius / 2)

	local emitter = ParticleEmitter(emitpos)
	emitter:SetNearClip(48, 64)

	local particle = emitter:Add("particles/smokey", emitpos)
	particle:SetVelocity(randdir * math.Rand(8, 256))
	particle:SetAirResistance(64)
	particle:SetDieTime(math.Rand(1.2, 2.5))
	particle:SetStartAlpha(math.Rand(70, 90))
	particle:SetEndAlpha(0)
	particle:SetStartSize(1)
	particle:SetEndSize(radius * math.Rand(0.25, 0.45))
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-1, 1))
	particle:SetColor(0, math.Rand(40, 70), 0)

	emitter:Finish()
end
