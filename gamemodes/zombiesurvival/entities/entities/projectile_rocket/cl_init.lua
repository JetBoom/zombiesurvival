INC_CLIENT()

local matGlow = Material("sprites/light_glow02_add")

ENT.SmokeTimer = 0

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local alt = self:GetDTBool(0)

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, alt and 30 or 100, alt and 30 or 100, Color(255,210,170))
end

function ENT:Initialize()
	local alt = self:GetDTBool(0)

	self.AmbientSound = CreateSound(self, "Missile.Ignite")
	self.AmbientSound:PlayEx(alt and 0.3 or 1, alt and 245 or 65)
end

function ENT:Think()
	local pos = self:GetPos()
	local emitter = ParticleEmitter(pos)
	local alt = self:GetDTBool(0)
	emitter:SetNearClip(24, 32)

	if self.SmokeTimer < CurTime() then
		self.SmokeTimer = CurTime() + (alt and 0.3 or 0.05)

		local particle = emitter:Add("effects/fire_cloud1", pos)
		particle:SetVelocity(self:GetVelocity() * -0.4 + VectorRand() * 60)
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(12, 19))
		particle:SetEndSize(5)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(240, 180, 120)

		particle = emitter:Add("particles/smokey", pos + VectorRand() * 10)
		particle:SetDieTime(math.Rand(0.4, 0.6))
		particle:SetStartAlpha(math.Rand(110, 130))
		particle:SetEndAlpha(0)
		particle:SetStartSize(2)
		particle:SetEndSize(math.Rand(20, 34))
		particle:SetRoll(math.Rand(0, 359))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(240, 190, 120)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)

	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 190
		dlight.b = 130
		dlight.Brightness = 2
		dlight.Size = 150
		dlight.Decay = 300
		dlight.DieTime = CurTime() + 2
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()

	local pos = self:GetPos()
	local alt = self:GetDTBool(0)

	if not alt then return end

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 25 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 275)
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(7, 9))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(245, 155, 30)
	end
	for i=1, 16 do
		particle = emitter:Add("effects/fire_embers"..math.random(1, 3), pos)
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
	for i=0,5 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(127, 129))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(245, 175, 60)
	end
	for i=1, 75 do
		particle = emitter:Add("effects/splash2", pos)
		particle:SetDieTime(0.6)
		particle:SetColor(255, 130, 0)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(5)
		particle:SetEndSize(0)
		particle:SetStartLength(1)
		particle:SetEndLength(15)
		particle:SetVelocity(VectorRand():GetNormal() * 200)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
