-- A DPanel with a single line of text and scrolling.
--
-- Two modes:
--   "cursor" (default) — progress is based on the X position of the cursor
--                        relative to the parent button.
--   "time"             — text smoothly slides back and forth on its own,
--                        with a pause at each edge so both the start and
--                        the end can be read.
--
-- NOTE: DLabel in GMod draws text with the engine — there's no way around it,
-- so this is a DPanel with the label API reimplemented manually.

local PANEL = {}

AccessorFunc(PANEL, "m_bAutoScroll", "AutoScroll", FORCE_BOOL)

local function MeasureText(text, font)
    if ZS_MeasureMixedText then
        return ZS_MeasureMixedText(text, font)
    end
    surface.SetFont(font)
    return surface.GetTextSize(text)
end

function PANEL:Init()
	self:SetAutoScroll(true)
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	self.m_strText      = ""
	self.m_Font         = "DermaDefault"
	self.m_TextColor    = Color(255, 255, 255, 255)
	self.m_ContentAlign = 0

	self.m_flLastT      = 0

	-- Scroll mode: "cursor" (default) or "time".
	self.m_ScrollingMode = "cursor"

	-- "time" mode settings.
	self.m_flScrollSpeed    = 40   -- pixels per second
	self.m_flEdgePause      = 1.2  -- seconds of pause at each edge
	self.m_flTimeCycleStart = RealTime()
end

function PANEL:SetText(text)
	self.m_strText = tostring(text or "")

	-- Reset the timer phase so a long string doesn't "jump" into
	-- a random position when the value updates.
	self.m_flTimeCycleStart = RealTime()
	self.m_flLastT = 0

	self:InvalidateLayout()
end

local baseSetParent = PANEL.SetParent
function PANEL:SetParent(p)
	self._CachedRoot = nil
	if baseSetParent then baseSetParent(self, p) end
end

function PANEL:GetText() return self.m_strText end
function PANEL:SetFont(font) self.m_Font = font self:InvalidateLayout() end
function PANEL:GetFont() return self.m_Font end
function PANEL:SetTextColor(col) self.m_TextColor = col end
function PANEL:GetTextColor() return self.m_TextColor end
function PANEL:SetContentAlignment(a) self.m_ContentAlign = a end
function PANEL:GetContentAlignment() return self.m_ContentAlign end

-- By default, cursor mode freezes the scroll position when the cursor
-- is outside the root window — useful for panels where scrolling is a
-- subtle "reading assistance" and jumping to 0/1 the moment the mouse
-- grazes the edge would be jarring. Set this to true if you want the
-- label to keep tracking the raw cursor X position regardless of where
-- the cursor is on screen (e.g. a label inside a menu that stays open
-- when the mouse wanders outside).
function PANEL:SetIgnoreRootBounds(b)
	self.m_bIgnoreRootBounds = b and true or false
end

function PANEL:SetScrollingMode(mode)
	self.m_ScrollingMode = mode == "time" and "time" or "cursor"
	self.m_flTimeCycleStart = RealTime()
	self.m_flLastT = 0
end

function PANEL:GetScrollingMode() return self.m_ScrollingMode end

function PANEL:SetScrollSpeed(px)
	self.m_flScrollSpeed = math.max(1, tonumber(px) or 40)
end

function PANEL:SetEdgePause(sec)
	self.m_flEdgePause = math.max(0, tonumber(sec) or 1.2)
end

function PANEL:SizeToContents()
    local w, h = MeasureText(self.m_strText, self.m_Font)
	self:SetSize(math.max(w, 1), math.max(h, 1))
end

function PANEL:GetContentSize()
    return MeasureText(self.m_strText, self.m_Font)
end

local function GetRootPanel(panel)
	if panel._CachedRoot and IsValid(panel._CachedRoot) then
		return panel._CachedRoot
	end
	local root = panel
	local world = vgui.GetWorldPanel()
	while IsValid(root:GetParent()) and root:GetParent() ~= world do
		root = root:GetParent()
	end
	panel._CachedRoot = root
	return root
end

-- Cursor-based progress: 0..1 depending on the mouse position
-- relative to the parent panel (usually a list button).
function PANEL:GetCursorScrollFraction()
	local owner = self:GetParent()
	if not IsValid(owner) then return self.m_flLastT or 0 end

	if not self.m_bIgnoreRootBounds then
		local root = GetRootPanel(self)
		if not IsValid(root) or not root:IsVisible() then
			return self.m_flLastT or 0
		end

		local rx, ry = root:LocalToScreen(0, 0)
		local rw, rh = root:GetSize()
		if rw <= 0 or rh <= 0 then return self.m_flLastT or 0 end

		local mx, my = gui.MousePos()
		if mx < rx or mx >= rx + rw or my < ry or my >= ry + rh then
			return self.m_flLastT or 0
		end
	end

	local ox = owner:LocalToScreen(0, 0)
	local ow = owner:GetWide()
	if ow <= 0 then return self.m_flLastT or 0 end

	local mx = gui.MousePos()
	local t = math.Clamp((mx - ox) / math.max(1, ow - 1), 0, 1)
	self.m_flLastT = t
	return t
end

-- Automatic cycle: pause at the start → scroll to the end → pause →
-- scroll back → and repeat. Travel duration depends on how much wider
-- the text is than the panel (so long strings don't flash by too fast).
function PANEL:GetTimeScrollFraction(textWidth, panelWidth)
	if textWidth <= panelWidth then return 0 end

	local travel = textWidth - panelWidth
	local scrollTime = travel / self.m_flScrollSpeed
	local pause = self.m_flEdgePause
	local cycle = (scrollTime + pause) * 2

	local t = (RealTime() - self.m_flTimeCycleStart) % cycle

	if t < pause then
		return 0
	elseif t < pause + scrollTime then
		return (t - pause) / scrollTime
	elseif t < pause + scrollTime + pause then
		return 1
	else
		return 1 - (t - pause - scrollTime - pause) / scrollTime
	end
end

local function AlignX(align, w, tW)
    align = align or 0

    -- Standard DLabel values (1..9), 3x3 grid:
    --   1  2  3   = left / center / right  (top)
    --   4  5  6   = left / center / right  (middle)
    --   7  8  9   = left / center / right  (bottom)
    if align >= 1 and align <= 9 then
        local cax = (align - 1) % 3
        if cax == 1 then return (w - tW) * 0.5 end
        if cax == 2 then return w - tW end
        return 0
    end

    -- Fallback: legacy bitmask (0..3).
    local a = bit.band(align, 3)
    if a == 1 then return (w - tW) * 0.5 end
    if a == 2 then return w - tW end
    return 0
end

function PANEL:Paint(w, h)
    local text = self.m_strText
    if not text or text == "" then return end

    local font = self.m_Font
    local tW = MeasureText(text, font)
    local col = self.m_TextColor or color_white
    local align = self.m_ContentAlign

    if tW <= w or not self:GetAutoScroll() then
        local x = AlignX(align, w, tW)
        draw.SimpleText(text, font, x, h * 0.5, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        return
    end

    local t
    if self.m_ScrollingMode == "time" then
        t = self:GetTimeScrollFraction(tW, w)
    else
        t = self:GetCursorScrollFraction()
    end

    local diff = tW - w
    local x = -diff * t

    local sx, sy = self:LocalToScreen(0, 0)
    render.SetScissorRect(sx, sy, sx + w, sy + h, true)
        draw.SimpleText(text, font, x, h * 0.5, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    render.SetScissorRect(0, 0, 0, 0, false)
end

vgui.Register("DLabelAutoScroll", PANEL, "DPanel")