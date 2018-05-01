INC_CLIENT()

ENT.ParticleTimer = 0

function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 128))

	if self:GetOwner() ~= MySelf then return end
	self.AmbientSound = CreateSound(self, "player/heartbeat1.wav")
	self.AmbientSound:PlayEx(0.85, 150)
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner == MySelf then
		self.AmbientSound:Stop()
	end

	self.BaseClass.OnRemove(self)
end


local function GetRandomBonePos(pl)
	if pl ~= MySelf or pl:ShouldDrawLocalPlayer() then
		local bone = pl:GetBoneMatrix(math.random(0,25))
		if bone then
			return bone:GetTranslation()
		end
	end

	return pl:GetShootPos()
end

function ENT:DrawTranslucent()
	local ent = self:GetOwner()
	if not ent:IsValid() then return end
	if ent.SpawnProtection then return end

	local pos
	if ent == MySelf and not ent:ShouldDrawLocalPlayer() then
		local aa, bb = ent:WorldSpaceAABB()
		pos = Vector(math.Rand(aa.x, bb.x), math.Rand(aa.y, bb.y), math.Rand(aa.z, bb.z))
	else
		pos = GetRandomBonePos(ent)
	end

	local emitter = ParticleEmitter(self:GetPos())
	emitter:SetNearClip(24, 32)

	if self.ParticleTimer <= CurTime() then
		self.ParticleTimer = CurTime() + 0.065

		local scale = MySelf:GetModelScale()

		local particle = emitter:Add("sprites/glow04_noz", pos + VectorRand():GetNormalized() * 2)
		particle:SetDieTime(0.65)
		particle:SetStartSize(12 * scale)
		particle:SetEndSize(5 * scale)
		particle:SetColor(255, 40, 0)
		particle:SetStartAlpha(90)
		particle:SetEndAlpha(0)
		particle:SetGravity(Vector(0, 0, 256))
		particle:SetVelocity(ent:GetVelocity())
		particle:SetRoll(math.random(0, 360))
		particle:SetRollDelta(math.random(-5, 5))

	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
