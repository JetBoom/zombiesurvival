INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self:SharedInitialize()
end

function ENT:DrawTranslucent()
	local cycle = math.Clamp((CurTime() - self.Created) * 0.8, 0, 1) * self:GetDeathSequenceLength() + self:GetDeathSequenceStart()
	local sequence = self:GetDeathSequence()

	if cycle == 1 then
		local idleseq = self:LookupSequence("zombie_slump_idle_01")
		if idleseq and idleseq > 0 then
			sequence = idleseq
		end
	end

	self:SetSequence(sequence)
	self:SetCycle(cycle)
	self:SetAngles(self:GetDeathAngles())

	cam.Start3D(EyePos() + Vector(0, 0, 4), EyeAngles())
		render.SetBlend(math.Clamp(self:GetRemoveTime() - CurTime(), 0, 1))
		self:DrawModel()
		render.SetBlend(1)
	cam.End3D()
end
