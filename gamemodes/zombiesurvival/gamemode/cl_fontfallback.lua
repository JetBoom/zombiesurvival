local fallbackFamily  = "Tahoma"
local fallbackEnabled = false
local fallbackMap     = {}     -- [baseFontName] = regularTwinName
local buttonFontMap   = {}     -- [baseFontName] = buttonTwinName
local SUFFIX          = "_CYR"
local BTN_SUFFIX      = "_BTN"
local configLoaded    = false

-- ============================================================
-- Config
-- ============================================================
local function ReadConfig()
    fallbackFamily  = "Tahoma"
    fallbackEnabled = false

    if not (translate and translate.Exists) then return end

    local v = translate.Get("font_fallback")
    if type(v) == "string" and v ~= "" and v:sub(1, 1) ~= "@" then
        fallbackFamily = v
    end
    fallbackEnabled = translate.Get("font_fallback_enabled") == "1"
end

local function EnsureConfig()
    if configLoaded then return end
    configLoaded = true
    ReadConfig()
end

-- ============================================================
-- Utilities
-- ============================================================
local HasNonAsciiCache = {}
local HasNonAsciiCacheCount = 0
local HAS_CACHE_MAX = 512

local function HasNonAscii(text)
    if type(text) ~= "string" then return false end
    local c = HasNonAsciiCache[text]
    if c ~= nil then return c end

    if HasNonAsciiCacheCount >= HAS_CACHE_MAX then
        HasNonAsciiCache = {}
        HasNonAsciiCacheCount = 0
    end

    c = text:find("[\128-\255]") ~= nil
    HasNonAsciiCache[text] = c
    HasNonAsciiCacheCount = HasNonAsciiCacheCount + 1
    return c
end

local function SplitRuns(text)
    local runs = {}
    local len = #text
    if len == 0 then return runs end

    local i = 1
    while i <= len do
        local isAscii = text:byte(i) < 128
        local j = i + 1
        while j <= len and (text:byte(j) < 128) == isAscii do
            j = j + 1
        end
        local sub = text:sub(i, j - 1)
        runs[#runs + 1] = {
            text = sub,
            ascii = isAscii,
            whitespace = isAscii and sub:match("^%s+$") ~= nil or false,
        }
        i = j
    end
    return runs
end

-- Split cache: in the HUD, the same strings are rendered from frame to frame
-- (buttons, notifications, tooltips). Splitting via scripts allocates
-- a table on every call — with a large HUD, that's dozens of allocations per frame.
local SplitRunsCache = {}
local SplitRunsCacheCount = 0
local SPLIT_CACHE_MAX = 512

local function SplitRunsCached(text)
    local c = SplitRunsCache[text]
    if c then return c end

    if SplitRunsCacheCount >= SPLIT_CACHE_MAX then
        SplitRunsCache = {}
        SplitRunsCacheCount = 0
    end

    c = SplitRuns(text)
    SplitRunsCache[text] = c
    SplitRunsCacheCount = SplitRunsCacheCount + 1
    return c
end

-- ============================================================
-- draw.SimpleText / draw.DrawText
-- ============================================================
local nativeSimpleText = draw.SimpleText
local nativeDrawText   = draw.DrawText

-- Runs that consist purely of whitespace must be measured and drawn
-- with a font that actually has a proper space glyph. Decorative
-- fonts like "Ghoulish Fright AOE" have ultra-narrow (or zero-width)
-- spaces, so a standalone " " between two Cyrillic words visually
-- disappears. Using the fallback font (Tahoma) for whitespace-only.
local function RunFont(run, baseFont, twinFont)
    if run.whitespace then
        return twinFont
    end
    return run.ascii and baseFont or twinFont
end

-- GMod's surface.GetTextSize strips whitespace-only strings and returns 0
-- for " ". If we trust that number when laying out runs manually, the space
-- between two words collapses and they fuse together ("Стеклянноеоружие").
-- Approximate a per-character space width from the font's line height
-- (~1/3 em is the typical space advance for Tahoma at that size).
local function ApproxSpaceWidth(font)
    surface.SetFont(font)
    local _, h = surface.GetTextSize("Ag")
    return math.max(1, h * 0.33)
end

local function MeasureRun(run, baseFont, twinFont)
    local f = RunFont(run, baseFont, twinFont)
    surface.SetFont(f)
    local w, h = surface.GetTextSize(run.text)

    if run.whitespace and w <= 0 then
        local n = (utf8 and utf8.len and utf8.len(run.text)) or #run.text
        if not n or n < 1 then n = #run.text end
        w = ApproxSpaceWidth(f) * n
    end
    return w, h
end

local function DrawMixed(isSimple, text, font, x, y, col, xalign, yalign)
    local twin = fallbackMap[font]
    if not twin then
        if isSimple then
            return nativeSimpleText(text, font, x, y, col, xalign, yalign)
        else
            return nativeDrawText(text, font, x, y, col, xalign)
        end
    end

    local runs = SplitRunsCached(text)
    if #runs == 0 then return 0, 0 end

    -- One run — we just render it in the correct font.
    if #runs == 1 then
        local f = runs[1].ascii and font or twin
        if isSimple then
            return nativeSimpleText(text, f, x, y, col, xalign, yalign)
        else
            return nativeDrawText(text, f, x, y, col, xalign)
        end
    end

    -- We measure each run.
    local widths, totalW, height = {}, 0, 0
    for i, run in ipairs(runs) do
        local w, h = MeasureRun(run, font, twin)
        widths[i] = w
        totalW = totalW + w
        if h > height then height = h end
    end

    -- x of the first run, accounting for alignment.
    local startX = x
    if xalign == TEXT_ALIGN_CENTER then
        startX = x - totalW * 0.5
    elseif xalign == TEXT_ALIGN_RIGHT then
        startX = x - totalW
    end

    -- We draw the runs sequentially.
    local cx = startX
    for i, run in ipairs(runs) do
        local f = RunFont(run, font, twin)
        if isSimple then
            nativeSimpleText(run.text, f, cx, y, col, TEXT_ALIGN_LEFT, yalign)
        else
            nativeDrawText(run.text, f, cx, y, col, TEXT_ALIGN_LEFT)
        end
        cx = cx + widths[i]
    end

    return totalW, height
end

function draw.SimpleText(text, font, x, y, col, xalign, yalign)
    text = tostring(text)
    if not configLoaded then EnsureConfig() end
    if fallbackEnabled and fallbackMap[font] and HasNonAscii(text) then
        return DrawMixed(true, text, font, x, y, col, xalign, yalign)
    end
    return nativeSimpleText(text, font, x, y, col, xalign, yalign)
end

function draw.DrawText(text, font, x, y, col, xalign)
    text = tostring(text)
    if not configLoaded then EnsureConfig() end
    if fallbackEnabled and fallbackMap[font] and HasNonAscii(text) then
        return DrawMixed(false, text, font, x, y, col, xalign)
    end
    return nativeDrawText(text, font, x, y, col, xalign)
end

-- ============================================================
-- Blur / Blurry
-- ============================================================
local blurColor1 = Color(60, 60, 60, 220)
local blurColor2 = Color(40, 40, 40, 140)
local blurTint   = Color(0, 0, 0)

local FontBlurX,  FontBlurY  = 0, 0
local FontBlurX2, FontBlurY2 = 0, 0

timer.Create("fontblur_fb", 0.1, 0, function()
    FontBlurX  = math.random(-8, 8)
    FontBlurY  = math.random(-8, 8)
    FontBlurX2 = math.random(-8, 8)
    FontBlurY2 = math.random(-8, 8)
end)

function draw.SimpleTextBlur(text, font, x, y, col, xalign, yalign)
    if GAMEMODE.FontEffects then
        blurColor1.a = col.a * 0.85
        blurColor2.a = col.a * 0.55
        draw.SimpleText(text, font, x + FontBlurX,  y + FontBlurY,  blurColor1, xalign, yalign)
        draw.SimpleText(text, font, x + FontBlurX2, y + FontBlurY2, blurColor2, xalign, yalign)
    end
    draw.SimpleText(text, font, x, y, col, xalign, yalign)
end

function draw.DrawTextBlur(text, font, x, y, col, xalign)
    if GAMEMODE.FontEffects then
        blurColor1.a = col.a * 0.85
        blurColor2.a = col.a * 0.55
        draw.DrawText(text, font, x + FontBlurX,  y + FontBlurY,  blurColor1, xalign)
        draw.DrawText(text, font, x + FontBlurX2, y + FontBlurY2, blurColor2, xalign)
    end
    draw.DrawText(text, font, x, y, col, xalign)
end

function draw.SimpleTextBlurry(text, font, x, y, col, xalign, yalign)
    if GAMEMODE.FontEffects then
        blurTint.r = col.r
        blurTint.g = col.g
        blurTint.b = col.b
        blurTint.a = col.a * math.Rand(0.35, 0.6)
        draw.SimpleText(text, font .. "Blur", x, y, blurTint, xalign, yalign)
    end
    draw.SimpleText(text, font, x, y, col, xalign, yalign)
end

function draw.DrawTextBlurry(text, font, x, y, col, xalign)
    if GAMEMODE.FontEffects then
        blurTint.r = col.r
        blurTint.g = col.g
        blurTint.b = col.b
        blurTint.a = col.a * math.Rand(0.35, 0.6)
        draw.DrawText(text, font .. "Blur", x, y, blurTint, xalign)
    end
    draw.DrawText(text, font, x, y, col, xalign)
end

-- ============================================================
-- Creating twin fonts.
-- ------------------------------------------------------------
-- Tahoma renders visually larger at the same px than
-- the decorative Ghoulish Fright AOE. Because of this, Cyrillic in
-- mixed strings looked larger than Latin at the same size.
--
-- We compensate by reducing the font size of the twin font. weight and outline
-- are inherited from the base — both parts of the string (Latin/Cyrillic)
-- look identical in thickness and outline.
--
-- TWIN_SIZE_MULT — empirical GFA→Tahoma coefficient:
--   0.85 — moderate (recommended)
--   0.80 — if Tahoma is still too large
--   0.90 — if it has become too small
-- ============================================================
local TWIN_SIZE_MULT = 0.85

local function RoundSize(n)
    -- math.Round exists in GMod, but let's play it safe.
    return math.max(1, math.Round(n))
end

local origCreateLegacyFont

function InstallFontFallbackHooks()
    if origCreateLegacyFont then return end
    if not surface.CreateLegacyFont then return end

    ReadConfig()
    origCreateLegacyFont = surface.CreateLegacyFont

        surface.CreateLegacyFont = function(...)
        local args   = {...}
        local family = args[1]
        local size   = args[2]
        local name   = args[6]

        origCreateLegacyFont(unpack(args))

        if not fallbackEnabled then return end
        if family == fallbackFamily then return end
        if name:sub(-#SUFFIX)     == SUFFIX     then return end
        if name:sub(-#BTN_SUFFIX) == BTN_SUFFIX then return end

        local twinSize = RoundSize(size * TWIN_SIZE_MULT)

        -- (a) Regular twin
        local twinArgs = {...}
        twinArgs[1] = fallbackFamily
        twinArgs[2] = twinSize
        twinArgs[6] = name .. SUFFIX
        origCreateLegacyFont(unpack(twinArgs))
        fallbackMap[name] = name .. SUFFIX

        -- (b) Button twin
        local btnArgs = {...}
        btnArgs[1] = fallbackFamily
        btnArgs[2] = twinSize
        btnArgs[6] = name .. BTN_SUFFIX
        origCreateLegacyFont(unpack(btnArgs))
        buttonFontMap[name] = name .. BTN_SUFFIX
    end
end

-- ============================================================
-- VGUI: DLabel:GetFont / DButton:GetFont
-- ============================================================
do
    local function WrapGetFont(origGetFont, map)
        return function(self)
            local font = origGetFont(self)
            if fallbackEnabled and type(font) == "string" and map[font] then
                local text = self.GetText and self:GetText() or nil
                if text and HasNonAscii(text) then
                    return map[font]
                end
            end
            return font
        end
    end

    local function install()
        local dlabel  = vgui.GetControlTable("DLabel")
        local dbutton = vgui.GetControlTable("DButton")

        if dlabel and not dlabel.__ZS_FontFallbackPatched then
            dlabel.__ZS_FontFallbackPatched = true
            local orig = dlabel.GetFont
            dlabel.GetFont = WrapGetFont(orig, fallbackMap)
        end

        if dbutton and not dbutton.__ZS_FontFallbackPatched then
            dbutton.__ZS_FontFallbackPatched = true
            local orig = dbutton.GetFont
            if orig then
                dbutton.GetFont = WrapGetFont(orig, buttonFontMap)
            end
        end
    end

    install()
    hook.Add("InitPostEntity", "ZS_FontFallbackPatchVgui", install)
end

-- Public access to the base → twin mapping, so other modules
-- (e.g. zsgamestate.lua) can measure the string using the same
-- font with which it will be drawn.
function ZS_GetFontForText(font, text)
    if not configLoaded then EnsureConfig() end
    if fallbackEnabled and fallbackMap[font] and HasNonAscii(text) then
        return fallbackMap[font]
    end
    return font
end

-- ============================================================
-- Cache of measurements for mixed text.
-- Key: baseFont .. "\1" .. text. Value: {w, h, time}.
-- ============================================================
local MeasureCache = {}
local MeasureCacheCount = 0
local MEASURE_CACHE_MAX = 256

local function MeasureCachePut(key, w, h)
    if MeasureCache[key] == nil then
        MeasureCacheCount = MeasureCacheCount + 1
        if MeasureCacheCount > MEASURE_CACHE_MAX then
            local cutoff = CurTime() - 2
            for k, v in pairs(MeasureCache) do
                if v[3] < cutoff then
                    MeasureCache[k] = nil
                    MeasureCacheCount = MeasureCacheCount - 1
                end
            end
            if MeasureCacheCount > MEASURE_CACHE_MAX then
                MeasureCache = {}
                MeasureCacheCount = 0
            end
        end
    end
    MeasureCache[key] = {w, h, CurTime()}
end

function ZS_MeasureMixedText(text, baseFont)
    if not text or text == "" then return 0, 0 end
    if not configLoaded then EnsureConfig() end

    local useFallback = fallbackEnabled
        and fallbackMap[baseFont] ~= nil
        and HasNonAscii(text)

    if not useFallback then
        surface.SetFont(baseFont)
        return surface.GetTextSize(text)
    end

    local cacheKey = baseFont .. "\1" .. text
    local c = MeasureCache[cacheKey]
    if c then return c[1], c[2] end

    local twin = fallbackMap[baseFont]
    local runs = SplitRunsCached(text)
    local totalW, height = 0, 0
    for _, run in ipairs(runs) do
        local w, h = MeasureRun(run, baseFont, twin)
        totalW = totalW + w
        if h > height then height = h end
    end

    MeasureCachePut(cacheKey, totalW, height)
    return totalW, height
end

-- ============================================================
-- ENABLE the surface.CreateLegacyFont interception.
-- By this point shared.lua has already been loaded (meaning
-- surface.CreateLegacyFont is defined), and GM:CreateFonts
-- will be called later — the twin fonts will have time to be created.
-- ============================================================
InstallFontFallbackHooks()

-- ============================================================
-- Reset MeasureCache when changing the language.
-- EmptyCachedFontHeights is called from sh_translate.lua before
-- CreateFonts(). We'll wrap it so that along with the height cache,
-- the measurement cache is also cleared — otherwise after switching languages, old strings
-- are measured using the metrics of the previous locale.
-- ============================================================
do
    local origEmpty = GM.EmptyCachedFontHeights
    function GM:EmptyCachedFontHeights()
        if origEmpty then origEmpty(self) end
        MeasureCache = {}
        MeasureCacheCount = 0
    end
end