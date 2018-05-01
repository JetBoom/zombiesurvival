CLASS.Name = "Shit Slapper"
CLASS.TranslationName = "class_shitslapper"
CLASS.Description = "description_shitslapper"
CLASS.Help = "controls_shitslapper"

CLASS.Model = Model("models/Zombie/Classic_torso.mdl")

CLASS.Boss = true

CLASS.KnockbackScale = 0

CLASS.FearPerInstance = 1

CLASS.Points = 40

CLASS.SWEP = "weapon_zs_shitslapper"

CLASS.Health = 4000
CLASS.Speed = 225
CLASS.JumpPower = 200

CLASS.ModelScale = 1.75
CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 64)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 35)}
CLASS.ViewOffset = Vector(0, 0, 14 * CLASS.ModelScale)
CLASS.ViewOffsetDucked = Vector(0, 0, 14 * CLASS.ModelScale)
CLASS.StepSize = 25
CLASS.CrouchedWalkSpeed = 1
CLASS.Mass = DEFAULT_MASS * CLASS.ModelScale * 0.5

CLASS.CantDuck = true

local math_random = math.random
local CurTime = CurTime

local ACT_WALK = ACT_WALK

function CLASS:PlayPainSound(pl)
	pl:EmitSound("npc/zombie/zombie_pain"..math.random(6)..".wav", 75, math_random(70, 80))

	pl.NextPainSound = CurTime() + .5

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/zombie/zombie_die"..math_random(3)..".wav", 70, math_random(70, 80))

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	return GAMEMODE.BaseClass.PlayerStepSoundTime(GAMEMODE.BaseClass, pl, iType, bWalking) * self.ModelScale
end

local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)

	pl:EmitSound(StepSounds[math_random(#StepSounds)], 77, 50)

	if iFoot == 0 then
		pl:EmitSound("^npc/strider/strider_step4.wav", 90, math_random(95, 115))
	else
		pl:EmitSound("^npc/strider/strider_step5.wav", 90, math_random(95, 115))
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local len2d = velocity:Length2D()
	if len2d > 1 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.25 / self.ModelScale, 3))
	else
		pl:SetPlaybackRate(1 / self.ModelScale)
	end

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2DSqr() <= 1 then
		return 1, 1
	end

	return ACT_WALK, -1
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1, true)
		return ACT_INVALID
	end
end
