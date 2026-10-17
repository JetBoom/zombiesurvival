function GM:AddHonorableMention(pl, mentionid, ...)
	if not (pEndBoard and pEndBoard:IsValid()) then
		MakepEndBoard(ROUNDWINNER)
	end

	local mentiontab = self.HonorableMentions[mentionid]
	if not mentiontab then return end

	local args = {mentiontab.Callback(pl, ...)}

	local title = translate.Get(mentiontab.Name)
	local desc = translate.Format(mentiontab.String, unpack(args))

	local pan = vgui.Create("DEndBoardPlayerPanel", pEndBoard.List)
	pan:SetPlayer(pl, mentiontab.Color, desc, nil, title)
	pEndBoard.List:AddItem(pan)
end

function MakepEndBoard(winner)
	if pEndBoard and pEndBoard:IsValid() then
		pEndBoard:Remove()
		pEndBoard = nil
	end

	local localwin = winner == TEAM_HUMAN and MySelf:IsValid() and MySelf:Team() == winner

	local screenscale = BetterScreenScale()
	local wid = math.min(ScrW(), 650) * screenscale

	local frame = vgui.Create("DFrame")
	frame:SetWide(wid)
	frame:SetKeyboardInputEnabled(false)
	frame:SetDeleteOnClose(false)
	frame:SetCursor("pointer")
	frame:SetTitle(" ")
	pEndBoard = frame

	local y = 8

	local heading
	if localwin then
		surface.PlaySound("beams/beamstart5.wav")
		heading = EasyLabel(frame, translate.Get("endboard_you_won"), "ZSHUDFontBig", COLOR_CYAN)
	else
		surface.PlaySound("ambient/levels/citadel/strange_talk"..math.random(3, 11)..".wav")
		heading = EasyLabel(frame, translate.Get("endboard_you_lost"), "ZSHUDFontBig", COLOR_RED)
	end
	heading:SetPos(wid * 0.5 - heading:GetWide() * 0.5, y)
	y = y + heading:GetTall() + 16

	local subheading
	if localwin then
		subheading = EasyLabel(frame, translate.Get("endboard_humans_survived"), "ZSHUDFontSmaller", COLOR_WHITE)
	else
		subheading = EasyLabel(frame, translate.Get("endboard_undead_stronger"), "ZSHUDFontSmaller", COLOR_LIMEGREEN)
	end
	subheading:SetPos(wid * 0.5 - subheading:GetWide() * 0.5, y)
	y = y + subheading:GetTall() + 2

	local svpan = EasyLabel(frame, translate.Get("endboard_mentions"), "ZSHUDFontSmall", COLOR_WHITE)
	svpan:SetPos(wid * 0.5 - svpan:GetWide() * 0.5, y)
	y = y + svpan:GetTall() + 2

	local list = vgui.Create("DPanelList", frame)
	list:SetSize(wid - 16, 600 * screenscale)
	list:SetPos(8, y)
	list:SetPadding(2)
	list:SetSpacing(2)
	list:EnableVerticalScrollbar()
	y = y + list:GetTall() + 8

	frame.List = list

	frame:SetTall(y)
	frame:Center()

	frame:MakePopup()

	return frame
end

local PANEL = {}
function PANEL:OnMousePressed(mc)
	if mc == MOUSE_LEFT then
		local pl = self:GetPlayer()
		if pl:IsValid() then
			gamemode.Call("ClickedEndBoardPlayerButton", pl, self)
		end
	end
end

function PANEL:Init()
	local screenscale = math.max(1, BetterScreenScale())
	self:SetSize(200 * screenscale, 38 * screenscale)
end

function PANEL:GetPlayer()
	return self.m_Player or NULL
end

function PANEL:SetPlayer(pl, col, misc, misccol, overridename)
	if self.m_pAvatar then
		self.m_pAvatar:Remove()
		self.m_pAvatar = nil
	end
	if self.m_pName then
		self.m_pName:Remove()
		self.m_pName = nil
	end
	if self.m_pMisc then
		self.m_pMisc:Remove()
		self.m_pMisc = nil
	end

	if pl:IsValidPlayer() then
		local name = string.TruncateUTF8(overridename or pl:Name(), 23)

		local avatarButton = vgui.Create("DButton", self)
		avatarButton:SetText("")
		avatarButton:SetPos(2, 2)
		avatarButton:SetSize(32, 32)
		avatarButton.Paint = function() end

		if not pl:IsBot() then
			avatarButton:SetTooltip(translate.Get("tooltip_view_steam_profile"))
			avatarButton.DoClick = function()
				if pl:IsValidPlayer() then
					pl:ShowProfile()
				end
			end
		end

		local avatar = vgui.Create("AvatarImage", avatarButton)
		avatar:SetPos(0, 0)
		avatar:SetSize(32, 32)
		avatar:SetPlayer(pl)
		avatar:SetMouseInputEnabled(false)

		self.m_pAvatar = avatarButton

		local namelab = EasyLabel(self, name, ZS_TinyFontWithOutline(), col)
		namelab:SetPos(40, -2)
		self.m_pName = namelab

		if misc then
			local misclab = EasyLabel(self, misc, nil, misccol)
			misclab:SetPos(58, self:GetTall() - 1 - misclab:GetTall())
		end
	end
end
vgui.Register("DEndBoardPlayerPanel", PANEL, "DPanel")
