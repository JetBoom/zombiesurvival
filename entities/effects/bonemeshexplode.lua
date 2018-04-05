function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

function EFFECT:Init(data)
	local pos = data:GetOrigin()

	sound.Play("physics/body/body_medium_break"..math.random(2, 4)..".wav", pos, 77, math.Rand(95, 105))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 48)

	local particle = emitter:Add("particles/smokey", pos)
	particle:SetDieTime(0.5)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetStartSize(1)
	particle:SetEndSize(32)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(40, 60) * (math.random(2) == 1 and -1 or 1))
	particle:SetColor(255, 30, 30)
	particle:SetLighting(true)

	for i = 1, math.random(100, 130) do
		local particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(128, 350))
		particle:SetAirResistance(100)
		particle:SetDieTime(math.Rand(0.9, 2))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(1, 3))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-30, 30))
		particle:SetColor(255, 30, 30)
		particle:SetLighting(true)
	end

	emitter:Finish()
end
