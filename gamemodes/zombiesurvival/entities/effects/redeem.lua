function EFFECT:Init(data)
	local pos = data:GetOrigin()

	sound.Play("ambient/energy/whiteflash.wav", pos)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	for x=1, math.random(150, 200) do
		local vecRan = VectorRand():GetNormalized()
		vecRan = vecRan * math.Rand(24, 64)
		vecRan.z = math.Rand(-32, -1)

		local particle = emitter:Add("sprites/light_glow02_add", pos + vecRan)
		particle:SetVelocity(Vector(0, 0, math.Rand(16, 64)))
		particle:SetDieTime(math.Rand(1.2, 2))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.Rand(7, 8))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-32, 32))
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

util.PrecacheSound("ambient/energy/whiteflash.wav")
