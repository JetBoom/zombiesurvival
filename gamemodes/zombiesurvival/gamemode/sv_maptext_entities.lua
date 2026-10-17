if not SERVER then return end

-- tonumber() in GLua doesn't understand a comma as decimal separator,
-- and a .vmf saved with localized Hammer may write "0,05".
local function ParseFloat(v)
    if type(v) == "number" then return v end
    if type(v) ~= "string" then return nil end
    return tonumber(v) or tonumber((v:gsub(",", ".")))
end

util.AddNetworkString("zs_maptext_display")
util.AddNetworkString("zs_maptext_clear")

-- ============================================================
-- Full KV capture from game_text / game_text_tf / env_message.
-- GetKeyValues() on a live entity loses color, color2, effect,
-- fxtime, x, y, channel — the engine's KeyValue() processes them
-- and doesn't leave them in the generic KV table. We catch
-- everything via EntityKeyValue during BSP parsing.
-- ============================================================
local MapTextKVs = setmetatable({}, {__mode = "k"})

hook.Add("EntityKeyValue", "ZS_CaptureMapTextKV", function(ent, key, value)
    local class = ent:GetClass()
    if class ~= "game_text" and class ~= "game_text_tf" and class ~= "env_message" then return end
    if type(key) ~= "string" or type(value) ~= "string" then return end
    if value == "" then return end

    local t = MapTextKVs[ent]
    if not t then
        t = {}
        MapTextKVs[ent] = t
    end
    t[key:lower()] = value
end)

-- ============================================================
-- ZE weapon messages + I/O graph
-- ------------------------------------------------------------
-- GetKeyValues()/GetSaveTable() in GMod do NOT return OnPlayerPickup
-- and are often empty for outputs — catch everything through
-- EntityKeyValue while the map loads. Data lives until map change.
-- ============================================================
-- ============================================================
-- ZE weapon display names
-- ------------------------------------------------------------
-- Source of truth — KVs caught while loading the map. GetKeyValues()
-- and ents.GetAll() for weapon_elite* don't work on ZE maps: the root
-- weapons spawn and get removed during BSP parsing, before InitPostEntity.
-- So we catch:
--   * OnPlayerPickup on weapon_map_base* — message on pickup
--   * parentname on everything — weapon → children hierarchy (who gets shown)
-- ============================================================
local ZEWeaponMessages  = {}   -- weapon targetname -> {msg, ...}
local ZE_ParentChildren = {}   -- parent targetname -> { {name, class}, ... }

local function ZE_ExtractSayMessage(param)
    if type(param) ~= "string" or param == "" then return nil end
    local lower = param:lower()
    for _, cmd in ipairs({"say", "chatprint", "hl2mp_chat"}) do
        local start, finish = lower:find(cmd, 1, true)
        while start do
            local before = param:sub(start - 1, start - 1)
            if start == 1 or before == " " or before == "\t" then
                local rest = param:sub(finish + 1)
                local t = rest:match('^%s*"([^"]*)"') or rest:match("^%s*'([^']*)'")
                if t then return t end
                local bare = rest:match("^%s+(.+)")
                if bare and bare ~= "" then return bare end
            end
            start, finish = lower:find(cmd, finish + 1, true)
        end
    end
    return nil
end

local function ZE_ParseIOSpec(spec)
    if type(spec) ~= "string" or spec == "" then return nil end
    local sep = spec:find("\x1B", 1, true) and "\x1B" or ","
    local parts = string.Explode(sep, spec)
    if #parts < 3 then return nil end
    return {
        target = parts[1],
        input  = (parts[2] or ""):gsub("%s+", ""),
        param  = parts[3] or "",
    }
end

local function ZE_IsMapWeaponClass(class)
    if type(class) ~= "string" then return false end
    local stored = weapons.GetStored(class)
    return class == "weapon_map_base"
        or (stored and stored.Base == "weapon_map_base")
end

hook.Add("EntityKeyValue", "ZS_ZEWeaponMessages", function(ent, key, value)
    if type(key) ~= "string" or type(value) ~= "string" then return end
    if value == "" then return end
    local kl = key:lower()

    local name = ent:GetName()
    if name == "" then return end

    -- weapon → children hierarchy
    if kl == "parentname" then
        local list = ZE_ParentChildren[value]
        if not list then
            list = {}
            ZE_ParentChildren[value] = list
        end
        for _, e in ipairs(list) do
            if e.name == name then return end
        end
        list[#list + 1] = { name = name, class = ent:GetClass() }
        return
    end

    if not (kl:sub(1, 2) == "on" or kl:sub(1, 4) == "m_on") then return end

    -- Pickup message — only on map weapons
    if kl == "onplayerpickup" and ZE_IsMapWeaponClass(ent:GetClass()) then
        local p = ZE_ParseIOSpec(value)
        if p and p.input:lower() == "command" then
            local msg = ZE_ExtractSayMessage(p.param)
            if msg and msg ~= "" then
                local list = ZEWeaponMessages[name]
                if not list then
                    list = {}
                    ZEWeaponMessages[name] = list
                end
                for _, m in ipairs(list) do
                    if m == msg then return end
                end
                list[#list + 1] = msg
            end
        end
    end
end)

-- ============================================================
-- Export ZE records for the shared zs_dumpmaptexts command.
-- The separate zs_dumpzeweapons was removed — the data goes to
-- a single file together with map texts, see sh_maptext.lua.
-- ============================================================
function translate.GetZEDumpRecords()
    if not SERVER then return end

    local records = {}

    local function AddRec(name, class, parent, kind, msgs)
        if not name or name == "" then return end
        local rec = records[name]
        if rec then
            if parent and parent ~= "" and rec.parent == "" then
                rec.parent = parent
            end
            if kind and kind ~= "" then rec.kind = kind end
            if msgs then rec.msgs = msgs end
            return
        end
        records[name] = {
            name   = name,
            class  = class  or "",
            parent = parent or "",
            kind   = kind   or "",
            msgs   = msgs,
        }
    end

    -- Roots: those that have OnPlayerPickup (caught in EntityKeyValue).
    for weaponName, msgs in pairs(ZEWeaponMessages) do
        AddRec(weaponName, "weapon_elite", "", "weapon", msgs)

        local children = ZE_ParentChildren[weaponName]
        if children then
            for _, child in ipairs(children) do
                if not ZE_IsMapWeaponClass(child.class) then
                    AddRec(child.name, child.class, weaponName,
                        "weapon_child", msgs)
                end
            end
        end
    end

    local sortedNames = {}
    for name in pairs(records) do sortedNames[#sortedNames + 1] = name end
    table.sort(sortedNames)

    return records, sortedNames
end

function GM:ClearMapTexts()
    net.Start("zs_maptext_clear")
    net.Broadcast()
end

function GM:ReplaceMapTextEntities()
    local function Convert(oldClass, envMsg)
        for _, old in ipairs(ents.FindByClass(oldClass)) do
            if not old:IsValid() then continue end

            local ent = ents.Create("zs_gametext")
            if not ent:IsValid() then continue end

            ent:SetPos(old:GetPos())
            ent:SetAngles(old:GetAngles())
            ent.m_bEnvironmentMessage = envMsg

            -- First — the full set caught via EntityKeyValue.
            -- Fallback to GetKeyValues() (has message, but loses colors etc.).
            local kv = MapTextKVs[old]
            if not kv then
                kv = {}
                if old.GetKeyValues then
                    for k, v in pairs(old:GetKeyValues()) do
                        if type(k) == "string" then
                            kv[k:lower()] = v
                        end
                    end
                end
            end

            -- ParseFloat, not tonumber: Russian/German locale Hammer writes
            -- decimals with a comma ("0,35"), which tonumber doesn't
            -- understand and returns nil → the value falls to default 0 →
            -- the effect is disabled.
            ent.StoredMessage       = kv.message or ""
            ent.m_flMessageTextTime = ParseFloat(kv.holdtime) or 5
            ent.m_flFadeInTime      = ParseFloat(kv.fadein)   or 0.5
            ent.m_flFadeOutTime     = ParseFloat(kv.fadeout)  or 0.5
            ent.m_flEffectTime      = ParseFloat(kv.fxtime)   or 0
            ent.m_iTextX            = ParseFloat(kv.x)        or -1
            ent.m_iTextY            = ParseFloat(kv.y)        or -1
            ent.m_iTextEffect       = tonumber(kv.effect)     or 0
            ent.m_iChannel          = tonumber(kv.channel)    or 0

            -- Parse colors right here — Initialize in SENT won't see
            -- them, because KeyValue is not called on a runtime-created entity.
            if kv.color then
                local c = ent:_ParseColor(kv.color)
                if c then ent.m_iTextColor1 = c end
            end
            if kv.color2 then
                local c = ent:_ParseColor(kv.color2)
                if c then ent.m_iTextColor2 = c end
            end

            -- Copy spawnflags, otherwise "Start On" and other map flags
            -- won't fire on zs_gametext.
            ent:AddSpawnFlags(old:GetSpawnFlags())

            ent:Spawn()
            ent:Activate()

            local name = old:GetName()
            if name ~= "" then
                ent:SetName(name)
            end

            old:Remove()
        end
    end

    Convert("game_text", false)
    Convert("game_text_tf", false)
    Convert("env_message", true)
end