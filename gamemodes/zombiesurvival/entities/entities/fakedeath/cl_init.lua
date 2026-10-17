INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local BOUNDS_MINS = Vector(-128, -128, -128)
local BOUNDS_MAXS = Vector(128, 128, 128)

function ENT:Initialize()
	self:SharedInitialize()

	self.m_LocalRemoveTime = CurTime() + 10
end

function ENT:Think()
	self:SetRenderBounds(BOUNDS_MINS, BOUNDS_MAXS)
	self:NextThink(CurTime())
	return true
end

function ENT:DrawTranslucent()
	local removetime = self:GetRemoveTime()
	if removetime <= 0 then
		removetime = self.m_LocalRemoveTime or (CurTime() + 10)
	end

	local cycle = math.Clamp((CurTime() - self.Created) * 0.8, 0, 1) * self:GetDeathSequenceLength() + self:GetDeathSequenceStart()
	local sequence = self:GetDeathSequence()

	if cycle >= 1 then
		cycle = 1
		local idleseq = self:LookupSequence("zombie_slump_idle_01")
		if idleseq and idleseq > 0 then
			sequence = idleseq
		end
	end

	self:SetSequence(sequence)
	self:SetCycle(cycle)
	self:SetAngles(self:GetDeathAngles())

	local col = self:GetColor()
	local alpha = math.Clamp(removetime - CurTime(), 0, 1) * (col.a / 255)

	if alpha <= 0 then return end

	render.SetBlend(alpha)
	render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
end
