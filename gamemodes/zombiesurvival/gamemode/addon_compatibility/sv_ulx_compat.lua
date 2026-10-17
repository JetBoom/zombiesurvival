--[[
    Compatibility with third-party addons that call:
        hook.Call("PlayerRedeemed", GAMEMODE, pl)
        hook.Call("PlayerRespawn",  GAMEMODE, pl)

    ULX (commands ulx redeem and ulx respawn) and some other
    admin panels trigger these hooks exactly that way. The
    gamemode itself has no GM:PlayerRedeemed / GM:PlayerRespawn
    methods, so those calls used to do nothing.

    Here both methods are registered as proxies to the existing
    features in obj_player_extend_sv.lua:
        Player:Redeem(silent, noequip)   — turn into a human
        Player:UnSpectateAndSpawn()      — unspectate and Spawn()
]]

if not SERVER then return end

-- hook.Call("PlayerRedeemed", GAMEMODE, pl) → GM:PlayerRedeemed(pl)
function GM:PlayerRedeemed(pl, silent, noequip)
    if not IsValid(pl) then return end
    if not pl.Redeem then return end

    -- Redeem only works for zombies. If the player is already human —
    -- bail out to avoid spawning him a second time and giving
    -- him a second loadout.
    if pl:Team() ~= TEAM_UNDEAD then return end

    pl:Redeem(silent, noequip)
end

-- hook.Call("PlayerRespawn", GAMEMODE, pl) → GM:PlayerRespawn(pl)
--
-- "Respawn" in ZS terms: the player stays in his current team,
-- we just pull him out of observer mode and call Spawn.
-- Don't touch class/team/points — that's regular Redeem's job.
function GM:PlayerRespawn(pl, silent, noequip)
    if not IsValid(pl) then return end

    -- Guard against re-entry if some engine/mod
    -- calls PlayerRespawn while the player is already alive.
    if pl:Alive() and pl:GetObserverMode() == OBS_MODE_NONE then
        return
    end

    if pl.UnSpectateAndSpawn then
        pl:UnSpectateAndSpawn()
    else
        pl:UnSpectate()
        pl:Spawn()
    end
end