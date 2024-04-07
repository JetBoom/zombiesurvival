function EFFECT:Init(effectdata)
	local pos = effectdata:GetOrigin()
	self.Pos = pos
	local normal = effectdata:GetNormal()

	self.Alpha = 255
	self.Life = 0

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	for i=1, 11 do
		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetDieTime(0.2)
		particle:SetColor(190,210,250)
		particle:SetStartAlpha(190)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1)
		particle:SetEndSize(2)
		particle:SetVelocity((normal + VectorRand()):GetNormal() * 200)
		particle:SetCollide(true)
		particle:SetBounce(0.75)
		particle:SetAirResistance(24)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	sound.Play("physics/metal/metal_sheet_impact_bullet"..math.random(2)..".wav", pos, 75, math.Rand(195, 215))
end

function EFFECT:Think()
	self.Life = self.Life + FrameTime() * 5
	self.Alpha = 255 * (1 - self.Life)
	return (self.Life < 1)
end

local glowmat = Material("sprites/glow04_noz")
function EFFECT:Render()
	local pos = self.Pos

	render.SetMaterial(glowmat)
	render.DrawSprite(pos, 20, 20, Color(180, 210, 255, self.Alpha))
end
