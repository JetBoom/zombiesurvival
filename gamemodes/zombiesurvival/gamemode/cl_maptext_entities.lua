if not CLIENT then return end

-- Normalized key for deduplication: trim spaces and lowercase.
-- Two versions of the same text often differ by a leading/trailing
-- space or case — a plain compare would not collapse them.
local function NormKey(s)
    if type(s) ~= "string" then return s end
    -- NBSP (U+00A0) → regular space, then strip ALL whitespace.
    -- This catches "'< Light X >' vs '<Light X>'" and single vs double space.
    s = s:gsub("\194\160", " ")
    s = s:gsub("%s+", "")
    return s:lower()
end

local ActiveTexts = {}

net.Receive("zs_maptext_clear", function()
    table.Empty(ActiveTexts)
end)

-- If the server ships us new HL2 tokens (via language.Add), any map
-- text currently on screen was resolved against the old phrase table.
-- Clear it so the next Display uses the fresh translations.
hook.Add("ZS_HL2LangReceived", "ZS_MapTextClearOnNewTokens", function()
    table.Empty(ActiveTexts)
end)

-- Slot key:
--   channel > 0  → the channel itself (as in Source: two messages of the
--                  same channel overwrite each other);
--   channel == 0 → key by text, not a unique ID. This gives the same
--                  "overwrite" behavior for when a mapper sends the same
--                  text twice (Display + AddOutput), but for some reason
--                  with different/empty channels. Different texts still
--                  get different slots and are visible simultaneously.
local function GetSlotKey(channel, text)
    if channel > 0 then return channel end
    return "t:" .. tostring(text)
end

net.Receive("zs_maptext_display", function()
    local type_     = net.ReadUInt(2)
    local text      = net.ReadString()
    local holdTime  = net.ReadFloat()
    local fadeIn    = net.ReadFloat()
    local fadeOut   = net.ReadFloat()
    local fxTime    = net.ReadFloat()
    local x         = net.ReadFloat()
    local y         = net.ReadFloat()
    local effect    = net.ReadUInt(4)
    local channel   = net.ReadUInt(4)
    local col1      = net.ReadColor(false)
    local col2      = net.ReadColor(false)

    local translated = translate.MapText(text)
    local key        = GetSlotKey(channel, translated)

    -- Normalized key is computed once here, not every frame.
    local nk = NormKey(translated)

    -- Remove any already-active slots with the same displayed text.
    for k, v in pairs(ActiveTexts) do
        if k ~= key and v._norm == nk then
            ActiveTexts[k] = nil
        end
    end

    ActiveTexts[key] = {
        text        = translated,
        _norm       = nk,           -- cached for the per-frame dedup pass
        startTime   = CurTime(),
        holdTime    = holdTime,
        fadeIn      = fadeIn,
        fadeOut     = fadeOut,
        fxTime      = fxTime,
        x           = x,
        y           = y,
        effect      = effect,
        col1        = col1,
        col2        = col2,
        isEnvMsg    = (type_ == 1),
    }
end)

hook.Add("InitPostEntity", "ZS_MapTextClearOnMap", function()
    table.Empty(ActiveTexts)
end)

-- ============================================================
-- UTF-8 utilities
-- ============================================================

local function CharLen(s)
    if utf8 and utf8.len then
        local n = utf8.len(s)
        if n then return n end
    end
    return #s
end

local function ByteEndOfChar(s, i)
    if i <= 0 then return 0 end
    if utf8 and utf8.offset then
        local nextStart = utf8.offset(s, i + 1)
        if nextStart then return nextStart - 1 end
        return #s
    end
    return math.min(i, #s)
end

-- ============================================================
-- Character width cache
-- ------------------------------------------------------------
-- PrepareTextMetrics used to call surface.GetTextSize() once
-- per character. For a 200-char message that's 200 syscalls.
-- The font is fixed (ZSMapText / ZSMapTextSmall) and the char
-- set is small, so a global cache makes this effectively free
-- after the first message.
-- ============================================================
local CharWidthCache = {}

local function GetCharWidth(font, ch)
    local fontcache = CharWidthCache[font]
    if not fontcache then
        fontcache = {}
        CharWidthCache[font] = fontcache
    end

    local w = fontcache[ch]
    if w == nil then
        surface.SetFont(font)
        w = surface.GetTextSize(ch)
        fontcache[ch] = w
    end
    return w
end

-- ============================================================
-- Precomputed metrics (once per message)
-- ------------------------------------------------------------
-- For per-char rendering we need three things:
--   • cumulative prefix widths (position of the i-th letter),
--   • byte boundaries of each character,
--   • total width (for centering).
-- All of these depend on font + text — both known right after
-- receiving the net message. Compute once.
-- ============================================================

local function PrepareTextMetrics(data)
    if data._m then return end

    local font = data.isEnvMsg and "ZSMapTextSmall" or "ZSMapText"
    local text = data.text
    local len  = CharLen(text)

    local chars  = {}
    local cumW   = {}   -- cumW[i] = sum of widths of chars 1..i-1
    local totalW = 0

    for i = 1, len do
        local pb = ByteEndOfChar(text, i - 1)
        local cb = ByteEndOfChar(text, i)
        local ch = text:sub(pb + 1, cb)
        local w  = GetCharWidth(font, ch)

        chars[i] = { pb, cb, w }
        cumW[i]  = totalW
        totalW   = totalW + w
    end

    data._m = {
        font    = font,
        chars   = chars,
        cumW    = cumW,
        totalW  = totalW,
        len     = len,
    }
end

-- fxTime — total scan-out duration (like the original game_text),
-- not seconds per character. The entire text appears within fxTime seconds.
local function ApplyWriteOut(text, fxTime, elapsed)
    if fxTime <= 0 then return text end
    if elapsed < 0 then return "" end
    local len = CharLen(text)
    if len == 0 then return "" end

    local progress = elapsed / fxTime         -- 0..1+
    if progress >= 1 then return text end
    if progress <= 0 then return "" end

    local visible = math.floor(progress * len)
    if visible <= 0 then return "" end
    if visible >= len then return text end
    return text:sub(1, ByteEndOfChar(text, visible))
end

local function ApplyFlicker(elapsed)
    return 0.4 + 0.6 * math.abs(math.sin(elapsed * 12))
end

-- ============================================================
-- Multi-line rendering
-- ------------------------------------------------------------
-- draw.SimpleText doesn't handle "\n" — it draws it as a blank
-- glyph and keeps everything on one line. Source's CHudMessage
-- splits at \n and stacks lines. We do the same, honoring the
-- same alignment semantics: xAlign applies to each line
-- individually, yAlign positions the whole block.
-- ============================================================
local function DrawMultilineText(text, font, px, py, col, xAlign, yAlign)
    local lines = string.Explode("\n", text, false)
    local lineCount = #lines

    if lineCount <= 1 then
        draw.SimpleText(text, font, px, py, col, xAlign, yAlign)
        return
    end

    local lineH  = draw.GetFontHeight(font)
    local totalH = lineH * lineCount

    local yStart
    if yAlign == TEXT_ALIGN_CENTER then
        yStart = py - totalH * 0.5
    elseif yAlign == TEXT_ALIGN_BOTTOM then
        yStart = py - totalH
    else
        yStart = py
    end

    for i = 1, lineCount do
        draw.SimpleText(
            lines[i], font,
            px, yStart + (i - 1) * lineH,
            col,
            xAlign, TEXT_ALIGN_TOP
        )
    end
end

-- ============================================================
-- Rendering
-- ============================================================

hook.Add("HUDPaint", "ZS_MapTextRender", function()
    if not next(ActiveTexts) then return end

    local now  = CurTime()
    local scrw = ScrW()
    local scrh = ScrH()

    -- Pass 1: purge expired entries and dedupe by text.
    -- If the map sent the same Display twice (e.g., due to respawn at
    -- the start and end of preparation) and both landed in different
    -- slots (channel 0 vs 1 or different channels), the frame shows two
    -- copies of the text with a slight offset — visually "bold text".
    -- Keep only the freshest entry per unique text.
    local toDraw = {}
    do
        local newest = {}
        for key, data in pairs(ActiveTexts) do
            local elapsed = now - data.startTime
            local total   = data.fadeIn + data.holdTime + data.fadeOut

            if elapsed >= total then
                ActiveTexts[key] = nil
            else
                local t   = data._norm
                local cur = newest[t]
                if not cur or cur.startTime < data.startTime then
                    newest[t] = data
                end
            end
        end
        for _, data in pairs(newest) do
            toDraw[#toDraw + 1] = data
        end
    end

    for _, data in ipairs(toDraw) do
	local elapsed = now - data.startTime
	local total   = data.fadeIn + data.holdTime + data.fadeOut

	-- Base alpha values for the fade-in, hold, and fade-out phases
	local alpha = 255
	if data.fadeIn > 0 and elapsed < data.fadeIn then
		alpha = 255 * (elapsed / data.fadeIn)
	elseif data.fadeOut > 0 and elapsed > data.fadeIn + data.holdTime then
		alpha = 255 * (1 - (elapsed - data.fadeIn - data.holdTime) / data.fadeOut)
	end
	alpha = math.Clamp(alpha, 0, 255)
        if alpha <= 0 then continue end

        -- Position. Semantics as CHudMessage in Source:
        --   x/y < 0  → centered along that axis;
        --   x/y >= 0 → text is anchored (top-left) to x*W, y*H.
        local xAlign = (data.x < 0) and TEXT_ALIGN_CENTER or TEXT_ALIGN_LEFT
        local yAlign = (data.y < 0) and TEXT_ALIGN_CENTER or TEXT_ALIGN_TOP
        local px = (data.x < 0) and scrw * 0.5 or scrw * data.x
        local py = (data.y < 0) and scrh * 0.5 or scrh * data.y

        -- Source game_text effects:
        --   0 = fade only
        --   1 = flicker
        --   2 = write-out (scan)
        --   3 = flicker + write-out
        --   4 = write-out + flicker
        local useFlicker  = (data.effect == 1 or data.effect == 3 or data.effect == 4)
        local useWriteOut = (data.effect == 2 or data.effect == 3 or data.effect == 4)

        local usePerChar = useWriteOut
            and data.fxTime > 0
            and not data.text:find("\n", 1, true)
            and (data.col1.r ~= data.col2.r
                 or data.col1.g ~= data.col2.g
                 or data.col1.b ~= data.col2.b)

        if usePerChar then
            PrepareTextMetrics(data)
            local M = data._m

            if M.len > 0 then
                local startX = (xAlign == TEXT_ALIGN_CENTER) and (px - M.totalW * 0.5) or px
                -- Letter i appears at t = (i-1) * charTime.
                -- fxTime is the total write-out duration for the whole line.
                -- Each letter appears fxTime / len seconds after the previous one.
				local charTime       = data.fxTime / M.len
				 -- The color transition from color2 to color1 also takes fxTime.
				local transitionTime = data.fxTime

                -- Draw each letter that has already appeared separately.
                -- A letter appears in color2 and transitions to color1 over
                -- transitionTime. Letters the progress hasn't reached yet
                -- are not drawn at all (as in Source).
                for i = 1, M.len do
                    local charAge = elapsed - (i - 1) * charTime
                    if charAge < 0 then break end

                    -- Alpha: the letter fades in over its own "charTime".
                    local localProg = math.Clamp(charAge / charTime, 0, 1)
                    local charAlpha = alpha * localProg
                    if charAlpha <= 0 then continue end

                    -- Color: color2 (just appeared) → color1 (settled).
                    local colorProg = math.Clamp(charAge / transitionTime, 0, 1)
                    local r = Lerp(colorProg, data.col2.r, data.col1.r)
                    local g = Lerp(colorProg, data.col2.g, data.col1.g)
                    local b = Lerp(colorProg, data.col2.b, data.col1.b)

                    local cell  = M.chars[i]
                    local ch    = data.text:sub(cell[1] + 1, cell[2])
                    local charX = startX + M.cumW[i]
					-- Per-char is vertically centered, so for top-align we
                    -- shift pyDraw down by half a line height.
					local pyDraw = py
					if yAlign == TEXT_ALIGN_TOP then
						pyDraw = py + draw.GetFontHeight(M.font) * 0.5
					end

                    draw.SimpleText(ch, M.font, charX + 1, pyDraw + 1,
                        Color(0, 0, 0, charAlpha * 0.55),
                        TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(ch, M.font, charX, pyDraw,
                        Color(r, g, b, charAlpha),
                        TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
            end
        else
            -- Normal path: a single line, two draw calls.
            local finalText = data.text
            if useFlicker then
                alpha = alpha * ApplyFlicker(elapsed)
            end
            if useWriteOut then
                finalText = ApplyWriteOut(data.text, data.fxTime, elapsed)
            end

            if finalText ~= "" then
                local font = data.isEnvMsg and "ZSMapTextSmall" or "ZSMapText"
                local col  = Color(data.col1.r, data.col1.g, data.col1.b, alpha)

                if finalText:find("\n", 1, true) then
                    DrawMultilineText(finalText, font, px, py, col, xAlign, yAlign)
                else
                    draw.SimpleText(finalText, font, px, py, col, xAlign, yAlign)
                end
            end
        end
    end
end)