-- Partially based on the Railgun from AS:S, and the Gluon

EFFECT.LifeTime = 0.3

function EFFECT:GetDelta()
	return math.Clamp(self.DieTime - CurTime(), 0, self.LifeTime) / self.LifeTime
end

function EFFECT:Init(data)
	self.StartPos = self:GetTracerShootPos(data:GetStart(), data:GetEntity(), data:GetAttachment())
	self.EndPos = data:GetOrigin()
	self.HitNormal = data:GetNormal() * -1
	self.Color = Color(150,155,255)
	self.LifeTime = 0.15 + 0.013 * ((self.StartPos - self.EndPos):Length() ^ 0.5) -- Keep the particle relatively constant speed
	self.DieTime = CurTime() + self.LifeTime

	local emitter = ParticleEmitter(self.EndPos)
	emitter:SetNearClip(24, 32)

	local r, g, b = self.Color.r, self.Color.g, self.Color.b
	local randmin, randmax = -40, 40
	local normal = (self.EndPos - self.StartPos)
	normal:Normalize()
	for i = -100, self.EndPos:Distance(self.StartPos), 20 do
		local pos = self.StartPos + normal * i + VectorRand():GetNormalized() * math.Rand(randmin, randmax)
		local dietime = math.Rand(1, 2)
		local startsize = 1 + math.Rand(0.5, 1.5) * 2
		local rolldelta = math.Rand(-16, 16)
		local roll = math.Rand(0, 360)
		local vel = math.Rand(192, 256) * normal

		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetDieTime(dietime)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(startsize)
		particle:SetRoll(roll)
		particle:SetRollDelta(rolldelta)
		particle:SetVelocity(vel * 4)
		particle:SetGravity(vel * -7)
		particle:SetAirResistance(20)
		particle:SetColor(r, g, b)
	end

	self.QuadPos = self.EndPos + self.HitNormal

	for i=1, 20 do
		local particle = emitter:Add("effects/blueflare1", self.QuadPos)
		local vel = VectorRand():GetNormal() * 160
		particle:SetDieTime(1.5)
		particle:SetColor(130,200,230)
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(11)
		particle:SetEndSize(0)
		particle:SetVelocity(vel)
		particle:SetGravity(vel * -0.7)
	end

	emitter:Finish()
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matBeam2 = Material("trails/physbeam")
local matGlow = Material("effects/select_ring")
local matFlare = Material("sprites/glow04_noz")
function EFFECT:Render()
	local delta = self:GetDelta()
	if delta <= 0 then return end
	self.Color.a = delta * 155

	local startpos = self.StartPos
	local endpos = self.QuadPos

	local size = delta * 50
	render.SetMaterial(matBeam2)
	render.DrawBeam(startpos, endpos, size * 0.5, 1, 0, self.Color)
	render.DrawBeam(startpos, endpos, size, 1, 0, self.Color)

	local texcoord = math.Rand( 0, 1 )

	local distancevector = (startpos - endpos)
	local dir = distancevector:Angle()
	local dfwd = dir:Forward()
	local dup = dir:Up()
	local drgt = dir:Right()
	local nlen = distancevector:Length()
	local prevspinpos, prevspinpos2 = startpos, startpos

	for i = 0, nlen * (1 - delta), 32 do
		local set = i - CurTime() * 7
		local spinbeamsize = (1 - delta) * 15

		local basebeampos = startpos - dfwd * i
		local spinbeampos = basebeampos + dup * math.sin(set) * spinbeamsize + drgt * math.cos(set) * spinbeamsize
		local spinbeampos2 = basebeampos - dup * math.sin(set) * spinbeamsize - drgt * math.cos(set) * spinbeamsize

		render.DrawBeam(prevspinpos, spinbeampos, 4, texcoord + i, texcoord + 1 + i, Color(90, 90, 255, self.Color.a))
		render.DrawBeam(prevspinpos2, spinbeampos2, 4, texcoord + i, texcoord + 1 + i, Color(90, 90, 255, self.Color.a))

		prevspinpos = spinbeampos
		prevspinpos2 = spinbeampos2
	end

	local ringpos = startpos - (dfwd * (1 - delta) * nlen)
	render.SetMaterial(matGlow)
	render.DrawSprite(ringpos, 24, 24, self.Color)
	render.SetMaterial(matFlare)
	render.DrawSprite(ringpos, 150, 150, self.Color)
	render.DrawSprite(ringpos, 20, 170, self.Color)
	render.DrawSprite(ringpos, 220, 20, self.Color)
	render.DrawSprite(self.QuadPos, 255-self.Color.a, 255-self.Color.a, self.Color)
end
