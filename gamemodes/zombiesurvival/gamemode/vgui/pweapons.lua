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

	GAMEMODE:CreateItemViewerGenericElems(viewer)

	viewer.m_Title:SetText(sweptable.PrintName)
	viewer.m_Title:PerformLayout()

	local desctext = sweptable.Description or ""

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
	viewer.m_Desc:SetText(desctext)

	GAMEMODE:ViewerStatBarUpdate(viewer, category ~= ITEMCAT_GUNS and category ~= ITEMCAT_MELEE, sweptable)
	if GAMEMODE:HasPurchaseableAmmo(sweptable) and GAMEMODE.AmmoNames[string.lower(sweptable.Primary.Ammo)] then
		local lower = string.lower(sweptable.Primary.Ammo)

		viewer.m_AmmoType:SetText(GAMEMODE.AmmoNames[lower])
		viewer.m_AmmoType:PerformLayout()

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

	viewer.m_Recipe1:SetText(comps and (
		GAMEMODE.ZSInventoryItemData[comps[1]].PrintName
	) or "")

	viewer.m_Recipe2:SetText(comps and (
		weapons.Get(comps[2]).PrintName
	) or "")
end

function MakepWeapons(silent)
	if not silent then
		PlayMenuOpenSound()
	end

	if pWeapons then
		pWeapons:SetAlpha(0)
		pWeapons:AlphaTo(255, 0.15, 0)
		pWeapons:SetVisible(true)
		pWeapons:MakePopup()
		return
	end

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
	frame.SetWeaponViewerSWEP = SetWeaponViewerSWEP
	pWeapons = frame

	local y = 8

	local title = EasyLabel(frame, "Weapon Database", "ZSHUDFont", color_white)
	title:SetPos(wid * 0.5 - title:GetWide() * 0.5, y)
	y = y + title:GetTall() + 8

	local propertysheet = vgui.Create("DPropertySheet", frame)

	propertysheet:SetSize(wid * 0.4 - 8, hei - title:GetTall() - 32 * screenscale)
	propertysheet:MoveBelow(title, 16 * screenscale)
	propertysheet:SetPadding(1)

	local tree = vgui.Create("DTree", propertysheet)
	tree:SetWide(propertysheet:GetWide() - 16)
	local sheet = propertysheet:AddSheet("Weapons", tree, nil, false, false)
	sheet.Panel:SetPos(0, tabhei + 2)
	tree:SetIndentSize(4)
	frame.WeaponsTree = tree

	tree = vgui.Create("DTree", propertysheet)
	tree:SetWide(propertysheet:GetWide() - 16)
	sheet = propertysheet:AddSheet("Crafts", tree, nil, false, false)
	sheet.Panel:SetPos(0, tabhei + 2)
	tree:SetIndentSize(4)
	frame.CraftsTree = tree

	local scroller = propertysheet:GetChildren()[1]
	local dragbase = scroller:GetChildren()[1]
	local tabs = dragbase:GetChildren()

	GAMEMODE:ConfigureMenuTabs(tabs, tabhei)

	frame.ViewerY = y

	for _, wep in pairs(weps) do
		local enttab = weapons.Get(wep)
		local wepnode
		if enttab then
			wepnode = frame.WeaponsTree:AddNode(enttab.PrintName or wep)
		else
			wepnode = frame.WeaponsTree:AddNode(wep)
		end
		wepnode.SWEP = wep
		wepnode.DoClick = WeaponButtonDoClick
		wepnode.Category = addedcat[wep] or ITEMCAT_GUNS
	end

	for _, wep in pairs(crafts) do
		local enttab = weapons.Get(wep)
		local wepnode
		if enttab then
			wepnode = frame.CraftsTree:AddNode(enttab.PrintName or wep)
		else
			wepnode = frame.CraftsTree:AddNode(wep)
		end
		wepnode.SWEP = wep
		wepnode.DoClick = WeaponButtonDoClick
		wepnode.Category = enttab.RequiredClip and ITEMCAT_GUNS or (enttab.Primary.Ammo == "none" and enttab.MeleeRange) and ITEMCAT_MELEE or ITEMCAT_TOOLS
		wepnode.Comps = GAMEMODE.Assemblies[wep]
	end

	frame:SetWeaponViewerSWEP()

	MakepWeapons(true)
end
