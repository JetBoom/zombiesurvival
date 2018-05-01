ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

function ENT:Initialize()
	self:DrawShadow(false)
	if self:GetDTFloat(1) == 0 then
		self:SetDTFloat(1, CurTime())
	end

	if CLIENT then
		hook.Add("Draw", self, self.Draw)
	end
end

function ENT:SetHealLeft(healleft)
	self:SetDTFloat(0, math.min(75, healleft))
end

function ENT:GetHealLeft()
	return self:GetDTFloat(0)
end
