function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal() * -1


	sound.Play("physics/concrete/concrete_break"..math.random(2,3)..".wav", pos, 75, math.Rand(130, 140))
	sound.Play("physics/glass/glass_largesheet_break"..math.random(1, 3)..".wav", pos, 75, math.Rand(160, 180))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 24)

	for i=1, math.random(12, 18) do
		local Size = math.Rand(3, 5)
		local RandDarkness = math.Rand(0.8, 1.0)
		local dir = (norm * 2 + VectorRand()) / 3
		dir:Normalize()

		particle = emitter:Add("particles/balloon_bit", pos + VectorRand() * 6)
		particle:SetVelocity(dir * math.Rand(150, 250))
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(3, 5))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(100)
		particle:SetStartSize(Size)
		particle:SetEndSize(Size * 0.25)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-2, 2))
		particle:SetGravity(Vector(0, 0, -400))
		particle:SetColor(145 * RandDarkness, 230 * RandDarkness, 255 * RandDarkness)
		particle:SetCollide(true)
		particle:SetAngleVelocity(Angle(math.Rand(-160, 160), math.Rand(-160, 160), math.Rand(-160, 160)))
		particle:SetBounce(0.45)
	end
	for i=1, 6 do
		particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(VectorRand():GetNormal() * 190)
		particle:SetDieTime(math.Rand(0.7, 0.85))
		particle:SetStartAlpha(math.Rand(50, 70))
		particle:SetStartSize(math.Rand(100,120))
		particle:SetEndSize(math.Rand(205, 210))
		particle:SetRoll(math.Rand(-360, 360))
		particle:SetRollDelta(math.Rand(-4.5, 4.5))
		particle:SetColor(255, 255, 255)
	end
	for i=1, 12 do
		particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(VectorRand():GetNormal() * 240)
		particle:SetDieTime(math.Rand(0.3, 0.6))
		particle:SetStartAlpha(math.Rand(90, 110))
		particle:SetStartSize(1)
		particle:SetEndSize(math.Rand(160, 190))
		particle:SetRoll(math.Rand(-360, 360))
		particle:SetRollDelta(math.Rand(-4.5, 4.5))
		particle:SetColor(40, 160, 255)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)

	local maxbound = Vector(3, 3, 3)
	local minbound = maxbound * -1
	for i=1, math.random(6,8) do
		local dir = (norm * 2 + VectorRand()) / 3
		dir:Normalize()

		local ent = ClientsideModel("models/props_junk/Rock001a.mdl", RENDERGROUP_OPAQUE)
		if ent:IsValid() then
			ent:SetModelScale(math.Rand(0.6, 0.9), 0)
			ent:SetMaterial("models/shadertest/shader2")
			ent:SetColor(Color(0, 150, 255, 255))
			ent:SetPos(pos + dir * 6)
			ent:PhysicsInitBox(minbound, maxbound)
			ent:SetCollisionBounds(minbound, maxbound)

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMaterial("rock")
				phys:ApplyForceCenter(dir * math.Rand(200, 300))
			end

			SafeRemoveEntityDelayed(ent, math.Rand(6, 10))
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
