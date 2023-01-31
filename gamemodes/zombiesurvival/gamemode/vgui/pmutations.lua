local color
local MutationButtons = {}
local quickbuyitems
local quickbuycheckmark

local function GetCost(tab)
	return (tab.Worth or 0) + ((isnumber(GAMEMODE.UsedMutations[tab.Signature]) and GAMEMODE.UsedMutations[tab.Signature] or 0) * (isnumber(tab.Rebuyable) and tab.Rebuyable or 0))
end

local function IsBuyable(tab)
	return not GAMEMODE.UsedMutations[tab.Signature] and not isnumber(tab.Rebuyable) or isnumber(tab.Rebuyable) and isnumber(GAMEMODE.UsedMutations[tab.Signature])
	and GAMEMODE.UsedMutations[tab.Signature] < (tab.MaxPurchases or math.huge) or not GAMEMODE.UsedMutations[tab.Signature]
end

local function BuyMutation(tobuy)
	RunConsoleCommand("zs_mutationshop_buy", tobuy)
end

function MakepMutationShop()
	if pMutation and pMutation:Valid() then
		pMutation:Remove()
		pMutation = nil
	end

	local wid, hei = math.min(ScrW(), 720), ScrH() * 0.7
	local frame = vgui.Create("DFrame")
	pMutation = frame
	frame:SetSize(wid, hei)
	frame:SetDeleteOnClose(true)
--	frame:SetDraggable(true)
	frame:SetKeyboardInputEnabled(false)
	frame:SetTitle("")
	frame.Paint = function()
		draw.RoundedBox( 0, 0, 0, wid, hei, Color( 0, 0, 0, 200 ) )
		draw.SimpleText(Format("Zombie tokens: %s", MySelf:GetZombieTokens()), "ZSHUDFontSmall", 8, frame:GetTall() - 40, MySelf:GetZombieTokens() <= 0 and COLOR_SOFTRED or COLOR_GRAY)
	end
	frame.Think = function()
		if MySelf:Team() ~= TEAM_UNDEAD then
			frame:Remove()
		end
	end

	quickbuycheckmark = vgui.Create("DCheckBoxLabel", frame)
	quickbuycheckmark:SetText("Quick buy mutations")
	quickbuycheckmark:SizeToContents()
	quickbuycheckmark:AlignBottom(8)
	quickbuycheckmark:AlignRight(8)
	quickbuycheckmark:SetChecked(quickbuyitems)
	quickbuycheckmark.OnChange = function()
		if quickbuycheckmark:GetChecked() then
			quickbuyitems = true
		else
			quickbuyitems = false
		end
	end

	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:StretchToParent(4, 24, 4, 50)
	propertysheet.Paint = function() end

	local panfont = "ZSHUDFontSmall"
	local panhei = 40

	for catid, catname in ipairs(GAMEMODE.MutationCategories) do
		local hasitems = false
		for i, tab in ipairs(GAMEMODE.Mutations) do
			if tab.MutCategory == catid and tab.MutationShop then
				hasitems = true
				break
			end
		end

		if hasitems then
			local list = vgui.Create("DPanelList", propertysheet)
			list:SetPaintBackground(false)
			propertysheet:AddSheet(catname, list, nil, false, false)
			list:EnableVerticalScrollbar(true)
			list:SetWide(propertysheet:GetWide() - 16)
			list:SetSpacing(2)
			list:SetPadding(2)

			for i, tab in ipairs(GAMEMODE.Mutations) do
				if tab.MutCategory == catid and tab.MutationShop then
					local button = vgui.Create("ZSMutationButton")
					button:SetMutationID(i)
					list:AddItem(button)
					MutationButtons[i] = button

				end
			end
		end
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
	self:SetTall(48)

	self.NameLabel = EasyLabel(self, "", "ZSHUDFontSmall")
	self.NameLabel:SizeToContents()
	self.NameLabel:SetContentAlignment(4)
	self.NameLabel:Dock(FILL)
	self.NameLabel:DockMargin(0, 0, 8, 0)

	self.PriceLabel = EasyLabel(self, "", "ZSHUDFontTiny")
	self.PriceLabel:SetWide(80)
	self.PriceLabel:SetContentAlignment(6)
	self.PriceLabel:Dock(RIGHT)
	self.PriceLabel:DockMargin(8, 0, 4, 0)

	self:SetMutationID(nil)
end

function PANEL:SetMutationID(id)
	self.ID = id

	local tab = FindMutation(id)

	if not tab then
		self.NameLabel:SetText("")
		return
	end

	if not IsBuyable(tab) then
		self.NameLabel:SetTextColor(COLOR_RED)
	end

	if GetCost(tab) then
		self.PriceLabel:SetText(tostring(GetCost(tab)).." tokens")
	else
		self.PriceLabel:SetText("")
	end

	self:SetTooltip(Format("%s\n%s\n\nCost: %d zombie tokens\nPrice increase per purchase: %s\nMax purchases: %s", tab.Name, tab.Description, GetCost(tab), isnumber(tab.Rebuyable) and tab.Rebuyable or 0, tab.MaxPurchases or "No limit"))

	self.NameLabel:SetText(tab.Name or "")
end

function PANEL:Paint(w, h)
	local outline

	if self.Hovered then
		outline = COLOR_GRAY
	else
		outline = COLOR_DARKGRAY
	end

	draw.RoundedBox(8, 0, 0, w, h, outline)
	draw.RoundedBox(4, 4, 4, w - 8, h - 8, color_black)
end

function PANEL:Think()
	local tab = FindMutation(self.ID)
	if not tab then return end
	local cost = GetCost(tab)
	self.PriceLabel:SetText(tostring(cost).." tokens")
	self:SetTooltip(Format("%s\n%s\n\nCost: %d zombie tokens\nPrice increase per purchase: %s\nMax purchases: %s", tab.Name, tab.Description, GetCost(tab), isnumber(tab.Rebuyable) and tab.Rebuyable or 0, tab.MaxPurchases or "No limit"))
	if not IsBuyable(tab) then
		self.NameLabel:SetTextColor(COLOR_RED)
	end
end

function PANEL:DoClick(silent, force)
	local id = self.ID
	local tab = FindMutation(id)
	if not tab then return end

	for k,v in pairs(GAMEMODE.UsedMutations) do
		if k == tab.Signature and not IsBuyable(tab) then
			surface.PlaySound("buttons/button8.wav")
			return
		end
	end

	if MySelf:GetZombieTokens() < GetCost(tab) and not IsBuyable(tab) then
		surface.PlaySound("buttons/button8.wav")
		return
	end

	if not gamemode.Call("ZombieCanPurchase", MySelf) then
		GAMEMODE:CenterNotify(COLOR_RED, "You cannot buy mutations at the time!")
		surface.PlaySound("buttons/button10.wav")
		return
	end



	if quickbuyitems then
		BuyMutation(id)
	else
		local menu = DermaMenu()
		menu:AddOption("Buy", function()
			BuyMutation(id)
		end)
		menu:Open()
	end
end

vgui.Register("ZSMutationButton", PANEL, "DButton")