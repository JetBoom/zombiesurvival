EFFECT.LifeTime = 0.45

function EFFECT:Init(effectdata)
	local pos = effectdata:GetOrigin()
	local normal = effectdata:GetNormal()

	pos = pos + normal

	self.Pos = pos
	self.Normal = normal
	self.DieTime = CurTime() + self.LifeTime

	local particle

	sound.Play("weapons/physcannon/energy_disintegrate"..math.random(4, 5)..".wav", pos, 80, math.random(70, 90))
	sound.Play("weapons/physcannon/energy_sing_explosion2.wav", pos, 80, math.random(105, 120))

	local emitter = ParticleEmitter(pos)
	local emitter2 = ParticleEmitter(pos, true)
	emitter:SetNearClip(24, 32)
	emitter2:SetNearClip(24, 32)

	for i=1, 100 do
		particle = emitter:Add("effects/splash2", pos)
		particle:SetDieTime(0.4)
		particle:SetColor(75, 110, 255)
		particle:SetStartAlpha(185)
		particle:SetEndAlpha(0)
		particle:SetStartSize(6)
		particle:SetEndSize(6)
		particle:SetStartLength(0)
		particle:SetEndLength(90)
		particle:SetVelocity(VectorRand():GetNormal() * 220)
	end
	local ringstart = pos + normal * -3
	for i=1, 3 do
		particle = emitter2:Add("effects/select_ring", ringstart)
		particle:SetDieTime(0.1 + i * 0.1)
		particle:SetColor(75, 115, 255)
		particle:SetStartAlpha(185)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(110)
		particle:SetAngles(normal:Angle())
		particle = emitter2:Add("effects/select_ring", ringstart)
		particle:SetDieTime(0.2 + i * 0.1)
		particle:SetColor(75, 115, 255)
		particle:SetStartAlpha(185)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(120)
		particle:SetAngles(normal:Angle())
	end

	emitter:Finish()
	emitter2:Finish()
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matRefract = Material("refract_ring")
local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(75, 115, 255)
function EFFECT:Render()
	local delta = (self.DieTime - CurTime()) / self.LifeTime
	local basesize = 48
	basesize = basesize + basesize ^ (1.5 - delta)

	local pos = self.Pos
	matRefract:SetFloat("$refractamount", (10.75 + math.abs(math.sin(CurTime() * 5)) * math.pi * 0.25) * delta)
	render.SetMaterial(matRefract)
	render.UpdateRefractTexture()
	render.DrawSprite(pos, basesize, basesize)
	render.DrawQuadEasy(pos, self.Normal, basesize, basesize, colGlow, 0)
	render.DrawQuadEasy(pos, self.Normal, basesize, basesize, colGlow, 0)

	basesize = basesize * 0.75

	colGlow.a = delta * 255
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, basesize, basesize, colGlow)
	render.DrawQuadEasy(pos, self.Normal, basesize, basesize, colGlow, 0)
	render.DrawQuadEasy(pos, self.Normal, basesize, basesize, colGlow, 0)
end
