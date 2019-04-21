function EFFECT:Init(effectdata)
	local pos = effectdata:GetOrigin()
	self.Pos = pos
	local normal = effectdata:GetNormal()

	self.Alpha = 255
	self.Life = 0

	sound.Play("ambient/office/zap1.wav", pos, 80, math.random(165, 180))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	for i=1, 15 do
		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetDieTime(0.5)
		particle:SetColor(50,125,255)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(2)
		particle:SetEndSize(4)
		particle:SetVelocity((normal + VectorRand()):GetNormal() * 700)
		particle:SetGravity(VectorRand() * 20 + Vector(0, 0, -100))
		particle:SetCollide(true)
		particle:SetBounce(0.75)
		particle:SetAirResistance(12)
	end
	for i=0,5 do
		particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(47, 49))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(55, 136, 245)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	self.Life = self.Life + FrameTime() * 4
	self.Alpha = 255 * (1 - self.Life)
	return self.Life < 1
end

local glowmat = Material("sprites/glow04_noz")
local matTrail = Material("trails/laser")
function EFFECT:Render()
	local pos = self.Pos

	render.SetMaterial(glowmat)
	render.DrawSprite(pos, 60, 60, Color(70, 140, 255, self.Alpha))

	render.SetMaterial(matTrail)
	for i=1, 8 do
		local dir = VectorRand():GetNormal()
		render.DrawBeam(pos, pos + dir * 30 * self.Alpha/255, 15, i, 3 + i, Color(70, 140, 250))
	end
end
