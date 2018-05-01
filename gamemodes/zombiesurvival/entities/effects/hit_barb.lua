function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local hitnormal = data:GetNormal() * -1

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 48)

	local grav = Vector(0, 0, -200)
	for i = 1, math.random(60, 85) do
		local particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(90, 130) + hitnormal * math.Rand(48, 198))
		particle:SetDieTime(math.Rand(1.2, 2))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(1, 2))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-15, 15))
		particle:SetColor(25, 25, 25)
		particle:SetLighting(true)
		particle:SetGravity(grav)
		particle:SetCollide(true)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	sound.Play("physics/metal/sawblade_stick"..math.random(3)..".wav", pos, 74, math.random(199, 210))
end
