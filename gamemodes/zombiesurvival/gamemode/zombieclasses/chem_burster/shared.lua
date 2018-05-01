CLASS.Name = "Chem Burster"
CLASS.TranslationName = "class_chem_burster"
CLASS.Description = "description_chem_burster"
CLASS.Help = "controls_chem_burster"

CLASS.Wave = 6 / 6

CLASS.Health = 125
CLASS.Speed = 170

CLASS.Points = CLASS.Health/GM.HumanoidZombiePointRatio

CLASS.CanTaunt = true

CLASS.SWEP = "weapon_zs_burster"

CLASS.Model = Model("models/player/zombie_classic.mdl")
CLASS.OverrideModel = Model("models/Zombie/Poison.mdl")

CLASS.PainSounds = {Sound("npc/metropolice/knockout2.wav"), Sound("npc/metropolice/pain1.wav"), Sound("npc/metropolice/pain2.wav"), Sound("npc/metropolice/pain3.wav"), Sound("npc/metropolice/pain4.wav")}
CLASS.VoicePitch = 0.7

CLASS.BloodColor = BLOOD_COLOR_GREEN

local math_random = math.random
local math_min = math.min
local math_ceil = math.ceil
local CurTime = CurTime
--local string_format = string.format

local STEPSOUNDTIME_NORMAL = STEPSOUNDTIME_NORMAL
local STEPSOUNDTIME_WATER_FOOT = STEPSOUNDTIME_WATER_FOOT
local STEPSOUNDTIME_ON_LADDER = STEPSOUNDTIME_ON_LADDER
local STEPSOUNDTIME_WATER_KNEE = STEPSOUNDTIME_WATER_KNEE
local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_CHARGING = ACT_HL2MP_RUN_CHARGING

--[[function CLASS:PlayPainSound(pl)
	pl:EmitSound(string_format("npc/zombie_poison/pz_warn%d.wav", math.random(2)), 75, math.Rand(137, 143))
	pl.NextPainSound = CurTime() + 0.5

	return true
end]]

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/zombie_poison/pz_die2.wav", 75, math.Rand(122, 128))

	return true
end

local StepLeftSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav"
}
local StepRightSounds = {
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound(StepLeftSounds[math_random(#StepLeftSounds)], 70)
	else
		pl:EmitSound(StepRightSounds[math_random(#StepRightSounds)], 70)
	end

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetCharge and wep:GetCharge() > 0 then
		if velocity:Length2DSqr() <= 1 then
			return 1, pl:LookupSequence("seq_cower")
		end

		return ACT_HL2MP_RUN_CHARGING, -1
	end

	if pl:WaterLevel() >= 3 then
		return ACT_HL2MP_SWIM_PISTOL, -1
	end

	if velocity:Length2DSqr() <= 1 then
		if pl:Crouching() and pl:OnGround() then
			return ACT_HL2MP_IDLE_CROUCH_ZOMBIE, -1
		end

		return ACT_HL2MP_RUN_ZOMBIE, -1
	end

	if pl:Crouching() and pl:OnGround() then
		return ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math_ceil((CurTime() / 4 + pl:EntIndex()) % 3), -1
	end

	return ACT_HL2MP_RUN_ZOMBIE, -1
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetCharge and wep:GetCharge() > 0 and velocity:Length2DSqr() <= 1 then
		pl:SetPlaybackRate(0)
		pl:SetCycle(wep:GetCharge() ^ 2)
		return true
	end

	local len2d = velocity:Length2D()
	if len2d > 1 then
		pl:SetPlaybackRate(math_min(len2d / maxseqgroundspeed * 0.666, 3))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:DoZombieAttackAnim(data)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_RELOAD then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
		return ACT_INVALID
	end
end

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end
end
