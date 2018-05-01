-- Animations are heavily optimized.

local TEAM_UNDEAD = TEAM_UNDEAD
local ACT_MP_STAND_IDLE = ACT_MP_STAND_IDLE
local ACT_MP_RUN = ACT_MP_RUN
local ACT_MP_WALK = ACT_MP_WALK
local ACT_MP_JUMP = ACT_MP_JUMP
local ACT_MP_CROUCHWALK = ACT_MP_CROUCHWALK
local ACT_MP_CROUCH_IDLE = ACT_MP_CROUCH_IDLE
local GESTURE_SLOT_JUMP = GESTURE_SLOT_JUMP
local ACT_LAND = ACT_LAND
local MOVETYPE_NOCLIP = MOVETYPE_NOCLIP
local math_min = math.min
local math_max = math.max
local CLIENT = CLIENT
local PLAYERANIMEVENT_FLINCH_HEAD = PLAYERANIMEVENT_FLINCH_HEAD
local CurTime = CurTime
local IsValid = IsValid

local M_Player = FindMetaTable("Player")
local M_Entity = FindMetaTable("Entity")
local P_Team = M_Player.Team
local P_GetZombieClassTable = M_Player.GetZombieClassTable
local P_AnimRestartGesture = M_Player.AnimRestartGesture
local P_AnimRestartMainSequence = M_Player.AnimRestartMainSequence
local P_Crouching = M_Player.Crouching
local P_DoFlinchAnim = M_Player.DoFlinchAnim
local P_IsCarrying = M_Player.IsCarrying
local P_CallZombieFunction = M_Player.CallZombieFunction
local P_Alive = M_Player.Alive
local E_OnGround = M_Entity.OnGround
local E_GetTable = M_Entity.GetTable
local E_WaterLevel = M_Entity.WaterLevel
local E_SetPlaybackRate = M_Entity.SetPlaybackRate
-- These don't get destroyed by __index like player and entity but why not have them here.
local M_Vector = FindMetaTable("Vector")
local V_Length2D = M_Vector.Length2D
local V_Length2DSqr = M_Vector.Length2DSqr
local V_LengthSqr = M_Vector.LengthSqr

local onground, tab, len2d, waterlevel, ideal, override, pt

function GM:PlayerShouldTaunt(pl, actid)
	pt = E_GetTable(pl)

	return P_Alive(pl) and (P_Team(pl) == TEAM_HUMAN or P_Team(pl) == TEAM_UNDEAD and P_GetZombieClassTable(pl).CanTaunt) and not IsValid(pt.Revive) and not IsValid(pt.FeignDeath)
end

function GM:CalcMainActivity(pl, velocity)
	pt = E_GetTable(pl)

	if P_Team(pl) == TEAM_UNDEAD then
		tab = P_GetZombieClassTable(pl)
		if tab.CalcMainActivity then
			ideal, override = tab:CalcMainActivity(pl, velocity)
			if ideal then
				return ideal, override
			end
		end
	end

	-- Handle landing
	onground = E_OnGround(pl)
	if onground and not pt.m_bWasOnGround then
		P_AnimRestartGesture(pl, GESTURE_SLOT_JUMP, ACT_LAND, true)
		pt.m_bWasOnGround = true
	end
	--

	-- Handle jumping
	-- airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
	-- underwater we're alright we airwalking
	waterlevel = E_WaterLevel(pl)
	if pt.m_bJumping then
		if pt.m_bFirstJumpFrame then
			pt.m_bFirstJumpFrame = false
			P_AnimRestartMainSequence(pl)
		end

		if waterlevel >= 2 or CurTime() - pt.m_flJumpStartTime > 0.2 and onground then
			pt.m_bJumping = false
			pt.m_fGroundTime = nil
			P_AnimRestartMainSequence(pl)
		else
			return ACT_MP_JUMP, -1
		end
	elseif not onground and waterlevel <= 0 then
		if not pt.m_fGroundTime then
			pt.m_fGroundTime = CurTime()
		elseif CurTime() > pt.m_fGroundTime and V_Length2D(velocity) < 0.5 then
			pt.m_bJumping = true
			pt.m_bFirstJumpFrame = false
			pt.m_flJumpStartTime = 0
		end
	end
	--

	-- Handle ducking
	if P_Crouching(pl) then
		if V_Length2DSqr(velocity) >= 1 then
			return ACT_MP_CROUCHWALK, -1
		end

		return ACT_MP_CROUCH_IDLE, -1
	end
	--

	-- Handle swimming
	if not onground and waterlevel >= 2 then
		return ACT_MP_SWIM, -1
	end
	--

	len2d = V_Length2DSqr(velocity)
	if len2d >= 22500 then -- 150^2
		return ACT_MP_RUN, -1
	end

	if len2d >= 1 then
		return ACT_MP_WALK, -1
	end

	return ACT_MP_STAND_IDLE, -1
end

--local wep
local len
local rate
function GM:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	if P_CallZombieFunction(pl, "UpdateAnimation", velocity, maxseqgroundspeed) then return end

	len = V_LengthSqr(velocity)

	if len > 1 then
		rate = math_min(len / maxseqgroundspeed ^ 2, 2)
	else
		rate = 1
	end

	-- if we're under water we want to constantly be swimming..
	if E_WaterLevel(pl) >= 2 then
		rate = math_max(rate, 0.5)
	end

	E_SetPlaybackRate(pl, rate)

	if CLIENT then
		GAMEMODE:GrabEarAnimation(pl)
		--GAMEMODE:MouthMoveAnimation(pl) -- Broken?
	end
end

local eact
function GM:DoAnimationEvent(pl, event, data)
	eact = P_CallZombieFunction(pl, "DoAnimationEvent", event, data)
	if eact then return eact end

	if event == PLAYERANIMEVENT_FLINCH_HEAD then
		return P_DoFlinchAnim(pl, data)
	end

	return self.BaseClass:DoAnimationEvent(pl, event, data)
end

local CarryingActivityTranslate = {}
CarryingActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_SLAM
CarryingActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_IDLE_SLAM + 1
CarryingActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_IDLE_SLAM + 2
CarryingActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_SLAM + 3
CarryingActivityTranslate[ACT_MP_CROUCHWALK] = ACT_HL2MP_IDLE_SLAM + 4
CarryingActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_HL2MP_IDLE_SLAM + 5
CarryingActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_HL2MP_IDLE_SLAM + 5
CarryingActivityTranslate[ACT_MP_RELOAD_STAND] = ACT_HL2MP_IDLE_SLAM + 6
CarryingActivityTranslate[ACT_MP_RELOAD_CROUCH] = ACT_HL2MP_IDLE_SLAM + 6
CarryingActivityTranslate[ACT_MP_JUMP] = ACT_HL2MP_IDLE_SLAM + 7
CarryingActivityTranslate[ACT_RANGE_ATTACK1] = ACT_HL2MP_IDLE_SLAM + 8

function GM:TranslateActivity(pl, act)
	if P_IsCarrying(pl) then
		return CarryingActivityTranslate[act] or act
	end

	return self.BaseClass:TranslateActivity(pl, act)
end
