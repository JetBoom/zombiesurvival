local PANEL = {}

PANEL.m_Team = 0

PANEL.NextRefresh = 0

local function ImageThink(self)
	self:SetRotation(math.sin((RealTime() + self.Seed) * 0.5) * 25)
	self:OldPaint()
end

function PANEL:Init()
	self.m_Image = vgui.Create("DEXRotatedImage", self)
	self.m_Image:SetImage("icon16/check_off.png")
	self.m_Image.Seed = math.Rand(0, 1000)
	self.m_Image.OldPaint = self.m_Image.Paint
	self.m_Image.Paint = ImageThink

	self.m_Counter = vgui.Create("DLabel", self)
	self.m_Counter:SetFont("ZSHUDFontSmaller")

	self:Refresh()
end

function PANEL:Paint()
	return true
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + 1
		self:Refresh()
	end
end

function PANEL:SetTeam(teamid)
	self.m_Team = teamid
	self.m_Counter:SetTextColor(team.GetColor(teamid))
end

function PANEL:SetImage(mat)
	self.m_Image:SetImage(mat)

	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	self.m_Image:SetSize(self:GetSize())
	self.m_Counter:AlignBottom()
	self.m_Counter:AlignRight()
end

function PANEL:Refresh()
	local numplayers = team.NumPlayers(self.m_Team)
	self.m_PrevPlayers = self.m_PrevPlayers or numplayers

	self.m_Counter:SetText(numplayers)
	self.m_Counter:SizeToContents()

	if self.m_PrevPlayers ~= numplayers then
		self.m_Counter:Stop()
		self.m_Counter:SetColor(numplayers > self.m_PrevPlayers and color_white or COLOR_RED)
		self.m_Counter:ColorTo(team.GetColor(self.m_Team), 2)

		self.m_PrevPlayers = numplayers
	end

	self:InvalidateLayout()
end

vgui.Register("DTeamCounter", PANEL, "DPanel")
