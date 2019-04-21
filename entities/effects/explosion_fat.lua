function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()

	sound.Play("physics/body/body_medium_break"..math.random(2, 4)..".wav", pos, 77, math.Rand(90, 110))
	for i=0, math.random(2, 3) do
		timer.Simple(i * math.Rand(0.1, 0.3), function() sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav", pos, 77, math.Rand(90, 110)) end)
	end

	local emitter = ParticleEmitter(pos)

	for i=1, 12 do
		local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
		particle:SetVelocity(norm * 32 + VectorRand() * 16)
		particle:SetDieTime(math.Rand(1.5, 2.5))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(13, 14))
		particle:SetEndSize(math.Rand(10, 12))
		particle:SetRoll(180)
		particle:SetDieTime(3)
		particle:SetColor(255, 255, 0)
		particle:SetLighting(true)
	end

	local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
	particle:SetVelocity(norm * 32)
	particle:SetDieTime(math.Rand(2.25, 3))
	particle:SetStartAlpha(200)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(28, 32))
	particle:SetEndSize(math.Rand(14, 28))
	particle:SetRoll(180)
	particle:SetColor(255, 255, 0)
	particle:SetLighting(true)

	emitter:Finish() emitter = nil collectgarbage("step", 64)

	util.Blood(pos, math.random(16, 22), Vector(0,0,1), 300)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
