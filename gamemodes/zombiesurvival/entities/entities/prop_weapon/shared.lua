ENT.Type = "anim"
ENT.Base = "prop_baseoutlined"

ENT.NoNails = true

function ENT:HumanHoldable(pl)
	return pl:KeyDown(GAMEMODE.UtilityKey) or (pl:HasWeapon(self:GetWeaponType()) and self:GetClip1() == 0 and self:GetClip2() == 0)
end

local FALLBACK_WORLDMODEL = "models/weapons/w_crowbar.mdl"

-- Returns the world model of the weapon or nil.
--   1. Lua SWEP table (for Lua weapons and most CSS weapons in GMod).
--   2. Engine .txt script (for HL2 weapons: weapon_357, weapon_pistol, ...).
local function ResolveWeaponWorldModel(class)
    if not class or class == "" then return nil end

    local weptab = weapons.GetStored(class)
    if weptab then
        if weptab.WorldModel and weptab.WorldModel ~= "" then
            return weptab.WorldModel
        end
        if weptab.ViewModel and weptab.ViewModel ~= "" then
            return weptab.ViewModel
        end
    end

    -- HL2 script: scripts/weapon_357.txt etc.
    local data = file.Read("scripts/" .. class .. ".txt", "GAME")
    if data and data ~= "" then
        local ok, kvs = pcall(util.KeyValuesToTable, data)
        if ok and type(kvs) == "table" then
            -- The upper block may be called WeaponData / weapondata / be absent.
            local wd = kvs.WeaponData or kvs.weapondata or kvs
            -- The engine stores the playermodel key as is, but let's play it safe.
            local pm = wd.playermodel or wd.Playermodel or wd.PlayerModel
            if pm and pm ~= "" then
                return pm
            end
        end
    end

    return nil
end

function ENT:SetWeaponType(class)
    if string.sub(class, 1, 12) == "weapon_zs_t_" then
        if SERVER then self:MakeInvItemConvert(class) end
        self:SetDTString(0, class)
        return
    end

    local mdl = ResolveWeaponWorldModel(class) or FALLBACK_WORLDMODEL
    self:SetModel(mdl)

    local weptab = weapons.Get(class)
    if weptab then
        if SERVER then self:SetupPhysics(weptab) end
        if weptab.ModelScale then
            self:SetModelScale(weptab.ModelScale, 0)
        end
    end

    self:SetDTString(0, class)
end

function ENT:GetWeaponType()
	return self:GetDTString(0)
end
