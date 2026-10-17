SWEP.PrintName = "Item"

SWEP.AnimPrefix = "none"
SWEP.HoldType = "normal"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = false
SWEP.Primary.Sound = Sound("")

SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.WalkSpeed = SPEED_NORMAL

-- ============================================================
-- Display names for ZE weapons
-- ------------------------------------------------------------
-- There is NO separate table. The name is looked up automatically:
--   1) try "map_ze_weapon_name_<full targetname in lowercase>"
--   2) if not found — "map_ze_weapon_name_<first word of targetname>"
--      (rayo_template1 -> rayo, gira_Rayo -> gira)
--
-- So it's enough to add lines like these to the map translation file:
--   LANGUAGE.ze_weapon_name_boton = "Button"
--   LANGUAGE.ze_weapon_name_rayo  = "Thunder"
-- and everything will be picked up automatically.
-- ============================================================

local function ExtractZEBase(targetname)
    if type(targetname) ~= "string" or targetname == "" then return nil end
    local base = targetname:match("^([%a]+)")
    return base and base:lower() or nil
end

local function ResolveName(pl, lookup)
    if SERVER and IsValid(pl) then
        local v = translate.ClientGet(pl, lookup)
        if v and v ~= "@" .. lookup .. "@" then return v end
        return nil
    end
    if translate.Exists(lookup) then
        return translate.Get(lookup)
    end
    return nil
end

-- Resolver by the name targetname (a string, not an entity).
local function GetMapWeaponDisplayNameByName(pl, raw)
    if type(raw) ~= "string" or raw == "" then return nil end

    local lower = raw:lower()
    local base  = ExtractZEBase(raw)

    local function Resolve(lookup)
        if SERVER and IsValid(pl) then
            local v = translate.ClientGet(pl, lookup)
            if v and v ~= "@" .. lookup .. "@" then return v end
            return nil
        end
        if translate.Exists(lookup) then return translate.Get(lookup) end
        return nil
    end

    -- 1. Exact name
    local v = Resolve("map_ze_weapon_name_" .. lower)
    if v then return v end

    -- 2. magia_rayo_t1 -> magia_rayo
    local notier = lower:gsub("_[tT]%d+[%a%d]*$", "")
    if notier ~= lower then
        v = Resolve("map_ze_weapon_name_" .. notier)
        if v then return v end
    end

    -- 3. First word: magia_rayo -> magia
    if base and base ~= lower then
        v = Resolve("map_ze_weapon_name_" .. base)
        if v then return v end
    end

    return nil
end

-- Wrapper for compatibility with entity.
local function GetMapWeaponDisplayName(pl, child)
    if not IsValid(child) then return "?" end
    local raw = child:GetName()
    if raw and raw ~= "" then
        local v = GetMapWeaponDisplayNameByName(pl, raw)
        if v then return v end
        return raw
    end
    return child:GetClass()
end

function SWEP:Initialize()
end

function SWEP:Equip()
    if not GAMEMODE.ZombieEscape then return end
    if not SERVER then return end

    local owner = self:GetOwner()

    -- Show the notification ONLY when the weapon has actual
    -- named children (map entities with targetname). If there are no children —
    -- this is a typical runtime spawn via env_entity_maker
    -- (ze_lotr_minas_tirith_v3_3 and similar maps). The original
    -- weapon_map_base worked exactly the same way and stayed silent in this case.
    local named = {}
    for _, child in ipairs(self:GetChildren()) do
        if IsValid(child) then
            local n = child:GetName()
            if n and n ~= "" then
                named[#named + 1] = child
            end
        end
    end

    -- We always trigger the hook — other systems may depend on it.
    gamemode.Call("OnZEWeaponPickup", owner, self)

    if #named == 0 then return end

    local child = named[math.random(#named)]
    local sourceName = child:GetName()

    for _, pl in pairs(player.GetAll()) do
        local childname = GetMapWeaponDisplayNameByName(pl, sourceName) or sourceName
        local msg = translate.ClientFormat(pl, "ze_weapon_pickup",
            owner:Name(), childname)
        pl:CenterNotify(COLOR_GREEN, msg)
        pl:PrintMessage(HUD_PRINTTALK, msg)
    end
end

function SWEP:SetWeaponHoldType()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Deploy()
	if SERVER then
		local owner = self:GetOwner()

		if GAMEMODE.ZombieEscape then
			owner:SelectWeapon("weapon_zs_zeknife")
		else
			owner:SelectWeapon("weapon_zs_fists")
		end
	end
	return true
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end
