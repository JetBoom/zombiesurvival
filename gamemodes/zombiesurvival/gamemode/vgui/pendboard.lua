function GM:AddHonorableMention(pl, mentionid, ...)
	if not (pEndBoard and pEndBoard:IsValid()) then
		MakepEndBoard(ROUNDWINNER)
	end

	local mentiontab = self.HonorableMentions[mentionid]
	if not mentiontab then return end

	local pan = vgui.Create("DEndBoardPlayerPanel", pEndBoard.List)
	pan:SetPlayer(pl, mentiontab.Color, string.format(mentiontab.String, mentiontab.Callback(pl, ...)), nil, mentiontab.Name)
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
	frame:SetAlpha(0)
	frame:AlphaTo(255, 2.25, 0)
	pEndBoard = frame

	local y = 8

	local heading
	if localwin then
		surface.PlaySound("beams/beamstart5.wav")
		heading = EasyLabel(frame, "You have won!", "ZSHUDFontBig", COLOR_CYAN)
	elseif winner == TEAM_HUMAN or winner == TEAM_UNDEAD then
		surface.PlaySound("ambient/levels/citadel/strange_talk"..math.random(3, 11)..".wav")
		heading = EasyLabel(frame, "You have lost.", "ZSHUDFontBig", COLOR_RED)
	else
		surface.PlaySound("ambient/levels/citadel/strange_talk"..math.random(3, 11)..".wav")
		heading = EasyLabel(frame, "Round ended with a draw...", "ZSHUDFont", COLOR_GRAY)
	end
	heading:SetPos(wid * 0.5 - heading:GetWide() * 0.5, y)
	y = y + heading:GetTall() + 16

	local subheading
	if winner == TEAM_HUMAN then
		if GAMEMODE.ZombieEscape then
			subheading = EasyLabel(frame, "The humans have won!", "ZSHUDFontSmaller", COLOR_CYAN)
		else
			if MySelf:Team() == TEAM_HUMAN then
				subheading = EasyLabel(frame, "The humans have survived for now.", "ZSHUDFontSmaller", COLOR_WHITE)
			else
				subheading = EasyLabel(frame, "The humans have survived!", "ZSHUDFontSmaller", COLOR_MIDGRAY)
			end
		end
	elseif winner == TEAM_UNDEAD then
		subheading = EasyLabel(frame, GAMEMODE.ZombieEscape and "Zombies have won." or Format("The undead army grows stronger.\nHumans survived on wave %d.", GAMEMODE:GetWave()), "ZSHUDFontSmaller", COLOR_LIMEGREEN)
	else
		subheading = EasyLabel(frame, "Everyone has lost.", "ZSHUDFontSmaller", COLOR_RORANGE)
	end
	subheading:SetPos(wid * 0.5 - subheading:GetWide() * 0.5, y)
	y = y + subheading:GetTall() + 2

	local svpan = EasyLabel(frame, "Honorable Mentions", "ZSHUDFontSmall", COLOR_WHITE)
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
		local name = overridename or pl:Name()

		local avatar = vgui.Create("AvatarImage", self)
		avatar:SetPos(2, 2)
		avatar:SetSize(32, 32)
		avatar:SetPlayer(pl)
		avatar:SetTooltip("Click here to view their Steam Community profile.")
		self.m_pAvatar = avatar

		local namelab = EasyLabel(self, name, "ZSHUDFontTiny", col)
		namelab:SetPos(40, -2)
		self.m_pName = namelab

		if misc then
			local misclab = EasyLabel(self, misc, nil, misccol)
			misclab:SetPos(58, self:GetTall() - 1 - misclab:GetTall())
		end
	end
end
vgui.Register("DEndBoardPlayerPanel", PANEL, "DPanel")
