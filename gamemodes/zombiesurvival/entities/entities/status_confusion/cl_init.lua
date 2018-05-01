INC_CLIENT()

function ENT:Initialize()
	self:DrawShadow(false)

	local owner = self:GetOwner()
	if owner:IsValid() then
		owner.Confusion = self
	end

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	if self:GetEndTime() == 0 then
		self:SetEndTime(CurTime() + 10)
	end
end

function ENT:Draw()
end

function ENT:CalcView(pl, pos, ang, fov, znear, zfar)
	ang.roll = ang.roll + math.sin(CurTime() * 0.5) * 50 * self:GetPower()
end

function ENT:RenderScreenSpaceEffects()
	local power = self:GetPower()

	local time = CurTime() * 1.5
	local sharpenpower = power * 0.4
	DrawSharpen(sharpenpower, math.sin(time) * 128)
	DrawSharpen(sharpenpower, math.cos(time) * 128)
	DrawMotionBlur(0.1 * power, 4 * power, 0.05)
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner.Confusion == self then
		owner.Confusion = nil
	end
end
