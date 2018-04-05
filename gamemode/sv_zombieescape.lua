AddCSLuaFile("cl_zombieescape.lua")
AddCSLuaFile("sh_zombieescape.lua")

include("sh_zombieescape.lua")

if not GM.ZombieEscape then return end

table.insert(GM.CleanupFilter, "func_brush")
table.insert(GM.CleanupFilter, "env_global")
table.insert(GM.CleanupFilter, "info_player_terrorist")
table.insert(GM.CleanupFilter, "info_player_counterterrorist")

-- Map CS:S player model attachments to their closest GMod equivalent
local attachmentFallbackMap = {
	forward = "eyes",
	grenade0 = "eyes",
	grenade1 = "eyes",
	grenade2 = "eyes",
	pistol = "eyes",
	primary = "eyes",
	defusekit = "eyes",
	eholster = "eyes",
	rfoot = "eyes",
	lfoot = "eyes",
	muzzle_flash = "eyes"
}

local function fixPlayerAttachment(value)
	local startIdx, endIdx, attachmentName = value:lower():find("^.-,setparentattachment,(.-),")

	if startIdx and attachmentFallbackMap[attachmentName] then
		local fixedName = attachmentFallbackMap[attachmentName]

		startIdx = endIdx - attachmentName:len()
		return value:sub(1, startIdx - 1) .. fixedName .. value:sub(endIdx)
	end
end

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
	if (ent:GetClass() == "trigger_multiple" or ent:GetClass() == "trigger_once") and string.find(string.lower(value), "%!.*%,.+%,health") then
		ent.ZEDelete = true
	end

	-- Fix SetParentAttachment using CS:S player model attachment names
	if (value:lower():find("setparentattachment")) then
		local fixedOutput = fixPlayerAttachment(value)
		if fixedOutput then
			return fixedOutput
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
			GAMEMODE:SetWaveStart(CurTime() + GAMEMODE.ZE_FreezeTime + 5)
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
		if attacker:IsValid() and attacker:GetClass() == "trigger_hurt" --[[and dmginfo:GetDamage() >= 1000]] then
			pl.KilledByTriggerHurt = CurTime()
			pl.NextSpawnTime = CurTime() + 10
		elseif GAMEMODE.RoundEnded then
			pl.NextSpawnTime = CurTime() + 9999
		else
			pl.NextSpawnTime = CurTime() + 5
		end
	end
end)

util.AddNetworkString("BossDefeated")
util.AddNetworkString("BossSpawn")
util.AddNetworkString("BossTakeDamage")

/*---------------------------------------------------------
	Boss Object
---------------------------------------------------------*/
BOSS_MATH		= 1
BOSS_PHYSBOX	= 2

local BOSS = {}

function BOSS:Setup(name, modelEnt, counterEnt)

	local boss = {}

	setmetatable( boss, self )
	self.__index = self

	boss.Name = name
	boss:Reset()

	boss.Targets = {}
	boss.Targets.Model = modelEnt
	boss.Targets.Counter = counterEnt

	return boss

end

function BOSS:IsValid()
	return IsValid( self:GetCounter() ) and
		IsValid( self:GetClientModel() ) and
		self:GetType() != -1 --and
		-- self.KilledOnRound != GAMEMODE:GetRound()
end

function BOSS:Reset()
	self.Type = -1
	self.bInitialized = nil
	self.Entities = {}
end

function BOSS:HasCounter(ent)
	return self.Targets.Counter == ent:GetName()
end

function BOSS:Health()
	if self:GetType() == BOSS_MATH then
		return IsValid(self.Entities.Counter) and self.Entities.Counter:GetOutValue() or -1
	elseif self:GetType() == BOSS_PHYSBOX then
		if !IsValid(self.Entities.Counter) then return -1 end

		-- Update max health
		local health = self.Entities.Counter:Health()
		if !self._MaxHealth or health > self._MaxHealth then
			self._MaxHealth = health
		end

		return health
	end
end

function BOSS:MaxHealth()
	if self:GetType() == BOSS_MATH then
		return IsValid(self.Entities.Counter) and self.Entities.Counter.m_InitialValue or -1
	elseif self:GetType() == BOSS_PHYSBOX then
		return IsValid(self.Entities.Counter) and self._MaxHealth or self:Health()
	end
end

function BOSS:GetType()
	return self.Type or -1
end

function BOSS:GetCounterTarget()
	return self.Targets.Counter
end

function BOSS:GetModelTarget()
	return self.Targets.Model
end

function BOSS:GetName()
	return self.Name
end

function BOSS:GetCounter()

	if self:GetType() == -1 or !IsValid(self.Entities.Counter) then

		-- Attempt to find health counter entity
		for _, v in pairs(ents.FindByName(self.Targets.Counter)) do
			if IsValid(v) and v:GetName() == self.Targets.Counter then
				if v:GetClass() == "math_counter" then
					self.Type = BOSS_MATH
				elseif v:GetClass() == "func_physbox_multiplayer" then
					self.Type = BOSS_PHYSBOX
				else
					continue -- not what we want
				end

				self.Entities.Counter = v
				break
			end
		end

	end

	return self.Entities.Counter

end

function BOSS:GetClientModel()

	if !IsValid(self.Entities.Model) then

		-- Attempt to find valid client entity
		for _, v in pairs(ents.FindByName(self.Targets.Model)) do
			if IsValid(v) and v:GetName() == self.Targets.Model then
				self.Entities.Model = v
				break
			end
		end

	end

	return self.Entities.Model

end

function BOSS:OnDamageTaken( activator )

	if !self.bInitialized then

		-- Broadcast boss spawn
		net.Start("BossSpawn")
			net.WriteFloat( self:GetClientModel():EntIndex() )
			net.WriteString( self:GetName() )
		net.Broadcast()

		self.bInitialized = true

	end

	-- Broadcast health stats
	net.Start("BossTakeDamage")
		net.WriteFloat( self:GetClientModel():EntIndex() )
		net.WriteFloat( self:Health() )
		net.WriteFloat( self:MaxHealth() )
	net.Broadcast()

	-- Output debug info
	if CVars.BossDebug:GetInt() > 0 then
		Msg("BOSS TAKE DAMAGE:\n")
		Msg("\tMath: " .. tostring(self:GetCounter()) .. "\n")
		Msg("\tProp: " .. tostring(self:GetClientModel()) .. "\n")
		Msg("\tActivator: " .. tostring(activator) .. "\n")
	end

end

function BOSS:OnDeath( activator )

	-- Announce death to players
	net.Start("BossDefeated")
		net.WriteFloat( self:GetClientModel():EntIndex() )
	net.Broadcast()

	-- Reset boss
	self.KilledOnRound = GAMEMODE:GetRound()
	self:Reset()

	-- Output debug info
	if CVars.BossDebug:GetInt() > 0 then
		Msg("BOSS DEFEATED:\n")
		Msg("\tMath: " .. tostring(self:GetCounter()) .. "\n")
		Msg("\tProp: " .. tostring(self:GetClientModel()) .. "\n")
		Msg("\tActivator: " .. tostring(activator) .. "\n")
	end

	-- Call hook for any developers looking to integrate more
	hook.Call( "OnBossDefeated", GAMEMODE, self, activator )

end


/*---------------------------------------------------------
	Bosses
---------------------------------------------------------*/

GM.Bosses = {}

GM.ValidBossEntities = {}
GM.ValidBossEntities[ "math_counter" ] 				= true
GM.ValidBossEntities[ "func_physbox_multiplayer" ] 	= true


-- AddBoss( name, model entity, math counter )
function GM:AddBoss(name, propEnt, healthEnt)

	local boss = BOSS:Setup(name,propEnt,healthEnt)
	table.insert(self.Bosses, boss)

end

-- return boss table
function GM:GetBoss(ent)

	if CVars.BossDebug:GetInt() == 2 then
		Msg("REQUESTING BOSS\n")
		Msg(ent)
		Msg("\n")
	end

	if !self.ValidBossEntities[ ent:GetClass() ] then
		return
	end

	if CVars.BossDebug:GetInt() == 1 then
		Msg("REQUESTING BOSS\n")
		Msg(ent)
		Msg("\n")
	end

	for _, boss in pairs(self.Bosses) do
		if boss:HasCounter(ent) then
			if CVars.BossDebug:GetInt() > 0 then
				Msg("FOUND BOSS\n")
				Msg(boss)
				Msg("\n")
			end
			return boss
		end
	end

	return nil

end


/*---------------------------------------------------------
	Boss Updates
---------------------------------------------------------*/
function GM:BossDamageTaken( ent, activator )

	if !IsValid(ent) then return end
	if self.NextBossUpdate && self.NextBossUpdate > CurTime() then return end -- prevent umsg spam

	local boss = self:GetBoss(ent)
	if IsValid(boss) then
		boss:OnDamageTaken( activator )
		self.NextBossUpdate = CurTime() + 0.15
	end

end

function GM:BossDeath(ent, activator)

	if !IsValid(ent) then return end

	local boss = self:GetBoss(ent)
	if IsValid(boss) and boss.bInitialized then
		boss:OnDeath( activator )
	end

end

function GM:MathCounterUpdate(ent, activator)
	self:BossDamageTaken(ent, activator)
end

function GM:MathCounterHitMin(ent, activator)
	self:BossDeath(ent, activator)
end

-- Physbox boss handling
hook.Add("EntityTakeDamage", "PhysboxTakeDamage", function( ent, dmginfo )
	GAMEMODE:BossDamageTaken(ent, dmginfo:GetAttacker())
end)

hook.Add("EntityRemoved", "PhysboxRemoved", function(ent)
	GAMEMODE:BossDeath(ent, nil)
end)