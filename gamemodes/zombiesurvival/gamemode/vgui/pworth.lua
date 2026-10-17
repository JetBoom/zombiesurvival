function InitialWorthMenu()
	timer.Create("WaitUntilSkillsLoaded", 0, 0, function()
		if GAMEMODE.ReceivedInitialSkills then
			timer.Remove("WaitUntilSkillsLoaded")
			MakepWorth()
		end
	end)
end

hook.Add("SetWave", "CloseWorthOnWave1", function(wave)
	if wave > 0 then
		if pWorth and pWorth:IsValid() then
			pWorth:Close()
		end

		hook.Remove("SetWave", "CloseWorthOnWave1")
	end
end)

local ExtraStartingWorth = 0
local function GetStartingWorth()
	return GAMEMODE.StartingWorth + ExtraStartingWorth
end

net.Receive("zs_extrastartingworth", function(len)
	ExtraStartingWorth = net.ReadUInt(16)
end)

local cvarDefaultCart = CreateClientConVar("zs_defaultcart", "", true, false)

local function DefaultDoClick(btn)
	if cvarDefaultCart:GetString() == btn.Name then
		RunConsoleCommand("zs_defaultcart", "")
		surface.PlaySound("buttons/button11.wav")
	else
		RunConsoleCommand("zs_defaultcart", btn.Name)
		surface.PlaySound("buttons/button14.wav")
	end

	timer.Simple(0.1, MakepWorth)
end

local remainingworth = 0
local WorthButtons = {}

local function Checkout(tobuy)
	if tobuy and #tobuy > 0 then
		gamemode.Call("SuppressArsenalUpgrades", 1)

		RunConsoleCommand("worthcheckout", unpack(tobuy))

		if pWorth and pWorth:IsValid() then
			pWorth:Close()
		end
	else
		surface.PlaySound("buttons/combine_button_locked.wav")
	end
end

local function CheckoutDoClick(self)
	local tobuy = {}
	for _, btn in pairs(WorthButtons) do
		if btn and btn.On and btn.ID then
			table.insert(tobuy, btn.ID)
		end
	end

	if remainingworth >= 0 then
		Checkout(tobuy)
	else
		surface.PlaySound("buttons/button8.wav")
	end
end

local function RandDoClick(self)
	gamemode.Call("SuppressArsenalUpgrades", 1)

	RunConsoleCommand("worthrandom")

	if pWorth and pWorth:IsValid() then
		pWorth:Close()
	end
end

GM.SavedCarts = {}
hook.Add("Initialize", "LoadCarts", function()
	if file.Exists(GAMEMODE.CartFile, "DATA") then
		GAMEMODE.SavedCarts = Deserialize(file.Read(GAMEMODE.CartFile)) or {}
	end
end)

local function ClearCartDoClick()
	for _, btn in ipairs(WorthButtons) do
		if btn.On then
			btn:DoClick(true, true)
		end
	end

	surface.PlaySound("buttons/button11.wav")
end

local function ClickWorthButton(id)
	local result = true
	for _, btn in pairs(WorthButtons) do
		if not btn then continue end

		if btn.ID == id or btn.Signature == id then
			result = btn:DoClick(true, true)
			break
		end
	end
	return result
end

local function LoadCart(cartid, silent)
	if not GAMEMODE.SavedCarts[cartid] then return end

	MakepWorth()

	for _, id in pairs(GAMEMODE.SavedCarts[cartid][2]) do
		if not ClickWorthButton(id) then
			surface.PlaySound("buttons/button8.wav")
			return false
		end
	end

	if not silent then
		surface.PlaySound("buttons/combine_button1.wav")
	end

	return true
end

local function LoadDoClick(self)
	LoadCart(self.ID)
end

local function SaveCurrentCart(name)
	local tobuy = {}
	for _, btn in pairs(WorthButtons) do
		if btn and btn.On and btn.ID then
			table.insert(tobuy, FindStartingItem(btn.ID).Signature)
		end
	end

	for i, cart in ipairs(GAMEMODE.SavedCarts) do
		if string.lower(cart[1]) == string.lower(name) then
			cart[1] = name
			cart[2] = tobuy

			file.Write(GAMEMODE.CartFile, Serialize(GAMEMODE.SavedCarts))
			print("Saved cart "..tostring(name))

			LoadCart(i, true)
			return
		end
	end

	GAMEMODE.SavedCarts[#GAMEMODE.SavedCarts + 1] = {name, tobuy}

	file.Write(GAMEMODE.CartFile, Serialize(GAMEMODE.SavedCarts))
	print("Saved cart "..tostring(name))

	LoadCart(#GAMEMODE.SavedCarts, true)
end

local function SaveDoClick(self)
	local frame = Derma_StringRequest(translate.Get("save_cart_title"), translate.Get("save_cart_prompt"), translate.Get("save_cart_default"),
	function(strTextOut) SaveCurrentCart(strTextOut) end,
	function(strTextOut) end,
	translate.Get("okay_button"), translate.Get("cancel_button"))

	frame:GetChildren()[5]:GetChildren()[2]:SetTextColor(Color(30, 30, 30))
end

local function DeleteDoClick(self)
	if GAMEMODE.SavedCarts[self.ID] then
		table.remove(GAMEMODE.SavedCarts, self.ID)
		file.Write(GAMEMODE.CartFile, Serialize(GAMEMODE.SavedCarts))
		surface.PlaySound("buttons/button19.wav")
		MakepWorth()
	end
end

local function QuickCheckDoClick(self)
	if GAMEMODE.SavedCarts[self.ID] and LoadCart(self.ID, true) then
		Checkout(GAMEMODE.SavedCarts[self.ID][2])
	end
end

local function WorthThink(self)
	if MySelf:Team() ~= TEAM_HUMAN then
		self:Close()
	end
end

function MakepWorth()
	if pWorth and pWorth:IsValid() then
		pWorth:Remove()
		pWorth = nil
	end

	remainingworth = GetStartingWorth()

	local screenscale = BetterScreenScale()
	local wid, hei = math.min(ScrW(), 900) * screenscale, math.min(ScrH(), 800) * screenscale
	local tabhei = ZS_GetTabHeight and ZS_GetTabHeight(screenscale, 24 * screenscale) or 24 * screenscale

	local frame = vgui.Create("DFrame")
	pWorth = frame
	frame:SetSize(wid, hei)
	frame:SetDeleteOnClose(true)
	frame:SetKeyboardInputEnabled(false)
	frame:SetTitle(" ")
	frame.Think = WorthThink

	local topspace = vgui.Create("DPanel", frame)
	topspace:SetWide(wid * 0.75)
	topspace:SetPaintBackground(false)

	local title = EasyLabel(topspace, translate.Get("worth_menu_title"), "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()
	local subtitle = EasyLabel(topspace, translate.Get("worth_menu_subtitle"), "ZSHUDFontTiny", COLOR_WHITE)
	subtitle:CenterHorizontal()
	subtitle:MoveBelow(title, 4)

	local _, y = subtitle:GetPos()
	topspace:SetTall(y + subtitle:GetTall() + 4)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local bottomspace = vgui.Create("DPanel", frame)
	bottomspace:SetWide(topspace:GetWide())
	bottomspace:SetPaintBackground(false)

	local lab = EasyLabel(bottomspace, " ", ZS_TinyFontWithOutline())
	lab:AlignTop(4)
	lab:AlignRight(4)
	frame.m_SpacerBottomLabel = lab

	_, y = lab:GetPos()
	bottomspace:SetTall(y + lab:GetTall() + 4)
	bottomspace:AlignBottom(16)
	bottomspace:CenterHorizontal()

	local __, topy = topspace:GetPos()
	local ___, boty = bottomspace:GetPos()

	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:SetSize(wid, boty - topy - 8 - topspace:GetTall())
	propertysheet:MoveBelow(topspace, 4)
	propertysheet:SetPadding(1)
	propertysheet.Paint = function() end

	local list = vgui.Create("DPanelList", propertysheet)
	local sheet = propertysheet:AddSheet(translate.Get("favorites_tab"), list, "icon16/heart.png", false, false)
	sheet.Panel:SetPos(0, tabhei + 2)
	list:EnableVerticalScrollbar(true)
	list:SetWide(propertysheet:GetWide() - 16)
	list:SetSpacing(2)
	list:SetPadding(2)

	local savebutton = EasyButton(nil, translate.Get("save_current_cart"), 0, 10)
	savebutton.DoClick = SaveDoClick
	savebutton:SetFont(ZS_TinyFont())
	list:AddItem(savebutton)

	local panfont = "ZSHUDFontSmall"
	local panhei = 40 * screenscale

	local defaultcart = cvarDefaultCart:GetString()

	for i, savetab in ipairs(GAMEMODE.SavedCarts) do
		local cartpan = vgui.Create("DEXRoundedPanel")
		cartpan:SetCursor("pointer")
		cartpan:SetSize(list:GetWide(), panhei)

		local cartname = savetab[1]

		local x = 8
		local limitedscale = math.Clamp(screenscale, 1, 1.5)

		if defaultcart == cartname then
			local defimage = vgui.Create("DImage", cartpan)
			defimage:SetImage("icon16/heart.png")
			defimage:SizeToContents()
			defimage:SetSize(16 * limitedscale, 16 * limitedscale)
			defimage:SetMouseInputEnabled(true)
			defimage:SetTooltip(translate.Get("cart_tooltip_default"))
			defimage:SetPos(x, cartpan:GetTall() * 0.5 - defimage:GetTall() * 0.5)
			x = x + defimage:GetWide() + 4
		end

		-- Width reserved for 4 buttons on the right (16*ls + 8 gap, + 8 right pad).
		local reservedW = 4 * (16 * limitedscale) + 4 * 8 + 8

		local cartnamelabel = EasyLabel(cartpan, cartname, panfont)
		cartnamelabel:SetPos(x, cartpan:GetTall() * 0.5 - cartnamelabel:GetTall() * 0.5)

		x = cartpan:GetWide()

		local checkbutton = vgui.Create("DImageButton", cartpan)
		checkbutton:SetImage("icon16/accept.png")
		checkbutton:SizeToContents()
		checkbutton:SetSize(16 * limitedscale, 16 * limitedscale)
		checkbutton:SetTooltip(translate.Get("cart_tooltip_purchase"))
		x = x - checkbutton:GetWide() - 8
		checkbutton:SetPos(x, cartpan:GetTall() * 0.5 - checkbutton:GetTall() * 0.5)
		checkbutton.ID = i
		checkbutton.DoClick = QuickCheckDoClick

		local loadbutton = vgui.Create("DImageButton", cartpan)
		loadbutton:SetImage("icon16/folder_go.png")
		loadbutton:SizeToContents()
		loadbutton:SetSize(16 * limitedscale, 16 * limitedscale)
		loadbutton:SetTooltip(translate.Get("cart_tooltip_load"))
		x = x - loadbutton:GetWide() - 8
		loadbutton:SetPos(x, cartpan:GetTall() * 0.5 - loadbutton:GetTall() * 0.5)
		loadbutton.ID = i
		loadbutton.DoClick = LoadDoClick

		local defaultbutton = vgui.Create("DImageButton", cartpan)
		defaultbutton:SetImage("icon16/heart.png")
		defaultbutton:SizeToContents()
		defaultbutton:SetSize(16 * limitedscale, 16 * limitedscale)
		if cartname == defaultcart then
			defaultbutton:SetTooltip(translate.Get("cart_tooltip_unset_default"))
		else
			defaultbutton:SetTooltip(translate.Get("cart_tooltip_make_default"))
		end
		x = x - defaultbutton:GetWide() - 8
		defaultbutton:SetPos(x, cartpan:GetTall() * 0.5 - defaultbutton:GetTall() * 0.5)
		defaultbutton.Name = cartname
		defaultbutton.DoClick = DefaultDoClick

		local deletebutton = vgui.Create("DImageButton", cartpan)
		deletebutton:SetImage("icon16/bin.png")
		deletebutton:SizeToContents()
		deletebutton:SetSize(16 * limitedscale, 16 * limitedscale)
		deletebutton:SetTooltip(translate.Get("cart_tooltip_delete"))
		x = x - deletebutton:GetWide() - 8
		deletebutton:SetPos(x, cartpan:GetTall() * 0.5 - loadbutton:GetTall() * 0.5)
		deletebutton.ID = i
		deletebutton.DoClick = DeleteDoClick

		checkbutton:SetZPos(1)
		loadbutton:SetZPos(1)
		defaultbutton:SetZPos(1)
		deletebutton:SetZPos(1)

		list:AddItem(cartpan)
	end

	for catid, catname in ipairs(GAMEMODE.ItemCategories) do
		local itemframe = vgui.Create("DScrollPanel", propertysheet)
		local trinkets = catid == ITEMCAT_TRINKETS

		--list = vgui.Create("DPanelList", itemframe)
		list = vgui.Create("DGrid", itemframe)
		list:SetSize(propertysheet:GetWide() - 328, propertysheet:GetTall() - 32)
		list:SetCols(2)
		list:SetColWide(290 * screenscale)
		list:SetRowHeight((trinkets and 64 or 100) * screenscale)

		sheet = propertysheet:AddSheet(translate.Get(catname), itemframe, GAMEMODE.ItemCategoryIcons[catid], false, false)
		sheet.Panel:SetPos(0, tabhei + 2)

		for i, tab in ipairs(GAMEMODE.Items) do
			if tab.Category == catid and tab.WorthShop then
				local button = vgui.Create("ZSWorthButton")
				button:SetWorthID(i)
				list:AddItem(button)
				WorthButtons[i] = button
			end
		end
	end

	local worthlab = EasyLabel(frame, translate.Format("worth_x", remainingworth), "ZSHUDFontSmall", COLOR_LIMEGREEN)
	worthlab:SetPos(8, frame:GetTall() - worthlab:GetTall() - 8)
	frame.WorthLab = worthlab

	local function SizeButtonToText(btn, padW, padH, minH)
			surface.SetFont(btn:GetFont())
			local tw, th = surface.GetTextSize(btn:GetText() or "")
			btn:SetSize(tw + padW, math.max(th + padH, minH or (th + padH)))
		end
		
		local checkout = vgui.Create("DButton", frame)
		checkout:SetFont("ZSHUDFontSmall")
		checkout:SetText(translate.Get("checkout_button"))
		SizeButtonToText(checkout, 28 * screenscale, 14 * screenscale, 28 * screenscale)
		checkout:AlignBottom(8)
		checkout:CenterHorizontal()
		checkout.DoClick = CheckoutDoClick

		-- Random/Clear: if the text is short (English "Random"/"Clear") —
		-- original layout: Clear above Random, both 64×16.
		-- If the text is longer (Russian "Очистить"/"Случайно") — place them in a row
		-- and shift them left so they don't overlap the property sheet's scrollbar.
		local minBtnW = 64 * screenscale
		local minBtnH = 16 * screenscale

		surface.SetFont(ZS_TinyFont())
		local randTw, randTh   = surface.GetTextSize(translate.Get("random_button"))
		local clearTw, clearTh = surface.GetTextSize(translate.Get("clear_button"))

		local randW  = math.max(minBtnW, randTw  + 12 * screenscale)
		local randH  = math.max(minBtnH, randTh  + 6  * screenscale)
		local clearW = math.max(minBtnW, clearTw + 12 * screenscale)
		local clearH = math.max(minBtnH, clearTh + 6  * screenscale)

		local randombutton = vgui.Create("DButton", frame)
		randombutton:SetFont(ZS_TinyFont())
		randombutton:SetText(translate.Get("random_button"))
		randombutton.DoClick = RandDoClick

		local clearbutton = vgui.Create("DButton", frame)
		clearbutton:SetFont(ZS_TinyFont())
		clearbutton:SetText(translate.Get("clear_button"))
		clearbutton.DoClick = ClearCartDoClick

		if randW <= minBtnW and clearW <= minBtnW then
			-- Original layout: both buttons are the same size, Clear above Random.
			randombutton:SetSize(minBtnW, minBtnH)
			randombutton:AlignBottom(8)
			randombutton:AlignRight(8)

			clearbutton:SetSize(minBtnW, minBtnH)
			clearbutton:AlignRight(8)
			clearbutton:MoveAbove(randombutton, 8)
		else
			-- The text doesn't fit in the original size — lay them out in a row.
			-- Random in the bottom-right corner, Clear to its left.
			randombutton:SetSize(randW, randH)
			randombutton:SetPos(frame:GetWide() - randW - 8 * screenscale, frame:GetTall() - randH - 8 * screenscale)

			clearbutton:SetSize(clearW, clearH)
			clearbutton:SetPos(randombutton:GetX() - clearW - 6 * screenscale, frame:GetTall() - clearH - 8 * screenscale)
		end

	frame:Center()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.15, 0)
	frame:MakePopup()

	local scroller = propertysheet:GetChildren()[1]
	local dragbase = scroller:GetChildren()[1]
	local tabs = dragbase:GetChildren()

	GAMEMODE:CreateItemInfoViewer(frame, propertysheet, topspace, bottomspace, MENU_WORTH)
	GAMEMODE:ConfigureMenuTabs(tabs, tabhei, function(tabpanel)
		pWorth.Viewer:SetVisible(tabpanel ~= tabs[1])
	end)

	if #GAMEMODE.SavedCarts == 0 then
		propertysheet:SetActiveTab(propertysheet.Items[math.min(2, #propertysheet.Items)].Tab)
	else
		propertysheet:SwitchToName(translate.Get("favorites_tab"))
	end

	return frame
end

local PANEL = {}
PANEL.m_ItemID = 0
PANEL.RefreshTime = 1
PANEL.NextRefresh = 0

function PANEL:Init()
	local screenscale = BetterScreenScale()

	self:SetFont(screenscale > 1.5 and "DefaultFontLargest" or "DefaultFontSmall")
end

function PANEL:Think()
	if CurTime() >= self.NextRefresh then
		self.NextRefresh = CurTime() + self.RefreshTime
		self:RefreshWorth()
	end
end

function PANEL:RefreshWorth()
	local count = GAMEMODE:GetCurrentEquipmentCount(self:GetItemID())
	local newtext = (count == 0) and " " or tostring(count)
	if self._LastText == newtext then return end
	self._LastText = newtext
	self:SetText(newtext)
	self:SizeToContents()
end

function PANEL:SetItemID(id) self.m_ItemID = id end
function PANEL:GetItemID() return self.m_ItemID end

vgui.Register("ItemAmountCounter", PANEL, "DLabel")

PANEL = {}

function PANEL:Init()
	self:SetText("")

	local screenscale = BetterScreenScale()

	local wid = 285

	self:SetWide(wid * screenscale)
	self:SetTall(100 * screenscale)

	self.ModelFrame = vgui.Create("DPanel", self)
	self.ModelFrame:SetSize(wid/2 * screenscale, 100/2 * screenscale)
	self.ModelFrame:SetPos(wid/4 * screenscale, 100/5 * screenscale)
	self.ModelFrame:SetVisible(false)
	self.ModelFrame:SetMouseInputEnabled(false)
	self.ModelFrame.Paint = function() end

	self.NameLabel = vgui.Create("DLabelAutoScroll", self)
	self.NameLabel:SetFont("ZSHUDFontSmallest")
	self.NameLabel:SetTextColor(COLOR_WHITE)
	self.NameLabel:SetContentAlignment(4)
	--self.NameLabel:Dock(FILL)

	self.PriceLabel = vgui.Create("DLabelAutoScroll", self)
	self.PriceLabel:SetFont("ZSHUDFontTiny")
	self.PriceLabel:SetContentAlignment(4)

	self.ItemCounter = vgui.Create("ItemAmountCounter", self)

	self:SetWorthID(nil)
end

function PANEL:SetWorthID(id)
	self.ID = id

	local tab = FindStartingItem(id)
	local screenscale = BetterScreenScale()

	if not tab then
		self.ModelFrame:SetVisible(false)
		self.ItemCounter:SetVisible(false)
		self.NameLabel:SetText("")
		return
	end

	self.Signature = tab.Signature
	self.Price = tab.Price

	local reqskill = tab.SkillRequirement and GAMEMODE.Skills[tab.SkillRequirement]
	local missing_skill = tab.SkillRequirement and not MySelf:IsSkillActive(tab.SkillRequirement)

	local nottrinkets = tab.Category ~= ITEMCAT_TRINKETS
	self:SetTall((nottrinkets and 100 or 60) * screenscale)

	if nottrinkets then
		self.ModelFrame:SetVisible(true)
		local kitbl = killicon.Get(GAMEMODE.ZSInventoryItemData[tab.SWEP] and "weapon_zs_craftables" or tab.SWEP or tab.Model)
		if kitbl then
			GAMEMODE:AttachKillicon(kitbl, self, self.ModelFrame, tab.Category == ITEMCAT_AMMO, missing_skill)
		elseif tab.Model then
			local mdlpanel = vgui.Create("DModelPanel", self.ModelFrame)
			mdlpanel:SetSize(self.ModelFrame:GetSize())
			mdlpanel:SetModel(tab.Model)
			local mins, maxs = mdlpanel.Entity:GetRenderBounds()
			mdlpanel:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
			mdlpanel:SetLookAt((mins + maxs) / 2)
		end
	end

	if tab.SWEP or tab.Countables then
		self.ItemCounter:SetItemID(id)
		self.ItemCounter:SetVisible(true)
	else
		self.ItemCounter:SetVisible(false)
	end

	if missing_skill then
		self.PriceLabel:SetTextColor(COLOR_RED)
		self.PriceLabel:SetText(GAMEMODE:GetSkillDisplayName(tab.SkillRequirement) or translate.Get("missing_skill"))
	elseif tab.Price then
		self.PriceLabel:SetText(translate.Format("worth_price_x", tab.Price))
	else
		self.PriceLabel:SetText("")
	end

	-- Measure the SAME way DLabelAutoScroll draws (via draw.SimpleText with
	-- fallback). If you measure with bare surface.GetTextSize, for Cyrillic
	-- the width comes from base GFA without glyphs and becomes huge — the
	-- label stretches across the whole tile and slides left.
	self.PriceLabel:SizeToContents()
	self.PriceLabel:SetPos(
		self:GetWide() - self.PriceLabel:GetWide() - 12 * screenscale,
		self:GetTall() * (nottrinkets and 0.15 or 0.3) - self.PriceLabel:GetTall() * 0.5
	)

	local desc = GAMEMODE:GetShopItemDisplayDesc(tab)
	if desc and desc ~= "" then
		self:SetTooltip(desc)
	end

	if missing_skill or tab.NoClassicMode and GAMEMODE:IsClassicMode() or tab.NoZombieEscape and GAMEMODE.ZombieEscape then
		self:SetAlpha(120)
		self.Locked = true
	else
		self:SetAlpha(255)
	end

	if not nottrinkets and tab.SubCategory then
		-- Cursor-driven scrolling: the label follows the X position of
		-- the cursor relative to the item tile. IgnoreRootBounds means
		-- the label keeps tracking even if the cursor briefly leaves
		-- the Worth window (Worth doesn't close on mouse-out, so the
		-- alternative is a frozen label).
		local catlabel = vgui.Create("DLabelAutoScroll", self)
		catlabel:SetFont("ZSBodyTextFont")
		catlabel:SetTextColor(COLOR_WHITE)
		catlabel:SetScrollingMode("cursor")
		catlabel:SetIgnoreRootBounds(true)
		catlabel:SetContentAlignment(4)
		catlabel:SetText(translate.Get(GAMEMODE.ItemSubCategories[tab.SubCategory]))

		local catX = 10
		local catRightLimit = self.PriceLabel:GetX() - 6 * screenscale
		local catW = math.max(20, catRightLimit - catX)

		catlabel:SetSize(catW, draw.GetFontHeight("ZSBodyTextFont") + 2)
		catlabel:SetPos(catX, self:GetTall() * 0.3 - catlabel:GetTall() * 0.5)
	end

	self.NameLabel:SetText(GAMEMODE:GetShopItemDisplayName(tab))
	self.NameLabel:SetSize(self:GetWide() - 24 * screenscale, draw.GetFontHeight("ZSHUDFontSmallest") + 2)
	self.NameLabel:SetPos(12 * screenscale, self:GetTall() * (nottrinkets and 0.8 or 0.7) - self.NameLabel:GetTall() * 0.5)
end

local colBG = Color(15, 15, 15, 255)
local colSel = Color(15, 40, 15, 255)
function PANEL:Paint(w, h)
	local outline
	if self.Hovered then
		outline = self.On and COLOR_MIDGRAY or (self.Locked or not self.On and remainingworth < self.Price) and COLOR_RED or self.Depressed and COLOR_GREEN or COLOR_DARKGREEN

		draw.RoundedBox(8, 0, 0, w, h, outline)
	end

	draw.RoundedBox(2, 4, 4, w - 8, h - 8, self.On and colSel or colBG)

	return true
end

function PANEL:OnCursorEntered()
	local shoptbl = FindStartingItem(self.ID)
	if not shoptbl then return end

	local sweptable = GAMEMODE.ZSInventoryItemData[shoptbl.SWEP] or weapons.Get(shoptbl.SWEP)
	if sweptable then
		GAMEMODE:SupplyItemViewerDetail(pWorth.Viewer, sweptable, shoptbl)
	end
end

--[[function PANEL:OnCursorExited()
end]]

function PANEL:DoClick(silent, force)
	local id = self.ID
	local tab = FindStartingItem(id)
	local goodcart = true

	if not tab then return end

	if self.On then
		self.On = nil
		if not silent then
			surface.PlaySound("buttons/button18.wav")
		end
		remainingworth = remainingworth + tab.Price
	elseif tab.SkillRequirement and not MySelf:IsSkillActive(tab.SkillRequirement) then
		surface.PlaySound("buttons/button8.wav")
		return
	else
		if remainingworth < tab.Price then
			if not force then
				surface.PlaySound("buttons/button8.wav")
				return
			else
				goodcart = false
			end
		end
		self.On = true
		if not silent then
			surface.PlaySound("buttons/button17.wav")
		end
		remainingworth = remainingworth - tab.Price
	end

	pWorth.WorthLab:SetText(translate.Format("worth_x", remainingworth))
	if remainingworth <= 0 then
		pWorth.WorthLab:SetTextColor(COLOR_RED)
		pWorth.WorthLab:InvalidateLayout()
	elseif remainingworth < GetStartingWorth() then
		pWorth.WorthLab:SetTextColor(COLOR_YELLOW)
		pWorth.WorthLab:InvalidateLayout()
	else
		pWorth.WorthLab:SetTextColor(COLOR_LIMEGREEN)
		pWorth.WorthLab:InvalidateLayout()
	end
	pWorth.WorthLab:SizeToContents()

	return goodcart
end

vgui.Register("ZSWorthButton", PANEL, "DButton")
