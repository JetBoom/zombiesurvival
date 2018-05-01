CLASS.Name = "Devourer"
CLASS.TranslationName = "class_devourer"
CLASS.Description = "description_devourer"
CLASS.Help = "controls_devourer"

CLASS.Boss = true

CLASS.KnockbackScale = 0

CLASS.Health = 1600
CLASS.Speed = 160

CLASS.CanTaunt = true

CLASS.FearPerInstance = 1

CLASS.Points = 30

CLASS.SWEP = "weapon_zs_devourer"

CLASS.Model = Model("models/player/charple.mdl")
CLASS.OverrideModel = Model("models/player/skeleton.mdl")

CLASS.NoHideMainModel = true

CLASS.VoicePitch = 0.65

CLASS.PainSounds = {"npc/zombie/zombie_pain1.wav", "npc/zombie/zombie_pain2.wav", "npc/zombie/zombie_pain3.wav", "npc/zombie/zombie_pain4.wav", "npc/zombie/zombie_pain5.wav", "npc/zombie/zombie_pain6.wav"}
CLASS.DeathSounds = {"npc/zombie/zombie_die1.wav", "npc/zombie/zombie_die2.wav", "npc/zombie/zombie_die3.wav"}

CLASS.Skeletal = true

local math_random = math.random
local math_min = math.min
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

	local len = velocity:Length2DSqr()
	if len <= 1 then
		if pl:Crouching() and pl:OnGround() then
			return ACT_HL2MP_IDLE_CROUCH_FIST, -1
		end

		return ACT_HL2MP_IDLE_KNIFE, -1
	end

	if pl:Crouching() and pl:OnGround() then
		return ACT_HL2MP_WALK_CROUCH_KNIFE, -1
	end

	if len < 2800 then
		return ACT_HL2MP_WALK_KNIFE, -1
	end

	return ACT_HL2MP_RUN_KNIFE, -1
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local len2d = velocity:Length()
	if len2d > 1 then
		pl:SetPlaybackRate(math_min(len2d / maxseqgroundspeed, 3))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_RELOAD then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
		return ACT_INVALID
	end
end

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("devourerambience")
	end
end

local vecSpineOffset = Vector(1, 3, 0)
local MuscularBones = {
	["ValveBiped.Bip01_R_Upperarm"] = Vector(1, 2, 3.5),
	["ValveBiped.Bip01_R_Forearm"] = Vector(1, 2.5, 3),
	["ValveBiped.Bip01_L_Upperarm"] = Vector(1, 2, 3.5),
	["ValveBiped.Bip01_L_Forearm"] = Vector(1, 2.5, 3),
	["ValveBiped.Bip01_L_Hand"] = Vector(1, 2, 4),
	["ValveBiped.Bip01_R_Hand"] = Vector(1, 2, 4),
	["ValveBiped.Bip01_L_Thigh"] = Vector(1, 2, 3),
	["ValveBiped.Bip01_R_Thigh"] = Vector(1, 2, 3),
	["ValveBiped.Bip01_L_Calf"] = Vector(1, 2, 3),
	["ValveBiped.Bip01_R_Calf"] = Vector(1, 2, 3),
	["ValveBiped.Bip01_L_Foot"] = Vector(1, 2, 3),
	["ValveBiped.Bip01_R_Foot"] = Vector(1, 2, 3),
}
local SpineBones = {"ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Spine1", "ValveBiped.Bip01_Neck1"}
function CLASS:BuildBonePositions(pl)
	for _, bone in pairs(SpineBones) do
		local boneid = pl:LookupBone(bone)
		if boneid and boneid > 0 then
			pl:ManipulateBonePosition(boneid, vecSpineOffset)
		end
	end

	for bonename, newscale in pairs(MuscularBones) do
		local boneid = pl:LookupBone(bonename)
		if boneid and boneid > 0 then
			pl:ManipulateBoneScale(boneid, newscale)
		end
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/devourer"

local matFlesh = Material("models/flesh")
local matBlack = CreateMaterial("devourer", "UnlitGeneric", {["$basetexture"] = "Tools/toolsblack", ["$model"] = 1})
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matFlesh)
	render.SetColorModulation(0.45, 0.35, 0.05)
end

function CLASS:PostPlayerDraw(pl)
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride()
end

function CLASS:PrePlayerDrawOverrideModel(pl)
	render.ModelMaterialOverride(matBlack)
end

function CLASS:PostPlayerDrawOverrideModel(pl)
	render.ModelMaterialOverride(nil)
end
