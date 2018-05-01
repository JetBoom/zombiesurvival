INC_CLIENT()

function ENT:Draw()
	render.SetColorModulation(0.2, 0.2, 0.2)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
end

function ENT:OnRemove()
	self:EmitSound("items/suitchargeok1.wav", 75, 80)

	local pos = self:GetPos()
	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(12, 16)

	for i = 1, 10 do
		local axis = AngleRand()
		for j=1, 40 do
			axis.roll = axis.roll + 8
			offset = axis:Up()

			particle = emitter:Add("sprites/glow04_noz", pos + offset)
			particle:SetVelocity(offset * math.Rand(300, 400))
			particle:SetGravity(Vector(0, 0, -300))
			particle:SetColor(255, 90, 90)
			particle:SetAirResistance(200)
			particle:SetDieTime(math.Rand(1.95, 2.5))
			particle:SetStartAlpha(205)
			particle:SetEndAlpha(0)
			particle:SetStartSize(1)
			particle:SetEndSize(math.Rand(6, 10))
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-10, 10))
			particle:SetCollide(true)
		end

		for j=1, 5 do
			particle = emitter:Add("sprites/glow04_noz", pos)
			particle:SetVelocity(VectorRand() * 8)
			particle:SetColor(255, 60, 60)
			particle:SetDieTime(2)
			particle:SetStartAlpha(0)
			particle:SetEndAlpha(255)
			particle:SetStartSize(24)
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
		end
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
