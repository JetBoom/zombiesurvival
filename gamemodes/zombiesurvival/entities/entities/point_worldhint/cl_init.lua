INC_CLIENT()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

function ENT:Draw()
end

function ENT:DrawHint()
	if self:GetViewable() == 0 or self:GetViewable() == MySelf:Team() then
		local pos = self:GetPos()
		local eyepos = EyePos()
		local range = self:GetRange()

		if range <= 0 then
			DrawWorldHint(self:GetHint(), pos)
		else
			local dist = pos:DistToSqr(eyepos)
			if dist <= range * range then
				DrawWorldHint(self:GetHint(), pos)
			end
		end
	end
end
