--local MainMenu
GM.REVISION = 4352

function GM:OpenMainMenu()
	if MainMenu and MainMenu:Valid() then
		MainMenu:MakePopup()
		return
	end

	MainMenu = vgui.Create("DEXRoundedPanel")
	MainMenu:SetCurve(false)
	MainMenu:SetColor(color_black_alpha220)
	MainMenu:Dock(FILL)
	MainMenu:DockPadding(0, 0, 0, 0)
	MainMenu:DockMargin(0, 0, 0, 0)

	local creditbar = vgui.Create("DEXRoundedPanel", MainMenu)
	creditbar:SetCurve(false)
	creditbar:SetColor(color_black_alpha220)
	creditbar:SetTall(40)
	creditbar:Dock(BOTTOM)
	creditbar:DockPadding(0, 8, 8, 8)

	local credittext = vgui.Create("DLabel", creditbar)
	credittext:SetFont("ZSScoreBoardSubTitle")
	credittext:SetTextColor(COLOR_LIGHTGRAY)
	credittext:SetText("Zombie Survival (r"..self.REVISION..") - created by William \"JetBoom\" Moodhe")
	credittext:SetContentAlignment(6)
	credittext:Dock(FILL)

	-- Tooltip section...

	button = vgui.Create("ZSMenuButton", MainMenu)
	button:SetText("종료")
	button:SizeToContents()
	button:Dock(BOTTOM)
	button:DockMargin(90, 8, 0, 220)
	button.Tooltip = "mainmenu_tooltip_quit"

	button = vgui.Create("ZSMenuButton", MainMenu)
	button:SetText("서포터 되기")
	button:SizeToContents()
	button:Dock(BOTTOM)
	button:DockMargin(80, 8, 0, 0)
	button.Tooltip = "mainmenu_tooltip_supporter"

	button = vgui.Create("ZSMenuButton", MainMenu)
	button:SetText("제작자")
	button:SizeToContents()
	button:Dock(BOTTOM)
	button:DockMargin(70, 8, 0, 0)
	button.Tooltip = "mainmenu_tooltip_credits"

	button = vgui.Create("ZSMenuButton", MainMenu)
	button:SetText("가이드")
	button:SizeToContents()
	button:Dock(BOTTOM)
	button:DockMargin(60, 8, 0, 0)
	button.Tooltip = "mainmenu_tooltip_guides"

	button = vgui.Create("ZSMenuButton", MainMenu)
	button:SetText("도움말")
	button:SizeToContents()
	button:Dock(BOTTOM)
	button:DockMargin(50, 8, 0, 0)
	button.Tooltip = "mainmenu_tooltip_help"

	button = vgui.Create("ZSMenuButton", MainMenu)
	button:SetText("관전")
	button:SizeToContents()
	button:Dock(BOTTOM)
	button:DockMargin(40, 8, 0, 0)
	button.Tooltip = "mainmenu_tooltip_spectate"

	local button = vgui.Create("ZSMenuButton", MainMenu)
	button:SetText("플레이")
	button:SizeToContents()
	button:Dock(BOTTOM)
	button:DockMargin(30, 8, 0, 0)
	button.Tooltip = "mainmenu_tooltip_play"

	MainMenu:MakePopup()
end

local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment(4)
	self:SetFont("ZSHUDFontSmall")
end

function PANEL:Paint()
end

vgui.Register("ZSMenuButton", PANEL, "Button")
