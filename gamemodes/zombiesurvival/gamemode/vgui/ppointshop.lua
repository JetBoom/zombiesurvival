local function pointslabelThink(self)
	local points = MySelf:GetPoints()
	if self.m_LastPoints ~= points then
		self.m_LastPoints = points

		self:SetText("사용 가능 포인트: "..points)
		self:SizeToContents()
	end
end

hook.Add("Think", "PointsShopThink", function()
	local pan = GAMEMODE.m_PointsShop
	if pan and pan:Valid() and pan:IsVisible() then
		local newstate = not GAMEMODE:GetWaveActive()
		if newstate ~= pan.m_LastNearArsenalCrate then
			pan.m_LastNearArsenalCrate = newstate

			if newstate then
				pan.m_DiscountLabel:SetText("쉬는 시간엔 가격이" .. GAMEMODE.ArsenalCrateDiscountPercentage .."% 할인됩니다!")
				pan.m_DiscountLabel:SetTextColor(COLOR_GREEN)
			else
				pan.m_DiscountLabel:SetText("청약철회 불가!")
				pan.m_DiscountLabel:SetTextColor(COLOR_GRAY)
			end

			pan.m_DiscountLabel:SizeToContents()
			pan.m_DiscountLabel:AlignRight(8)
		end

		local mx, my = gui.MousePos()
		local x, y = pan:GetPos()
		if mx < x - 16 or my < y - 16 or mx > x + pan:GetWide() + 16 or my > y + pan:GetTall() + 16 then
			pan:SetVisible(false)
			surface.PlaySound("npc/dog/dog_idle3.wav")
		end
	end
end)

local function PointsShopCenterMouse(self)
	local x, y = self:GetPos()
	local w, h = self:GetSize()
	gui.SetMousePos(x + w * 0.5, y + h * 0.5)
end

local ammonames = {
	["pistol"] = "pistolammo",
	["buckshot"] = "shotgunammo",
	["smg1"] = "smgammo",
	["ar2"] = "assaultrifleammo",
	["357"] = "rifleammo",
	["XBowBolt"] = "crossbowammo",
	["pulse"] = "pulseammo",
	["gravity"] = "m249ammo",
	["rpg"] = "rpgammo",
	["combinecannon"] = "railgunammo"
}

local warnedaboutammo = CreateClientConVar("_zs_warnedaboutammo", "0", true, false)
local function PurchaseDoClick(self)
	if not warnedaboutammo:GetBool() then
		local itemtab = FindItem(self.ID)
		if itemtab and itemtab.SWEP then
			local weptab = weapons.GetStored(itemtab.SWEP)
			if weptab and weptab.Primary and weptab.Primary.Ammo and ammonames[weptab.Primary.Ammo] then
				RunConsoleCommand("_zs_warnedaboutammo", "1")
				Derma_Message("탄약을 사는 것을 잊지 마십시오. 무기를 구매할 때 추가 탄약은 지급되지 않습니다!", "경고: 탄약 미포함")
			end
		end
	end

	RunConsoleCommand("zs_pointsshopbuy", self.ID)
end

local function BuyAmmoDoClick(self)
	if MySelf:KeyDown(IN_SPEED )  then
		for i=1, 10, 1 do
			RunConsoleCommand("zs_pointsshopbuy", "ps_"..self.AmmoType)
		end
	else
		RunConsoleCommand("zs_pointsshopbuy", "ps_"..self.AmmoType)
	end
end

local function worthmenuDoClick()
	MakepWorth()
	GAMEMODE.m_PointsShop:Close()
end

local function ItemPanelThink(self)
	local itemtab = FindItem(self.ID)
	if itemtab then
		local newstate = MySelf:GetPoints() >= math.ceil(itemtab.Worth * (GAMEMODE.m_PointsShop.m_LastNearArsenalCrate and GAMEMODE.ArsenalCrateMultiplier or 1)) and not (itemtab.NoClassicMode and GAMEMODE:IsClassicMode())
		if newstate ~= self.m_LastAbleToBuy then
			self.m_LastAbleToBuy = newstate
			if newstate then
				self:AlphaTo(255, 0.75, 0)
				self.m_NameLabel:SetTextColor(COLOR_WHITE)
				self.m_NameLabel:InvalidateLayout()
				self.m_BuyButton:SetImage("icon16/accept.png")
			else
				self:AlphaTo(90, 0.75, 0)
				self.m_NameLabel:SetTextColor(COLOR_RED)
				self.m_NameLabel:InvalidateLayout()
				self.m_BuyButton:SetImage("icon16/exclamation.png")
			end

			self.m_BuyButton:SizeToContents()
		end
	end
end

local function PointsShopThink(self)
	if GAMEMODE:GetWave() ~= self.m_LastWaveWarning and not GAMEMODE:GetWaveActive() and CurTime() >= GAMEMODE:GetWaveStart() - 10 and CurTime() > (self.m_LastWaveWarningTime or 0) + 11 then
		self.m_LastWaveWarning = GAMEMODE:GetWave()
		self.m_LastWaveWarningTime = CurTime()

		surface.PlaySound("ambient/alarms/klaxon1.wav")
		timer.Simple(0.6, function() surface.PlaySound("ambient/alarms/klaxon1.wav") end)
		timer.Simple(1.2, function() surface.PlaySound("ambient/alarms/klaxon1.wav") end)
		timer.Simple(2, function() surface.PlaySound("vo/npc/Barney/ba_hurryup.wav") end)
	end
end

function GM:OpenPointsShop()
	if self.m_PointsShop and self.m_PointsShop:Valid() then
		self.m_PointsShop:SetVisible(true)
		self.m_PointsShop:CenterMouse()
		return
	end

	local wid, hei = 600, math.max(ScrH() * 0.5, 540)

	local frame = vgui.Create("DFrame")
	frame:SetSize(wid, hei)
	frame:Center()
	frame:SetDeleteOnClose(false)
	frame:SetTitle(" ")
	frame:SetDraggable(false)
	if frame.btnClose and frame.btnClose:Valid() then frame.btnClose:SetVisible(false) end
	if frame.btnMinim and frame.btnMinim:Valid() then frame.btnMinim:SetVisible(false) end
	if frame.btnMaxim and frame.btnMaxim:Valid() then frame.btnMaxim:SetVisible(false) end
	frame.CenterMouse = PointsShopCenterMouse
	frame.Think = PointsShopThink
	self.m_PointsShop = frame

	local topspace = vgui.Create("DPanel", frame)
	topspace:SetWide(wid - 16)

	local title = EasyLabel(topspace, "포인트 샵", "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()
	local subtitle = EasyLabel(topspace, "좀비 대재앙에서 살아남기 위한 모든 것!", "ZSHUDFontTiny", COLOR_WHITE)
	subtitle:CenterHorizontal()
	subtitle:MoveBelow(title, 4)

	local _, y = subtitle:GetPos()
	topspace:SetTall(y + subtitle:GetTall() + 4)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local tt = vgui.Create("DImage", topspace)
	tt:SetImage("gui/info")
	tt:SizeToContents()
	tt:SetPos(8, 8)
	tt:SetMouseInputEnabled(true)
	tt:SetTooltip("이 샵은 좀비의 기습에 대비한 시스템을 갖췄습니다.\n마우스를 상점 밖으로 이동해 빠르게 닫을 수 있습니다!")

	local wsb = EasyButton(topspace, "시작 자금 무기창", 8, 4)
	wsb:AlignRight(8)
	wsb:AlignTop(8)
	wsb.DoClick = worthmenuDoClick


	local bottomspace = vgui.Create("DPanel", frame)
	bottomspace:SetWide(topspace:GetWide())

	local pointslabel = EasyLabel(bottomspace, "사용할 자금: 0", "ZSHUDFontTiny", COLOR_GREEN)
	pointslabel:AlignTop(4)
	pointslabel:AlignLeft(8)
	pointslabel.Think = pointslabelThink

	local lab = EasyLabel(bottomspace, " ", "ZSHUDFontTiny")
	lab:AlignTop(4)
	lab:AlignRight(4)
	frame.m_DiscountLabel = lab

	local _, y = lab:GetPos()
	bottomspace:SetTall(y + lab:GetTall() + 4)
	bottomspace:AlignBottom(8)
	bottomspace:CenterHorizontal()

	local topx, topy = topspace:GetPos()
	local botx, boty = bottomspace:GetPos()

	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:SetSize(wid - 8, boty - topy - 8 - topspace:GetTall())
	propertysheet:MoveBelow(topspace, 4)
	propertysheet:CenterHorizontal()

	local isclassic = GAMEMODE:IsClassicMode()

	for catid, catname in ipairs(GAMEMODE.ItemCategories) do
		local hasitems = false
		for i, tab in ipairs(GAMEMODE.Items) do
			if tab.Category == catid and tab.PointShop then
				hasitems = true
				break
			end
		end

		if hasitems then
			local list = vgui.Create("DPanelList", propertysheet)
			list:SetPaintBackground(false)
			propertysheet:AddSheet(catname, list, GAMEMODE.ItemCategoryIcons[catid], false, false)
			list:EnableVerticalScrollbar(true)
			list:SetWide(propertysheet:GetWide() - 16)
			list:SetSpacing(2)
			list:SetPadding(2)

			for i, tab in ipairs(GAMEMODE.Items) do
				if tab.Category == catid and tab.PointShop then
					local itempan = vgui.Create("DPanel")
					itempan:SetSize(list:GetWide(), 40)
					itempan.ID = tab.Signature or i
					itempan.Think = ItemPanelThink
					list:AddItem(itempan)

					local mdlframe = vgui.Create("DPanel", itempan)
					mdlframe:SetSize(32, 32)
					mdlframe:SetPos(4, 4)

					local weptab = weapons.GetStored(tab.SWEP) or tab
					local mdl = tab.Model or weptab.WorldModel
					if mdl then
						local mdlpanel = vgui.Create("DModelPanel", mdlframe)
						mdlpanel:SetSize(mdlframe:GetSize())
						mdlpanel:SetModel(mdl)
						local mins, maxs = mdlpanel.Entity:GetRenderBounds()
						mdlpanel:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
						mdlpanel:SetLookAt((mins + maxs) / 2)
					end

					if tab.SWEP or tab.Countables then
						local counter = vgui.Create("ItemAmountCounter", itempan)
						counter:SetItemID(i)
					end

					local name = tab.Name or ""
					local namelab = EasyLabel(itempan, name, "ZSHUDFontSmall", COLOR_WHITE)
					namelab:SetPos(42, itempan:GetTall() * 0.5 - namelab:GetTall() * 0.5)
					itempan.m_NameLabel = namelab

					local pricelab = EasyLabel(itempan, tostring(math.ceil(tab.Worth * (!GAMEMODE:GetWaveActive() and 0.8 or 1))).." 포인트", "ZSHUDFontTiny")
					pricelab:SetPos(itempan:GetWide() - 25 - pricelab:GetWide(), 4)
					pricelab.Think = function(self)
						self:SetText(tostring(math.ceil(tab.Worth * (!GAMEMODE:GetWaveActive() and 0.8 or 1))).." 포인트")
					end
					itempan.m_PriceLabel = pricelab

					local button = vgui.Create("DImageButton", itempan)
					button:SetImage("icon16/lorry_add.png")
					button:SizeToContents()
					button:SetPos(itempan:GetWide() - 25 - button:GetWide(), itempan:GetTall() - 20)
					button:SetTooltip(name.. " 구매")
					button.ID = itempan.ID
					button.DoClick = PurchaseDoClick
					itempan.m_BuyButton = button

					if weptab and weptab.Primary then
						local ammotype = weptab.Primary.Ammo
						if ammonames[ammotype] then
							local ammobutton = vgui.Create("DImageButton", itempan)
							ammobutton:SetImage("icon16/add.png")
							ammobutton:SizeToContents()
							ammobutton:CopyPos(button)
							ammobutton:MoveLeftOf(button, 2)
							ammobutton:SetTooltip("탄약 구매")
							ammobutton.AmmoType = ammonames[ammotype]
							ammobutton.DoClick = BuyAmmoDoClick
						end
					end

					if tab.Description then
						itempan:SetTooltip(tab.Description)
					end

					if tab.NoClassicMode and isclassic or tab.NoZombieEscape and GAMEMODE.ZombieEscape then
						itempan:SetAlpha(120)
					end
				end
			end
		end
	end

	frame:MakePopup()
	frame:CenterMouse()
end
GM.OpenPointShop = GM.OpenPointsShop
