local Models = {
	Model("models/props_debris/concrete_chunk02a.mdl"),
	Model("models/props_debris/concrete_chunk03a.mdl"),
	Model("models/props_debris/concrete_chunk08a.mdl")
}

local colRubble = Color(20, 20, 140)
function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local maxs = Vector(16, 16, 72)
	local mins = maxs * -1
	mins.z = 0
	local center = origin + (maxs + mins) / 2

	sound.Play("ambient/materials/rock4.wav", center, 77, math.Rand(95, 105))
	sound.Play("physics/concrete/concrete_break2.wav", center, 77, math.Rand(110, 120))

	for i = 1, 20 do
		local pos = origin + Vector(math.Rand(mins.x, maxs.x), math.Rand(mins.y, maxs.y), math.Rand(mins.z, maxs.z))
		local dir = pos - center + VectorRand()
		dir:Normalize()

		local ent = ClientsideModel(Models[math.random(#Models)], RENDERGROUP_TRANSLUCENT)
		if ent:IsValid() then
			--ent:SetModelScale(math.Rand(0.2, 0.5), 0)
			ent:SetPos(pos)
			--[[ent:PhysicsInitBox(minbound, maxbound)
			ent:SetCollisionBounds(minbound, maxbound)]]
			ent:PhysicsInit(SOLID_VPHYSICS)

			ent:SetRenderFX(kRenderFxDistort)
			ent:SetColor(colRubble)

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMaterial("rock")
				phys:ApplyForceOffset(ent:GetPos() + VectorRand() * 5, dir * math.Rand(100, 800))
			end

			SafeRemoveEntityDelayed(ent, math.Rand(25, 30))
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
