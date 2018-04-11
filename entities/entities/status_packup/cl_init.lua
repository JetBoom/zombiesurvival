include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	self:GetOwner().PackUp = self
end

function ENT:OnRemove()
end

function ENT:Think()
end

function ENT:Draw()
	local packup = LocalPlayer().PackUp
	if packup and packup:IsValid() then
		self:DrawPackUpBar(ScrW() * 0.5, ScrH() * 0.55, 1 - packup:GetTimeRemaining() / packup:GetMaxTime(), packup:GetNotOwner(), BetterScreenScale())
	end
end

local colPackUp = Color(20, 255, 20, 220)
local colPackUpNotOwner = Color(255, 240, 10, 220)
function ENT:DrawPackUpBar(x, y, fraction, notowner, screenscale)
	local col = notowner and colPackUpNotOwner or colPackUp

	local maxbarwidth = 270 * screenscale
	local barheight = 11 * screenscale
	local barwidth = maxbarwidth * math.Clamp(fraction, 0, 1)
	local startx = x - maxbarwidth * 0.5

	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect(startx, y, maxbarwidth, barheight)
	surface.SetDrawColor(col)
	surface.DrawRect(startx + 3, y + 3, barwidth - 6, barheight - 6)
	surface.DrawOutlinedRect(startx, y, maxbarwidth, barheight)

	draw.SimpleText(notowner and CurTime() % 2 < 1 and translate.Format("requires_x_people", 4) or notowner and translate.Get("packing_others_object") or translate.Get("packing"), "ZSHUDFontSmall", x, y - draw.GetFontHeight("ZSHUDFontSmall") - 2, col, TEXT_ALIGN_CENTER)
end

--local colPackUp = Color(20, 255, 20, 220)
--local colPackUpNotOwner = Color(255, 240, 10, 220)
--function GM:DrawPackUpBar(x, y, fraction, notowner, screenscale)
--	local col = notowner and colPackUpNotOwner or colPackUp
--
--	local maxbarwidth = 270 * screenscale
--	local barheight = 11 * screenscale
--	local barwidth = maxbarwidth * math.Clamp(fraction, 0, 1)
--	local startx = x - maxbarwidth * 0.5
--
--	surface_SetDrawColor(0, 0, 0, 220)
--	surface_DrawRect(startx, y, maxbarwidth, barheight)
--	surface_SetDrawColor(col)
--	surface_DrawRect(startx + 3, y + 3, barwidth - 6, barheight - 6)
--	surface_DrawOutlinedRect(startx, y, maxbarwidth, barheight)
--
--	draw_SimpleText(notowner and CurTime() % 2 < 1 and translate.Format("requires_x_people", 4) or notowner and translate.Get("packing_others_object") or translate.Get("packing"), "ZSHUDFontSmall", x, y - draw_GetFontHeight("ZSHUDFontSmall") - 2, col, TEXT_ALIGN_CENTER)
--end

--local packup = MySelf.PackUp
--if packup and packup:IsValid() then
--	self:DrawPackUpBar(w * 0.5, h * 0.55, 1 - packup:GetTimeRemaining() / packup:GetMaxTime(), packup:GetNotOwner(), screenscale)
--end
