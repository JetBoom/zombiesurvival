concommand.Add("printdxinfo", function()
	print("DX Level: "..tostring(render.GetDXLevel()))
	print("Supports HDR: "..tostring(render.SupportsHDR()))
	print("Supports Pixel Shaders 1.4: "..tostring(render.SupportsPixelShaders_1_4()))
	print("Supports Pixel Shaders 2.0: "..tostring(render.SupportsPixelShaders_2_0()))
	print("Supports Vertex Shaders 2.0: "..tostring(render.SupportsVertexShaders_2_0()))
end)

local ammonames = {
	["pistol"] = "pistolammo",
	["buckshot"] = "shotgunammo",
	["smg1"] = "smgammo",
	["ar2"] = "assaultrifleammo",
	["357"] = "rifleammo",
	["pulse"] = "pulseammo",
	["battery"] = "50mkit",
	["xbowbolt"] = "crossbowammo",
	["impactmine"] = "impactmine",
	["chemical"] = "chemical",
	["gaussenergy"] = "nail"
}

concommand.Add("zs_quickbuyammo", function()
	if ammonames[GAMEMODE.CachedResupplyAmmoType] then
		RunConsoleCommand("zs_pointsshopbuy", "ps_"..ammonames[GAMEMODE.CachedResupplyAmmoType])
	end
end)

local function GetViewModelPosition(self, pos, ang)
	return pos + ang:Forward() * -256, ang
end

function DontDrawViewModel()
	if SWEP then
		SWEP.GetViewModelPosition = GetViewModelPosition
	end
end

-- Scales the screen based around 1080p but doesn't make things TOO tiny on low resolutions.
function BetterScreenScale()
	return math.max(ScrH() / 1080, 0.851) * GAMEMODE.InterfaceSize
end

function render.GetLightRGB(pos)
	local vec = render.GetLightColor(pos)
	return vec.r, vec.g, vec.b
end

function EasyLabel(parent, text, font, textcolor)
	-- A bare Panel, not DLabel. DLabel's text is a C++ component:
	-- its SetText("") clears only the Lua-visible value, while the
	-- engine still owns a hidden text slot. During DScrollPanel
	-- rebuilds that leaked string is what flashed as "Label". A
	-- Panel has no text slot at all, so nothing can leak.
	local dpanel = vgui.Create("Panel", parent)

	local baseFont = font or "DefaultFont"
	local storedText = text or ""
	local storedColor = textcolor
	local storedAlign = 0  -- 0 = left/top, matches DLabel default

	dpanel.GetText = function(self) return storedText end
	dpanel.SetText = function(self, t)
		storedText = t or ""
		self:InvalidateLayout()
	end

	-- Expose the base font (not the fallback twin). cl_fontfallback
	-- patches DLabel:GetFont to swap fonts for Cyrillic text; if the
	-- panel returned the twin, any code that measures with GetFont
	-- would size against the wrong font.
	dpanel.GetFont = function(self) return baseFont end
	dpanel.SetFont = function(self, f)
		baseFont = f or "DefaultFont"
		self:InvalidateLayout()
	end

	-- DLabel-compatible color API. Several call sites use
	-- SetTextColor / GetTextColor / SetColor.
	dpanel.GetTextColor = function(self) return storedColor end
	dpanel.SetTextColor = function(self, c) storedColor = c end
	dpanel.GetColor     = dpanel.GetTextColor
	dpanel.SetColor     = dpanel.SetTextColor

	-- DLabel-compatible content alignment.
	dpanel.GetContentAlignment = function(self) return storedAlign end
	dpanel.SetContentAlignment = function(self, a)
		storedAlign = a or 0
		self:InvalidateLayout()
	end

	-- Custom measurement: ASCII uses the base font, Cyrillic uses the twin.
	-- DLabel's default PerformLayout calls self:SizeToContents(),
	-- so replacing the method works automatically on SetText/SetFont.
	-- Supports \n: measure line by line, take max width and sum the
	-- heights so SetTall on multi-line labels (e.g. credits) is correct.
	dpanel.SizeToContents = function(self)
		local txt = storedText
		if txt == "" then
			self:SetSize(0, 0)
			return
		end

		local lines = string.Explode("\n", txt, false)
		local maxW, lineH = 0, 0

		for _, line in ipairs(lines) do
			local w, h
			if ZS_MeasureMixedText then
				w, h = ZS_MeasureMixedText(line, baseFont)
			else
				surface.SetFont(baseFont)
				w, h = surface.GetTextSize(line)
			end
			if w > maxW then maxW = w end
			if h > lineH then lineH = h end
		end

		self:SetSize(maxW, lineH * #lines)
	end
	dpanel:SizeToContents()

	if textcolor then
		dpanel:SetTextColor(textcolor)
	end

	-- Custom render. draw.SimpleText splits the string into ASCII/
	-- non-ASCII runs and substitutes fallback only where needed.
	-- draw.SimpleText doesn't handle \n, so multi-line text (used,
	-- e.g., in credits) is drawn line by line in separate calls.
	-- Cache the effective alpha. Walking the parent chain every
	-- frame is wasteful — parents' alpha changes rarely (panel
	-- fades, show/hide). Refresh at most every 0.1 s, and force
	-- a refresh whenever this label's own alpha changes.
	local cachedAlpha   = 1
	local cachedAlphaAt = -1
	local lastSelfAlpha = -1

	local function ComputeEffectiveAlpha(self)
		local a = 1
		local p = self
		while IsValid(p) do
			local pa = p:GetAlpha()
			if pa and pa < 255 then
				a = a * (pa / 255)
			end
			p = p:GetParent()
		end
		return a
	end

	dpanel.Paint = function(self, w, h)
		local txt = storedText
		if not txt or txt == "" then return end

		-- Effective alpha: recompute when our own alpha changes,
		-- otherwise refresh at most every 0.1 s.
		local ownAlpha = self:GetAlpha()
		if ownAlpha ~= lastSelfAlpha or RealTime() - cachedAlphaAt > 0.1 then
			cachedAlpha   = ComputeEffectiveAlpha(self)
			cachedAlphaAt = RealTime()
			lastSelfAlpha = ownAlpha
		end

		local a = cachedAlpha

		local col = storedColor or color_white

		if not textcolor and col.r >= 240 and col.g >= 240 and col.b >= 240 then
			col = Color(190, 190, 190, col.a)
		end
		local drawCol = Color(col.r, col.g, col.b, col.a * a)

		local align = storedAlign
		-- Values 1..9 — a 3x3 grid in GMod style. 0 (default)
		-- means “left/top”, but arithmetic with it ends up at
		-- TEXT_ALIGN_RIGHT due to Lua's modulo with a negative
		-- number. Normalize: anything outside 1..9 → 1.
		if align < 1 or align > 9 then align = 1 end

		local cax = (align - 1) % 3
		local cay = math.floor((align - 1) / 3)

		local xalign = (cax == 1 and TEXT_ALIGN_CENTER) or (cax == 2 and TEXT_ALIGN_RIGHT) or TEXT_ALIGN_LEFT
		local yalign = (cay == 1 and TEXT_ALIGN_CENTER) or (cay == 2 and TEXT_ALIGN_BOTTOM) or TEXT_ALIGN_TOP

		local x = (xalign == TEXT_ALIGN_CENTER and w * 0.5) or (xalign == TEXT_ALIGN_RIGHT and w) or 0

		-- Split into lines. Single line — old behavior unchanged.
		local lines = string.Explode("\n", txt, false)

		if #lines == 1 then
			local y = (yalign == TEXT_ALIGN_CENTER and h * 0.5) or (yalign == TEXT_ALIGN_BOTTOM and h) or 0
			draw.SimpleText(txt, baseFont, x, y, drawCol, xalign, yalign)
			return
		end

		-- Multi-line render: compute total height and start Y,
		-- draw each line vertically centered in its own cell so
		-- line spacing is even.
		local lineH
		if ZS_MeasureMixedText then
			_, lineH = ZS_MeasureMixedText("Ag", baseFont)
		end
		if not lineH or lineH <= 0 then
			surface.SetFont(baseFont)
			_, lineH = surface.GetTextSize("Ag")
		end
		if not lineH or lineH <= 0 then
			lineH = draw.GetFontHeight(baseFont)
		end

		local totalH = #lines * lineH
		local startY
		if yalign == TEXT_ALIGN_CENTER then
			startY = h * 0.5 - totalH * 0.5 + lineH * 0.5
		elseif yalign == TEXT_ALIGN_BOTTOM then
			startY = h - totalH + lineH * 0.5
		else
			startY = lineH * 0.5
		end

		for i, line in ipairs(lines) do
			draw.SimpleText(line, baseFont, x, startY + (i - 1) * lineH, drawCol, xalign, TEXT_ALIGN_CENTER)
		end
	end

	return dpanel
end

function EasyButton(parent, text, xpadding, ypadding)
	local dpanel = vgui.Create("DButton", parent)
	if textcolor then
		dpanel:SetFGColor(textcolor or color_white)
	end
	if text then
		dpanel:SetText(text)
	end
	dpanel:SizeToContents()

	if xpadding then
		dpanel:SetWide(dpanel:GetWide() + xpadding * 2)
	end

	if ypadding then
		dpanel:SetTall(dpanel:GetTall() + ypadding * 2)
	end

	return dpanel
end

function StyleZSComboBox(dd)
    dd:SetTextColor(color_black)
    dd:SetFont("DefaultFont")

    dd.Paint = function(self, w, h)
        surface.SetDrawColor(240, 240, 240, 255)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    dd.OnMenuOpened = function(self, menu)
        menu:SetBackgroundColor(Color(240, 240, 240, 255))
        for _, opt in ipairs(menu:GetCanvas():GetChildren()) do
            opt:SetTextColor(color_black)
            opt:SetFont("DefaultFont")
        end
    end
end

function ZS_NormalFont()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFont"   -- был "ZSHUDFontNoOutline"
    end
    return "ZSHUDFont"
end

function ZS_NormalFontWithOutline()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFontOutline"
    end
    return "ZSHUDFont"
end

function ZS_TinyFont()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFontTinyNoOutline"
    end
    return "ZSHUDFontTiny"
end

function ZS_TinyFontWithOutline()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFontTinyOutline"
    end
    return "ZSHUDFontTiny"
end

function ZS_SmallestFont()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFontSmallestNoOutline"
    end
    return "ZSHUDFontSmallest"
end

function ZS_SmallestFontWithOutline()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFontSmallestOutline"
    end
    return "ZSHUDFontSmallest"
end

function ZS_SmallerFont()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFontSmallerNoOutline"
    end
    return "ZSHUDFontSmaller"
end

function ZS_SmallerFontWithOutline()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFontSmallerOutline"
    end
    return "ZSHUDFontSmaller"
end

function ZS_SmallFont()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFontSmallNoOutline"
    end
    return "ZSHUDFontSmall"
end

function ZS_SmallFontWithOutline()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSHUDFontSmallOutline"
    end
    return "ZSHUDFontSmall"
end

function ZS_BodyTextFont()
    if translate and translate.Get and translate.Get("font_fallback_enabled") == "1" then
        return "ZSBodyTextFontNoOutline"
    end
    return "ZSBodyTextFont"
end

-- Returns the tab height accounting for real font metrics.
-- For English (== base font) returns the passed base, for
-- Russian (== twin font) increases it so Cyrillic descenders
-- are not clipped at the bottom.
function ZS_GetTabHeight(screenscale, baseHeight)
    baseHeight = baseHeight or 24 * screenscale
    if not (translate and translate.Exists) then return baseHeight end
    if translate.Get("font_fallback_enabled") ~= "1" then return baseHeight end
    if not ZS_GetFontForText then return baseHeight end

    local baseFont = ZS_TinyFont()
    -- "У" and "р" have descenders — use them as an indicator.
    local twin = ZS_GetFontForText(baseFont, "У")
    if twin == baseFont then return baseHeight end

    surface.SetFont(twin)
    local _, h = surface.GetTextSize("У")
    return math.max(baseHeight, h + 8 * screenscale)
end

function ZS_UpdateAltSelItemLabel()
	local activeweapon = MySelf:GetActiveWeapon()
	if not activeweapon or not activeweapon:IsValid() then return end

	local actwclass = activeweapon:GetClass()
	local wep = weapons.Get(actwclass)

	local name

	if string.sub(actwclass, 1, 12) == "weapon_zs_t_" then
		local trinketid = string.sub(actwclass, 13)
		name = translate.ItemName(trinketid, "trinket") or (wep and wep.PrintName)
	elseif wep then
		name = translate.WeaponName(wep)
	end

	if not name and activeweapon.GetPrintName then
		local pn = activeweapon:GetPrintName()
		if type(pn) == "string" and pn ~= "" then
			if pn:sub(1, 1) == "#" then
				local key = pn:sub(2)
				local resolved = language.GetPhrase(key)
				if type(resolved) == "string" and resolved ~= key and resolved ~= "" then
					name = resolved
				else
					key = key:gsub("^HL2_", ""):gsub("^Cstrike_", ""):gsub("^GMod_", ""):gsub("_", " ")
					name = key:gsub("(%a)([%w]*)", function(a, b)
						return a:upper() .. b:lower()
					end)
				end
			else
				name = pn
			end
		end
	end

	-- Последний резерв.
	if not name then
		name = actwclass:gsub("^weapon_", ""):gsub("^zs_", ""):gsub("_", " ")
		name = name:gsub("(%a)([%w]*)", function(a, b)
			return a:upper() .. b:lower()
		end)
	end

	if GAMEMODE.HumanMenuPanel and GAMEMODE.HumanMenuPanel:IsValid() then
		GAMEMODE.HumanMenuPanel.SelectedItemLabel:SetText(name)
	end
end

-- ============================================================
-- Mixed-font labels: Latin in one font, Cyrillic in another —
-- inside a single DLabel. A plain DLabel can't do this (it uses
-- one font for the whole string), while EasyLabel/DLabelAutoScroll
-- draw via draw.SimpleText and get the fallback twin from
-- cl_fontfallback.lua, but there the twin is NOT bold → outline
-- produces stray pixels.
-- ============================================================
ZS_MixedFonts = {
    tiny     = { latin = "ZSMixTinyL",     cyr = "ZSMixTinyC" },
    smallest = { latin = "ZSMixSmallestL", cyr = "ZSMixSmallestC" },
    smaller  = { latin = "ZSMixSmallerL",  cyr = "ZSMixSmallerC" },
    small    = { latin = "ZSMixSmallL",    cyr = "ZSMixSmallC" },
    body     = { latin = "ZSMixBodyL",     cyr = "ZSMixBodyC" },
}

hook.Add("InitPostEntity", "ZS_CreateMixedFonts", function()
    local ss  = BetterScreenScale()
    local GFA = "ghoulish_fright_aoe_v2.1"

    -- Same fallback as in cl_fontfallback.lua.
    -- For Russian = Tahoma, for Chinese = Microsoft YaHei etc.
    -- Otherwise, in a Chinese locale, the twin font would be
    -- created on Tahoma, which has no CJK glyphs, and hieroglyphs
    -- wouldn't render.
    local FALLBACK = "Tahoma"
    if translate and translate.Get then
        local v = translate.Get("font_fallback")
        if type(v) == "string" and v ~= "" and v:sub(1, 1) ~= "@" then
            FALLBACK = v
        end
    end

    local function mk(name, family, size, weight, outline)
        surface.CreateFont(name, {
            font      = family,
            size      = size,
            weight    = weight,
            antialias = true,
            outline   = outline,
        })
    end

    -- Sizes match vanilla ZSHUDFont*.
    -- Cyrillic = bold Tahoma at the same size so glyph heights match.
    mk(ZS_MixedFonts.tiny.latin,     GFA,      ss * 24, 0,   true)
    mk(ZS_MixedFonts.tiny.cyr,       FALLBACK, ss * 20, 700, true)
    mk(ZS_MixedFonts.smallest.latin, GFA,      ss * 28, 0,   true)
    mk(ZS_MixedFonts.smallest.cyr,   FALLBACK, ss * 28, 0, true)
    mk(ZS_MixedFonts.smaller.latin,  GFA,      ss * 30, 0,   true)
    mk(ZS_MixedFonts.smaller.cyr,    FALLBACK, ss * 30, 0, true)
    mk(ZS_MixedFonts.small.latin,    GFA,      ss * 36, 0,   true)
    mk(ZS_MixedFonts.small.cyr,      FALLBACK, ss * 34, 0, true)
    mk(ZS_MixedFonts.body.latin,     GFA,      ss * 20, 0,   true)
    mk(ZS_MixedFonts.body.cyr,       FALLBACK, ss * 20, 0, true)
end)

function ZS_SplitScriptRuns(text)
    local runs = {}
    local i, len = 1, #text
    while i <= len do
        local isAscii = text:byte(i) < 128
        local j = i + 1
        while j <= len and (text:byte(j) < 128) == isAscii do
            j = j + 1
        end
        runs[#runs + 1] = { text = text:sub(i, j - 1), ascii = isAscii }
        i = j
    end
    return runs
end

local function MixedRunFont(run, pair)
    -- Whitespace runs use Tahoma: GFA's space is nearly zero.
    if run.text:match("^%s+$") then return pair.cyr end
    return run.ascii and pair.latin or pair.cyr
end

local function MixedMeasure(runs, pair)
    local total, maxH = 0, 0
    for _, run in ipairs(runs) do
        local f = MixedRunFont(run, pair)
        surface.SetFont(f)
        local w, h = surface.GetTextSize(run.text)
        total = total + w
        if h > maxH then maxH = h end
    end
    return total, maxH
end

-- Returns a DLabel with mixed rendering. Externally behaves like a
-- regular label: SetText/SetTextColor/SetAlpha/SizeToContents work.
-- The engine can't mix two fonts in a single DLabel — keep the real
-- text in a closure, and leave the DLabel always "" (otherwise the
-- native render draws a duplicate on top of ours).
function ZS_MixedLabel(parent, initialPair)
    local lbl = vgui.Create("DLabel", parent)
    lbl.MixPair = initialPair or ZS_MixedFonts.smaller

    local storedText = ""
    local origSetText = lbl.SetText

    lbl.GetText = function(me) return storedText end
    lbl.SetText = function(me, t)
        storedText = t or ""
        origSetText(me, "")
        me:InvalidateLayout()
    end

    lbl:SetFont("ZSHUDFontSmaller")

    lbl.SizeToContents = function(me)
        if storedText == "" then me:SetSize(0, 0) return end
        local w, h = MixedMeasure(ZS_SplitScriptRuns(storedText), me.MixPair)
        me:SetSize(w, h)
    end

    lbl.Paint = function(me, w, h)
        if storedText == "" then return end

        local a = 1
        local p = me
        while IsValid(p) do
            local pa = p:GetAlpha()
            if pa and pa < 255 then a = a * (pa / 255) end
            p = p:GetParent()
        end

        local col = me:GetTextColor() or color_white
        local drawCol = Color(col.r, col.g, col.b, col.a * a)

        local runs   = ZS_SplitScriptRuns(storedText)
        local totalW = MixedMeasure(runs, me.MixPair)
        local cx     = w * 0.5 - totalW * 0.5

        for _, run in ipairs(runs) do
            local f = MixedRunFont(run, me.MixPair)
            surface.SetFont(f)
            local rw = surface.GetTextSize(run.text)
            draw.SimpleText(run.text, f, cx, h * 0.5, drawCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            cx = cx + rw
        end
    end

    return lbl
end
