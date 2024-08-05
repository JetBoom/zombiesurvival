function EFFECT:Init(data)
	local pos = data:GetOrigin()
	pos = pos + Vector(0, 0, 48)
	
	sound.Play("ambient/wind/wind_hit1.wav", pos, 77, math.Rand(90, 110))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(40, 45)
		for i=1, math.random(5, 8) do
			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(28, 32))
			particle:SetDieTime(math.Rand(2.2, 3.6))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(8)
			particle:SetEndSize(100)
			particle:SetColor(60, 60, 20)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetAirResistance(10)
		end
		for i=1, math.random(17, 21) do
			local particle = emitter:Add("effects/fire_cloud1", pos + VectorRand() * 32)
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(28, 32))
			local dir = VectorRand():GetNormalized()
			particle:SetDieTime(math.Rand(1.0, 1.25))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(60)
			particle:SetEndSize(30)
			particle:SetColor(0, 0, 2)
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
			particle:SetColor(0, 0, 2)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-30, 30))
		end

	local emitter = ParticleEmitter(pos)

	for i=1, math.random(12,20) do
		local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), pos)
		local dir = VectorRand():GetNormalized()
		particle:SetVelocity(dir * math.Rand(100, 150))
		particle:SetDieTime(math.Rand(1.5, 2.5))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(13, 14))
		particle:SetEndSize(math.Rand(10, 12))
		particle:SetRoll(180)
		particle:SetDieTime(3)
		particle:SetColor(160, 160, 40)
		particle:SetLighting(true)
	end

	local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), pos)
	local dir = VectorRand():GetNormalized()
	particle:SetVelocity(dir * math.Rand(100, 200))
	particle:SetStartAlpha(200)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(28, 32))
	particle:SetEndSize(math.Rand(14, 28))
	particle:SetRoll(180)
	particle:SetColor(160, 160, 40)
	particle:SetLighting(true)

	emitter:Finish()
end


function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
