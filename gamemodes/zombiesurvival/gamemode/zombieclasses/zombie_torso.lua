CLASS.Name = "Zombie Torso"
CLASS.TranslationName = "class_zombie_torso"
CLASS.Description = "description_zombie_torso"

CLASS.Model = Model("models/Zombie/Classic_torso.mdl")

CLASS.SWEP = "weapon_zs_zombietorso"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.Health = 100
CLASS.Speed = 130
CLASS.JumpPower = 120

CLASS.Points = CLASS.Health/GM.TorsoZombiePointRatio

CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 20)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 20)}
CLASS.ViewOffset = Vector(0, 0, 14)
CLASS.ViewOffsetDucked = Vector(0, 0, 14)
CLASS.Mass = DEFAULT_MASS * 0.5
CLASS.CrouchedWalkSpeed = 1
CLASS.StepSize = 12

CLASS.CantDuck = true

CLASS.PainSounds = {"npc/zombie/zombie_pain1.wav", "npc/zombie/zombie_pain2.wav", "npc/zombie/zombie_pain3.wav", "npc/zombie/zombie_pain4.wav", "npc/zombie/zombie_pain5.wav", "npc/zombie/zombie_pain6.wav"}
CLASS.DeathSounds = {"npc/zombie/zombie_die1.wav", "npc/zombie/zombie_die2.wav", "npc/zombie/zombie_die3.wav"}

CLASS.VoicePitch = 0.65

CLASS.IsTorso = true

local math_random = math.random
local ACT_WALK = ACT_WALK

function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2DSqr() <= 1 then
		return 1, 1
	end

	return ACT_WALK, -1
end

local ScuffSounds = {
	"npc/zombie/foot_slide1.wav",
	"npc/zombie/foot_slide2.wav",
	"npc/zombie/foot_slide3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if math_random() < 0.07 then
		pl:EmitSound(ScuffSounds[math_random(#ScuffSounds)], 70, 90)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1, true)
		return ACT_INVALID
	end
end

if SERVER then
	function CLASS:OnSecondWind(pl)
		pl:EmitSound("npc/zombie/zombie_voice_idle"..math.random(14)..".wav", 100, 85)
	end
end

if CLIENT then
	CLASS.Icon = "zombiesurvival/killicons/torso"
end
