CLASS.Hidden = true
CLASS.Disabled = true
CLASS.Unlocked = true

CLASS.Name = "Burster"
CLASS.TranslationName = "class_burster"
CLASS.Description = "description_burster"
CLASS.Help = "controls_burster"

CLASS.Wave = 5 / 6

CLASS.Health = 100
CLASS.Speed = 160

CLASS.Points = 3

CLASS.CanTaunt = true

CLASS.SWEP = "weapon_zs_burster"

CLASS.Model = Model("models/player/zombie_fast.mdl")

CLASS.VoicePitch = 0.7

local STEPSOUNDTIME_NORMAL = STEPSOUNDTIME_NORMAL
local STEPSOUNDTIME_WATER_FOOT = STEPSOUNDTIME_WATER_FOOT
local STEPSOUNDTIME_ON_LADDER = STEPSOUNDTIME_ON_LADDER
local STEPSOUNDTIME_WATER_KNEE = STEPSOUNDTIME_WATER_KNEE
local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

function CLASS:PlayPainSound(pl)
	pl:EmitSound("npc/zombie_poison/pz_warn"..math.random(2)..".wav", 75, math.Rand(137, 143))

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/zombie_poison/pz_die2.wav", 75, math.Rand(122, 128))

	return true
end

local mathrandom = math.random
local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
local ScuffSounds = {
	"npc/zombie/foot_slide1.wav",
	"npc/zombie/foot_slide2.wav",
	"npc/zombie/foot_slide3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if mathrandom() < 0.15 then
		pl:EmitSound(ScuffSounds[mathrandom(#ScuffSounds)], 70)
	else
		pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 70)
	end

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 625 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 600
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 750
	end

	return 450
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetCharge then
		local charge = wep:GetCharge()
		if charge > 0 then
			pl.CalcSeqOverride = pl:LookupSequence("taunt_zombie_original")
			return true
		end
	end

	if pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_HL2MP_SWIM_PISTOL
		return true
	end

	if velocity:Length2D() <= 0.5 then
		if pl:Crouching() then
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
		else
			pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
		end
	elseif pl:Crouching() then
		pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetCharge then
		local charge = wep:GetCharge()
		if charge > 0 then
			pl:SetPlaybackRate(0)
			pl:SetCycle(wep:GetCharge() ^ 2 * 0.8)
			return true
		end
	end

	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.666, 3))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
		return ACT_INVALID
	end
end

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end
end

if SERVER then
	function CLASS:CanPlayerSuicide(pl)
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() and wep.GetCharge and wep:GetCharge() > 0 then return false end
	end

	local function DoExplode(pl, pos, magnitude)
		local inflictor = pl:GetActiveWeapon()
		if not inflictor:IsValid() then inflictor = pl end

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetMagnitude(magnitude)
		util.Effect("chemzombieexplode", effectdata, true)

		util.PoisonBlastDamage(inflictor, pl, pos, magnitude * 128, magnitude * 85, true)

		pl:CheckRedeem()
	end

	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
		local magnitude = 1
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() and wep.GetCharge then magnitude = wep:GetCharge() end

		if magnitude == 0 then return end

		local pos = pl:WorldSpaceCenter()

		pl:Gib(dmginfo)
		timer.Simple(0, function() DoExplode(pl, pos, magnitude) end)

		return true
	end

	function CLASS:OnSpawned(pl)
		local status = pl:GiveStatus("overridemodel")
		if status and status:IsValid() then
			status:SetModel("models/Zombie/Poison.mdl")
		end

		pl:CreateAmbience("bursterambience")
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/chemzombie"
