GM.Help = {
{Name = "help_cat_introduction",
Content = "help_cont_introduction"},

{Name = "help_cat_survival",
Content = "help_cont_survival"},

{Name = "help_cat_barricading",
Content = "help_cont_barricading"},

{Name = "help_cat_upgrades",
Content = "help_cont_upgrades"},

{Name = "help_cat_being_a_zombie",
Content = "help_cont_being_a_zombie"}
}

function MakepCredits()
	PlayMenuOpenSound()

	local wid = math.min(ScrW(), 750)

	local y = 8

	local frame = vgui.Create("DEXRoundedFrame")
	frame:SetColorAlpha(230)
	frame:SetWide(wid)
	frame:SetTitle(" ")
	frame:SetKeyboardInputEnabled(false)

	local label = EasyLabel(frame, GAMEMODE.Name.." Credits", "ZSHUDFontNS", color_white)
	label:AlignTop(y)
	label:CenterHorizontal()
	y = y + label:GetTall() + 8

	for authorindex, authortab in ipairs(GAMEMODE.Credits) do
		local lineleft = EasyLabel(frame, string.Replace(authortab[1], "@", "(at)"), "ZSHUDFontSmallestNS", color_white)
		local linemid = EasyLabel(frame, "-", "ZSHUDFontSmallestNS", color_white)
		local lineright = EasyLabel(frame, authortab[3], "ZSHUDFontSmallestNS", color_white)
		local linesub
		if authortab[2] then
			linesub = EasyLabel(frame, authortab[2], "DefaultFont", color_white)
		end

		lineleft:AlignLeft(8)
		lineleft:AlignTop(y)
		lineright:AlignRight(8)
		lineright:AlignTop(y)
		linemid:CenterHorizontal()
		linemid:AlignTop(y)

		y = y + lineleft:GetTall()
		if linesub then
			linesub:AlignTop(y)
			linesub:AlignLeft(8)
			y = y + linesub:GetTall()
		end
		y = y + 10
	end

	frame:SetTall(y + 8)
	frame:Center()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.15, 0)
	frame:MakePopup()
end

function MakepHelp()
	PlayMenuOpenSound()

	if pHelp then
		pHelp:SetAlpha(0)
		pHelp:AlphaTo(255, 0.15, 0)
		pHelp:SetVisible(true)
		pHelp:MakePopup()
		return
	end

	local wide, tall = 500, 480

	local Window = vgui.Create("DFrame")
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle(" ")
	Window:SetDraggable(false)
	Window:SetDeleteOnClose(false)
	Window:SetKeyboardInputEnabled(false)
	Window:SetCursor("pointer")
	pHelp = Window

	local label = EasyLabel(Window, "Help", "ZSHUDFont", color_white)
	label:CenterHorizontal()
	label:AlignTop(8)

	local propertysheet = vgui.Create("DPropertySheet", Window)
	propertysheet:StretchToParent(12, 52, 12, 64)

	for _, helptab in ipairs(GAMEMODE.Help) do
		local htmlpanel = vgui.Create("DHTML", propertysheet)
		htmlpanel:StretchToParent(4, 4, 4, 24)
		htmlpanel:SetHTML([[<html>
		<head>
		<style type="text/css">
		body
		{
			font-family:tahoma;
			font-size:11px;
			color:white;
			background-color:black;
			width:]].. htmlpanel:GetWide() - 48 ..[[px;
		}
		div p
		{
			margin:10px;
			padding:2px;
		}
		</style>
		</head>
		<body>
<center><span style="font-size:22px;font-weight:bold;color:limegreen;text-decoration:underline;">Zombie Survival</span><br>
]]..translate.Get(helptab.Name)..[[</center><br><br><div>]]..translate.Get(helptab.Content)..[[</div>
</body>
</html>]])
		propertysheet:AddSheet(translate.Get(helptab.Name), htmlpanel, helptab.Icon, false, false)
	end

	Window:Center()
	Window:MakePopup()

	local button = EasyButton(Window, "Credits", 8, 4)
	button:SetPos(wide - button:GetWide() - 12, tall - button:GetTall() - 12)
	button:SetText("Credits")
	button.DoClick = function(btn) MakepCredits() end

	gamemode.Call("BuildHelpMenu", Window, propertysheet)

	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.15, 0)
	Window:MakePopup()
end

function GM:BuildHelpMenu(window, propertysheet)
end
