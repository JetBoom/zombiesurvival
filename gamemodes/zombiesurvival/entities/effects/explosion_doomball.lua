function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local normal = data:GetNormal() * -1

	pos = pos + normal

	sound.Play("ambient/fire/gascan_ignite1.wav", pos, 75, math.Rand(50, 55))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	for i=1, 6 do
		local particle = emitter:Add("particles/smokey", pos)
		particle:SetDieTime(math.Rand(2, 4.5))
		particle:SetStartAlpha(30)
		particle:SetEndAlpha(0)
		particle:SetStartSize(200)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-5.5, 5.5))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetColor(0, 0, 0)
	end

	for i=1, 80 do
		local heading = VectorRand()
		heading:Normalize()

		local size = math.Rand(15, 25)

		local particle = emitter:Add("particles/smokey", pos + heading * math.Rand(2, 64))
		particle:SetVelocity(heading * math.Rand(-128, 256))
		particle:SetDieTime(math.Rand(3, 5.5))
		particle:SetStartAlpha(60)
		particle:SetEndAlpha(0)
		particle:SetStartSize(size)
		particle:SetEndSize(size)
		particle:SetRollDelta(math.Rand(-1.5, 1.5))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetColor(0, 0, 0)
		particle:SetAirResistance(math.Rand(50, 200))
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	for i=1, 8 do
		util.Effect("doomball_skull", effectdata)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
