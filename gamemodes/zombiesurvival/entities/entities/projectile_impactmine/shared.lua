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

-- Shared cache of rarely changing entities: all mines use the same one,
-- rebuilding it no more than twice per second in total.
local sharedFF, sharedProj = {}, {}
local sharedNext = 0

local function RefreshSharedFilterParts()
	local t = CurTime()
	if t < sharedNext then return end
	sharedNext = t + 0.5

	table.Empty(sharedFF)
	table.Empty(sharedProj)

	for _, e in ipairs(ents.FindByClass("prop_ffemitterfield")) do
		sharedFF[#sharedFF + 1] = e
	end
	for _, e in ipairs(ents.FindByClass("projectile_*")) do
		sharedProj[#sharedProj + 1] = e
	end
end

function ENT:GetScanFilter()
	RefreshSharedFilterParts()

	local filter = team.GetPlayers(TEAM_HUMAN)
	filter[#filter + 1] = self

	local n = #filter
	for i = 1, #sharedFF do
		filter[n + i] = sharedFF[i]
	end
	n = n + #sharedFF
	for i = 1, #sharedProj do
		filter[n + i] = sharedProj[i]
	end

	return filter
end

function ENT:GetCachedScanFilter()
	if CurTime() < (self.NextCache or 0) and self.CachedFilter then return self.CachedFilter end
	self.CachedFilter = self:GetScanFilter()
	self.NextCache = CurTime() + 1
	return self.CachedFilter
end
