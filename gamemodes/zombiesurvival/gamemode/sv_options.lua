-- Weapon sets that humans can start with if they choose RANDOM.
GM.StartLoadouts = {
	{"pshtr", "3pcp", "2pcp", "2sgcp", "3sgcp"},
	{"btlax", "3pcp", "2pcp", "2arcp", "3arcp"},
	{"stbbr", "3rcp", "2rcp", "2pcp", "3pcp"},
	{"tossr", "3smgcp", "2smgcp", "zpplnk", "stone"},
	{"blstr", "3sgcp", "2sgcp", "csknf"},
	{"owens", "3pcp", "2pcp", "2pls", "3pls"},
	{"curativei", "medkit", "90mkit", "60mkit"},
	{"minelayer", "4mines", "6mines"},
	{"crklr", "3arcp", "2arcp", "xbow1", "xbow2"},
	{"junkpack", "12nails", "crphmr", "loadingframe"},
	{"z9000", "3pls", "2pls", "stnbtn"},
	{"sling", "xbow1", "xbow2", "2sgcp", "3sgcp"}
}


GM.BossZombies = CreateConVar("zs_bosszombies", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Summon a boss zombie in the middle of each wave break."):GetBool()
cvars.AddChangeCallback("zs_bosszombies", function(cvar, oldvalue, newvalue)
	GAMEMODE.BossZombies = tonumber(newvalue) == 1
end)

GM.OutnumberedHealthBonus = CreateConVar("zs_outnumberedhealthbonus", "4", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Give zombies some extra maximum health if there are less than or equal to this many zombies. 0 to disable."):GetInt()
cvars.AddChangeCallback("zs_outnumberedhealthbonus", function(cvar, oldvalue, newvalue)
	GAMEMODE.OutnumberedHealthBonus = tonumber(newvalue) or 0
end)

GM.PantsMode = CreateConVar("zs_pantsmode", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Only the dead can know peace from this evil."):GetBool()
cvars.AddChangeCallback("zs_pantsmode", function(cvar, oldvalue, newvalue)
	GAMEMODE:SetPantsMode(tonumber(newvalue) == 1)
end)

GM.ClassicMode = CreateConVar("zs_classicmode", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY, "No nails, no class selection, final destination."):GetBool()
cvars.AddChangeCallback("zs_classicmode", function(cvar, oldvalue, newvalue)
	GAMEMODE:SetClassicMode(tonumber(newvalue) == 1)
end)

GM.BabyMode = CreateConVar("zs_babymode", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Babby mode."):GetBool()
cvars.AddChangeCallback("zs_babymode", function(cvar, oldvalue, newvalue)
	GAMEMODE:SetBabyMode(tonumber(newvalue) == 1)
end)

GM.EndWaveHealthBonus = CreateConVar("zs_endwavehealthbonus", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Humans will get this much health after every wave. 0 to disable."):GetInt()
cvars.AddChangeCallback("zs_endwavehealthbonus", function(cvar, oldvalue, newvalue)
	GAMEMODE.EndWaveHealthBonus = tonumber(newvalue) or 0
end)

GM.GibLifeTime = CreateConVar("zs_giblifetime", "25", FCVAR_ARCHIVE, "Specifies how many seconds player gibs will stay in the world if not eaten or destroyed."):GetFloat()
cvars.AddChangeCallback("zs_giblifetime", function(cvar, oldvalue, newvalue)
	GAMEMODE.GibLifeTime = tonumber(newvalue) or 1
end)

GM.GriefForgiveness = math.ceil(100 * CreateConVar("zs_grief_forgiveness", "0.5", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Scales the damage given to griefable objects by this amount. Does not actually prevent damage, it only decides how much of a penalty to give the player. Use smaller values for more forgiving, larger for less forgiving."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_grief_forgiveness", function(cvar, oldvalue, newvalue)
	GAMEMODE.GriefForgiveness = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.GriefStrict = CreateConVar("zs_grief_strict", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Anti-griefing system. Gives points and eventually health penalties to humans who destroy friendly barricades."):GetBool()
cvars.AddChangeCallback("zs_grief_strict", function(cvar, oldvalue, newvalue)
	GAMEMODE.GriefStrict = tonumber(newvalue) == 1
end)

GM.GriefMinimumHealth = CreateConVar("zs_grief_minimumhealth", "100", FCVAR_ARCHIVE + FCVAR_NOTIFY, "The minimum health for an object to be considered griefable."):GetInt()
cvars.AddChangeCallback("zs_grief_minimumhealth", function(cvar, oldvalue, newvalue)
	GAMEMODE.GriefMinimumHealth = tonumber(newvalue) or 100
end)

GM.GriefDamageMultiplier = math.ceil(100 * CreateConVar("zs_grief_damagemultiplier", "0.5", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Multiplies damage done to griefable objects from humans by this amount."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_grief_damagemultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.GriefDamageMultiplier = math.ceil(100 * (tonumber(newvalue) or 0.5)) * 0.01
end)

GM.GriefReflectThreshold = CreateConVar("zs_grief_reflectthreshold", "-5", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Start giving damage if the player has less than this many points."):GetInt()
cvars.AddChangeCallback("zs_grief_reflectthreshold", function(cvar, oldvalue, newvalue)
	GAMEMODE.GriefReflectThreshold = tonumber(newvalue) or -5
end)

GM.MaxPropsInBarricade = CreateConVar("zs_maxpropsinbarricade", "8", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Limits the amount of props that can be in one 'contraption' of nails."):GetInt()
cvars.AddChangeCallback("zs_maxpropsinbarricade", function(cvar, oldvalue, newvalue)
	GAMEMODE.MaxPropsInBarricade = tonumber(newvalue) or 8
end)

GM.MaxDroppedItems = 48--[[CreateConVar("zs_maxdroppeditems", "48", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Maximum amount of dropped items. Prevents spam or lag when lots of people die."):GetInt()
cvars.AddChangeCallback("zs_maxdroppeditems", function(cvar, oldvalue, newvalue)
	GAMEMODE.MaxDroppedItems = tonumber(newvalue) or 48
end)]]

GM.NailHealthPerRepair = CreateConVar("zs_nailhealthperrepair", "10", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How much health a nail gets when being repaired."):GetInt()
cvars.AddChangeCallback("zs_nailhealthperrepair", function(cvar, oldvalue, newvalue)
	GAMEMODE.NailHealthPerRepair = tonumber(newvalue) or 1
end)

GM.NoPropDamageFromHumanMelee = CreateConVar("zs_nopropdamagefromhumanmelee", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Melee from humans doesn't damage props."):GetBool()
cvars.AddChangeCallback("zs_nopropdamagefromhumanmelee", function(cvar, oldvalue, newvalue)
	GAMEMODE.NoPropDamageFromHumanMelee = tonumber(newvalue) == 1
end)

GM.MedkitPointsPerHealth = 8--[[CreateConVar("zs_medkitpointsperhealth", "8", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Specifies the amount of healing for players to be given a point. For use with the medkit and such."):GetInt()
cvars.AddChangeCallback("zs_medkitpointsperhealth", function(cvar, oldvalue, newvalue)
	GAMEMODE.MedkitPointsPerHealth = tonumber(newvalue) or 1
end)]]

GM.RepairPointsPerHealth = CreateConVar("zs_repairpointsperhealth", "35", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Specifies the amount of repairing for players to be given a point. For use with nails and such."):GetInt()
cvars.AddChangeCallback("zs_repairpointsperhealth", function(cvar, oldvalue, newvalue)
	GAMEMODE.RepairPointsPerHealth = tonumber(newvalue) or 1
end)

local function GetMostKey(key, top)
	top = top or 0
	local toppl
	for _, pl in pairs(player.GetAll()) do
		if pl[key] and pl[key] > top then
			top = pl[key]
			toppl = pl
		end
	end

	if toppl and top > 0 then
		return toppl, top
	end
end

local function GetMostFunc(func, top)
	top = top or 0
	local toppl
	for _, pl in pairs(player.GetAll()) do
		local amount = pl[func](pl)
		if amount > top then
			top = amount
			toppl = pl
		end
	end

	if toppl and top > 0 then
		return toppl, top
	end
end

GM.HonorableMentions[HM_MOSTZOMBIESKILLED].GetPlayer = function(self)
	return GetMostKey("ZombiesKilled")
end

GM.HonorableMentions[HM_MOSTBRAINSEATEN].GetPlayer = function(self)
	return GetMostKey("BrainsEaten")
end

GM.HonorableMentions[HM_MOSTHEADSHOTS].GetPlayer = function(self)
	return GetMostKey("Headshots")
end

GM.HonorableMentions[HM_SCARECROW].GetPlayer = function(self)
	return GetMostKey("CrowKills")
end

GM.HonorableMentions[HM_DEFENCEDMG].GetPlayer = function(self)
	return GetMostKey("DefenceDamage")
end

GM.HonorableMentions[HM_STRENGTHDMG].GetPlayer = function(self)
	return GetMostKey("StrengthBoostDamage")
end

GM.HonorableMentions[HM_BARRICADEDESTROYER].GetPlayer = function(self)
	return GetMostKey("BarricadeDamage")
end

GM.HonorableMentions[HM_HANDYMAN].GetPlayer = function(self)
	local pl, amount = GetMostKey("RepairedThisRound")
	if pl and amount then
		return pl, math.ceil(amount)
	end
end

GM.HonorableMentions[HM_LASTHUMAN].GetPlayer = function(self)
	if self.TheLastHuman and self.TheLastHuman:IsValid() then return self.TheLastHuman end
end

GM.HonorableMentions[HM_MOSTHELPFUL].GetPlayer = function(self)
	return GetMostKey("ZombiesKilledAssists")
end

GM.HonorableMentions[HM_GOODDOCTOR].GetPlayer = function(self)
	return GetMostKey("HealedThisRound")
end

GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD].GetPlayer = function(self)
	local top = 0
	local toppl
	for _, pl in pairs(player.GetAll()) do
		if pl.DamageDealt and pl.DamageDealt[TEAM_HUMAN] > top then
			top = pl.DamageDealt[TEAM_HUMAN]
			toppl = pl
		end
	end

	if toppl and top >= 1 then
		return toppl, math.ceil(top)
	end
end

GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS].GetPlayer = function(self)
	local top = 0
	local toppl
	for _, pl in pairs(player.GetAll()) do
		if pl.DamageDealt and pl.DamageDealt[TEAM_UNDEAD] > top then
			top = pl.DamageDealt[TEAM_UNDEAD]
			toppl = pl
		end
	end

	if toppl and top >= 1 then
		return toppl, math.ceil(top)
	end
end

GM.HonorableMentions[HM_LASTBITE].GetPlayer = function(self)
	if LAST_BITE and LAST_BITE:IsValid() then
		return LAST_BITE
	end
end

GM.HonorableMentions[HM_USEFULTOOPPOSITE].GetPlayer = function(self)
	local pl, mag = GetMostFunc("Deaths")
	if mag and mag >= 30 then
		return pl, mag
	end
end

GM.HonorableMentions[HM_PACIFIST].GetPlayer = function(self)
	if WINNER == TEAM_HUMAN then
		for _, pl in pairs(player.GetAll()) do
			if pl.ZombiesKilled == 0 and pl:Team() == TEAM_HUMAN then return pl end
		end
	end
end

GM.HonorableMentions[HM_STUPID].GetPlayer = function(self)
	local dist = 99999
	local finalpl
	for _, pl in pairs(player.GetAll()) do
		if pl.ZombieSpawnDeathDistance and pl.ZombieSpawnDeathDistance < dist then
			finalpl = pl
			dist = pl.ZombieSpawnDeathDistance
		end
	end

	if finalpl and dist <= 1000 then
		return finalpl, math.ceil(dist / 12)
	end
end

GM.HonorableMentions[HM_OUTLANDER].GetPlayer = function(self)
	local dist = 0
	local finalpl
	for _, pl in pairs(player.GetAll()) do
		if pl.ZombieSpawnDeathDistance and dist < pl.ZombieSpawnDeathDistance then
			finalpl = pl
			dist = pl.ZombieSpawnDeathDistance
		end
	end

	if finalpl and 8000 <= dist then
		return finalpl, math.ceil(dist / 12)
	end
end

GM.HonorableMentions[HM_SALESMAN].GetPlayer = function(self)
	return GetMostKey("PointsCommission")
end

GM.HonorableMentions[HM_WAREHOUSE].GetPlayer = function(self)
	return GetMostKey("ResupplyBoxUsedByOthers")
end

GM.HonorableMentions[HM_NESTDESTROYER].GetPlayer = function(self)
	return GetMostKey("NestsDestroyed")
end

GM.HonorableMentions[HM_NESTMASTER].GetPlayer = function(self)
	return GetMostKey("NestSpawns")
end
