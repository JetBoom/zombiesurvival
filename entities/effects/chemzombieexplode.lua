function EFFECT:Init(data)
	local pos = data:GetOrigin()
	pos = pos + Vector(0, 0, 48)

	sound.Play("ambient/explosions/explode_9.wav", pos, 90, math.Rand(85, 95))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(40, 45)
		for i=1, math.random(12, 15) do
			local heading = VectorRand():GetNormalized()
			local particle = emitter:Add("particle/smokestack", pos + heading * 16)
			particle:SetVelocity(heading * 72)
			particle:SetDieTime(math.Rand(1.7, 2.0))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(32)
			particle:SetEndSize(4)
			particle:SetColor(20, 100, 20)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
		end
		for i=1, math.random(5, 8) do
			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(48, 82))
			particle:SetDieTime(math.Rand(2.2, 3.6))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(8)
			particle:SetEndSize(100)
			particle:SetColor(0, 30, 0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetAirResistance(10)
		end
		for i=1, math.random(17, 21) do
			local particle = emitter:Add("effects/fire_cloud1", pos + VectorRand() * 32)
			local dir = VectorRand():GetNormalized()
			particle:SetVelocity(dir * math.Rand(500, 600))
			particle:SetDieTime(math.Rand(1.0, 1.25))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(60)
			particle:SetEndSize(30)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetAirResistance(60)
			particle:SetGravity(dir * math.Rand(-600, -500))
		end
		for i=1, 2 do
			local particle = emitter:Add("effects/fire_cloud1", pos)
			particle:SetDieTime(math.Rand(0.3, 0.35))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(16)
			particle:SetEndSize(300)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-30, 30))
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
