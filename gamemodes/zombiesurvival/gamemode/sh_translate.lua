-- Translation library by William Moodhe
-- Feel free to use this in your own addons.
-- See the languages folder to add your own languages.

translate = {}

local Languages = {}
local Translations = {}
local AddingLanguage
local DefaultLanguage = "en"
local CurrentLanguage = DefaultLanguage

-- Cache of the "live" translation table for the current language.
-- LookupTranslation calls these tables hundreds of times per second,
-- and accessing Translations[CurrentLanguage] each time is an extra table lookup.
local CurrentTbl = nil
local DefaultTbl = nil

local function RefreshLangCache()
	DefaultTbl = Translations[DefaultLanguage]
	CurrentTbl = Translations[CurrentLanguage] or DefaultTbl
end

if CLIENT then
    CreateClientConVar("gmod_language_rep", "en", false, true)

	local function UpdateCurrentLanguage()
		local newlang = GetConVar("gmod_language"):GetString()
		if not newlang or newlang == "" then return end

		local changed = newlang ~= CurrentLanguage
		CurrentLanguage = newlang
		RefreshLangCache()

		if newlang ~= GetConVar("gmod_language_rep"):GetString() then
			RunConsoleCommand("gmod_language_rep", newlang)
		end

		if changed and GAMEMODE and GAMEMODE.CreateFonts then
			if GAMEMODE.EmptyCachedFontHeights then
				GAMEMODE:EmptyCachedFontHeights()
			end
			GAMEMODE:CreateFonts()
		end
	end

    UpdateCurrentLanguage()
    timer.Create("checklanguagechange", 1, 0, UpdateCurrentLanguage)
end

-- ============================================================
-- HL2 engine tokens relay
-- ------------------------------------------------------------
-- Client Lua cannot read resource/hl2_*.txt from mounted games:
-- GMod blocks file access there for security. The server CAN
-- read them. So the server parses the file matching the player's
-- gmod_language and ships the token table over the wire. The
-- client injects each token via language.Add(), after which
-- language.GetPhrase() returns the localized text everywhere —
-- including our own ResolveEngineToken().
-- ============================================================

local HL2_LANG_NAMES = {
    ["en"]       = "english",
    ["bg"]       = "bulgarian",
    ["cs"]       = "czech",
    ["da"]       = "danish",
    ["nl"]       = "dutch",
    ["fi"]       = "finnish",
    ["fr"]       = "french",
    ["de"]       = "german",
    ["el"]       = "greek",
    ["hu"]       = "hungarian",
    ["it"]       = "italian",
    ["ja"]       = "japanese",
    ["ko"]       = "korean",
    ["no"]       = "norwegian",
    ["pl"]       = "polish",
    ["pt-BR"]    = "portuguese",
    ["pt-PT"]    = "portuguese",
    ["ro"]       = "romanian",
    ["ru"]       = "russian",
    ["zh-CN"]    = "schinese",
    ["es-ES"]    = "spanish",
    ["sv-SE"]    = "swedish",
    ["th"]       = "thai",
    ["tr"]       = "turkish",
    ["zh-TW"]    = "tchinese",
    ["uk"]       = "ukrainian",
    ["vi"]       = "vietnamese",
}

local function ZS_ResolveHL2LangName(gmodlang)
    if not gmodlang or gmodlang == "" then return "english" end
    local direct = HL2_LANG_NAMES[gmodlang]
    if direct then return direct end
    local base = gmodlang:match("^([^-]+)")
    return base and HL2_LANG_NAMES[base] or "english"
end

-- -- -- SERVER SIDE -- -- --
if SERVER then
    util.AddNetworkString("zs_hl2_lang")

    local hl2Cache = {}   -- [gmodlang] = {token -> text} | false if unavailable

    -- ========================================================
    -- Source KeyValues parser
    -- --------------------------------------------------------
    -- util.KeyValuesToTable() chokes on escaped quotes (\")
    -- inside values, which appear throughout hl2_*.txt
    -- (e.g. "\"A RED LETTER DAY\""). It also lowercases keys
    -- and mishandles the outer "lang {}" block. This is a
    -- minimal hand-written parser that handles everything the
    -- HL2 files actually contain:
    --   * "key" "value" pairs
    --   * "key" { ... } nested blocks
    --   * escapes: \n \t \" \\ \'
    --   * line comments starting with //
    --   * UTF-8 BOM at the start of file
    -- ========================================================
    local function ParseSourceKV(raw)
        if type(raw) ~= "string" or raw == "" then return nil end

        -- Strip UTF-8 BOM if present.
        if raw:sub(1, 3) == "\239\187\191" then
            raw = raw:sub(4)
        end

        local pos, n = 1, #raw

        local function skipWS()
            while pos <= n do
                local b = raw:byte(pos)
                if b == 32 or b == 9 or b == 10 or b == 13 or b == 0 then
                    pos = pos + 1
                elseif b == 47 and raw:byte(pos + 1) == 47 then
                    -- // line comment
                    while pos <= n and raw:byte(pos) ~= 10 do
                        pos = pos + 1
                    end
                else
                    break
                end
            end
        end

        local function parseString()
            -- Assumes pos is at the opening double-quote.
            pos = pos + 1
            local out = {}
            local start = pos

            while pos <= n do
                local b = raw:byte(pos)
                if b == 92 then -- backslash
                    if pos > start then
                        out[#out + 1] = raw:sub(start, pos - 1)
                    end
                    local nb = raw:byte(pos + 1)
                    if nb == 110 then        -- \n
                        out[#out + 1] = "\n"
                    elseif nb == 116 then    -- \t
                        out[#out + 1] = "\t"
                    elseif nb == 114 then    -- \r
                        out[#out + 1] = "\r"
                    elseif nb == 34 then     -- \"
                        out[#out + 1] = '"'
                    elseif nb == 92 then     -- \\
                        out[#out + 1] = "\\"
                    elseif nb == 39 then     -- \'
                        out[#out + 1] = "'"
                    else
                        out[#out + 1] = string.char(nb or 32)
                    end
                    pos = pos + 2
                    start = pos
                elseif b == 34 then       -- closing quote
                    if pos > start then
                        out[#out + 1] = raw:sub(start, pos - 1)
                    end
                    pos = pos + 1
                    return table.concat(out)
                else
                    pos = pos + 1
                end
            end

            -- Unterminated string: return what we have.
            if pos > start then
                out[#out + 1] = raw:sub(start, pos - 1)
            end
            return table.concat(out)
        end

        local function parseBlock()
            local t = {}
            while pos <= n do
                skipWS()
                if pos > n then break end

                local b = raw:byte(pos)
                if b == 125 then          -- }
                    pos = pos + 1
                    return t
                elseif b == 34 then       -- opening "key"
                    local key = parseString()
                    skipWS()
                    if pos > n then
                        t[key] = ""
                        break
                    end

                    local nb = raw:byte(pos)
                    if nb == 123 then     -- {
                        pos = pos + 1
                        t[key] = parseBlock()
                    elseif nb == 34 then  -- "value"
                        t[key] = parseString()
                    else
                        -- Rare unquoted scalar; read until EOL or }.
                        local s = {}
                        while pos <= n do
                            local cb = raw:byte(pos)
                            if cb == 10 or cb == 13 or cb == 125 then break end
                            s[#s + 1] = string.char(cb)
                            pos = pos + 1
                        end
                        t[key] = (table.concat(s):gsub("%s+$", ""))
                    end
                else
                    pos = pos + 1
                end
            end
            return t
        end

        local ok, result = pcall(parseBlock)
        if not ok or type(result) ~= "table" then return nil end
        return result
    end
	
    -- ========================================================
    -- UTF-16 → UTF-8 decoder
    -- --------------------------------------------------------
    -- Valve's hl2_*.txt files are UTF-16 LE with a BOM (FF FE).
    -- Each visible character is 2 bytes; for Cyrillic/Greek/
    -- accented Latin we get code points > 127, which must be
    -- re-encoded as multi-byte UTF-8 for GMod's text pipeline.
    --
    -- We also handle UTF-16 BE (FE FF) and UTF-8 BOM (EF BB BF)
    -- because some third-party language packs ship different
    -- encodings of the same files.
    -- ========================================================
    local function Utf8Encode(code)
        if code < 0x80 then
            return string.char(code)
        elseif code < 0x800 then
            return string.char(
                0xC0 + math.floor(code / 0x40),
                0x80 + (code % 0x40)
            )
        elseif code < 0x10000 then
            return string.char(
                0xE0 + math.floor(code / 0x1000),
                0x80 + (math.floor(code / 0x40) % 0x40),
                0x80 + (code % 0x40)
            )
        else
            return string.char(
                0xF0 + math.floor(code / 0x40000),
                0x80 + (math.floor(code / 0x1000) % 0x40),
                0x80 + (math.floor(code / 0x40) % 0x40),
                0x80 + (code % 0x40)
            )
        end
    end

    local UTF8_REPLACEMENT = "\239\191\189" -- U+FFFD

    local function DecodeUTF16(raw, littleEndian, startIndex)
        local out = {}
        local i = startIndex or 1
        local n = #raw

        while i + 1 <= n do
            local b1, b2 = raw:byte(i), raw:byte(i + 1)
            i = i + 2

            local code
            if littleEndian then
                code = b1 + b2 * 256
            else
                code = b2 + b1 * 256
            end

            if code >= 0xD800 and code <= 0xDBFF and i + 1 <= n then
                -- High surrogate; need the low one.
                local b3, b4 = raw:byte(i), raw:byte(i + 1)
                local low
                if littleEndian then
                    low = b3 + b4 * 256
                else
                    low = b4 + b3 * 256
                end

                if low >= 0xDC00 and low <= 0xDFFF then
                    i = i + 2
                    local full = 0x10000 + (code - 0xD800) * 0x400 + (low - 0xDC00)
                    out[#out + 1] = Utf8Encode(full)
                else
                    out[#out + 1] = UTF8_REPLACEMENT
                end
            elseif code >= 0xDC00 and code <= 0xDFFF then
                -- Lone low surrogate — malformed input.
                out[#out + 1] = UTF8_REPLACEMENT
            else
                out[#out + 1] = Utf8Encode(code)
            end
        end

        return table.concat(out)
    end

    -- Detects BOM and returns the raw bytes as UTF-8 text.
    -- If no BOM is present, returns the input unchanged so that
    -- plain ASCII / UTF-8 files still work.
    local function NormalizeEncoding(raw)
        if type(raw) ~= "string" or #raw < 2 then return raw end

        local b1, b2 = raw:byte(1), raw:byte(2)

        -- UTF-16 LE BOM (FF FE)
        if b1 == 0xFF and b2 == 0xFE then
            return DecodeUTF16(raw, true, 3)
        end

        -- UTF-16 BE BOM (FE FF)
        if b1 == 0xFE and b2 == 0xFF then
            return DecodeUTF16(raw, false, 3)
        end

        -- UTF-8 BOM (EF BB BF)
        if b1 == 0xEF and b2 == 0xBB and raw:byte(3) == 0xBF then
            return raw:sub(4)
        end

        return raw
    end

    local HL2_CANDIDATES = {
        "resource/hl2_%s.txt",
        "hl2/resource/hl2_%s.txt",
    }

    local function ExtractTokenTable(root)
        -- File layout:
        --     "lang" {
        --         "Language" "English"
        --         "Tokens"   { "Key" "Value" ... }
        --     }
        -- We preserve case, so try both "lang"/"Lang" and
        -- "Tokens"/"tokens" to be robust against unusual files.
        local langBlock = root.lang or root.Lang
        if type(langBlock) == "table" then
            local tokens = langBlock.Tokens or langBlock.tokens
            if type(tokens) == "table" then return tokens end
            -- Some writers flatten without a Tokens wrapper.
            return langBlock
        end

        local tokens = root.Tokens or root.tokens
        if type(tokens) == "table" then return tokens end

        return nil
    end

    local function ZS_LoadHL2Tokens(gmodlang)
        local cached = hl2Cache[gmodlang]
        if cached ~= nil then return cached or nil end

        local fname = ZS_ResolveHL2LangName(gmodlang)

        for _, tpl in ipairs(HL2_CANDIDATES) do
            local path = tpl:format(fname)
            if file.Exists(path, "GAME") then
                local raw = file.Read(path, "GAME")
                if raw then
                    raw = NormalizeEncoding(raw)
                    local root = ParseSourceKV(raw)
                    local tokens = root and ExtractTokenTable(root)

                    if type(tokens) == "table" and next(tokens) ~= nil then
                        local count = 0
                        for _ in pairs(tokens) do count = count + 1 end

                        hl2Cache[gmodlang] = tokens
                        return tokens
                    end
                end
            end
        end

        -- If the requested language isn't available, fall back to English.
        if fname ~= "english" then
            local en = ZS_LoadHL2Tokens("en")
            hl2Cache[gmodlang] = en or false
            return en
        end

        hl2Cache[gmodlang] = false
        return nil
    end
	
	    -- ========================================================
    -- titles.txt parser
    -- --------------------------------------------------------
    -- Source's titles.txt maps a title *name* (like GAMEOVER_ALLY)
    -- to a language token (like #HL2_GameOver_Ally) or to inline
    -- text. env_message resolves names through it automatically,
    -- but game_text does not — that's why a raw "GAMEOVER_ALLY"
    -- ends up on screen unlocalized.
    --
    -- Format:
    --     TITLE_NAME
    --     {
    --     #HL2_SomeToken
    --     }
    --
    -- Modifiers ($position, $effect, etc.) apply to subsequent
    -- blocks. We skip them; we only care about name → content.
    -- ========================================================
    local titlesCache = nil

    local function ParseTitlesFile(raw)
        local titles = {}
        if type(raw) ~= "string" or raw == "" then return titles end

        -- Strip line comments (// ... to end of line).
        raw = raw:gsub("//[^\r\n]*", "")

        local i, n = 1, #raw
        while i <= n do
            -- Skip whitespace.
            while i <= n do
                local b = raw:byte(i)
                if b == 32 or b == 9 or b == 10 or b == 13 then i = i + 1
                else break end
            end
            if i > n then break end

            local b = raw:byte(i)

            if b == 36 then
                -- $ directive — skip to end of line.
                while i <= n and raw:byte(i) ~= 10 do i = i + 1 end
            elseif b == 123 then
                -- Stray { — skip.
                i = i + 1
            else
                -- Title name — read until whitespace or {.
                local ns = i
                while i <= n do
                    local cb = raw:byte(i)
                    if cb == 32 or cb == 9 or cb == 10 or cb == 13 or cb == 123 then
                        break
                    end
                    i = i + 1
                end
                local name = raw:sub(ns, i - 1)

                -- Skip whitespace before {.
                while i <= n do
                    local cb = raw:byte(i)
                    if cb == 32 or cb == 9 or cb == 10 or cb == 13 then i = i + 1
                    else break end
                end

                if raw:byte(i) == 123 then
                    i = i + 1
                    local cs = i
                    while i <= n and raw:byte(i) ~= 125 do i = i + 1 end
                    local content = raw:sub(cs, i - 1)
                    i = i + 1 -- consume }

                    content = content:gsub("^%s+", ""):gsub("%s+$", "")
                    if name ~= "" and content ~= "" then
                        titles[name] = content
                    end
                end
            end
        end

        return titles
    end

    local function LoadTitles()
        if titlesCache then return titlesCache end

        local candidates = {
            "resource/titles.txt",
            "hl2/resource/titles.txt",
        }

        for _, path in ipairs(candidates) do
            if file.Exists(path, "GAME") then
                local raw = file.Read(path, "GAME")
                if raw then
                    raw = NormalizeEncoding(raw)
                    local parsed = ParseTitlesFile(raw)
                    if next(parsed) ~= nil then
                        titlesCache = parsed
                        local cnt = 0
                        for _ in pairs(parsed) do cnt = cnt + 1 end
                        return titlesCache
                    end
                end
            end
        end

        titlesCache = {}
        return titlesCache
    end

        local function ZS_SendHL2Lang(ply)
        if not IsValid(ply) then return end

        local lang = ply:GetInfo("gmod_language_rep")
        if not lang or lang == "" then lang = "en" end

        local tokens = ZS_LoadHL2Tokens(lang) or {}
        local titles = LoadTitles() or {}

        local payload = {
            tokens = tokens,
            titles = titles,
        }

        local json = util.TableToJSON(payload)
        if not json then return end

        local compressed = util.Compress(json)
        if not compressed then return end

        net.Start("zs_hl2_lang")
            net.WriteString(lang)
            net.WriteUInt(#compressed, 32)
            net.WriteData(compressed, #compressed)
        net.Send(ply)

        local tcount, titcount = 0, 0
        for _ in pairs(tokens) do tcount = tcount + 1 end
        for _ in pairs(titles) do titcount = titcount + 1 end

    end

    hook.Add("PlayerInitialSpawn", "ZS_HL2LangSend", function(ply)
        timer.Simple(2, function()
            if IsValid(ply) then ZS_SendHL2Lang(ply) end
        end)
    end)

    cvars.AddChangeCallback("gmod_language_rep", function(cvar, oldv, newv)
        for _, ply in ipairs(player.GetAll()) do
            if ply:GetInfo("gmod_language_rep") == newv then
                ZS_SendHL2Lang(ply)
            end
        end
    end)
end

-- -- -- CLIENT SIDE -- -- --
if CLIENT then
    -- Client-side title map. Seeded by sh_titles.lua (which runs
    -- after this file in shared.lua); the server payload merges on
    -- top in the net handler below.
    translate.Titles = translate.Titles or {}

    function translate.GetTitleValue(name)
        if type(name) ~= "string" or name == "" then return nil end
        return translate.Titles[name]
    end

    net.Receive("zs_hl2_lang", function()
        local lang = net.ReadString()
        local size = net.ReadUInt(32)

        if size == 0 then
            return
        end

        local compressed = net.ReadData(size)
        if not compressed then return end

        local json = util.Decompress(compressed)
        if not json then return end

        local payload = util.JSONToTable(json)
        if type(payload) ~= "table" then return end

        local ourlang = GetConVar("gmod_language"):GetString()
        if ourlang ~= lang then
            return
        end

        -- Support old payload format (flat token table) for safety.
        local tokens = payload.tokens or (not payload.titles and payload) or {}
        local titles = payload.titles or {}

        local tcount = 0
        for token, value in pairs(tokens) do
            if type(token) == "string" and type(value) == "string" and value ~= "" then
                language.Add(token, value)
                tcount = tcount + 1
            end
        end

        local titcount = 0
        for name, value in pairs(titles) do
            if type(name) == "string" and type(value) == "string" and value ~= "" then
                translate.Titles[name] = value
                titcount = titcount + 1
            end
        end

        hook.Run("ZS_HL2LangReceived", lang)
    end)
end

function translate.GetLanguages()
	return Languages
end

function translate.GetLanguageName(short)
	return Languages[short]
end

function translate.GetTranslations(short)
	return Translations[short] or Translations[DefaultLanguage]
end

function translate.AddLanguage(short, long)
	Languages[short] = long
	Translations[short] = Translations[short] or {}
	AddingLanguage = short
	RefreshLangCache()
end

function translate.AddTranslation(id, text)
	if not AddingLanguage or not Translations[AddingLanguage] then return end

	Translations[AddingLanguage][id] = text
end

local PluralRules = {}

local function RuleOneOther(n)
	return n == 1 and "one" or "other"
end

local function RuleZeroAndOne(n)
	return n <= 1 and "one" or "other"
end

local function RuleOther()
	return "other"
end

-- Russian, Ukrainian, Croatian: 1 / 2-4 / 5+
local function RuleEastSlavic(n)
	local n10, n100 = n % 10, n % 100
	if n10 == 1 and n100 ~= 11 then return "one" end
	if n10 >= 2 and n10 <= 4 and (n100 < 12 or n100 > 14) then return "few" end
	return "many"
end

local function RulePolish(n)
	if n == 1 then return "one" end
	local n10, n100 = n % 10, n % 100
	if n10 >= 2 and n10 <= 4 and (n100 < 12 or n100 > 14) then return "few" end
	return "many"
end

-- Czech, Slovak
local function RuleCzech(n)
	if n == 1 then return "one" end
	if n >= 2 and n <= 4 then return "few" end
	return "other"
end

local function RuleLithuanian(n)
	local n10, n100 = n % 10, n % 100
	if n10 == 1 and (n100 < 11 or n100 > 19) then return "one" end
	if n10 >= 2 and (n100 < 11 or n100 > 19) then return "few" end
	return "other"
end

for _, code in ipairs({"en", "en-PT", "de", "da", "nl", "no", "sv-SE", "es-ES", "it", "el", "bg", "et", "fi", "hu", "tr", "pt-PT"}) do
	PluralRules[code] = RuleOneOther
end
for _, code in ipairs({"fr", "pt-BR"}) do
	PluralRules[code] = RuleZeroAndOne
end
for _, code in ipairs({"ja", "ko", "zh-CN", "zh-TW", "th", "vi"}) do
	PluralRules[code] = RuleOther
end
for _, code in ipairs({"ru", "uk", "hr"}) do
	PluralRules[code] = RuleEastSlavic
end
PluralRules["pl"] = RulePolish
PluralRules["cs"] = RuleCzech
PluralRules["sk"] = RuleCzech
PluralRules["lt"] = RuleLithuanian

-- Call inside a language file (after translate.AddLanguage) or pass the language code first.
function translate.SetPluralRule(short, func)
	if type(short) == "function" then
		short, func = AddingLanguage, short
	end
	if not short or type(func) ~= "function" then return end

	PluralRules[short] = func
end

local function GetPluralRule(short)
	return PluralRules[short] or PluralRules[string.match(short, "^([^-]+)")] or RuleOneOther
end

-- ============================================================
-- Case tables
-- ------------------------------------------------------------
-- An entry can be:
--   * a line                       — a standard translation;
--   * a table with one/few/many/...   — plural forms;
--   * a table with nom/gen/acc/...    — the cases of the class name.
--
-- Distinguish between the two types of tables by their keys: if at least one
-- plural key is found, it is a plural table. Otherwise, if there is a nom or [1] —
-- it is a case table. There are no overlaps.
-- ============================================================
local PLURAL_FORM_KEYS = {
    one   = true,
    few   = true,
    many  = true,
    other = true,
    zero  = true,
}

local function IsCaseTable(entry)
    if type(entry) ~= "table" then return false end

    for k in pairs(PLURAL_FORM_KEYS) do
        if entry[k] ~= nil then return false end
    end

    return entry.nom ~= nil or entry[1] ~= nil
end

-- Picks the right string out of a translation. Plain strings are returned as they are.
local function GetPluralForm(entry, short, count)
	if type(entry) ~= "table" then return entry end

	count = tonumber(count)
	if not count then
		return entry.other or entry.many or entry.few or entry.one or entry.zero
	end

	count = math.abs(count)
	if count == 0 and entry.zero then return entry.zero end

	local form = "other"
	if count == math.floor(count) then
		form = GetPluralRule(short)(count)
	end

	return entry[form] or entry.other or entry.many or entry.few or entry.one or entry.zero
end

--------------------------------------------------------------------
-- Lowercase-after-comma defaults per language
--------------------------------------------------------------------
-- Some languages write common nouns (like class names) in lowercase
-- even in the middle of a sentence; German capitalizes them, CJK has
-- no case at all. "after_comma" tells the class-unlock list whether
-- to lower everything after the first element; "scripts" limits which
-- scripts get touched, so e.g. Russian won't lowercase stray English
-- fallback names that never got translated.
--
-- Each language file can override these by setting LANGUAGE.lowercase_after_comma
-- and/or LANGUAGE.lowercase_scripts explicitly.

local LowercaseDefaults = {
    -- Cyrillic — safely limited to Cyrillic runs
    bg = {after_comma = "1", scripts = "cyrillic"},
    ru = {after_comma = "1", scripts = "cyrillic"},
    uk = {after_comma = "1", scripts = "cyrillic"},

    -- Greek — limited to Greek runs
    el = {after_comma = "1", scripts = "greek"},

    -- Latin-script languages where common nouns are lowercase
    cs = {after_comma = "1", scripts = "latin"},
    da = {after_comma = "1", scripts = "latin"},
    ["es-ES"] = {after_comma = "1", scripts = "latin"},
    et = {after_comma = "1", scripts = "latin"},
    fi = {after_comma = "1", scripts = "latin"},
    fr = {after_comma = "1", scripts = "latin"},
    hr = {after_comma = "1", scripts = "latin"},
    hu = {after_comma = "1", scripts = "latin"},
    it = {after_comma = "1", scripts = "latin"},
    lt = {after_comma = "1", scripts = "latin"},
    nl = {after_comma = "1", scripts = "latin"},
    no = {after_comma = "1", scripts = "latin"},
    pl = {after_comma = "1", scripts = "latin"},
    ["pt-PT"] = {after_comma = "1", scripts = "latin"},
    ["pt-BR"] = {after_comma = "1", scripts = "latin"},
    sk = {after_comma = "1", scripts = "latin"},
    ["sv-SE"] = {after_comma = "1", scripts = "latin"},
    tr = {after_comma = "1", scripts = "latin"},
    vi = {after_comma = "1", scripts = "latin"},

    -- German capitalizes nouns; English is conventionally capitalized in lists;
    -- CJK and Thai have no case.
}

local DefaultAfterComma = "0"
local DefaultScripts = "any"

function translate.GetLowercaseAfterComma()
    if translate.Exists("lowercase_after_comma") then
        return translate.Get("lowercase_after_comma")
    end
    local d = LowercaseDefaults[CurrentLanguage]
    return d and d.after_comma or DefaultAfterComma
end

function translate.GetLowercaseScripts()
    if translate.Exists("lowercase_scripts") then
        local v = translate.Get("lowercase_scripts")
        if v ~= "" and v ~= "@lowercase_scripts@" then return v end
    end
    local d = LowercaseDefaults[CurrentLanguage]
    return d and d.scripts or DefaultScripts
end

-- Returns the translation entry and the language it was found in (falls back to English).
local function LookupTranslation(id)
	local entry = CurrentTbl and CurrentTbl[id]
	if entry ~= nil then return entry, CurrentLanguage end

	if CurrentTbl ~= DefaultTbl then
		entry = DefaultTbl and DefaultTbl[id]
		if entry ~= nil then return entry, DefaultLanguage end
	end
end

-- True if a translation with this id exists in the current language or in English.
function translate.Exists(id)
	return LookupTranslation(id) ~= nil
end

function translate.Get(id, count)
    local entry, short = LookupTranslation(id)
    if entry == nil then return "@"..id.."@" end

    local res
    if IsCaseTable(entry) then
        res = entry.nom or entry[1]
    else
        res = GetPluralForm(entry, short, count)
    end

    if type(res) ~= "string" then return "@"..id.."@" end
    
    if translate.InterpolateBindNames then
        res = translate.InterpolateBindNames(res)
    end
    
    return res
end

local function ApplyPositionalFormat(template, ...)
	local nargs = select("#", ...)
	local args = { ... }

	local result = template:gsub("%%(%d+)%$([%-%+ #0]*%d*%.?%d*[sdifg])", function(pos, spec)
		pos = tonumber(pos)
		if not pos or pos < 1 or pos > nargs then return "" end
		local v = args[pos]
		if v == nil then return "" end
		return string.format("%" .. spec, v)
	end)

	result = result:gsub("%%%%", function() return "%" end)

	return result
end

function translate.Format(id, ...)
	local count
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		if type(v) == "number" then
			count = v
			break
		end
	end

	local template = translate.Get(id, count)
	if type(template) ~= "string" then
		return "@" .. id .. "@"
	end

	if string.find(template, "%%%d+%$[%-%+ #0%d%.]*[sdifg]") then
		return ApplyPositionalFormat(template, ...)
	end

    local result
    if string.find(template, "%%%d+%$[%-%+ #0%d%.]*[sdifg]") then
        result = ApplyPositionalFormat(template, ...)
    else
        result = string.format(template, ...)
    end

    if translate.InterpolateBindNames then
        result = translate.InterpolateBindNames(result)
    end

    return result
end

function translate.ItemName(id, prefix)
	if not id then return nil end
	prefix = prefix or "trinket"
	local key = prefix .. "_name_" .. id
	if translate.Exists(key) then return translate.Get(key) end
end

-- Resolves a raw ammo type into its display name for the current language.
-- GM.AmmoNames stores translation keys ("ammo_name_*") — this unwraps them
-- and falls back gracefully if the key isn't registered anywhere.
--
-- Second parameter is the context where the ammo name is displayed. Allows
-- different translations for different places:
--   nil / ""   → base key ammo_name_<ammo>
--   "ps"       → ammo_name_ps_<ammo>       (Points Shop / arsenal)
--   "inv"      → ammo_name_inv_<ammo>      (inventory / F3 menu)
--   "notify"   → ammo_name_notify_<ammo>   (pop-up notifications)
-- If the context key isn't set in either the current language or in English —
-- the base ammo_name_<ammo> is used, and only then — the raw ID.
function translate.AmmoName(ammotype, context)
    if not ammotype or ammotype == "" then return "" end

    -- The engine returns built-in ammo types in mixed case
    -- ("GaussEnergy", "SMG1", "AR2"), while GM.AmmoNames is populated
    -- with lowercase keys. Normalize the case before lookup.
    local lower = string.lower(ammotype)

    local key
    if GAMEMODE and GAMEMODE.AmmoNames then
        key = GAMEMODE.AmmoNames[lower] or GAMEMODE.AmmoNames[ammotype]
    end

    if not key then
        return ammotype
    end

    if string.sub(key, 1, 10) == "ammo_name_" then
        local bare = string.sub(key, 11)

        if context and context ~= "" then
            local ctxkey = "ammo_name_" .. context .. "_" .. bare
            local t = translate.Get(ctxkey)
            if t ~= "@" .. ctxkey .. "@" then
                return t
            end
        end

        local t = translate.Get(key)
        if t ~= "@" .. key .. "@" then return t end

        return bare
    end

    return key
end

function translate.ItemDesc(id, fallback, numbers, prefix)
	if not id then return fallback end
	prefix = prefix or "trinket"
	local key = prefix .. "_desc_" .. id
	if translate.Exists(key) then
		local fmt = translate.Get(key)
		if numbers and #numbers > 0 then
			return string.format(fmt, unpack(numbers))
		end
		return fmt
	end
	return fallback
end

-- Replaces {{bind:+attack}} / {{bind:+attack2|RMB}} tokens with the player's
-- current keybinding. Semantic part (after the pipe) is used as the friendly
-- default name when the player hasn't rebound that action.
--
-- Only works on the client (translate.GetBindKeyName is client-only). On the
-- server it's a no-op — the tokens are returned untouched. That's fine because
-- weapon/trinket descriptions are only ever rendered on the client.
local function InterpolateBindNames(str)
    translate.InterpolateBindNames = InterpolateBindNames
	if type(str) ~= "string" then return str end
	if not translate.GetBindKeyName then return str end

	-- Semantic form: {{bind:+attack2|SECONDARY ATTACK}}
	-- Capture allows anything except "}" and "|" so spaces inside the
	-- semantic name ("PRIMARY ATTACK") work.
	str = str:gsub("{{bind:([%w_%+%-]+)|([^|}]+)}}", function(bind, semantic)
		return translate.GetBindKeyName(bind, semantic)
	end)

	-- Plain form: {{bind:+attack}}
	str = str:gsub("{{bind:([%w_%+%-]+)}}", function(bind)
		return translate.GetBindKeyName(bind)
	end)

	return str
end

-- Weapon-specific wrappers. Set SWEP.TranslationID (short id, e.g. "tempest") and
-- SWEP.TranslationPrefix = "weapon" on the weapon to translate its PrintName/Description
-- (add the matching LANGUAGE.weapon_name_<id> / weapon_desc_<id> entries to a language file).
-- Without those two fields set, these just return PrintName/Description unchanged.
-- Falls back to the weapon's class name (with a leading "weapon_zs_" stripped) when TranslationID isn't
-- set explicitly, so any weapon based on weapon_zs_base gets a usable id for free. Returns nil if there's
-- no TranslationPrefix at all (e.g. old weapons not based on weapon_zs_base) or no ClassName to fall back to.
local function GetWeaponTranslationID(swep)
	if not swep or not swep.ClassName then return nil end
	if swep.TranslationID then return swep.TranslationID end
	if string.sub(swep.ClassName, 1, 10) ~= "weapon_zs_" then return nil end

	local ownid = (string.gsub(swep.ClassName, "^weapon_zs_", ""))

	-- If the class itself has its own translation — use it.
    -- This is needed for cases where the ZE variant should have its
    -- own separate name different from the base.
	if translate.Exists("wpn_name_" .. ownid) then
		return ownid
	end

	-- Otherwise walk up the Base chain and look for the first class
    -- that has wpn_name_<id>. This way ZE weapons automatically
    -- inherit the base weapon's translation without duplicating keys.
	local seen = { [ownid] = true }
	local base = swep.Base
	local guard = 0

	while base and guard < 16 do
		guard = guard + 1

		local basetab = (type(base) == "string") and weapons.GetStored(base) or base
		if not basetab or not basetab.ClassName then break end
		if seen[basetab.ClassName] then break end
		seen[basetab.ClassName] = true

		if string.sub(basetab.ClassName, 1, 10) == "weapon_zs_" then
			local baseid = (string.gsub(basetab.ClassName, "^weapon_zs_", ""))
			if translate.Exists("wpn_name_" .. baseid) then
				return baseid
			end
		end

		base = basetab.Base
	end

	-- Nothing found — return our own ID as it was.
	return ownid
end

-- ============================================================
-- Class name casing (per-language)
-- ------------------------------------------------------------
-- The equivalent of qlt_weapon_lowercase for zombie class names. It works
-- because the class name is substituted into an already translated
-- sentence—the translator cannot omit the case from
-- the `LANGUAGE.<key>` string itself.
--
-- LANGUAGE.class_name_lowercase         = "1"         -- enabled
-- LANGUAGE.class_name_lowercase_scripts = "cyrillic"   -- optional
--     script filter: lowercase only if the name
--     is written in one of these scripts (“cyrillic”, “greek”,
--     “cyrillic, greek”, ‘latin’, “” = any).
--
-- Usage:
--     translate.ClassName(translate.Get(classtab.TranslationName))
-- ============================================================
local function ClassNameLowercaseEnabled()
    if not (translate and translate.Exists) then return false end
    return translate.Get("class_name_lowercase") == "1"
end

local function ClassNameLowercaseScripts()
    if not (translate and translate.Exists) then return { "any" } end
    local v = translate.Get("class_name_lowercase_scripts")
    if type(v) ~= "string" or v == "" or v == "@class_name_lowercase_scripts@" then
        return { "any" }
    end
    local s = string.Explode(",", v:gsub("%s", ""))
    if #s == 0 then return { "any" } end
    return s
end

function translate.ClassName(name)
    if type(name) ~= "string" or name == "" then return name end
    if not ClassNameLowercaseEnabled() then return name end

    if string.HasScript then
        local scripts = ClassNameLowercaseScripts()
        if not string.HasScript(name, scripts) then
            return name
        end
    end

    if string.utf8lower then
        return string.utf8lower(name)
    end
    return string.lower(name)
end

-- ============================================================
-- Class name cases (per language)
-- ------------------------------------------------------------
-- A class can have forms for different cases, declared either
-- in a single table:
--     LANGUAGE.class_zombie = {nom="Zombie", gen="Zombie", acc="Zombie",
--                              dat="Zombie", ins="Zombie", pre="Zombie"}
-- or as separate keys (old format):
--     LANGUAGE.class_zombie       = "Zombie"
--     LANGUAGE.class_zombie_gen   = "..."
--     LANGUAGE.class_zombie_acc   = "..."
-- All forms except the base form are optional.
--
-- A language can also override the case for a specific message
-- via the class_case_<message_id> key, and this takes precedence over
-- the case passed from the code.
-- ============================================================

local function ResolveClassCase(messageID, defaultCase)
    if messageID and messageID ~= "" then
        local override = "class_case_" .. messageID
        if translate.Exists(override) then
            local v = translate.Get(override)
            if type(v) == "string" and v ~= "" and v ~= "@" .. override .. "@" then
                return v
            end
        end
    end
    return defaultCase
end

function translate.ClassNameKey(key, grammaticalCase)
    if type(key) ~= "string" or key == "" then return key end

    local entry = LookupTranslation(key)

    if IsCaseTable(entry) then
        local c = grammaticalCase
        if not c or c == "" then c = "nom" end

        local name = entry[c] or entry.nom or entry[1]
        if type(name) ~= "string" or name == "" then return name end
        return translate.ClassName(name)
    end

    local actualKey = key
    if grammaticalCase and grammaticalCase ~= "" and grammaticalCase ~= "nom" then
        local caseKey = key .. "_" .. grammaticalCase
        if translate.Exists(caseKey) then
            actualKey = caseKey
        end
    end

    local name = translate.Get(actualKey)
    if type(name) ~= "string" or name == "" then return name end
    return translate.ClassName(name)
end

function translate.ClassNameKeyFor(messageID, key, defaultCase)
    local case = ResolveClassCase(messageID, defaultCase)
    return translate.ClassNameKey(key, case)
end

local function ApplyQualityFormat(quality, name)
	local fmt = translate.Get("qlt_weapon_format_targetid")
	if fmt == "@qlt_weapon_format_targetid@" then
		fmt = "%quality% %name%"
	end

	local lower = translate.Get("qlt_weapon_lowercase")
	if lower == "1" then
		if string.utf8lower then
			quality = string.utf8lower(quality)
		else
			quality = string.lower(quality)
		end
	end

	local result = string.gsub(fmt, "%%quality%%", function() return quality end)
	result = string.gsub(result, "%%name%%", function() return name end)

	return result
end

local function GetWeaponQualityNameID(swep)
	local tier = swep.QualityTier
	if not tier or tier < 1 then return nil end

	local branch = swep.Branch
	if branch and branch > 0 then
		local base = swep.BaseQuality and weapons.Get(swep.BaseQuality)
		if base and base.Branches and base.Branches[branch] then
			local br = base.Branches[branch]
			if br.NewNameIDs and br.NewNameIDs[tier] then
				return br.NewNameIDs[tier]
			end
		end

		if GAMEMODE and GAMEMODE.WeaponQualityAltNameIDs then
			return GAMEMODE.WeaponQualityAltNameIDs[tier]
		end
		return nil
	end

	if GAMEMODE and GAMEMODE.WeaponQualityNameIDs then
		return GAMEMODE.WeaponQualityNameIDs[tier]
	end
	return nil
end

-- ============================================================
-- Deployable display name
-- ------------------------------------------------------------
-- GM.DeployableInfo[class].Name is usually just a translation
-- key ("deployable_gunturret"). Quality variants created by
-- CreateWeaponOfQuality additionally carry QualityTier /
-- QualityNameID / BaseNameKey so that a localized
-- "<quality> <base>" can be assembled instead of an English
-- concatenation.
-- ============================================================
function translate.DeployableName(pl, info)
    if not info then return "?" end

    if info.QualityTier and info.BaseNameKey then
        -- 1. Quality name — from qlt_name_<id> (fallback — English).
        local qid = info.QualityNameID
            or (GAMEMODE and GAMEMODE.WeaponQualityNameIDs
                and GAMEMODE.WeaponQualityNameIDs[info.QualityTier])

        local qname
        if qid then
            local qkey = "qlt_name_" .. qid
            local v = translate.ClientGet(pl, qkey)
            if type(v) == "string" and v ~= "" and v ~= "@" .. qkey .. "@" then
                qname = v
            end
        end
        if not qname and GAMEMODE and GAMEMODE.WeaponQualities then
            local q = GAMEMODE.WeaponQualities[info.QualityTier]
            qname = q and q[1]
        end

        -- 2. Base deployable name — a regular translation key.
        local bname = translate.ClientGet(pl, info.BaseNameKey)
        if type(bname) ~= "string"
            or bname == ""
            or bname == "@" .. info.BaseNameKey .. "@" then
            bname = info.BaseNameKey
        end

        -- 3. Assembly by format. Default — "%quality% %name%",
        --    matches the weapon name order in the remantler.
        local fmtkey = "qlt_deployable_format"
        local fmt = translate.ClientGet(pl, fmtkey)
        if type(fmt) ~= "string" or fmt == "" or fmt == "@" .. fmtkey .. "@" then
            fmt = "%quality% %name%"
        end

        local result = string.gsub(fmt, "%%quality%%", function() return qname or "" end)
        result = string.gsub(result, "%%name%%", function() return bname or "" end)
        return result
    end

    -- Regular deployable — just resolve the translation key.
    return translate.ClientGet(pl, info.Name)
end

function translate.WeaponName(swep)
	if not swep then return nil end

	-- Resolve an explicit wpn_name_* translation first. Its presence
	-- overrides the ZombieOnly → class-name behavior below, so a
	-- shared zombie weapon can still show its own individual name.
	local id = GetWeaponTranslationID(swep)
	local explicit_name = id and translate.ItemName(id, swep.TranslationPrefix or "wpn")

	-- Zombie weapons normally display as their zombie class name,
	-- but only if they don't have their own wpn_name_* entry.
	if not explicit_name then
		if swep.ZombieOnly or swep.Base == "weapon_zs_zombie" or swep.Base == "weapon_zs_poisonheadcrab" then
			local map = GAMEMODE and GAMEMODE.ZombieClassBySWEP
			local zclass = map and swep.ClassName and map[swep.ClassName]
			if zclass and zclass.TranslationName and translate.Exists(zclass.TranslationName) then
				return translate.Get(zclass.TranslationName)
			end

			-- Fallback: direct class_<id> lookup (works for weapon_zs_zombie -> class_zombie, weapon_zs_headcrab -> class_headcrab).
			local fallbackid = swep.ClassName and (string.gsub(swep.ClassName, "^weapon_zs_", ""))
			if fallbackid then
				local key = "class_" .. fallbackid
				if translate.Exists(key) then return translate.Get(key) end
			end
		end
	end

	local basename = explicit_name
	if not basename then
		if swep.QualityTier and swep.BaseQuality then
			local stored = weapons.GetStored(swep.BaseQuality)
			if stored and stored.PrintName then
				basename = stored.PrintName
			end
		end
		if not basename then
			basename = swep.PrintName
		end
	end

	if not basename then return nil end

	local qid = GetWeaponQualityNameID(swep)
	if qid and translate.Exists("qlt_name_" .. qid) then
		local qname = translate.Get("qlt_name_" .. qid)
		return ApplyQualityFormat(qname, basename)
	end

    -- Key of a built-in engine translation like "#HL2_SMG1".
	-- Resolve it ourselves via language.GetPhrase, so that the string
	-- is readable everywhere: DEXNotification, DLabelAutoScroll,
	-- draw.SimpleText, chat, etc. Without this DLabel sometimes shows
	-- "SMG", while our custom elements show literally "#HL2_SMG1" or nothing.
	if basename:sub(1, 1) == "#" then
		-- Key like "#HL2_SMG1". language.GetPhrase expects it WITHOUT "#",
		-- so we strip the hash before the call.
		local key = basename:sub(2)

		local resolved = language.GetPhrase(key)
		if type(resolved) == "string" and resolved ~= "" and resolved ~= key then
			return resolved
		end

		-- Some localizations store the key as-is, together with the "#".
		resolved = language.GetPhrase(basename)
		if type(resolved) == "string" and resolved ~= "" and resolved ~= basename then
			return resolved
		end

		-- The engine doesn't know this key — readable fallback from the key itself.
		key = key:gsub("^HL2_", ""):gsub("^Cstrike_", ""):gsub("^GMod_", "")
		key = key:gsub("_", " ")
		key = key:gsub("(%a)([%w]*)", function(a, b)
			return a:upper() .. b:lower()
		end)
		return key
	end

	return basename
end     

-- Walks the weapon's Base chain and returns the first id (with the
-- "weapon_zs_" prefix stripped) that has a wpn_desc_<id> translation.
-- Prefers the weapon's own id first, then its bases. This lets a child
-- weapon inherit its base's translated description (and also lets a
-- child override it without needing a matching wpn_name_<id>).
local function GetWeaponDescTranslationID(swep)
	if not swep or not swep.ClassName then return nil end
	if swep.TranslationID then return swep.TranslationID end
	if string.sub(swep.ClassName, 1, 10) ~= "weapon_zs_" then return nil end

	local prefix = swep.TranslationPrefix or "wpn"

	local function hasDesc(id)
		return id and translate.Exists(prefix .. "_desc_" .. id)
	end

	local ownid = (string.gsub(swep.ClassName, "^weapon_zs_", ""))
	if hasDesc(ownid) then return ownid end

	local seen = { [ownid] = true }
	local base = swep.Base
	local guard = 0

	while base and guard < 16 do
		guard = guard + 1

		local basetab = (type(base) == "string") and weapons.GetStored(base) or base
		if not basetab then break end

		local baseclass = basetab.ClassName or (type(base) == "string" and base or nil)
		if not baseclass then break end
		if seen[baseclass] then break end
		seen[baseclass] = true

		if string.sub(baseclass, 1, 10) == "weapon_zs_" then
			local baseid = (string.gsub(baseclass, "^weapon_zs_", ""))
			if hasDesc(baseid) then return baseid end
		end

		base = basetab.Base
	end

	return ownid
end

function translate.InterpolateConstants(str, localTbl)
	if type(str) ~= "string" then return str end

	return (str:gsub("{{([%w_%.]+)}}", function(key)
		if localTbl then
			local val, ok = localTbl, true
			for part in key:gmatch("[^%.]+") do
				if type(val) ~= "table" then ok = false break end
				val = rawget(val, part)
				if val == nil then ok = false break end
			end
			if ok and type(val) ~= "table" and type(val) ~= "function" then
				return tostring(val)
			end
		end

		local consts = GAMEMODE and GAMEMODE.SkillConstants
		if consts and consts[key] ~= nil then
			return tostring(consts[key])
		end

		local gm = GAMEMODE and rawget(GAMEMODE, key)
		if gm ~= nil then
			return tostring(gm)
		end

		return "{{" .. key .. "}}"
	end))
end

function translate.WeaponDesc(swep)
	if not swep then return nil end

	local id = GetWeaponDescTranslationID(swep)
	if id then
		local prefix = swep.TranslationPrefix or "wpn"
		local key = prefix .. "_desc_" .. id
		if translate.Exists(key) then
			local fmt = translate.Get(key)
			local result
			if swep.DescriptionNumbers and #swep.DescriptionNumbers > 0 then
				result = string.format(fmt, unpack(swep.DescriptionNumbers))
			else
				result = fmt
			end
			return InterpolateBindNames(translate.InterpolateConstants(result, swep))
		end
	end

	return InterpolateBindNames(translate.InterpolateConstants(swep.Description or "", swep))
end

if SERVER then
	-- Set the player's language and synchronously rebuild the translation-table cache.
	-- Previously, this was just `CurrentLanguage = ...`, but after introducing
	-- the CurrentTbl/DefaultTbl cache, LookupTranslation reads an upvalue rather than
	-- Translations[CurrentLanguage] directly. Without RefreshLangCache()
	-- all per-player ClientGet/ClientFormat calls silently fell back to English
	-- (or to the language that was CurrentLanguage at startup).
	local function SetClientLanguage(pl)
		if not IsValid(pl) then return end
		local lang = pl:GetInfo("gmod_language_rep")
		if lang and lang ~= "" and lang ~= CurrentLanguage then
			CurrentLanguage = lang
			RefreshLangCache()
		end
	end

	function translate.ClientGet(pl, ...)
		SetClientLanguage(pl)
		return translate.Get(...)
	end

	function translate.ClientWeaponName(pl, swep)
		if not swep then return nil end
		SetClientLanguage(pl)
		return translate.WeaponName(swep)
	end

	function translate.ClientItemName(pl, id, prefix)
		if not id then return nil end
		prefix = prefix or "trinket"
		SetClientLanguage(pl)
		return translate.ItemName(id, prefix)
	end

	function translate.ClientSkillName(pl, skillid, skill)
		SetClientLanguage(pl)
		return translate.SkillName(skillid, skill)
	end

	function translate.ClientFormat(pl, ...)
		SetClientLanguage(pl)
		return translate.Format(...)
	end

	function translate.ClientClassNameKey(pl, key, grammaticalCase)
		SetClientLanguage(pl)
		return translate.ClassNameKey(key, grammaticalCase)
	end

	function translate.ClientClassNameKeyFor(pl, messageID, key, defaultCase)
		SetClientLanguage(pl)
		return translate.ClassNameKeyFor(messageID, key, defaultCase)
	end

	function PrintTranslatedMessage(printtype, str, ...)
		for _, pl in pairs(player.GetAll()) do
			pl:PrintMessage(printtype, translate.ClientFormat(pl, str, ...))
		end
	end
end

if CLIENT then
	function translate.ClientGet(_, ...)
		return translate.Get(...)
	end
	function translate.ClientFormat(_, ...)
		return translate.Format(...)
	end

	function translate.ClientClassNameKey(_, key, grammaticalCase)
		return translate.ClassNameKey(key, grammaticalCase)
	end

	function translate.ClientClassNameKeyFor(_, messageID, key, defaultCase)
		return translate.ClassNameKeyFor(messageID, key, defaultCase)
	end

	-- Reliable standard bindings in case default_binds is unavailable or empty
	local DefaultBindFallbacks = {
		["+attack"]       = "mouse1",
		["+attack2"]      = "mouse2",
		["+reload"]       = "r",
		["+speed"]        = "shift",
		["+use"]          = "e",
		["+jump"]         = "space",
		["+crouch"]       = "ctrl",
		["+walk"]         = "alt",
		["+menu"]         = "q",
		["+menu_context"] = "c",
	}

	-- Parses GetConVar("default_binds") once and caches per-command defaults.
	-- Format of the cvar string: bind "mouse1" "+attack"; bind "space" "+jump"; ...
	local defaultBindCache = {}
	local function GetEngineDefaultBinding(bind)
		if defaultBindCache[bind] ~= nil then
			return defaultBindCache[bind] or nil
		end

		local cv = GetConVar("default_binds")
		local s = cv and cv:GetString() or ""

		local found = false
		for key, cmd in string.gmatch(s, 'bind%s+"([^"]+)"%s+"([^"]+)"') do
			if cmd == bind then
				found = key
				break
			end
		end

		-- If we didn't find anything in convar, we take it from our table
		if not found then
			found = DefaultBindFallbacks[bind]
		end

		defaultBindCache[bind] = found
		return found or nil
	end

	function translate.GetBindKeyName(bind, semantic)
		local key     = input.LookupBinding(bind)
		local default = GetEngineDefaultBinding(bind)

		local isDefault = key and default and string.lower(key) == string.lower(default)

		if semantic and (not key or not default or isDefault) then
			local semanticID = "keyname_" .. semantic
			if translate.Exists(semanticID) then
				return translate.Get(semanticID)
			end
			return semantic
		end

		if not key then
			return translate.Get("key_not_bound")
		end

		local upper = string.upper(key)
		local id = "keyname_" .. upper
		if translate.Exists(id) then
			return translate.Get(id)
		end

		return upper
	end
end

-- ============================================================
-- Map-specific translations
-- ─────────────────────────────────────────────────────────────
-- Files languages/<lang>/maps/<mapname>.lua store translations for text
-- baked into the .bsp. All versions matching the map's base name are
-- loaded as "candidates"; on InitPostEntity one is chosen — by exact
-- name, or by matching the text signature (signature).
--
-- Keys are registered with a "map_" prefix to avoid conflicts
-- with normal translations. The special field __map_signature is
-- excluded from entries and handled separately.

translate.MapCandidates = {}

-- Case-insensitive fallback index: lang → {lowercase_key → translation}.
-- Exact lookup by "map_"..str remains primary — if the file has two
-- key variants differing only in case, the exact one wins.
translate.MapTextLower = {}

local function ExtractMapBase(name)
    local prev
    repeat
        prev = name
        -- _<letter><digits><rest> $ — covers v12, v6f, v3fix,
        -- a2, a4, b1, e10, r3, v4fix_e10 etc.
        name = name:gsub("_[a-z]%d+[%a%d]*$", "")
    until name == prev
    return name
end
translate.ExtractMapBase = ExtractMapBase

function translate.RegisterMapVersion(lang, version, signature, entries)
    translate.MapCandidates[lang] = translate.MapCandidates[lang] or {}
    translate.MapCandidates[lang][version] = {
        signature = signature or "",
        entries = entries,
    }
end

function translate.ActivateMapVersion(lang, version)
    local cand = translate.MapCandidates[lang] and translate.MapCandidates[lang][version]
    if not cand then return false end

    local tbl = Translations[lang]
    if not tbl then
        tbl = {}
        Translations[lang] = tbl
    end

    local lowidx = translate.MapTextLower[lang]
    if not lowidx then
        lowidx = {}
        translate.MapTextLower[lang] = lowidx
    end

	for k, v in pairs(cand.entries) do
		if type(v) == "string" and v ~= "" then
			tbl["map_" .. k] = v

			local lowerk = string.lower((k:gsub("^%s+", ""):gsub("%s+$", "")))
			if lowidx[lowerk] == nil then
				lowidx[lowerk] = v
			end
		end
	end

	RefreshLangCache()

	return true
end

local function LoadMapCandidates(rootpath)
    local _, langs = file.Find(rootpath .. "/*", "LUA")
    local currentmap = string.lower(game.GetMap())
    local base = ExtractMapBase(currentmap)

    for _, lang in ipairs(langs) do
        local langname = translate.GetLanguageName(lang)
        if langname then
            local files = file.Find(rootpath .. "/" .. lang .. "/maps/*.lua", "LUA")
            for _, filename in ipairs(files) do
                local version = filename:sub(1, -5)
                if ExtractMapBase(version) == base then
                    local relative = rootpath .. "/" .. lang .. "/maps/" .. filename

                    LANGUAGE = {}
                    AddCSLuaFile(relative)
                    include(relative)

                    local sig = LANGUAGE.__map_signature or ""
                    LANGUAGE.__map_signature = nil
                    local entries = LANGUAGE
                    LANGUAGE = nil

                    translate.RegisterMapVersion(lang, version, sig, entries)
                end
            end
        end
    end
end

local function LoadLanguages(path)
    local files, folders = file.Find(path .. "/*", "LUA")

    for _, filename in ipairs(files) do
        if string.EndsWith(filename, ".lua") then
            local relativePath = path .. "/" .. filename
            LANGUAGE = {}
            AddCSLuaFile(relativePath)
            include(relativePath)
            for k, v in pairs(LANGUAGE) do
                translate.AddTranslation(k, v)
            end
            LANGUAGE = nil
        end
    end

    for _, folder in ipairs(folders) do
        -- Do not recurse into maps/: files there are loaded only for
        -- the current map, so two maps don't overwrite each other's keys.
        if folder == "maps" then continue end
        LoadLanguages(path .. "/" .. folder)
    end
end

local langroot = GM.FolderName .. "/gamemode/languages"
LoadLanguages(langroot)
LoadMapCandidates(langroot)

RefreshLangCache()

-- ============================================================
-- Runtime helpers for map translations
-- ============================================================

-- ============================================================
-- Engine localization tokens
-- ------------------------------------------------------------
-- env_message and similar entities reference engine strings like
-- "GAMEOVER_ALLY" or "#HL2_SomeKey". The engine itself resolves
-- these through the language system, but our gamemode sees only
-- the raw token and would print it verbatim.
--
-- We resolve such tokens via language.GetPhrase() so non-English
-- clients see the localized text out of the box. A map translation
-- file can still override them via LANGUAGE.map_<token>.
-- ============================================================

-- Recognizes two forms:
--   * "#SomeKey"    — explicit HL2 engine token
--   * "UPPER_CASE"  — bare token (env_message often uses these)
local function IsEngineLocalizationToken(s)
    if type(s) ~= "string" or s == "" then return false end
    if s:sub(1, 1) == "#" then return true end
    if s:match("^[A-Z][A-Z0-9_]*$") and s:find("_", 1, true) then return true end
    return false
end
translate.IsEngineLocalizationToken = IsEngineLocalizationToken

-- Returns (resolved, key). `resolved` is nil if the engine has no
-- entry for this token. The engine returns the key unchanged when
-- it has no phrase, so we filter that out.
-- Tries every plausible key variant the engine might use for a
-- localization token. Source's phrase storage is case-insensitive
-- in theory but GMod occasionally stores entries with a literal '#'
-- prefix or a fully lowercased name, and closecaption entries may
-- live under either form.
-- Unescape any literal "\n" left over from raw KV strings.
local function UnescapeNewlines(s)
    if type(s) ~= "string" then return s end
    return (s:gsub("\\n", "\n"))
end

-- Returns (resolved, key). Priority order:
--   1. hl2token_<key> from the language files (gamemode override).
--   2. language.GetPhrase() from the engine.
-- `resolved` is nil if neither has anything.
local function ResolveEngineToken(s)
    if type(s) ~= "string" or s == "" then return nil end

    local key = s
    if key:sub(1, 1) == "#" then key = key:sub(2) end

    -- 1. Gamemode-level override. Lets us ship tokens for the
    --    languages the engine doesn't expose to client Lua.
    local trkey = "hl2token_" .. key
    if translate.Exists(trkey) then
        local ov = translate.Get(trkey)
        if type(ov) == "string" and ov ~= "" and ov ~= trkey then
            return UnescapeNewlines(ov), key
        end
    end

    -- 2. Engine lookup. On the client this uses the loaded language,
    --    which for GMod is almost always English.
    local lang = _G["language"]
    if type(lang) ~= "table" or type(lang.GetPhrase) ~= "function" then
        return nil, key
    end

    local candidates = {
        key,
        "#" .. key,
        key:lower(),
        "#" .. key:lower(),
    }

    local tried = {}
    for _, cand in ipairs(candidates) do
        if not tried[cand] then
            tried[cand] = true

            local ok, resolved = pcall(lang.GetPhrase, cand)
            if ok
               and type(resolved) == "string"
               and resolved ~= ""
               and resolved ~= cand
               and resolved ~= key then
                return UnescapeNewlines(resolved), key
            end
        end
    end

    return nil, key
end
translate.ResolveEngineToken = ResolveEngineToken

-- Resolves a map-translation *value* to its final text.
-- Handles three cases, in order:
--   1. Title names from titles.txt (GAMEOVER_ALLY → #HL2_GameOver_Ally).
--   2. Engine token references (#HL2_SomeKey).
--   3. Anything else — returned as-is.
-- Recurse is bounded by `depth` so a malformed payload can never
-- produce an infinite loop.
local function MaybeResolveEngineValue(v, depth)
    if type(v) ~= "string" or v == "" then return v end

    depth = (depth or 0) + 1
    if depth > 6 then return v end

    local trimmed = v:gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed == "" then return v end

    -- 1. Title name → either inline text or #Token reference.
    if translate.GetTitleValue then
        local titleval = translate.GetTitleValue(trimmed)
        if type(titleval) == "string"
           and titleval ~= ""
           and titleval ~= trimmed then
            return MaybeResolveEngineValue(titleval, depth)
        end
    end

    -- 2. Engine token reference.
    if IsEngineLocalizationToken(trimmed) then
        local resolved = ResolveEngineToken(trimmed)
        if resolved then return resolved end
    end

    return v
end

-- Substitutes $key$ or looks up a translation using the entire
-- string as the key. Used in sv_maptext.lua at the KeyValue/
-- AcceptInput stage.
function translate.MapText(str)
    if type(str) ~= "string" or str == "" then return str end

    if SERVER then return str end

    -- Trim: from Source-format output specs like
    -- "msg_hooman,message,Prepare to leave! ,50,-1" the third element
    -- comes out with a trailing space. The engine displays it, but it
    -- doesn't belong in the key.
    str = str:gsub("^%s+", ""):gsub("%s+$", "")
    if str == "" then return str end

    -- 1. $key$ substitution (explicit translation key inside the text).
    if str:find("$", 1, true) then
        local replaced = str:gsub("%$([%a_][%w_]*)%$", function(key)
            local id = "map_" .. key
            if translate.Exists(id) then
                return translate.Get(id)
            end
            return "$" .. key .. "$"
        end)
        if replaced ~= str then return replaced end
    end

    -- 2. Map translation file. A passthrough entry (value == key,
    -- as written by zs_dumpmaptexts for engine tokens) is ignored
    -- so that the engine localization below can still take effect.
    local id = "map_" .. str
    if translate.Exists(id) then
        local v = translate.Get(id)
        if type(v) == "string" and v ~= "" and v ~= str then
            -- The value might itself be an engine token reference
            -- (LANGUAGE.Amphetamine = "GAMEOVER_ALLY"). Resolve it.
            return MaybeResolveEngineValue(v)
        end
    end

    -- 3. Engine localization token (env_message with a raw engine
    -- key, "#token" in game_text, etc.). The engine resolves these
    -- via the client's language; we piggyback on it so non-English
    -- clients get the localized text.
    if IsEngineLocalizationToken(str) then
        local resolved = ResolveEngineToken(str)
        if resolved then return resolved end
    end

    return str
end

function translate.GetMap(key, ...)
    local id = "map_" .. key
    if select("#", ...) > 0 then
        return translate.Format(id, ...)
    end
    return translate.Get(id)
end

function translate.ExistsMap(key)
    return translate.Exists("map_" .. key)
end

--------------------------------------------------------------------
-- Attribute-based descriptions
--------------------------------------------------------------------

local function InterpolateSkillConstants(str)
	if type(str) ~= "string" then return str end
	local consts = GAMEMODE and GAMEMODE.SkillConstants
	if not consts then return str end

	return (str:gsub("{{([%w_]+)}}", function(key)
		local v = consts[key]
		if v == nil then return "{{" .. key .. "}}" end
		return tostring(v)
	end))
end

function translate.Attribute(id, value)
	local tmpl = translate.Get(id)
	if tmpl == "@" .. id .. "@" then
		return id .. ": " .. tostring(value)
	end

	tmpl = InterpolateSkillConstants(tmpl)

	local specifiers = 0
	for _ in tmpl:gmatch("%%[+%-%d%.]*[gdsx]") do
		specifiers = specifiers + 1
	end

	local arg = type(value) == "number" and value or tostring(value)

	local ok, result
	if specifiers == 0 then
		ok, result = pcall(string.format, tmpl)
	else
		ok, result = pcall(string.format, tmpl, arg)
	end

	if not ok then
		MsgN("[translate] Bad attribute template '", id, "': ", result)
		return tmpl
	end
	return result
end

function translate.ComposeAttributes(entries, moodPrefix)
	if type(entries) ~= "table" then return entries end
	local parts = {}
	for _, entry in ipairs(entries) do
		local id, value, mood = entry[1], entry[2], entry[3]
		local line = translate.Attribute(id, value)
		if mood and moodPrefix then
			line = (moodPrefix(mood) or "") .. line
		end
		parts[#parts + 1] = line
	end
	return table.concat(parts, "\n")
end

-- Skill display name: "skill_name_<id>" if translated, otherwise skill.Name (the raw
-- English text from registry.lua/GM:AddTrinket). Mirrors translate.SkillDescription below.
function translate.SkillName(skillid, skill)
	if skillid == -1 then
		return translate.Get("skill_remort_name")
	end

	if skillid then
		local key = "skill_name_" .. skillid
		if translate.Exists(key) then
			return translate.Get(key)
		end
	end

	return skill and skill.Name or ""
end

function translate.SkillDescription(skillid, skill)
	if skillid == -1 then
		local sp = (GAMEMODE and GAMEMODE.RemortSkillPoints) or 1
		return translate.Format("skill_remort_desc", sp)
	end

	if skillid then
		local key = "skill_desc_" .. skillid
		if translate.Exists(key) then
			return InterpolateSkillConstants(translate.Get(key))
		end
	end

	if skill and skill.DescriptionAttributes then
		local moodPrefix = function(mood)
			if mood == "good" then return "^2" end
			if mood == "bad"  then return "^1" end
		end
		return translate.ComposeAttributes(skill.DescriptionAttributes, moodPrefix)
	end

	return skill and skill.Description or ""
end

function translate.ItemDescription(data, prefix)
	if not data then return "" end
	prefix = prefix or "item"

	if data.TranslationID then
		local key = prefix .. "_desc_" .. data.TranslationID
		if translate.Exists(key) then
			local fmt = translate.Get(key)
			local result
			if data.DescriptionNumbers and #data.DescriptionNumbers > 0 then
				result = string.format(fmt, unpack(data.DescriptionNumbers))
			else
				result = fmt
			end
			return InterpolateBindNames(result)
		end
	end

	if data.DescriptionAttributes then
		return translate.ComposeAttributes(data.DescriptionAttributes)
	end

	return data.Description or ""
end

local meta = FindMetaTable("Player")
if not meta then return end

function meta:PrintTranslatedMessage(hudprinttype, translateid, ...)
	if ... ~= nil then
		self:PrintMessage(hudprinttype, translate.ClientFormat(self, translateid, ...))
	else
		self:PrintMessage(hudprinttype, translate.ClientGet(self, translateid))
	end
end
