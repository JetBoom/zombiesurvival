INC_SERVER()

local ViewHullMins = Vector(-4, -4, -4)
local ViewHullMaxs = Vector(4, 4, 4)
function ENT:Initialize()
	self:SharedInitialize()

	local tr = util.TraceHull({start = self:GetPos(), endpos = self:GetPos() + Vector(0, 0, -10240), mask = MASK_SOLID_BRUSHONLY, mins = ViewHullMins, maxs = ViewHullMaxs})
	self:SetPos(tr.HitPos + tr.HitNormal)
end

function ENT:Think()
	if self:GetRemoveTime() > 0 and CurTime() >= self:GetRemoveTime() then
		self:Remove()
	end
end
