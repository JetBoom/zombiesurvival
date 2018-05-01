CLASS.Name = "Nightmare"
CLASS.TranslationName = "class_nightmare"
CLASS.Description = "description_nightmare"
CLASS.Help = "controls_nightmare"

CLASS.Boss = true

CLASS.KnockbackScale = 0

CLASS.Health = 2000
CLASS.Speed = 280 -- 150

CLASS.CanTaunt = true

CLASS.FearPerInstance = 1

CLASS.Points = 30

CLASS.SWEP = "weapon_zs_nightmare"

CLASS.Model = Model("models/player/zombie_classic_hbfix.mdl")
CLASS.OverrideModel = Model("models/player/charple.mdl")

CLASS.VoicePitch = 0.65

CLASS.PainSounds = {"npc/zombie/zombie_pain1.wav", "npc/zombie/zombie_pain2.wav", "npc/zombie/zombie_pain3.wav", "npc/zombie/zombie_pain4.wav", "npc/zombie/zombie_pain5.wav", "npc/zombie/zombie_pain6.wav"}
CLASS.DeathSounds = {"npc/zombie/zombie_die1.wav", "npc/zombie/zombie_die2.wav", "npc/zombie/zombie_die3.wav"}

local math_random = math.random
local math_Rand = math.Rand
local math_min = math.min
local math_ceil = math.ceil
local CurTime = CurTime

local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	pl:EmitSound(StepSounds[math_random(#StepSounds)], 70)

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	if pl:WaterLevel() >= 3 then
		return ACT_HL2MP_SWIM_PISTOL, -1
	end

	if pl:Crouching() and pl:OnGround() then
		if velocity:Length2DSqr() <= 1 then
			return ACT_HL2MP_IDLE_CROUCH_ZOMBIE, -1
		end

		return ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math_ceil((CurTime() / 4 + pl:EntIndex()) % 3), -1
	end

	return ACT_HL2MP_RUN_ZOMBIE, -1
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math_min(len2d / maxseqgroundspeed, 3))
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

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("nightmareambience")
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/nightmare2"

local function CreateBoneOffsets(pl)
	pl.m_NightmareBoneOffsetsNext = CurTime() + math_Rand(0.02, 0.1)

	local offsets = {}
	local angs = {}
	for i=1, pl:GetBoneCount() - 1 do
		if math_random(3) == 3 then
			offsets[i] = VectorRand():GetNormalized() * math.Rand(0.5, 3)
		end
		if math_random(5) == 5 then
			angs[i] = Angle(math_Rand(-5, 5), math_Rand(-15, 15), math_Rand(-5, 5))
		end
	end
	pl.m_NightmareBoneOffsets = offsets
	pl.m_NightmareBoneAngles = angs
end

function CLASS:BuildBonePositions(pl)
	if not pl.m_NightmareBoneOffsets or CurTime() >= pl.m_NightmareBoneOffsetsNext then
		CreateBoneOffsets(pl)
	end

	local offsets = pl.m_NightmareBoneOffsets
	local angs = pl.m_NightmareBoneAngles
	for i=1, pl:GetBoneCount() - 1 do
		if offsets[i] then
			pl:ManipulateBonePosition(i, offsets[i])
		end
		if angs[i] then
			pl:ManipulateBoneAngles(i, angs[i])
		end
	end
end

function CLASS:PrePlayerDraw(pl)
	render.SetColorModulation(0.1, 0.1, 0.1)
end

function CLASS:PostPlayerDraw(pl)
	render.SetColorModulation(1, 1, 1)
end
