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

    self.ClassTypeButton = EasyButton(nil, bossmode and translate.Get("class_select_open_normal") or translate.Get("class_select_open_boss"), 8, 4)
    self.ClassTypeButton:SetFont("ZSHUDFontSmall")
    self.ClassTypeButton:SizeToContents()
    self.ClassTypeButton.DoClick = BossTypeDoClick

    self.CloseButton = EasyButton(nil, translate.Get("class_select_close"), 8, 4)
    self.CloseButton:SetFont("ZSHUDFontSmall")
    self.CloseButton:SizeToContents()
    self.CloseButton.DoClick = function() Window:Remove() end

    self.ButtonGrid = vgui.Create("DGrid", self)
    self.ButtonGrid:SetContentAlignment(5)
    self.ButtonGrid:Dock(FILL)

    local already_added = {}
    local use_better_versions = GAMEMODE:ShouldUseBetterVersionSystem()

    for i=1, #GAMEMODE.ZombieClasses do
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

    local cols = math.ceil(#self.ClassButtons / self.Rows)
    local cell_size = ScrW() / cols
    cell_size = math.min(ScrW() / 7, cell_size)

    self:SetSize(ScrW(), self.Rows * cell_size)
    self:CenterHorizontal()
    self:CenterVertical(0.35)

    self.ClassTypeButton:MoveAbove(self, 16)
    self.ClassTypeButton:CenterHorizontal()

    self.CloseButton:MoveAbove(self, 16)
    self.CloseButton:CenterHorizontal(0.9)

    self.ButtonGrid:SetCols(cols)
    self.ButtonGrid:SetColWide(cell_size)
    self.ButtonGrid:SetRowHeight(cell_size)
end

function PANEL:OnRemove()
    self.ClassTypeButton:Remove()
    self.CloseButton:Remove()
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

    self.NameLabel = vgui.Create("DLabelAutoScroll", self)
    self.NameLabel:SetScrollingMode("time")
    self.NameLabel:SetContentAlignment(5)
    self.NameLabel:SetFont("ZSHUDFontSmaller")
    self.NameLabel:SetTextColor(Color(255, 255, 255, 170))
    self.NameLabel:SetScrollSpeed(45)
    self.NameLabel:SetEdgePause(1.0)

    self.Image = vgui.Create("DImage", self)

    self:InvalidateLayout()
end

function PANEL:PerformLayout()
    local cell_size = self:GetParent():GetColWide()

    self:SetSize(cell_size, cell_size)

    self.Image:SetSize(cell_size * 0.75, cell_size * 0.75)
    self.Image:AlignTop(8)
    self.Image:CenterHorizontal()

    local pad = 8
    local labelH = draw.GetFontHeight(self.NameLabel:GetFont() or "ZSHUDFontSmaller") + 2
    self.NameLabel:SetSize(cell_size - pad * 2, labelH)
    self.NameLabel:SetPos(pad, cell_size - labelH - pad)

    self:UpdateScrollState()
end

function PANEL:SetClassTable(classtable)
    self.ClassTable = classtable

    local text = translate.Get(classtable.TranslationName)
    local len  = #text

    local font
    if len > 30 then
        font = "ZSHUDFontTiny"
    elseif len > 22 then
        font = "ZSHUDFontSmallest"
    else
        font = "ZSHUDFontSmaller"
    end

    self.NameLabel:SetFont(font)
    self.NameLabel:SetText(text)

    self.Image:SetImage(classtable.Icon)
    self.Image:SetImageColor(classtable.IconColor or color_white)

    self:InvalidateLayout()
end

function PANEL:UpdateScrollState()
    if not self.NameLabel then return end

    local panelW = self.NameLabel:GetWide()
    if panelW <= 0 then return end

    local textW = self.NameLabel:GetContentSize()
    if textW > panelW then
        self.NameLabel:SetAutoScroll(true)
    else
        self.NameLabel:SetAutoScroll(false)
    end
end

function PANEL:DoClick()
    if self.ClassTable then
        if self.ClassTable.Boss then
            RunConsoleCommand("zs_bossclass", self.ClassTable.Name)
            GAMEMODE:CenterNotify(translate.Format("boss_class_select", translate.ClassName(translate.Get(GAMEMODE.ZombieClasses[self.ClassTable.Name].TranslationName))))
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
    CreateHoveredClassWindow(self.ClassTable)
end

function PANEL:OnCursorExited()
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


    if enabled ~= self.LastEnabledState or self.Hovered ~= self.LastHoveredState then
        self.LastEnabledState  = enabled
        self.LastHoveredState  = self.Hovered

        local basecol = (enabled == 2 and COLOR_GREEN)
                     or (enabled == 1 and COLOR_GRAY)
                     or COLOR_DARKRED
        local alpha   = self.Hovered and 255 or (enabled == 0 and 170 or 245)
        self.NameLabel:SetTextColor(Color(basecol.r, basecol.g, basecol.b, alpha))

        if enabled == 0 then
            self.Image:SetImageColor(COLOR_DARKRED)
            self.Image:SetAlpha(170)
        else
            self.Image:SetImageColor(self.ClassTable.IconColor or color_white)
            self.Image:SetAlpha(245)
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

    if classtable.BetterVersion then
        local betterclasstable = GAMEMODE.ZombieClasses[classtable.BetterVersion]
        if betterclasstable then
            table.insert(lines, translate.Format("evolves_in_to_x_on_wave_y", translate.ClassNameKeyFor("evolves_in_to_x_on_wave_y", betterclasstable.TranslationName, "acc"), betterclasstable.Wave))
        end
    end

    table.insert(lines, " ")
    table.Add(lines, string.Explode("\n", translate.Get(classtable.Description)))

    if classtable.Help then
        table.insert(lines, " ")
        table.Add(lines, string.Explode("\n", translate.Get(classtable.Help)))
    end

    for i, line in ipairs(lines) do
        local label = vgui.Create("DLabel", self)
        local notwaveone = classtable.Wave and classtable.Wave > 0

        label:SetText(translate.InterpolateBindNames(line)) 
        
        if i == (notwaveone and 2 or 1) and classtable.BetterVersion then
            label:SetColor(COLOR_RORANGE)
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