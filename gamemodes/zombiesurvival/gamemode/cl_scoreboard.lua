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

	self.ScoreboardVisible = true
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

	self.ScoreboardVisible = false
end

local PANEL = {}

PANEL.RefreshTime = 2
PANEL.NextRefresh = 0

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

	self.m_AuthorLabel = EasyLabel(self, translate.Format("scoreboard_author_format", GAMEMODE.Author, GAMEMODE.Email), "ZSScoreBoardPing", COLOR_GRAY)
	self.m_ContactLabel = EasyLabel(self, GAMEMODE.Website, "ZSScoreBoardPing", COLOR_GRAY)

	self.m_HumanHeading = vgui.Create("DTeamHeading", self)
	self.m_HumanHeading:SetTeam(TEAM_HUMAN)

	self.m_ZombieHeading = vgui.Create("DTeamHeading", self)
	self.m_ZombieHeading:SetTeam(TEAM_UNDEAD)

	self.m_PointsLabel = EasyLabel(self, translate.Get("scoreboard_score"), "ZSScoreBoardPlayer", COLOR_GRAY)
	self.m_RemortCLabel = EasyLabel(self, translate.Get("scoreboard_remort_level"), "ZSScoreBoardPlayer", COLOR_GRAY)

	self.m_BrainsLabel = EasyLabel(self, translate.Get("scoreboard_brains"), "ZSScoreBoardPlayer", COLOR_GRAY)
	self.m_RemortCZLabel = EasyLabel(self, translate.Get("scoreboard_remort_level"), "ZSScoreBoardPlayer", COLOR_GRAY)

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
	self.m_ZombieHeading:SetPos(self:GetWide() * 0.75 - self.m_ZombieHeading:GetWide() * 0.5, 110 * screenscale - self.m_HumanHeading:GetTall())

	self.m_PointsLabel:SizeToContents()
	self.m_RemortCLabel:SizeToContents()
	self.m_BrainsLabel:SizeToContents()
	self.m_RemortCZLabel:SizeToContents()

	local labelY = 110 * screenscale + 1 * screenscale
	local gap    = 10 * screenscale

	-- Layout inside ZSPlayerPanel (defined lower in this file):
	--   scoreLabel center            = panelW * 0.6
	--   classImage left edge         = panelW * 0.75 - panelTall / 2
	--   remortLabel right edge       = classImage left - 2
	-- We mirror those numbers here so the header label sits exactly above
	-- the value it describes, regardless of the translation length.
	local listPad  = 8 * screenscale
	local panelPad = 8
	local listOuterW = self:GetWide() / 2 - 24
	local panelW     = listOuterW - panelPad * 2
	local panelTall  = 32 * screenscale

	do
		local panelX = listPad + panelPad
		local scoreCenterX  = panelX + panelW * 0.6
		local remortCenterX = panelX + panelW * 0.75 - panelTall * 0.5 - 2

		local scoreW  = self.m_PointsLabel:GetWide()
		local remortW = self.m_RemortCLabel:GetWide()

		local scoreLeft  = scoreCenterX  - scoreW  / 2
		local remortLeft = remortCenterX - remortW / 2

		-- If the translations are so long that they start to overlap —
		-- center them as a single group while preserving the gap.
		if scoreLeft + scoreW + gap > remortLeft then
			local groupCenter = (scoreCenterX + remortCenterX) / 2
			local groupW = scoreW + gap + remortW
			scoreLeft  = groupCenter - groupW / 2
			remortLeft = scoreLeft + scoreW + gap
		end

		self.m_PointsLabel:SetPos(scoreLeft, labelY)
		self.m_RemortCLabel:SetPos(remortLeft, labelY)
	end

	do
		local listX = self:GetWide() - listPad - listOuterW
		local panelX = listX + panelPad
		local brainsCenterX = panelX + panelW * 0.6
		local remortCenterX = panelX + panelW * 0.75 - panelTall * 0.5 - 2

		local brainW  = self.m_BrainsLabel:GetWide()
		local remortW = self.m_RemortCZLabel:GetWide()

		local brainLeft  = brainsCenterX - brainW  / 2
		local remortLeft = remortCenterX - remortW / 2

		if brainLeft + brainW + gap > remortLeft then
			local groupCenter = (brainsCenterX + remortCenterX) / 2
			local groupW = brainW + gap + remortW
			brainLeft  = groupCenter - groupW / 2
			remortLeft = brainLeft + brainW + gap
		end

		self.m_BrainsLabel:SetPos(brainLeft, labelY)
		self.m_RemortCZLabel:SetPos(remortLeft, labelY)
	end

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

function PANEL:CreatePlayerPanel(pl)
	if pl:Team() == TEAM_SPECTATOR then return end

	-- PlayerPanels is keyed by player, so a direct lookup replaces
	-- the old O(n) scan.
	if not self.PlayerPanels then self.PlayerPanels = {} end
	if self.PlayerPanels[pl] then return end

	local parent = (pl:Team() == TEAM_UNDEAD) and self.ZombieList or self.HumanList
	local panel  = vgui.Create("ZSPlayerPanel", parent)
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

	local humans, zombies = {}, {}
	for _, pl in pairs(player.GetAllActive()) do
		local t = pl:Team()
		if t == TEAM_HUMAN then
			humans[#humans + 1] = pl
		elseif t == TEAM_UNDEAD then
			zombies[#zombies + 1] = pl
		end
	end

	local sig = #humans .. "h"
	for _, pl in ipairs(humans) do sig = sig .. ":" .. pl:EntIndex() end
	sig = sig .. "|" .. #zombies .. "z"
	for _, pl in ipairs(zombies) do sig = sig .. ":" .. pl:EntIndex() end

	if sig == self._LastRosterSig then return end
	self._LastRosterSig = sig

	for _, panel in pairs(self.PlayerPanels) do
		if panel:IsValid() then panel:Remove() end
	end
	self.PlayerPanels = {}

	local function sortfn(a, b)
		local sa, sb = a:Frags(), b:Frags()
		if sa ~= sb then return sa > sb end
		return a:EntIndex() < b:EntIndex()
	end
	table.sort(humans,  sortfn)
	table.sort(zombies, sortfn)

	for _, pl in ipairs(humans)  do self:CreatePlayerPanel(pl) end
	for _, pl in ipairs(zombies) do self:CreatePlayerPanel(pl) end
end

vgui.Register("ZSScoreBoard", PANEL, "Panel")

PANEL = {}

PANEL.RefreshTime = 1

PANEL.m_Player = NULL
PANEL.NextRefresh = 0

-- Every bot in GMod shares the same SteamID, and both the engine's
-- voice-mute list and GM.ZSFriends are keyed by SteamID. Using the
-- entity index for bots keeps the two controls per-bot.
local function GetPlayerKey(pl)
	if pl:IsBot() then
		return "bot_" .. pl:EntIndex()
	end
	return pl:SteamID()
end

local function MuteDoClick(self)
	local panel = self.PlayerPanel
	if not panel or not panel:IsValid() then return end

	local pl = panel:GetPlayer()
	if not pl:IsValid() then return end

	if pl:IsBot() then
		-- Engine mute is SteamID-keyed, so we can't use it for bots.
		pl.ZS_LocalMuted = not pl.ZS_LocalMuted
	else
		pl:SetMuted(not pl:IsMuted())
	end

	panel.NextRefresh = RealTime()
end

GM.ZSFriends = {}
--[[hook.Add("Initialize", "LoadZSFriends", function()
	if file.Exists(GAMEMODE.FriendsFile, "DATA") then
		GAMEMODE.ZSFriends = Deserialize(file.Read(GAMEMODE.FriendsFile)) or {}
	end
end)]]

local function ToggleZSFriend(self)
	if MySelf.LastFriendAdd and MySelf.LastFriendAdd + 2 > CurTime() then return end

	local panel = self.PlayerPanel
	if not panel or not panel:IsValid() then return end

	local pl = panel:GetPlayer()
	if not pl:IsValid() then return end

	local key = GetPlayerKey(pl)
	local newstate = not GAMEMODE.ZSFriends[key]
	GAMEMODE.ZSFriends[key] = newstate or nil

	panel.NextRefresh = RealTime()

	if not pl:IsBot() then
		net.Start("zs_zsfriend")
			net.WriteString(pl:SteamID())
			net.WriteBool(newstate)
		net.SendToServer()
	end

	MySelf.LastFriendAdd = CurTime()
end

net.Receive("zs_zsfriendadded", function()
	local pl = net:ReadEntity()
	pl.ZSFriendAdded = net:ReadBool()
end)

local function AvatarDoClick(self)
	local pl = self.PlayerPanel:GetPlayer()
	if pl:IsValidPlayer() and not pl:IsBot() then
		pl:ShowProfile()
	end
end

local function empty() end

function PANEL:Init()
	-- Button/DLabel normally sets "" as the initial text. We override
	-- Init without calling the base, so the engine's own default
	-- ("Label") survives and DButton:PaintOver draws it on the very
	-- first frames after a rebuild — visible as a brief "Label" flash
	-- in the middle of the row.
	self:SetText("")

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
	self.m_Mute.PlayerPanel = self

	self.m_Friend = vgui.Create("DImageButton", self)
	self.m_Friend.DoClick = ToggleZSFriend
	self.m_Friend.PlayerPanel = self
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

	local name = string.TruncateUTF8(pl:Name(), 23)
	if #name > 23 then
		name = string.sub(name, 1, 21)..".."
	end
	self.m_PlayerLabel:SetText(name)
	self.m_PlayerLabel:SetAlpha(240)

	self.m_ScoreLabel:SetText(GAMEMODE:FormatNumber(GAMEMODE:GetDisplayedScore(pl), nil, 1))
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

	-- Team checks and zombie class table: read once, use often.
	local plyTeam    = pl:Team()
	local showClass  = (MySelf:Team() == TEAM_UNDEAD and plyTeam == TEAM_UNDEAD)
	local classTbl   = showClass and pl:GetZombieClassTable() or nil

	if classTbl and classTbl.Icon then
		self.m_ClassImage:SetVisible(true)
		self.m_ClassImage:SetImage(classTbl.Icon)
		self.m_ClassImage:SetImageColor(classTbl.IconColor or color_white)
	else
		self.m_ClassImage:SetVisible(false)
	end

	if pl == MySelf then
		self.m_Mute:SetVisible(false)
		self.m_Friend:SetVisible(false)
	else
		local muted
		if pl:IsBot() then
			muted = pl.ZS_LocalMuted
		else
			muted = pl:IsMuted()
		end

		self.m_Mute:SetImage(muted and "icon16/sound_mute.png" or "icon16/sound.png")

		-- Two independent signals of friendship:
		--   * GAMEMODE.ZSFriends[key]  — we marked them as a friend.
		--   * pl.ZSFriendAdded         — server told us they marked us.
		-- Either direction counts; use one flag for both color and icon.
		local key = GetPlayerKey(pl)
		local isfriend = GAMEMODE.ZSFriends[key] or pl.ZSFriendAdded
		self.m_Friend:SetColor(isfriend and COLOR_LIMEGREEN or COLOR_GRAY)
		self.m_Friend:SetImage(isfriend and "icon16/heart_delete.png" or "icon16/heart.png")
	end

	-- Sort order is handled by the scoreboard refresh. RefreshPlayer
	-- only updates the label values, no layout pass is needed.
end

function PANEL:Think()
    local pl = self:GetPlayer()
    if not pl:IsValid() then
        self:Remove()
        return
    end

    -- Detect team change every frame. Instead of trying to move
    -- this panel (SetParent doesn't work cleanly between
    -- DScrollPanels), we destroy it and let the scoreboard rebuild
    -- recreate it in the right list on the next refresh.
    local team = pl:Team()
    if team ~= self._LastTeam then
        -- Ask the board to rebuild immediately, then remove
        -- ourselves. RefreshScoreboard will recreate us in the
        -- correct list, at the correct sort position.
        if ScoreBoard and ScoreBoard:IsValid() then
            ScoreBoard.NextRefresh = 0
        end
        self:Remove()
        return
    end

    if RealTime() >= self.NextRefresh then
        self.NextRefresh = RealTime() + self.RefreshTime
        self:RefreshPlayer()
    end
end

function PANEL:SetPlayer(pl)
	self.m_Player = pl or NULL
	self._LastTeam = pl:IsValid() and pl:Team() or nil

	if pl:IsValidPlayer() then
		self.m_Avatar:SetPlayer(pl)
		self.m_Avatar:SetVisible(true)

		if pl:IsBot() then
			self.m_AvatarButton:SetTooltip()
		else
			self.m_AvatarButton:SetTooltip(translate.Get("tooltip_view_steam_profile"))
		end

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
