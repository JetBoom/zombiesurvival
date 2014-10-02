local PANEL = {}

PANEL.IdealPing = 50
PANEL.MaxPing = 400
PANEL.RefreshTime = 1
PANEL.PingBars = 4

PANEL.m_Player = NULL
PANEL.m_Ping = 0
PANEL.NextRefresh = 0

function PANEL:Init()
end

local colPing = Color(255, 255, 60, 255)
function PANEL:Paint()
	local ping = self:GetPing()
	local pingmul = 1 - math.Clamp((ping - self.IdealPing) / self.MaxPing, 0, 1)
	local wid, hei = self:GetWide(), self:GetTall()
	local pingbars = math.max(1, self.PingBars)
	local barwidth = wid / pingbars
	local baseheight = hei / pingbars

	colPing.r = (1 - pingmul) * 255
	colPing.g = pingmul * 255

	for i=1, pingbars do
		local barheight = baseheight * i
		local x, y = (i - 1) * barwidth, hei - barheight

		surface.SetDrawColor(20, 20, 20, 255)
		surface.DrawRect(x, y, barwidth, barheight)

		if i == 1 or pingmul >= i / pingbars then
			surface.SetDrawColor(colPing)
			surface.DrawRect(x, y, barwidth, barheight)
		end

		surface.SetDrawColor(80, 80, 80, 255)
		surface.DrawOutlinedRect(x, y, barwidth, barheight)
	end

	draw.SimpleText(ping, "DefaultFontSmall", 0, 0, colPing)

	return true
end

function PANEL:Refresh()
	local pl = self:GetPlayer()
	if pl:IsValid() then
		self:SetPing(pl:Ping())
	else
		self:SetPing(0)
	end
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:Refresh()
	end
end

function PANEL:SetPlayer(pl)
	self.m_Player = pl or NULL
	self:Refresh()
end

function PANEL:GetPlayer()
	return self.m_Player
end

function PANEL:SetPing(ping)
	self.m_Ping = ping
end

function PANEL:GetPing()
	return self.m_Ping
end

vgui.Register("DPingMeter", PANEL, "Panel")
