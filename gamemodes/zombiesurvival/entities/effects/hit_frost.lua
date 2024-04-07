function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

local function CollideCallback(particle, hitpos, hitnormal)
	if particle:GetDieTime() == 0 then return end
	particle:SetDieTime(0)

	if math.random(3) == 3 then
		sound.Play("physics/glass/glass_impact_bullet"..math.random(4)..".wav", hitpos, 50, math.Rand(135, 155))
	end

	if math.random(3) == 3 then
		util.Decal("Impact.Glass", hitpos + hitnormal, hitpos - hitnormal)
	end
end

function EFFECT:Init(data)
	local pos = data:GetOrigin()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(28, 32)
	local grav = Vector(0, 0, -200)
	for i=1, math.random(4, 7) do
		local particle = emitter:Add("particle/sparkles", pos)
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(16, 64))
		particle:SetDieTime(math.Rand(1.1, 1.5))
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(2, 3))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetCollide(true)
		particle:SetGravity(grav)
		particle:SetCollideCallback(CollideCallback)
		particle:SetColor(140, 175, 205)
		particle:SetLighting(false)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	sound.Play("physics/glass/glass_impact_bullet"..math.random(4)..".wav", pos, 80, math.Rand(165, 170))
end
