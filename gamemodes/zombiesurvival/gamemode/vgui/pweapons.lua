local function WeaponButtonDoClick(self)
	local swep = self.SWEP
	if swep then
		pWeapons:SetWeaponViewerSWEP(self.SWEP, self.Category, self.Comps)
	end
end

local function SetWeaponViewerSWEP(self, swep, category, comps)
	if self.Viewer then
		if self.Viewer:IsValid() then
			self.Viewer:Remove()
		end
		self.Viewer = nil
	end

	local wid, hei = self:GetWide() * 0.6 - 16, self:GetTall() - self.ViewerY - 8
	local screenscale = BetterScreenScale()

	local viewer = vgui.Create("DPanel", self)
	viewer:SetPaintBackground(false)
	viewer:SetSize(wid, hei)
	viewer:SetPos(self:GetWide() - viewer:GetWide() - 8, self.ViewerY)
	self.Viewer = viewer

	if not swep then return end
	local sweptable = weapons.Get(swep)
	if not sweptable then return end

	GAMEMODE:CreateItemViewerGenericElems(viewer, "cursor")

	viewer.m_Title:SetText(translate.WeaponName(sweptable))

	local desctext = translate.WeaponDesc(sweptable) or sweptable.Description or ""

	viewer.ModelPanel:SetSWEPPreview(sweptable, GAMEMODE.ShowWElements ~= false)
	viewer.m_VBG:SetVisible(true)

	if sweptable.NoDismantle then
		desctext = desctext .. "\n" .. translate.Get("cannot_dismantle_scrap")
	end

	viewer.m_Desc:MoveBelow(viewer.m_VBG, 8)
	viewer.m_Desc:SetFont("ZSBodyTextFont")
	viewer.m_Desc:SetText(desctext)

	local noStats = sweptable.IsTool
		or (category ~= ITEMCAT_GUNS and category ~= ITEMCAT_MELEE)
	GAMEMODE:ViewerStatBarUpdate(viewer, noStats, sweptable)
	if GAMEMODE:HasPurchaseableAmmo(sweptable) and GAMEMODE.AmmoNames[string.lower(sweptable.Primary.Ammo)] then
		local lower = string.lower(sweptable.Primary.Ammo)

	    viewer.m_AmmoType:SetText(translate.AmmoName(lower, "ps"))

		local ki = killicon.Get(GAMEMODE.AmmoIcons[lower])

		viewer.m_AmmoIcon:SetImage(ki[1])
		if ki[2] then viewer.m_AmmoIcon:SetImageColor(ki[2]) end

		viewer.m_AmmoIcon:SetVisible(true)
	else
		viewer.m_AmmoType:SetText("")
		viewer.m_AmmoIcon:SetVisible(false)
	end

	if not viewer.m_Recipe1 then
		local recipe = EasyLabel(viewer, "", "ZSBodyTextFont", COLOR_TAN)
		recipe:SetContentAlignment(8)
		recipe:SetSize(viewer:GetWide(), 16 * screenscale)
		recipe:MoveBelow(viewer.ItemStatBars[6], 20)
		viewer.m_Recipe1 = recipe
	end

	if not viewer.m_Recipe2 then
		local recipe = EasyLabel(viewer, "", "ZSBodyTextFont", COLOR_TAN)
		recipe:SetContentAlignment(8)
		recipe:SetSize(viewer:GetWide(), 16 * screenscale)
		recipe:MoveBelow(viewer.m_Recipe1, 20)
		viewer.m_Recipe2 = recipe
	end

	if comps then
	local invdata = GAMEMODE.ZSInventoryItemData[comps[1]]
	if invdata then
		viewer.m_Recipe1:SetText(translate.ItemName(invdata.TranslationID, invdata.TranslationPrefix) or invdata.PrintName)
	end
	local wep2 = weapons.Get(comps[2])
	if wep2 then
		viewer.m_Recipe2:SetText(translate.WeaponName(wep2))
	end
else
	viewer.m_Recipe1:SetText("")
	viewer.m_Recipe2:SetText("")
end
end

function MakepWeapons(silent)
	if not silent then
		PlayMenuOpenSound()
	end

	if pWeapons and pWeapons:IsValid() then
		pWeapons:SetAlpha(0)
		pWeapons:AlphaTo(255, 0.15, 0)
		pWeapons:SetVisible(true)
		pWeapons:MakePopup()
		return
	end

	pWeapons = nil

	local added = {}
	local addedcat = {}
	local weps = {}
	local crafts = {}

	for _, tab in ipairs(GAMEMODE.Items) do
		if tab.SWEP and not added[tab.SWEP] then
			if weapons.Get(tab.SWEP) then
				weps[#weps + 1] = tab.SWEP
				added[tab.SWEP] = true
				addedcat[tab.SWEP] = tab.Category
			end
		end
	end

	for wep, comps in pairs(GAMEMODE.Assemblies) do
		if not added[wep] then
			if weapons.Get(wep) then
				crafts[#crafts + 1] = wep
				added[wep] = true
			end
		end
	end

	local screenscale = BetterScreenScale()
	local wid, hei = math.min(ScrW(), 700) * screenscale, math.min(ScrH(), 700) * screenscale
	local tabhei = 24 * screenscale

	local frame = vgui.Create("DFrame")
	frame:SetDeleteOnClose(false)
	frame:SetSize(wid, hei)
	frame:SetTitle(" ")
	frame:Center()
	frame.MainMenuSubmenu = true
	frame.SetWeaponViewerSWEP = SetWeaponViewerSWEP
	pWeapons = frame

	local y = 8

	local title = EasyLabel(frame, translate.Get("weapon_database_title"), "ZSHUDFont", color_white)
	title:SetPos(wid * 0.5 - title:GetWide() * 0.5, y)
	y = y + title:GetTall() + 8

	-- ============================================================
	-- Category + Search + Sort
	-- ============================================================
	local searchRowH = 24 * screenscale
	local catBtnW    = 130 * screenscale
	local sortBtnW   = 96 * screenscale
	local searchW    = wid - 16 - catBtnW - sortBtnW - 8

	local searchRow = vgui.Create("EditablePanel", frame)
	searchRow:SetSize(wid - 16, searchRowH)
	searchRow:SetPos(8, y)
	searchRow.Paint = function() end

	local catBtn = vgui.Create("DButton", searchRow)
	catBtn:SetText("")
	catBtn:SetPos(0, 0)
	catBtn:SetSize(catBtnW, searchRowH)
	catBtn.Paint = function(me, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(20, 20, 20, 200))
		draw.RoundedBox(2, 1, 1, w - 2, h - 2,
			me.Hovered and Color(30, 30, 30, 240) or Color(10, 10, 10, 240))
	end

	local catLabel = vgui.Create("DLabelAutoScroll", catBtn)
	catLabel:SetFont("ZSHUDFontSmaller")
	catLabel:SetTextColor(color_white)
	catLabel:SetContentAlignment(5)
	catLabel:SetScrollingMode("time")
	catLabel:Dock(FILL)
	catLabel:SetMouseInputEnabled(false)

	local searchEntry = vgui.Create("DTextEntry", searchRow)
	searchEntry:SetPos(catBtnW + 4, 0)
	searchEntry:SetSize(searchW, searchRowH)
	searchEntry:SetFont("DermaDefault")
	searchEntry:SetEditable(true)
	searchEntry:SetMultiline(false)
	searchEntry:SetAllowNonAsciiCharacters(true)
	searchEntry:SetTextColor(Color(0, 0, 0))
	searchEntry:SetCursorColor(Color(0, 0, 0))
	searchEntry:SetHighlightColor(Color(80, 130, 200))
	searchEntry:SetPaintBackground(false)
	searchEntry:SetUpdateOnType(true)
	searchEntry:SetKeyboardInputEnabled(true)
	searchEntry:SetMouseInputEnabled(true)
	searchEntry:SetPlaceholderText(translate.Get("weapon_database_search"))
	searchEntry:SetPlaceholderColor(Color(130, 130, 130, 255))

	searchEntry.OnValueChange = function(_, text)
		frame.SearchFilter = string.utf8lower(text or "")
		if timer.Exists("ZS_WeaponsSearchDebounce") then
			timer.Remove("ZS_WeaponsSearchDebounce")
		end
		timer.Create("ZS_WeaponsSearchDebounce", 0.15, 1, function()
			if IsValid(frame) then
				frame:RebuildWeaponTrees()
			end
		end)
	end

	searchRow.Paint = function(me, w, h)
		draw.RoundedBox(2, catBtnW + 4, 0, searchW, h, Color(255, 255, 255, 255))
		surface.SetDrawColor(120, 120, 120, 255)
		surface.DrawOutlinedRect(catBtnW + 4, 0, searchW, h)
	end

	local sortBtn = vgui.Create("DButton", searchRow)
	sortBtn:SetText("")
	sortBtn:SetPos(catBtnW + 4 + searchW + 4, 0)
	sortBtn:SetSize(sortBtnW, searchRowH)
	sortBtn.Paint = function(me, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(20, 20, 20, 200))
		draw.RoundedBox(2, 1, 1, w - 2, h - 2,
			me.Hovered and Color(30, 30, 30, 240) or Color(10, 10, 10, 240))
	end

	local sortLabel = vgui.Create("DLabelAutoScroll", sortBtn)
	sortLabel:SetFont("ZSHUDFontSmaller")
	sortLabel:SetTextColor(color_white)
	sortLabel:SetContentAlignment(5)
	sortLabel:SetScrollingMode("time")
	sortLabel:SetText(translate.Get("weapon_database_sort_az"))
	sortLabel:Dock(FILL)
	sortLabel:SetMouseInputEnabled(false)

	frame.WeaponSortDesc = false
	frame.SearchFilter   = ""
	frame.WeaponCatFilter = nil   -- nil = All

	sortBtn.DoClick = function()
		frame.WeaponSortDesc = not frame.WeaponSortDesc
		sortLabel:SetText(frame.WeaponSortDesc and translate.Get("weapon_database_sort_za") or translate.Get("weapon_database_sort_az"))
		frame:RebuildWeaponTrees()
	end

	y = y + searchRowH + 6

	local weaponData = {}
	for _, wep in ipairs(weps) do
		local enttab = weapons.Get(wep)
		weaponData[#weaponData + 1] = {
			swep        = wep,
			name        = translate.WeaponName(enttab) or wep,
			classname   = wep,
			rawprintname= (enttab and enttab.PrintName) or "",
			category    = addedcat[wep] or ITEMCAT_GUNS,
		}
	end

	local craftData = {}
	for _, wep in ipairs(crafts) do
		local enttab = weapons.Get(wep)
		craftData[#craftData + 1] = {
			swep        = wep,
			name        = translate.WeaponName(enttab) or wep,
			classname   = wep,
			rawprintname= (enttab and enttab.PrintName) or "",
			category    = enttab.RequiredClip and ITEMCAT_GUNS
				or (enttab.Primary.Ammo == "none" and enttab.MeleeRange) and ITEMCAT_MELEE
				or ITEMCAT_TOOLS,
			comps       = GAMEMODE.Assemblies[wep],
		}
	end

	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:SetSize(wid * 0.4 - 8, hei - y - 16 * screenscale)
	propertysheet:SetPos(8, y)
	propertysheet:SetPadding(1)
	frame.PropSheet = propertysheet

	local tree = vgui.Create("DTree", propertysheet)
	tree:SetWide(propertysheet:GetWide() - 16)
	local sheet = propertysheet:AddSheet(translate.Get("weapons_tab"), tree, nil, false, false)
	sheet.Panel:SetPos(0, tabhei + 2)
	tree:SetIndentSize(4)
	frame.WeaponsTree = tree
	frame.WeaponsTabPanel = sheet.Panel

	tree = vgui.Create("DTree", propertysheet)
	tree:SetWide(propertysheet:GetWide() - 16)
	sheet = propertysheet:AddSheet(translate.Get("crafts_tab"), tree, nil, false, false)
	sheet.Panel:SetPos(0, tabhei + 2)
	tree:SetIndentSize(4)
	frame.CraftsTree = tree
	frame.CraftsTabPanel = sheet.Panel

	local scroller = propertysheet:GetChildren()[1]
	local dragbase = scroller:GetChildren()[1]
	local tabs = dragbase:GetChildren()

	GAMEMODE:ConfigureMenuTabs(tabs, tabhei)

	frame.ViewerY = y

	local catMenu
	local catMenuCloser
	local function CloseCatMenu()
		if IsValid(catMenu) then catMenu:Remove() end
		catMenu = nil
		if IsValid(catMenuCloser) then catMenuCloser:Remove() end
		catMenuCloser = nil
		if IsValid(frame) then
			frame:MakePopup()
		end
	end

	local function GetActiveTabData()
		if IsValid(frame.CraftsTabPanel) and frame.CraftsTabPanel:IsVisible() then
			return craftData
		end
		return weaponData
	end

		local function UpdateCatLabel()
		local cat = frame.WeaponCatFilter
		if cat and GAMEMODE.ItemCategories[cat] then
			catLabel:SetText(translate.Get(GAMEMODE.ItemCategories[cat]))
		else
			catLabel:SetText(translate.Get("inventory_category_all"))
		end
	end
	UpdateCatLabel()

	-- ============================================================
	-- Reset the category filter when switching tabs, if the selected
	-- category is not on the new tab.
	-- ============================================================
	propertysheet.OnActiveTabChanged = function(self, old, new)
		-- Wait for one frame so that VGUI has time to update the visibility of the panels
        -- and GetActiveTabData() returns the correct data array.
		timer.Simple(0, function()
			if not IsValid(frame) then return end
			
			local data = GetActiveTabData()
			local cat = frame.WeaponCatFilter

			if cat ~= nil then
				local found = false
				for _, d in ipairs(data) do
					if d.category == cat then
						found = true
						break
					end
				end

				-- If the selected category isn't on the new tab, reset to “All”
				if not found then
					frame.WeaponCatFilter = nil
					UpdateCatLabel()
					frame:RebuildWeaponTrees()
				end
			end
		end)
	end

	local function OpenCatMenu()
		CloseCatMenu()

		local data = GetActiveTabData()

		local seen = {}
		for _, d in ipairs(data) do
			seen[d.category] = true
		end

		local entries = {{id = nil, label = translate.Get("inventory_category_all")}}
		for cat = 1, ITEMCAT_OTHER do
			local key = GAMEMODE.ItemCategories[cat]
			if seen[cat] and key then
				entries[#entries + 1] = {id = cat, label = translate.Get(key)}
			end
		end

		catMenuCloser = vgui.Create("EditablePanel") 
		catMenuCloser:SetSize(ScrW(), ScrH())
		catMenuCloser:SetPos(0, 0)
		catMenuCloser:SetMouseInputEnabled(true)
		catMenuCloser:SetKeyboardInputEnabled(false)
		catMenuCloser.Paint = function() end
		catMenuCloser.OnMousePressed = function(self, mc)
			CloseCatMenu()
			return true
		end
		catMenuCloser.Think = function(self)
			if not IsValid(frame) or not frame:IsVisible() then
				CloseCatMenu()
			end
		end
		catMenuCloser:MakePopup()

		local rowH = 22 * screenscale
		local menu = vgui.Create("DPanel", catMenuCloser)
		menu:SetMouseInputEnabled(true)
		menu:SetKeyboardInputEnabled(false)
		menu:SetZPos(32768)
		menu:SetSize(catBtnW, #entries * rowH + 4)

		local bx, by = catBtn:LocalToScreen(0, 0)
		by = by + catBtn:GetTall() + 2
		menu:SetPos(bx, by)

		menu.Paint = function(me, w, h)
			draw.RoundedBox(2, 0, 0, w, h, Color(12, 12, 12, 252))
			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		for i, e in ipairs(entries) do
			local btn = vgui.Create("DButton", menu)
			btn:SetText("")
			btn:SetSize(menu:GetWide() - 4, rowH)
			btn:SetPos(2, 2 + (i - 1) * rowH)

			local active = frame.WeaponCatFilter == e.id

			btn.Paint = function(me, w, h)
				local bg = active and Color(60, 60, 60, 240)
					or (me.Hovered and Color(40, 40, 40, 240) or Color(20, 20, 20, 200))
				draw.RoundedBox(2, 0, 0, w, h, bg)
			end

			local lab = vgui.Create("DLabelAutoScroll", btn)
			lab:SetFont("ZSHUDFontSmaller")
			lab:SetTextColor(active and color_white or COLOR_GRAY)
			lab:SetContentAlignment(5)
			lab:SetScrollingMode("time")
			lab:SetText(e.label)
			lab:Dock(FILL)
			lab:SetMouseInputEnabled(false)

			btn.DoClick = function()
				CloseCatMenu()
				frame.WeaponCatFilter = e.id
				UpdateCatLabel()
				frame:RebuildWeaponTrees()
			end
		end

		catMenu = menu
	end

	catBtn.DoClick = function()
		if IsValid(catMenu) then
			CloseCatMenu()
		else
			OpenCatMenu()
		end
	end


	local function ClearDTree(tree)
		if not IsValid(tree) then return end

		if tree.Clear then
			tree:Clear()
			return
		end

		local root = tree.RootNode
		if not IsValid(root) then return end

		local kids = root:GetChildren()
		for i = #kids, 1, -1 do
			local child = kids[i]
			if IsValid(child) then
				child:Remove()
			end
		end

		tree:InvalidateLayout(true)
	end

	local function FilterAndSort(data)
		local filter    = frame.SearchFilter or ""
		local desc      = frame.WeaponSortDesc
		local catFilter = frame.WeaponCatFilter

		local filtered = {}
		for _, d in ipairs(data) do
			local pass = true

			if catFilter ~= nil and d.category ~= catFilter then
				pass = false
			end

			if pass and filter ~= "" then
				local n = string.utf8lower(d.name         or "")
				local c = string.utf8lower(d.classname    or "")
				local r = string.utf8lower(d.rawprintname or "")
				pass = n:find(filter, 1, true) ~= nil
					or c:find(filter, 1, true) ~= nil
					or r:find(filter, 1, true) ~= nil
			end

			if pass then filtered[#filtered + 1] = d end
		end

		table.sort(filtered, function(a, b)
			local an = string.utf8lower(a.name or "")
			local bn = string.utf8lower(b.name or "")
			if an == bn then
				return string.utf8lower(a.classname or "") < string.utf8lower(b.classname or "")
			end
			if desc then return an > bn else return an < bn end
		end)

		return filtered
	end

	local function PopulateTree(tree, list, isCraft)
		for _, d in ipairs(list) do
			local node = tree:AddNode(d.name)
			node.SWEP     = d.swep
			node.DoClick  = WeaponButtonDoClick
			node.Category = d.category
			if isCraft then
				node.Comps = d.comps
			end
		end
	end

	function frame:RebuildWeaponTrees()
		if IsValid(self.WeaponsTree) then
			ClearDTree(self.WeaponsTree)
			PopulateTree(self.WeaponsTree, FilterAndSort(weaponData), false)
		end

		if IsValid(self.CraftsTree) then
			ClearDTree(self.CraftsTree)
			PopulateTree(self.CraftsTree, FilterAndSort(craftData), true)
		end
	end
	frame:RebuildWeaponTrees()
	frame:SetWeaponViewerSWEP()

	frame:SetVisible(true)
	frame:MakePopup()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.15, 0)
end
