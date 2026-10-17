local function pointslabelThink(self)
	local points = MySelf:GetPoints()
	if self.m_LastPoints ~= points then
		self.m_LastPoints = points

		self:SetText(translate.Format("points_to_spend_x", points))
		self:SizeToContents()
	end
end

-- Robust skill-name translation helper
function GM:GetSkillDisplayName(skillid)
    if not skillid then return nil end
    local skill = self.Skills and self.Skills[skillid]
    if not skill then return tostring(skillid) end

    -- translate.SkillName first tries the skill_name_<id> key itself,
    -- and if it doesn't exist — returns skill.Name.
    return translate.SkillName(skillid, skill)
end

function GM:GetShopItemDisplayName(tab)
	if not tab then return "" end

	if tab.SWEP then
		local wep = weapons.Get(tab.SWEP)
		if wep then return translate.WeaponName(wep) end
		local invdata = self.ZSInventoryItemData[tab.SWEP]
		if invdata and invdata.TranslationID then
			local translated = translate.ItemName(invdata.TranslationID, invdata.TranslationPrefix)
			if translated then return translated end
		end
	end

	-- "#key" — localization key. If DisplayCount is specified — substitute the number.
	local n = tab.Name or ""
	if string.sub(n, 1, 1) == "#" then
		local key = string.sub(n, 2)
		if tab.DisplayCount then
			return translate.Format(key, tab.DisplayCount)
		end
		return translate.Get(key)
	end

	return n
end

function GM:GetShopItemDisplayDesc(tab)
	if not tab then return "" end
	if tab.SWEP then
		local wep = weapons.Get(tab.SWEP)
		if wep then return translate.WeaponDesc(wep) end
		local invdata = self.ZSInventoryItemData[tab.SWEP]
		if invdata then
			return translate.ItemDescription(invdata, invdata.TranslationPrefix or "item")
		end
	end

	local d = tab.Description or ""
	if string.sub(d, 1, 1) == "#" then
		local key = string.sub(d, 2)
		if tab.DisplayCount then
			return translate.Format(key, tab.DisplayCount)
		end
		return translate.Get(key)
	end
	return d
end

local wasOpen = false
hook.Add("Think", "ArsenalMenuThink", function()
	local pan = GAMEMODE.ArsenalInterface
	local rem = GAMEMODE.RemantlerInterface

	local panValid = pan and pan:IsValid() and pan:IsVisible()
	local remValid = rem and rem:IsValid() and rem:IsVisible()
	local isOpen = panValid or remValid

	-- Close the open panel if the cursor has moved far beyond its bounds.
	local function CheckPanelClose(pnl)
		if not (pnl and pnl:IsValid() and pnl:IsVisible()) then return end

		local mx, my = gui.MousePos()
		local x, y = pnl:GetPos()
		if mx < x - 16 or my < y - 16
			or mx > x + pnl:GetWide() + 16
			or my > y + pnl:GetTall() + 16 then
			pnl:SetVisible(false)
			return true
		end
	end

	if panValid and CheckPanelClose(pan) then isOpen = false end
	if remValid and CheckPanelClose(rem) then isOpen = false end

	-- When closing the arsenal/remantler, close all open DMenus.
	if wasOpen and not isOpen then
		for _, pnl in ipairs(vgui.GetAll()) do
			if IsValid(pnl) and pnl.ClassName == "DMenu"
				and not pnl:IsMarkedForDeletion() then
				pnl:Remove()
			end
		end
	end

	wasOpen = isOpen
end)

local function ArsenalMenuCenterMouse(self)
	local x, y = self:GetPos()
	local w, h = self:GetSize()
	gui.SetMousePos(x + w / 2, y + h / 2)
end

local function worthmenuDoClick()
	MakepWorth()
	GAMEMODE.ArsenalInterface:Close()
end

local function CanBuy(item, pan)
	if item.NoClassicMode and GAMEMODE:IsClassicMode() then
		return false
	end

	if item.Tier and GAMEMODE.LockItemTiers and not GAMEMODE.ZombieEscape and not GAMEMODE.ObjectiveMap and not GAMEMODE:IsClassicMode() then
		if not GAMEMODE:GetWaveActive() then -- We can buy during the wave break before hand.
			if GAMEMODE:GetWave() + 1 < item.Tier then
				return false
			end
		elseif GAMEMODE:GetWave() < item.Tier then
			return false
		end
	end

	if item.MaxStock and not GAMEMODE:HasItemStocks(item.Signature) then
		return false
	end

	if not pan.NoPoints and MySelf:GetPoints() < math.floor(item.Price * (MySelf.ArsenalDiscount or 1)) then
		return false
	elseif pan.NoPoints and MySelf:GetAmmoCount("scrap") < math.ceil(GAMEMODE:PointsToScrap(item.Price)) then
		return false
	end

	return true
end

local function ItemPanelThink(self)
	local itemtab = FindItem(self.ID)
	if itemtab then
		local newstate = CanBuy(itemtab, self)
		if newstate ~= self.m_LastAbleToBuy then
			self.m_LastAbleToBuy = newstate
			if newstate then
				self.NameLabel:SetTextColor(COLOR_WHITE)
				self.NameLabel:InvalidateLayout()
			else
				self.NameLabel:SetTextColor(COLOR_RED)
				self.NameLabel:InvalidateLayout()
			end
		end

		if self.StockLabel then
			local stocks = GAMEMODE:GetItemStocks(self.ID)
			if stocks ~= self.m_LastStocks then
				self.m_LastStocks = stocks

				self.StockLabel:SetText(translate.Format("x_remaining", stocks))
				-- Size and position are fixed at creation time (see AddShopItem).
				-- SizeToContents/AlignRight here break the width constraint,
				-- so they were removed.
				self.StockLabel:SetTextColor(stocks > 0 and COLOR_GRAY or COLOR_RED)
				self.StockLabel:InvalidateLayout()
			end
		end
	end
end

local colBG = Color(20, 20, 20)
local function ItemPanelPaint(self, w, h)
	if self.Hovered or self.On then
		local outline
		if self.m_LastAbleToBuy then
			outline = self.Depressed and COLOR_GREEN or COLOR_DARKGREEN
		else
			outline = self.Depressed and COLOR_RED or COLOR_DARKRED
		end

		draw.RoundedBox(8, 0, 0, w, h, outline)
	end

	if self.ShopTabl.SWEP and MySelf:HasInventoryItem(self.ShopTabl.SWEP) then
		draw.RoundedBox(8, 2, 2, w - 4, h - 4, COLOR_RORANGE)
	end

	draw.RoundedBox(2, 4, 4, w - 8, h - 8, colBG)

	return true
end

function GM:ViewerStatBarUpdate(viewer, display, sweptable)
	local done, statshow = {}
	local speedtotext = GAMEMODE.SpeedToText
	for i = 1, 6 do
		if display then
			viewer.ItemStats[i]:SetText("")
			viewer.ItemStatValues[i]:SetText("")
			viewer.ItemStatBars[i]:SetVisible(false)
			continue
		end
		local statshowbef = statshow
		for k, stat in pairs(GAMEMODE.WeaponStatBarVals) do
			local statval = stat[6] and sweptable[stat[6]][stat[1]] or sweptable[stat[1]]
			if not done[stat] and statval and statval ~= -1 then
				if stat[1] == "ClipSize" and not sweptable.RequiredClip then
					continue
				end

				statshow = stat
				done[stat] = true

				break
			end
		end
		if statshowbef and statshowbef[1] == statshow[1] then
			viewer.ItemStats[i]:SetText("")
			viewer.ItemStatValues[i]:SetText("")
			viewer.ItemStatBars[i]:SetVisible(false)
			continue
		end

		local statnum, stattext = statshow[6] and sweptable[statshow[6]][statshow[1]] or sweptable[statshow[1]]
		if statshow[1] == "Damage" and sweptable.Primary.NumShots and sweptable.Primary.NumShots > 1 then
			stattext = statnum .. " x " .. sweptable.Primary.NumShots-- .. " (" .. (statnum * sweptable.Primary.NumShots) .. ")"
		elseif statshow[1] == "WalkSpeed" then
			-- SpeedToText now stores translation keys, not display strings.
			local speedkey = speedtotext[SPEED_NORMAL]
			if speedtotext[sweptable[statshow[1]]] then
				speedkey = speedtotext[sweptable[statshow[1]]]
			elseif sweptable[statshow[1]] < SPEED_SLOWEST then
				speedkey = speedtotext[-1]
			end
			stattext = translate.Get(speedkey)
		elseif statshow[1] == "ClipSize" then
			stattext = statnum / sweptable.RequiredClip
		else
			stattext = statnum
		end

		viewer.ItemStats[i]:SetText(translate.Get(statshow[2]))
		viewer.ItemStatValues[i]:SetText(stattext)

		if statshow[1] == "Damage" then
			statnum = statnum * sweptable.Primary.NumShots
		elseif statshow[1] == "ClipSize" then
			statnum = statnum / sweptable.RequiredClip
		end

		viewer.ItemStatBars[i].Stat = statnum
		viewer.ItemStatBars[i].StatMin = statshow[3]
		viewer.ItemStatBars[i].StatMax = statshow[4]
		viewer.ItemStatBars[i].BadHigh = statshow[5]
		viewer.ItemStatBars[i]:SetVisible(true)
	end
end

function GM:HasPurchaseableAmmo(sweptable)
	if sweptable and sweptable.Primary and self.AmmoToPurchaseNames[sweptable.Primary.Ammo] then
		return true
	end
end

function GM:SupplyItemViewerDetail(viewer, sweptable, shoptbl)
	if not (viewer and viewer:IsValid() and viewer.m_Title) then return end
	if not shoptbl then return end

	-- Ammunition and other items without SWEP: they only have Name/Description.
	if not sweptable then
		viewer.m_Title:SetText(self:GetShopItemDisplayName(shoptbl))

		viewer.ModelPanel:SetModel("")
		viewer.m_VBG:SetVisible(false)

		viewer.m_Desc:MoveBelow(viewer.m_Title, 20)
		viewer.m_Desc:SetFont("ZSBodyTextFontBig")
		viewer.m_Desc:SetText(self:GetShopItemDisplayDesc(shoptbl))

		self:ViewerStatBarUpdate(viewer, true, {})

		viewer.m_AmmoType:SetText("")
		viewer.m_AmmoIcon:SetVisible(false)
		return
	end

	local is_invitem = self.ZSInventoryItemData[shoptbl.SWEP] ~= nil
	local title, desctext
	if is_invitem then
		title = translate.ItemName(sweptable.TranslationID, sweptable.TranslationPrefix) or sweptable.PrintName
		desctext = translate.ItemDescription(sweptable, sweptable.TranslationPrefix or "item")
	else
		title = translate.WeaponName(sweptable)
		desctext = translate.WeaponDesc(sweptable) or ""
	end

	viewer.m_Title:SetText(title)

	if not is_invitem then
		viewer.ModelPanel:SetSWEPPreview(sweptable, GAMEMODE.ShowWElements ~= false)
		viewer.m_VBG:SetVisible(true)

		if sweptable.NoDismantle then
			desctext = desctext .. "\n" .. translate.Get("cannot_dismantle_scrap")
		end

		viewer.m_Desc:MoveBelow(viewer.m_VBG, 8)
		viewer.m_Desc:SetFont("ZSBodyTextFont")
	else
		viewer.ModelPanel:SetModel("")
		viewer.m_VBG:SetVisible(false)

		viewer.m_Desc:MoveBelow(viewer.m_Title, 20)
		viewer.m_Desc:SetFont("ZSBodyTextFontBig")
	end
	viewer.m_Desc:SetText(desctext)

	self:ViewerStatBarUpdate(viewer, shoptbl.Category ~= ITEMCAT_GUNS and shoptbl.Category ~= ITEMCAT_MELEE, sweptable)

	if self:HasPurchaseableAmmo(sweptable) and self.AmmoNames[string.lower(sweptable.Primary.Ammo)] then
		local lower = string.lower(sweptable.Primary.Ammo)

		viewer.m_AmmoType:SetText(translate.AmmoName(lower, "ps"))

		local ki = killicon.Get(self.AmmoIcons[lower])

		viewer.m_AmmoIcon:SetImage(ki[1])
		if ki[2] then viewer.m_AmmoIcon:SetImageColor(ki[2]) end

		viewer.m_AmmoIcon:SetVisible(true)
	else
		viewer.m_AmmoType:SetText("")
		viewer.m_AmmoIcon:SetVisible(false)
	end
end

local function ItemPanelDoClick(self)
	local shoptbl = self.ShopTabl
	local viewer = self.NoPoints and GAMEMODE.RemantlerInterface.TrinketsFrame.Viewer or GAMEMODE.ArsenalInterface.Viewer

	if not shoptbl then return end
	local sweptable = GAMEMODE.ZSInventoryItemData[shoptbl.SWEP] or weapons.Get(shoptbl.SWEP)

	if not sweptable or GAMEMODE.AlwaysQuickBuy then
		RunConsoleCommand("zs_pointsshopbuy", self.ID, self.NoPoints and "scrap")
		return
	end

	for _, v in pairs(self:GetParent():GetChildren()) do
		v.On = false
	end
	self.On = true

	GAMEMODE:SupplyItemViewerDetail(viewer, sweptable, shoptbl)

	local screenscale = BetterScreenScale()
	local canammo = GAMEMODE:HasPurchaseableAmmo(sweptable)

	local padding = 16 * screenscale
	local gap     = 8 * screenscale
	local minPurchaseW = 120 * screenscale
	local minAmmoW     = 70 * screenscale

	local ammoButton = viewer.m_AmmoB
	local ammoLabel  = viewer.m_AmmoL
	local ammoPrice  = viewer.m_AmmoPrice

	if canammo then
		ammoButton.AmmoType = GAMEMODE.AmmoToPurchaseNames[sweptable.Primary.Ammo]
		ammoButton.DoClick = function() RunConsoleCommand("zs_pointsshopbuy", "ps_"..ammoButton.AmmoType) end

		local ammosig = "ps_" .. ammoButton.AmmoType
		local ammoitem = GAMEMODE.Items[ammosig]
		local ammoPriceValue
		if ammoitem and ammoitem.Price then
			ammoPriceValue = math.floor(ammoitem.Price * (MySelf.ArsenalDiscount or 1))
		else
			ammoPriceValue = math.floor(9 * (MySelf.ArsenalDiscount or 1))
		end
		ammoPrice:SetText(translate.Format("price_points_fmt", ammoPriceValue))
		ammoPrice:SizeToContents()
		ammoLabel:SizeToContents()
	end

	local ammoRight = viewer:GetWide() * 0.875
	local ammoMaxW  = math.max(minAmmoW, ammoRight - 4 - (minPurchaseW + gap + 8))
	local ammoContentW = math.max(ammoLabel:GetWide(), math.min(ammoPrice:GetWide(), viewer:GetWide() * 0.4)) + padding * 2
	local ammoW = math.Clamp(ammoContentW, minAmmoW, ammoMaxW)
	ammoButton:SetWide(ammoW)

	local maxAmmoPriceW = ammoW - padding
	if ammoPrice:GetWide() > maxAmmoPriceW then
		ammoPrice:SetSize(maxAmmoPriceW, ammoPrice:GetTall())
	end

	local ammoX = ammoRight - ammoW
	ammoButton:SetPos(ammoX, viewer:GetTall() - 64 * screenscale)
	ammoButton:SetVisible(canammo)

	ammoLabel:SetPos(ammoW / 2 - ammoLabel:GetWide() / 2, ammoButton:GetTall() * 0.35 - ammoLabel:GetTall() * 0.5)
	ammoLabel:SetVisible(canammo)

	ammoPrice:SetPos(ammoW / 2 - ammoPrice:GetWide() / 2, ammoButton:GetTall() * 0.75 - ammoPrice:GetTall() * 0.5)
	ammoPrice:SetVisible(canammo)

	local purchaseButton = viewer.m_PurchaseB
	local purchaseLabel  = viewer.m_PurchaseLabel
	local purchasePrice  = viewer.m_PurchasePrice

	purchaseButton.ID = self.ID
	purchaseButton.DoClick = function() RunConsoleCommand("zs_pointsshopbuy", self.ID, self.NoPoints and "scrap") end
	purchaseLabel:SetVisible(true)

	local price = self.NoPoints and math.ceil(GAMEMODE:PointsToScrap(shoptbl.Worth)) or math.floor(shoptbl.Worth * (MySelf.ArsenalDiscount or 1))
	purchasePrice:SetText(translate.Format(self.NoPoints and "price_scrap_fmt" or "price_points_fmt", price))
	purchasePrice:SizeToContents()
	purchaseLabel:SizeToContents()

	local purchaseRight
	if canammo then
		purchaseRight = ammoX - gap
	else
		purchaseRight = viewer:GetWide() - 4
	end

	local purchaseAvailableW = math.max(40 * screenscale, purchaseRight - 4)
	local purchaseContentW = math.max(purchaseLabel:GetWide(), math.min(purchasePrice:GetWide(), viewer:GetWide() * 0.4)) + padding * 2
	local purchaseW = math.Clamp(purchaseContentW, math.min(minPurchaseW, purchaseAvailableW), purchaseAvailableW)
	purchaseButton:SetWide(purchaseW)

	local maxPurchasePriceW = purchaseW - padding
	if purchasePrice:GetWide() > maxPurchasePriceW then
		purchasePrice:SetSize(maxPurchasePriceW, purchasePrice:GetTall())
	end

	local purchaseX
	if canammo then
		purchaseX = purchaseRight - purchaseW
	else
		purchaseX = (viewer:GetWide() - purchaseW) * 0.5
	end

	purchaseButton:SetPos(purchaseX, viewer:GetTall() - 64 * screenscale)
	purchaseButton:SetVisible(true)

	purchaseLabel:SetPos(purchaseW / 2 - purchaseLabel:GetWide() / 2, purchaseButton:GetTall() * 0.35 - purchaseLabel:GetTall() * 0.5)
	purchasePrice:SetPos(purchaseW / 2 - purchasePrice:GetWide() / 2, purchaseButton:GetTall() * 0.75 - purchasePrice:GetTall() * 0.5)
	purchasePrice:SetVisible(true)
end

function GM:AttachKillicon(kitbl, itempan, mdlframe, ammo, missing_skill)
	local function imgAdj(img, maximgx, maximgy)
		img:SizeToContents()
		local iwidth, height = img:GetSize()
		if height > maximgy then
			img:SetSize(maximgy / height * img:GetWide(), maximgy)
			iwidth, height = img:GetSize()
		end
		if iwidth > maximgx then
			img:SetWidth(maximgx)
		end

		img:Center()
	end

	if #kitbl == 2 then
		local img = vgui.Create("DImage", mdlframe)
		img:SetImage(kitbl[1])
		if kitbl[2] then
			img:SetImageColor(kitbl[2])
		end
		if missing_skill then img:SetAlpha(50) end

		imgAdj(img, mdlframe:GetWide() - 6, mdlframe:GetTall() - 3)
		if ammo then img:SetSize(img:GetWide() + 3, img:GetTall() + 3) end

		img:Center()
		itempan.m_Icon = img
	elseif #kitbl == 3 then
		local label = vgui.Create("DLabel", mdlframe)
		label:SetText(kitbl[2])
		label:SetFont(kitbl[1] .. "pa" or DefaultFont)
		label:SetTextColor(kitbl[3] or color_white)
		label:SizeToContents()
		label:SetContentAlignment(8)
		label:DockMargin(0, label:GetTall() * 0.05, 0, 0)
		label:Dock(FILL)
		itempan.m_Icon = label
	end

	if missing_skill then
		local img = vgui.Create("DImage", mdlframe)
		img:SetImage("zombiesurvival/padlock.png")
		img:SetImageColor(Color(255, 30, 30))
		imgAdj(img, mdlframe:GetWide(), mdlframe:GetTall())

		img:Center()
		itempan.m_Padlock = img
	end
end

function GM:AddShopItem(list, i, tab, issub, nopointshop)
	local screenscale = BetterScreenScale()

	local nottrinkets = tab.Category ~= ITEMCAT_TRINKETS
	local reqskill = tab.SkillRequirement and GAMEMODE.Skills[tab.SkillRequirement]
	local missing_skill = tab.SkillRequirement and not MySelf:IsSkillActive(tab.SkillRequirement)
	local wid = 280

	local itempan = vgui.Create("DButton")
	itempan:SetText("")
	itempan:SetSize(wid * screenscale, (nottrinkets and 100 or 60) * screenscale)
	itempan.ID = tab.Signature or i
	itempan.NoPoints = nopointshop
	itempan.ShopTabl = tab
	itempan.Think = ItemPanelThink
	itempan.Paint = ItemPanelPaint
	itempan.DoClick = ItemPanelDoClick
	itempan.DoRightClick = function()
		local menu = DermaMenu(itempan)
		local opt = menu:AddOption(translate.Get("buy_option"), function()
			RunConsoleCommand("zs_pointsshopbuy", itempan.ID, itempan.NoPoints and "scrap") end)
		opt:SetTextColor(color_black)
		menu:SetBackgroundColor(Color(240, 240, 240, 255))
		menu:Open()
	end
	list:AddItem(itempan)

	if nottrinkets then
		local mdlframe = vgui.Create("DPanel", itempan)
		mdlframe:SetSize(wid/2 * screenscale, 100/2 * screenscale)
		mdlframe:SetPos(wid/4 * screenscale, 100/5 * screenscale)
		mdlframe:SetMouseInputEnabled(false)
		mdlframe.Paint = function() end

		local kitbl = killicon.Get(GAMEMODE.ZSInventoryItemData[tab.SWEP] and "weapon_zs_craftables" or tab.SWEP or tab.Model)
		if kitbl then
			self:AttachKillicon(kitbl, itempan, mdlframe, tab.Category == ITEMCAT_AMMO, missing_skill)
		elseif tab.Model then
			local mdlpanel = vgui.Create("DModelPanel", mdlframe)
			mdlpanel:SetSize(mdlframe:GetSize())
			mdlpanel:SetModel(tab.Model)
			local mins, maxs = mdlpanel.Entity:GetRenderBounds()
			mdlpanel:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
			mdlpanel:SetLookAt((mins + maxs) / 2)
		end
	end

	if tab.SWEP or tab.Countables then
		local counter = vgui.Create("ItemAmountCounter", itempan)
		counter:SetItemID(i)
	end

	local namelab = vgui.Create("DLabelAutoScroll", itempan)
	namelab:SetFont("ZSHUDFontSmaller")
	namelab:SetTextColor(COLOR_WHITE)
	namelab:SetScrollingMode("time")
	namelab:SetContentAlignment(4)
	namelab:SetText(self:GetShopItemDisplayName(tab))
	namelab:SetSize(
		itempan:GetWide() - 24 * screenscale,
		draw.GetFontHeight("ZSHUDFontSmaller") + 2
	)
	namelab:SetPos(
		12 * screenscale,
		itempan:GetTall() * (nottrinkets and 0.8 or 0.7) - namelab:GetTall() * 0.5
	)
	if missing_skill then
		namelab:SetAlpha(30)
	end
	itempan.NameLabel = namelab

	local alignri = (issub and (320 + 32) or (nopointshop and 32 or 20)) * screenscale

	local pricelabel = vgui.Create("DLabelAutoScroll", itempan)
	pricelabel:SetFont(ZS_TinyFontWithOutline())
	pricelabel:SetContentAlignment(8) -- right-aligned inside the label
	pricelabel:SetTextColor(COLOR_WHITE)
	pricelabel:SetScrollingMode("time")

	if missing_skill then
		pricelabel:SetTextColor(COLOR_RED)
		pricelabel:SetText(self:GetSkillDisplayName(tab.SkillRequirement) or translate.Get("missing_skill"))
	else
		local points = math.floor(tab.Price * (MySelf.ArsenalDiscount or 1))
		local price = tostring(points)
		if nopointshop then
			price = tostring(math.ceil(self:PointsToScrap(tab.Price)))
		end
		pricelabel:SetText(translate.Format(nopointshop and "price_scrap_fmt" or "price_points_fmt", price))
	end

	-- Stretch the bar to the left edge of the panel: long skill names
	-- will be fully visible, without the need for hovering/scrolling.
	-- Measure with the mixed font (see ZS_MeasureMixedText), otherwise for
	-- Cyrillic the width comes out huge and the label slides away.
	pricelabel:SizeToContents()
	pricelabel:AlignRight(alignri)

	if tab.MaxStock then
		-- DLabelAutoScroll instead of DLabel: if the text is wider than the
		-- available space, it scrolls inside its own frame but never
		-- overlaps the weapon icon.
		local stocklabel = vgui.Create("DLabelAutoScroll", itempan)
		stocklabel:SetFont("ZSHUDFontTiny")
		stocklabel:SetTextColor(COLOR_GRAY)
		stocklabel:SetScrollingMode("time")
		stocklabel:SetContentAlignment(6)  -- 6 = middle-right inside its own frame
		stocklabel:SetText(translate.Format("x_remaining", tab.MaxStock))

		-- Left border: right edge of the weapon icon + small gap.
		-- For trinkets there is no icon — then take the minimum margin from the edge.
		local iconLeft = nottrinkets
			and (wid / 4) * screenscale + 4 * screenscale
			or (4 * screenscale)

		-- Right border: as in the original — panel edge.
		local stockRight = itempan:GetWide() - 7 * screenscale

		local stockW = math.max(40 * screenscale, stockRight - iconLeft)
		local stockH = draw.GetFontHeight("ZSHUDFontTiny") + 2

		stocklabel:SetSize(stockW, stockH)
		stocklabel:SetPos(stockRight - stockW, itempan:GetTall() * 0.45 - stockH * 0.5)

		itempan.StockLabel = stocklabel
	end
	pricelabel:SetPos(
		itempan:GetWide() - pricelabel:GetWide() - 12 * screenscale,
		itempan:GetTall() * (nottrinkets and 0.15 or 0.3) - pricelabel:GetTall() * 0.5
	)

	if missing_skill or tab.NoClassicMode and isclassic or tab.NoZombieEscape and GAMEMODE.ZombieEscape then
		itempan:SetAlpha(160)
	end

	if not nottrinkets and tab.SubCategory then
		local catlabel = vgui.Create("DLabelAutoScroll", itempan)
		catlabel:SetFont(ZS_BodyTextFont())
		catlabel:SetTextColor(COLOR_WHITE)
		catlabel:SetScrollingMode("time")
		catlabel:SetContentAlignment(4)
		catlabel:SetText(translate.Get(GAMEMODE.ItemSubCategories[tab.SubCategory]))

		local catX = 10
		local catRightLimit = pricelabel:GetX() - 6 * screenscale
		local catW = math.max(20, catRightLimit - catX)

		catlabel:SetSize(catW, draw.GetFontHeight("ZSBodyTextFont") + 2)
		catlabel:SetPos(catX, itempan:GetTall() * 0.3 - catlabel:GetTall() * 0.5)
	end

	return itempan
end

function GM:ConfigureMenuTabs(tabs, tabhei, callback)
	local screenscale = BetterScreenScale()

	for _, tab in pairs(tabs) do
		tab:SetFont(screenscale > 0.85 and ZS_TinyFont() or "DefaultFontAA")
		tab.GetTabHeight = function()
			return tabhei
		end
		tab.PerformLayout = function(me)
			me:ApplySchemeSettings()

			if not me.Image then return end
			me.Image:SetPos(7, me:GetTabHeight()/2 - me.Image:GetTall()/2 + 3)
			me.Image:SetImageColor(Color(255, 255, 255, not me:IsActive() and 155 or 255))
		end
		tab.DoClick = function(me)
			me:GetPropertySheet():SetActiveTab(me)

			if callback then callback(tab) end
		end
	end
end

local PANEL = {}

PANEL.Stat = 50
PANEL.StatMin = 0
PANEL.StatMax = 100
PANEL.BadHigh = false
PANEL.LerpStat = 50
function PANEL:Init()
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
end

local matGradientLeft = CreateMaterial("gradient-l", "UnlitGeneric", {["$basetexture"] = "vgui/gradient-l", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1", ["$ignorez"] = "1", ["$nomip"] = "1"})
function PANEL:Paint(w, h)
	self.LerpStat = Lerp(FrameTime() * 4, self.LerpStat, self.Stat)
	local progress = math.Clamp((self.StatMax - self.LerpStat)/(self.StatMax - self.StatMin), 0, 1)
	if not self.BadHigh then
		progress = 1 - progress
	end

	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect(0, 0, w, 5)
	surface.SetDrawColor(250, 250, 250, 20)
	surface.DrawRect(math.min(w * 0.95, w * progress), 0, 1, 5)
	surface.SetDrawColor(200 * (1 - progress), 200 * progress, 10, 160)
	surface.SetMaterial(matGradientLeft)
	surface.DrawTexturedRect(0, 0, w * progress, 4)
end
vgui.Register("ZSItemStatBar", PANEL, "Panel")

function GM:CreateItemViewerGenericElems(viewer, scrollMode)
    local screenscale = BetterScreenScale()
    scrollMode = scrollMode or "time"

    local vtitle = EasyLabel(viewer, "", "ZSHUDFontSmaller", COLOR_GRAY)
    vtitle:SetContentAlignment(8)
    vtitle:SetSize(viewer:GetWide(), draw.GetFontHeight("ZSHUDFontSmaller") + 8 * screenscale)
    viewer.m_Title = vtitle

    local vammot = EasyLabel(viewer, "", "ZSBodyTextFontBig", COLOR_GRAY)
    vammot:SetContentAlignment(8)
    vammot:SetSize(viewer:GetWide(), draw.GetFontHeight("ZSBodyTextFontBig") + 4 * screenscale)
    vammot:MoveBelow(vtitle, 20)
    vammot:CenterHorizontal(0.35)
    viewer.m_AmmoType = vammot

    local vammoi = vgui.Create("DImage", viewer)
    vammoi:SetSize(40, 40)
    vammoi:MoveBelow(vtitle, 8)
    vammoi:CenterHorizontal(0.7)
    viewer.m_AmmoIcon = vammoi

    local vbg = vgui.Create("DPanel", viewer)
    vbg:SetSize(200 * screenscale, 100 * screenscale)
    vbg:CenterHorizontal()
    vbg:MoveBelow(vammot, 24)
    vbg:SetBackgroundColor(Color(0, 0, 0, 255))
    vbg:SetVisible(false)
    viewer.m_VBG = vbg

    local modelpanel = vgui.Create("DModelPanelEx", vbg)
    modelpanel:SetModel("")
    modelpanel:AutoCam()
    modelpanel:Dock(FILL)
    modelpanel:SetDirectionalLight(BOX_TOP, Color(100, 255, 100))
    modelpanel:SetDirectionalLight(BOX_FRONT, Color(255, 100, 100))
    viewer.ModelPanel = modelpanel

    local itemdesc = vgui.Create("DLabel", viewer)
    itemdesc:SetFont("ZSBodyTextFont")
    itemdesc:SetTextColor(COLOR_GRAY)
    itemdesc:SetMultiline(true)
    itemdesc:SetWrap(true)
    itemdesc:SetAutoStretchVertical(true)
    itemdesc:SetWide(viewer:GetWide() - 16)
    itemdesc:CenterHorizontal()
    itemdesc:SetText("")
    itemdesc:MoveBelow(vbg, 8)
    viewer.m_Desc = itemdesc

    -- Bar geometry (fractions of the viewer width) — same values as
    -- below in SetWide/CenterHorizontal for itemsb.
    local BAR_CENTER = 0.55
    local BAR_WIDTH  = 0.35
    local BAR_LEFT   = BAR_CENTER - BAR_WIDTH * 0.5   -- 0.375
    local BAR_RIGHT  = BAR_CENTER + BAR_WIDTH * 0.5   -- 0.725

    local edgeMargin  = 0 * screenscale   -- from the viewer edge
    local innerMargin = 3 * screenscale   -- between text and the bar

    -- Left column (stat names): from the left edge to the left edge of the bar.
    local statW = math.max(40, viewer:GetWide() * BAR_LEFT
                               - edgeMargin - innerMargin)
    local statX = edgeMargin

    -- Right column (values): from the right edge of the bar to the right edge of the viewer.
    local valW = math.max(40, viewer:GetWide() * (1 - BAR_RIGHT)
                              - edgeMargin - innerMargin)
    local valX = viewer:GetWide() * BAR_RIGHT + innerMargin

    local rowH = draw.GetFontHeight("ZSBodyTextFont") + 2

    local itemstats, itemsbs, itemsvs = {}, {}, {}
    for i = 1, 6 do
        -- Stat name: fills all the room to the left of the bar.
        -- For long text it scrolls inside this area
        -- (SetScissorRect in DLabelAutoScroll clips to its bounds).
        local itemstat = vgui.Create("DLabelAutoScroll", viewer)
        itemstat:SetFont("ZSBodyTextFont")
        itemstat:SetTextColor(COLOR_GRAY)
        itemstat:SetScrollingMode(scrollMode)
        itemstat:SetIgnoreRootBounds(true)
        itemstat:SetText("")
        itemstat:SetContentAlignment(8)
        itemstat:SetSize(statW, rowH)
        itemstat:SetX(statX)
        itemstat:MoveBelow(i == 1 and vbg or itemstats[i-1], (i == 1 and 100 or 8) * screenscale)
        table.insert(itemstats, itemstat)

        -- Bar — unchanged.
        local itemsb = vgui.Create("ZSItemStatBar", viewer)
        itemsb:SetWide(viewer:GetWide() * BAR_WIDTH)
        itemsb:SetTall(8 * screenscale)
        itemsb:CenterHorizontal(BAR_CENTER)
        itemsb:SetVisible(false)
        itemsb:MoveBelow(i == 1 and vbg or itemstats[i-1], ((i == 1 and 100 or 8) + 6) * screenscale)
        table.insert(itemsbs, itemsb)

        -- Value: fills all the room to the right of the bar.
        local itemsv = vgui.Create("DLabelAutoScroll", viewer)
        itemsv:SetFont("ZSBodyTextFont")
        itemsv:SetTextColor(COLOR_GRAY)
        itemsv:SetScrollingMode(scrollMode)
        itemsv:SetIgnoreRootBounds(true)
        itemsv:SetSize(valW, rowH)               -- ← вместо SetWide(...*0.3)
        itemsv:SetText("")
        itemsv:SetContentAlignment(8)
        itemsv:SetX(valX)                        -- ← вместо CenterHorizontal(0.85)
        itemsv:MoveBelow(i == 1 and vbg or itemstats[i-1], (i == 1 and 100 or 8) * screenscale)
        table.insert(itemsvs, itemsv)
    end
    viewer.ItemStats = itemstats
    viewer.ItemStatValues = itemsvs
    viewer.ItemStatBars = itemsbs
end

MENU_POINTSHOP = 1
MENU_WORTH = 2
MENU_REMANTLER = 3

function GM:CreateItemInfoViewer(frame, propertysheet, topspace, bottomspace, menutype)
	local __, topy = topspace:GetPos()
	local ___, boty = bottomspace:GetPos()
	local screenscale = BetterScreenScale()

	local worthmenu = menutype == MENU_WORTH
	local remantler = menutype == MENU_REMANTLER

	local viewer = vgui.Create("DPanel", frame)

	viewer:SetPaintBackground(false)
	viewer:SetSize(
		remantler and 320 * screenscale
			or frame:GetWide() - propertysheet:GetWide() + (worthmenu and 312 or -16) * screenscale,
		boty - topy - 8 - topspace:GetTall() - (worthmenu and 32 or 0)
	)

	viewer:MoveBelow(topspace, 4 + (worthmenu and 32 or 0))
	if menutype == MENU_POINTSHOP or worthmenu then
		viewer:MoveRightOf(propertysheet, 8 - (worthmenu and 328 or 0) * screenscale)
	else
		viewer:Dock(RIGHT)
	end
	frame.Viewer = viewer

	local scrollMode = (menutype == MENU_WORTH) and "cursor" or "time"
	self:CreateItemViewerGenericElems(viewer, scrollMode)

	local purchaseb = vgui.Create("DButton", viewer)
	purchaseb:SetText("")
	purchaseb:SetSize(viewer:GetWide() / 2, 54 * screenscale)
	purchaseb:SetVisible(false)
	viewer.m_PurchaseB = purchaseb

	local namelab = EasyLabel(purchaseb, translate.Get("purchase_button"), "ZSBodyTextFontBig", COLOR_WHITE)
	namelab:SetVisible(false)
	namelab:SetMouseInputEnabled(false)
	viewer.m_PurchaseLabel = namelab

	local pricelab = vgui.Create("DLabelAutoScroll", purchaseb)
	pricelab:SetFont("ZSBodyTextFont")
	pricelab:SetTextColor(COLOR_WHITE)
	pricelab:SetContentAlignment(5)
	pricelab:SetVisible(false)
	pricelab:SetMouseInputEnabled(false)
	viewer.m_PurchasePrice = pricelab

	local ammopb = vgui.Create("DButton", viewer)
	ammopb:SetText("")
	ammopb:SetSize(viewer:GetWide() / 4, 54 * screenscale)
	ammopb:SetVisible(false)
	viewer.m_AmmoB = ammopb

	namelab = EasyLabel(ammopb, translate.Get("ammo_button"), "ZSBodyTextFontBig", COLOR_WHITE)
	namelab:SetVisible(false)
	namelab:SetMouseInputEnabled(false)
	viewer.m_AmmoL = namelab

	pricelab = vgui.Create("DLabelAutoScroll", ammopb)
	pricelab:SetFont("ZSBodyTextFont")
	pricelab:SetTextColor(COLOR_WHITE)
	pricelab:SetContentAlignment(5)
	pricelab:SetVisible(false)
	pricelab:SetMouseInputEnabled(false)
	
	viewer.m_AmmoPrice = pricelab
end

function GM:OpenArsenalMenu()
	if self.ArsenalInterface and self.ArsenalInterface:IsValid() then
		self.ArsenalInterface:SetVisible(true)
		self.ArsenalInterface:CenterMouse()
		return
	end

	local screenscale = BetterScreenScale()
	local wid, hei = math.min(ScrW(), 900) * screenscale, math.min(ScrH(), 800) * screenscale
    local tabhei = ZS_GetTabHeight and ZS_GetTabHeight(screenscale, 24 * screenscale) or 24 * screenscale

	local frame = vgui.Create("DFrame")
	frame:SetSize(wid, hei)
	frame:Center()
	frame:SetDeleteOnClose(false)
	frame:SetTitle(" ")
	frame:SetDraggable(false)
	if frame.btnClose and frame.btnClose:IsValid() then frame.btnClose:SetVisible(false) end
	if frame.btnMinim and frame.btnMinim:IsValid() then frame.btnMinim:SetVisible(false) end
	if frame.btnMaxim and frame.btnMaxim:IsValid() then frame.btnMaxim:SetVisible(false) end
	frame.CenterMouse = ArsenalMenuCenterMouse
	self.ArsenalInterface = frame

	local topspace = vgui.Create("DPanel", frame)
	topspace:SetWide(wid - 16)

	local title = EasyLabel(topspace, translate.Get("points_shop_title"), "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()
	local subtitle = EasyLabel(topspace, translate.Get("points_shop_subtitle"), "ZSHUDFontTiny", COLOR_WHITE)
	subtitle:CenterHorizontal()
	subtitle:MoveBelow(title, 4)

	local _, y = subtitle:GetPos()
	topspace:SetTall(y + subtitle:GetTall() + 4)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local wsb = EasyButton(topspace, translate.Get("worth_menu_button"), 8, 4)
	wsb:SetFont("ZSHUDFontSmaller")
	wsb:SizeToContents()
	wsb:AlignRight(8)
	wsb:AlignTop(8)
	wsb.DoClick = worthmenuDoClick

	local bottomspace = vgui.Create("DPanel", frame)
	bottomspace:SetWide(topspace:GetWide())

	local pointslabel = EasyLabel(bottomspace, translate.Format("points_to_spend_x", 0), "ZSHUDFontTiny", COLOR_GREEN)
	pointslabel:AlignTop(4)
	pointslabel:AlignLeft(8)
	pointslabel.Think = pointslabelThink

	local lab = EasyLabel(bottomspace, " ", "ZSHUDFontTiny")
	lab:AlignTop(4)
	lab:AlignRight(4)
	frame.m_SpacerBottomLabel = lab

	_, y = lab:GetPos()
	bottomspace:SetTall(y + lab:GetTall() + 4)
	bottomspace:AlignBottom(8)
	bottomspace:CenterHorizontal()

	local __, topy = topspace:GetPos()
	local ___, boty = bottomspace:GetPos()

	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:SetSize(wid - 320 * screenscale, boty - topy - 8 - topspace:GetTall())
	propertysheet:MoveBelow(topspace, 4)
	propertysheet:SetPadding(1)
	propertysheet:CenterHorizontal(0.33)

	for catid, catname in ipairs(GAMEMODE.ItemCategories) do
		local hasitems = false
		for i, tab in ipairs(GAMEMODE.Items) do
			if tab.Category == catid and tab.PointShop then
				hasitems = true
				break
			end
		end

		if hasitems then
			local tabpane = vgui.Create("DPanel", propertysheet)
			tabpane.Paint = function() end
			tabpane.Grids = {}
			tabpane.Buttons = {}

			local usecats = catid == ITEMCAT_GUNS or catid == ITEMCAT_MELEE or catid == ITEMCAT_TRINKETS
			local trinkets = catid == ITEMCAT_TRINKETS
			local offset = 64 * screenscale

			local itemframe = vgui.Create("DScrollPanel", tabpane)
			itemframe:SetSize(propertysheet:GetWide(), propertysheet:GetTall() - (usecats and (32 + offset) or 32))
			itemframe:SetPos(0, usecats and offset or 0)

			local mkgrid = function()
				local list = vgui.Create("DGrid", itemframe)
				list:SetPos(0, 0)
				list:SetSize(propertysheet:GetWide() - 312, propertysheet:GetTall())
				list:SetCols(2)
				list:SetColWide(280 * screenscale)
				list:SetRowHeight((trinkets and 64 or 100) * screenscale)

				return list
			end

			local subcats = GAMEMODE.ItemSubCategories
			if usecats then
				local ind = 1
				local numCats = trinkets and #subcats or 5
				local perRow = trinkets and 3 or 5

				-- Pass 1: build all buttons / grids, remember them. Layout
				-- is done afterwards so we can use each button's measured
				-- width (translations differ a lot in length).
				for i = ind, numCats do
					local start = i == (catid == ITEMCAT_GUNS and 2 or ind)

					local tbn = EasyButton(tabpane, trinkets and translate.Get(subcats[i]) or translate.Format("tier_x", i), 2, 8)
					tbn:SetFont(trinkets and ZS_SmallestFont() or ZS_SmallFont())
					tbn:SetAlpha(start and 255 or 70)
					tbn:SetContentAlignment(5)
					tbn:SizeToContents()
					tbn.DoClick = function(me)
						for k, v in pairs(tabpane.Grids) do
							v:SetVisible(k == i)
							tabpane.Buttons[k]:SetAlpha(k == i and 255 or 70)
						end
					end

					tabpane.Grids[i] = mkgrid()
					tabpane.Grids[i]:SetVisible(start)
					tabpane.Buttons[i] = tbn
				end

				-- Pass 2 postponed: DPropertySheet sets the sizes of its
				-- panels only on its next layout, so
				-- tabpane:GetWide() here == 0. Arrange the buttons
				-- through PerformLayout, when the width is already real.
				local catStep     = (trinkets and 190 or 110) * screenscale
				local catLeftPad  = 15 * screenscale
				local catRightPad = 15 * screenscale
				local catGap      = 8 * screenscale

				local baseFonts = trinkets
					and {ZS_SmallestFont(), ZS_TinyFont()}
					or  {ZS_SmallFont(), ZS_SmallerFont(), ZS_SmallestFont(), ZS_TinyFont()}

				local capturedInd     = ind
				local capturedNumCats = numCats
				local capturedPerRow  = perRow

				local origLayout = tabpane.PerformLayout
				tabpane.PerformLayout = function(me)
					if origLayout then origLayout(me) end
					if me._DoingCatsLayout then return end
					me._DoingCatsLayout = true

					local panelW = me:GetWide()
					if panelW > 0 then
						local rows = math.ceil(capturedNumCats / capturedPerRow)

						for rowIdx = 1, rows do
							local first = capturedInd + (rowIdx - 1) * capturedPerRow
							local last  = math.min(first + capturedPerRow - 1, capturedNumCats)
							local ids = {}
							for i = first, last do
								if me.Buttons[i] then ids[#ids + 1] = i end
							end

							if #ids > 0 then
								local yPos = trinkets and ((rowIdx - 1) * 28) or 16

								-- Original layout fits if all buttons except
								-- the last are not wider than catStep (otherwise
								-- they overlap the neighbor) and the leftmost one
								-- doesn't go past catLeftPad.
								local function OrigFits()
									for k = 1, #ids - 1 do
										if me.Buttons[ids[k]]:GetWide() > catStep then return false end
									end
									local leftX = panelW - catRightPad - (#ids - 1) * catStep - me.Buttons[ids[1]]:GetWide()
									return leftX >= catLeftPad
								end

								local function TightFits()
									local totalW = 0
									for _, i in ipairs(ids) do totalW = totalW + me.Buttons[i]:GetWide() end
									totalW = totalW + (#ids - 1) * catGap
									return totalW <= panelW - catLeftPad - catRightPad
								end

								local mode = nil
								for _, f in ipairs(baseFonts) do
									for _, i in ipairs(ids) do
										if me.Buttons[i]._LastCatFont ~= f then
											me.Buttons[i]:SetFont(f)
											me.Buttons[i]:SizeToContents()
											me.Buttons[i]._LastCatFont = f
										end
									end
									if OrigFits() then mode = "orig" break end
									if TightFits() then mode = "tight" break end
								end
								if not mode then mode = "tight" end

								if mode == "orig" then
									-- 1:1 with the original. For English we always
									-- land here.
									local rightEdge = panelW - catRightPad
									for idx = #ids, 1, -1 do
										local i = ids[idx]
										local w = me.Buttons[i]:GetWide()
										me.Buttons[i]:SetPos(math.max(catLeftPad, rightEdge - w), yPos)
										rightEdge = rightEdge - catStep
									end
								else
									-- Tight layout: real widths + gap, no overlaps.
									local rightEdge = panelW - catRightPad
									for idx = #ids, 1, -1 do
										local i = ids[idx]
										local w = me.Buttons[i]:GetWide()
										me.Buttons[i]:SetPos(rightEdge - w, yPos)
										rightEdge = rightEdge - w - catGap
									end
								end
							end
						end
					end

					me._DoingCatsLayout = nil
				end
			else
				tabpane.Grid = mkgrid()
			end

			local sheet = propertysheet:AddSheet(translate.Get(catname), tabpane, GAMEMODE.ItemCategoryIcons[catid], false, false)
			sheet.Panel:SetPos(0, tabhei + 2)

			for i, tab in ipairs(GAMEMODE.Items) do
				if tab.PointShop and tab.Category == catid then
					self:AddShopItem(
						trinkets and tabpane.Grids[tab.SubCategory] or tabpane.Grid or tabpane.Grids[tab.Tier or 1],
						i, tab
					)
				end
			end

			local scroller = propertysheet:GetChildren()[1]
			local dragbase = scroller:GetChildren()[1]
			local tabs = dragbase:GetChildren()

			self:ConfigureMenuTabs(tabs, tabhei)
		end
	end

	self:CreateItemInfoViewer(frame, propertysheet, topspace, bottomspace, MENU_POINTSHOP)

	frame:MakePopup()
	frame:CenterMouse()
end
