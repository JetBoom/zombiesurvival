-- ============================================================
-- Server-side fixes for TFA Base / TFA-CSO / TFA-Nexon.
-- ============================================================

if not SERVER then return end
if not TFACompat then return end

local ourFns = setmetatable({}, {__mode = "k"})
local PlayerMeta = FindMetaTable("Player")

local function IsPlayerEnt(ent)
    return IsValid(ent) and getmetatable(ent) == PlayerMeta
end

local function IsSigilOrBarricade(ent)
    if not IsValid(ent) then return false end
    if ent.Sigil then return true end
    if ent.IsBarricadeObject then return true end
    if ent.IsBarricadeProp and ent:IsBarricadeProp() then return true end
    local owner = ent.GetOwner and ent:GetOwner()
    if IsValid(owner) and (owner.IsBarricadeObject or owner:GetClass() == "prop_obj_sigil") then
        return true
    end
    local cls = ent.GetClass and ent:GetClass() or ""
    return cls == "prop_prop_blocker" or cls == "prop_obj_sigil"
        or cls == "prop_blocker" or cls == "prop_arsenalcrate"
        or cls == "prop_gunturret" or cls == "prop_remantler"
        or cls == "prop_resupplybox"
end

local function IsGhosting(ply)
    if not IsValid(ply) then return false end
    if ply.ZS_Ghosting == true then return true end
    if ply.GetNWBool and ply:GetNWBool("ZS_Ghosting", false) then return true end
    if ply.GetDTBool and (ply:GetDTBool(0) or ply:GetDTBool(1)) then return true end
    if ply.KeyDown and ply:KeyDown(IN_ZOOM) then return true end
    return false
end

-- ---------- ShouldNotCollide ----------
local function WrapShouldNotCollide(orig)
    local fn = function(self, ent)
        if not IsValid(ent) then return false end
        if IsPlayerEnt(ent) then
            return self:Team() == ent:Team() or self.NoCollideAll or ent.NoCollideAll
        end
        if self:Team() ~= TEAM_HUMAN then
            if orig then return orig(self, ent) end
            return false
        end
        if IsGhosting(self) and IsSigilOrBarricade(ent) then
            return true
        end
        if orig then return orig(self, ent) end
        return false
    end
    ourFns[fn] = true
    return fn
end

-- ---------- PlayerUse ----------
-- Normally nothing can be used while ghosting, but sigils can.
local function WrapPlayerUse(orig)
    local fn = function(self, ent)
        if self:GetBarricadeGhosting() and IsValid(ent) and ent.Sigil then
            if orig then return orig(self, ent) end
            return true
        end
        if orig then return orig(self, ent) end
        return true
    end
    ourFns[fn] = true
    return fn
end

-- ---------- ResetJumpPower ----------
local function WrapResetJumpPower(orig)
    local fn = function(self, noset)
        if self:GetBarricadeGhosting() then
            local power = 50
            if not noset then self:SetJumpPower(power) end
            return power
        end
        if orig then return orig(self, noset) end
    end
    ourFns[fn] = true
    return fn
end

-- ---------- Set/GetBarricadeGhosting ----------
-- TFA-CSO writes to DTBool(0) and corrupts the ZS flag.
-- Hide the flag in a player variable and duplicate in NWBool (client reads it).
local function WrapBarricadeGhosting()
    local meta = FindMetaTable("Player")
    if not meta or meta.ZS_TFA_GhostingPatched then return end
    meta.ZS_TFA_GhostingPatched = true

    local oldSet = meta.SetBarricadeGhosting
    local oldGet = meta.GetBarricadeGhosting

    function meta:SetBarricadeGhosting(b, fullspeed)
        local val = b and true or false
        self.ZS_Ghosting = val
        self:SetNWBool("ZS_Ghosting", val)
        if oldSet then oldSet(self, b, fullspeed) end
    end

    function meta:GetBarricadeGhosting()
        if self.ZS_Ghosting ~= nil then return self.ZS_Ghosting end
        if self.GetNWBool then return self:GetNWBool("ZS_Ghosting", false) end
        if oldGet then return oldGet(self) end
        return false
    end
    meta.IsBarricadeGhosting = meta.GetBarricadeGhosting
end

-- ---------- GM:ShouldCollide ----------
local function InstallShouldCollide()
    GAMEMODE.ShouldCollide = function(self, enta, entb)
        if IsValid(enta) and enta.ShouldNotCollide and enta:ShouldNotCollide(entb) then
            return false
        end
        if IsValid(entb) and entb.ShouldNotCollide and entb:ShouldNotCollide(enta) then
            return false
        end
        return true
    end
end

-- ---------- Wrap foreign ShouldCollide hooks ----------
-- ajax_forcefield.lua adds ForceFieldCollision which returns
-- true/false for ANY pair and breaks hook.Run. Remove it: for
-- forcefield the engine allows collision by default anyway.
local function WrapTFAShouldCollideHooks()
    hook.Remove("ShouldCollide", "ForceFieldCollision")

    local tbl = hook.GetTable()["ShouldCollide"]
    if not tbl then return end
    for name, fn in pairs(tbl) do
        local skip = name:find("^ZS_") or ourFns[fn]
        if not skip then
            local orig = fn
            local wrapped = function(enta, entb)
                local aGhost = IsPlayerEnt(enta) and enta:Team() == TEAM_HUMAN and enta:GetBarricadeGhosting()
                local bGhost = IsPlayerEnt(entb) and entb:Team() == TEAM_HUMAN and entb:GetBarricadeGhosting()
                if aGhost and IsSigilOrBarricade(entb) then return false end
                if bGhost and IsSigilOrBarricade(enta) then return false end
                return orig(enta, entb)
            end
            ourFns[wrapped] = true
            tbl[name] = wrapped
        end
    end
end

-- ---------- SetCustomCollisionCheck ----------
-- Prevent removing CCC from a human player.
local function WrapSetCustomCollisionCheck(orig)
    local fn = function(self, on)
        if on == false and self:Team() == TEAM_HUMAN then
            on = true
        end
        if orig then return orig(self, on) end
    end
    ourFns[fn] = true
    return fn
end

local function Patch()
    local meta = FindMetaTable("Player")
    if not meta then return end

    WrapBarricadeGhosting()

    if not ourFns[meta.ShouldNotCollide] then
        meta.ShouldNotCollide = WrapShouldNotCollide(meta.ShouldNotCollide)
    end
    if not ourFns[meta.PlayerUse] then
        meta.PlayerUse = WrapPlayerUse(meta.PlayerUse)
    end
    if not ourFns[meta.ResetJumpPower] then
        meta.ResetJumpPower = WrapResetJumpPower(meta.ResetJumpPower)
    end
    if meta.SetCustomCollisionCheck and not ourFns[meta.SetCustomCollisionCheck] then
        meta.SetCustomCollisionCheck = WrapSetCustomCollisionCheck(meta.SetCustomCollisionCheck)
    end

    InstallShouldCollide()
end

local function ForceCustomCollisionCheck()
    for _, ply in pairs(player.GetAll()) do
        if ply:Team() == TEAM_HUMAN then
            ply:SetCustomCollisionCheck(true)
        end
    end
end

-- ============================================================
-- Entity:ShouldCollide — the key patch.
-- Player CCC=true → engine calls Entity:ShouldCollide(other),
-- not GM:ShouldCollide. ZS base has no such function → default
-- "can collide" → player can't pass. Make it mirror
-- ShouldNotCollide.
-- ============================================================
local function InstallEntityShouldCollide()
    local meta = FindMetaTable("Entity")
    if not meta or meta.ZS_TFA_EntityShouldCollide then return end
    meta.ZS_TFA_EntityShouldCollide = true

    local oldSC = meta.ShouldCollide

    function meta:ShouldCollide(ent)
        if self:IsPlayer() and self.ShouldNotCollide and self:ShouldNotCollide(ent) then
            return false
        end
        if IsValid(ent) and ent:IsPlayer() and ent.ShouldNotCollide and ent:ShouldNotCollide(self) then
            return false
        end
        if oldSC then return oldSC(self, ent) end
        return true
    end
end

-- ============================================================
-- prop_blocker
-- shared.lua for prop_blocker doesn't set IsBarricadeObject.
-- Force it on SENT + live instances.
-- ============================================================
local function PatchBlockerSENT()
    local sent = scripted_ents.GetStored("prop_blocker")
    if sent and sent.t then
        sent.t.IsBarricadeObject = true
        sent.t.NoNails          = true
        sent.t.m_NoNailUnfreeze = true
    end
end

local BARRICADE_CLASSES = {
    "prop_prop_blocker",
    "prop_obj_sigil",
    "prop_arsenalcrate",
    "prop_remantler",
    "prop_resupplybox",
    "prop_gunturret",
    "prop_blocker",
}

local function ForceBlockersNow()
    for _, cls in ipairs(BARRICADE_CLASSES) do
        for _, e in pairs(ents.FindByClass(cls)) do
            if not e.IsBarricadeObject then
                e.IsBarricadeObject = true
            end
        end
    end
end

-- ============================================================
-- Hooks
-- ============================================================
-- Set for fast class check.
local BARRICADE_CLASS_SET = {}
for _, cls in ipairs(BARRICADE_CLASSES) do
	BARRICADE_CLASS_SET[cls] = true
end

-- Force flag on new entities.
hook.Add("OnEntityCreated", "ZS_TFA_ForceBlockerFlag", function(ent)
	if not BARRICADE_CLASS_SET[ent:GetClass()] then return end
	timer.Simple(0, function()
		if IsValid(ent) then ent.IsBarricadeObject = true end
	end)
end)

-- Once on map load.
hook.Add("InitPostEntity", "ZS_TFA_InitPatches", function()
	PatchBlockerSENT()
	ForceBlockersNow()
	InstallEntityShouldCollide()
	Patch()
	WrapTFAShouldCollideHooks()
end)

-- On player spawn.
hook.Add("PlayerSpawn", "ZS_TFA_PlayerPatch", function(ply)
	Patch()
	timer.Simple(0, function()
		if IsValid(ply) and ply:Team() == TEAM_HUMAN then
			ply:SetCustomCollisionCheck(true)
		end
	end)
end)

-- Rare fallback: every 3 seconds.
local nextcheck = 0
hook.Add("Think", "ZS_TFA_VerifyPatches", function()
	local now = CurTime()
	if now < nextcheck then return end
	nextcheck = now + 3

	WrapTFAShouldCollideHooks()
	Patch()
	ForceCustomCollisionCheck()
	InstallEntityShouldCollide()
end)

hook.Add("Move", "ZS_TFA_MoveSpeedFinal", function(ply, move)
    if ply:Team() ~= TEAM_HUMAN then return end
    if not ply:GetBarricadeGhosting() then return end
    local wideLoad = ply.NoGhosting and ply:GetDTFloat(DT_PLAYER_FLOAT_WIDELOAD) > CurTime()
    local mul = ply.BarricadePhaseSpeedMul or 1
    local target = wideLoad and 7 or (36 * mul)
    if move.SetMaxClientSpeed then move:SetMaxClientSpeed(target) end
    if move.SetMaxSpeed then move:SetMaxSpeed(target) end
end)