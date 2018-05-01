function EFFECT:Init(data)
	local pos = data:GetOrigin()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(12, 24)

	for i=1, 2 do
		local particle = emitter:Add("particles/smokey", pos + VectorRand():GetNormalized() * math.Rand(0.1, 6))
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(1, 16))
		particle:SetDieTime(math.Rand(1, 2.5))
		particle:SetStartAlpha(math.random(100, 140))
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(4, 12))
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-2.5, 2.5))
		particle:SetRoll(math.random(0, 360))
		particle:SetColor(255, 220, 50)
		particle:SetLighting(true)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
