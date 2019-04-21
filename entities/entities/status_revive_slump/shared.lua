ENT.Type = "anim"
ENT.Base = "status__base"

ENT.AnimTime = 1.9

function ENT:GetRagdollEyes(pl)
	local attachid = pl:LookupAttachment("eyes")
	if attachid then
		local attach = pl:GetAttachment(attachid)
		if attach then
			return attach.Pos, attach.Ang
		end
	end
end

function ENT:IsRising()
	return self:GetReviveTime() - self.AnimTime <= CurTime()
end

function ENT:SetReviveTime(tim)
	self:SetDTFloat(0, tim)
end

function ENT:GetReviveTime()
	return self:GetDTFloat(0)
end

function ENT:SetReviveAnim(t)
	self:SetDTFloat(1, t)
end

function ENT:GetReviveAnim()
	return self:GetDTFloat(1)
end

function ENT:SetReviveHeal(h)
	self:SetDTFloat(2, h)
end

function ENT:GetReviveHeal()
	return self:GetDTFloat(2)
end
