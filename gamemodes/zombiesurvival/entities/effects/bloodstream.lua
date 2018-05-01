util.PrecacheSound("physics/flesh/flesh_bloody_impact_hard1.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard1.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard2.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard3.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard4.wav")

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if particle:GetDieTime() == 0 then return end
	particle:SetDieTime(0)

	if math.random(3) == 3 then
		sound.Play("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.Rand(95, 105))
		util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
	end
end

local function CollideCallback(oldparticle, hitpos, hitnormal)
	if oldparticle:GetDieTime() == 0 then return end
	oldparticle:SetDieTime(0)

	local pos = hitpos + hitnormal

	if math.random(3) == 3 then
		sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav", hitpos, 50, math.Rand(95, 105))
	end
	util.Decal("Blood", pos, hitpos - hitnormal)

	local num = math.random(-4, 4)
	if num < 1 then return end

	local nhitnormal = hitnormal * 90

	local emitter = ParticleEmitter(pos)
	for i=1, num do
		local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
		particle:SetLighting(true)
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(75, 150) + nhitnormal)
		particle:SetDieTime(3)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.Rand(1.5, 2.5))
		particle:SetEndSize(1.5)
		particle:SetRoll(math.Rand(-25, 25))
		particle:SetRollDelta(math.Rand(-25, 25))
		particle:SetAirResistance(5)
		particle:SetGravity(Vector(0, 0, -600))
		particle:SetCollide(true)
		particle:SetColor(255, 0, 0)
		particle:SetCollideCallback(CollideCallbackSmall)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Init(data)
	local pos = data:GetOrigin() + Vector(0, 0, 10)

	local dir = data:GetNormal()
	local force = data:GetScale()

	local emitter = ParticleEmitter(pos)
	for i=1, data:GetMagnitude() do
		local heading = (VectorRand():GetNormalized() * 3 + dir) / 4
		local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos + heading)
		particle:SetVelocity(force * math.Rand(0.8, 1) * heading)
		particle:SetDieTime(math.Rand(3, 6))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(200)
		particle:SetStartSize(math.Rand(3, 5))
		particle:SetEndSize(3)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-20, 20))
		particle:SetAirResistance(5)
		particle:SetGravity(Vector(0, 0, -600))
		particle:SetCollide(true)
		particle:SetLighting(true)
		particle:SetColor(255, 0, 0)
		particle:SetCollideCallback(CollideCallback)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
