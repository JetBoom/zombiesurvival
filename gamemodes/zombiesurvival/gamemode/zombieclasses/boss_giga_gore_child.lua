CLASS.Name = "Giga Gore Child"
CLASS.TranslationName = "class_giga_gore_child"
CLASS.Description = "description_giga_gore_child"
CLASS.Help = "controls_giga_gore_child"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = true

CLASS.Health = 2000
CLASS.Speed = 170

CLASS.Points = 30

CLASS.CanTaunt = true

CLASS.FearPerInstance = 1

CLASS.SWEP = "weapon_zs_gigagorechild"

CLASS.Model = Model("models/vinrax/player/doll_player.mdl")

CLASS.VoicePitch = 1

CLASS.ModelScale = 1.6

CLASS.CanFeignDeath = true

CLASS.Mass = 500
CLASS.ViewOffset = DEFAULT_VIEW_OFFSET * CLASS.ModelScale
CLASS.ViewOffsetDucked = DEFAULT_VIEW_OFFSET_DUCKED * CLASS.ModelScale
CLASS.StepSize = 25
CLASS.Hull = {Vector(-16, -16, 0) * CLASS.ModelScale, Vector(16, 16, 64) * CLASS.ModelScale}
CLASS.HullDuck = {Vector(-16, -16, 0) * CLASS.ModelScale, Vector(16, 16, 32) * CLASS.ModelScale}

CLASS.Hull[1].x = -16
CLASS.Hull[2].x = 16
CLASS.Hull[1].y = -16
CLASS.Hull[2].y = 16
CLASS.HullDuck[1].x = -16
CLASS.HullDuck[2].x = 16
CLASS.HullDuck[1].y = -16
CLASS.HullDuck[2].y = 16

local DIR_BACK = DIR_BACK
local ACT_HL2MP_ZOMBIE_SLUMP_RISE = ACT_HL2MP_ZOMBIE_SLUMP_RISE
local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

local mathrandom = math.random
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
		pl:EmitSound(StepLeftSounds[mathrandom(#StepLeftSounds)], 77, 50)
		pl:EmitSound("physics/concrete/concrete_break2.wav", 77, 70)
	else
		pl:EmitSound(StepRightSounds[mathrandom(#StepRightSounds)], 77, 50)
		pl:EmitSound("physics/concrete/concrete_break3.wav", 77, 70)
	end

	if EyePos():Distance(vFootPos) <= 300 then
		util.ScreenShake(vFootPos, 5, 5, 1, 300)
	end

	return true
end

function CLASS:PlayDeathSound(pl)
	local pitch = math.random(60, 70)
	for i=1, 2 do
		pl:EmitSound("ambient/creatures/town_child_scream1.wav", 75, pitch)
	end

	return true
end

function CLASS:PlayPainSound(pl)
	pl:EmitSound("ambient/voices/citizen_beaten"..math.random(5)..".wav", 70, math.random(50, 60))
	pl.NextPainSound = CurTime() + 1.25

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetDirection() == DIR_BACK then
			pl.CalcSeqOverride = pl:LookupSequence("zombie_slump_rise_02_fast")
		else
			pl.CalcIdeal = ACT_HL2MP_ZOMBIE_SLUMP_RISE
		end
		return true
	end

	if pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_HL2MP_SWIM_PISTOL
	elseif pl:Crouching() then
		if velocity:Length2D() <= 0.5 then
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
		else
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
		end
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
	end

	return true
end

function CLASS:Move(pl, move)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsSwinging and wep:IsSwinging() then
		move:SetMaxSpeed(move:GetMaxSpeed() * 0.25)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.25)

		return true
	end
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	return GAMEMODE.BaseClass.PlayerStepSoundTime(GAMEMODE.BaseClass, pl, iType, bWalking) * 1.8
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetState() == 1 then
			pl:SetCycle(1 - math.max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		else
			pl:SetCycle(math.max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		end
		pl:SetPlaybackRate(0)
		return true
	end

	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed, 3))
	else
		pl:SetPlaybackRate(1)
	end

	pl:SetPlaybackRate(pl:GetPlaybackRate() * 0.5)

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_RELOAD then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_THROW, true)
		return ACT_INVALID
	end
end

function CLASS:DoesntGiveFear(pl)
	return pl.FeignDeath and pl.FeignDeath:IsValid()
end

if SERVER then
	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
		pl:FakeDeath(pl:LookupSequence("death_0"..math.random(4)), self.ModelScale)

		return true
	end

	function CLASS:PostOnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
		pl:SetZombieClass(GAMEMODE.DefaultZombieClass)
	end

	function CLASS:AltUse(pl)
		pl:StartFeignDeath()
	end
end

if not CLIENT then return end

function CLASS:ShouldDrawLocalPlayer()
	return true
end
