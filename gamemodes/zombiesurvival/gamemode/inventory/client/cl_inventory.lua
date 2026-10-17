GM.ZSInventory = {}
INVCAT_WEAPONS = INVCAT_WEAPONS or -1

INVCAT_TRINKETS = 1
INVCAT_COMPONENTS = 2
INVCAT_CONSUMABLES = 3

local categorycolors = {
	[INVCAT_TRINKETS]    = {COLOR_RED,    COLOR_DARKRED},
	[INVCAT_COMPONENTS]  = {COLOR_BLUE,   COLOR_DARKBLUE},
	[INVCAT_CONSUMABLES] = {COLOR_YELLOW, COLOR_DARKYELLOW},
}

local cvInvSort = CreateClientConVar("zs_inventorysort", "0", true, false)
GM.InvSortMode = cvInvSort:GetInt() == 1 and "received" or "alpha"

GM.InvAcquireOrder = GM.InvAcquireOrder or {}
local invAcquireSeq = 0

local meta = FindMetaTable("Player")
function meta:GetInventoryItems()
	return GAMEMODE.ZSInventory
end

function meta:HasInventoryItem(item)
	return GAMEMODE.ZSInventory[item] and GAMEMODE.ZSInventory[item] > 0
end

net.Receive("zs_inventoryitem", function()
	local item = net.ReadString()
	local count = net.ReadInt(5)
	local prevcount = GAMEMODE.ZSInventory[item] or 0

	GAMEMODE.ZSInventory[item] = count

	if count > 0 and prevcount <= 0 then
		invAcquireSeq = invAcquireSeq + 1
		GAMEMODE.InvAcquireOrder[item] = invAcquireSeq
	elseif count <= 0 then
		GAMEMODE.InvAcquireOrder[item] = nil
	end

	if GAMEMODE.InventoryMenu and GAMEMODE.InventoryMenu:IsValid() then
		if count > prevcount then
			GAMEMODE:InventoryAddGridItem(item, GAMEMODE:GetInventoryItemType(item))
		else
			GAMEMODE:InventoryRemoveGridItem(item)
		end
	end

	if MySelf and MySelf:IsValid() then
		MySelf:ApplyTrinkets()
	end
end)

net.Receive("zs_wipeinventory", function()
	GAMEMODE.ZSInventory = {}
	GAMEMODE.InvAcquireOrder = {}

	if GAMEMODE.InventoryMenu and GAMEMODE.InventoryMenu:IsValid() then
		GAMEMODE:InventoryWipeGrid()
	end

	MySelf:ApplyTrinkets()
end)

local function TryCraftWithComponent(me)
	net.Start("zs_trycraft")
		net.WriteString(me.Item)
		net.WriteString(me.WeaponCraft)
	net.SendToServer()
end

local function GetInvItemInfo(item, category)
	local name, desc, datatab

	if category == INVCAT_WEAPONS then
		datatab = weapons.Get(item)
		if datatab then
			name = translate.WeaponName(datatab) or datatab.PrintName
			desc = translate.WeaponDesc(datatab) or ""
		end
	else
		datatab = GAMEMODE.ZSInventoryItemData[item]
		if datatab then
			name = translate.ItemName(datatab.TranslationID, datatab.TranslationPrefix) or datatab.PrintName
			desc = translate.ItemDescription(datatab, datatab.TranslationPrefix or "item") or ""
		end
	end

	return name or item, desc or "", datatab
end

local invTooltip
local function EnsureInvTooltip()
	if IsValid(invTooltip) then return invTooltip end

	local p = vgui.Create("DPanel")
	p:SetSize(260, 30)
	p:SetDrawOnTop(true)
	p:SetMouseInputEnabled(false)
	p:SetKeyboardInputEnabled(false)
	p:SetVisible(false)
	p.Paint = function(me, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(12, 12, 12, 252))
		surface.SetDrawColor(me._BorderColor or COLOR_WHITE)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local title = vgui.Create("DLabelAutoScroll", p)
	title:SetFont("ZSHUDFontSmaller")
	title:SetTextColor(COLOR_WHITE)
	title:SetContentAlignment(5)
	title:SetScrollingMode("time")
	title:SetPos(8, 6)
	title:SetSize(p:GetWide() - 16, 18)
	title:SetMouseInputEnabled(false)
	p._Title = title

	invTooltip = p
	return p
end

function GM:ShowInventoryTooltip(itempan)
	local p = EnsureInvTooltip()
	local name = GetInvItemInfo(itempan.Item, itempan.Category)

	p._Title:SetText(name or "?")

	local colors = categorycolors[itempan.Category]
	p._BorderColor = (colors and colors[1]) or COLOR_WHITE

	p:SetSize(260, 6 + 18 + 6)
	p:SetVisible(true)

	local mx, my = gui.MousePos()
	local tw, th = p:GetSize()
	p:SetPos(math.Clamp(mx + 18, 0, ScrW() - tw), math.Clamp(my + 18, 0, ScrH() - th))
end

function GM:HideInventoryTooltip()
	if IsValid(invTooltip) then
		invTooltip:SetVisible(false)
	end
end

local function ItemPanelDoClick(self)
	local item = self.Item
	if not item then return end

	local category, sweptable = self.Category
	if category == INVCAT_WEAPONS then
		sweptable = weapons.Get(item)
	else
		sweptable = GAMEMODE.ZSInventoryItemData[item]
	end

	local viewer = GAMEMODE.m_InvViewer
	local screenscale = BetterScreenScale()

	if self.On then
		if viewer and viewer:IsValid() then
			viewer:SetVisible(false)
		end

		self.On = false

		GAMEMODE.InventoryMenu.SelInv = false
		GAMEMODE:DoAltSelectedItemUpdate()
		return
	else
		for _, v in pairs(self:GetParent():GetChildren()) do
			v.On = false
		end
		self.On = true

		GAMEMODE.InventoryMenu.SelInv = item
		GAMEMODE:DoAltSelectedItemUpdate()
	end

	GAMEMODE:CreateInventoryInfoViewer()

	viewer = GAMEMODE.m_InvViewer
	viewer.m_Title:SetText(translate.ItemName(sweptable.TranslationID, sweptable.TranslationPrefix) or sweptable.PrintName)
	-- EasyLabel is a Panel, not a DLabel: it has no ContentAlignment autolayout.
	-- Restore fixed size so that alignment (align=8, center)
	-- works relative to the viewer width, not "shrink to text".
	viewer.m_Title:SetSize(viewer:GetWide(), draw.GetFontHeight("ZSHUDFontSmaller") + 8 * screenscale)

	local desctext
	if category == INVCAT_WEAPONS then
		desctext = translate.WeaponDesc(sweptable) or ""
	else
		desctext = translate.ItemDescription(sweptable, sweptable.TranslationPrefix or "item")
	end
	if category == INVCAT_WEAPONS then
		viewer.ModelPanel:SetModel(sweptable.WorldModel)
		local mins, maxs = viewer.ModelPanel.Entity:GetRenderBounds()
		viewer.ModelPanel:SetCamPos(mins:Distance(maxs) * Vector(1.15, 0.75, 0.5))
		viewer.ModelPanel:SetLookAt((mins + maxs) / 2)
		viewer.m_VBG:SetVisible(true)

		if sweptable.NoDismantle then
			desctext = desctext .. "\n" .. translate.Get("cannot_dismantle_scrap")
		end

		viewer.m_Desc:MoveBelow(viewer.m_VBG, 8)
		viewer.m_Desc:SetFont("ZSBodyTextFont")

		local canammo = false
		if sweptable.Primary then
			local ammotype = sweptable.Primary.Ammo
			if GAMEMODE.AmmoToPurchaseNames[ammotype] then
				canammo = true
			end
		end

		if canammo and GAMEMODE.AmmoNames[string.lower(sweptable.Primary.Ammo)] then
			viewer.m_AmmoType:SetText(translate.AmmoName(string.lower(sweptable.Primary.Ammo)))
			-- Same reason — not SizeToContents, but fixed panel size.
			viewer.m_AmmoType:SetSize(viewer:GetWide(), draw.GetFontHeight("ZSBodyTextFontBig") + 4 * screenscale)
		else
			viewer.m_AmmoType:SetText("")
		end
	else
		viewer.ModelPanel:SetModel("")
		viewer.m_VBG:SetVisible(false)

		viewer.m_Desc:MoveBelow(viewer.m_Title, 20)
		viewer.m_Desc:SetFont("ZSBodyTextFontBig")

		viewer.m_AmmoType:SetText("")
	end
	viewer.m_Desc:SetText(desctext)

	GAMEMODE:ViewerStatBarUpdate(viewer, category ~= INVCAT_WEAPONS, sweptable)

	for i = 1, 3 do
		local crab, cral = viewer.m_CraftBtns[i][1], viewer.m_CraftBtns[i][2]

		crab:SetVisible(false)
		cral:SetVisible(false)
	end

	local assembles = {}
	for k,v in pairs(GAMEMODE.Assemblies) do
		if v[1] == item then
			assembles[v[2]] = k
		end
	end

	local count = 0
	for k,v in pairs(assembles) do
		count = count + 1

		local crab, cral = viewer.m_CraftBtns[count][1], viewer.m_CraftBtns[count][2]
		local iitype = GAMEMODE:GetInventoryItemType(k) ~= -1

		crab.Item = item
		crab.WeaponCraft = k
		crab.DoClick = TryCraftWithComponent
		crab:SetPos(viewer:GetWide() / 2 - crab:GetWide() / 2, (viewer:GetTall() - 33 * screenscale) - (count - 1) * 33 * screenscale)
		crab:SetVisible(true)

		local target = iitype and GAMEMODE.ZSInventoryItemData[k] or weapons.Get(k)
		local targetName
		if iitype then
			targetName = translate.ItemName(target.TranslationID, target.TranslationPrefix) or target.PrintName
		else
			targetName = translate.WeaponName(target) or target.PrintName
		end
		cral:SetText(targetName)
		cral:SetPos(crab:GetWide() / 2 - cral:GetWide() / 2, (crab:GetTall() * 0.5 - cral:GetTall() * 0.5))
		cral:SetContentAlignment(5)
		cral:SetVisible(true)
	end

	if count > 0 then
		viewer.m_CraftWith:SetPos(viewer:GetWide() / 2 - viewer.m_CraftWith:GetWide() / 2, (viewer:GetTall() - 33 * screenscale) - 33 * count * screenscale)
		viewer.m_CraftWith:SetContentAlignment(5)
		viewer.m_CraftWith:SetVisible(true)
	else
		viewer.m_CraftWith:SetVisible(false)
	end
end

local colBG = Color(10, 10, 10, 252)
local colBGH = Color(200, 200, 200, 5)
local function ItemPanelPaint(self, w, h)
	local cols = categorycolors[self.Category] or {COLOR_WHITE, COLOR_BLACK}
	draw.RoundedBox(2, 0, 0, w, h, (self.Depressed or self.On) and cols[1] or cols[2])
	draw.RoundedBox(2, 2, 2, w - 4, h - 4, colBG)
	if self.On or self.Hovered then
		draw.RoundedBox(2, 2, 2, w - 4, h - 4, colBGH)
	end

	return true
end

function GM:CreateInventoryInfoViewer()
	if self.m_InvViewer and self.m_InvViewer:IsValid() then
		self.m_InvViewer:SetVisible(true)
		return
	end

	local leftframe = self.InventoryMenu
	local viewer = vgui.Create("DFrame")

	local screenscale = BetterScreenScale()

	viewer:SetDeleteOnClose(false)
	viewer:SetTitle(" ")
	viewer:SetDraggable(false)
	if viewer.btnClose and viewer.btnClose:IsValid() then viewer.btnClose:SetVisible(false) end
	if viewer.btnMinim and viewer.btnMinim:IsValid() then viewer.btnMinim:SetVisible(false) end
	if viewer.btnMaxim and viewer.btnMaxim:IsValid() then viewer.btnMaxim:SetVisible(false) end

	viewer:SetSize(leftframe:GetWide() / 1.25, leftframe:GetTall())
	viewer:MoveRightOf(leftframe, 32)
	viewer:MoveAbove(leftframe, -leftframe:GetTall())
	self.m_InvViewer = viewer

	self:CreateItemViewerGenericElems(viewer)

	local craftbtns = {}
	for i = 1, 3 do
		local craftb = vgui.Create("DButton", viewer)
		craftb:SetText("")
		craftb:SetSize(viewer:GetWide() / 1.15, 27 * screenscale)
		craftb:SetVisible(false)

		local namelab = EasyLabel(craftb, "...", "ZSBodyTextFont", COLOR_WHITE)
		namelab:SetWide(craftb:GetWide())
		namelab:SetVisible(false)
		namelab:SetMouseInputEnabled(false)

		craftbtns[i] = {craftb, namelab}
	end
	viewer.m_CraftBtns = craftbtns

	local craftwith = EasyLabel(viewer, translate.Get("craft_with_label"), "ZSBodyTextFontBig", COLOR_WHITE)
	craftwith:SetSize(viewer:GetWide() / 1.15, 27 * screenscale)
	craftwith:SetVisible(false)
	craftwith:SetMouseInputEnabled(false)
	viewer.m_CraftWith = craftwith
end

local function GetTierLabel(tier)
	tier = math.Clamp(tier or 1, 1, 6)
	return translate.Get("inventory_tier_" .. tier)
end

local function SetTileCount(tile, count)
	local screenscale = BetterScreenScale()

	if count > 1 then
		if IsValid(tile.CountLabel) then
			tile.CountLabel:SetText("x" .. count)
			tile.CountLabel:SizeToContents()
		else
			local cntlbl = EasyLabel(tile, "x" .. count, "ZSHUDFontSmaller", COLOR_WHITE)
			cntlbl:SizeToContents()
			cntlbl:SetPos(3 * screenscale, 3 * screenscale)
			cntlbl:SetMouseInputEnabled(false)
			tile.CountLabel = cntlbl
		end
	elseif IsValid(tile.CountLabel) then
		tile.CountLabel:Remove()
		tile.CountLabel = nil
	end
end

local function GetItemSortName(item)
	local data = GAMEMODE.ZSInventoryItemData[item]
	local name = data and (translate.ItemName(data.TranslationID, data.TranslationPrefix) or data.PrintName) or item

	return string.lower(name or item)
end

local function CreateInventoryTile(self, item, category)
	local screenscale = BetterScreenScale()
	local frame = self.InventoryMenu
	local grid = frame.Grid

	local itempan = vgui.Create("DButton")
	itempan:SetText("")
	itempan:SetSize(64 * screenscale, 64 * screenscale)
	itempan.Paint = ItemPanelPaint
	itempan.DoClick = ItemPanelDoClick
	itempan.Item = item
	itempan.Category = category

	grid:AddItem(itempan)

	local mdlframe = vgui.Create("DPanel", itempan)
	mdlframe:SetSize(60 * screenscale, 30 * screenscale)
	mdlframe:Center()
	mdlframe:SetMouseInputEnabled(false)
	mdlframe.Paint = function() end

	local trintier = EasyLabel(itempan, "", "ZSHUDFontSmaller", COLOR_WHITE)
	trintier:CenterHorizontal(0.8)
	trintier:CenterVertical(0.8)

	if category == INVCAT_TRINKETS then
		local tier = GAMEMODE.ZSInventoryItemData[item].Tier or 1
		trintier:SetText(GetTierLabel(tier))
		trintier:SizeToContents()
		trintier:CenterHorizontal(0.8)
		trintier:CenterVertical(0.8)
		trintier:SetMouseInputEnabled(false)
	end

	local kitbl = killicon.Get(category == INVCAT_TRINKETS and "weapon_zs_trinket" or "weapon_zs_craftables")
	if kitbl then
		self:AttachKillicon(kitbl, itempan, mdlframe)
	end

	itempan.OnCursorEntered = function(me)
		GAMEMODE:ShowInventoryTooltip(me)
	end
	itempan.OnCursorExited = function(me)
		GAMEMODE:HideInventoryTooltip()
	end

	SetTileCount(itempan, self.ZSInventory[item] or 0)

	frame.Tiles[item] = itempan

	return itempan
end

function GM:InventoryAddGridItem(item, category)
	local frame = self.InventoryMenu
	if not frame or not frame:IsValid() or not frame.Grid then return end

	local tile = frame.Tiles and frame.Tiles[item]
	if IsValid(tile) then
		SetTileCount(tile, self.ZSInventory[item] or 0)
		return
	end

	if self.InvCategoryFilter ~= nil and self.InvCategoryFilter ~= category then return end

	self:RefreshInventoryGrid()
end

function GM:InventoryRemoveGridItem(item)
	local frame = self.InventoryMenu
	if not frame or not frame:IsValid() or not frame.Grid then return end

	local remaining = self.ZSInventory[item] or 0

	local tile = frame.Tiles and frame.Tiles[item]
	if IsValid(tile) then
		if remaining > 0 then
			SetTileCount(tile, remaining)
		else
			self:HideInventoryTooltip()
			frame.Tiles[item] = nil
			frame.Grid:RemoveItem(tile)
		end
	end

	if self:RefreshTabVisibility() then
		self:RefreshInventoryGrid()
		return
	end

	if frame.SelInv == item then
		if self.m_InvViewer and self.m_InvViewer:IsValid() then
			self.m_InvViewer:SetVisible(false)
		end

		frame.SelInv = nil
		self:DoAltSelectedItemUpdate()
	end
end

function GM:InventoryWipeGrid()
	local frame = self.InventoryMenu
	if not frame or not frame:IsValid() or not frame.Grid then return end

	self:HideInventoryTooltip()

	for _, tile in pairs(frame.Tiles or {}) do
		if IsValid(tile) then tile:Remove() end
	end
	frame.Tiles = {}
	frame.Grid.Items = {}

	if self.m_InvViewer and self.m_InvViewer:IsValid() then
		self.m_InvViewer:SetVisible(false)
	end

	frame.SelInv = nil
	self:DoAltSelectedItemUpdate()
end

function GM:CategoryHasItems(category)
	if category == nil then return true end
	for item, count in pairs(self.ZSInventory) do
		if count > 0 and self:GetInventoryItemType(item) == category then
			return true
		end
	end
	return false
end

function GM:RefreshTabVisibility()
	local frame = self.InventoryMenu
	if not frame or not frame:IsValid() then return false end

	local filterInvalid = self.InvCategoryFilter ~= nil and not self:CategoryHasItems(self.InvCategoryFilter)
	if filterInvalid then
		self.InvCategoryFilter = nil
		if frame.UpdateCategoryLabel then frame.UpdateCategoryLabel() end
	end

	return filterInvalid
end

function GM:RefreshInventoryGrid()
	local frame = self.InventoryMenu
	if not frame or not frame:IsValid() or not frame.Grid then return end

	local grid = frame.Grid

	self:HideInventoryTooltip()

	for _, tile in pairs(frame.Tiles or {}) do
		if IsValid(tile) then tile:Remove() end
	end
	frame.Tiles = {}
	for _, child in ipairs(grid:GetChildren()) do
		if IsValid(child) then child:Remove() end
	end
	grid.Items = {}

	local filter = self.InvCategoryFilter
	if filter ~= nil and not self:CategoryHasItems(filter) then
		self.InvCategoryFilter = nil
		filter = nil
		if frame.UpdateCategoryLabel then frame.UpdateCategoryLabel() end
	end

	local list, unordered = {}, {}
	for item, count in pairs(self.ZSInventory) do
		if count > 0 then
			local cat = self:GetInventoryItemType(item)
			if filter == nil or cat == filter then
				local entry = {item = item, cat = cat, name = GetItemSortName(item)}
				list[#list + 1] = entry

				if not self.InvAcquireOrder[item] then
					unordered[#unordered + 1] = entry
				end
			end
		end
	end

	if #unordered > 0 then
		table.sort(unordered, function(a, b) return a.name < b.name end)
		for _, entry in ipairs(unordered) do
			invAcquireSeq = invAcquireSeq + 1
			self.InvAcquireOrder[entry.item] = invAcquireSeq
		end
	end

	for _, entry in ipairs(list) do
		entry.seq = self.InvAcquireOrder[entry.item] or 0
	end

	if self.InvSortMode == "received" then
		table.sort(list, function(a, b)
			if a.seq ~= b.seq then return a.seq < b.seq end
			return a.name < b.name
		end)
	else
		table.sort(list, function(a, b)
			if a.name ~= b.name then return a.name < b.name end
			return a.seq < b.seq
		end)
	end

	for _, entry in ipairs(list) do
		local tile = CreateInventoryTile(self, entry.item, entry.cat)
		if frame.SelInv == entry.item then
			tile.On = true
		end
	end

	grid:InvalidateLayout(true)
	if IsValid(frame.ListPanel) then
		frame.ListPanel:InvalidateLayout(true)
	end
end

function GM:SetInvCategoryFilter(category)
	self.InvCategoryFilter = category
	self:RefreshInventoryGrid()
end

function GM:SetInvSortMode(mode)
	self.InvSortMode = (mode == "received") and "received" or "alpha"
	RunConsoleCommand("zs_inventorysort", self.InvSortMode == "received" and "1" or "0")

	if self.InventoryMenu and self.InventoryMenu:IsValid() and self.InventoryMenu.UpdateSortLabel then
		self.InventoryMenu.UpdateSortLabel()
	end

	self:RefreshInventoryGrid()
end

function GM:OpenInventory()
	if self.InventoryMenu and self.InventoryMenu:IsValid() then
		if self.InventoryMenu:IsVisible() then
			self.InventoryMenu:SetVisible(false)
			if self.m_InvViewer and self.m_InvViewer:IsValid() then
				self.m_InvViewer:SetVisible(false)
			end
			if self.InventoryMenu.CloseCategoryMenu then
				self.InventoryMenu.CloseCategoryMenu()
			end
		else
			self.InventoryMenu:SetVisible(true)
			if self.m_InvViewer and self.m_InvViewer:IsValid()
				and self.InventoryMenu.SelInv then
				self.m_InvViewer:SetVisible(true)
			end
		end
		return
	end

	local screenscale = BetterScreenScale()
	local wid, hei = math.max(400, math.min(ScrW(), 400) * screenscale), math.min(ScrH(), 370) * screenscale

	local frame = vgui.Create("DFrame")
	frame:SetSize(wid, hei)
	frame:CenterHorizontal(0.385)
	frame:CenterVertical(0.25)
	frame:SetDeleteOnClose(false)
	frame:SetTitle(" ")
	frame:SetDraggable(false)

	if frame.btnClose and frame.btnClose:IsValid() then frame.btnClose:SetVisible(false) end
	if frame.btnMinim and frame.btnMinim:IsValid() then frame.btnMinim:SetVisible(false) end
	if frame.btnMaxim and frame.btnMaxim:IsValid() then frame.btnMaxim:SetVisible(false) end

	self.InventoryMenu = frame
	frame.Tiles = {}

	local topspace = vgui.Create("DPanel", frame)
	topspace:SetWide(wid - 16)

	local title = EasyLabel(topspace, translate.Get("inventory_title"), "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()

	local _, y = title:GetPos()
	topspace:SetTall(y + title:GetTall() + 2)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local catBtnW = 110 * screenscale
	local tabbarW = wid - 16
	local sortBtnW = tabbarW - catBtnW - 4

	local tabbar = vgui.Create("DPanel", frame)
	tabbar:SetTall(24 * screenscale)
	tabbar:SetWide(tabbarW)
	tabbar:AlignTop(topspace:GetTall() + 18)
	tabbar:CenterHorizontal()
	tabbar.Paint = function() end

	local function PaintButton(me, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(20, 20, 20, 200))
		draw.RoundedBox(2, 1, 1, w - 2, h - 2, me.Hovered and Color(30, 30, 30, 240) or Color(10, 10, 10, 240))
	end

	local catBtn = vgui.Create("DButton", tabbar)
	catBtn:SetText("")
	catBtn:SetSize(catBtnW, 24 * screenscale)
	catBtn:SetPos(0, 0)
	catBtn.Paint = PaintButton

	local catLabel = vgui.Create("DLabelAutoScroll", catBtn)
	catLabel:SetFont("ZSHUDFontSmaller")
	catLabel:SetTextColor(COLOR_WHITE)
	catLabel:SetContentAlignment(5)
	catLabel:SetScrollingMode("time")
	catLabel:SetText("All")
	catLabel:Dock(FILL)
	catLabel:SetMouseInputEnabled(false)

	local categoryLabels = {
		[INVCAT_TRINKETS]    = "inventory_category_trinkets",
		[INVCAT_COMPONENTS]  = "inventory_category_components",
		[INVCAT_CONSUMABLES] = "inventory_category_consumables",
	}

	local function UpdateCategoryLabel()
		local key = categoryLabels[GAMEMODE.InvCategoryFilter] or "inventory_category_all"
		catLabel:SetText(translate.Get(key))
	end
	UpdateCategoryLabel()

	local catMenu
	local catMenuCloser
	local function CloseCategoryMenu()
		if IsValid(catMenu) then catMenu:Remove() end
		catMenu = nil
		if IsValid(catMenuCloser) then catMenuCloser:Remove() end
		catMenuCloser = nil
		if IsValid(frame) then
			frame:MakePopup()
		end
	end

	local function OpenCategoryMenu()
		CloseCategoryMenu()

		local entries = {{id = nil, label = translate.Get("inventory_category_all")}}
		if GAMEMODE:CategoryHasItems(INVCAT_TRINKETS) then
			entries[#entries + 1] = {id = INVCAT_TRINKETS,    label = translate.Get("inventory_category_trinkets")}
		end
		if GAMEMODE:CategoryHasItems(INVCAT_COMPONENTS) then
			entries[#entries + 1] = {id = INVCAT_COMPONENTS,  label = translate.Get("inventory_category_components")}
		end
		if GAMEMODE:CategoryHasItems(INVCAT_CONSUMABLES) then
			entries[#entries + 1] = {id = INVCAT_CONSUMABLES, label = translate.Get("inventory_category_consumables")}
		end

		catMenuCloser = vgui.Create("EditablePanel")
		catMenuCloser:SetSize(ScrW(), ScrH())
		catMenuCloser:SetPos(0, 0)
		catMenuCloser:SetMouseInputEnabled(true)
		catMenuCloser:SetKeyboardInputEnabled(false)
		catMenuCloser.Paint = function() end
		catMenuCloser.OnMousePressed = function(self, mc)
			CloseCategoryMenu()
			return true
		end
		catMenuCloser.Think = function(self)
			if not IsValid(frame) or not frame:IsVisible() then
				CloseCategoryMenu()
			end
		end
		catMenuCloser:MakePopup()

		local rowH = 22 * screenscale
		local menu = vgui.Create("DPanel", catMenuCloser)
		menu:SetMouseInputEnabled(true)
		menu:SetKeyboardInputEnabled(false)
		menu:SetZPos(100)
		menu:SetSize(catBtnW, #entries * rowH + 4)

		local bx, by = catBtn:LocalToScreen(0, 0)
		by = by + catBtn:GetTall() + 2
		menu:SetPos(bx, by)

		menu.Paint = function(me, w, h)
			draw.RoundedBox(2, 0, 0, w, h, Color(12, 12, 12, 252))
			surface.SetDrawColor(COLOR_WHITE)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		for i, e in ipairs(entries) do
			local btn = vgui.Create("DButton", menu)
			btn:SetText("")
			btn:SetSize(menu:GetWide() - 4, rowH)
			btn:SetPos(2, 2 + (i - 1) * rowH)

			local active = GAMEMODE.InvCategoryFilter == e.id

			btn.Paint = function(me, w, h)
				local bg = active and Color(60, 60, 60, 240)
					or (me.Hovered and Color(40, 40, 40, 240) or Color(20, 20, 20, 200))
				draw.RoundedBox(2, 0, 0, w, h, bg)
			end

			local lab = vgui.Create("DLabelAutoScroll", btn)
			lab:SetFont("ZSHUDFontSmaller")
			lab:SetTextColor(active and COLOR_WHITE or COLOR_GRAY)
			lab:SetContentAlignment(5)
			lab:SetScrollingMode("time")
			lab:SetText(e.label)
			lab:Dock(FILL)
			lab:SetMouseInputEnabled(false)

			btn.DoClick = function()
				CloseCategoryMenu()
				GAMEMODE:SetInvCategoryFilter(e.id)
				UpdateCategoryLabel()
			end
		end

		menu.OnMousePressed = function(me, mc)
			return false
		end

		catMenu = menu
	end

	catBtn.DoClick = function()
		if IsValid(catMenu) then
			CloseCategoryMenu()
		else
			OpenCategoryMenu()
		end
	end

	frame.CategoryButton = catBtn
	frame.UpdateCategoryLabel = UpdateCategoryLabel
	frame.CloseCategoryMenu = CloseCategoryMenu

	local sortBtn = vgui.Create("DButton", tabbar)
	sortBtn:SetText("")
	sortBtn:SetSize(sortBtnW, 24 * screenscale)
	sortBtn:SetPos(catBtnW + 4, 0)
	sortBtn.Paint = PaintButton

	local sortLabel = vgui.Create("DLabelAutoScroll", sortBtn)
	sortLabel:SetFont("ZSHUDFontSmaller")
	sortLabel:SetTextColor(COLOR_WHITE)
	sortLabel:SetContentAlignment(5)
	sortLabel:SetScrollingMode("time")
	sortLabel:Dock(FILL)
	sortLabel:SetMouseInputEnabled(false)

	local function UpdateSortLabel()
		local key = (GAMEMODE.InvSortMode == "received")
			and "inventory_sort_received"
			or  "inventory_sort_alpha"
		sortLabel:SetText(translate.Get(key))
	end
	UpdateSortLabel()

	sortBtn.DoClick = function()
		CloseCategoryMenu()
		GAMEMODE:SetInvSortMode(GAMEMODE.InvSortMode == "received" and "alpha" or "received")
	end

	frame.SortButton = sortBtn
	frame.UpdateSortLabel = UpdateSortLabel

	local invListPanel = vgui.Create("DScrollPanel", frame)
	invListPanel:Dock(FILL)
	local sbar = invListPanel:GetVBar()
	sbar.Enabled = true
	invListPanel:DockMargin(0, topspace:GetTall() + tabbar:GetTall() + 18, 0, 0)
	invListPanel:InvalidateParent(true)
	frame.ListPanel = invListPanel

	local invgrid = vgui.Create("DGrid", invListPanel)
	invgrid:SetSize(invListPanel:GetWide() - sbar:GetWide(), invListPanel:GetTall())
	invgrid:SetCols(5)
	invgrid:SetColWide((70 + (invgrid:GetWide() - 70*5) / 4) * screenscale)
	invgrid:SetRowHeight(70 * screenscale)
	frame.Grid = invgrid

	self.InvCategoryFilter = nil
	self:RefreshInventoryGrid()

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)
end
