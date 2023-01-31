CreateClientConVar("zs_bossclass", "", true, true)

local Window
local HoveredClassWindow

local function CreateHoveredClassWindow(classtable)
	if HoveredClassWindow and HoveredClassWindow:IsValid() then
		HoveredClassWindow:Remove()
	end

	HoveredClassWindow = vgui.Create("ClassInfo")
	HoveredClassWindow:SetSize(ScrW() * 0.5, 128)
	HoveredClassWindow:CenterHorizontal()
	HoveredClassWindow:MoveBelow(Window, 32)
	HoveredClassWindow:SetClassTable(classtable)
end

function GM:OpenClassSelect()
	if Window and Window:IsValid() then Window:Remove() end

	Window = vgui.Create("ClassSelect")
	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.1)

	Window:MakePopup()

	Window:InvalidateLayout()

	PlayMenuOpenSound()
end

local PANEL = {}

PANEL.Rows = 2

local bossmode = false
local function BossTypeDoClick(self)
	bossmode = not bossmode
	GAMEMODE:OpenClassSelect()
end

function PANEL:Init()
	self.ClassButtons = {}

	self.ClassTypeButton = EasyButton(nil, bossmode and "Open Normal Class Selection" or "Open Boss Class Selection", 8, 4)
	self.ClassTypeButton:SetFont("ZSHUDFontSmall")
	self.ClassTypeButton:SizeToContents()
	self.ClassTypeButton.DoClick = BossTypeDoClick

	self.CloseButton = EasyButton(nil, "Close", 8, 4)
	self.CloseButton:SetFont("ZSHUDFontSmall")
	self.CloseButton:SizeToContents()
	self.CloseButton.DoClick = function() Window:Remove() end

	if GAMEMODE:CanRedeem(MySelf) and MySelf:Frags() >= GAMEMODE:GetRedeemBrains() or GAMEMODE:CanSelfRedeem(MySelf) then
		self.RedeemButton = EasyButton(nil, "Redeem", 8, 4)
		self.RedeemButton:SetFont("ZSHUDFontSmall")
		self.RedeemButton:SizeToContents()
		self.RedeemButton.DoClick = function() net.Start("zs_redeembutton") net.SendToServer() Window:Remove() end
	end

	local lowundead = team.NumPlayers(TEAM_UNDEAD) * 2 < team.NumPlayers(TEAM_HUMAN)
	
	if lowundead then
		self.LowZombieCountLabel = EasyLabel(nil, (self.ObjectiveMap or self.ZombieEscape) and "Zombies have +25% health boost" or "Zombies have +20% health boost", "ZSHUDFontSmallest", color_white)
		self.LowZombieCountLabel:SetToolTip("If there are less than 4 players in zombie team, zombies get +20% health boost")
		self.LowZombieCountLabel:SizeToContents()
	end

	self.ButtonGrid = vgui.Create("DGrid", self)
	self.ButtonGrid:SetContentAlignment(5)
	self.ButtonGrid:Dock(FILL)

	local already_added = {}
	local use_better_versions = GAMEMODE:ShouldUseBetterVersionSystem()

	for i=1, #GAMEMODE.ZombieClasses do
		if GAMEMODE.ClassicMode then break end

		local classtab = GAMEMODE.ZombieClasses[GAMEMODE:GetBestAvailableZombieClass(i)]

		if classtab and not classtab.Disabled and not already_added[classtab.Index] then
			already_added[classtab.Index] = true

			local ok
			if bossmode then
				ok = classtab.Boss
			else
				ok = not classtab.Boss and
					(not classtab.Hidden or classtab.CanUse and classtab:CanUse(MySelf)) and
					(not GAMEMODE.ObjectiveMap or classtab.Unlocked)
			end

			if ok then
				if not use_better_versions or not classtab.BetterVersionOf or GAMEMODE:IsClassUnlocked(classtab.Index) then
					local button = vgui.Create("ClassButton")
					button:SetClassTable(classtab)
					button.Wave = classtab.Wave or 1

					table.insert(self.ClassButtons, button)

					self.ButtonGrid:AddItem(button)
				end
			end
		end
	end

	self.ButtonGrid:SortByMember("Wave")
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	if #self.ClassButtons < 8 then self.Rows = 1 end
	if #self.ClassButtons >= 28 then self.Rows = 3 end
	if #self.ClassButtons >= 60 then self.Rows = 4 end

	local cols = math.ceil(#self.ClassButtons / self.Rows)
	local cell_size = ScrW() / cols
	cell_size = math.min(ScrW() / 7, cell_size)

	self:SetSize(ScrW(), self.Rows * cell_size)
	self:CenterHorizontal()
	self:CenterVertical(0.35)

	local button = self.ClassTypeButton

	if IsValid(button) then
		button:MoveAbove(self, 16)
		button:CenterHorizontal()
	end

	button = self.CloseButton
	if IsValid(button) then
		button:MoveAbove(self, 16)
		button:CenterHorizontal(0.9)
	end

	button = self.RedeemButton
	if IsValid(button) then
	
		button:MoveAbove(self, 16)
		button:CenterHorizontal(0.1)
	end

	button = self.LowZombieCountLabel
	if IsValid(button) then

		button:MoveAbove(self, 16)
		button:CenterHorizontal(0.3)
	end

	button = self.ButtonGrid
	button:SetCols(cols)
	button:SetColWide(cell_size)
	button:SetRowHeight(cell_size)
end

function PANEL:OnRemove()
	local button = self.ClassTypeButton
	if IsValid(button) then button:Remove() end
	button = self.CloseButton
	if IsValid(button) then button:Remove() end
	button = self.RedeemButton
	if IsValid(button) then button:Remove() end
	button = self.LowZombieCountLabel
	if IsValid(button) then button:Remove() end
end

local texUpEdge = surface.GetTextureID("gui/gradient_up")
local texDownEdge = surface.GetTextureID("gui/gradient_down")
function PANEL:Paint()
	local wid, hei = self:GetSize()
	local edgesize = 16

	DisableClipping(true)
	surface.SetDrawColor(Color(0, 0, 0, 220))
	surface.DrawRect(0, 0, wid, hei)
	surface.SetTexture(texUpEdge)
	surface.DrawTexturedRect(0, -edgesize, wid, edgesize)
	surface.SetTexture(texDownEdge)
	surface.DrawTexturedRect(0, hei, wid, edgesize)
	DisableClipping(false)

	return true
end

vgui.Register("ClassSelect", PANEL, "Panel")

PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetContentAlignment(5)

	self.NameLabel = vgui.Create("DLabel", self)
	self.NameLabel:SetFont("ZSHUDFontSmaller")
	self.NameLabel:SetAlpha(170)

	self.Image = vgui.Create("DImage", self)

	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local cell_size = self:GetParent():GetColWide()

	self:SetSize(cell_size, cell_size)

	self.Image:SetSize(cell_size * 0.75, cell_size * 0.75)
	self.Image:AlignTop(8)
	self.Image:CenterHorizontal()

	self.NameLabel:SizeToContents()
	self.NameLabel:AlignBottom(8)
	self.NameLabel:CenterHorizontal()
end

function PANEL:SetClassTable(classtable)
	self.ClassTable = classtable

	local len = #translate.Get(classtable.TranslationName)

	self.NameLabel:SetText(translate.Get(classtable.TranslationName))
	self.NameLabel:SetFont(len > 15 and "ZSHUDFontTiny" or len > 11 and "ZSHUDFontSmallest" or "ZSHUDFontSmaller")

	self.Image:SetImage(classtable.Icon)
	self.Image:SetImageColor(classtable.IconColor or color_white)

	self:InvalidateLayout()
end

function PANEL:DoClick()
	if self.ClassTable then
		if self.ClassTable.Boss then
			RunConsoleCommand("zs_bossclass", self.ClassTable.Name)
			GAMEMODE:CenterNotify(translate.Format("boss_class_select", self.ClassTable.Name))
		else
			net.Start("zs_changeclass")
				net.WriteString(self.ClassTable.Name)
				net.WriteBool(GAMEMODE.SuicideOnChangeClass)
			net.SendToServer()
		end
	end

	surface.PlaySound("buttons/button15.wav")

	Window:Remove()
	bossmode = false
end

function PANEL:Paint()
	return true
end

function PANEL:OnCursorEntered()
	self.NameLabel:SetAlpha(230)

	CreateHoveredClassWindow(self.ClassTable)
end

function PANEL:OnCursorExited()
	self.NameLabel:SetAlpha(170)

	if HoveredClassWindow and HoveredClassWindow:IsValid() and HoveredClassWindow.ClassTable == self.ClassTable then
		HoveredClassWindow:Remove()
	end
end

function PANEL:Think()
	if not self.ClassTable then return end

	local enabled
	if MySelf:GetZombieClass() == self.ClassTable.Index then
		enabled = 2
	elseif self.ClassTable.Boss or gamemode.Call("IsClassUnlocked", self.ClassTable.Index) then
		enabled = 1
	else
		enabled = 0
	end

	if enabled ~= self.LastEnabledState then
		self.LastEnabledState = enabled

		if enabled == 2 then
			self.NameLabel:SetTextColor(COLOR_GREEN)
			self.Image:SetImageColor(self.ClassTable.IconColor or color_white)
			self.Image:SetAlpha(245)
		elseif enabled == 1 then
			self.NameLabel:SetTextColor(COLOR_GRAY)
			self.Image:SetImageColor(self.ClassTable.IconColor or color_white)
			self.Image:SetAlpha(245)
		else
			self.NameLabel:SetTextColor(COLOR_DARKRED)
			self.Image:SetImageColor(COLOR_DARKRED)
			self.Image:SetAlpha(170)
		end
	end
end

vgui.Register("ClassButton", PANEL, "Button")

PANEL = {}

function PANEL:Init()
	self.NameLabel = vgui.Create("DLabel", self)
	self.NameLabel:SetFont("ZSHUDFontSmaller")

	self.DescLabels = self.DescLabels or {}

	self:InvalidateLayout()
end

function PANEL:SetClassTable(classtable)
	self.ClassTable = classtable

	self.NameLabel:SetText(translate.Get(classtable.TranslationName))
	self.NameLabel:SizeToContents()

	self:CreateDescLabels()

	self:InvalidateLayout()
end

function PANEL:RemoveDescLabels()
	for _, label in pairs(self.DescLabels) do
		label:Remove()
	end

	self.DescLabels = {}
end

function PANEL:CreateDescLabels()
	self:RemoveDescLabels()

	self.DescLabels = {}

	local classtable = self.ClassTable
	if not classtable or not classtable.Description then return end

	local lines = {}

	if classtable.Wave and classtable.Wave > 0 then
		table.insert(lines, translate.Format("unlocked_on_wave_x", classtable.Wave))
	end
	if classtable.Infliction and classtable.Infliction > 0 then
		table.insert(lines, Format("Unlocked on %d%% infliction", (classtable.Infliction or 0) * 100))
	end

	if classtable.BetterVersion then
		local betterclasstable = GAMEMODE.ZombieClasses[classtable.BetterVersion]
		if betterclasstable then
			table.insert(lines, translate.Format("evolves_in_to_x_on_wave_y", betterclasstable.Name, betterclasstable.Wave))
		end
	end

	table.insert(lines, " ")
	table.Add(lines, string.Explode("\n", translate.Get(classtable.Description)))

	if classtable.Help then
		table.insert(lines, " ")
		table.Add(lines, string.Explode("\n", translate.Get(classtable.Help)))
	end

	table.insert(lines, " ")
	local hp = (classtable.Health or 0) + ((classtable.DynamicHealth or 0) * math.max(0, GAMEMODE:GetWave() - 1))
	table.Add(lines, string.Explode("\n", Format("Health: %d (Default HP: %d, +%d HP per every wave)", hp, classtable.Health or 0, classtable.DynamicHealth or 0)))
	table.Add(lines, string.Explode("\n", Format("Speed: %d", classtable.Speed or 0)))
	local wep = weapons.Get(classtable.SWEP)
	table.Add(lines, string.Explode("\n", Format("Damage per hit: %s (To props: %s)", wep.MeleeDamage or wep.PounceDamage or 0, wep.MeleeDamageVsProps or wep.MeleeDamage or wep.PounceDamage or 0)))
	table.Add(lines, string.Explode("\n", Format("Points gained on killing class (on full health): %s", math.Round(classtable.Points or 0, 2))))

	for i, line in ipairs(lines) do
		local label = vgui.Create("DLabel", self)
		local notwaveone = classtable.Wave and classtable.Wave > 0

		label:SetText(line)
		if i == (notwaveone and classtable.Infliction and classtable.Infliction > 0 and 3 or notwaveone and 2 or 1) and classtable.BetterVersion then
			label:SetColor(COLOR_RORANGE)
		end
		if i == (notwaveone and 2 or 1) and classtable.Infliction and classtable.Infliction > 0 then
			label:SetColor(COLOR_DARKRED)
		end
		label:SetFont(i == 1 and notwaveone and "ZSBodyTextFontBig" or "ZSBodyTextFont")
		label:SizeToContents()
		table.insert(self.DescLabels, label)
	end
end

function PANEL:PerformLayout()
	self.NameLabel:SizeToContents()
	self.NameLabel:CenterHorizontal()

	local maxw = self.NameLabel:GetWide()
	for _, label in pairs(self.DescLabels) do
		maxw = math.max(maxw, label:GetWide())
	end
	self:SetWide(maxw + 64)
	self:CenterHorizontal()

	for i, label in ipairs(self.DescLabels) do
		label:MoveBelow(self.DescLabels[i - 1] or self.NameLabel)
		label:CenterHorizontal()
	end

	local lastlabel = self.DescLabels[#self.DescLabels] or self.NameLabel
	local _, y = lastlabel:GetPos()
	self:SetTall(y + lastlabel:GetTall())
end

function PANEL:Think()
	if not Window or not Window:IsValid() or not Window:IsVisible() then
		self:Remove()
	end
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "Frame", self, w, h)

	return true
end

vgui.Register("ClassInfo", PANEL, "Panel")
