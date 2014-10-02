local PANEL = {}
PANEL.m_Team = 0
PANEL.NextRefresh = 0
PANEL.RefreshTime = 2

function PANEL:Init()
	self.m_TeamNameLabel = EasyLabel(self, " ", "ZSScoreBoardHeading", color_black)
	self.m_TeamCountLabel = EasyLabel(self, " ", "ZSScoreBoardHeading", color_black)

	self.m_Icon = vgui.Create("DImage", self)
	self.m_Icon:SetVisible(false)
	self.m_Icon:NoClipping(true)

	self:InvalidateLayout()
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:Refresh()
	end
end

function PANEL:PerformLayout()
	self.m_TeamNameLabel:Center()

	self.m_TeamCountLabel:AlignRight(16)
	self.m_TeamCountLabel:CenterVertical()

	self.m_Icon:AlignLeft(2)
	self.m_Icon:CenterVertical()
end

function PANEL:Refresh()
	local teamid = self:GetTeam()

	self.m_TeamNameLabel:SetText(team.GetName(teamid))
	self.m_TeamNameLabel:SizeToContents()

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
