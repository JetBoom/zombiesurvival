include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	self:GetOwner().Teleport = self
end

function ENT:OnRemove()
	self:GetOwner().Teleport = nil
end

function ENT:Think()
end

function ENT:Draw()

end

local colTeleport = Color(20, 20, 255, 220)
local function drawBar(x, y, fraction, screenscale, destName)
	
	local maxbarwidth = 270 * screenscale
	local barheight = 11 * screenscale
	local barwidth = maxbarwidth * math.Clamp(fraction, 0, 1)
	local startx = x - maxbarwidth * 0.5
	
	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect(startx, y, maxbarwidth, barheight)
	surface.SetDrawColor(colTeleport)
	surface.DrawRect(startx + 3, y + 3, barwidth - 6, barheight - 6)
	surface.DrawOutlinedRect(startx, y, maxbarwidth, barheight)
	
	draw.SimpleText(translate.Format("sigil_teleporting", destName), "ZSHUDFontSmall", x, y - draw.GetFontHeight("ZSHUDFontSmall") - 2, col, TEXT_ALIGN_CENTER)
end

hook.Add("HUDPaint", "HUDPaint_Teleport", function()
	local teleport = LocalPlayer().Teleport
	if IsValid(teleport) and IsValid(teleport:GetDestSigil()) then
		local destName = teleport:GetDestSigil():GetSigilLetter()
		drawBar(ScrW() * 0.5, ScrH() * 0.55, 1 - teleport:GetTimeRemaining() / teleport:GetMaxTime(), BetterScreenScale(), destName)
	end
end)