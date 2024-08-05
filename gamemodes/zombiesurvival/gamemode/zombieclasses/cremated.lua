CLASS.Name = "Cremated"
CLASS.TranslationName = "class_zombie_cremated"
CLASS.Description = "description_zombie_cremated"
CLASS.Help = "controls_zombie_cremated"
CLASS.Model = Model("models/Zombie/Classic_torso.mdl")

CLASS.SWEP = "weapon_zs_cremated"

CLASS.Wave = 3 / 6
CLASS.Threshold = 0
CLASS.Unlocked = false
CLASS.Hidden = true

CLASS.Health = 125
CLASS.Speed = 160
CLASS.JumpPower = 230
CLASS.Points = 4

CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 20)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 20)}
CLASS.ViewOffset = Vector(0, 0, 14)
CLASS.ViewOffsetDucked = Vector(0, 0, 14)
CLASS.Mass = DEFAULT_MASS * 0.5
CLASS.CrouchedWalkSpeed = 1
CLASS.StepSize = 12

CLASS.CantDuck = true

CLASS.PainSounds = {Sound("npc/barnacle/barnacle_pull1.wav"), Sound("npc/barnacle/barnacle_pull2.wav"), Sound("npc/barnacle/barnacle_pull3.wav"), Sound("npc/barnacle/barnacle_pull4.wav")}
CLASS.DeathSounds = {"npc/dog/dog_growl2.wav", "npc/dog/dog_growl3.wav"}

CLASS.VoicePitch = 1.4

function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2D() <= 0.5 then
		pl.CalcSeqOverride = 1
	else
		pl.CalcIdeal = ACT_WALK
	end

	return true
end

local mathrandom = math.random
local ScuffSounds = {
	"npc/zombie/foot_slide1.wav",
	"npc/zombie/foot_slide2.wav",
	"npc/zombie/foot_slide3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if mathrandom() < 0.07 then
		pl:EmitSound(ScuffSounds[mathrandom(#ScuffSounds)], 70, 90)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1, true)
		return ACT_INVALID
	end
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)
end

function CLASS:ProcessDamage(pl, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker:GetActiveWeapon().IsMelee then
		dmginfo:ScaleDamage(2)
	else 
		dmginfo:ScaleDamage(0.5)
	end
end



if not CLIENT then return end
--CLASS.Icon = "zombiesurvival/killicons/torso"

local matSkin = Material("Models/Charple/Charple1_sheet")
function CLASS:PrePlayerDraw(pl)
	render.SetColorModulation(0.3, 0.3, 0.3)
	render.ModelMaterialOverride(matSkin)
end
function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
end
