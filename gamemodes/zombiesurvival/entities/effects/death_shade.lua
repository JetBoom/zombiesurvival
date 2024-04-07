function EFFECT:Init(effectdata)
	local pos = effectdata:GetOrigin()
	self.Pos = pos
	local normal = effectdata:GetNormal()

	self.Alpha = 255
	self.Life = 0

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	for i=1, 30 do
		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetDieTime(1)
		particle:SetColor(50,80,255)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(4)
		particle:SetEndSize(7)
		particle:SetVelocity((normal + VectorRand()):GetNormal() * 300)
		particle:SetGravity(VectorRand() * 20 + Vector(0, 0, -300))
		particle:SetCollide(true)
		particle:SetBounce(0.75)
		particle:SetAirResistance(12)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	sound.Play("weapons/physcannon/energy_disintegrate4.wav", pos, 80, math.Rand(50, 65))
end

function EFFECT:Think()
	self.Life = self.Life + FrameTime() * 2
	self.Alpha = 255 * (1 - self.Life)
	return (self.Life < 1)
end

local glowmat = Material("sprites/glow04_noz")

function EFFECT:Render()
	render.SetMaterial(glowmat)
	render.DrawSprite(self.Pos, 300, 300, Color(110, 150, 255, self.Alpha))
end
