INC_CLIENT()

function ENT:GetDim()
	local creation_time = self:GetStartTime()
	local time = CurTime()
	local life_time = self:GetDuration()
	local end_time = creation_time + life_time

	if time > end_time - 0.5 then
		return math.Clamp((end_time - time) * 2, 0, 1)
	end

	if time < creation_time + 0.5 then
		return math.max(0, (time - creation_time) * 2)
	end

	return 1
end

function ENT:Draw()
end

local colModDimVision = {
	["$pp_colour_colour"] = 1,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_mulr"]	= 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0
}
function ENT:RenderScreenspaceEffects()
	if MySelf ~= self:GetOwner() then return end

	colModDimVision["$pp_colour_brightness"] = self:GetDim() * -0.15
	DrawColorModify(colModDimVision)
end
