INC_CLIENT()

local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/glow04_noz")
local vector_origin = vector_origin

function ENT:Draw()
	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 2 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 25)
		particle:SetDieTime(0.1)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(20)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(155, 100, 255)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	if self:GetVelocity() ~= vector_origin then
		render.SetMaterial(matGlow)
		render.DrawSprite(pos, 55, 55, Color(100, 100, 255, 100))
		render.SetMaterial(matGlow2)
		render.DrawSprite(pos, 65, 65, Color(155, 100, 255, 100))
		render.DrawSprite(pos, 45, 45, Color(255, 255, 255, 255))
	end
end

function ENT:OnRemove()
	local pos = self:GetPos()

	sound.Play("weapons/physcannon/energy_bounce1.wav", pos, 75, math.random(75, 80))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 19 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 25)
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(3, 4))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(150, 125, 255)
	end
	for i=0,5 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(35, 40))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(225, 205, 255)
	end
	for i=1, 45 do
		particle = emitter:Add("effects/splash2", pos)
		particle:SetDieTime(0.6)
		particle:SetColor(100, 65, 255)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(5)
		particle:SetEndSize(0)
		particle:SetStartLength(1)
		particle:SetEndLength(5)
		particle:SetVelocity(VectorRand():GetNormal() * 50)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
