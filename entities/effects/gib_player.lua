util.PrecacheSound("physics/flesh/flesh_bloody_break.wav")

local function CollideCallback(oldparticle, hitpos, hitnormal)
	if oldparticle:GetDieTime() == 0 then return end
	oldparticle:SetDieTime(0)

	local pos = hitpos + hitnormal

	if math.random(3) == 3 then
		sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav", hitpos, 50, math.Rand(95, 105))
	end
	util.Decal("Blood", pos, hitpos - hitnormal)
end

local vecGravity = Vector(0, 0, -500)
function EFFECT:Init(data)
	local ent = data:GetEntity()
	if not ent:IsValid() then return end

	ent:EmitSound("physics/flesh/flesh_bloody_break.wav")

	local basepos = ent:GetPos()
	local vel = ent:GetVelocity()
	local dir = vel:GetNormalized()
	local up = ent:GetUp()
	local speed = math.Clamp(vel:Length() * 2, 512, 2048)

	local emitter = ParticleEmitter(ent:LocalToWorld(ent:OBBCenter()))
	emitter:SetNearClip(24, 32)

	for boneid = 1, ent:GetBoneCount() - 1 do
		local pos = ent:GetBonePositionMatrixed(boneid)
		if pos and pos ~= basepos then
			for i=1, math.random(1, 3) do
				local heading = (VectorRand():GetNormalized() + up + dir * 2) / 4
				local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos + heading)
				particle:SetVelocity(speed * math.Rand(0.5, 1) * heading)
				particle:SetDieTime(math.Rand(3, 6))
				particle:SetStartAlpha(200)
				particle:SetEndAlpha(200)
				particle:SetStartSize(math.Rand(3, 4))
				particle:SetEndSize(2)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-20, 20))
				particle:SetAirResistance(8)
				particle:SetGravity(vecGravity)
				particle:SetCollide(true)
				particle:SetLighting(true)
				particle:SetColor(255, 0, 0)
				particle:SetCollideCallback(CollideCallback)
			end

			for i=1, 4 do
				local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
				particle:SetVelocity(math.Rand(0.5, 4) * (VectorRand():GetNormalized() + dir))
				particle:SetDieTime(math.Rand(0.75, 2))
				particle:SetStartAlpha(230)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(4, 5))
				particle:SetEndSize(3)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetLighting(true)
				particle:SetColor(255, 0, 0)
			end
		end
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
