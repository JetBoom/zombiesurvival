INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.ParticleTimer = 0

function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 128))
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsValid() then self:SetPos(owner:EyePos()) end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner[self:GetClass()] == self then
		owner[self:GetClass()] = nil
	end
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

	if self.ParticleTimer < CurTime() then
		self.ParticleTimer = CurTime() + 0.1

		local emitter = ParticleEmitter(self:GetPos())
		emitter:SetNearClip(24, 32)

		local pos, aa, bb
		for i = 0, 11 do
			if ent == MySelf and not ent:ShouldDrawLocalPlayer() then
				aa, bb = ent:WorldSpaceAABB()
				pos = Vector(math.Rand(aa.x, bb.x), math.Rand(aa.y, bb.y), math.Rand(aa.z, bb.z))
			else
				pos = GetRandomBonePos(ent)
			end

			local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos + VectorRand():GetNormalized() * 5)
			particle:SetDieTime(math.Rand(0.75, 0.85))
			particle:SetStartSize(11)
			particle:SetEndSize(1)
			particle:SetColor(200,30,30)
			particle:SetStartAlpha(235)
			particle:SetEndAlpha(0)
			particle:SetVelocity(ent:GetVelocity())
			particle:SetRoll(math.random(0, 360))
			particle:SetRollDelta(math.random(5, -5))
			particle:SetGravity(Vector(0, 0, -200))
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
