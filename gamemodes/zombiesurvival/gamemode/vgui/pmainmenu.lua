local function HelpMenuPaint(self)
	Derma_DrawBackgroundBlur(self, self.Created)
	Derma_DrawBackgroundBlur(self, self.Created)
end

local pPlayerModel
local function SwitchPlayerModel(self)
	surface.PlaySound("buttons/button14.wav")
	RunConsoleCommand("cl_playermodel", self.m_ModelName)
	chat.AddText(COLOR_LIMEGREEN, "You've changed your desired player model to "..tostring(self.m_ModelName))

	pPlayerModel:Close()
end
function MakepPlayerModel()
	if pPlayerModel and pPlayerModel:Valid() then pPlayerModel:Remove() end

	PlayMenuOpenSound()

	local numcols = 8
	local wid = numcols * 68 + 24
	local hei = 400

	pPlayerModel = vgui.Create("DFrame")
	pPlayerModel:SetSkin("Default")
	pPlayerModel:SetTitle("Player model selection")
	pPlayerModel:SetSize(wid, hei)
	pPlayerModel:Center()
	pPlayerModel:SetDeleteOnClose(true)

	local list = vgui.Create("DPanelList", pPlayerModel)
	list:StretchToParent(8, 24, 8, 8)
	list:EnableVerticalScrollbar()

	local grid = vgui.Create("DGrid", pPlayerModel)
	grid:SetCols(numcols)
	grid:SetColWide(68)
	grid:SetRowHeight(68)
	
	for name, mdl in pairs(player_manager.AllValidModels()) do
		local button = vgui.Create("SpawnIcon", grid)
		button:SetPos(0, 0)
		button:SetModel(mdl)
		button.m_ModelName = name
		button.OnMousePressed = SwitchPlayerModel
		grid:AddItem(button)
	end
	grid:SetSize(wid - 16, math.ceil(table.Count(player_manager.AllValidModels()) / numcols) * grid:GetRowHeight())

	list:AddItem(grid)

	pPlayerModel:SetSkin("Default")
	pPlayerModel:MakePopup()
end

function MakepPlayerColor()
	if pPlayerColor and pPlayerColor:Valid() then pPlayerColor:Remove() end

	PlayMenuOpenSound()

	pPlayerColor = vgui.Create("DFrame")
	pPlayerColor:SetWide(math.min(ScrW(), 500))
	pPlayerColor:SetTitle(" ")
	pPlayerColor:SetDeleteOnClose(true)

	local y = 8

	local label = EasyLabel(pPlayerColor, "Colors", "ZSHUDFont", color_white)
	label:SetPos((pPlayerColor:GetWide() - label:GetWide()) / 2, y)
	y = y + label:GetTall() + 8

	local lab = EasyLabel(pPlayerColor, "Player color")
	lab:SetPos(8, y)
	y = y + lab:GetTall()

	local colpicker = vgui.Create("DColorMixer", pPlayerColor)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker.UpdateConVars = function(me, color)
		me.NextConVarCheck = SysTime() + 0.2
		RunConsoleCommand("cl_playercolor", color.r / 100 .." ".. color.g / 100 .." ".. color.b / 100)
	end
	local r, g, b = string.match(GetConVarString("cl_playercolor"), "(%g+) (%g+) (%g+)")
	if r then
		colpicker:SetColor(Color(r * 100, g * 100, b * 100))
	end
	colpicker:SetSize(pPlayerColor:GetWide() - 16, 72)
	colpicker:SetPos(8, y)
	y = y + colpicker:GetTall()

	local lab = EasyLabel(pPlayerColor, "Weapon color")
	lab:SetPos(8, y)
	y = y + lab:GetTall()

	local colpicker = vgui.Create("DColorMixer", pPlayerColor)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker.UpdateConVars = function(me, color)
		me.NextConVarCheck = SysTime() + 0.2
		RunConsoleCommand("cl_weaponcolor", color.r / 100 .." ".. color.g / 100 .." ".. color.b / 100)
	end
	local r, g, b = string.match(GetConVarString("cl_weaponcolor"), "(%g+) (%g+) (%g+)")
	if r then
		colpicker:SetColor(Color(r * 100, g * 100, b * 100))
	end
	colpicker:SetSize(pPlayerColor:GetWide() - 16, 72)
	colpicker:SetPos(8, y)
	y = y + colpicker:GetTall()

	pPlayerColor:SetTall(y + 8)
	pPlayerColor:Center()
	pPlayerColor:MakePopup()
end

function GM:ShowHelp()
	if self.HelpMenu and self.HelpMenu:Valid() then
		self.HelpMenu:Remove()
	end

	PlayMenuOpenSound()

	local menu = vgui.Create("Panel")
	menu:SetSize(BetterScreenScale() * 420, ScrH())
	menu:Center()
	menu.Paint = HelpMenuPaint
	menu.Created = SysTime()

	local header = EasyLabel(menu, self.Name, "ZSHUDFont")
	header:SetContentAlignment(8)
	header:DockMargin(0, ScrH() * 0.25, 0, 64)
	header:Dock(TOP)

	local but = vgui.Create("DButton", menu)
	but:SetFont("ZSHUDFontSmaller")
	but:SetText("Help")
	but:SetTall(32)
	but:DockMargin(0, 0, 0, 12)
	but:DockPadding(0, 12, 0, 12)
	but:Dock(TOP)
	but.DoClick = function() MakepHelp() end

	local but = vgui.Create("DButton", menu)
	but:SetFont("ZSHUDFontSmaller")
	but:SetText("Player Model")
	but:SetTall(32)
	but:DockMargin(0, 0, 0, 12)
	but:DockPadding(0, 12, 0, 12)
	but:Dock(TOP)
	but.DoClick = function() MakepPlayerModel() end

	local but = vgui.Create("DButton", menu)
	but:SetFont("ZSHUDFontSmaller")
	but:SetText("Player Color")
	but:SetTall(32)
	but:DockMargin(0, 0, 0, 12)
	but:DockPadding(0, 12, 0, 12)
	but:Dock(TOP)
	but.DoClick = function() MakepPlayerColor() end

	local but = vgui.Create("DButton", menu)
	but:SetFont("ZSHUDFontSmaller")
	but:SetText("Options")
	but:SetTall(32)
	but:DockMargin(0, 0, 0, 12)
	but:DockPadding(0, 12, 0, 12)
	but:Dock(TOP)
	but.DoClick = function() MakepOptions() end

	local but = vgui.Create("DButton", menu)
	but:SetFont("ZSHUDFontSmaller")
	but:SetText("Credits")
	but:SetTall(32)
	but:DockMargin(0, 0, 0, 12)
	but:DockPadding(0, 12, 0, 12)
	but:Dock(TOP)
	but.DoClick = function() MakepCredits() end

	local but = vgui.Create("DButton", menu)
	but:SetFont("ZSHUDFontSmaller")
	but:SetText("Close")
	but:SetTall(32)
	but:DockMargin(0, 24, 0, 0)
	but:DockPadding(0, 12, 0, 12)
	but:Dock(TOP)
	but.DoClick = function() menu:Remove() end

	menu:MakePopup()
end
