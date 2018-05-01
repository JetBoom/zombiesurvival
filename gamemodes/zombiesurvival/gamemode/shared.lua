GM.Name		=	"Zombie Survival"
GM.Author	=	"William \"JetBoom\" Moodhe"
GM.Email	=	"williammoodhe@gmail.com"
GM.Website	=	"http://www.noxiousnet.com"

-- No, adding a gun doesn't make your name worth being here.
GM.Credits = {
	{"William \"JetBoom\" Moodhe", "williammoodhe@gmail.com (www.noxiousnet.com)", "Creator / Programmer"},
	{"11k", "tjd113@gmail.com", "Zombie view models"},
	{"Eisiger", "k2deseve@gmail.com", "Zombie kill icons"},
	{"Austin \"Little Nemo\" Killey", "austin_odyssey@yahoo.com", "Ambient music"},
	{"Zombie Panic: Source", "http://www.zombiepanic.org/", "Melee weapon sounds"},
	{"Samuel", "samuel_games@hotmail.com", "Board Kit models"},
	{"Typhon", "lukas-tinel@hotmail.com", "Fear-o-meter textures"},
	{"Benjy, The Darker One, Raox, Scott", "", "Code contributions"},

	{"Mr. Darkness", "", "Russian translation"},
	{"honsal", "", "Korean translation"},
	{"rui_troia", "", "Portuguese translation"},
	{"Shinyshark", "", "Dutch translation"},
	{"Kradar", "", "Italian translation"},
	{"Raptor", "", "German translation"},
	{"The Special Duckling", "", "Danish translation"},
	{"ptown, Dr. Broly", "", "Spanish translation"},

	{"Anyone else on GitHub or who I've forgotten", "", "Various contributions"},
}

if file.Exists(GM.FolderName.."/gamemode/maps/"..game.GetMap()..".lua", "LUA") then
	include("maps/"..game.GetMap()..".lua")
end

function GM:GetNumberOfWaves()
	local default = GetGlobalBool("classicmode") and 10 or self.NumberOfWaves
	local num = GetGlobalInt("numwaves", default) -- This is controlled by logic_waves.
	return num == -2 and default or num
end

function GM:GetWaveOneLength()
	return GetGlobalBool("classicmode") and self.WaveOneLengthClassic or self.WaveOneLength
end

include("obj_vector_extend.lua")
include("obj_entity_extend.lua")
include("obj_player_extend.lua")
include("obj_weapon_extend.lua")

include("sh_translate.lua")
include("sh_colors.lua")
include("sh_serialization.lua")
include("sh_util.lua")

include("skillweb/sh_skillweb.lua")

include("sh_options.lua")
include("sh_zombieclasses.lua")
include("sh_animations.lua")
include("sh_sigils.lua")
include("sh_channel.lua")
include("sh_weaponquality.lua")

include("noxapi/noxapi.lua")

include("vault/shared.lua")

include("workshopfix.lua")

include_library("perf")
include_library("player_movement")
include_library("inventory")
include_library("ammoexpand")

----------------------

GM.EndRound = false
GM.StartingWorth = 100
GM.ZombieVolunteers = {}

team.SetUp(TEAM_ZOMBIE, "The Undead", Color(0, 255, 0, 255))
team.SetUp(TEAM_SURVIVORS, "Survivors", Color(0, 160, 255, 255))

local validmodels = player_manager.AllValidModels()
validmodels["tf01"] = nil
validmodels["tf02"] = nil

vector_tiny = Vector(0.001, 0.001, 0.001)

-- ogg/mp3 still doesn't work with SoundDuration() function
GM.SoundDuration = {
	["zombiesurvival/music_win.ogg"] = 33.149,
	["zombiesurvival/music_lose.ogg"] = 45.714,
	["zombiesurvival/lasthuman.ogg"] = 120.503,

	["zombiesurvival/beats/defaulthuman/1.ogg"] = 7.111,
	["zombiesurvival/beats/defaulthuman/2.ogg"] = 7.111,
	["zombiesurvival/beats/defaulthuman/3.ogg"] = 7.111,
	["zombiesurvival/beats/defaulthuman/4.ogg"] = 7.111,
	["zombiesurvival/beats/defaulthuman/5.ogg"] = 7.111,
	["zombiesurvival/beats/defaulthuman/6.ogg"] = 14.222,
	["zombiesurvival/beats/defaulthuman/7.ogg"] = 14.222,
	["zombiesurvival/beats/defaulthuman/8.ogg"] = 7.111,
	["zombiesurvival/beats/defaulthuman/9.ogg"] = 14.222,

	["zombiesurvival/beats/defaultzombiev2/1.ogg"] = 8,
	["zombiesurvival/beats/defaultzombiev2/2.ogg"] = 8,
	["zombiesurvival/beats/defaultzombiev2/3.ogg"] = 8,
	["zombiesurvival/beats/defaultzombiev2/4.ogg"] = 8,
	["zombiesurvival/beats/defaultzombiev2/5.ogg"] = 8,
	["zombiesurvival/beats/defaultzombiev2/6.ogg"] = 6.038,
	["zombiesurvival/beats/defaultzombiev2/7.ogg"] = 6.038,
	["zombiesurvival/beats/defaultzombiev2/8.ogg"] = 6.038,
	["zombiesurvival/beats/defaultzombiev2/9.ogg"] = 6.038,
	["zombiesurvival/beats/defaultzombiev2/10.ogg"] = 6.038
}

local SERVER = SERVER
local CLIENT = CLIENT
local HITGROUP_HEAD = HITGROUP_HEAD
local HITGROUP_LEFTARM = HITGROUP_LEFTARM
local HITGROUP_RIGHTARM = HITGROUP_RIGHTARM
local HITGROUP_GEAR = HITGROUP_GEAR
local HITGROUP_STOMACH = HITGROUP_STOMACH
local HITGROUP_LEFTLEG = HITGROUP_LEFTLEG
local HITGROUP_RIGHTLEG = HITGROUP_RIGHTLEG
local PTeam = FindMetaTable("Player").Team

function GM:AddCustomAmmo()
	game.AddAmmoType({name = "dummy"})
	game.AddAmmoType({name = "pulse"})
	game.AddAmmoType({name = "impactmine"})
	game.AddAmmoType({name = "chemical"})
	game.AddAmmoType({name = "scrap"})

	game.AddAmmoType({name = "stone"})
	game.AddAmmoType({name = "flashbomb"})
	game.AddAmmoType({name = "betty"})
	game.AddAmmoType({name = "molotov"})
	game.AddAmmoType({name = "corgasgrenade"})
	game.AddAmmoType({name = "crygasgrenade"})
	game.AddAmmoType({name = "bloodshot"})

	game.AddAmmoType({name = "spotlamp"})
	game.AddAmmoType({name = "manhack"})
	game.AddAmmoType({name = "manhack_saw"})
	game.AddAmmoType({name = "drone"})
	game.AddAmmoType({name = "pulse_cutter"})
	game.AddAmmoType({name = "drone_hauler"})
	game.AddAmmoType({name = "rollermine"})
	game.AddAmmoType({name = "sigilfragment"})
	game.AddAmmoType({name = "corruptedfragment"})
	game.AddAmmoType({name = "mediccloudbomb"})
	game.AddAmmoType({name = "nanitecloudbomb"})
	game.AddAmmoType({name = "repairfield"})
	game.AddAmmoType({name = "zapper"})
	game.AddAmmoType({name = "zapper_arc"})
	game.AddAmmoType({name = "remantler"})
	game.AddAmmoType({name = "turret_buckshot"})
	game.AddAmmoType({name = "turret_assault"})
	game.AddAmmoType({name = "turret_rocket"})
	game.AddAmmoType({name = "camera"})
	game.AddAmmoType({name = "tv"})

	game.AddAmmoType({name = "foodwatermelon"})
	game.AddAmmoType({name = "foodorange"})
	game.AddAmmoType({name = "foodbanana"})
	game.AddAmmoType({name = "foodsoda"})
	game.AddAmmoType({name = "foodmilk"})
	game.AddAmmoType({name = "foodtakeout"})
	game.AddAmmoType({name = "foodwater"})
end

GM.Food = {}
function GM:RegisterFood()
	self.Food = {}

	for k, v in pairs(weapons.GetList()) do
		if v.Base == "weapon_zs_basefood" then
			table.insert(self.Food, v.ClassName)
		end
	end
end

function GM:RefreshMapIsObjective()
	local mapname = string.lower(game.GetMap())
	if string.find(mapname, "_obj_", 1, true) or string.find(mapname, "objective", 1, true) then
		self.ObjectiveMap = true
	else
		self.ObjectiveMap = false
	end
end

function GM:AssignItemProperties()
	for _, tab in ipairs(self.Items) do
		if tab.SWEP then
			local sweptab = self.ZSInventoryItemData[tab.SWEP] or weapons.Get(tab.SWEP)
			if sweptab then
				if not tab.Description then
					tab.Description = sweptab.Description
				end
				if not tab.Tier then
					tab.Tier = sweptab.Tier
				end
				if not tab.MaxStock then
					tab.MaxStock = sweptab.MaxStock
				end
				if tab.Name == "?" then
					tab.Name = sweptab.PrintName or tab.Name
				end
			end
		end
	end
end

-- Utility function to setup a weapon's DefaultClip.
function GM:SetupDefaultClip(tab)
	tab.DefaultClip = math.ceil(tab.ClipSize * self.SurvivalClips * (tab.ClipMultiplier or 1))
end

-- Some weapons are derived from weapon_base and try to make use of .Owner
function GM:FixWeaponBase()
	local base = weapons.GetStored("weapon_base")

	base.TranslateActivity = function(me)
		if me.ActivityTranslate[act] ~= nil then
			return me.ActivityTranslate[act]
		end

		return -1
	end

	base.TakePrimaryAmmo = function(me, num)
		if me.Weapon:Clip1() <= 0 then
			if me:Ammo1() <= 0 then return end

			me:GetOwner():RemoveAmmo(num, me.Weapon:GetPrimaryAmmoType())

			return
		end

		me.Weapon:SetClip1(me.Weapon:Clip1() - num)
	end

	base.Ammo1 = function(me)
		return me:GetOwner():GetAmmoCount(me.Weapon:GetPrimaryAmmoType())
	end
end

function GM:GetRedeemBrains()
	return GetGlobalInt("redeembrains", self.DefaultRedeem)
end

function GM:PlayerIsAdmin(pl)
	return pl:IsAdmin()
end

function GM:GetFallDamage(pl, fallspeed)
	return 0 -- Handled in OnPlayerHitGround
end

function GM:ValidMenuLockOnTarget(pl, ent)
	if ent and ent:IsValidLivingHuman() then
		local startpos = pl:EyePos()
		local endpos = ent:NearestPoint(startpos)
		if startpos:DistToSqr(endpos) <= 2304 and TrueVisible(startpos, endpos) then -- 48^2
			return true
		end
	end

	return false
end

function GM:GetHandsModel(pl)
	return player_manager.TranslatePlayerHands(player_manager.TranslateToPlayerModelName(pl:GetModel()))
end

function GM:GetBestAvailableZombieClass(baseclass_id)
	if self:ShouldUseBetterVersionSystem() then
		local baseclass

		while true do
			baseclass = self.ZombieClasses[baseclass_id]
			if baseclass and baseclass.BetterVersion and self:IsClassUnlocked(baseclass.BetterVersion) then
				baseclass_id = baseclass.BetterVersion
			else
				break
			end
		end
	end

	return self.ZombieClasses[baseclass_id].Index
end

function GM:ShouldUseBetterVersionSystem()
	return not self.ObjectiveMap
end

local playerheight = Vector(0, 0, 72)
local playermins = Vector(-17, -17, 0)
local playermaxs = Vector(17, 17, 4)
local SkewedDistance = util.SkewedDistance

GM.DynamicSpawnDistVisOld = 2048
GM.DynamicSpawnDistOld = 640
function GM:DynamicSpawnIsValidOld(zombie, humans, allplayers)
	-- I didn't make this check where trigger_hurt entities are. Rather I made it check the time since the last time you were hit with a trigger_hurt.
	-- I'm not sure if it's possible to check if a trigger_hurt is enabled or disabled through the Lua bindings.
	if SERVER and zombie.LastHitWithTriggerHurt and CurTime() < zombie.LastHitWithTriggerHurt + 2 then
		return false
	end

	local hpos, nearest, dist

	-- Optional caching for these.
	if not humans then humans = team.GetPlayers(TEAM_HUMAN) end
	if not allplayers then allplayers = player.GetAll() end

	local pos = zombie:GetPos() + Vector(0, 0, 1)
	if zombie:Alive() and zombie:GetMoveType() == MOVETYPE_WALK and zombie:OnGround()
	and not util.TraceHull({start = pos, endpos = pos + playerheight, mins = playermins, maxs = playermaxs, mask = MASK_SOLID, filter = allplayers}).Hit then
		local vtr = util.TraceHull({start = pos, endpos = pos - playerheight, mins = playermins, maxs = playermaxs, mask = MASK_SOLID_BRUSHONLY})
		if not vtr.HitSky and not vtr.HitNoDraw then
			local valid = true

			for _, human in pairs(humans) do
				hpos = human:GetPos()
				nearest = zombie:NearestPoint(hpos)
				dist = SkewedDistance(hpos, nearest, 2.75) -- We make it so that the Z distance between a human and a zombie is skewed if the zombie is below the human.
				if dist <= self.DynamicSpawnDistOld or dist <= self.DynamicSpawnDistVisOld and WorldVisible(hpos, nearest) then -- Zombies can't be in radius of any humans. Zombies can't be clearly visible by any humans.
					valid = false
					break
				end
			end

			return valid
		end
	end

	return false
end

function GM:GetBestDynamicSpawnOld(pl, pos)
	local spawns = self:GetDynamicSpawnsOld(pl)
	if #spawns == 0 then return end

	return self:GetClosestSpawnPoint(spawns, pos or self:GetTeamEpicentre(TEAM_HUMAN)) or table.Random(spawns)
end

function GM:GetDynamicSpawnsOld(pl)
	local tab = {}

	local allplayers = player.GetAll()
	local humans = team.GetPlayers(TEAM_HUMAN)
	for _, zombie in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		if zombie ~= pl and self:DynamicSpawnIsValidOld(zombie, humans, allplayers) then
			table.insert(tab, zombie)
		end
	end

	return tab
end

GM.DynamicSpawnDist = 512
GM.DynamicSpawnDistVis = 2048
GM.CreeperNestDist = 150
GM.CreeperNestDistBuild = 420
GM.CreeperNestDistBuildNest = 192
GM.CreeperNestDistBuildZSpawn = 256
local trace_dynspawn = {mins = playermins, maxs = playermaxs, mask = MASK_SOLID}
local trace_dynspawn_skybox = {mins = playermins, maxs = playermaxs, mask = MASK_SOLID_BRUSHONLY}
function GM:DynamicSpawnIsValid(ent, humans, allplayers)
	if self:ShouldUseAlternateDynamicSpawn() then
		return self:DynamicSpawnIsValidOld(ent, humans, allplayers)
	end

	-- Optional caching for these.
	if not humans then humans = team.GetPlayers(TEAM_HUMAN) end
	if not allplayers then allplayers = player.GetAll() end

	local pos = ent:GetPos() + Vector(0, 0, 1)
	local is_nest = ent:GetClass() == "prop_creepernest"
	local required_distance = is_nest and self.CreeperNestDist or self.DynamicSpawnDist -- Nests have a shorter distance and no visibility requirement.

	--if ent.GetNestBuilt and ent:GetNestBuilt() and not util.TraceHull({start = pos, endpos = pos + playerheight, mins = playermins, maxs = playermaxs, mask = MASK_SOLID_BRUSHONLY}).Hit then
	if is_nest and not ent:GetNestBuilt() then
		return false
	end

	-- Check if not enough room.
	trace_dynspawn.start = pos
	trace_dynspawn.endpos = pos + playerheight
	trace_dynspawn.filter = allplayers
	table.insert(trace_dynspawn.filter, ent)
	local tr = util.TraceHull(trace_dynspawn)
	if tr.Hit then
		return false
	end

	-- No need to check this. You shouldn't be able to build a nest on top of nodraw/skybox
	-- -- Check if on top of a nodraw / skybox.
	-- trace_dynspawn_skybox.start = pos
	-- trace_dynspawn_skybox.endpos = pos - playerheight
	-- local vtr = util.TraceHull(trace_dynspawn_skybox)
	-- if vtr.HitSky or vtr.HitNoDraw then
	-- 	return false
	-- end
	-- vtr = util.TraceLine(trace_dynspawn_skybox)
	-- if vtr.HitSky or vtr.HitNoDraw then
	-- 	return false
	-- end

	-- Check if too close to a human.
	local nearest, dist
	for _, human in pairs(humans) do
		nearest = human:NearestPoint(pos)
		dist = SkewedDistance(nearest, pos, 2.75)
		if dist <= required_distance then -- We make it so that the Z distance between a human and an ent is skewed if the ent is below the human.
			return false
		end

		-- Check if visible by any human.
		if not is_nest and dist <= self.DynamicSpawnDistVis and WorldVisible(nearest, pos) then
			return false
		end
	end

	return true
end

function GM:GetBestDynamicSpawn(pl, pos)
	if self:ShouldUseAlternateDynamicSpawn() then
		return self:GetBestDynamicSpawnOld(pl, pos)
	end

	local spawns = self:GetDynamicSpawns(pl)
	if #spawns == 0 then return end

	return self:GetClosestSpawnPoint(spawns, pos or self:GetTeamEpicentre(TEAM_HUMAN)) or table.Random(spawns)
end

function GM:GetDynamicSpawns(pl)
	if self:ShouldUseAlternateDynamicSpawn() then
		return self:GetDynamicSpawnsOld(pl)
	end

	local tab = {}

	local humans = team.GetPlayers(TEAM_HUMAN)
	for _, nest in pairs(ents.FindByClass("prop_creepernest")) do
		if self:DynamicSpawnIsValid(nest, humans) then
			table.insert(tab, nest)
		end
	end

	return tab
end

function GM:GetDesiredStartingZombies()
	local numplayers = #player.GetAllActive()
	return math.Clamp(math.ceil(numplayers * self.WaveOneZombies), 1, numplayers - 1)
end

function GM:GetEndRound()
	return self.RoundEnded
end

function GM:PrecacheResources()
	util.PrecacheSound("physics/body/body_medium_break2.wav")
	util.PrecacheSound("physics/body/body_medium_break3.wav")
	util.PrecacheSound("physics/body/body_medium_break4.wav")
	for name, mdl in pairs(player_manager.AllValidModels()) do
		util.PrecacheModel(mdl)
	end

	game.AddParticles("particles/vman_explosion.pcf")

	PrecacheParticleSystem("dusty_explosion_rockets")
end

function GM:ShouldCollide(enta, entb)
	local snca = enta.ShouldNotCollide
	if snca and snca(enta, entb) then return false end

	local sncb = entb.ShouldNotCollide
	if sncb and sncb(entb, enta) then return false end

	--[[if enta.ShouldNotCollide and enta:ShouldNotCollide(entb) or entb.ShouldNotCollide and entb:ShouldNotCollide(enta) then
		return false
	end]]

	return true
end

function GM:DoChangeDeploySpeed(wep)
	if wep:IsValid() and wep.SetDeploySpeed and not wep.NoDeploySpeedChange then
		local owner = wep:GetOwner()
		wep:SetDeploySpeed(self.BaseDeploySpeed * (owner:IsValid() and owner.DeploySpeedMultiplier or 1) * (owner:IsValid() and owner:GetStatus("frost") and 0.7 or 1))
	end
end

function GM:OnPlayerHitGround(pl, inwater, hitfloater, speed)
	if inwater then return true end

	if speed > 64 then
		pl.LandSlow = true
	end

	local isundead = PTeam(pl) == TEAM_UNDEAD
	if isundead and pl:GetZombieClassTable().NoFallDamage then return true end

	local threshold_mul
	local slowdown_mul
	local recovery_mul
	local damage_mul

	if isundead then
		speed = math.max(0, speed - 200)

		threshold_mul = 1
		slowdown_mul = 1
		recovery_mul = 1
		damage_mul = 1
	else
		threshold_mul = pl.FallDamageThresholdMul or 1
		slowdown_mul = pl.FallDamageSlowDownMul or 1
		recovery_mul = pl.FallDamageRecoveryMul or 1
		damage_mul = pl.FallDamageDamageMul or 1
	end

	local damage = (0.1 * (speed - 525 * threshold_mul)) ^ 1.45
	if hitfloater then damage = damage / 2 end

	if SERVER then
		local groundent = pl:GetGroundEntity()
		if groundent:IsValid() and groundent:IsPlayer() and PTeam(groundent) == TEAM_UNDEAD and pl:HasTrinket("curbstompers") then
			if groundent:IsHeadcrab() then
				groundent:TakeSpecialDamage(groundent:Health() + 70, DMG_DIRECT, pl, pl, pl:GetPos())
			elseif groundent:IsTorso() then
				groundent:TakeSpecialDamage(50, DMG_CLUB, pl, pl, pl:GetPos())
			end

			if math.floor(damage) > 0 then
				groundent:TakeSpecialDamage(damage * 5, DMG_CLUB, pl, pl, pl:GetPos())
				return true
			end
		end
	end

	if math.floor(damage) > 0 then
		if SERVER then
			local h = pl:Health()
			pl:TakeSpecialDamage(damage * damage_mul, DMG_FALL, game.GetWorld(), game.GetWorld(), pl:GetPos())
			damage = h - pl:Health()

			if not self.ZombieEscape and damage >= 5 and pl:Health() > 0 then
				if damage >= 30 then
					pl:KnockDown(damage * 0.05 * recovery_mul)
				end
				if not isundead or not pl:GetZombieClassTable().NoFallSlowdown then
					pl:RawCapLegDamage(CurTime() + math.min(2, damage * 0.038 * slowdown_mul))
				end
			end

			pl:EmitSound("player/pl_fallpain"..(math.random(2) == 1 and 3 or 1)..".wav")
		elseif not self.ZombieEscape and damage >= 5 and (not isundead or not pl:GetZombieClassTable().NoFallSlowdown) then
			pl:RawCapLegDamage(CurTime() + math.min(2, damage * 0.038 * slowdown_mul))
		end
	end

	return true
end

function GM:PlayerCanBeHealed(pl)
	local maxhp = pl:IsSkillActive(SKILL_D_FRAIL) and math.floor(pl:GetMaxHealth() * 0.25) or pl:GetMaxHealth()

	return pl:Health() < maxhp or pl:GetPoisonDamage() > 0 or pl:GetBleedDamage() > 0
end

function GM:PlayerCanPurchase(pl)
	if CLIENT and self.CanPurchaseCacheTime and self.CanPurchaseCacheTime >= CurTime() then
		return self.CanPurchaseCache
	end
	local canpurchase = PTeam(pl) == TEAM_HUMAN and self:GetWave() > 0 and pl:Alive() and pl:NearArsenalCrate()

	if CLIENT then
		self.CanPurchaseCache = canpurchase
		self.CanPurchaseCacheTime = CurTime() + 0.5
	end
	return canpurchase
end

-- This is actually only called by the engine on the server but it's here in case the client wants to know.
local TEAM_SPECTATOR = TEAM_SPECTATOR
function GM:PlayerCanHearPlayersVoice(listener, talker)
	return PTeam(listener) == PTeam(talker) or PTeam(listener) == TEAM_SPECTATOR, false
end
GM.PlayerCanHearPlayersVoiceDefault = GM.PlayerCanHearPlayersVoice

function GM:PlayerCanHearPlayersVoiceAllTalk(listener, talker)
	return true, false
end

cvars.AddChangeCallback("sv_alltalk", function(cvar, old, new)
	GAMEMODE.PlayerCanHearPlayersVoice = new ~= "1" and GAMEMODE.PlayerCanHearPlayersVoiceDefault or  GAMEMODE.PlayerCanHearPlayersVoiceAllTalk
end)
GM.PlayerCanHearPlayersVoice = GetConVar("sv_alltalk"):GetBool() and GM.PlayerCanHearPlayersVoiceAllTalk or  GM.PlayerCanHearPlayersVoiceDefault

function GM:PlayerTraceAttack(pl, dmginfo, dir, trace)
end

function GM:GetDamageResistance(fearpower)
	if self.MaxSigils > 0 and self:GetUseSigils() then
		return fearpower * 0.1 + self:NumSigilsCorrupted() / self.MaxSigils * 0.2
	end

	return fearpower * 0.15
end

function GM:FindUseEntity(pl, ent)
	if not ent:IsValid() then
		local e = pl:TraceLine(90, MASK_SOLID, pl:GetDynamicTraceFilter()).Entity
		if e:IsValid() then return e end
	end

	return ent
end

function GM:ShouldUseAlternateDynamicSpawn()
	return self.ZombieEscape or self:IsClassicMode() or self.PantsMode or self:IsBabyMode()
end

function GM:GetZombieDamageScale(pos, ignore)
	if LASTHUMAN then return self.ZombieDamageMultiplier end

	return self.ZombieDamageMultiplier * (1 - self:GetDamageResistance(self:GetFearMeterPower(pos, TEAM_UNDEAD, ignore)))
end

local temppos
local function SortByDistance(a, b)
	return a:GetPos():DistToSqr(temppos) < b:GetPos():DistToSqr(temppos)
end

local function GetSortedSpawnPoints(teamid, pos)
	temppos = pos
	local spawnpoints
	if type(teamid) == "table" then
		spawnpoints = teamid
	else
		spawnpoints = team.GetValidSpawnPoint(teamid)
	end

	table.sort(spawnpoints, SortByDistance)
	return spawnpoints
end

function GM:GetClosestSpawnPoint(teamid, pos)
	return GetSortedSpawnPoints(teamid, pos)[1]
end

function GM:GetFurthestSpawnPoint(teamid, pos)
	local spawnpoints = GetSortedSpawnPoints(teamid, pos)
	return spawnpoints[#spawnpoints]
end

local FEAR_RANGE = 768^2
local FEAR_PERINSTANCE = 0.075
local RALLYPOINT_THRESHOLD = 0.3

local function GetEpicenter(tab)
	local vec = Vector(0, 0, 0)
	if #tab == 0 then return vec end

	for k, v in pairs(tab) do
		vec = vec + v:GetPos()
	end

	return vec / #tab
end

function GM:GetTeamRallyGroups(teamid)
	local groups = {}
	local ingroup = {}

	local plys = team.GetPlayers(teamid)
	local plpos, group

	for _, pl in pairs(plys) do
		if not ingroup[pl] and pl:Alive() then
			plpos = pl:GetPos()
			group = {pl}

			for __, otherpl in pairs(plys) do
				if otherpl ~= pl and not ingroup[otherpl] and otherpl:Alive() and otherpl:GetPos():DistToSqr(plpos) <= FEAR_RANGE then
					group[#group + 1] = otherpl
				end
			end

			if #group * FEAR_PERINSTANCE >= RALLYPOINT_THRESHOLD then
				for k, v in pairs(group) do
					ingroup[v] = true
				end
				groups[#groups + 1] = group
			end
		end
	end

	return groups
end

function GM:GetTeamRallyPoints(teamid)
	local points = {}

	for _, group in pairs(self:GetTeamRallyGroups(teamid)) do
		points[#points + 1] = {GetEpicenter(group), math.min(1, (#group * FEAR_PERINSTANCE - RALLYPOINT_THRESHOLD) / (1 - RALLYPOINT_THRESHOLD))}
	end

	return points
end

local CachedEpicentreTimes = {}
local CachedEpicentres = {}
function GM:GetTeamEpicentre(teamid, nocache)
	if not nocache and CachedEpicentres[teamid] and CurTime() < CachedEpicentreTimes[teamid] then
		return CachedEpicentres[teamid]
	end

	local plys = team.GetPlayers(teamid)
	local vVec = Vector(0, 0, 0)
	local considered = 0
	for _, pl in pairs(plys) do
		if pl:Alive() and pl:GetAuraRange() == 2048 then
			vVec = vVec + pl:GetPos()
			considered = considered + 1
		end
	end

	local epicentre = vVec / considered
	if not nocache then
		CachedEpicentreTimes[teamid] = CurTime() + 0.5
		CachedEpicentres[teamid] = epicentre
	end

	return epicentre
end
GM.GetTeamEpicenter = GM.GetTeamEpicentre

function GM:GetCurrentEquipmentCount(id)
	local count = 0

	local item = self.Items[id]
	if item then
		if item.Countables then
			if type(item.Countables) == "table" then
				for k, v in pairs(item.Countables) do
					count = count + #ents.FindByClass(v)
				end
			else
				count = count + #ents.FindByClass(item.Countables)
			end
		end

		if item.SWEP then
			count = count + #ents.FindByClass(item.SWEP)
		end
	end

	return count
end

function GM:GetFearMeterPower(pos, teamid, ignore)
	if LASTHUMAN then return 1 end

	local dist

	local power = 0

	for _, pl in pairs(player.GetAll()) do
		if pl ~= ignore and PTeam(pl) == teamid and not pl:CallZombieFunction0("DoesntGiveFear") and pl:Alive() then
			dist = pl:GetPos():DistToSqr(pos)
			if dist <= FEAR_RANGE then
				power = power + (1 - dist / FEAR_RANGE) * (pl:GetZombieClassTable().FearPerInstance or FEAR_PERINSTANCE)
			end
		end
	end

	return math.min(1, power)
end

function GM:GetRagdollEyes(pl)
	local Ragdoll = pl:GetRagdollEntity()
	if not Ragdoll then return end

	local att = Ragdoll:GetAttachment(Ragdoll:LookupAttachment("eyes"))
	if att then
		att.Pos = att.Pos + att.Ang:Forward() * -2
		att.Ang = att.Ang

		return att.Pos, att.Ang
	end
end

function GM:PlayerNoClip(pl, on)
	if pl:IsAdmin() then
		if SERVER then
			PrintMessage(HUD_PRINTCONSOLE, translate.Format(on and "x_turned_on_noclip" or "x_turned_off_noclip", pl:Name()))
		end

		if SERVER then
			pl:MarkAsBadProfile()
		end

		return true
	end

	return false
end

function GM:IsSpecialPerson(pl, image)
	local img, tooltip

	if pl:SteamID() == "STEAM_0:1:3307510" then
		img = "VGUI/steam/games/icon_sourcesdk"
		tooltip = "JetBoom\nCreator of Zombie Survival!"
	elseif pl:IsAdmin() then
		img = "VGUI/servers/icon_robotron"
		tooltip = "Admin"
	elseif pl:IsNoxSupporter() then
		img = "noxiousnet/noxicon.png"
		tooltip = "Nox Supporter"
	end

	if img then
		if CLIENT then
			image:SetImage(img)
			image:SetTooltip(tooltip)
		end

		return true
	end

	return false
end

function GM:GetWaveEnd()
	return GetGlobalFloat("waveend", 0)
end

function GM:SetWaveEnd(time)
	SetGlobalFloat("waveend", time)
end

function GM:GetWaveStart()
	return GetGlobalFloat("wavestart", self.WaveZeroLength)
end

function GM:SetWaveStart(time)
	SetGlobalFloat("wavestart", time)
end

function GM:GetWave()
	return GetGlobalInt("wave", 0)
end

if GM:GetWave() == 0 then
	GM:SetWaveStart(GM.WaveZeroLength)
	GM:SetWaveEnd(GM.WaveZeroLength + GM:GetWaveOneLength())
end

function GM:GetWaveActive()
	return GetGlobalBool("waveactive", false)
end

function GM:SetWaveActive(active)
	if self.RoundEnded then return end

	if self:GetWaveActive() ~= active then
		SetGlobalBool("waveactive", active)

		if SERVER then
			gamemode.Call("WaveStateChanged", active)
		end
	end
end

if not FixedSoundDuration then
FixedSoundDuration = true
local OldSoundDuration = SoundDuration
function SoundDuration(snd)
	if snd then
		local ft = string.sub(snd, -4)
		if ft == ".mp3" then
			return OldSoundDuration(snd) * 2.25
		end
		if ft == ".ogg" then
			return OldSoundDuration(snd) * 3
		end
	end

	return OldSoundDuration(snd)
end
end

function GM:VehicleMove()
end
