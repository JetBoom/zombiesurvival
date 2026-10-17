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

-- ============================================================
-- Weapon classification cache
-- ------------------------------------------------------------
-- Entity:GetClass() allocates a fresh string per call, and
-- string.sub(..., 1, 10) allocates another. Both CalcMainActivity
-- and TranslateActivity run for every player every tick, so this
-- used to burn thousands of short-lived strings per second on a
-- busy server. A weapon's class never changes after it is
-- registered, so we cache the result on the weapon instance.
-- ============================================================
local function IsZSWeapon(wep)
    if not IsValid(wep) then return false end
    local cached = wep._zs_isZsWeapon
    if cached ~= nil then return cached end

    local cls = wep:GetClass()
    local res = string.sub(cls, 1, 10) == "weapon_zs_"
    wep._zs_isZsWeapon = res
    return res
end

local function IsGModFists(wep)
    if not IsValid(wep) then return false end
    local cached = wep._zs_isFists
    if cached ~= nil then return cached end

    local res = wep:GetClass() == "weapon_fists"
    wep._zs_isFists = res
    return res
end

local onground, tab, len2d, waterlevel, ideal, override, pt

function GM:PlayerShouldTaunt(pl, actid)
	pt = E_GetTable(pl)

	return P_Alive(pl) and (P_Team(pl) == TEAM_HUMAN or P_Team(pl) == TEAM_UNDEAD and P_GetZombieClassTable(pl).CanTaunt) and not IsValid(pt.Revive) and not IsValid(pt.FeignDeath)
end

function GM:CalcMainActivity(pl, velocity)
	pt = E_GetTable(pl)

	-- Non-ZS weapons (HL2/GMod: medkit, fists, flechettegun, weapon_shotgun
	-- etc.) are handed over to engine logic — otherwise the engine won't
	-- substitute activities for the weapon's HoldType and we get a T-pose.
	local wep = pl:GetActiveWeapon()
	if not IsZSWeapon(wep) then
		local bc = self.BaseClass
		if bc and bc.CalcMainActivity then
			return bc:CalcMainActivity(pl, velocity)
		end

		-- Fallback: a copy of the standard engine logic
		-- in case BaseClass is somehow unavailable.
		if pl:InVehicle() then return ACT_MP_STAND_IDLE, -1 end
		if pl:GetMoveType() == MOVETYPE_NOCLIP then return ACT_MP_SWIM, -1 end

		local onground = pl:OnGround()
		local len2dSqr = velocity:Length2DSqr()

		if not onground and pl:WaterLevel() < 2 and velocity:Length2D() > 0.5 then
			return ACT_MP_RUN, -1
		end

		if pl:Crouching() then
			if len2dSqr >= 1 then return ACT_MP_CROUCHWALK, -1 end
			return ACT_MP_CROUCH_IDLE, -1
		end

		if not onground and pl:WaterLevel() >= 2 then
			return ACT_MP_SWIM, -1
		end

		if len2dSqr >= 1 then
			if pl:KeyDown(IN_RUN) then return ACT_MP_RUN, -1 end
			return ACT_MP_WALK, -1
		end

		return ACT_MP_STAND_IDLE, -1
	end

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
	-- Airwalk like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation.
	-- Underwater we're fine airwalking.
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

-- Translation table from base GMod — used as the final fallback.
local IdleActivityTranslate = {
	[ACT_MP_STAND_IDLE]                 = ACT_HL2MP_IDLE,
	[ACT_MP_WALK]                       = ACT_HL2MP_IDLE + 1,
	[ACT_MP_RUN]                        = ACT_HL2MP_IDLE + 2,
	[ACT_MP_CROUCH_IDLE]                = ACT_HL2MP_IDLE + 3,
	[ACT_MP_CROUCHWALK]                 = ACT_HL2MP_IDLE + 4,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE]   = ACT_HL2MP_IDLE + 5,
	[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]  = ACT_HL2MP_IDLE + 5,
	[ACT_MP_RELOAD_STAND]               = ACT_HL2MP_IDLE + 6,
	[ACT_MP_RELOAD_CROUCH]              = ACT_HL2MP_IDLE + 6,
	[ACT_MP_JUMP]                       = ACT_HL2MP_JUMP_SLAM,
	[ACT_MP_SWIM]                       = ACT_HL2MP_IDLE + 9,
	[ACT_LAND]                          = ACT_LAND,
}

-- Base idle activity by weapon HoldType.
local HoldTypeToIdle = {
	normal   = ACT_HL2MP_IDLE,
	melee    = ACT_HL2MP_IDLE_MELEE,
	pistol   = ACT_HL2MP_IDLE_PISTOL,
	smg      = ACT_HL2MP_IDLE_SMG1,
	smg1     = ACT_HL2MP_IDLE_SMG1,
	ar2      = ACT_HL2MP_IDLE_AR2,
	shotgun  = ACT_HL2MP_IDLE_SHOTGUN,
	["357"]  = ACT_HL2MP_IDLE_357,
	revolver = ACT_HL2MP_IDLE_357,
	crossbow = ACT_HL2MP_IDLE_CROSSBOW,
	rpg      = ACT_HL2MP_IDLE_RPG,
	grenade  = ACT_HL2MP_IDLE_GRENADE,
	slam     = ACT_HL2MP_IDLE_SLAM,
	physgun  = ACT_HL2MP_IDLE_PHYSGUN,
	fist     = ACT_HL2MP_IDLE_MELEE,
}

-- Offsets of ACT_MP_* inside one HL2MP HoldType group.
local ActMPtoOffset = {
	[ACT_MP_STAND_IDLE]                 = 0,
	[ACT_MP_WALK]                       = 1,
	[ACT_MP_RUN]                        = 2,
	[ACT_MP_CROUCH_IDLE]                = 3,
	[ACT_MP_CROUCHWALK]                 = 4,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE]   = 5,
	[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]  = 5,
	[ACT_MP_RELOAD_STAND]               = 6,
	[ACT_MP_RELOAD_CROUCH]              = 6,
}

function GM:TranslateActivity(pl, act)
	if P_IsCarrying(pl) then
		return CarryingActivityTranslate[act] or act
	end

	local wep = pl:GetActiveWeapon()

	-- ZS weapons and GMod fists are handled by the engine/base GMod.
	-- weapon_zs_fists shows the correct animation precisely because
	-- the engine itself picks the activity by HoldType "fist";
	-- weapon_fists from GMod should go the same route.
	if not IsValid(wep) or IsZSWeapon(wep) or IsGModFists(wep) then
		return self.BaseClass:TranslateActivity(pl, act)
	end

	-- Let the engine pick the weapon-specific activity first.
	-- HL2 SP/CSS/GMod models have distinct sequences per weapon for
	-- jump, swim, reload and attack. Returning JUMP_SLAM / SWIM
	-- before this call forced the unarmed pose for HL2 weapons.
	local newact = pl:TranslateWeaponActivity(act)
	if newact ~= act then return newact end

	-- Engine returned the act unchanged — no translation was found.
	-- This happens for Lua SWEPs that don't define their own
	-- activity list. Universal fallbacks:
	if act == ACT_MP_JUMP then return ACT_HL2MP_JUMP_SLAM end
	if act == ACT_MP_SWIM then return ACT_HL2MP_SWIM end
	if act == ACT_LAND  then return ACT_LAND end

	-- Map the rest by HoldType.
	local ht = wep:GetHoldType()
	if not ht or ht == "" or ht == "none" then ht = "normal" end

	local baseIdle = HoldTypeToIdle[ht]
	if not baseIdle then
		-- Unknown HoldType — generic unarmed fallback.
		return IdleActivityTranslate[act] or act
	end

	local offset = ActMPtoOffset[act]
	if offset then
		return baseIdle + offset
	end

	return act
end