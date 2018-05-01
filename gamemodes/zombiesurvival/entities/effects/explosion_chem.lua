function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local magnitude = data:GetMagnitude()

	sound.Play("ambient/explosions/explode_" .. math.random(8, 9) .. ".wav", pos, 70 + magnitude * 20, math.Rand(175, 180) - magnitude * 55)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 24)

	local particle, heading

	for i=1, math.random(8, 11) do
		heading = VectorRand()
		heading:Normalize()

		particle = emitter:Add("particle/smokestack", pos + 16 * magnitude * heading)
		particle:SetVelocity(72 * magnitude * heading)
		particle:SetDieTime(math.Rand(1.3, 1.6))
		particle:SetStartAlpha(170)
		particle:SetEndAlpha(0)
		particle:SetStartSize(32 * magnitude)
		particle:SetEndSize(4 * magnitude)
		particle:SetColor(60, 140, 60)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
	end

	for i=1, math.random(3, 6) do
		particle = emitter:Add("particle/smokestack", pos)
		particle:SetVelocity(math.Rand(48, 82) * magnitude * VectorRand():GetNormalized())
		particle:SetDieTime(math.Rand(1.7, 1.8))
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		particle:SetStartSize(8 * magnitude)
		particle:SetEndSize(70 * magnitude)
		particle:SetColor(20, 50, 20)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetAirResistance(10)
	end

	for i=1, math.random(14, 18) do
		heading = VectorRand()
		heading:Normalize()

		particle = emitter:Add("effects/fire_cloud1", pos + heading * 16)
		particle:SetVelocity(math.Rand(100, 200) * magnitude * heading)
		particle:SetDieTime(math.Rand(0.45, 0.65))
		particle:SetStartAlpha(130)
		particle:SetEndAlpha(0)
		particle:SetStartSize(20 * magnitude)
		particle:SetEndSize(10 * magnitude)
		particle:SetColor(115, 255, 145)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetAirResistance(60)
		particle:SetGravity(math.Rand(-50, -100) * magnitude * heading)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
