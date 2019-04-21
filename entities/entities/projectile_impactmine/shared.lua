ENT.Type = "anim"

ENT.Range = 384

ENT.IgnoreBullets = true

AccessorFuncDT(ENT, "HitTime", "Float", 0)

function ENT:IsActive()
	local hittime = self:GetHitTime()
	return hittime > 0 and CurTime() >= hittime + 2
end

function ENT:GetStartPos()
	return self:GetPos() + self:GetForward() * 9.25
end

function ENT:GetScanFilter()
	local filter = team.GetPlayers(TEAM_HUMAN)
	filter[#filter + 1] = self
	filter = table.Add(filter, ents.FindByClass("prop_ffemitterfield"))
	filter = table.Add(filter, ents.FindByClass("projectile_*"))

	return filter
end

local NextCache = 0
function ENT:GetCachedScanFilter()
	if CurTime() < NextCache and self.CachedFilter then return self.CachedFilter end

	self.CachedFilter = self:GetScanFilter()
	NextCache = CurTime() + 1

	return self.CachedFilter
end
