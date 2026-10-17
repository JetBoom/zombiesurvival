local PANEL = {}
PANEL.m_Team = 0
PANEL.NextRefresh = 0
PANEL.RefreshTime = 2

-- Font size fallback chain (largest first).
local HEADING_FONT_CHAIN = {
	"ZSScoreBoardHeading",
	"ZSScoreBoardSubTitle",
	"ZSScoreBoardPlayer",
	"ZSScoreBoardPlayerSmall",
	"ZSScoreBoardPlayerSmaller",
	"ZSScoreBoardPing",
}

-- Extra vertical room inside the label so descenders
-- (Cyrillic у/р/ц/щ/д, CJK bottoms) aren't clipped by the label's
-- own bounds. DLabel clips its own text to its rect; without this
-- the last baseline pixels get cut off.
local NAME_PAD_Y = 8

local function PickFittingFont(text, maxw)
	maxw = math.max(1, maxw or 0)
	for _, f in ipairs(HEADING_FONT_CHAIN) do
		surface.SetFont(f)
		if surface.GetTextSize(text) <= maxw then
			return f
		end
	end
	return HEADING_FONT_CHAIN[#HEADING_FONT_CHAIN]
end

function PANEL:Init()
	-- NOTE: Panel:SetClipChildren does not exist in vanilla GMod.
	-- A Panel does NOT clip its children by default, so we don't
	-- need it here — the fix is on the label itself (see PerformLayout).

	self.m_TeamNameLabel  = EasyLabel(self, " ", HEADING_FONT_CHAIN[1], color_black)
	self.m_TeamCountLabel = EasyLabel(self, " ", HEADING_FONT_CHAIN[1], color_black)

	-- Center content inside the label rect so ascenders / descenders
	-- are not cut off by the label's own bounds.
	self.m_TeamNameLabel:SetContentAlignment(5)
	self.m_TeamCountLabel:SetContentAlignment(5)

	self.m_TeamCountLabel:SizeToContents()

	self.m_Icon = vgui.Create("DImage", self)
	self.m_Icon:SetVisible(false)
	self.m_Icon:NoClipping(true)

	self:InvalidateLayout()
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:RefreshContents()
	end
end

function PANEL:PerformLayout()
	local wid = self:GetWide()
	local hei = self:GetTall()

	local iconW  = self.m_Icon:IsVisible() and self.m_Icon:GetWide() or 0
	local countW = self.m_TeamCountLabel:GetWide()

	-- Room for icon (left), count (right), plus a bit of breathing space.
	local nameMaxW = math.max(1, wid - iconW - countW - 24)

	-- Auto-shrink the name so it never spills into the icon or the counter.
	local nameText = self.m_TeamNameLabel:GetText() or ""
	local fitFont  = PickFittingFont(nameText, nameMaxW)
	if self.m_TeamNameLabel:GetFont() ~= fitFont then
		self.m_TeamNameLabel:SetFont(fitFont)
	end

	-- Manual size: SizeToContents gives the raw line height, which can
	-- still be a couple of pixels too small for fonts with real descenders.
	surface.SetFont(fitFont)
	local tw, th = surface.GetTextSize(nameText)

	self.m_TeamNameLabel:SetSize(math.max(1, tw + 4), th + NAME_PAD_Y)
	self.m_TeamNameLabel:SetPos(
		(wid - self.m_TeamNameLabel:GetWide()) / 2,
		(hei - self.m_TeamNameLabel:GetTall()) / 2
	)

	self.m_TeamCountLabel:AlignRight(16)
	self.m_TeamCountLabel:CenterVertical()

	self.m_Icon:AlignLeft(2)
	self.m_Icon:CenterVertical()
end

function PANEL:RefreshContents()
	local teamid = self:GetTeam()

	self.m_TeamNameLabel:SetText(team.GetName(teamid))

	self.m_TeamCountLabel:SetText(team.NumPlayers(teamid))
	self.m_TeamCountLabel:SizeToContents()

	self:InvalidateLayout()
end

function PANEL:Paint()
	local wid, hei = self:GetWide(), self:GetTall()

	surface.SetDrawColor(130, 130, 130, 180)
	surface.DrawRect(0, 0, wid, hei)
	surface.SetDrawColor(60, 60, 60, 180)
	surface.DrawOutlinedRect(0, 0, wid, hei)

	return true
end

function PANEL:SetTeam(teamid)
	self.m_Team = teamid

	if teamid == TEAM_HUMAN then
		self.m_Icon:SetVisible(true)
		self.m_Icon:SetImage("zombiesurvival/humanhead")
		self.m_Icon:SizeToContents()
		self:InvalidateLayout()
	elseif teamid == TEAM_UNDEAD then
		self.m_Icon:SetVisible(true)
		self.m_Icon:SetImage("zombiesurvival/zombiehead")
		self.m_Icon:SizeToContents()
		self:InvalidateLayout()
	else
		self.m_Icon:SetVisible(false)
	end
end

function PANEL:GetTeam() return self.m_Team end

vgui.Register("DTeamHeading", PANEL, "Panel")