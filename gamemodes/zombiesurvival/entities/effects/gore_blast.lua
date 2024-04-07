local function CollideCallback(oldparticle, hitpos, hitnormal)
	if oldparticle:GetDieTime() == 0 then return end
	oldparticle:SetDieTime(0)

	local pos = hitpos + hitnormal

	util.Decal("Blood", pos, hitpos - hitnormal)
end

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = Vector(0, 0, 1)

	local emitter = ParticleEmitter(pos)

	for i=1, 15 do
		local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
		particle:SetVelocity(norm * 275 + VectorRand() * 100)
		particle:SetGravity(Vector(0,0,-450))
		particle:SetDieTime(math.Rand(1.5, 2.5))
		particle:SetStartAlpha(220)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(15, 18))
		particle:SetEndSize(math.Rand(20, 24))
		particle:SetRoll(math.random(360))
		particle:SetRollDelta(math.random(-2, 2))
		particle:SetColor(255, 0, 0)
		particle:SetLighting(true)
	end

	for i=1, 64 do
		local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
		particle:SetVelocity(VectorRand():GetNormalized() * 600)
		particle:SetDieTime(math.Rand(0.18, 0.24))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(60)
		particle:SetStartSize(math.Rand(12, 18))
		particle:SetEndSize(math.Rand(8, 12))
		particle:SetRoll(math.random(360))
		particle:SetRollDelta(math.random(-8, 8))
		particle:SetStartLength(12)
		particle:SetEndLength(42)
		particle:SetColor(255, 0, 0)
		particle:SetCollide(true)
		particle:SetCollideCallback(CollideCallback)
	end

	for i=1, 3 do
		local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
		particle:SetVelocity(norm * 34)
		particle:SetDieTime(math.Rand(0.3, 0.35))
		particle:SetStartAlpha(math.random(220, 250))
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(24, 26))
		particle:SetEndSize(math.Rand(145, 148))
		particle:SetRoll(math.random(360))
		particle:SetRollDelta(math.random(-5, 5))
		particle:SetColor(255, 0, 0)
		particle:SetLighting(true)
	end

	local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
	particle:SetVelocity(norm * 34)
	particle:SetDieTime(math.Rand(1.5, 2))
	particle:SetStartAlpha(220)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(28, 32))
	particle:SetEndSize(math.Rand(56, 64))
	particle:SetRoll(math.random(360))
	particle:SetColor(255, 0, 0)
	particle:SetLighting(true)

	emitter:Finish() emitter = nil collectgarbage("step", 64)

	util.Blood(pos, math.random(16, 22), Vector(0,0,1), 300)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
