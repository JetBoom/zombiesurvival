local function pointslabelThink(self)
	local points = MySelf:GetPoints()
	if self.m_LastPoints ~= points then
		self.m_LastPoints = points

		self:SetText("Points to spend: "..points)
		self:SizeToContents()
	end
end

hook.Add("Think", "ArsenalMenuThink", function()
	local pan = GAMEMODE.ArsenalInterface
	if pan and pan:IsValid() and pan:IsVisible() then
		local mx, my = gui.MousePos()
		local x, y = pan:GetPos()
		if mx < x - 16 or my < y - 16 or mx > x + pan:GetWide() + 16 or my > y + pan:GetTall() + 16 then
			pan:SetVisible(false)
		end
	end
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

				self.StockLabel:SetText(stocks.." remaining")
				self.StockLabel:SizeToContents()
				self.StockLabel:AlignRight(10)
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
			stattext = speedtotext[SPEED_NORMAL]
			if speedtotext[sweptable[statshow[1]]] then
				stattext = speedtotext[sweptable[statshow[1]]]
			elseif sweptable[statshow[1]] < SPEED_SLOWEST then
				stattext = speedtotext[-1]
			end
		elseif statshow[1] == "ClipSize" then
			stattext = statnum / sweptable.RequiredClip
		else
			stattext = statnum
		end

		viewer.ItemStats[i]:SetText(statshow[2])
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
	if sweptable.Primary and self.AmmoToPurchaseNames[sweptable.Primary.Ammo] then
		return true
	end
end

function GM:SupplyItemViewerDetail(viewer, sweptable, shoptbl)
	viewer.m_Title:SetText(sweptable.PrintName)
	viewer.m_Title:PerformLayout()

	local desctext = sweptable.Description or ""
	if not self.ZSInventoryItemData[shoptbl.SWEP] then
		viewer.ModelPanel:SetModel(sweptable.WorldModel)
		local mins, maxs = viewer.ModelPanel.Entity:GetRenderBounds()
		viewer.ModelPanel:SetCamPos(mins:Distance(maxs) * Vector(1.15, 0.75, 0.5))
		viewer.ModelPanel:SetLookAt((mins + maxs) / 2)
		viewer.m_VBG:SetVisible(true)

		if sweptable.NoDismantle then
			desctext = desctext .. "\nCannot be dismantled for scrap."
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

		viewer.m_AmmoType:SetText(self.AmmoNames[lower])
		viewer.m_AmmoType:PerformLayout()

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

	local purb = viewer.m_PurchaseB
	purb.ID = self.ID
	purb.DoClick = function() RunConsoleCommand("zs_pointsshopbuy", self.ID, self.NoPoints and "scrap") end
	purb:SetPos(canammo and viewer:GetWide() / 4 - viewer:GetWide() / 8 - 20 or viewer:GetWide() / 4, viewer:GetTall() - 64 * screenscale)
	purb:SetVisible(true)

	local purl = viewer.m_PurchaseLabel
	purl:SetPos(purb:GetWide() / 2 - purl:GetWide() / 2, purb:GetTall() * 0.35 - purl:GetTall() * 0.5)
	purl:SetVisible(true)

	local ppurbl = viewer.m_PurchasePrice
	local price = self.NoPoints and math.ceil(GAMEMODE:PointsToScrap(shoptbl.Worth)) or math.floor(shoptbl.Worth * (MySelf.ArsenalDiscount or 1))
	ppurbl:SetText(price .. (self.NoPoints and " Scrap" or " Points"))
	ppurbl:SizeToContents()
	ppurbl:SetPos(purb:GetWide() / 2 - ppurbl:GetWide() / 2, purb:GetTall() * 0.75 - ppurbl:GetTall() * 0.5)
	ppurbl:SetVisible(true)

	purb = viewer.m_AmmoB
	if canammo then
		purb.AmmoType = GAMEMODE.AmmoToPurchaseNames[sweptable.Primary.Ammo]
		purb.DoClick = function() RunConsoleCommand("zs_pointsshopbuy", "ps_"..purb.AmmoType) end
	end
	purb:SetPos(viewer:GetWide() * (3/4) - purb:GetWide() / 2, viewer:GetTall() - 64 * screenscale)
	purb:SetVisible(canammo)

	purl = viewer.m_AmmoL
	purl:SetPos(purb:GetWide() / 2 - purl:GetWide() / 2, purb:GetTall() * 0.35 - purl:GetTall() * 0.5)
	purl:SetVisible(canammo)

	ppurbl = viewer.m_AmmoPrice
	price = math.floor(9 * (MySelf.ArsenalDiscount or 1))
	ppurbl:SetText(price .. " Points")
	ppurbl:SizeToContents()
	ppurbl:SetPos(purb:GetWide() / 2 - ppurbl:GetWide() / 2, purb:GetTall() * 0.75 - ppurbl:GetTall() * 0.5)
	ppurbl:SetVisible(canammo)
end

local function ArsenalMenuThink(self)
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
		menu:AddOption("Buy", function() RunConsoleCommand("zs_pointsshopbuy", itempan.ID, itempan.NoPoints and "scrap") end)
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
			if tab.Model then
				local mdlpanel = vgui.Create("DModelPanel", mdlframe)
				mdlpanel:SetSize(mdlframe:GetSize())
				mdlpanel:SetModel(tab.Model)
				local mins, maxs = mdlpanel.Entity:GetRenderBounds()
				mdlpanel:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
				mdlpanel:SetLookAt((mins + maxs) / 2)
			end
		end
	end

	if tab.SWEP or tab.Countables then
		local counter = vgui.Create("ItemAmountCounter", itempan)
		counter:SetItemID(i)
	end

	local name = tab.Name or ""
	local namelab = EasyLabel(itempan, name, "ZSHUDFontSmaller", COLOR_WHITE)
	namelab:SetPos(12 * screenscale, itempan:GetTall() * (nottrinkets and 0.8 or 0.7) - namelab:GetTall() * 0.5)
	if missing_skill then
		namelab:SetAlpha(30)
	end
	itempan.NameLabel = namelab

	local alignri = (issub and (320 + 32) or (nopointshop and 32 or 20)) * screenscale

	local pricelabel = EasyLabel(itempan, "", "ZSHUDFontTiny")
	if missing_skill then
		pricelabel:SetTextColor(COLOR_RED)
		pricelabel:SetText(GAMEMODE.Skills[tab.SkillRequirement].Name)
	else
		local points = math.floor(tab.Price * (MySelf.ArsenalDiscount or 1))
		local price = tostring(points)
		if nopointshop then
			price = tostring(math.ceil(self:PointsToScrap(tab.Price)))
		end
		pricelabel:SetText(price..(nopointshop and " Scrap" or " Points"))
	end
	pricelabel:SizeToContents()
	pricelabel:AlignRight(alignri)

	if tab.MaxStock then
		local stocklabel = EasyLabel(itempan, tab.MaxStock.." remaining", "ZSHUDFontTiny")
		stocklabel:SizeToContents()
		stocklabel:AlignRight(alignri)
		stocklabel:SetPos(itempan:GetWide() - stocklabel:GetWide(), itempan:GetTall() * 0.45 - stocklabel:GetTall() * 0.5)
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
		local catlabel = EasyLabel(itempan, GAMEMODE.ItemSubCategories[tab.SubCategory], "ZSBodyTextFont")
		catlabel:SizeToContents()
		catlabel:SetPos(10, itempan:GetTall() * 0.3 - catlabel:GetTall() * 0.5)
	end

	return itempan
end

function GM:ConfigureMenuTabs(tabs, tabhei, callback)
	local screenscale = BetterScreenScale()

	for _, tab in pairs(tabs) do
		tab:SetFont(screenscale > 0.85 and "ZSHUDFontTiny" or "DefaultFontAA")
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

function GM:CreateItemViewerGenericElems(viewer)
	local screenscale = BetterScreenScale()

	local vtitle = EasyLabel(viewer, "", "ZSHUDFontSmaller", COLOR_GRAY)
	vtitle:SetContentAlignment(8)
	vtitle:SetSize(viewer:GetWide(), 24 * screenscale)
	viewer.m_Title = vtitle

	local vammot = EasyLabel(viewer, "", "ZSBodyTextFontBig", COLOR_GRAY)
	vammot:SetContentAlignment(8)
	vammot:SetSize(viewer:GetWide(), 16 * screenscale)
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

	local itemstats, itemsbs, itemsvs = {}, {}, {}
	for i = 1, 6 do
		local itemstat = vgui.Create("DLabel", viewer)
		itemstat:SetFont("ZSBodyTextFont")
		itemstat:SetTextColor(COLOR_GRAY)
		itemstat:SetWide(viewer:GetWide() * 0.35)
		itemstat:SetText("")
		itemstat:CenterHorizontal(0.2)
		itemstat:SetContentAlignment(8)
		itemstat:MoveBelow(i == 1 and vbg or itemstats[i-1], (i == 1 and 100 or 8) * screenscale)
		table.insert(itemstats, itemstat)

		local itemsb = vgui.Create("ZSItemStatBar", viewer)
		itemsb:SetWide(viewer:GetWide() * 0.35)
		itemsb:SetTall(8 * screenscale)
		itemsb:CenterHorizontal(0.55)
		itemsb:SetVisible(false)
		itemsb:MoveBelow(i == 1 and vbg or itemstats[i-1], ((i == 1 and 100 or 8) + 6) * screenscale)
		table.insert(itemsbs, itemsb)

		local itemsv = vgui.Create("DLabel", viewer)
		itemsv:SetFont("ZSBodyTextFont")
		itemsv:SetTextColor(COLOR_GRAY)
		itemsv:SetWide(viewer:GetWide() * 0.3)
		itemsv:SetText("")
		itemsv:CenterHorizontal(0.85)
		itemsv:SetContentAlignment(8)
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

	self:CreateItemViewerGenericElems(viewer)

	local purchaseb = vgui.Create("DButton", viewer)
	purchaseb:SetText("")
	purchaseb:SetSize(viewer:GetWide() / 2, 54 * screenscale)
	purchaseb:SetVisible(false)
	viewer.m_PurchaseB = purchaseb

	local namelab = EasyLabel(purchaseb, "Purchase", "ZSBodyTextFontBig", COLOR_WHITE)
	namelab:SetVisible(false)
	viewer.m_PurchaseLabel = namelab

	local pricelab = EasyLabel(purchaseb, "", "ZSBodyTextFont", COLOR_WHITE)
	pricelab:SetVisible(false)
	viewer.m_PurchasePrice = pricelab

	local ammopb = vgui.Create("DButton", viewer)
	ammopb:SetText("")
	ammopb:SetSize(viewer:GetWide() / 4, 54 * screenscale)
	ammopb:SetVisible(false)
	viewer.m_AmmoB = ammopb

	namelab = EasyLabel(ammopb, "Ammo", "ZSBodyTextFontBig", COLOR_WHITE)
	namelab:SetVisible(false)
	viewer.m_AmmoL = namelab

	pricelab = EasyLabel(ammopb, "", "ZSBodyTextFont", COLOR_WHITE)
	pricelab:SetVisible(false)
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
	local tabhei = 24 * screenscale

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
	frame.Think = ArsenalMenuThink
	self.ArsenalInterface = frame

	local topspace = vgui.Create("DPanel", frame)
	topspace:SetWide(wid - 16)

	local title = EasyLabel(topspace, "The Points Shop", "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()
	local subtitle = EasyLabel(topspace, "For all of your zombie apocalypse needs!", "ZSHUDFontTiny", COLOR_WHITE)
	subtitle:CenterHorizontal()
	subtitle:MoveBelow(title, 4)

	local _, y = subtitle:GetPos()
	topspace:SetTall(y + subtitle:GetTall() + 4)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local wsb = EasyButton(topspace, "Worth Menu", 8, 4)
	wsb:SetFont("ZSHUDFontSmaller")
	wsb:SizeToContents()
	wsb:AlignRight(8)
	wsb:AlignTop(8)
	wsb.DoClick = worthmenuDoClick

	local bottomspace = vgui.Create("DPanel", frame)
	bottomspace:SetWide(topspace:GetWide())

	local pointslabel = EasyLabel(bottomspace, "Points to spend: 0", "ZSHUDFontTiny", COLOR_GREEN)
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
				local ind, tbn = 1
				for i = ind, (trinkets and #subcats or 5) do
					local ispacer = trinkets and ((i-1) % 3)+1 or i
					local start = i == (catid == ITEMCAT_GUNS and 2 or ind)

					tbn = EasyButton(tabpane, trinkets and subcats[i] or ("Tier " .. i), 2, 8)
					tbn:SetFont(trinkets and "ZSHUDFontSmallest" or "ZSHUDFontSmall")
					tbn:SetAlpha(start and 255 or 70)
					tbn:AlignRight((trinkets and -35 or -15) * screenscale -
						(ispacer - ind) * (ind == 1 and (trinkets and 190 or 110) or 145) * screenscale
					)
					tbn:AlignTop(trinkets and i <= 3 and 0 or trinkets and 28 or 16)
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
			else
				tabpane.Grid = mkgrid()
			end

			local sheet = propertysheet:AddSheet(catname, tabpane, GAMEMODE.ItemCategoryIcons[catid], false, false)
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
