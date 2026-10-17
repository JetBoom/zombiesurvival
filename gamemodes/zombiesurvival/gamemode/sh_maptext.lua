--[[
    Auto-translation of map text + dumper.

    Text sources:
      1. Entity KeyValues (game_text.message, env_message.message, ...)
      2. Save table — m_On* fields hold outputs in
         "target,input,param,delay,times" format. Pull param from there.
      3. Custom storage: self["on..."] (used when the entity
         itself calls AddOnOutput from KeyValue).
      4. Runtime capture: catch everything the engine passes to
         AcceptInput during play (opening doors, entering zones, etc.).
]]

-- ─────────────────────────────────────────────────────────────
-- Sets of keys/inputs
-- ─────────────────────────────────────────────────────────────

local KEYVALUE_KEYS = {
    point_worldhint       = {"hint"},
    game_text             = {"message"},
    game_text_tf          = {"message"},
    env_message           = {"message"},
    env_instructor_hint   = {"hint_caption"},
    point_servercommand   = {"command"},
    point_clientcommand   = {"command"},
	point_broadcastclientcommand = {"command"},
	lua_run               = {"code"},
}
do
    local custom = {}
    for i = 1, 99 do
        custom[#custom + 1] = string.format("string%02d", i)
    end
    KEYVALUE_KEYS.info_custommessage = custom
end

-- Input names whose parameter is visible text.
local TEXT_INPUT_NAMES = {
    message                = true,
    sethint                = true,
    sethumanhudmessage     = true,
    setsurvivorhudmessage  = true,
    setundeadhudmessage    = true,
    setzombiehudmessage    = true,
    -- game_text
    display                = true,
    settext                = true,
    addtext                = true,
    -- env_message
    showmessage            = true,
    setmessage             = true,
}
do
    for i = 1, 99 do
        TEXT_INPUT_NAMES[string.format("setstring%02d", i)] = true
    end
end

-- ─────────────────────────────────────────────────────────────
-- Fields in the entity's Lua table that usually hold visible text.
-- Case-insensitive. Walk GetTable() and collect any string
-- with such a field name — without waiting for the player to
-- trigger it in-game.
-- ─────────────────────────────────────────────────────────────

local LUA_TEXT_FIELDS = {
    hint          = true,
    hintcaption   = true,
    hint_caption  = true,

    message       = true,
    storedmessage = true,
    text          = true,
    caption       = true,
    displaymessage = true,
    worldhint     = true,
}
do
    -- string01..string99 (for info_custommessage and similar).
    -- Support both zero-padded and unpadded format.
    for i = 1, 99 do
        LUA_TEXT_FIELDS[string.format("string%02d", i)] = true
        LUA_TEXT_FIELDS[string.format("string%d",  i)] = true
    end
end
-- Table fields whose values are visible text.
-- info_custommessage: self.PartStrings[1..99] = "text"
local LUA_TEXT_TABLE_FIELDS = {
    partstrings = true,
    strings     = true,
    messages    = true,
    texts       = true,
    parts       = true,
}

local function ExtractCommandText(value)
    if type(value) ~= "string" then return nil end
    local lower = value:lower()

    for _, cmdname in ipairs({"chatprint", "say", "hl2mp_chat"}) do
        local start, finish = lower:find(cmdname, 1, true)
        while start do
            -- Command must be a separate word
            local before = value:sub(start - 1, start - 1)
            if start == 1 or before == " " or before == "\t" then
                local rest = value:sub(finish + 1)

                -- Quoted variant: say "text"
                local t = rest:match('^%s*"([^"]*)"') or rest:match("^%s*'([^']*)'")
                if t then return t end

                -- Unquoted variant: say text until end of line
                local bare = rest:match("^%s+(.+)")
                if bare and bare ~= "" then return bare end
            end

            start, finish = lower:find(cmdname, finish + 1, true)
        end
    end

    return nil
end

local function ExtractLuaRunText(code)
    if type(code) ~= "string" then return nil end

    -- Variant 1: RunConsoleCommand("say", "text")
    local text = code:match("RunConsoleCommand%s*%(%s*['\"]say['\"]%s*,%s*['\"]([^'\"]*)['\"]")
    if text then return text end

    -- Variant 2: chat.AddText(...)
    local inner = code:match("chat%.AddText%s*%((.*)%)%s*$")
    if inner then
        local parts = {}
        for s in inner:gmatch("['\"]([^'\"]*)['\"]") do
            parts[#parts + 1] = s
        end
        if #parts > 0 then return table.concat(parts, "") end
    end

    return nil
end

-- ─────────────────────────────────────────────────────────────
-- Scanners
-- ─────────────────────────────────────────────────────────────
local ParseOutputSpec  -- forward-declare

local function ScanKeyValues(ent, class, add)
    -- zs_gametext / zs_envmessage are our replacements for the original
    -- classes; for the report source we show the original class.
    local srcClass = class
    if class == "zs_gametext" then srcClass = "game_text"
    elseif class == "zs_envmessage" then srcClass = "env_message" end

    if class == "zs_gametext" or class == "zs_envmessage" then
        local msg = ent.StoredMessage
        if type(msg) ~= "string" or msg == "" then
            if ent.GetTable then
                local ok, tbl = pcall(ent.GetTable, ent)
                if ok and type(tbl) == "table" then
                    msg = tbl.StoredMessage
                end
            end
        end
        if type(msg) == "string" and msg ~= "" then
            add(msg, srcClass)
        end
        return
    end

    if not ent.GetKeyValues then return end
    local ok, kvs = pcall(ent.GetKeyValues, ent)
    if not ok or type(kvs) ~= "table" then return end

    -- Generic scan of On*/m_On* with \x1B — for logic_auto and the like.
    for k, v in pairs(kvs) do
        if type(k) == "string" and type(v) == "string" and v ~= "" then
            local kl = k:lower()
            if (kl:sub(1, 4) == "m_on" or kl:sub(1, 2) == "on")
               and v:find("\27", 1, true) then
                ParseOutputSpec(v, add, srcClass)
            end
        end
    end

    local keys = KEYVALUE_KEYS[class]
    if not keys then return end

    for _, key in ipairs(keys) do
        local raw = kvs[key]
        if type(raw) == "string" and raw ~= "" then
            if class == "lua_run" then
                local t = ExtractLuaRunText(raw)
                if t then add(t, "lua_run") end
            elseif class == "point_clientcommand"
                or class == "point_broadcastclientcommand"
                or class == "point_servercommand" then
                local t = ExtractCommandText(raw)
                if t then add(t, class) end
            else
                add(raw, srcClass)
            end
        end
    end
end

local function ScanDTStrings(ent, class, add)
    if class == "point_worldhint" then
        if ent.GetTranslated and ent:GetTranslated() then return end

        if ent.GetDTString then
            local ok, hint = pcall(ent.GetDTString, ent, 0)
            if ok and type(hint) == "string" and hint ~= "" then
                add(hint, "point_worldhint")
            end
        end
    end
end

local function ScanLuaFields(ent, class, add)
    if not ent.GetTable then return end

    local srcClass = class
    if class == "zs_gametext" then srcClass = "game_text"
    elseif class == "zs_envmessage" then srcClass = "env_message" end

    local ok, tbl = pcall(ent.GetTable, ent)
    if not ok or type(tbl) ~= "table" then return end

    for k, v in pairs(tbl) do
        if type(k) == "string" then
            local kl = k:lower()

            if type(v) == "string" and v ~= "" then
                if LUA_TEXT_FIELDS[kl] then
                    add(v, srcClass)
                end
            elseif type(v) == "table" and LUA_TEXT_TABLE_FIELDS[kl] then
                for _, part in pairs(v) do
                    if type(part) == "string" and part ~= "" then
                        add(part, srcClass)
                    end
                end
            end
        end
    end
end

-- Parses a single output spec "target,param,...,input".
-- source — the class of the entity that owns the output (for the dump report).
ParseOutputSpec = function(spec, add, source)
    if type(spec) ~= "string" or spec == "" then return end
    local sep = spec:find("\x1B", 1, true) and "\x1B" or ","
    local parts = string.Explode(sep, spec)
    if #parts < 3 then return end

    local target = parts[1]
    local input  = (parts[2] or ""):lower()
    local param  = parts[3]
    if not param or param == "" then return end

    -- Any output with input = "message" (any case) is a visible
    -- message. Group by target: private_message, msg_hooman,
    -- zombie_message etc. The class of the entity sender doesn't
    -- matter here.
    if input == "message" and target and target ~= "" then
        source = target:lower()
    end

    if input == "command" then
        local t = ExtractCommandText(param)
        if t then add(t, source or "point_servercommand") end
        return
    end

    if input == "runcode" then
        local t = ExtractLuaRunText(param)
        if t then add(t, "lua_run") end
        return
    end

    if TEXT_INPUT_NAMES[input] then
        add(param, source)
    end
end

local function ScanSaveTable(ent, class, add)
    if not ent.GetSaveTable then return end

    local ok, st = pcall(ent.GetSaveTable, ent)
    if not ok or type(st) ~= "table" then return end

    for k, v in pairs(st) do
        if type(v) == "string" and v ~= "" then
            local isOutput = v:find("\27", 1, true) ~= nil

            if not isOutput and type(k) == "string" then
                local kl = k:lower()
                if kl:sub(1, 4) == "m_on" or kl:sub(1, 2) == "on" then
                    isOutput = true
                end
            end

            if isOutput then
                ParseOutputSpec(v, add, class)
            end
        end
    end
end

local function ScanCustomOutputs(ent, class, add)
    if not ent.GetTable then return end

    local ok, tbl = pcall(ent.GetTable, ent)
    if not ok or type(tbl) ~= "table" then return end

    for k, v in pairs(tbl) do
        if type(k) == "string" and k:sub(1, 2):lower() == "on" and type(v) == "table" then
            for _, entry in ipairs(v) do
                if type(entry) == "table" then
                    local input = (entry.input or entry.Input or ""):lower()
                    local param = entry.args or entry.Param or entry.param
                    if not param or param == "" then
                        -- skip
                    elseif input == "command" then
                        local t = ExtractCommandText(param)
                        if t then add(t, class or "point_servercommand") end
                    elseif input == "runcode" then
                        local t = ExtractLuaRunText(param)
                        if t then add(t, "lua_run") end
                    elseif TEXT_INPUT_NAMES[input] then
                        add(param, class)
                    end
                end
            end
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Runtime capture
-- ─────────────────────────────────────────────────────────────

if SERVER then
    translate.CapturedRuntimeTexts = translate.CapturedRuntimeTexts or {}
    translate.KVTextsByMap = translate.KVTextsByMap or {}

    local function AddKVText(str, source)
        if type(str) ~= "string" or str == "" then return end
        local mapname = game.GetMap()
        local cache = translate.KVTextsByMap[mapname]
        if not cache then
            cache = {}
            translate.KVTextsByMap[mapname] = cache
        end
        -- source либо true (неизвестен), либо строка (класс энтити).
        -- Первая запись с известным source побеждает.
        if cache[str] == nil then
            cache[str] = source or true
        elseif source and cache[str] == true then
            cache[str] = source
        end
    end

    local function ZS_WrapScriptedEnt(tbl)
        if type(tbl) ~= "table" or tbl.__zs_textwrapped then return end
        tbl.__zs_textwrapped = true

        local oldKV = tbl.KeyValue
        if oldKV then
            tbl.KeyValue = function(self, key, value)
                if type(key) == "string" and type(value) == "string" and value ~= "" then
                    local kl = key:lower()

                    if LUA_TEXT_FIELDS[kl] or kl:match("^string%d+$") then
                        AddKVText(value)

                    elseif kl:sub(1, 2) == "on" and value:find("\27", 1, true) then
                        local parts = string.Explode("\27", value)
                        if #parts >= 3 then
                            local target = parts[1]
                            local input  = (parts[2] or ""):lower():gsub("%s+", "")
                            local param  = parts[3]

                            local src = self:GetClass()
                            if input == "message" and target and target ~= "" then
                                src = target:lower()
                            end

                            if input == "command" then
                                local t = param:match('chatprint%s*"([^"]*)"')
                                       or param:match("chatprint%s*'([^']*)'")
                                       or param:match('say%s*"([^"]*)"')
                                       or param:match("say%s*'([^']*)'")
                                       or param:match('hl2mp_chat%s*"([^"]*)"')
                                       or param:match("hl2mp_chat%s*'([^']*)'")
                                       or param:match("^chatprint%s+(.+)")
                                       or param:match("^say%s+(.+)")
                                       or param:match("^hl2mp_chat%s+(.+)")
                                if t and t ~= "" then
                                    AddKVText(t, src)
                                end
                            elseif input == "runcode" then
                                local t = ExtractLuaRunText(param)
                                if t then AddKVText(t, src) end
                            elseif TEXT_INPUT_NAMES[input] then
                                AddKVText(param, src)
                            end
                        end
                    end
                end
                return oldKV(self, key, value)
            end
        end

        local oldAI = tbl.AcceptInput
        if oldAI then
			tbl.AcceptInput = function(self, name, activator, caller, data, ...)
				if type(data) == "string" and data ~= "" then
					if TEXT_INPUT_NAMES[(name or ""):lower()] then
						pcall(AddKVText, data, self:GetClass())
					end
				end
				return oldAI(self, name, activator, caller, data, ...)
			end
        end
    end

    local list = scripted_ents.GetList()
    if type(list) == "table" then
        for _, entry in pairs(list) do
            if entry.tbl then
                ZS_WrapScriptedEnt(entry.tbl)
            end
        end
    end

    local oldRegister = scripted_ents.Register
    function scripted_ents.Register(tbl, name)
        ZS_WrapScriptedEnt(tbl)
        return oldRegister(tbl, name)
    end

    local function GetMapCache()
        local mapname = game.GetMap()
        local cache = translate.CapturedRuntimeTexts[mapname]
        if not cache then
            cache = {}
            translate.CapturedRuntimeTexts[mapname] = cache
        end
        return cache, mapname
    end

    hook.Add("EntityKeyValue", "ZS_CaptureMapOutputs", function(ent, key, value)
        if type(key) ~= "string" or type(value) ~= "string" then return end
        if value == "" then return end

        local kl = key:lower()
        local class = ent:GetClass()

        -- ─── Direct text keys (game_text.message, env_message.message, ...) ───
        -- On many maps GetKeyValues() returns an empty table, and
        -- message can't be retrieved from a live entity. We catch it
        -- here while the engine passes KVs in batches while loading BSP.
        local direct = KEYVALUE_KEYS[class]
        if direct then
            for _, want in ipairs(direct) do
                if kl == want:lower() then
                    if class == "lua_run" then
                        local t = ExtractLuaRunText(value)
                        if t then AddKVText(t, "lua_run") end
                    elseif class == "point_clientcommand"
                        or class == "point_broadcastclientcommand"
                        or class == "point_servercommand" then
                        local t = ExtractCommandText(value)
                        if t then AddKVText(t, class) end
                    else
                        AddKVText(value, class)
                    end
                    return
                end
            end
        end

        -- ─── Output specs (m_OnXXX / OnXXX with \x1B) ───
        if not (kl:sub(1, 4) == "m_on" or kl:sub(1, 2) == "on") then return end

        local target, input, param

        if value:find("\27", 1, true) then
            local parts = string.Explode("\27", value)
            if #parts >= 3 then
                target = parts[1]
                input  = parts[2]
                param  = parts[3]
            end
        elseif value:find(",", 1, true) then
            local _, i, rest = value:match("^([^,]*),([^,]*),(.*)$")
            if i then
                target = value:match("^([^,]*),")
                input  = i
                local inner = rest:match("^(.-),%s*[%d%.]+%s*,%s*%-?[%d%.]+%s*$")
                param  = inner or rest
            end
        end

        if not param or param == "" then return end

        input = (input or ""):lower():gsub("%s+", "")

        local src = ent:GetClass()
        if input == "message" and target and target ~= "" then
            src = target:lower()
        end

        if input == "command" then
            local t = param:match('chatprint%s*"([^"]*)"')
                   or param:match("chatprint%s*'([^']*)'")
                   or param:match('say%s*"([^"]*)"')
                   or param:match("say%s*'([^']*)'")
                   or param:match('hl2mp_chat%s*"([^"]*)"')
                   or param:match("hl2mp_chat%s*'([^']*)'")
                   or param:match("^chatprint%s+(.+)")
                   or param:match("^say%s+(.+)")
                   or param:match("^hl2mp_chat%s+(.+)")
            if t and t ~= "" then
                AddKVText(t, src)
                translate.CaptureRuntimeText(t, src)
            end
            return
        end

        if TEXT_INPUT_NAMES[input] then
            AddKVText(param, src)
            translate.CaptureRuntimeText(param, src)
        end
    end)

	hook.Add("ShutDown", "ZS_FlushRuntimeTexts", translate.FlushRuntimeTexts)

	function translate.CaptureRuntimeText(str, source)
		if type(str) ~= "string" or str == "" then return end
		if #str <= 4 and tonumber(str) then return end

		local cache = GetMapCache()
		if cache[str] then return end
		cache[str] = source or true
	end

	function translate.FlushRuntimeTexts()
		local mapname = game.GetMap()
		local cache = translate.CapturedRuntimeTexts[mapname]
		if not cache then return end

		local lines = {}
		for str in pairs(cache) do
			lines[#lines + 1] = str
		end
		if #lines == 0 then return end
		table.sort(lines)

		file.CreateDir("zs_maptexts")
		file.Write("zs_maptexts/" .. mapname .. "_runtime.txt", table.concat(lines, "\n") .. "\n")
	end

    do
        local oldMapText = translate.MapText
        function translate.MapText(str)
            translate.CaptureRuntimeText(str)
            return oldMapText(str)
        end
    end

	local meta = FindMetaTable("Entity")
	local oldMetaAccept = meta.AcceptInput
	function meta:AcceptInput(name, activator, caller, data, ...)
		if type(data) == "string" and data ~= ""
			and TEXT_INPUT_NAMES[string.lower(name or "")] then
			pcall(translate.CaptureRuntimeText, data, self:GetClass())
		end
		return oldMetaAccept(self, name, activator, caller, data, ...)
	end
end

-- ─────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────

function translate.CollectMapTexts(includeruntime)
    -- Returns: ordered (array of texts) and sources (map text→source).
    local seen    = {}
    local sources = {}
    local ordered = {}

    local function add(t, source)
        if type(t) ~= "string" then return end
        t = t:gsub("^%s+", ""):gsub("%s+$", "")
        if t == "" or seen[t] then return end
        seen[t] = true
        ordered[#ordered + 1] = t
        if source and source ~= "" then
            sources[t] = source
        end
    end

    for _, ent in ipairs(ents.GetAll()) do
        if ent:IsValid() then
            local class = ent:GetClass()
            ScanKeyValues(ent, class, add)
            ScanDTStrings(ent, class, add)
            ScanLuaFields(ent, class, add)
            ScanSaveTable(ent, class, add)
            ScanCustomOutputs(ent, class, add)
        end
    end

    if SERVER and translate.KVTextsByMap then
        local cache = translate.KVTextsByMap[game.GetMap()]
        if cache then
            for t, src in pairs(cache) do
                add(t, type(src) == "string" and src or nil)
            end
        end
    end

    if includeruntime and SERVER and translate.CapturedRuntimeTexts then
        local cache = translate.CapturedRuntimeTexts[game.GetMap()]
        if cache then
            for t, src in pairs(cache) do
                add(t, type(src) == "string" and src or nil)
            end
        end
    end

    table.sort(ordered, function(a, b)
        local la, lb = string.lower(a), string.lower(b)
        if la ~= lb then return la < lb end
        return a < b
    end)

    return ordered, sources
end

function translate.ComputeMapSignature(list)
    if #list == 0 then return "" end
    return util.MD5(table.concat(list, "\n"))
end

-- ─────────────────────────────────────────────────────────────
-- Activating translations
-- ─────────────────────────────────────────────────────────────

local cv_maptext_debug
if SERVER then
    cv_maptext_debug = CreateConVar("zs_maptext_debug", "0", FCVAR_ARCHIVE, "Print information about the map translation selection to the server console")
end

local function MapTextLog(fmt, ...)
    if cv_maptext_debug and cv_maptext_debug:GetBool() then
        MsgN(string.format(fmt, ...))
    end
end

hook.Add("InitPostEntity", "ZS_ActivateMapTranslations", function()
    local texts = translate.CollectMapTexts(false)
    local sig   = translate.ComputeMapSignature(texts)
    local currentmap = string.lower(game.GetMap())

    for lang, versions in pairs(translate.MapCandidates) do
        if versions[currentmap] then
            translate.ActivateMapVersion(lang, currentmap)
            MapTextLog("[zs] maptext [%s]: exact %s", lang, currentmap)
        else
            local sorted = {}
            for v in pairs(versions) do sorted[#sorted + 1] = v end
            table.sort(sorted, function(a, b) return a > b end)

            local used
            for _, v in ipairs(sorted) do
                local cand = versions[v]
                if cand.signature ~= "" and cand.signature == sig then
                    translate.ActivateMapVersion(lang, v)
                    used = v
                    break
                end
            end

            if used then
                MapTextLog("[zs] maptext [%s]: %s not found, using %s (signature match)", lang, currentmap, used)
            else
                MapTextLog("[zs] maptext [%s]: no matching file for %s (sig %s)", lang, currentmap, sig)
            end
        end
    end

    GAMEMODE.MapTextSignature = sig
end)

if SERVER then
    local oldChatPrint = concommand.GetTable()["chatprint"]
    if oldChatPrint then
        concommand.Add("chatprint", function(ply, cmd, args)
            for i, a in ipairs(args) do
                args[i] = translate.MapText(a)
            end
            return oldChatPrint(ply, cmd, args)
        end)
    end
end

-- ─────────────────────────────────────────────────────────────
-- zs_dumpmaptexts
-- ─────────────────────────────────────────────────────────────

if SERVER then
    local function EscapeLuaString(s)
        return (s
            :gsub("\\", "\\\\")
            :gsub('"',  '\\"')
            :gsub("\r", "\\r")
            :gsub("\n", "\\n"))
    end

    local function IsLuaIdentifier(s)
        return type(s) == "string"
            and s:match("^[A-Za-z_][A-Za-z0-9_]*$") ~= nil
    end

    -- Writes one line LANGUAGE.<key> = "<value>".
    -- If key is not a valid Lua identifier (contains &, !, -, space,
    -- Cyrillic, etc.) LANGUAGE["<key>"] = "<value>" is used.
    local function EmitLine(out, key, value)
        local ve = EscapeLuaString(value)
        if IsLuaIdentifier(key) then
            out[#out + 1] = string.format('LANGUAGE.%s = "%s"', key, ve)
        else
            out[#out + 1] = string.format('LANGUAGE["%s"] = "%s"',
                EscapeLuaString(key), ve)
        end
    end

    concommand.Add("zs_dumpmaptexts", function(ply, cmd, args)
        if IsValid(ply) and not ply:IsSuperAdmin() then return end

        local texts, sources = translate.CollectMapTexts(true)
        local sig = translate.ComputeMapSignature(translate.CollectMapTexts(false))
        local mapname = game.GetMap()

        -- ZE weapons (exist only on ze_ maps).
        local zeRecords, zeNames
        if translate.GetZEDumpRecords then
            zeRecords, zeNames = translate.GetZEDumpRecords()
        end
        local hasZE    = zeNames and #zeNames > 0
        local hasTexts = #texts > 0

        if not hasTexts and not hasZE then
            local msg = string.format(
                "[zs] Map text dump: nothing found on %s (sig %s), file not written",
                mapname, sig)
            print(msg)
            if IsValid(ply) then
                ply:PrintMessage(HUD_PRINTCONSOLE, msg)
            end
            return
        end

        local dir = "zs_maptexts"
        file.CreateDir(dir)

        -- .lua.txt — GMod forbids file.Write for .lua, but this is a normal
        -- text fragment the user copies into the actual map translation file.
        local filename = dir .. "/" .. mapname .. ".lua.txt"

        -- ─── Header instruction ───
        -- LANGUAGE = {} and __map_signature are NOT written: the user inserts
        -- only the lines themselves into the existing map translation file.
        local out = {}
	    out[#out + 1] = "LANGUAGE = {}"
		out[#out + 1] = ""
        out[#out + 1] = "LANGUAGE.__map_signature = \"" .. sig .. "\""
		out[#out + 1] = ""
        out[#out + 1] = "-- ============================================================"
        out[#out + 1] = "-- Map text dump for: " .. mapname
        out[#out + 1] = "--"
        out[#out + 1] = "-- Copy the lines below into the map translation file:"
        out[#out + 1] = "--   gamemode/languages/<lang>/maps/" .. mapname .. ".lua"
        out[#out + 1] = "--"
        out[#out + 1] = "-- A signature is required so that the engine can recognize the translation"
        out[#out + 1] = "-- even when the maps's name in the game doesn't match the file name."
        out[#out + 1] = "-- ============================================================"

        -- ─── Sections with map texts ───
        if hasTexts then
            local SOURCE_ORDER = {
                "game_text",
                "game_text_tf",
                "env_message",
                "env_instructor_hint",
                "point_zsmessage",
                "point_worldhint",
                "info_custommessage",
                "private_message",
                "human_message",
                "zombie_message",
                "logic_waves",
                "point_servercommand",
                "point_clientcommand",
                "point_broadcastclientcommand",
                "lua_run",
            }
            local SOURCE_DESC = {
                game_text                    = "game_text — on-screen message entity",
                logic_waves                  = "logic_waves — wave logic entity whose outputs drive on-screen messages",
                game_text_tf                 = "game_text_tf — TF-style on-screen message entity",
                env_message                  = "env_message — centered message entity (may play a sound)",
                env_instructor_hint          = "env_instructor_hint — instructor hint caption",
                trigger_multiple             = "trigger_multiple — touch-triggered message emitter",
                trigger_once                 = "trigger_once — single-fire touch trigger",
                logic_relay                  = "logic_relay — relay for chained outputs",
                logic_auto                   = "logic_auto — fires outputs on map spawn",
                point_zsmessage              = "point_zsmessage — Zombie Survival message entity",
                point_worldhint              = "point_worldhint — world-space hint",
                info_custommessage           = "info_custommessage — multi-part custom message entity",
                private_message              = "private_message — message shown only to the activating player",
                human_message                = "human_message — message shown to all human players",
                zombie_message               = "zombie_message — message shown to all zombies",
                point_servercommand          = "point_servercommand — server-side console command (say / chatprint)",
                point_clientcommand          = "point_clientcommand — console command sent to a single client",
                point_broadcastclientcommand = "point_broadcastclientcommand — console command sent to all clients",
                lua_run                      = "lua_run — Lua code containing say / chatprint / chat.AddText",
            }

            local groups  = {}
            local unknown = {}
            for _, text in ipairs(texts) do
                local source = sources[text]
                if source then
                    groups[source] = groups[source] or {}
                    groups[source][#groups[source] + 1] = text
                else
                    unknown[#unknown + 1] = text
                end
            end

            local function EmitText(text)
                -- ActivateMapVersion ADDS the "map_" prefix to every key
                -- itself, so the file stores the key WITHOUT a prefix.
                -- Otherwise you get map_map_<text> and translate.MapText()
                -- finds nothing.
                local explicit = text:match("^%$([%a_][%w_]*)%$$")

                if explicit then
                    EmitLine(out, explicit, explicit)
                    return
                end

                -- Engine localization token (env_message with a raw engine
                -- key like "GAMEOVER_ALLY" or "#HL2_SomeKey"). The engine
                -- resolves the token itself, but we document the resolved
                -- phrase in a comment so translators know what to translate.
                -- The emitted line is a passthrough by default:
                -- translate.MapText ignores passthrough entries and lets
                -- the engine resolve them.
                if translate.IsEngineLocalizationToken and translate.IsEngineLocalizationToken(text) then
                    local resolved, key = translate.ResolveEngineToken(text)

                    out[#out + 1] = "-- Engine localization token: " .. (key or text)
                    if resolved then
                        out[#out + 1] = "-- The engine resolves this to (English default):"
                        out[#out + 1] = "--   \"" .. EscapeLuaString(resolved) .. "\""
                        out[#out + 1] = "-- Replace the value below with your translation to override it."
                    else
                        out[#out + 1] = "-- The engine has no phrase for this key (client sees the raw token)."
                    end

                    EmitLine(out, text, text)   -- passthrough
                    return
                end

                EmitLine(out, text, text)
            end

            local function EmitGroup(source, list, header)
                if not list or #list == 0 then return end
                out[#out + 1] = ""
                out[#out + 1] = "-- ============================================================"
                out[#out + 1] = "-- " .. (header or SOURCE_DESC[source] or ("Source: " .. source))
                out[#out + 1] = "-- ============================================================"
                out[#out + 1] = ""
                for _, text in ipairs(list) do
                    EmitText(text)
                    out[#out + 1] = ""
                end
            end

            for _, source in ipairs(SOURCE_ORDER) do
                local list = groups[source]
                if list then
                    EmitGroup(source, list)
                    groups[source] = nil
                end
            end

            local leftovers = {}
            for source in pairs(groups) do leftovers[#leftovers + 1] = source end
            table.sort(leftovers)
            for _, source in ipairs(leftovers) do
                EmitGroup(source, groups[source])
            end

            EmitGroup(nil, unknown, "unknown source — captured at runtime")
        end

        -- Section with ZE weapon names
        if hasZE then
            out[#out + 1] = ""
            out[#out + 1] = "-- ============================================================"
            out[#out + 1] = "-- ZE weapon names (weapon_map_base and its children)"
            out[#out + 1] = "-- These are displayed in the notification when selecting a weapon on the map."
            out[#out + 1] = "-- ============================================================"
            out[#out + 1] = ""

            for _, name in ipairs(zeNames) do
                local rec = zeRecords[name]

                -- Triggers are informational comments that help
                -- understand which event causes the map to show this
                -- name.
                if rec and rec.msgs then
                    for _, m in ipairs(rec.msgs) do
                        out[#out + 1] = "-- triggers: " .. EscapeLuaString(m)
                    end
                end

                EmitLine(out, "ze_weapon_name_" .. name:lower(), name)
                out[#out + 1] = ""
            end
        end

        file.Write(filename, table.concat(out, "\n"))

        local total = #texts + (hasZE and #zeNames or 0)
        local msg = string.format(
            "[zs] Map text dump: data/%s (%d entries, sig %s)",
            filename, total, sig)
        print(msg)
        if IsValid(ply) then
            ply:PrintMessage(HUD_PRINTCONSOLE, msg)
        end
    end)
end

if SERVER then
    concommand.Add("zs_clearmaptextcache", function(ply)
        if IsValid(ply) and not ply:IsSuperAdmin() then return end
        translate.CapturedRuntimeTexts[game.GetMap()] = {}
        local msg = "[zs] Map text runtime cache cleared for " .. game.GetMap()
        print(msg)
        if IsValid(ply) then ply:PrintMessage(HUD_PRINTCONSOLE, msg) end
    end)

    concommand.Add("zs_findtext", function(ply, cmd, args)
        if IsValid(ply) and not ply:IsSuperAdmin() then return end

        local filter = table.concat(args, " ")
        if filter == "" then filter = nil end
        local filterlower = filter and filter:lower() or nil

        MsgN("=== zs_findtext " ..
            (filter and ("filter=\"" .. filter .. "\"") or "(no filter)") .. " ===")

        local function matches(v)
            if not filterlower then return true end
            return v:lower():find(filterlower, 1, true) ~= nil
        end

        local n, scannedKV, scannedST = 0, 0, 0

        for _, e in ipairs(ents.GetAll()) do
            if not e:IsValid() then continue end

            if e.GetKeyValues then
                local ok, kv = pcall(e.GetKeyValues, e)
                if ok and type(kv) == "table" then
                    scannedKV = scannedKV + 1
                    for k, v in pairs(kv) do
                        if type(v) == "string" and v ~= "" and matches(v) then
                            n = n + 1
                            MsgN(("[KV] %s name=%q key=%q val=%q"):format(
                                e:GetClass(), e:GetName(), tostring(k), v))
                        end
                    end
                end
            end

            if e.GetSaveTable then
                local ok, st = pcall(e.GetSaveTable, e)
                if ok and type(st) == "table" then
                    scannedST = scannedST + 1
                    for k, v in pairs(st) do
                        if type(v) == "string" and v ~= "" and matches(v) then
                            n = n + 1
                            MsgN(("[ST] %s name=%q key=%q val=%q"):format(
                                e:GetClass(), e:GetName(), tostring(k), v))
                        end
                    end
                end
            end
        end

        MsgN(("=== matches: %d (scanned %d KV, %d ST) ===")
            :format(n, scannedKV, scannedST))
    end)
end
