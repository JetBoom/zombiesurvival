function GM:PlayerRedeemed(pl, silent, noequip)
	local mapname = string.lower(game.GetMap())
	if string.find(mapname, "_obj_", 1, true) or string.find(mapname, "objective", 1, true) then
TEAM_REDEEMER = TEAM_HUMAN end

if not silent then
		net.Start("zs_playerredeemed")
			net.WriteEntity(pl)
			net.WriteString(pl:Name())
		net.Broadcast()
	end

	pl:RemoveStatus("overridemodel", false, true)

	pl:ChangeTeam(TEAM_REDEEMER)
	pl:SetPoints(150)
	pl:DoHulls()
	if not noequip then pl.m_PreRedeem = true end
	pl:UnSpectateAndSpawn()
				pl:Give("weapon_zs_redeemers")
                                pl:Give("weapon_zs_hammer")
pl.m_PreRedeem = nil

	local frags = pl:Frags()
	if frags < 0 then
		pl:SetFrags(frags * 5)
	else
		pl:SetFrags(0)
	end
	pl:SetDeaths(0)

	pl.DeathClass = nil
	pl:SetZombieClass(self.DefaultZombieClass)

	pl.SpawnedTime = CurTime()

end

function GM:PlayerRespawn(pl, silent, noequip)

	pl:RemoveStatus("overridemodel", false, true)

	pl:ChangeTeam(TEAM_HUMAN)
	pl:DoHulls()
	pl:UnSpectateAndSpawn()
	
	pl:Give("weapon_zs_redeemers")
	pl:Give("weapon_zs_swissarmyknife")

	local frags = pl:Frags()
	if frags < 0 then
		pl:SetFrags(frags * 5)
	else
		pl:SetFrags(0)
	end
	pl:SetDeaths(0)

	pl.DeathClass = nil
	pl:SetZombieClass(self.DefaultZombieClass)

	pl.SpawnedTime = CurTime()
end

hook.Add("PostPlayerDeath", "PostPlayerDeath.Redeemer", function(ply)
    if ply:Team() == TEAM_REDEEMER or ply:Team() == TEAM_HUMAN then
        ply:ChangeTeam(TEAM_UNDEAD)
        ply:SetFrags(0)
        ply:SetDeaths(0)
        GAMEMODE.StartingZombie[ply:UniqueID()] = true
        GAMEMODE.PreviouslyDied[ply:UniqueID()] = CurTime()
ply:SetZombieClassName(Zombie)
    end
end)
