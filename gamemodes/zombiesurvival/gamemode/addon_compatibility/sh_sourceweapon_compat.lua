--[[
    Compatibility with any weapon: base HL2, CSS, from addons,
    custom. Goal: prevent crashes when accessing
    Primary/Secondary/WorldModel and provide a meaningful name
    if the weapon author didn't set one.

    Nothing is overwritten: if the addon set PrintName/WorldModel —
    use them. Only fill in empty/missing fields.
]]

local FALLBACK_WORLDMODEL = "models/weapons/w_crowbar.mdl"

-- "weapon_pistol"    -> "Pistol"
-- "weapon_coolgun"   -> "Coolgun"
-- "weapon_zs_akbar"  -> "Akbar"
-- "cw_mp5"           -> "Mp5"
-- "weapon_357"       -> "357"
local function PrettyClassName(class)
    if not class or class == "" then return "Weapon" end
    local s = class
    s = s:gsub("^weapon_", "")
    s = s:gsub("^zs_", "")
    s = s:gsub("_", " ")
    -- Capitalize each word: "coolgun" -> "Coolgun"
    s = s:gsub("(%a)([%w]*)", function(a, b) return a:upper() .. b:lower() end)
    return s
end

-- Normalize a single weapon to a safe form.
local function EnsureSwepFields(wep)
    if type(wep) ~= "table" then return end

    -- Primary / Secondary: don't touch existing, create stub if nil
    if wep.Primary == nil then
        wep.Primary = {
            Ammo = "none",
            ClipSize = -1,
            DefaultClip = -1,
            Automatic = false,
            Sound = Sound(""),
        }
    end
    if wep.Primary.Ammo == nil then
        wep.Primary.Ammo = "none"
    end

    if wep.Secondary == nil then
        wep.Secondary = {
            Ammo = "none",
            ClipSize = -1,
            DefaultClip = -1,
            Automatic = false,
            Sound = Sound(""),
        }
    end
    if wep.Secondary.Ammo == nil then
        wep.Secondary.Ammo = "none"
    end

    -- PrintName: if empty — derive from class
    if wep.PrintName == nil or wep.PrintName == "" then
        wep.PrintName = PrettyClassName(wep.ClassName)
    end
end

local function ApplyCompat()
    -- weapons.GetList() returns all weapons including from addons.
    -- Run once — that's enough, fields stay mutated.
    local list = weapons.GetList and weapons.GetList() or {}
    for _, wep in ipairs(list) do
        EnsureSwepFields(wep)
    end
end

hook.Add("InitPostEntity", "ZS_SourceWeaponCompat", ApplyCompat)
hook.Add("OnReloaded",     "ZS_SourceWeaponCompat", ApplyCompat)

-- Run immediately on load
ApplyCompat()