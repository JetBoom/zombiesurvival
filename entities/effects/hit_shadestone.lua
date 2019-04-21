function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal() * -1

	sound.Play("ambient/materials/rock4.wav", pos, 77, math.Rand(65, 85))
	sound.Play("physics/concrete/boulder_impact_hard" .. math.random(1,4) .. ".wav", pos, 77, math.Rand(85, 95))

	local maxbound = Vector(3, 3, 3)
	local minbound = maxbound * -1
	for i=1, 8 do
		local dir = (norm * 2 + VectorRand()) / 3
		dir:Normalize()

		local ent = ClientsideModel("models/props_junk/Rock001a.mdl", RENDERGROUP_OPAQUE)
		if ent:IsValid() then
			ent:SetModelScale(math.Rand(0.5, 0.9), 0)
			ent:SetPos(pos + dir * 6)
			ent:PhysicsInitBox(minbound, maxbound)
			ent:SetCollisionBounds(minbound, maxbound)

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMaterial("rock")
				phys:ApplyForceOffset(ent:GetPos() + VectorRand() * 5, dir * math.Rand(-600, 600))
			end

			SafeRemoveEntityDelayed(ent, math.Rand(4, 8))
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
