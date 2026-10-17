-- ============================================================
-- Client-side fixes for TFA Base / TFA-CSO.
-- ============================================================

if not CLIENT then return end
if not TFACompat then return end

-- ============================================================
-- Helpers
-- ============================================================
local function IsGhostingPly(ply)
    if not IsValid(ply) then return false end
    if ply.ZS_Ghosting then return true end
    if ply.GetNWBool and ply:GetNWBool("ZS_Ghosting", false) then return true end
    if ply.KeyDown and ply:KeyDown(IN_ZOOM) then return true end
    return false
end

local function IsBarricadeEntity(ent)
    if not IsValid(ent) then return false end
    if ent.IsBarricadeObject then return true end
    if ent.IsBarricadeProp and ent:IsBarricadeProp() then return true end
    local cls = ent:GetClass()
    if cls == "prop_prop_blocker" or cls == "prop_obj_sigil"
        or cls == "prop_arsenalcrate" or cls == "prop_remantler"
        or cls == "prop_resupplybox" or cls == "prop_gunturret"
        or cls == "prop_blocker" then
        return true
    end
    local o = ent.GetOwner and ent:GetOwner()
    if IsValid(o) and (o.IsBarricadeObject or o:GetClass() == "prop_obj_sigil") then
        return true
    end
    return false
end

-- ============================================================
-- GetBarricadeGhosting: read NWBool (TFA-CSO breaks DTBool0)
-- ============================================================
do
    local meta = FindMetaTable("Player")
    if not meta.ZS_TFA_ClientGhostingPatched then
        meta.ZS_TFA_ClientGhostingPatched = true
        local oldGet = meta.GetBarricadeGhosting
        function meta:GetBarricadeGhosting()
            if self.GetNWBool then
                return self:GetNWBool("ZS_Ghosting", false)
            end
            if oldGet then return oldGet(self) end
            return false
        end
        meta.IsBarricadeGhosting = meta.GetBarricadeGhosting
    end
end

-- ============================================================
-- ShouldNotCollide
-- ============================================================
do
    local meta = FindMetaTable("Player")
    if not meta.ZS_TFA_ClientSNCPatched then
        meta.ZS_TFA_ClientSNCPatched = true
        local PlayerMeta = meta
        local oldSNC = meta.ShouldNotCollide

        function meta:ShouldNotCollide(ent)
            if not IsValid(ent) then return false end
            if getmetatable(ent) == PlayerMeta then
                return self:Team() == ent:Team()
                    or self.NoCollideAll
                    or ent.NoCollideAll
            end
            if self:Team() ~= TEAM_HUMAN then
                if oldSNC then return oldSNC(self, ent) end
                return false
            end
            if IsGhostingPly(self) and IsBarricadeEntity(ent) then
                return true
            end
            if oldSNC then return oldSNC(self, ent) end
            return false
        end
    end
end

-- ============================================================
-- Entity:ShouldCollide — mirror of ShouldNotCollide.
-- Player CCC=true → engine calls this method.
-- ============================================================
do
    local meta = FindMetaTable("Entity")
    if not meta.ZS_TFA_ClientEntitySC then
        meta.ZS_TFA_ClientEntitySC = true
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
end

-- ============================================================
-- Wrap client-side ShouldCollide hooks.
-- Works when CCC=false and the engine goes through hook.Run.
-- ============================================================
do
    local ourFns = setmetatable({}, {__mode = "k"})

    local function WrapClientHooks()
        -- ajax_forcefield adds ForceFieldCollision which always
        -- returns true/false for any pair and breaks hook.Run.
        hook.Remove("ShouldCollide", "ForceFieldCollision")

        local tbl = hook.GetTable()["ShouldCollide"]
        if not (tbl and tbl.ZS_TFA_ClientAllowGhost) then
            hook.Add("ShouldCollide", "ZS_TFA_ClientAllowGhost", function(enta, entb)
                local aGhost = IsValid(enta) and enta:IsPlayer()
                    and enta:Team() == TEAM_HUMAN and IsGhostingPly(enta)
                local bGhost = IsValid(entb) and entb:IsPlayer()
                    and entb:Team() == TEAM_HUMAN and IsGhostingPly(entb)

                if aGhost and IsBarricadeEntity(entb) then return false end
                if bGhost and IsBarricadeEntity(enta) then return false end
                -- nil — don't interfere with other hooks.
            end)
        end

        tbl = hook.GetTable()["ShouldCollide"]
        if not tbl then return end

        for name, fn in pairs(tbl) do
            if name:find("^ZS_") or ourFns[fn] then continue end
            local orig = fn
            local wrapped = function(enta, entb)
                local aGhost = IsValid(enta) and enta:IsPlayer()
                    and enta:Team() == TEAM_HUMAN and IsGhostingPly(enta)
                local bGhost = IsValid(entb) and entb:IsPlayer()
                    and entb:Team() == TEAM_HUMAN and IsGhostingPly(entb)

                if aGhost and IsBarricadeEntity(entb) then return false end
                if bGhost and IsBarricadeEntity(enta) then return false end
                return orig(enta, entb)
            end
            ourFns[wrapped] = true
            tbl[name] = wrapped
        end
    end

    hook.Add("InitPostEntity", "ZS_TFA_ClientWrapHooks", WrapClientHooks)

	-- Rare hook re-check (once every 3 seconds).
	local nextCheck = 0
	hook.Add("Think", "ZS_TFA_ClientWrapHooksLoop", function()
		local now = CurTime()
		if now < nextCheck then return end
		nextCheck = now + 3
		WrapClientHooks()
	end)
end

-- Force CCC: once per spawn + every 2 seconds as fallback.
hook.Add("Think", "ZS_TFA_ClientCCCForced", function()
	local ply = LocalPlayer()
	if not IsValid(ply) or ply:Team() ~= TEAM_HUMAN then return end
	if not ply.SetCustomCollisionCheck then return end
	ply:SetCustomCollisionCheck(true)
end)

-- Force IsBarricadeObject: creation event + every 3 seconds.
local nextBlockerScan = 0
local class_set = {
	["prop_prop_blocker"]   = true,
	["prop_obj_sigil"]      = true,
	["prop_arsenalcrate"]   = true,
	["prop_remantler"]      = true,
	["prop_resupplybox"]    = true,
	["prop_gunturret"]      = true,
	["prop_blocker"]        = true,
}

hook.Add("OnEntityCreated", "ZS_TFA_ClientForceBlockerFlagEv", function(ent)
	if not class_set[ent:GetClass()] then return end
	timer.Simple(0, function()
		if IsValid(ent) then ent.IsBarricadeObject = true end
	end)
end)

hook.Add("Think", "ZS_TFA_ClientForceBarricadeFlag", function()
	local now = CurTime()
	if now < nextBlockerScan then return end
	nextBlockerScan = now + 3

	for cls in pairs(class_set) do
		for _, e in pairs(ents.FindByClass(cls)) do
			if not e.IsBarricadeObject then e.IsBarricadeObject = true end
		end
	end
end)

-- GhostingThink runs every frame but is cheap — only when the player is ghosting.
hook.Add("Think", "ZS_TFA_ForceBarricadeGhostingThink", function()
	local ply = LocalPlayer()
	if not IsValid(ply) or ply:Team() ~= TEAM_HUMAN then return end
	if not ply:GetBarricadeGhosting() then return end
	ply:BarricadeGhostingThink()
end)

-- ============================================================
-- Block LMB/RMB for TFA weapons while ghosting
-- ============================================================
hook.Add("CreateMove", "ZS_TFA_GhostBlockAttack", function(cmd)
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:GetBarricadeGhosting() then return end
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return end
    if not TFACompat.IsTFA(wep) then return end
    cmd:RemoveKey(IN_ATTACK)
    cmd:RemoveKey(IN_ATTACK2)
end)