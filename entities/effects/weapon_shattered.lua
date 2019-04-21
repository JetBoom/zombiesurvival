function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local ent = data:GetEntity()
	if ent:IsValid() then
		ent:EmitSound("physics/glass/glass_sheet_break3.wav")
	end

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(8, 16)

	local dir, size, brightness
	local gravity = Vector(0, 0, -400)

	for i=1, 30 do
		dir = VectorRand()
		dir:Normalize()
		size = math.Rand(1, 5)
		brightness = math.Rand(0.8, 1.0)

		local particle = emitter:Add("particles/balloon_bit", pos + dir)
		particle:SetVelocity(dir * math.Rand(48, 90))
		particle:SetDieTime(math.Rand(3, 5))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(100)
		particle:SetStartSize(size)
		particle:SetEndSize(size / 4)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-2, 2))
		particle:SetGravity(gravity)
		particle:SetColor(230 * brightness, 240 * brightness, 255 * brightness)
		particle:SetCollide(true)
		particle:SetAngleVelocity(Angle(math.Rand(-160, 160), math.Rand(-160, 160), math.Rand(-160, 160)))
		particle:SetBounce(0.9)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
