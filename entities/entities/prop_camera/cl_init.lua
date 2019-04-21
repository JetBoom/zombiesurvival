INC_CLIENT()

function ENT:SetObjectHealth(health)
	self:SetDTFloat(3, health)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(1, ent)
end

local render_SetBlend = render.SetBlend
function ENT:Draw()
	if FROM_CAMERA == self then return end

	local lp = LocalPlayer()
	if lp:IsValid() and lp:Team() == TEAM_UNDEAD then
		local dist = EyePos():DistToSqr(self:GetPos())
		if dist > 15000 then return end

		render_SetBlend(math.Clamp(1 - dist / 7500, 0, 1))

		self:DrawModel()

		render_SetBlend(1)
	else
		self:DrawModel()
	end
end
