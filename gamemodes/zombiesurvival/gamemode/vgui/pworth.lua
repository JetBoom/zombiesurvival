hook.Add("SetWave", "CloseWorthOnWave1", function(wave)
	if wave > 0 then
		if pWorth and pWorth:Valid() then
			pWorth:Close()
		end

		hook.Remove("SetWave", "CloseWorthOnWave1")
	end
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

local WorthRemaining = 0
local WorthButtons = {}
local function CartDoClick(self, silent, force)
	local id = self.ID
	local tab = FindStartingItem(id)
	if not tab then return end

	if self.On then
		self.On = nil
		self:SetImage("icon16/cart_add.png")
		if not silent then
			surface.PlaySound("buttons/button18.wav")
		end
		self:SetTooltip("Add to cart") -- not used and not needed to translate
		WorthRemaining = WorthRemaining + tab.Worth
	else
		if WorthRemaining < tab.Worth and not force then
			surface.PlaySound("buttons/button8.wav")
			return
		end
		self.On = true
		self:SetImage("icon16/cart_delete.png")
		if not silent then
			surface.PlaySound("buttons/button17.wav")
		end
		self:SetTooltip("Remove from cart") -- not used and not needed to translate
		WorthRemaining = WorthRemaining - tab.Worth
	end

	pWorth.WorthLab:SetText("Worth: ".. WorthRemaining) -- not used and not needed to translate
	if WorthRemaining <= 0 then
		pWorth.WorthLab:SetTextColor(COLOR_RED)
		pWorth.WorthLab:InvalidateLayout()
	elseif WorthRemaining <= GAMEMODE.StartingWorth * 0.25 then
		pWorth.WorthLab:SetTextColor(COLOR_YELLOW)
		pWorth.WorthLab:InvalidateLayout()
	else
		pWorth.WorthLab:SetTextColor(COLOR_LIMEGREEN)
		pWorth.WorthLab:InvalidateLayout()
	end
	pWorth.WorthLab:SizeToContents()
end

local function Checkout(tobuy)
	if tobuy and #tobuy > 0 then
		gamemode.Call("SuppressArsenalUpgrades", 1)

		RunConsoleCommand("worthcheckout", unpack(tobuy))

		if pWorth and pWorth:Valid() then
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

	Checkout(tobuy)
end

local function RandDoClick(self)
	gamemode.Call("SuppressArsenalUpgrades", 1)

	RunConsoleCommand("worthrandom")

	if pWorth and pWorth:Valid() then
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

local function LoadCart(cartid, silent)
	if GAMEMODE.SavedCarts[cartid] then
		MakepWorth()
		for _, id in pairs(GAMEMODE.SavedCarts[cartid][2]) do
			for __, btn in pairs(WorthButtons) do
				if btn and (btn.ID == id or GAMEMODE.Items[id] and GAMEMODE.Items[id].Signature == btn.ID) then
					btn:DoClick(true, true)
				end
			end
		end
		if not silent then
			surface.PlaySound("buttons/combine_button1.wav")
		end
	end
end

local function LoadDoClick(self)
	LoadCart(self.ID)
end

local function SaveCurrentCart(name)
	local tobuy = {}
	for _, btn in pairs(WorthButtons) do
		if btn and btn.On and btn.ID then
			table.insert(tobuy, btn.ID)
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
	Derma_StringRequest("Save cart", "Enter a name for this cart.", "Name", 
	function(strTextOut) SaveCurrentCart(strTextOut) end,
	function(strTextOut) end,
	"OK", "Cancel")
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
	if GAMEMODE.SavedCarts[self.ID] then
		Checkout(GAMEMODE.SavedCarts[self.ID][2])
	end
end

function MakepWorth()
	if pWorth and pWorth:Valid() then
		pWorth:Remove()
		pWorth = nil
	end

	local maxworth = GAMEMODE.StartingWorth
	WorthRemaining = maxworth

	local wid, hei = math.min(ScrW(), 1024), ScrH() * 0.75

	local frame = vgui.Create("DFrame")
	pWorth = frame
	frame:SetSize(wid, hei)
	frame:SetDeleteOnClose(true)
	frame:SetKeyboardInputEnabled(false)
	frame:SetTitle(" ")
	frame:SetDraggable(true)
	if frame.btnClose and frame.btnClose:Valid() then frame.btnClose:SetVisible(true) frame.btnClose:SetTooltip(translate.Get("worth_close")) end
	if frame.btnMinim and frame.btnMinim:Valid() then frame.btnMinim:SetVisible(false) end
	if frame.btnMaxim and frame.btnMaxim:Valid() then frame.btnMaxim:SetVisible(false) end

	
	local headertext = vgui.Create("DLabel", frame)
	headertext:SetText(translate.Get("worth_title"))
	headertext:SetFont( "ZS3D2DFontSmall" )
	headertext:SetTextColor( COLOR_DARKRED )
	headertext:CenterHorizontal()
	headertext:SizeToContents() 
	headertext:SetPos(wid * 0.5 - headertext:GetWide() * 0.5, 10)


	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:StretchToParent(12, 85, 12, 60) --yolo
	propertysheet.Paint = function()

		draw.RoundedBox(8, 0, 0, w, h, Color(25, 25, 25, 255))
	end

	local list = vgui.Create("DPanelList", propertysheet)
	propertysheet:AddSheet(translate.Get("worth_favtab"), list, "icon16/heart.png", false, false)
	list:EnableVerticalScrollbar(true)
	list:SetWide(propertysheet:GetWide() - 16)
	list:SetSpacing(2)
	list:SetPadding(2)


	local panfont = "ZSHUDFontSmall"
	local panhei = 40

	local defaultcart = cvarDefaultCart:GetString()

	for i, savetab in ipairs(GAMEMODE.SavedCarts) do
		local cartpan = vgui.Create("DEXRoundedPanel")
		cartpan:SetCursor("pointer")
		cartpan:SetSize(list:GetWide(), panhei)

		local cartname = savetab[1]

		local x = 8

		if defaultcart == cartname then
			local defimage = vgui.Create("DImage", cartpan)
			defimage:SetImage("icon16/heart.png")
			defimage:SizeToContents()
			defimage:SetMouseInputEnabled(true)
			defimage:SetTooltip(translate.Get("worth_favtooltip"))
			defimage:SetPos(x, cartpan:GetTall() * 0.5 - defimage:GetTall() * 0.5)
			x = x + defimage:GetWide() + 4
		end

		local cartnamelabel = EasyLabel(cartpan, cartname, panfont)
		cartnamelabel:SetPos(x, cartpan:GetTall() * 0.5 - cartnamelabel:GetTall() * 0.5)

		x = cartpan:GetWide() - 20

		local checkbutton = vgui.Create("DImageButton", cartpan)
		checkbutton:SetImage("icon16/accept.png")
		checkbutton:SizeToContents()
		checkbutton:SetTooltip(translate.Get("worth_favbuy"))
		x = x - checkbutton:GetWide() - 8
		checkbutton:SetPos(x, cartpan:GetTall() * 0.5 - checkbutton:GetTall() * 0.5)
		checkbutton.ID = i
		checkbutton.DoClick = QuickCheckDoClick

		local loadbutton = vgui.Create("DImageButton", cartpan)
		loadbutton:SetImage("icon16/folder_go.png")
		loadbutton:SizeToContents()
		loadbutton:SetTooltip(translate.Get("worth_favload"))
		x = x - loadbutton:GetWide() - 8
		loadbutton:SetPos(x, cartpan:GetTall() * 0.5 - loadbutton:GetTall() * 0.5)
		loadbutton.ID = i
		loadbutton.DoClick = LoadDoClick

		local defaultbutton = vgui.Create("DImageButton", cartpan)
		defaultbutton:SetImage("icon16/heart.png")
		defaultbutton:SizeToContents()
		if cartname == defaultcart then
			defaultbutton:SetTooltip(translate.Get("worth_favremove"))
		else
			defaultbutton:SetTooltip(translate.Get("worth_favdefault"))
		end
		x = x - defaultbutton:GetWide() - 8
		defaultbutton:SetPos(x, cartpan:GetTall() * 0.5 - defaultbutton:GetTall() * 0.5)
		defaultbutton.Name = cartname
		defaultbutton.DoClick = DefaultDoClick

		local deletebutton = vgui.Create("DImageButton", cartpan)
		deletebutton:SetImage("icon16/bin.png")
		deletebutton:SizeToContents()
		deletebutton:SetTooltip(translate.Get("worth_favdelete"))
		x = x - deletebutton:GetWide() - 8
		deletebutton:SetPos(x, cartpan:GetTall() * 0.5 - loadbutton:GetTall() * 0.5)
		deletebutton.ID = i
		deletebutton.DoClick = DeleteDoClick

		list:AddItem(cartpan)
	end

	for catid, catname in ipairs(GAMEMODE.ItemCategories) do
		local list = vgui.Create("DPanelList", propertysheet)
		list:SetPaintBackground(false)
		propertysheet:AddSheet(catname, list, GAMEMODE.ItemCategoryIcons[catid], false, false)
		list:EnableVerticalScrollbar(true)
		list:SetWide(propertysheet:GetWide() - 16)
		list:SetSpacing(5)
		list:SetPadding(0)

		for i, tab in ipairs(GAMEMODE.Items) do
			if tab.Category == catid and tab.WorthShop then
				local button = vgui.Create("ZSWorthButton")
				button:SetWorthID(i)
				list:AddItem(button)
				WorthButtons[i] = button
			end
		end
	end

	local worthlab = EasyLabel(frame, translate.Get("worth_worth")..": "..tostring(WorthRemaining), "ZSHUDFontSmall", COLOR_LIMEGREEN)
	worthlab:SetPos(8, frame:GetTall() - worthlab:GetTall() - 50)
	worthlab:AlignRight(20)
	worthlab:AlignTop(88)
	frame.WorthLab = worthlab

	local checkout = vgui.Create("DButton", frame)
	checkout:SetFont("ZSHUDFontSmall")
	checkout:SetText(translate.Get("worth_checkout"))
	checkout:SetColor(COLOR_WHITE)
	checkout:SizeToContents()
	checkout:SetSize(140, 40)
	checkout:AlignBottom(10)
	checkout:CenterHorizontal()
	checkout.DoClick = CheckoutDoClick
	checkout:SetTooltip(translate.Get("worth_checkouttooltip"))

	local savebutton = vgui.Create("DButton", frame)
	savebutton:SetText(translate.Get("worth_saveload"))
	savebutton:SetSize(130, 30)
	savebutton:AlignBottom(10)
	savebutton:MoveLeftOf(checkout, 15)
	savebutton.DoClick = SaveDoClick
	savebutton:SetTooltip(translate.Get("worth_saveloadtooltip"))
	
	local clearbutton = vgui.Create("DButton", frame)
	clearbutton:SetText(translate.Get("worth_clear"))
	clearbutton:SetSize(130, 30)
	clearbutton:AlignBottom(10)
	clearbutton:MoveLeftOf(savebutton, 15)
	clearbutton.DoClick = ClearCartDoClick
	clearbutton:SetTooltip(translate.Get("worth_cleartooltip"))
	
	local randombutton = vgui.Create("DButton", frame)
	randombutton:SetText(translate.Get("worth_random"))
	randombutton:SetSize(130, 30)
	randombutton:AlignBottom(10)
	randombutton:MoveLeftOf(clearbutton, 15)
	randombutton.DoClick = RandDoClick
	randombutton:SetTooltip(translate.Get("worth_randomtooltip"))
	
	local githubbutton = vgui.Create("DButton", frame)
	githubbutton:SetText(translate.Get("worth_github"))
	githubbutton:SetSize(130, 30)
	githubbutton:AlignBottom(10)
	githubbutton:MoveRightOf(checkout, 15)
	githubbutton.DoClick = function() gui.OpenURL("https://github.com/MrCraigTunstall/zombiesurvival") end
	githubbutton:SetTooltip(translate.Get("worth_githubtooltip"))
	
	local forumbutton = vgui.Create("DButton", frame)
	forumbutton:SetText(translate.Get("worth_forum"))
	forumbutton:SetSize(130, 30)
	forumbutton:AlignBottom(10)
	forumbutton:MoveRightOf(githubbutton, 15)
	forumbutton.DoClick = function() gui.OpenURL("https://voidresonance.com") end
	forumbutton:SetTooltip(translate.Get("worth_forumtooltip"))
	
	local groupbutton = vgui.Create("DButton", frame)
	groupbutton:SetText(translate.Get("worth_steam"))
	groupbutton:SetSize(130, 30)
	groupbutton:AlignBottom(10)
	groupbutton:MoveRightOf(forumbutton, 15)
	groupbutton.DoClick = function() gui.OpenURL("http://steamcommunity.com/groups/voidresonance") end
	groupbutton:SetTooltip(translate.Get("worth_steamtooltip"))
	

	if #GAMEMODE.SavedCarts == 0 then
		propertysheet:SetActiveTab(propertysheet.Items[math.min(2, #propertysheet.Items)].Tab)
	end

	frame:Center()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.5, 0)
	frame:MakePopup()

	return frame
end

local PANEL = {}
PANEL.m_ItemID = 0
PANEL.RefreshTime = 1
PANEL.NextRefresh = 0

function PANEL:Init()
	self:SetFont("DefaultFontSmall")
end

function PANEL:Think()
	if CurTime() >= self.NextRefresh then
		self.NextRefresh = CurTime() + self.RefreshTime
		self:Refresh()
	end
end

function PANEL:Refresh()
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
	
	self:DockPadding(4, 4, 4, 4)
	self:SetTall(64)

	local mdlframe = vgui.Create("DEXRoundedPanel", self)
	mdlframe:SetWide(self:GetTall())
	mdlframe:Dock(LEFT)
	mdlframe:DockMargin(0, 0, 20, 0)
	mdlframe:DockPadding(4, 4, 4, 4)

	self.ModelPanel = vgui.Create("DModelPanel", mdlframe)
	self.ModelPanel:Dock(FILL)
	self.ModelPanel:DockPadding(0, 0, 0, 0)
	self.ModelPanel:DockMargin(0, 0, 0, 0)

	self.NameLabel = EasyLabel(self, "", "ZSHUDFontSmall")
	self.NameLabel:SetTextColor(COLOR_WHITE)
	self.NameLabel:SetContentAlignment(5)
	self.NameLabel:Dock(FILL)
	self.NameLabel:DockMargin(0, 0, 0, 0)
	

	self.PriceLabel = EasyLabel(self, "", "ZSHUDFontTiny")
	self.PriceLabel:SetWide(80)
	self.PriceLabel:SetContentAlignment(6)
	self.PriceLabel:Dock(RIGHT)
	self.PriceLabel:DockMargin(8, 0, 4, 0)
	--self.PriceLabel:SetFont("ZSHUDFontSmall")

	self.ItemCounter = vgui.Create("ItemAmountCounter", self)

	self:SetWorthID(nil)
end

function PANEL:SetWorthID(id)
	self.ID = id

	local tab = FindStartingItem(id)

	if not tab then
		self.ItemCounter:SetVisible(false)
		self.NameLabel:SetText("")
		return
	end

	local mdl = tab.Model or (weapons.GetStored(tab.SWEP) or tab).WorldModel
	if mdl then
		self.ModelPanel:SetModel(mdl)
		local mins, maxs = self.ModelPanel.Entity:GetRenderBounds()
		self.ModelPanel:SetCamPos(mins:Distance(maxs) * Vector(0.50, 0.75, 0.6))
		self.ModelPanel:SetLookAt((mins + maxs) / 2)
		self.ModelPanel:SetVisible(true)
	end

	if tab.SWEP or tab.Countables then
		self.ItemCounter:SetItemID(id)
		self.ItemCounter:SetVisible(true)
	else
		self.ItemCounter:SetVisible(false)
	end

	if tab.Worth then
		self.PriceLabel:SetText(tostring(tab.Worth).." "..translate.Get("worth_worth"))
	else
		self.PriceLabel:SetText("")
	end

	self:SetTooltip(tab.Description)

	if tab.NoClassicMode and GAMEMODE:IsClassicMode() or tab.NoZombieEscape and GAMEMODE.ZombieEscape then
		self:SetAlpha(120)
	else
		self:SetAlpha(255)
	end

	self.NameLabel:SetText(tab.Name or "")
end

function PANEL:Paint(w, h)
	local outline
	if self.Hovered then
		outline = self.On and COLOR_RED or Color(190, 190, 190, 180)
	else
		outline = self.On and COLOR_DARKRED or Color(40, 40, 40, 180)
	end

	draw.RoundedBox(8, 0, 0, w, h, outline)
end

function PANEL:DoClick(silent, force)
	local id = self.ID
	local tab = FindStartingItem(id)
	if not tab then return end

	if self.On then
		self.On = nil
		if not silent then
			surface.PlaySound("buttons/button18.wav")
		end
		WorthRemaining = WorthRemaining + tab.Worth
	else
		if WorthRemaining < tab.Worth and not force then
			surface.PlaySound("buttons/button8.wav")
			return
		end
		self.On = true
		if not silent then
			surface.PlaySound("buttons/button17.wav")
		end
		WorthRemaining = WorthRemaining - tab.Worth
	end

	pWorth.WorthLab:SetText(translate.Get("worth_worth")..": "..WorthRemaining)
	if WorthRemaining <= 0 then
		pWorth.WorthLab:InvalidateLayout()
	elseif WorthRemaining <= GAMEMODE.StartingWorth * 0.25 then
		pWorth.WorthLab:SetTextColor(COLOR_YELLOW)
		pWorth.WorthLab:InvalidateLayout()
	else
		pWorth.WorthLab:SetTextColor(COLOR_LIMEGREEN)
		pWorth.WorthLab:InvalidateLayout()
	end
	pWorth.WorthLab:SizeToContents()
end
vgui.Register("ZSWorthButton", PANEL, "DButton")
