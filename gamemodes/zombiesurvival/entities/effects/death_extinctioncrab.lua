function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local normal = data:GetNormal() * -1

	pos = pos + normal

	sound.Play("physics/body/body_medium_break"..math.random(2, 4)..".wav", pos, 77, math.Rand(90, 110))
	for i=0, math.random(2, 3) do
		timer.Simple(i * math.Rand(0.1, 0.3), function() sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav", pos, 77, math.Rand(90, 110)) end)
	end

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	local particle, size, heading

	for i=1, 12 do
		particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(normal * 48 + VectorRand() * 32)
		particle:SetDieTime(math.Rand(3.5, 4.5))
		particle:SetStartAlpha(60)
		particle:SetEndAlpha(0)
		particle:SetStartSize(200)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-2.5, 2.5))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetColor(160, 5, 0)
	end

	local grav = Vector(0, 0, 170)
	for i=1, 24 do
		particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
		particle:SetVelocity(normal * -48 + VectorRand() * 64)
		particle:SetGravity(-grav)
		particle:SetDieTime(math.Rand(2, 2.5))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(13, 14))
		particle:SetEndSize(math.Rand(10, 12))
		particle:SetRoll(180)
		particle:SetDieTime(3)
		particle:SetColor(50, 50, 50)
		particle:SetLighting(true)
	end

	for i=1, 80 do
		heading = VectorRand()
		heading:Normalize()

		size = math.Rand(10, 15)

		particle = emitter:Add("particle/rain", pos + heading * math.Rand(2, 64))
		particle:SetVelocity(heading * math.Rand(200, 550))
		particle:SetGravity(Vector(0, 0, -250))
		particle:SetDieTime(math.Rand(1, 1.5))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(size)
		particle:SetEndSize(size)
		particle:SetStartLength(size * 2)
		particle:SetEndLength(size * 4.5)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetColor(255, 120, 0)
		particle:SetAirResistance(math.Rand(20, 30))
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)

	util.Blood(pos, math.random(22, 26), Vector(0,0,1), 300)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
