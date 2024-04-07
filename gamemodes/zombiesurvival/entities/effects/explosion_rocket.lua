function EFFECT:Init(data)
	local pos = data:GetOrigin() + Vector(0, 0, 2)

	self.Start = pos
	self.StartTime = CurTime()

	self.Alpha = 255
	self.Life = 0

	sound.Play("ambient/explosions/explode_"..math.random(1,5)..".wav", pos, 80, math.random(135, 160))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(32, 48)

	for i=1, 30 do
		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetDieTime(1)
		particle:SetColor(255,220,190)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(4)
		particle:SetEndSize(0)
		particle:SetVelocity(VectorRand():GetNormal() * 350)
		particle:SetGravity(Vector(0,0,-600))
		particle:SetCollide(true)
		particle:SetBounce(0.5)
	end

	for i=1, 12 do
		local particle = emitter:Add("effects/fire_cloud1", pos)
		particle:SetDieTime(0.5)
		particle:SetColor(235,210,160)
		particle:SetStartAlpha(178)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(45)
		particle:SetVelocity(VectorRand():GetNormal() * 150)
	end

	for i=1, 7 do
		local particle = emitter:Add("sprites/flamelet"..math.random(1, 4), pos)
		particle:SetVelocity(VectorRand():GetNormal() * 110)
		particle:SetDieTime(math.Rand(0.5, 0.6))
		particle:SetStartAlpha(220)
		particle:SetEndAlpha(0)
		particle:SetStartSize(48)
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetColor(255, 230, 150)
		particle:SetRollDelta(math.Rand(-3, 3))
	end

	for i=1, 20 do
		local particle = emitter:Add("effects/fire_embers"..math.random(1, 3), pos)
		particle:SetVelocity(VectorRand():GetNormal() * 250)
		particle:SetDieTime(math.Rand(1.25, 1.5))
		particle:SetStartAlpha(130)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(15, 19))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 359))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetAirResistance(50)
		particle:SetCollide(true)
		particle:SetBounce(0.3)
		particle:SetGravity(Vector(0,0,-400))
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	self.Life = self.Life + FrameTime() * 4
	self.Alpha = 255 * (1 - self.Life)
	return self.Life < 1
end

local glowmat = Material("sprites/glow04_noz")

function EFFECT:Render()
	render.SetMaterial(glowmat)
	render.DrawSprite(self.Start, 400, 400, Color(255, 210, 170, self.Alpha))
end
