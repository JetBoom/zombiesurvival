function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local mag = data:GetMagnitude()
	local ent = data:GetEntity()
	local scale = math.Round(data:GetScale())

	if ent:IsPlayer() then
		ent:Dismember(DISMEMBER_HEAD)
	end

	sound.Play("physics/flesh/flesh_bloody_break.wav", pos, 77, math.Rand(50, 100))
	sound.Play("physics/body/body_medium_break"..math.random(2, 4)..".wav", pos, 77, math.Rand(90, 110))

	local emitter = ParticleEmitter(pos)
	for i=1, 12 do
		local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), pos)
		particle:SetVelocity(norm * 32 + VectorRand() * 16)
		particle:SetDieTime(math.Rand(1.5, 2.5))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(13, 14))
		particle:SetEndSize(math.Rand(10, 12))
		particle:SetRoll(180)
		particle:SetDieTime(3)
		particle:SetColor(255, 0, 0)
		particle:SetLighting(true)
	end
	local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), pos)
	particle:SetVelocity(norm * 32)
	particle:SetDieTime(math.Rand(2.25, 3))
	particle:SetStartAlpha(200)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(28, 32))
	particle:SetEndSize(math.Rand(14, 28))
	particle:SetRoll(180)
	particle:SetColor(255, 0, 0)
	particle:SetLighting(true)
	emitter:Finish()

	util.Blood(pos, math.random(8, 10), Vector(0, 0, 1), 128)

	local maxbound = Vector(3, 3, 3)
	local minbound = maxbound * -1
	for i=1, math.random(5, 8) do
		local dir = (norm * 2 + VectorRand()) / 3
		dir:Normalize()

		local ent = ClientsideModel("models/props_junk/Rock001a.mdl", RENDERGROUP_OPAQUE)
		if ent:IsValid() then
			ent:SetMaterial("models/flesh")
			ent:SetModelScale(math.Rand(0.2, 0.5), 0)
			ent:SetPos(pos + dir * 6)
			ent:PhysicsInitBox(minbound, maxbound)
			ent:SetCollisionBounds(minbound, maxbound)

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMaterial("zombieflesh")
				phys:ApplyForceOffset(ent:GetPos() + VectorRand() * 5, dir * math.Rand(300, 800))
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
