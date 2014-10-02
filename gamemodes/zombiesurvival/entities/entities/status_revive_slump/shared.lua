ENT.Type = "anim"
ENT.Base = "status__base"

ENT.AnimTime = 1.9

function ENT:GetRagdollEyes(pl)
	local attachid = pl:LookupAttachment("head")
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
