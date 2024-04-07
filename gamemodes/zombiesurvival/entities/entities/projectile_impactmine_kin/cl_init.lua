INC_CLIENT()

local matBeam = Material("effects/laser1")
local matGlow = Material("sprites/glow04_noz")
local colBeam = Color(255, 168, 40, 255)
local COLOR_WHITE = color_white
local trace = {mask = MASK_SHOT}
function ENT:DrawTranslucent()
	if not self:IsActive() then return end

	local pos = self:GetStartPos()
	if CurTime() >= self.NextTrace then
		self.NextTrace = CurTime() + 0.15

		local forward = self:GetUp()
		trace.start = pos
		trace.endpos = pos + forward * self.Range
		trace.filter = self:GetCachedScanFilter()

		self.LastPos = util.TraceLine(trace).HitPos
	end

	local hitpos = self.LastPos
	render.SetMaterial(matBeam)
	render.DrawBeam(pos, hitpos, 0.33, 0, 1, COLOR_WHITE)
	render.DrawBeam(pos, hitpos, 1.3, 0, 1, colBeam)
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 2, 2, COLOR_WHITE)
	render.DrawSprite(pos, 8, 8, colBeam)
	render.DrawSprite(hitpos, 1, 1, COLOR_WHITE)
	render.DrawSprite(hitpos, 4, 4, colBeam)
end
