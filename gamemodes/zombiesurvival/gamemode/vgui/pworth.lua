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
	local frame = Derma_StringRequest("Save cart", "Enter a name for this cart.", "Name",
	function(strTextOut) SaveCurrentCart(strTextOut) end,
	function(strTextOut) end,
	"OK", "Cancel")

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
	local tabhei = 24 * screenscale

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

	local title = EasyLabel(topspace, "The Worth Menu", "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()
	local subtitle = EasyLabel(topspace, "Select the items you're going to start with this round.", "ZSHUDFontTiny", COLOR_WHITE)
	subtitle:CenterHorizontal()
	subtitle:MoveBelow(title, 4)

	local _, y = subtitle:GetPos()
	topspace:SetTall(y + subtitle:GetTall() + 4)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local bottomspace = vgui.Create("DPanel", frame)
	bottomspace:SetWide(topspace:GetWide())
	bottomspace:SetPaintBackground(false)

	local lab = EasyLabel(bottomspace, " ", "ZSHUDFontTiny")
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
	local sheet = propertysheet:AddSheet("Favorites", list, "icon16/heart.png", false, false)
	sheet.Panel:SetPos(0, tabhei + 2)
	list:EnableVerticalScrollbar(true)
	list:SetWide(propertysheet:GetWide() - 16)
	list:SetSpacing(2)
	list:SetPadding(2)

	local savebutton = EasyButton(nil, "Save the current cart", 0, 10)
	savebutton.DoClick = SaveDoClick
	savebutton:SetFont("ZSHUDFontTiny")
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
			defimage:SetTooltip("This is your default cart.\nIf you join the game late then you'll spawn with this cart.")
			defimage:SetPos(x, cartpan:GetTall() * 0.5 - defimage:GetTall() * 0.5)
			x = x + defimage:GetWide() + 4
		end

		local cartnamelabel = EasyLabel(cartpan, cartname, panfont)
		cartnamelabel:SetPos(x, cartpan:GetTall() * 0.5 - cartnamelabel:GetTall() * 0.5)

		x = cartpan:GetWide()

		local checkbutton = vgui.Create("DImageButton", cartpan)
		checkbutton:SetImage("icon16/accept.png")
		checkbutton:SizeToContents()
		checkbutton:SetSize(16 * limitedscale, 16 * limitedscale)
		checkbutton:SetTooltip("Purchase this saved cart.")
		x = x - checkbutton:GetWide() - 8
		checkbutton:SetPos(x, cartpan:GetTall() * 0.5 - checkbutton:GetTall() * 0.5)
		checkbutton.ID = i
		checkbutton.DoClick = QuickCheckDoClick

		local loadbutton = vgui.Create("DImageButton", cartpan)
		loadbutton:SetImage("icon16/folder_go.png")
		loadbutton:SizeToContents()
		loadbutton:SetSize(16 * limitedscale, 16 * limitedscale)
		loadbutton:SetTooltip("Load this saved cart.")
		x = x - loadbutton:GetWide() - 8
		loadbutton:SetPos(x, cartpan:GetTall() * 0.5 - loadbutton:GetTall() * 0.5)
		loadbutton.ID = i
		loadbutton.DoClick = LoadDoClick

		local defaultbutton = vgui.Create("DImageButton", cartpan)
		defaultbutton:SetImage("icon16/heart.png")
		defaultbutton:SizeToContents()
		defaultbutton:SetSize(16 * limitedscale, 16 * limitedscale)
		if cartname == defaultcart then
			defaultbutton:SetTooltip("Remove this cart as your default.")
		else
			defaultbutton:SetTooltip("Make this cart your default.")
		end
		x = x - defaultbutton:GetWide() - 8
		defaultbutton:SetPos(x, cartpan:GetTall() * 0.5 - defaultbutton:GetTall() * 0.5)
		defaultbutton.Name = cartname
		defaultbutton.DoClick = DefaultDoClick

		local deletebutton = vgui.Create("DImageButton", cartpan)
		deletebutton:SetImage("icon16/bin.png")
		deletebutton:SizeToContents()
		deletebutton:SetSize(16 * limitedscale, 16 * limitedscale)
		deletebutton:SetTooltip("Delete this saved cart.")
		x = x - deletebutton:GetWide() - 8
		deletebutton:SetPos(x, cartpan:GetTall() * 0.5 - loadbutton:GetTall() * 0.5)
		deletebutton.ID = i
		deletebutton.DoClick = DeleteDoClick

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

		sheet = propertysheet:AddSheet(catname, itemframe, GAMEMODE.ItemCategoryIcons[catid], false, false)
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

	local worthlab = EasyLabel(frame, "Worth: "..tostring(remainingworth), "ZSHUDFontSmall", COLOR_LIMEGREEN)
	worthlab:SetPos(8, frame:GetTall() - worthlab:GetTall() - 8)
	frame.WorthLab = worthlab

	local checkout = vgui.Create("DButton", frame)
	checkout:SetFont("ZSHUDFontSmall")
	checkout:SetText("Checkout")
	checkout:SizeToContents()
	checkout:SetSize(130 * screenscale, 30 * screenscale)
	checkout:AlignBottom(8)
	checkout:CenterHorizontal()
	checkout.DoClick = CheckoutDoClick

	local randombutton = vgui.Create("DButton", frame)
	randombutton:SetFont("ZSHUDFontTiny")
	randombutton:SetText("Random")
	randombutton:SetSize(64 * screenscale, 16 * screenscale)
	randombutton:AlignBottom(8)
	randombutton:AlignRight(8)
	randombutton.DoClick = RandDoClick

	local clearbutton = vgui.Create("DButton", frame)
	clearbutton:SetFont("ZSHUDFontTiny")
	clearbutton:SetText("Clear")
	clearbutton:SetSize(64 * screenscale, 16 * screenscale)
	clearbutton:AlignRight(8)
	clearbutton:MoveAbove(randombutton, 8)
	clearbutton.DoClick = ClearCartDoClick

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
		propertysheet:SwitchToName("Favorites")
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
	if count == 0 then
		self:SetText(" ")
	else
		self:SetText(count)
	end

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

	self.NameLabel = EasyLabel(self, "", "ZSHUDFontSmallest")
	self.NameLabel:SetContentAlignment(4)
	self.NameLabel:DockPadding(0, 0, 0, 0)
	self.NameLabel:DockMargin(0, 0, 0, 0)
	--self.NameLabel:Dock(FILL)

	self.PriceLabel = EasyLabel(self, "", "ZSHUDFontTiny")
	self.PriceLabel:SetContentAlignment(4)
	self.PriceLabel:DockPadding(0, 0, 0, 0)
	--self.PriceLabel:Dock(RIGHT)
	self.PriceLabel:DockMargin(8, 0, 8 * screenscale, 0)

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
		self.PriceLabel:SetText(GAMEMODE.Skills[tab.SkillRequirement].Name)
	elseif tab.Price then
		self.PriceLabel:SetText(tostring(tab.Price).." Worth")
	else
		self.PriceLabel:SetText("")
	end
	self.PriceLabel:SizeToContents()
	self.PriceLabel:SetPos(
		self:GetWide() - self.PriceLabel:GetWide() - 12 * screenscale,
		self:GetTall() * (nottrinkets and 0.15 or 0.3) - self.PriceLabel:GetTall() * 0.5
	)

	self:SetTooltip(tab.Description)

	if missing_skill or tab.NoClassicMode and GAMEMODE:IsClassicMode() or tab.NoZombieEscape and GAMEMODE.ZombieEscape then
		self:SetAlpha(120)
		self.Locked = true
	else
		self:SetAlpha(255)
	end

	if not nottrinkets and tab.SubCategory then
		local catlabel = EasyLabel(self, GAMEMODE.ItemSubCategories[tab.SubCategory], "ZSBodyTextFont")
		catlabel:SizeToContents()
		catlabel:SetPos(10, self:GetTall() * 0.3 - catlabel:GetTall() * 0.5)
	end

	self.NameLabel:SetText(tab.Name or "")
	self.NameLabel:SetPos(12 * screenscale, self:GetTall() * (nottrinkets and 0.8 or 0.7) - self.NameLabel:GetTall() * 0.5)
	self.NameLabel:SizeToContents()
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
	if sweptable --[[and not GAMEMODE.AlwaysQuickBuy]] then
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

	pWorth.WorthLab:SetText("Worth: ".. remainingworth)
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
