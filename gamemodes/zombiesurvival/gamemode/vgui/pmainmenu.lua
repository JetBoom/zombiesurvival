local function HelpMenuPaint(self)
	Derma_DrawBackgroundBlur(self, self.Created)
	Derma_DrawBackgroundBlur(self, self.Created)
end

local pPlayerModel

local function ZS_ResolvePhrase(key)
	if not key then return nil end
	if string.sub(key, 1, 1) == "#" then
		local s = language.GetPhrase(key)
		if s == key then return string.sub(key, 2) end
		return s
	end
	return key
end

local function ZS_PlayerModelDisplayName(name)
	local info = player_manager.GetAllPlayerModels()[name]
	if not info then return tostring(name) end

	if info.title then
		return ZS_ResolvePhrase(info.title)
	end

	local file = string.match(info.model or "", "([^/]+)%.mdl$")
	if file then
		file = string.gsub(file, "_", " ")
		file = string.gsub(file, "(%a)([%w']*)", function(a, b) return a:upper() .. b end)
		return file
	end

	return tostring(name)
end

function MakepPlayerModel()
	if pPlayerModel and pPlayerModel:IsValid() then pPlayerModel:Remove() end

	PlayMenuOpenSound()
	HideOtherSubmenus(nil)

	local screenscale = BetterScreenScale()

	local wid = math.max(680, math.min(ScrW() * 0.85, 980 * screenscale))
	local hei = math.max(440, math.min(ScrH() * 0.85, 640 * screenscale))

	pPlayerModel = vgui.Create("DFrame")
	pPlayerModel:SetSkin("Default")
	pPlayerModel:SetTitle(translate.Get("pmodel_window_title"))
	pPlayerModel:SetSize(wid, hei)
	pPlayerModel:Center()
	pPlayerModel:SetDeleteOnClose(true)
	pPlayerModel.MainMenuSubmenu = true

	local divider = vgui.Create("DHorizontalDivider", pPlayerModel)
	divider:Dock(FILL)
	divider:DockMargin(6, 26, 6, 6)
	divider:SetLeftWidth(math.max(240, wid * 0.4))
	divider:SetLeftMin(240)
	divider:SetRightMin(280)
	divider:SetDividerWidth(6)

	local leftPnl = vgui.Create("DPanel", divider)
	leftPnl.Paint = function() end
	divider:SetLeft(leftPnl)

	local nameLabel = vgui.Create("DLabel", leftPnl)
	nameLabel:Dock(TOP)
	nameLabel:DockMargin(6, 4, 6, 4)
	nameLabel:SetFont("ZSHUDFontSmaller")
	nameLabel:SetTextColor(COLOR_WHITE)
	nameLabel:SetText(translate.Get("pmodel_select_hint"))

	nameLabel:SetTall(draw.GetFontHeight("ZSHUDFontSmaller") + 10 * screenscale)
	nameLabel:SetContentAlignment(7)

	local mdl = vgui.Create("DModelPanel", leftPnl)
	mdl:Dock(FILL)
	mdl:DockMargin(6, 4, 6, 4)
	mdl.Angles = Angle(0, 0, 0)
	mdl:SetDirectionalLight(BOX_FRONT, nil)
	mdl:SetDirectionalLight(BOX_TOP, nil)
	mdl:SetAmbientLight(Color(60, 60, 60))
	mdl:SetFOV(47)
	mdl:SetAnimated(true)
	mdl.StoredFOV = 47

	function mdl:DragMousePress(btnId)
		if btnId ~= MOUSE_LEFT then return end
		self.PressX, self.PressY = input.GetCursorPos()
		self.Pressed = btnId
	end
	function mdl:DragMouseRelease() self.Pressed = nil end
	function mdl:LayoutEntity(ent)
		if self.bAnimated then self:RunAnimation() end
		if self.Pressed then
			local mx = input.GetCursorPos()
			self.Angles = self.Angles - Angle(0, ((self.PressX or mx) - mx) / 2, 0)
			self.PressX = mx
		end
		ent:SetAngles(self.Angles)
		self:SetFOV(self.StoredFOV * math.min(self:GetWide() / math.max(self:GetTall(), 1), 2.5))
	end

	local sheet = vgui.Create("DPropertySheet", divider)
	sheet.Paint = function() end
	divider:SetRight(sheet)

	local state = {
		model = nil,
		bodygroups = "0",
		skin = 0,
	}

	local bgTab = vgui.Create("DPanel", sheet)
	bgTab.Paint = function() end

	local bgScroll = vgui.Create("DScrollPanel", bgTab)
	bgScroll:Dock(FILL)
	bgScroll:DockMargin(4, 4, 4, 4)
	
	local modelsSheet, bgSheet

	local function RebuildBodygroupTab()
		bgScroll:Clear()

		if not (mdl and IsValid(mdl) and mdl.Entity and mdl.Entity:IsValid()) then
			return
		end

		local ent = mdl.Entity
		local hasAny = false

		local nskins = ent:SkinCount() - 1
		if nskins > 0 then
			hasAny = true

			local slider = vgui.Create("DNumSlider")
			slider:Dock(TOP)
			slider:SetTall(48)
			slider:SetText("#skin")
			slider:SetDecimals(0)
			slider:SetMin(0)
			slider:SetMax(nskins)
			slider:SetValue(tonumber(state.skin) or 0)
			slider.OnValueChanged = function(me, val)
				val = math.floor(val)
				state.skin = val
				if mdl.Entity and mdl.Entity:IsValid() then
					mdl.Entity:SetSkin(val)
				end
			end
			bgScroll:AddItem(slider)

			ent:SetSkin(tonumber(state.skin) or 0)
		end

		local groups = string.Explode(" ", tostring(state.bodygroups or "0"))
		for k = 0, ent:GetNumBodyGroups() - 1 do
			if ent:GetBodygroupCount(k) <= 1 then continue end
			hasAny = true

			local val = tonumber(groups[k + 1]) or 0

			local slider = vgui.Create("DNumSlider")
			slider:Dock(TOP)
			slider:SetTall(48)
			slider:SetText(string.NiceName(ent:GetBodygroupName(k)))
			slider:SetDecimals(0)
			slider:SetMin(0)
			slider:SetMax(ent:GetBodygroupCount(k) - 1)
			slider:SetValue(val)
			slider.OnValueChanged = function(me, val2)
				val2 = math.floor(val2)
				groups[k + 1] = tostring(val2)
				state.bodygroups = table.concat(groups, " ")
				if mdl.Entity and mdl.Entity:IsValid() then
					mdl.Entity:SetBodygroup(k, val2)
				end
			end
			bgScroll:AddItem(slider)

			ent:SetBodygroup(k, val)
		end

		if not hasAny then
			local lbl = EasyLabel(nil, translate.Get("pmodel_no_bodygroups"), "ZSHUDFontSmaller", COLOR_GRAY)
			lbl:SetContentAlignment(5)
			lbl:Dock(TOP)
			lbl:DockMargin(4, 12, 4, 4)
			bgScroll:AddItem(lbl)
		end

		if bgSheet then
			if hasAny ~= bgSheet.Tab:IsVisible() then
				bgSheet.Tab:SetVisible(hasAny)

				if sheet.tabScroller then
					sheet.tabScroller:InvalidateLayout(true)
					sheet.tabScroller:SizeToContents()
				end
				sheet:InvalidateLayout(true)
			end

			if not hasAny and sheet.ActiveTab == bgSheet.Tab then
				sheet:SetActiveTab(modelsSheet.Tab)
			end
		end
	end

	local modelsTab = vgui.Create("DPanel", sheet)
	modelsTab.Paint = function() end

	local SearchBar = vgui.Create("DTextEntry", modelsTab)
	SearchBar:Dock(TOP)
	SearchBar:DockMargin(4, 4, 4, 4)
	SearchBar:SetUpdateOnType(true)
	SearchBar:SetPlaceholderText("#spawnmenu.quick_filter")

	local list = vgui.Create("DPanelList", modelsTab)
	list:Dock(FILL)
	list:DockMargin(4, 0, 4, 4)
	list:EnableVerticalScrollbar()
	list:SetSpacing(4)
	list:SetPadding(4)

	modelsSheet = sheet:AddSheet("#smwidget.model", modelsTab, "icon16/user.png")
	bgSheet     = sheet:AddSheet("#smwidget.bodygroups", bgTab, "icon16/cog.png")
	bgSheet.Tab:SetVisible(false)

	local function SelectModel(name, modelPath)
		state.model = name
		state.bodygroups = "0"
		state.skin = 0

		surface.PlaySound("buttons/button17.wav")

		mdl:SetModel(modelPath)

		if mdl.Entity and mdl.Entity:IsValid() then
			local mins, maxs = mdl.Entity:GetRenderBounds()
			local height = maxs.z - mins.z
			if height <= 0 then height = 72 end

			mdl:SetLookAt(Vector(0, 0, mins.z + height * 0.55))
			mdl:SetCamPos(Vector(height * 1.25, 0, mins.z + height * 0.80))
		end

		nameLabel:SetText(ZS_PlayerModelDisplayName(name))

		RebuildBodygroupTab()
	end

	local function ResolvePhrase(key)
		if not key then return nil end
		if string.sub(key, 1, 1) == "#" then
			local s = language.GetPhrase(key)
			if s == key then return string.sub(key, 2) end
			return s
		end
		return key
	end

	local folderToCategoryKey = {
		["group01"]    = "#spawnmenu.category.hl2citizens",
		["group02"]    = "#spawnmenu.category.hl2citizens",
		["group03"]    = "#spawnmenu.category.hl2citizens",
		["group03m"]   = "#spawnmenu.category.hl2citizens",
		["group04"]    = "#spawnmenu.category.hl2citizens",
		["police"]     = "#spawnmenu.category.hl2",
		["combine"]    = "#spawnmenu.category.hl2",
		["characters"] = "#spawnmenu.category.hl2",
		["humans"]     = "#spawnmenu.category.hl2",
	}

	local function FallbackCategory(modelPath)
		local folder = string.lower(string.match(modelPath or "", "models/player/([^/]+)/") or "")
		if string.find(folder, "css", 1, true) then
			return ResolvePhrase("#spawnmenu.category.counterstrike")
		end
		return ResolvePhrase(folderToCategoryKey[folder] or "#spawnmenu.category.other")
	end

	local function FallbackTitle(modelPath, name)
		local file = string.match(modelPath or "", "([^/]+)%.mdl$")
		if not file then return name end
		file = string.gsub(file, "_", " ")
		file = string.gsub(file, "(%a)([%w']*)", function(a, b) return a:upper() .. b end)
		return file
	end

	-- Build a lowercase set of restricted models once, then reuse it.
	local restrictedSet = {}
	if GAMEMODE and GAMEMODE.RestrictedModels then
		for _, mdl in ipairs(GAMEMODE.RestrictedModels) do
			restrictedSet[string.lower(mdl)] = true
		end
	end

	local categorized = {}
	for name, info in pairs(player_manager.GetAllPlayerModels()) do
		-- Skip models that look like undead / are otherwise banned.
		if not restrictedSet[string.lower(info.model or "")] then
			local catName = info.category and ResolvePhrase(info.category) or FallbackCategory(info.model)
			local title   = info.title    and ResolvePhrase(info.title)    or FallbackTitle(info.model, name)

			categorized[catName] = categorized[catName] or {}
			table.insert(categorized[catName], {title = title, model = info.model, name  = name,})
		end
	end

	local numcols  = 6
	local iconSize = 68

	local listItems = {} -- for the filter

	for catName, items in SortedPairs(categorized) do
		local header = EasyLabel(nil, catName, "ZSHUDFontSmall", COLOR_WHITE)
		header:SetTall(28)
		header:SetContentAlignment(4)
		header:SetMouseInputEnabled(false)
		list:AddItem(header)

		local grid = vgui.Create("DGrid")
		grid:SetCols(numcols)
		grid:SetColWide(iconSize)
		grid:SetRowHeight(iconSize)

		grid.PerformLayout = function(me)
			me:SetWide(me:GetParent():GetWide() - 8)
			DGrid.PerformLayout(me)
		end

		local iconsInGrid = {}

		for _, info in SortedPairsByMemberValue(items, "title") do
			local button = vgui.Create("SpawnIcon", grid)
			button:SetPos(0, 0)
			button:SetModel(info.model)
			button:SetTooltip(info.title)
			button.playermodel = info.name
			button.model_path  = info.model

			button.OnMousePressed = function(me, mc)
				if mc == MOUSE_LEFT then
					SelectModel(info.name, info.model)
				elseif mc == MOUSE_RIGHT and me.OpenMenu then
					me:OpenMenu()
				end
			end

			button.OpenMenu = function()
				local menu = DermaMenu()

				local optText = language.GetPhrase("#spawnmenu.menu.copy")
				if not optText or optText == "" or optText == "#spawnmenu.menu.copy" then
					optText = translate.Get("pmodel_copy_path")
				end

				local opt = menu:AddOption(optText, function()
					SetClipboardText(info.model)
				end)
				opt:SetIcon("icon16/page_copy.png")
				opt:SetTextColor(color_black)

				menu:Open()
			end

			grid:AddItem(button)
			iconsInGrid[#iconsInGrid + 1] = button
		end

		grid:SetTall(math.ceil(#items / numcols) * iconSize)
		list:AddItem(grid)

		listItems[#listItems + 1] = {
			header = header,
			grid = grid,
			icons = iconsInGrid,
		}
	end

	SearchBar.OnValueChange = function(me, str)
		str = string.lower(str)
		for _, entry in ipairs(listItems) do
			local anyVisible = false
			for _, icon in ipairs(entry.icons) do
				local pm  = string.lower(icon.playermodel or "")
				local mp  = string.lower(icon.model_path or "")
				local tip = string.lower(icon:GetTooltip() or "")
				local match = str == ""
					or pm:find(str, 1, true)
					or mp:find(str, 1, true)
					or tip:find(str, 1, true)
				icon:SetVisible(match)
				if match then anyVisible = true end
			end

			entry.header:SetVisible(anyVisible)
			entry.grid:SetVisible(anyVisible)
			entry.grid:InvalidateLayout()
		end
		list:InvalidateLayout()
	end

	local allModels = player_manager.GetAllPlayerModels() or {}
	local curName   = MySelf and MySelf:GetInfo("cl_playermodel") or nil
	local curInfo   = curName and allModels[curName] or nil

	if curInfo then
		timer.Simple(0, function()
			if not (IsValid(pPlayerModel) and IsValid(mdl)) then return end
			if not curInfo.model then return end

			SelectModel(curName, curInfo.model)

			local bgCV = GetConVar("cl_playerbodygroups")
			local skCV = GetConVar("cl_playerskin")
			state.bodygroups = (bgCV and bgCV:GetString()) or "0"
			state.skin       = (skCV and tonumber(skCV:GetString())) or 0

			RebuildBodygroupTab()

			local tries = 0
			timer.Create("ZS_PM_BGTab_Retry_" .. tostring(pPlayerModel), 0.1, 10, function()
				tries = tries + 1
				if not (IsValid(pPlayerModel) and IsValid(mdl) and mdl.Entity and mdl.Entity:IsValid()) then
					return
				end
				RebuildBodygroupTab()
				timer.Remove("ZS_PM_BGTab_Retry_" .. tostring(pPlayerModel))
			end)
		end)
	end

	pPlayerModel:MakePopup()
	pPlayerModel.OnClose = function(me)
		if not state.model then return end

		local currentModel = MySelf and MySelf:GetInfo("cl_playermodel") or ""
		local currentBG    = (GetConVar("cl_playerbodygroups") and GetConVar("cl_playerbodygroups"):GetString()) or "0"
		local currentSkin  = (GetConVar("cl_playerskin") and GetConVar("cl_playerskin"):GetString()) or "0"
		local newBG        = tostring(state.bodygroups or "0")
		local newSkin      = tostring(state.skin or 0)

		if state.model == currentModel and newBG == currentBG and newSkin == currentSkin then
			return
		end

		surface.PlaySound("buttons/button14.wav")

		RunConsoleCommand("cl_playermodel", state.model)
		RunConsoleCommand("cl_playerbodygroups", newBG)
		RunConsoleCommand("cl_playerskin", newSkin)

		chat.AddText(COLOR_LIMEGREEN, translate.Format("changed_player_model_x", ZS_PlayerModelDisplayName(state.model)))
	end
end

-- DMenuOption patch: hide the label, draw the background and text ourselves.
do
	local meta = vgui.GetControlTable("DMenuOption")
	if meta and not meta.ZS_PatchV3 then
		meta.ZS_PatchV3 = true

		-- Save the text before we hide the label.
		local oldSetText = meta.SetText
		meta.SetText = function(self, text, ...)
			self.ZS_Text = text or ""
			if oldSetText then oldSetText(self, text, ...) end
		end

		-- Reliable label search (in different builds it is in self.Label
		-- or in self.pnlCanvas).
		local function FindLabel(s)
			if IsValid(s._CachedLbl) then return s._CachedLbl end
			if IsValid(s.Label) then s._CachedLbl = s.Label; return s.Label end
			for _, ch in ipairs(s:GetChildren()) do
				if IsValid(ch) then
					if ch.ClassName == "DLabel" then
						s._CachedLbl = ch
						return ch
					end
					for _, sub in ipairs(ch:GetChildren()) do
						if IsValid(sub) and sub.ClassName == "DLabel" then
							s._CachedLbl = sub
							return sub
						end
					end
				end
			end
		end

		local oldPerformLayout = meta.PerformLayout
		meta.PerformLayout = function(self, w, h)
			if oldPerformLayout then oldPerformLayout(self, w, h) end
			local lbl = FindLabel(self)
			if IsValid(lbl) then lbl:SetVisible(false) end
		end

		meta.Paint = function(s, w, h)
			if s:IsDown() then
				surface.SetDrawColor(150, 185, 230, 255)
			elseif s:IsHovered() then
				surface.SetDrawColor(180, 210, 245, 230)
			else
				surface.SetDrawColor(230, 230, 235, 255)
			end
			surface.DrawRect(0, 0, w, h)
			return true
		end

		-- We draw the text ourselves in PaintOver — over everything.
		meta.PaintOver = function(s, w, h)
			local text = s.ZS_Text or ""
			if text == "" then
				local lbl = FindLabel(s)
				if IsValid(lbl) then text = lbl:GetText() or "" end
			end
			if text == "" then return true end

			-- We determine the “first option” by the minimum Y among the neighbors —
			-- works regardless of AddOption.
			local isFirst = false
			local par = s:GetParent()
			if IsValid(par) then
				local myY = s:GetY()
				isFirst = true
				for _, ch in ipairs(par:GetChildren()) do
					if ch ~= s and IsValid(ch) and ch.ClassName == "DMenuOption"
						and ch:GetY() < myY then
						isFirst = false
						break
					end
				end
			end

			local col = isFirst
				and Color(0, 60, 130, 255)
				or  Color(0, 0, 0, 255)

			-- The icon is located either in s.Image or in s.m_Image.
			local iconPnl = s.Image or s.m_Image
			local hasIcon = IsValid(iconPnl) and iconPnl:GetImage() ~= ""

			draw.SimpleText(
				text,
				s:GetFont() or "DermaDefault",
				hasIcon and 30 or 8,
				h / 2,
				col,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_CENTER
			)

			return true
		end
	end
end

do
	local menuMeta = vgui.GetControlTable("DMenu")
	if menuMeta and not menuMeta.ZS_BorderPatch then
		menuMeta.ZS_BorderPatch = true

		local oldPaint = menuMeta.Paint
		menuMeta.Paint = function(self, w, h)
			surface.SetDrawColor(230, 230, 235, 255)
			surface.DrawRect(0, 0, w, h)
			return true
		end

		menuMeta.PaintOver = function(self, w, h)
			surface.SetDrawColor(60, 60, 60, 255)
			surface.DrawOutlinedRect(0, 0, w, h)
			return true
		end

		local oldAddOption = menuMeta.AddOption
		menuMeta.AddOption = function(self, ...)
			self.ZS_OptionCount = (self.ZS_OptionCount or 0) + 1
			local opt = oldAddOption(self, ...)
			if IsValid(opt) then
				opt.ZS_OptionIndex = self.ZS_OptionCount
			end
			return opt
		end
	end
end

function MakepPlayerColor()
	if pPlayerColor and pPlayerColor:IsValid() then pPlayerColor:Remove() end

	PlayMenuOpenSound()
	HideOtherSubmenus(nil)

	pPlayerColor = vgui.Create("DFrame")
	pPlayerColor:SetWide(math.min(ScrW(), 500))
	pPlayerColor:SetTitle(" ")
	pPlayerColor:SetDeleteOnClose(true)
	pPlayerColor.MainMenuSubmenu = true

	local y = 8

	local label = EasyLabel(pPlayerColor, translate.Get("pcolor_title"), "ZSHUDFont", color_white)
	label:SetPos((pPlayerColor:GetWide() - label:GetWide()) / 2, y)
	y = y + label:GetTall() + 8

	local lab = EasyLabel(pPlayerColor, translate.Get("pcolor_player_color"))
	lab:SetPos(8, y)
	y = y + lab:GetTall()

	local colpicker = vgui.Create("DColorMixer", pPlayerColor)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(true)
	colpicker:SetPaletteName("zs_pcolor_ply")
	colpicker.UpdateConVars = function(me, color)
		me.NextConVarCheck = SysTime() + 0.2
		RunConsoleCommand("cl_playercolor", color.r / 100 .." ".. color.g / 100 .." ".. color.b / 100)
	end

	local r, g, b = string.match(GetConVar("cl_playercolor"):GetString(), "(%g+) (%g+) (%g+)")
	if r then
		colpicker:SetColor(Color(r * 100, g * 100, b * 100))
	end

	local defaultcol = Vector(GetConVar("cl_playercolor"):GetDefault()):ToColor()
	if defaultcol and colpicker.HSV then
		colpicker.HSV:SetDefaultColor(defaultcol)
	end

	colpicker:SetSize(pPlayerColor:GetWide() - 16, 200)
	colpicker:SetPos(8, y)
	y = y + colpicker:GetTall() + 8

	lab = EasyLabel(pPlayerColor, translate.Get("pcolor_weapon_color"))
	lab:SetPos(8, y)
	y = y + lab:GetTall()

	colpicker = vgui.Create("DColorMixer", pPlayerColor)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(true)
	colpicker:SetPaletteName("zs_pcolor_wep")
	colpicker.UpdateConVars = function(me, color)
		me.NextConVarCheck = SysTime() + 0.2
		RunConsoleCommand("cl_weaponcolor", color.r / 100 .." ".. color.g / 100 .." ".. color.b / 100)
	end

	r, g, b = string.match(GetConVar("cl_weaponcolor"):GetString(), "(%g+) (%g+) (%g+)")
	if r then
		colpicker:SetColor(Color(r * 100, g * 100, b * 100))
	end

	local defaultcol = Vector(GetConVar("cl_weaponcolor"):GetDefault()):ToColor()
	if defaultcol and colpicker.HSV then
		colpicker.HSV:SetDefaultColor(defaultcol)
	end

	colpicker:SetSize(pPlayerColor:GetWide() - 16, 200)
	colpicker:SetPos(8, y)
	y = y + colpicker:GetTall()

	pPlayerColor:SetTall(y + 8)
	pPlayerColor:Center()
	pPlayerColor:MakePopup()
end

function GM:ShowHelp()
	if self.HelpMenu and self.HelpMenu:IsValid() then
		self.HelpMenu:Remove()
	end

	PlayMenuOpenSound()

	local screenscale = BetterScreenScale()
	local menu = vgui.Create("Panel")
	menu:SetSize(screenscale * 420, ScrH())
	menu:Center()
	menu.Paint = HelpMenuPaint
	menu.Created = SysTime()
	self.HelpMenu = menu

	local header = EasyLabel(menu, self.Name, "ZSHUDFont")
	header:SetContentAlignment(8)
	header:DockMargin(0, ScrH() * 0.25, 0, 64)
	header:Dock(TOP)

	local buttonhei = 32 * screenscale

	local content = {header}

	local function MakeSubmenuButton(text, onclick)
		local b = vgui.Create("DButton", menu)
		b:SetFont("ZSHUDFontSmaller")
		b:SetText(text)
		b:SetTall(buttonhei)
		b:DockMargin(0, 0, 0, 12)
		b:DockPadding(0, 12, 0, 12)
		b:Dock(TOP)
		b.DoClick = onclick
		content[#content + 1] = b
		return b
	end

	MakeSubmenuButton(translate.Get("submenu_help"),            function() MakepHelp() end)
	MakeSubmenuButton(translate.Get("submenu_player_model"),    function() MakepPlayerModel() end)
	MakeSubmenuButton(translate.Get("submenu_player_color"),    function() MakepPlayerColor() end)
	MakeSubmenuButton(translate.Get("submenu_options"),         function() MakepOptions() end)
	MakeSubmenuButton(translate.Get("submenu_weapon_database"), function() MakepWeapons() end)
	local skillsBtn = MakeSubmenuButton(translate.Get("submenu_skills"), function() GAMEMODE:ToggleSkillWeb() end)
	MakeSubmenuButton(translate.Get("submenu_credits"),         function() MakepCredits() end)

	local closebtn = vgui.Create("DButton", menu)
	closebtn:SetFont("ZSHUDFontSmaller")
	closebtn:SetText(translate.Get("submenu_close"))
	closebtn:SetTall(buttonhei)
	closebtn:DockMargin(0, 24, 0, 0)
	closebtn:DockPadding(0, 12, 0, 12)
	closebtn:Dock(TOP)
	closebtn.DoClick = function() menu:Remove() end
	content[#content + 1] = closebtn

	local function IsBlockingSubmenuOpen()
		local panels = {pHelp, pOptions, pWeapons, pCredits, pPlayerColor}
		for i = 1, #panels do
			local pnl = panels[i]
			if pnl and IsValid(pnl) and (not pnl.IsVisible or pnl:IsVisible()) then
				return true
			end
		end

		for _, pnl in pairs(vgui.GetWorldPanel():GetChildren()) do
			if IsValid(pnl) and pnl ~= menu and pnl.MainMenuSubmenu
			   and (not pnl.IsVisible or pnl:IsVisible()) then
				return true
			end
		end

		return false
	end

	local lastShow
	local timerid = "ZS_HelpMenu_ContentSync_" .. tostring(menu)
	timer.Create(timerid, 0.1, 0, function()
		if not IsValid(menu) then
			timer.Remove(timerid)
			return
		end

		local show = not IsBlockingSubmenuOpen()

		for i = 1, #content do
			local pnl = content[i]
			if IsValid(pnl) and pnl:IsVisible() ~= show then
				pnl:SetVisible(show)
			end
		end

		if lastShow ~= show then
			lastShow = show
			if show then
				menu:MakePopup()
			end
		end

		menu:SetMouseInputEnabled(show)
	end)

	menu:MakePopup()
end
