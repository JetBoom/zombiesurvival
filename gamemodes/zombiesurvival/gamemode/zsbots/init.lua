-- unobstructed path has a flaw where people in the air are considered a straight path (on ground check?)
-- have an icon that indicates they're a bot?
-- give them a better class?

ZSBOTS = {}

local TEAM_HUMAN = TEAM_HUMAN
local RealTime = RealTime
local CurTime = CurTime
local IN_ATTACK = IN_ATTACK
local IN_JUMP = IN_JUMP
local IN_DUCK = IN_DUCK
local IN_FORWARD = IN_FORWARD
local IN_MOVELEFT = IN_MOVELEFT
local IN_MOVERIGHT = IN_MOVERIGHT
local util_TraceEntity = util.TraceEntity
local Path = Path

local Bots = {}
function ZSBOTS:GetBots()
	return Bots
end

local eyepos

local function SortObstructions(posa, posb)
	return posa:DistToSqr(eyepos) < posb:DistToSqr(eyepos)
end

local target
local obstrace = {mask = MASK_PLAYERSOLID, filter = function(ent) return ent ~= target and not ent:IsPlayer() end}
function ZSBOTS.StartCommand(pl, cmd)
	if not pl.IsZSBot or not pl:OldAlive() then return end

	local buttons = 0

	if pl.HoldDuckUntil then
		if CurTime() > pl.HoldDuckUntil then
			pl.HoldDuckUntil = nil
		else
			buttons = bit.bor(buttons, IN_DUCK)
		end
	end

	if pl.ShouldJump then
		pl.ShouldJump = false

		buttons = bit.bor(buttons, IN_JUMP)

		pl.HoldDuckUntil = CurTime() + 1
	end

	local mypos = pl:GetPos()
	eyepos = pl:EyePos()

	target = pl.CurrentEnemy
	local destination = pl.MovementTarget
	local targetpos
	local targetdist
	local targetunobstructed

	if target:IsValid() then
		if not destination then
			destination = target:GetPos()
		end
		targetpos = (target:WorldSpaceCenter() * 2 + target:NearestPoint(eyepos)) / 3
		targetdist = targetpos:DistToSqr(eyepos)

		--if target:VisibleVec(eyepos) then
			obstrace.start = pl:GetPos() % 1
			obstrace.endpos = target:WorldSpaceCenter()
			if not util_TraceEntity(obstrace, pl).Hit then
				targetunobstructed = true
			end
		--end
	end

	local viewang

	if destination then
		if targetunobstructed then
			if targetdist < 5000 then
				-- Check if we're "inside" the target or they're on top of us, we're on top of them.
				local eyepos2d = Vector() eyepos2d:Set(eyepos) eyepos2d.z = 0
				local targetpos2d = Vector() targetpos2d:Set(targetpos) targetpos2d.z = 0
				if eyepos2d:DistToSqr(targetpos2d) < 2000 then
					buttons = bit.bor(buttons, IN_BACK)
					cmd:SetForwardMove(-10000)

					viewang = pl:EyeAngles()
					if eyepos.z < targetpos.z then
						-- They're on top of us.
						viewang.pitch = -89
					else
						-- We're on top of them.
						viewang.pitch = 89
						buttons = bit.bor(buttons, IN_DUCK)
					end
				else
					-- No but we're very close, so start doing anti-juke measures.
					buttons = bit.bor(buttons, IN_FORWARD)
					cmd:SetForwardMove(10000)

					viewang = (targetpos - eyepos):Angle()
					viewang.roll = 0

					local target_vel2d = target:GetVelocity()
					target_vel2d.z = 0
					targetpos = targetpos + --[[FrameTime() * 2 *]] target_vel2d * 1.5
				end
			else
				viewang = (destination - mypos):Angle()
				viewang.pitch = 0
				viewang.roll = 0

				if destination:DistToSqr(mypos) > 256 then
					buttons = bit.bor(buttons, IN_FORWARD)
					cmd:SetForwardMove(10000)
				end
			end

			local strafe_randomness = (CurTime() + pl:EntIndex() * 0.2) % 1 + math.Rand(0, 1)
			if strafe_randomness < 0.5 then
				buttons = bit.bor(buttons, IN_MOVELEFT)
				cmd:SetSideMove(-10000)
			elseif strafe_randomness > 1.5 then
				buttons = bit.bor(buttons, IN_MOVERIGHT)
				cmd:SetSideMove(10000)
			end
		else
			viewang = (destination - mypos):Angle()
			viewang.pitch = 0
			viewang.roll = 0

			if destination:DistToSqr(mypos) > 256 then
				buttons = bit.bor(buttons, IN_FORWARD)
				cmd:SetForwardMove(10000)
			end
		end

		local meleerange = 3600
		if targetdist then
			local wep = pl:GetActiveWeapon()
			if wep and wep:IsValid() and wep.MeleeRange then
				meleerange = wep.MeleeRange * wep.MeleeRange --+ 128
			end
			if targetdist <= meleerange then
				buttons = bit.bor(buttons, IN_ATTACK)
			end
		end

		if CurTime() <= pl.UnStuckTime then
			if CurTime() % 2 < 0.5 then
				buttons = bit.bor(buttons, IN_MOVELEFT)
				cmd:SetSideMove(-10000)
			else
				buttons = bit.bor(buttons, IN_MOVERIGHT)
				cmd:SetSideMove(10000)
			end

			buttons = bit.bor(buttons, IN_ATTACK)

			-- Break obstructions.
			if not targetunobstructed and (not targetdist or targetdist > meleerange) then
				local obstruction_positions = {}
				local obstruction_position

				for _, ent in pairs(ents.FindInSphere(eyepos, math.sqrt(meleerange))) do
					if ent:GetClass() == "func_breakable" or ent:IsBarricadeProp() or (ent:GetMoveType() == MOVETYPE_VPHYSICS and ent:GetPhysicsObject():IsValid() and ent:GetPhysicsObject():IsMoveable()) --[[and ent:VisibleVec(eyepos)]] then
						local nearest = ent:NearestPoint(eyepos)
						if nearest == vector_origin then nearest = ent:WorldSpaceCenter() end
						table.insert(obstruction_positions, (nearest * 2 + ent:WorldSpaceCenter()) / 3)
					end
				end

				table.sort(obstruction_positions, SortObstructions)

				if obstruction_positions[2] then
					obstruction_position = obstruction_positions[math.random(1, math.min(3, #obstruction_positions))]
				else
					obstruction_position = obstruction_positions[1]
				end

				if obstruction_position then
					viewang = (obstruction_position - eyepos):Angle()
					viewang.roll = 0

					--[[buttons = bit.bor(buttons, IN_FORWARD)
					cmd:SetForwardMove(10000)]]
				end
			end
		end
	end

	if viewang then --viewang = viewang or angle_zero
		cmd:SetViewAngles(viewang)
		pl:SetEyeAngles(viewang)
	end

	cmd:SetButtons(buttons)
end

function ZSBOTS.PlayerTick(pl, mv)
	if not pl.IsZSBot then return end

	pl.NB:SetPos(pl:GetPos() % 8)
	pl.NB:SetLocalVelocity(vector_origin)

	if not pl:OldAlive() then return end

	if pl:Team() == TEAM_HUMAN then
		-- "suicide" since we only want to be a zombie
		pl:Kill()
	else
		-- We don't update our path every frame because it would be excessive.
		-- We move directly towards a player if we're very near and visible so that's okay.
		if CurTime() >= pl.NextPathUpdate then
			pl.NextPathUpdate = CurTime() + 0.1
			pl:UpdateBotPath()
		end

		if CurTime() > pl.UnStuckTime and mv:GetVelocity():Length2DSqr() < 4096 then
			pl.StuckFrames = pl.StuckFrames + 1
			if pl.StuckFrames >= 10 then
				pl.UnStuckTime = CurTime() + 1
				pl.StuckFrames = 0
			end
		else
			pl.StuckFrames = 0
		end
	end
end

local temp_bot_pos
local function SortPathableTargets(enta, entb)
	local dista = enta:GetPos():DistToSqr(temp_bot_pos)
	dista = dista + enta._temp_bot_dist_add
	dista = dista * enta._temp_bot_dist_mul
	local distb = entb:GetPos():DistToSqr(temp_bot_pos)
	distb = distb + entb._temp_bot_dist_add
	distb = distb * entb._temp_bot_dist_mul

	return dista < distb
end

local NextBotTick = 0
function ZSBOTS.Think()
	for _, bot in ipairs(Bots) do
		if not bot:OldAlive() then
			gamemode.Call("PlayerDeathThink", bot)
		end
	end

	if CurTime() < NextBotTick then return end
	NextBotTick = CurTime() + 0.25

	-- This is significantly cheaper than pathfinding to all valid targets.
	for _, bot in pairs(Bots) do
		bot.PathableTargets = {}

		for __, pl in ipairs(player.GetAll()) do
			if pl:Team() == TEAM_HUMAN and pl:OldAlive() and pl:GetObserverMode() == OBS_MODE_NONE then
				table.insert(bot.PathableTargets, pl)
			elseif pl:IsBot() and not pl:OldAlive() then
				gamemode.Call("PlayerDeathThink", pl)
			end
		end

		--[[for _, ent in pairs(ents.FindByClass("prop_*")) do
			if ent:IsBarricadeProp() and ent:HumanNearby() then table.insert(bot.PathableTargets, ent) end
		end]]

		--[[for _, ent in pairs(ents.FindByClass("func_breakable*")) do
			if ent:HumanNearby() then table.insert(bot.PathableTargets, ent) end
		end]]

		--[[for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
			if not ent:GetSigilCorrupted() then table.insert(bot.PathableTargets, ent) end
		end]]

		temp_bot_pos = bot:GetPos()
		obstrace.start = temp_bot_pos % 1

		local dist_add, dist_mul
		for __, target in ipairs(bot.PathableTargets) do
			obstrace.endpos = target:WorldSpaceCenter()

			dist_add = 0
			dist_mul = 1

			-- Favor people with low health
			if target:IsPlayer() then
				if target:Health() < 50 then dist_add = dist_add - 75 end

				-- Greatly favor people that are visible
				obstrace.endpos = target:WorldSpaceCenter()
				if --[[target:VisibleVec(eyepos)]] not util_TraceEntity(obstrace, bot).Hit then
					dist_mul = dist_mul / 2
				end

				-- Favor current enemy
				if target == bot.CurrentEnemy then dist_add = dist_add - 50 end
			else
				-- Unfavor non-players
				dist_add = dist_add + 128
			end

			--[[if target.TargetPriority then
				distadd = distadd / target.TargetPriority
			end
			if target.TargetExtraPriority then
				distadd = distadd - target.TargetExtraPriority
			end]]

			target._temp_bot_dist_add = dist_add
			target._temp_bot_dist_mul = dist_mul
		end

		table.sort(bot.PathableTargets, SortPathableTargets)
	end
end

local autonameindex = 0
function ZSBOTS:CreateBot(teamid, name)
	if game.SinglePlayer() then return end

	if not navmesh.IsLoaded() then
		print("No navmesh - can't create bot")
		return
	end

	if not name then
		autonameindex = autonameindex + 1
		name = "Player "..autonameindex
	end

	name = "BOT "..name

	ZSBOT = true

	local pl = player.CreateNextBot(name)
	if pl:IsValid() then
		pl.IsZSBot = true

		pl:ChangeTeam(teamid)
		pl:Spawn()

		local nb = ents.Create("zsbotnb")
		nb:SetPos(pl:GetPos())
		nb:Spawn()
		nb:SetOwner(pl)
		pl:DeleteOnRemove(nb)
		pl.NB = nb
		nb.PL = pl

		pl.CurrentEnemy = NULL
		pl.TargetAcquireTime = 0
		pl.StuckFrames = 0
		pl.UnStuckTime = 0
		pl.NextPathUpdate = 0
		pl.PathableTargets = {}

		pl.PointsMultiplier = 0.5
		pl.VoiceSet = "male"

		table.insert(Bots, pl)

		self:AddOrRemoveHooks()
	end

	ZSBOT = false
end

local randomtaunts = {
	"dang owned :remnic:",
	"woooooow killed by a bot",
	":ez:",
	"fucking owned lol :ez::gg:",
	":dsp drot=-90 rotrate=60::gunl drot=25 rotrate=130::ahhahahaha c=255,0,0::youdied:"
}
function ZSBOTS.PostZombieKilledHuman(pl, attacker, inflictor, dmginfo, headshot, suicide)
	if attacker.IsZSBot then
		attacker:Say(table.Random(randomtaunts))
	end
end

function ZSBOTS.PrePlayerRedeemed(pl)
	if pl.IsZSBot then return true end -- Disallow redeeming
end

function ZSBOTS:AddOrRemoveHooks()
	if #Bots == 0 then
		hook.Remove("StartCommand", "zsbots")
		hook.Remove("Think", "zsbots")
		hook.Remove("PlayerTick", "zsbots")
		hook.Remove("PostZombieKilledHuman", "zsbots")
		hook.Remove("PrePlayerRedeemed", "zsbots")
	else
		hook.Add("StartCommand", "zsbots", self.StartCommand)
		hook.Add("Think", "zsbots", self.Think)
		hook.Add("PlayerTick", "zsbots", self.PlayerTick)
		hook.Add("PostZombieKilledHuman", "zsbots", self.PostZombieKilledHuman)
		hook.Add("PrePlayerRedeemed", "zsbots", self.PrePlayerRedeemed)
	end
end

hook.Add("PlayerDisconnect", "zsbots", function(pl)
	if pl:IsBot() then
		table.RemoveByValue(Bots, pl)

		ZSBOTS:AddOrRemoveHooks()
	end
end)

local meta = FindMetaTable("Player")
if not meta then return end

function meta:SetCurrentEnemy(enemy)
	if not enemy or not enemy:IsValid() then enemy = NULL end

	if self.CurrentEnemy ~= enemy then
		local old_enemy = self.CurrentEnemy
		self.CurrentEnemy = enemy
		self:EnemyChanged(old_enemy)
	end
end

function meta:ClearCurrentEnemy()
	self:SetCurrentEnemy(NULL)
end

function meta:SetMovementTarget(vec)
	self.MovementTarget = vec
end

function meta:ClearMovementTarget()
	self:SetMovementTarget(nil)
end

local loco
--local compute_pl
local compute_step_height
local function Compute(area, fromArea, ladder, elevator, length)
	-- first area in path, no cost
	if not fromArea or not fromArea:IsValid() then
		return 0
	end

	-- our locomotor says we can't move here
	--[[if not loco:IsAreaTraversable(area) then
		return -1
	end]]

	if area:HasAttributes(NAV_MESH_INVALID) then return -1 end
	if area:HasAttributes(NAV_MESH_AVOID) then return -1 end
	--[[if area:HasAttributes(NAV_MESH_NO_MERGE) then return -1 end
	if area:HasAttributes(NAV_MESH_NAV_BLOCKER) then return -1 end]]

	if not area:IsVisible(fromArea:GetClosestPointOnArea(area:GetCenter())) then
		return -1
	end

	-- compute distance traveled along path so far
	local dist = 0

	if ladder and ladder:IsValid() then
		dist = ladder:GetLength()
	elseif length > 0 then
		dist = length -- optimization to avoid recomputing length
	else
		dist = (area:GetCenter() - fromArea:GetCenter()):Length()
	end

	local cost = dist + fromArea:GetCostSoFar()

	--[[if not fromArea:IsConnected(area) then
		-- Use unconnected areas only as a last resort
		cost = cost + 10 * dist
	elseif not area:IsVisible(temp_bot_pos) then
		-- Penalty for not visible areas
		cost = cost + 2 * dist
	end]]

	-- check height change
	local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange(area)
	if deltaZ >= compute_step_height then
		if deltaZ >= 64 then
			return -1 -- too high to reach
		end

		-- jumping is slower than flat ground
		cost = cost + 2 * dist
	elseif deltaZ < -2000 then
		return -1 -- too far to drop
	end

	return cost
end

local pathlength
function meta:UpdateBotPath()
	-- Nothing to kill
	if #self.PathableTargets == 0 then
		self:ClearCurrentEnemy()
		self:ClearMovementTarget()
		return
	end

	local length = 10000
	local path, tpath, new_enemy

	loco = self.NB.loco
	--compute_pl = self
	compute_step_height = self:GetStepSize()

	--temp_bot_pos = self:EyePos()

	-- Find the target with the shortest route.
	-- This is presorted without path distance in the tick function so this won't always be accurate but it needs to be cheap.
	for i, ent in pairs(self.PathableTargets) do
		tpath = Path("Follow")
		--tpath:Invalidate()
		tpath:SetMinLookAheadDistance(300)
		tpath:SetGoalTolerance(20)
		tpath:Compute(self.NB, ent:GetPos(), Compute)

		pathlength = tpath:GetLength()

		if tpath:IsValid() and pathlength < length --[[and tpath:LastSegment().pos:DistToSqr(ent:GetPos()) <= 4096]] then
			path = tpath
			length = pathlength
			new_enemy = ent
		end

		-- This amount of tries is enough.
		if i >= 4 --[[or length < 128]] then break end
	end

	self:SetCurrentEnemy(new_enemy)
	self:ClearMovementTarget()

	if not new_enemy then return end

	path:Draw()

	-- Find the first segment not immediately near us
	local goal = path:GetCurrentGoal()
	if not goal then return end

	self:SetMovementTarget(self:GetPos() + goal.forward * 32)

	-- Have to look ahead to the next segment for jumping, ducking, etc.
	if goal.length < 48 then
		goal = path:GetAllSegments()[2]
		if goal and (goal.type == 2 or goal.type == 3) then
			self.ShouldJump = true
		end
	end
end

function meta:EnemyChanged(old_enemy)
	self.TargetAcquireTime = CurTime()
	if not self.CurrentEnemy:IsValid() then
		self:OnTargetLost()
	end
end

function meta:OnTargetLost()
end

function meta:HasBeenTrackingTargetFor(time)
	return self.CurrentEnemy:IsValid() and CurTime() >= self.TargetAcquireTime + time
end

concommand.Add("createnavmesh", function(sender, command, arguments)
	if sender:IsSuperAdmin() and not game.IsDedicated() then
		if sender:GetObserverMode() == OBS_MODE_NONE and sender:IsOnGround() and sender:OnGround() then
			for _, ent in pairs(ents.FindByClass("func_door*")) do
				ent:Fire("open", "", 0)
				ent:Fire("kill", "", 1)
			end
			for _, ent in pairs(ents.FindByClass("prop_door*")) do
				ent:Fire("open", "", 0)
				ent:Fire("kill", "", 1)
			end
			for _, ent in pairs(ents.FindByClass("prop_physics*")) do
				ent:Remove()
			end
			for _, ent in pairs(ents.FindByClass("func_breakable")) do
				ent:Remove()
			end
			for _, ent in pairs(ents.FindByClass("func_physbox")) do
				ent:Remove()
			end
			local ent = ents.Create("info_player_start")
			if ent:IsValid() then
				ent:SetPos(sender:GetPos())
				ent:Spawn()
				timer.Simple(2, function() navmesh.BeginGeneration() end)
			end
		else
			print("You must be firmly planted on the ground.")
		end
	end
end)

local ENT = {}

ENT.Type = "nextbot"
ENT.Base = "base_nextbot"

ENT.IsZSBot = true

function ENT:Initialize()
	self:AddEFlags(EFL_SERVER_ONLY + EFL_FORCE_CHECK_TRANSMIT)

	self.BaseClass.Initialize(self)

	self:DrawShadow(false)
	self:SetModel("models/player/zombie_classic.mdl")
	self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72))
	self:SetSolidMask(MASK_PLAYERSOLID)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged() --self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	--self.loco:SetStepHeight(18)
	self.loco:SetDeathDropHeight(2000)
	self.loco:SetJumpHeight(64)
	self.loco:SetAcceleration(900)
	self.loco:SetDeceleration(900)
end

function ENT:OnKilled(dmginfo)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_NONE
end

function ENT:ShouldNotCollide(ent)
	return ent.IsZSBot
end

function ENT:RunBehaviour()
	-- dummy, does nothing
end

scripted_ents.Register(ENT, "zsbotnb")
