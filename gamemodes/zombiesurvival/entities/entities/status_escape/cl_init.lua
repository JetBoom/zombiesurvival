INC_CLIENT()

ENT.ParticleMaterial = "sprites/glow04_noz"

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()

	if owner:IsValid() and owner == MySelf then
		self.TeleportingSound:PlayEx(1, 100 / (owner.SigilTeleportTimeMul or 1))
	end

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	owner.SigilTeleport = self
end

function ENT:OnRemove()
	self.TeleportingSound:Stop()
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner ~= LocalPlayer() then return end

	local ownerpos = owner:GetPos()

	local aa, bb = owner:WorldSpaceAABB()
	local startpos = Vector(math.Rand(aa.x, bb.x), math.Rand(aa.y, bb.y), math.Rand(aa.z, bb.z))

	local emitter = ParticleEmitter(startpos)
	emitter:SetNearClip(24, 32)


	emitter:Finish() emitter = nil collectgarbage("step", 64)

	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:SetParticleColor(particle)
	particle:SetColor(38, 102, 255)
end

function ENT:Draw()
end
