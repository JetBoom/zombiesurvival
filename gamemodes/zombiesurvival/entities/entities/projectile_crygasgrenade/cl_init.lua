INC_CLIENT()

function ENT:Think()
	if not self:GetGasEmit() then return end

	self.AmbientSound:PlayEx(0.80, 200 + CurTime() % 1)
end

function ENT:Draw()
	render.SetColorModulation(0.25, 0.46, 0.51)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)

	if not self:GetGasEmit() then return end

	local time = CurTime()

	if time < self.NextEmit then return end
	self.NextEmit = time + 0.07

	local particle
	local pos = self:GetPos()
	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(12, 16)

	local vel = Vector(0, 0, 170)
	for i=1, 7 do
		local angler = AngleRand()
		local dist = math.Rand(0, self.Radius)
		particle = emitter:Add(math.random(2) == 1 and "particle/smokesprites_0003" or "particle/smokestack", pos)
		particle:SetColor(70, 120, 150)
		particle:SetVelocity(vel * math.Rand(0.5, 1) + Vector(math.cos(angler.y) * dist, math.sin(angler.y) * dist, 0)/1.21)
		particle:SetGravity(vel * -0.95)
		particle:SetDieTime(math.Rand(1.85, 2.4))
		particle:SetStartAlpha(math.random(150, 200))
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(math.Rand(11, 19))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetCollide(true)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
