local ScoreBoard
function GM:ScoreboardShow()
	gui.EnableScreenClicker(true)
	PlayMenuOpenSound()

	if not ScoreBoard then
		ScoreBoard = vgui.Create("ZSScoreBoard")
	end

	local screenscale = BetterScreenScale()

	ScoreBoard:SetSize(math.min(974, ScrW() * 0.65) * math.max(1, screenscale), ScrH() * 0.85)
	ScoreBoard:AlignTop(ScrH() * 0.05)
	ScoreBoard:CenterHorizontal()
	ScoreBoard:SetAlpha(0)
	ScoreBoard:AlphaTo(255, 0.15, 0)
	ScoreBoard:SetVisible(true)
end

function GM:ScoreboardRebuild()
	self:ScoreboardHide()
	ScoreBoard = nil
end

function GM:ScoreboardHide()
	gui.EnableScreenClicker(false)

	if ScoreBoard then
		PlayMenuCloseSound()
		ScoreBoard:SetVisible(false)
	end
end

local PANEL = {}

PANEL.RefreshTime = 2
PANEL.NextRefresh = 0
PANEL.m_MaximumScroll = 0

local function BlurPaint(self)
	draw.SimpleTextBlur(self:GetValue(), self.Font, 0, 0, self:GetTextColor())

	return true
end

function PANEL:Init()
	self.NextRefresh = RealTime() + 0.1

	self.m_TitleLabel = vgui.Create("DLabel", self)
	self.m_TitleLabel.Font = "ZSScoreBoardTitle"
	self.m_TitleLabel:SetFont(self.m_TitleLabel.Font)
	self.m_TitleLabel:SetText(GAMEMODE.Name)
	self.m_TitleLabel:SetTextColor(COLOR_GRAY)
	self.m_TitleLabel:SizeToContents()
	self.m_TitleLabel:NoClipping(true)
	self.m_TitleLabel.Paint = BlurPaint

	self.m_ServerNameLabel = vgui.Create("DLabel", self)
	self.m_ServerNameLabel.Font = "ZSScoreBoardSubTitle"
	self.m_ServerNameLabel:SetFont(self.m_ServerNameLabel.Font)
	self.m_ServerNameLabel:SetText(GetHostName())
	self.m_ServerNameLabel:SetTextColor(COLOR_GRAY)
	self.m_ServerNameLabel:SizeToContents()
	self.m_ServerNameLabel:NoClipping(true)
	self.m_ServerNameLabel.Paint = BlurPaint

	self.m_AuthorLabel = EasyLabel(self, "by "..GAMEMODE.Author.." ("..GAMEMODE.Email..")", "ZSScoreBoardPing", COLOR_GRAY)
	self.m_ContactLabel = EasyLabel(self, GAMEMODE.Website, "ZSScoreBoardPing", COLOR_GRAY)

	self.m_HumanHeading = vgui.Create("DTeamHeading", self)
	self.m_HumanHeading:SetTeam(TEAM_HUMAN)

	self.m_ZombieHeading = vgui.Create("DTeamHeading", self)
	self.m_ZombieHeading:SetTeam(TEAM_UNDEAD)

	self.m_PointsLabel = EasyLabel(self, "Score", "ZSScoreBoardPlayer", COLOR_GRAY)
	self.m_RemortCLabel = EasyLabel(self, "R.LVL", "ZSScoreBoardPlayer", COLOR_GRAY)

	self.m_BrainsLabel = EasyLabel(self, "Brains", "ZSScoreBoardPlayer", COLOR_GRAY)
	self.m_RemortCZLabel = EasyLabel(self, "R.LVL", "ZSScoreBoardPlayer", COLOR_GRAY)

	self.ZombieList = vgui.Create("DScrollPanel", self)
	self.ZombieList.Team = TEAM_UNDEAD

	self.HumanList = vgui.Create("DScrollPanel", self)
	self.HumanList.Team = TEAM_HUMAN

	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local screenscale = math.max(0.95, BetterScreenScale())

	self.m_AuthorLabel:MoveBelow(self.m_TitleLabel)
	self.m_ContactLabel:MoveBelow(self.m_AuthorLabel)

	self.m_ServerNameLabel:SetPos(math.min(self:GetWide() - self.m_ServerNameLabel:GetWide(), self:GetWide() * 0.75 - self.m_ServerNameLabel:GetWide() * 0.5), 32 - self.m_ServerNameLabel:GetTall() / 2)

	self.m_HumanHeading:SetSize(self:GetWide() / 2 - 32, 28 * screenscale)
	self.m_HumanHeading:SetPos(self:GetWide() * 0.25 - self.m_HumanHeading:GetWide() * 0.5, 110 * screenscale - self.m_HumanHeading:GetTall())

	self.m_ZombieHeading:SetSize(self:GetWide() / 2 - 32, 28 * screenscale)
	self.m_ZombieHeading:SetPos(self:GetWide() * 0.75 - self.m_ZombieHeading:GetWide() * 0.5, 110 * screenscale - self.m_ZombieHeading:GetTall())

	self.m_PointsLabel:SizeToContents()
	self.m_PointsLabel:SetPos((self:GetWide() / 2 - 24) * 0.6 - self.m_PointsLabel:GetWide() * 0.35, 110 * screenscale - self.m_HumanHeading:GetTall())
	self.m_PointsLabel:MoveBelow(self.m_HumanHeading, 1 * screenscale)

	self.m_RemortCLabel:SizeToContents()
	self.m_RemortCLabel:SetPos((self:GetWide() / 2 - 24) * 0.71 - self.m_RemortCLabel:GetWide() * 0.5, 110 * screenscale - self.m_HumanHeading:GetTall())
	self.m_RemortCLabel:MoveBelow(self.m_HumanHeading, 1 * screenscale)

	self.m_BrainsLabel:SizeToContents()
	self.m_BrainsLabel:SetPos(self:GetWide() / 2 + 3 * screenscale + (self:GetWide() / 2 - 24) * 0.61 - self.m_BrainsLabel:GetWide() * 0.35, 110 * screenscale - self.m_HumanHeading:GetTall())
	self.m_BrainsLabel:MoveBelow(self.m_ZombieHeading, 1 * screenscale)

	self.m_RemortCZLabel:SizeToContents()
	self.m_RemortCZLabel:SetPos(self:GetWide() / 2 + 3 * screenscale + (self:GetWide() / 2 - 24) * 0.71 - self.m_RemortCZLabel:GetWide() * 0.5, 110 * screenscale - self.m_HumanHeading:GetTall())
	self.m_RemortCZLabel:MoveBelow(self.m_ZombieHeading, 1 * screenscale)

	self.HumanList:SetSize(self:GetWide() / 2 - 24, self:GetTall() - 150 * screenscale)
	self.HumanList:AlignBottom(16 * screenscale)
	self.HumanList:AlignLeft(8 * screenscale)

	self.ZombieList:SetSize(self:GetWide() / 2 - 24, self:GetTall() - 150 * screenscale)
	self.ZombieList:AlignBottom(16 * screenscale)
	self.ZombieList:AlignRight(8 * screenscale)
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:RefreshScoreboard()
	end
end

local texRightEdge = surface.GetTextureID("gui/gradient")
local texCorner = surface.GetTextureID("zombiesurvival/circlegradient")
local texDownEdge = surface.GetTextureID("gui/gradient_down")
function PANEL:Paint()
	local wid, hei = self:GetSize()
	local barw = 64

	surface.SetDrawColor(5, 5, 5, 180)
	surface.DrawRect(0, 64, wid, hei - 64)
	surface.SetDrawColor(90, 90, 90, 180)
	surface.DrawOutlinedRect(0, 64, wid, hei - 64)

	surface.SetDrawColor(5, 5, 5, 220)
	PaintGenericFrame(self, 0, 0, wid, 64, 32)

	surface.SetDrawColor(5, 5, 5, 160)
	surface.DrawRect(wid * 0.5 - 16, 64, 32, hei - 128)
	surface.SetTexture(texRightEdge)
	surface.DrawTexturedRect(wid * 0.5 + 16, 64, barw, hei - 128)
	surface.DrawTexturedRectRotated(wid * 0.5 - 16 - barw / 2, 64 + (hei - 128) / 2, barw, hei - 128, 180)
	surface.SetTexture(texCorner)
	surface.DrawTexturedRectRotated(wid * 0.5 - 16 - barw / 2, hei - 32, barw, 64, 90)
	surface.DrawTexturedRectRotated(wid * 0.5 + 16 + barw / 2, hei - 32, barw, 64, 180)
	surface.SetTexture(texDownEdge)
	surface.DrawTexturedRect(wid * 0.5 - 16, hei - 64, 32, 64)
end

function PANEL:GetPlayerPanel(pl)
	for _, panel in pairs(self.PlayerPanels) do
		if panel:IsValid() and panel:GetPlayer() == pl then
			return panel
		end
	end
end

function PANEL:CreatePlayerPanel(pl)
	local curpan = self:GetPlayerPanel(pl)
	if curpan and curpan:IsValid() then return curpan end

	if pl:Team() == TEAM_SPECTATOR then return end

	local panel = vgui.Create("ZSPlayerPanel", pl:Team() == TEAM_UNDEAD and self.ZombieList or self.HumanList)
	panel:SetPlayer(pl)
	panel:Dock(TOP)
	panel:DockMargin(8, 2, 8, 2)

	self.PlayerPanels[pl] = panel

	return panel
end

function PANEL:RefreshScoreboard()
	self.m_ServerNameLabel:SetText(GetHostName())
	self.m_ServerNameLabel:SizeToContents()
	self.m_ServerNameLabel:SetPos(math.min(self:GetWide() - self.m_ServerNameLabel:GetWide(), self:GetWide() * 0.75 - self.m_ServerNameLabel:GetWide() * 0.5), 32 - self.m_ServerNameLabel:GetTall() / 2)

	if self.PlayerPanels == nil then self.PlayerPanels = {} end

	for pl, panel in pairs(self.PlayerPanels) do
		if not panel:IsValid() or pl:IsValid() and pl:IsSpectator() then
			self:RemovePlayerPanel(panel)
		end
	end

	for _, pl in pairs(player.GetAllActive()) do
		self:CreatePlayerPanel(pl)
	end
end

function PANEL:RemovePlayerPanel(panel)
	if panel:IsValid() then
		self.PlayerPanels[panel:GetPlayer()] = nil
		panel:Remove()
	end
end

vgui.Register("ZSScoreBoard", PANEL, "Panel")

PANEL = {}

PANEL.RefreshTime = 1

PANEL.m_Player = NULL
PANEL.NextRefresh = 0

local function MuteDoClick(self)
	local pl = self:GetParent():GetPlayer()
	if pl:IsValid() then
		pl:SetMuted(not pl:IsMuted())
		self:GetParent().NextRefresh = RealTime()
	end
end

GM.ZSFriends = {}
--[[hook.Add("Initialize", "LoadZSFriends", function()
	if file.Exists(GAMEMODE.FriendsFile, "DATA") then
		GAMEMODE.ZSFriends = Deserialize(file.Read(GAMEMODE.FriendsFile)) or {}
	end
end)]]

local function ToggleZSFriend(self)
	if MySelf.LastFriendAdd and MySelf.LastFriendAdd + 2 > CurTime() then return end

	local pl = self:GetParent():GetPlayer()
	if pl:IsValid() then
		if GAMEMODE.ZSFriends[pl:SteamID()] then
			GAMEMODE.ZSFriends[pl:SteamID()] = nil
		else
			GAMEMODE.ZSFriends[pl:SteamID()] = true
		end

		self:GetParent().NextRefresh = RealTime()

		net.Start("zs_zsfriend")
			net.WriteString(pl:SteamID())
			net.WriteBool(GAMEMODE.ZSFriends[pl:SteamID()])
		net.SendToServer()

		MySelf.LastFriendAdd = CurTime()
		--file.Write(GAMEMODE.FriendsFile, Serialize(GAMEMODE.ZSFriends))
	end
end

net.Receive("zs_zsfriendadded", function()
	local pl = net:ReadEntity()
	pl.ZSFriendAdded = net:ReadBool()
end)

local function AvatarDoClick(self)
	local pl = self.PlayerPanel:GetPlayer()
	if pl:IsValidPlayer() then
		pl:ShowProfile()
	end
end

local function empty() end

function PANEL:Init()
	local screenscale = math.max(0.95, BetterScreenScale())
	self:SetTall(32 * screenscale)

	self.m_AvatarButton = self:Add("DButton", self)
	self.m_AvatarButton:SetText(" ")
	self.m_AvatarButton:SetSize(32 * screenscale, 32 * screenscale)
	self.m_AvatarButton:Center()
	self.m_AvatarButton.DoClick = AvatarDoClick
	self.m_AvatarButton.Paint = empty
	self.m_AvatarButton.PlayerPanel = self

	self.m_Avatar = vgui.Create("AvatarImage", self.m_AvatarButton)
	self.m_Avatar:SetSize(32 * screenscale, 32 * screenscale)
	self.m_Avatar:SetVisible(false)
	self.m_Avatar:SetMouseInputEnabled(false)

	self.m_SpecialImage = vgui.Create("DImage", self)
	self.m_SpecialImage:SetSize(16, 16)
	self.m_SpecialImage:SetMouseInputEnabled(true)
	self.m_SpecialImage:SetVisible(false)

	self.m_ClassImage = vgui.Create("DImage", self)
	self.m_ClassImage:SetSize(22 * screenscale, 22 * screenscale)
	self.m_ClassImage:SetMouseInputEnabled(false)
	self.m_ClassImage:SetVisible(false)

	self.m_PlayerLabel = EasyLabel(self, " ", "ZSScoreBoardPlayer", COLOR_WHITE)
	self.m_ScoreLabel = EasyLabel(self, " ", "ZSScoreBoardPlayerSmall", COLOR_WHITE)
	self.m_RemortLabel = EasyLabel(self, " ", "ZSScoreBoardPlayerSmaller", COLOR_WHITE)

	self.m_PingMeter = vgui.Create("DPingMeter", self)
	self.m_PingMeter.PingBars = 5

	self.m_Mute = vgui.Create("DImageButton", self)
	self.m_Mute.DoClick = MuteDoClick

	self.m_Friend = vgui.Create("DImageButton", self)
	self.m_Friend.DoClick = ToggleZSFriend
end

local colTemp = Color(255, 255, 255, 200)
function PANEL:Paint()
	local col = color_black_alpha220
	local mul = 0.5
	local pl = self:GetPlayer()
	if pl:IsValid() then
		col = team.GetColor(pl:Team())

		if self.m_Flash then
			mul = 0.6 + math.abs(math.sin(RealTime() * 6)) * 0.4
		elseif pl == MySelf then
			mul = 0.8
		end
	end

	if self.Hovered then
		mul = math.min(1, mul * 1.5)
	end

	colTemp.r = col.r * mul
	colTemp.g = col.g * mul
	colTemp.b = col.b * mul
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), colTemp)

	return true
end

function PANEL:DoClick()
	local pl = self:GetPlayer()
	if pl:IsValid() then
		gamemode.Call("ClickedPlayerButton", pl, self)
	end
end

function PANEL:PerformLayout()
	self.m_AvatarButton:AlignLeft(16)
	self.m_AvatarButton:CenterVertical()

	self.m_PlayerLabel:SizeToContents()
	self.m_PlayerLabel:MoveRightOf(self.m_AvatarButton, 4)
	self.m_PlayerLabel:CenterVertical()

	self.m_ScoreLabel:SizeToContents()
	self.m_ScoreLabel:SetPos(self:GetWide() * 0.6 - self.m_ScoreLabel:GetWide() / 2, 0)
	self.m_ScoreLabel:CenterVertical()

	self.m_SpecialImage:CenterVertical()

	self.m_ClassImage:SetSize(self:GetTall(), self:GetTall())
	self.m_ClassImage:SetPos(self:GetWide() * 0.75 - self.m_ClassImage:GetWide() * 0.5, 0)
	self.m_ClassImage:CenterVertical()

	local pingsize = self:GetTall() - 4

	self.m_PingMeter:SetSize(pingsize, pingsize)
	self.m_PingMeter:AlignRight(8)
	self.m_PingMeter:CenterVertical()

	self.m_Mute:SetSize(16, 16)
	self.m_Mute:MoveLeftOf(self.m_PingMeter, 8)
	self.m_Mute:CenterVertical()

	self.m_Friend:SetSize(16, 16)
	self.m_Friend:MoveLeftOf(self.m_Mute, 8)
	self.m_Friend:CenterVertical()

	self.m_RemortLabel:SizeToContents()
	self.m_RemortLabel:MoveLeftOf(self.m_ClassImage, 2)
	self.m_RemortLabel:CenterVertical()
end

function PANEL:RefreshPlayer()
	local pl = self:GetPlayer()
	if not pl:IsValid() then
		self:Remove()
		return
	end

	local name = pl:Name()
	if #name > 23 then
		name = string.sub(name, 1, 21)..".."
	end
	self.m_PlayerLabel:SetText(name)
	self.m_PlayerLabel:SetAlpha(240)

	self.m_ScoreLabel:SetText(pl:Frags())
	self.m_ScoreLabel:SetAlpha(240)

	local rlvl = pl:GetZSRemortLevel()
	self.m_RemortLabel:SetText(rlvl > 0 and rlvl or "")

	local rlvlmod = math.floor((rlvl % 40) / 4)
	local hcolor, hlvl = COLOR_GRAY, 0
	for rlvlr, rcolor in pairs(GAMEMODE.RemortColors) do
		if rlvlmod >= rlvlr and rlvlr >= hlvl then
			hlvl = rlvlr
			hcolor = rcolor
		end
	end
	self.m_RemortLabel:SetColor(hcolor)
	self.m_RemortLabel:SetAlpha(240)

	if MySelf:Team() == TEAM_UNDEAD and pl:Team() == TEAM_UNDEAD and pl:GetZombieClassTable().Icon then
		self.m_ClassImage:SetVisible(true)
		self.m_ClassImage:SetImage(pl:GetZombieClassTable().Icon)
		self.m_ClassImage:SetImageColor(pl:GetZombieClassTable().IconColor or color_white)
	else
		self.m_ClassImage:SetVisible(false)
	end

	if pl == MySelf then
		self.m_Mute:SetVisible(false)
		self.m_Friend:SetVisible(false)
	else
		if pl:IsMuted() then
			self.m_Mute:SetImage("icon16/sound_mute.png")
		else
			self.m_Mute:SetImage("icon16/sound.png")
		end

		self.m_Friend:SetColor(pl.ZSFriendAdded and COLOR_LIMEGREEN or COLOR_GRAY)
		self.m_Friend:SetImage(GAMEMODE.ZSFriends[pl:SteamID()] and "icon16/heart_delete.png" or "icon16/heart.png")
	end

	self:SetZPos(-pl:Frags())

	if pl:Team() ~= self._LastTeam then
		self._LastTeam = pl:Team()
		self:SetParent(self._LastTeam == TEAM_HUMAN and ScoreBoard.HumanList or ScoreBoard.ZombieList)
	end

	self:InvalidateLayout()
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:RefreshPlayer()
	end
end

function PANEL:SetPlayer(pl)
	self.m_Player = pl or NULL

	if pl:IsValidPlayer() then
		self.m_Avatar:SetPlayer(pl)
		self.m_Avatar:SetVisible(true)

		if gamemode.Call("IsSpecialPerson", pl, self.m_SpecialImage) then
			self.m_SpecialImage:SetVisible(true)
		else
			self.m_SpecialImage:SetTooltip()
			self.m_SpecialImage:SetVisible(false)
		end

		self.m_Flash = pl:SteamID() == "STEAM_0:1:3307510"
	else
		self.m_Avatar:SetVisible(false)
		self.m_SpecialImage:SetVisible(false)
	end

	self.m_PingMeter:SetPlayer(pl)

	self:RefreshPlayer()
end

function PANEL:GetPlayer()
	return self.m_Player
end

vgui.Register("ZSPlayerPanel", PANEL, "Button")
