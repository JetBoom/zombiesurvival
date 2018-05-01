AddCSLuaFile("cl_zombieescape.lua")
AddCSLuaFile("sh_zombieescape.lua")

include("sh_zombieescape.lua")

if not GM.ZombieEscape then return end

table.insert(GM.CleanupFilter, "func_brush")
table.insert(GM.CleanupFilter, "env_global")
table.insert(GM.CleanupFilter, "info_player_terrorist")
table.insert(GM.CleanupFilter, "info_player_counterterrorist")

local attachmentFallbackMap = table.ToAssoc({
	"forward",
	"grenade0",
	"grenade1",
	"grenade2",
	"pistol",
	"primary",
	"defusekit",
	"eholster",
	"rfoot",
	"lfoot",
	"muzzle_flash"
})

-- We need to fix these important entities.
hook.Add("EntityKeyValue", "zombieescape", function(ent, key, value)
	-- The teamid for Terrorist and Counter Terrorist is different than Zombie and Human in ZS.
	if ent:GetClass() == "filter_activator_team" and not ent.ZEFix then
		if string.lower(key) == "filterteam" then
			if value == "2" then
				ent.ZEFix = tostring(TEAM_UNDEAD)
			elseif value == "3" then
				ent.ZEFix = tostring(TEAM_HUMAN)
			end
		end

		return true
	end

	-- Some maps have brushes that regenerate or set health to dumb values. We don't want them. Although this can break maps I can't think of a way to remove the output instead.
	--[[if (ent:GetClass() == "trigger_multiple" or ent:GetClass() == "trigger_once") and string.find(string.lower(value), "%!.*%,.+%,health") then
		ent.ZEDelete = true
	end]]

	-- Samuel Maddock's fix for setparentattachment
	-- https://github.com/JetBoom/zombiesurvival/pull/178/commits/74aaeb2c2ffc8d5a848945162618de00aacbec72#diff-9fc6a6639c31f62902ca6b7a2f812044L29
	if value:lower():find("setparentattachment") then
		local startIdx, endIdx, attachmentName = value:lower():find("^.-,setparentattachment,(.-),")

		if startIdx and attachmentFallbackMap[attachmentName] then
			startIdx = endIdx - attachmentName:len()
			return value:sub(1, startIdx - 1) .. "eyes" .. value:sub(endIdx)
		end
	end
end)

hook.Add("InitPostEntityMap", "zombieescape", function(fromze)
	for _, ent in pairs(ents.FindByClass("filter_activator_team")) do
		if ent.ZEFix then
			ent:SetKeyValue("filterteam", ent.ZEFix)
		end
	end

	for _, ent in pairs(ents.GetAll()) do
		if ent and ent.ZEDelete and ent:IsValid() then
			ent:Remove()
		end
	end

	-- Forced dynamic spawning.
	-- It'd be pretty damn boring for the zombies with it off since there's only one spawn usually.
	GAMEMODE.DynamicSpawning = true

	if not fromze then
		GAMEMODE:SetRedeemBrains(0)
		if GAMEMODE.CurrentRound <= 1 then
			GAMEMODE:SetWaveStart(CurTime() + GAMEMODE.WaveZeroLength + 30) -- 30 extra seconds for late joiners
		else
			GAMEMODE:SetWaveStart(CurTime() + GAMEMODE.ZE_FreezeTime)
		end
	end
end)

hook.Add("PlayerSpawn", "zombieescape", function(pl)
	timer.Simple(0, function()
		if not pl:IsValid() then return end

		if GAMEMODE:GetWave() == 0 and not GAMEMODE:GetWaveActive() and (pl:Team() == TEAM_UNDEAD or pl:Team() == TEAM_HUMAN and CurTime() < GAMEMODE:GetWaveStart() - GAMEMODE.ZE_FreezeTime) then
			pl.ZEFreeze = true
			pl:Freeze(true)
			pl:GodEnable()
		end
	end)
end)

-- In ze_ the winning condition is when all players on the zombie team are dead at the exact same time.
-- Usually set on by a trigger_hurt that takes over the entire map.
-- So if all living zombies get killed at the same time from a trigger_hurt that did massive damage, we end the round in favor of the humans.
-- But in order to do that we have to force zombies to spawn. Which is shitty.

hook.Add("OnWaveStateChanged", "zombieescape", function()
	if GAMEMODE:GetWave() == 1 and GAMEMODE:GetWaveActive() then
		for _, pl in pairs(player.GetAll()) do
			pl:Freeze(false)
			pl:GodDisable()
		end
	end
end)

local CheckTime
local FreezeTime = true
local NextDamage = 0
hook.Add("Think", "zombieescape", function()
	if GAMEMODE:GetWave() == 0 then
		if FreezeTime and CurTime() >= GAMEMODE:GetWaveStart() - GAMEMODE.ZE_FreezeTime then
			FreezeTime = false

			game.CleanUpMap(false, GAMEMODE.CleanupFilter)
			gamemode.Call("InitPostEntityMap", true)

			for _, pl in pairs(team.GetPlayers(TEAM_HUMAN)) do
				pl.ZEFreeze = nil
				pl:Freeze(false)
				pl:GodDisable()
				local ent = GAMEMODE:PlayerSelectSpawn(pl)
				if IsValid(ent) then
					pl:SetPos(ent:GetPos())
				end
			end
		end

		return
	end

	FreezeTime = true

	if CurTime() >= GAMEMODE:GetWaveStart() + GAMEMODE.ZE_TimeLimit and CurTime() >= NextDamage then
		NextDamage = CurTime() + 1

		for _, pl in pairs(team.GetPlayers(TEAM_HUMAN)) do
			pl:TakeDamage(5)
		end
	end

	local undead = team.GetPlayers(TEAM_UNDEAD)
	if #undead == 0 then return end

	for _, pl in pairs(undead) do
		if not pl.KilledByTriggerHurt or CurTime() > pl.KilledByTriggerHurt + 12 then
			CheckTime = nil
			return
		end
	end

	CheckTime = CheckTime or (CurTime() + 2.5)

	if CheckTime and CurTime() >= CheckTime then
		gamemode.Call("EndRound", TEAM_HUMAN)
	end
end)

hook.Add("DoPlayerDeath", "zombieescape", function(pl, attacker, dmginfo)
	pl.KilledPos = pl:GetPos()

	if pl:Team() == TEAM_UNDEAD then
		if attacker:IsValid() and attacker:GetClass() == "trigger_hurt" and not attacker:GetParent():IsValid() --[[and dmginfo:GetDamage() >= 1000]] then
			pl.KilledByTriggerHurt = CurTime()
			pl.NextSpawnTime = CurTime() + 10
		elseif GAMEMODE.RoundEnded then
			pl.NextSpawnTime = CurTime() + 9999
		else
			pl.NextSpawnTime = CurTime() + 5
		end
	end
end)
