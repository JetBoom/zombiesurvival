local function ScrapLabelThink(self)
	local scrap = MySelf:GetAmmoCount("scrap")
	if self.m_LastScrap ~= scrap then
		self.m_LastScrap = scrap

		self:SetText("Scrap for usage: "..scrap)
		self:SizeToContents()
	end
end

local function SelectedInv()
	return GAMEMODE.InventoryMenu and GAMEMODE.InventoryMenu.SelInv
end

local function DismantleClick()
	Derma_Query("Dismantle weapon? This cannot be reversed.", "Confirm Dissassembling Weapon",
	"Dismantle", function()
		RunConsoleCommand("zs_dismantle", SelectedInv())

		GAMEMODE.RemantlerInterface:Close()
		GAMEMODE.RemantlerInterface = nil
	end,
	"Cancel", function()
	end)
end

hook.Add("Think", "RemantlerMenuThink", function()
	local pan = GAMEMODE.RemantlerInterface
	if pan and pan:IsValid() and pan:IsVisible() then
		local mx, my = gui.MousePos()
		local x, y = pan:GetPos()
		if mx < x - 16 or my < y - 16 or mx > x + pan:GetWide() + 16 or my > y + pan:GetTall() + 16 then
			pan:SetVisible(false)
		end
	end
end)

local function RemantlerCenterMouse(self)
	local x, y = self:GetPos()
	local w, h = self:GetSize()
	gui.SetMousePos(x + w / 2, y + h / 2)
end

-- Miniature version of the skill tree code
local PANEL = {}
local hovquality
local hovbranch

AccessorFunc( PANEL, "vCamPos",			"CamPos" )
AccessorFunc( PANEL, "fFOV",			"FOV" )
AccessorFunc( PANEL, "vLookatPos",		"LookAt" )
AccessorFunc( PANEL, "aLookAngle",		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight",	"AmbientLight" )

PANEL.CreationTime = 0

function PANEL:Init()
	local node
	local screenscale = BetterScreenScale()

	self.DirectionalLight = {}
	self.FarZ = 32000

	self.MainMenu = GAMEMODE.RemantlerInterface
	self.RemantleNodes = {}
	self.RemantleNodes[0] = {}

	if not SelectedInv() and self.MainMenu.m_WepClass then
		self.GunTab = weapons.Get(self.MainMenu.m_WepClass)
		local gtbl = self.GunTab
		local curqua = gtbl.QualityTier

		if gtbl.AllowQualityWeapons then
			local branches = gtbl.Branches

			if branches then
				for no, _ in pairs(branches) do
					self.RemantleNodes[no] = {}
				end
			end

			self.OrigTab = gtbl.BaseQuality and weapons.Get(gtbl.BaseQuality) or gtbl

			for i = 0, #GAMEMODE.WeaponQualities do
				node = ClientsideModel("models/props/cs_italy/orange.mdl", RENDER_GROUP_OPAQUE_ENTITY)
				if IsValid(node) then
					node:SetNoDraw(true)
					node:SetPos(Vector(0, -48 + i * 30, i > 0 and branches and 0 or -9))

					node.Unlocked = i == 0 or (curqua and curqua >= i or nil)
					if i ~= 0 and curqua and curqua >= 1 and gtbl.Branch then
						node.Locked = true
					end
					self.RemantleNodes[0][i] = node
				end

				if i > 0 and branches then
					for no, br in pairs(branches) do
						node = ClientsideModel("models/props/cs_italy/orange.mdl", RENDER_GROUP_OPAQUE_ENTITY)
						if IsValid(node) then
							node:SetNoDraw(true)
							node:SetPos(Vector(0, -48 + i * 30, 0 - (16/#branches)*no))

							node.Unlocked = i == 0 or (curqua and curqua >= i or nil)
							if curqua and curqua >= 1 and gtbl.Branch ~= no then
								node.Locked = true
							end
							node.Name = br and br.NewNames and br.NewNames[i] or nil
							self.RemantleNodes[no][i] = node
						end
					end
				end
			end
		end
	end

	self:SetCamPos( Vector( 20000, 0, 0 ) )
	self:SetLookAt( Vector( 0, 0, 0 ) )
	self:SetFOV( 5 )

	self:SetAmbientLight( Color( 50, 50, 50 ) )

	self:SetDirectionalLight( BOX_TOP, color_white )
	self:SetDirectionalLight( BOX_FRONT, color_white )

	local top = vgui.Create("Panel", self)
	top:SetSize(ScrW(), 256)
	top:SetMouseInputEnabled(false)

	local qualityname = vgui.Create("DLabel", top)
	qualityname:SetFont("ZSHUDFont")
	qualityname:SetTextColor(COLOR_WHITE)
	qualityname:SetContentAlignment(8)
	qualityname:Dock(TOP)

	local desc = {}
	for i=1, 5 do
		local qualityd = vgui.Create("DLabel", top)
		qualityd:SetFont("ZSHUDFontSmallest")
		qualityd:SetTextColor(COLOR_GRAY)
		qualityd:SetContentAlignment(8)
		qualityd:Dock(TOP)
		table.insert(desc, qualityd)
	end

	local bottom = vgui.Create("Panel", self)
	bottom:SetSize(ScrW(), 36 * screenscale)
	bottom:SetMouseInputEnabled(false)

	local scrapcost = vgui.Create("DLabel", bottom)
	scrapcost:SetFont("ZSHUDFontSmaller")
	scrapcost:SetTextColor(COLOR_WHITE)
	scrapcost:SetContentAlignment(2)
	scrapcost:Dock(TOP)

	self.Top = top
	self.QualityName = qualityname
	self.QualityDesc = desc
	self.Bottom = bottom
	self.ScrapCost = scrapcost

	top:SetAlpha(0)
	bottom:SetAlpha(0)

	self:DockMargin(0, 0, 0, 0)
	self:DockPadding(0, 0, 0, 0)
	self:Dock(FILL)
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local screenscale = BetterScreenScale()

	self.Top:AlignTop(4)
	self.Top:CenterHorizontal()

	self.Bottom:AlignBottom(10 * screenscale)
	self.Bottom:CenterHorizontal()
end

function PANEL:SetDirectionalLight(iDirection, color)
	self.DirectionalLight[iDirection] = color
end

local matBeam = Material("trails/laser")
local matGlow = Material("sprites/glow04_noz")
local matWhite = Material("models/debug/debugwhite")
local colBeam = Color(0, 0, 0)
local colBeam2 = Color(255, 255, 255)
local colGlow = Color(0, 0, 0)
function PANEL:Paint(w, h)
	local realtime = RealTime()
	local nodepos, selected
	local col, othernodepos
	local add, pos_a, pos_b, sat
	local size, ang

	local campos = self.vCamPos
	campos.x = 1600
	campos.y = math.Clamp(campos.y, -262, 262)
	campos.z = math.Clamp(campos.z, -262, 262)

	self:SetCamPos(campos)
	self.vLookatPos:Set(campos)
	self.vLookatPos.x = 0

	self:SetCamPos(campos)

	surface.SetDrawColor(15, 20, 25, 230)
	surface.DrawRect(0, 0, w, h)

	ang = self.aLookAngle
	if not ang then
		ang = (self.vLookatPos - self.vCamPos):Angle()
	end
	local to_camera = ang:Forward() * -1

	local x, y = self:LocalToScreen(0, 0)

	local mx, my = gui.MousePos()
	local aimvector = util.AimVector(ang, self.fFOV, mx - x, my - y, w, h)
	local intersectpos = util.IntersectRayWithPlane(self.vCamPos, aimvector, self:GetLookAt(), Vector(-1, 0, 0))

	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
	cam.IgnoreZ( true )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( vector_origin )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )

	for i=0, 6 do
		col = self.DirectionalLight[ i ]
		if col then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end

	render.SetMaterial(matBeam)
	for branch, nodes in pairs(self.RemantleNodes) do
		for id, node in pairs(nodes) do
			if IsValid(node) then
				nodepos = node:GetPos()
				othernodes = {}

				if id > 0 then
					othernodes[#othernodes+1] = nodes[id + 1]
				else
					for i = 0, #self.RemantleNodes do
						othernodes[#othernodes+1] = self.RemantleNodes[i][1]
					end
				end

				for _, othernode in pairs(othernodes) do
					if IsValid(othernode) then
						othernodepos = othernode:GetPos()

						local beamsize = 4
						if othernode.Unlocked then
							colBeam.r = 32
							colBeam.g = 128
							colBeam.b = 255
						elseif node.Unlocked then
							colBeam.r = 255
							colBeam.g = 192
							colBeam.b = 0
						else
							colBeam.r = 128
							colBeam.g = 40
							colBeam.b = 40

							beamsize = 2
						end

						if hovquality and hovquality >= id - 1 and hovquality <= id + 1 and hovbranch == branch then
							add = math.abs(math.sin(realtime * math.pi)) * 120
							colBeam.r = math.min(colBeam.r + add, 255)
							colBeam.g = math.min(colBeam.g + add, 255)
							colBeam.b = math.min(colBeam.b + add, 255)

							colBeam.a = 180
							colBeam2.a = 190
						else
							colBeam.a = 110
							colBeam2.a = 110
						end

						pos_a = nodepos + Vector(-16, 0, 0)
						pos_b = othernodepos + Vector(-16, 0, 0)

						render.DrawBeam(pos_a, pos_b, beamsize, 0, 1, colBeam2)
						render.DrawBeam(pos_a, pos_b, 8, 0, 1, colBeam)
					end
				end
			end
		end
	end

	local oldquality = hovquality
	local oldbranch = hovbranch
	hovquality = nil
	hovbranch = nil

	local angle = (realtime * 180) % 360

	for branch, nodes in pairs(self.RemantleNodes) do
		for id, node in pairs(nodes) do
			if IsValid(node) then
				nodepos = node:GetPos()
				selected = intersectpos and nodepos:DistToSqr(intersectpos) <= 36

				cam.Start3D2D(node:GetPos() - to_camera * 8, Angle(0, 90, 90), 0.08)
				surface.DisableClipping(true)
				DisableClipping(true)

				if selected then
					hovquality = id
					hovbranch = branch

					sat = 1 - math.abs(math.sin(realtime * math.pi)) * 0.25
				else
					sat = 1
				end

				local prevnode = nodes[id - 1] or id == 1 and self.RemantleNodes[0][0]
				if node.Locked then
					render.SetColorModulation(sat / 4, sat / 4, sat / 4)
				elseif node.Unlocked then
					render.SetColorModulation(sat / 4, sat / 4, sat)
				elseif prevnode.Unlocked and not node.Unlocked then
					render.SetColorModulation(sat, sat / 2, 0)
				else
					render.SetColorModulation(sat / 2, 0, 0)
				end
				render.ModelMaterialOverride(matWhite)

				node:DrawModel()

				render.ModelMaterialOverride()
				render.SetColorModulation(1, 1, 1)

				local txt = "Standard"
				local quals = GAMEMODE.WeaponQualities[id]
				if quals then
					txt = node.Name or branch == 0 and quals[1] or quals[3]
				end

				draw.SimpleText(txt, "ZS3D2DFont2", -x, -y, selected and color_white or COLOR_GRAY, TEXT_ALIGN_CENTER)

				DisableClipping(false)
				surface.DisableClipping(false)
				cam.End3D2D()

				if not node.Locked then
					render.SetMaterial(matGlow)
					colGlow.r = sat * 255 colGlow.g = sat * 255 colGlow.b = sat * 255
					if node.Unlocked then
						colGlow.r = colGlow.r / 4
						colGlow.g = colGlow.g / 4
					elseif not node.Unlocked then
						if prevnode.Unlocked then
							colGlow.g = colGlow.g / 1.5
							colGlow.b = 0
						else
							colGlow.r = colGlow.r / 1.5
							colGlow.g = 0
							colGlow.b = 0
						end
					end
					size = selected and 30 or 20
					render.DrawQuadEasy(nodepos, to_camera, size, size, colGlow, angle)
					angle = angle + 45
				end
			end
		end
	end

	if intersectpos then
		intersectpos = intersectpos + Vector(16, 0, 0)
		render.SetMaterial(matGlow)
		render.DrawQuadEasy(intersectpos, to_camera, 12, 12, color_white, realtime * 90)
	end

	render.SuppressEngineLighting(false)

	cam.IgnoreZ(false)
	cam.End3D()

	if oldquality ~= hovquality or oldbranch ~= hovbranch then
		self.Top:Stop()
		self.Bottom:Stop()

		if hovquality and hovbranch then
			local txt, scost = "Standard", ""

			local quals = GAMEMODE.WeaponQualities[hovquality]
			if quals then
				txt = self.RemantleNodes[hovbranch][hovquality].Name or hovbranch == 0 and quals[1] or quals[3]
				scost = GAMEMODE:GetUpgradeScrap(self.GunTab, hovquality)
			end

			self.QualityName:SetText(txt)
			self.QualityName:SizeToContents()

			self.ScrapCost:SetText(scost ~= "" and "Scrap Cost: " .. scost or "")
			self.ScrapCost:SetTextColor(scost ~= "" and MySelf:GetAmmoCount("scrap") >= scost and COLOR_WHITE or COLOR_RED)
			self.ScrapCost:SizeToContents()

			local dtxt
			local altdesc = self.OrigTab.RemantleDescs
			local altdescs = altdesc and altdesc[hovbranch][hovquality]

			for i=1, 5 do
				dtxt = " "
				if txt ~= "Standard" and altdesc and altdescs and altdescs[i] then
					dtxt = altdescs[i]
				end

				self.QualityDesc[i]:SetTextColor(i == 1 and hovbranch ~= 0 and COLOR_WHITE or COLOR_GREEN)
				self.QualityDesc[i]:SetText(dtxt)
				self.QualityDesc[i]:SizeToContents()
			end

			surface.PlaySound("zombiesurvival/ui/misc1.ogg")

			self.Top:SetAlpha(0)
			self.Top:AlphaTo(195, 0.1)

			self.Bottom:SetAlpha(0)
			self.Bottom:AlphaTo(140, 0.1)
		else
			self.Top:AlphaTo(0, 0.1)
			self.Bottom:AlphaTo(0, 0.1)
		end
	end

	return true
end

net.Receive("zs_remantleconf", function()
	if not (GAMEMODE.RemantlerInterface and GAMEMODE.RemantlerInterface:IsValid() and hovquality and hovbranch) then return end

	local ri = GAMEMODE.RemantlerInterface
	local path = ri.RemantlePath

	local wepclass = ri.m_WepClass
	local contentsqua = GAMEMODE.GunTab.QualityTier
	local desiredqua = contentsqua and contentsqua + 1 or 1
	local upgclass = GAMEMODE:GetWeaponClassOfQuality(not contentsqua and wepclass or GAMEMODE.GunTab.BaseQuality, desiredqua)

	GAMEMODE.GunTab = weapons.Get(upgclass)
	local gtbl = GAMEMODE.GunTab
	local scost = GAMEMODE:GetUpgradeScrap(gtbl, desiredqua)

	path.RemantleNodes[hovbranch][hovquality].Unlocked = true
	path.ScrapCost:SetTextColor((MySelf:GetAmmoCount("scrap") - scost) >= scost and COLOR_WHITE or COLOR_RED)

	ri.m_ContentsLabel:SetText(gtbl.PrintName)
	ri.m_ContentsLabel:SizeToContents()
	ri.m_ContentsLabel:CenterHorizontal()

	local retscrap = GAMEMODE:GetDismantleScrap(gtbl)
	local disscraptxt = gtbl.NoDismantle and "Cannot Dismantle" or "Dismantle for " .. retscrap .. " Scrap"

	ri.m_Dismantle:SetText(disscraptxt)
	ri.m_Dismantle:SizeToContents()
	ri.m_Dismantle:CenterHorizontal()

	ri.m_DisaButton:SetDisabled(gtbl.NoDismantle)
	ri.m_DisaButton:SetTextColor(gtbl.NoDismantle and COLOR_DARKGRAY or COLOR_WHITE)
end)

function PANEL:OnMousePressed(mc)
	if mc == MOUSE_LEFT and hovquality and hovbranch and hovquality ~= 0 then
		local gtbl = self.GunTab
		local cqua = gtbl.QualityTier or 0

		local current = self.RemantleNodes[hovbranch][hovquality]
		local prev = self.RemantleNodes[hovbranch][hovquality - 1] or hovquality == 1 and self.RemantleNodes[0][0]
		if cqua and hovquality > cqua and prev and prev.Unlocked and not current.Locked then
			if self.GunTab.AmmoIfHas and MySelf:GetAmmoCount(self.GunTab.Primary.Ammo) == 0 then
				GAMEMODE:CenterNotify(COLOR_RED, "You don't have the deployable ammo type for this!")
				surface.PlaySound("buttons/button8.wav")

				return
			end

			local scost = GAMEMODE:GetUpgradeScrap(self.GunTab, hovquality)
			if MySelf:GetAmmoCount("scrap") >= scost then
				RunConsoleCommand("zs_upgrade", hovbranch ~= 0 and hovbranch)

				return
			else
				GAMEMODE:CenterNotify(COLOR_RED, "You need enough scrap to upgrade this weapon!")
				surface.PlaySound("buttons/button8.wav")

				return
			end
		else
			GAMEMODE:CenterNotify(COLOR_RED, "You must upgrade your weapon to the correct quality first!")
			surface.PlaySound("buttons/button8.wav")

			return
		end
	end
end

vgui.Register("ZSRemantlePath", PANEL, "Panel")

function GM:OpenRemantlerMenu(remantler)
	if not (remantler and remantler:IsValid()) or (self.RemantlerInterface and self.RemantlerInterface:IsVisible()) then return end
	local mytarget = SelectedInv() or MySelf:GetActiveWeapon():GetClass()

	if self.RemantlerInterface and self.RemantlerInterface:IsValid() and self.RemantlerInterface.m_WepClass == mytarget then
		self.RemantlerInterface:SetVisible(true)
		self.RemantlerInterface:CenterMouse()
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
	frame.CenterMouse = RemantlerCenterMouse
	self.RemantlerInterface = frame

	frame.m_Remantler = remantler
	frame.m_WepClass = mytarget

	if not SelectedInv() then
		self.GunTab = weapons.Get(frame.m_WepClass)
	else
		self.GunTab = GAMEMODE.ZSInventoryItemData[frame.m_WepClass]
	end

	local gtbl = self.GunTab
	if not SelectedInv() and not (gtbl.AllowQualityWeapons or gtbl.PermitDismantle) then
		frame.m_WepClass, gtbl = nil, nil
	elseif SelectedInv() and ((gtbl.PermitDismantle ~= nil and not gtbl.PermitDismantle) or (self:GetInventoryItemType(mytarget) ~= INVCAT_TRINKETS)) then
		frame.m_WepClass, gtbl = nil, nil
	end

	local topspace = vgui.Create("DPanel", frame)
	topspace:SetWide(wid - 16)

	local title = EasyLabel(topspace, "Weapon Remantler", "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()
	local subtitle = EasyLabel(topspace, "Dismantle weapons into scrap and use scrap to upgrade weapons!", "ZSHUDFontTiny", COLOR_WHITE)
	subtitle:CenterHorizontal()
	subtitle:MoveBelow(title, 4)

	local _, y = subtitle:GetPos()
	topspace:SetTall(y + subtitle:GetTall() + 4)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local bottomspace = vgui.Create("DPanel", frame)
	bottomspace:SetWide(topspace:GetWide())

	local pointslabel = EasyLabel(bottomspace, "Scrap for usage: 0", "ZSHUDFontTiny", COLOR_GREEN)
	pointslabel:AlignTop(4)
	pointslabel:AlignLeft(8)
	pointslabel.Think = ScrapLabelThink

	local lab = EasyLabel(bottomspace, "Disassembling your weapons cannot be reversed!", "ZSHUDFontTiny")
	lab:AlignTop(4)
	lab:AlignRight(4)
	frame.m_AdviceLabel = lab

	_, y = lab:GetPos()
	bottomspace:SetTall(y + lab:GetTall() + 4)
	bottomspace:AlignBottom(8)
	bottomspace:CenterHorizontal()

	local __, topy = topspace:GetPos()
	local ___, boty = bottomspace:GetPos()

	local remprop = vgui.Create("DPropertySheet", frame)
	remprop:SetSize(wid - 8, boty - topy - 8 - topspace:GetTall())
	remprop:MoveBelow(topspace, 4)
	remprop:CenterHorizontal()
	remprop.Paint = function() end
	remprop:SetPadding(0)

	local remantleframe = vgui.Create("DPanel", remprop)
	local sheet = remprop:AddSheet("Remantling", remantleframe, "icon16/arrow_up.png", false, false)
	sheet.Panel:SetPos(0, tabhei + 2)
	remantleframe.Paint = function(me, w, h) surface.SetDrawColor(31, 33, 35, 255) surface.DrawRect(0, 0, w, h) end
	remantleframe:SetSize(wid - 8, boty - topy - 8 - topspace:GetTall())

	local trinketsframe = vgui.Create("DPanel")
	sheet = remprop:AddSheet("Trinkets", trinketsframe, GAMEMODE.ItemCategoryIcons[ITEMCAT_TRINKETS], false, false)
	sheet.Panel:SetPos(0, tabhei + 2)
	trinketsframe:SetSize(wid - 8, boty - topy - 8 - topspace:GetTall())
	trinketsframe:SetPaintBackground(false)
	frame.TrinketsFrame = trinketsframe

	local ammoframe = vgui.Create("DPanel")
	sheet = remprop:AddSheet("Ammunition", ammoframe, GAMEMODE.ItemCategoryIcons[ITEMCAT_AMMO], false, false)
	sheet.Panel:SetPos(0, tabhei + 2)
	ammoframe:SetSize(wid - 8, boty - topy - 8 - topspace:GetTall())
	ammoframe:SetPaintBackground(true)
	frame.m_AmmoFrame = ammoframe

	local subpropertysheet
	for frameindex = 0, 1 do
		local curframe = frameindex == 0 and trinketsframe or ammoframe

		if frameindex == 0 then
			local tabpane = vgui.Create("DPanel", curframe)
			--tabpane.Paint = function() end
			tabpane.Grids = {}
			tabpane.Buttons = {}
			tabpane:SetSize(curframe:GetWide(), curframe:GetTall())

			local offset = 64 * screenscale
			local itemframe = vgui.Create("DScrollPanel", tabpane)
			itemframe:SetSize(curframe:GetWide(), curframe:GetTall() - offset - 32)
			itemframe:SetPos(0, offset)

			local mkgrid = function()
				local list = vgui.Create("DGrid", itemframe)
				list:SetPos(0, 0)
				list:SetSize(curframe:GetWide() - 312, curframe:GetTall())
				list:SetCols(2)
				list:SetColWide(280 * screenscale)
				list:SetRowHeight(64 * screenscale)

				return list
			end

			local subcats = GAMEMODE.ItemSubCategories
			local tbn
			for j = 1, #subcats do
				local ispacer = ((j-1) % 3)+1

				tbn = EasyButton(tabpane, subcats[j], 8, 4)
				tbn:SetFont("ZSHUDFontSmallest")
				tbn:SetAlpha(j == 1 and 255 or 70)
				tbn:AlignRight(800 * screenscale - (ispacer - 1) * 190 * screenscale)
				tbn:AlignTop(j <= 3 and 0 or 28)
				tbn:SizeToContents()
				tbn.DoClick = function(me)
					for k, v in pairs(tabpane.Grids) do
						v:SetVisible(k == j)
						tabpane.Buttons[k]:SetAlpha(k == j and 255 or 70)
					end
				end

				tabpane.Grids[j] = mkgrid()
				tabpane.Grids[j]:SetVisible(j == 1)
				tabpane.Buttons[j] = tbn
			end

			for j, tab in ipairs(GAMEMODE.Items) do
				if tab.PointShop and tab.Category == ITEMCAT_TRINKETS then
					self:AddShopItem(tabpane.Grids[tab.SubCategory], j, tab, false, true)
				end
			end
		else
			local list = vgui.Create("DGrid", curframe)
			list:SetPos(0, 0)
			list:SetSize(curframe:GetWide() - 312, curframe:GetTall())
			list:SetCols(3)
			list:SetColWide(290 * screenscale)
			list:SetRowHeight(100 * screenscale)

			list:SetPos(8, 16)
			list:SetWide(ammoframe:GetWide() - 16)
			list:SetTall(ammoframe:GetTall() - 32)

			for j, tab in ipairs(GAMEMODE.Items) do
				if tab.PointShop and tab.Category == ITEMCAT_AMMO or tab.CanMakeFromScrap then
					self:AddShopItem(list, j, tab, false, true)
				end
			end
		end
	end
	frame.m_SubProp = subpropertysheet

	self:CreateItemInfoViewer(trinketsframe, frame, topspace, bottomspace, MENU_REMANTLER)

	local scroller = remprop:GetChildren()[1]
	local dragbase = scroller:GetChildren()[1]
	local tabs = dragbase:GetChildren()

	self:ConfigureMenuTabs(tabs, tabhei)

	local contents = EasyLabel(remantleframe, gtbl and gtbl.PrintName or "EMPTY", "ZSHUDFontSmall", COLOR_WHITE)
	contents:AlignTop(16 * screenscale)
	contents:CenterHorizontal()
	frame.m_ContentsLabel = contents

	local upgpathf = vgui.Create("DPanel", remantleframe)
	upgpathf:SetSize(wid - 16, remantleframe:GetTall() / 1.75)
	upgpathf:MoveBelow(contents, 24 * screenscale)
	upgpathf:CenterHorizontal()

	frame.RemantlePath = vgui.Create("ZSRemantlePath", upgpathf)

	local disabtn = EasyButton(remantleframe, "Dismantle Weapon", 8, 4)
	disabtn:SetFont("ZSHUDFont")
	disabtn:SizeToContents()
	disabtn:MoveBelow(upgpathf, 32 * screenscale)
	disabtn:CenterHorizontal()
	disabtn.DoClick = DismantleClick
	if not gtbl then
		disabtn:SetDisabled(true)
	else
		disabtn:SetDisabled(gtbl.NoDismantle)
	end
	disabtn:SetTextColor(gtbl and gtbl.NoDismantle and COLOR_DARKGRAY or gtbl and COLOR_WHITE or COLOR_DARKGRAY)
	frame.m_DisaButton = disabtn

	local disscraptxt = ""
	if gtbl then
		local retscrap = self:GetDismantleScrap(gtbl, SelectedInv())
		disscraptxt = gtbl.NoDismantle and "Cannot Dismantle" or "Dismantle for " .. retscrap .. " Scrap"
	end

	local disscrap = EasyLabel(remantleframe, disscraptxt, "ZSHUDFontSmaller", COLOR_WHITE)
	disscrap:MoveBelow(disabtn, 4 * screenscale)
	disscrap:CenterHorizontal()
	frame.m_Dismantle = disscrap

	local breakdowns = self.Breakdowns[frame.m_WepClass]
	local compdistxt = breakdowns and self.ZSInventoryItemData[breakdowns.Result].PrintName or ""

	local compdisl = EasyLabel(remantleframe, compdistxt, "ZSHUDFontSmaller", COLOR_WHITE)
	compdisl:MoveBelow(disscrap, 4 * screenscale)
	compdisl:CenterHorizontal()
	frame.m_ComponentDis = compdisl

	frame:MakePopup()
	frame:CenterMouse()
end
