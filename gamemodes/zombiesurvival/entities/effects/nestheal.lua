function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

util.PrecacheSound("sound/physics/body/body_medium_break2.wav")
util.PrecacheSound("sound/physics/body/body_medium_break3.wav")
util.PrecacheSound("sound/physics/body/body_medium_break4.wav")

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local normal = data:GetNormal()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(28, 32)
	for i=1, 5 do
		local particle = emitter:Add(Material("sprites/light_glow02_add.vmt"), pos)
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(8, 24))
		particle:SetDieTime(math.Rand(1.5, 2.5))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(200)
		particle:SetStartSize(math.Rand(8, 16))
		particle:SetEndSize(0)
		particle:SetColor(255, 0, 0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetCollide(true)
		particle:SetGravity(Vector(0, 0, 0))
		particle:SetLighting(true)
		-- if math.random(3) == 3 then
			-- sound.Play("physics/body/body_medium_break" .. tostring(math.random(2, 4)) .. ".wav", pos, 100, math.Rand(95, 105), 1)
		-- end
	end
	emitter:Finish()

end