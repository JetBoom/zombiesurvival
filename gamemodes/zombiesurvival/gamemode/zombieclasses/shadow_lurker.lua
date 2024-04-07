CLASS.Base = "zombie_torso"

CLASS.Name = "Shadow Lurker"
CLASS.TranslationName = "class_shadow_lurker"
CLASS.Description = "description_shadow_lurker"
CLASS.Help = "controls_shadow_lurker"

CLASS.Model = Model("models/zombie/classic_torso.mdl")
CLASS.OverrideModel = Model("models/player/skeleton.mdl")

CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 22)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 22)}

CLASS.SWEP = "weapon_zs_shadowlurker"

CLASS.Wave = 2 / 6
CLASS.Unlocked = false
CLASS.Hidden = false

CLASS.Health = 165
CLASS.Speed = 160
CLASS.JumpPower = 160

CLASS.Points = CLASS.Health/GM.TorsoZombiePointRatio

CLASS.VoicePitch = 0.55

CLASS.NoHideMainModel = true

CLASS.IsTorso = true

CLASS.Skeletal = true

local math_random = math.random
local ACT_IDLE = ACT_IDLE
local ACT_WALK = ACT_WALK

function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2DSqr() <= 1 then
		return ACT_IDLE, -1
	end

	return ACT_WALK, -1
end

function CLASS:PlayPainSound(pl)
	pl:EmitSound("npc/antlion/pain2.wav", 70, math_random(240, 250))
	pl.NextPainSound = CurTime() + 0.5

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/antlion/pain"..math_random(2)..".wav", 70, math_random(240, 250))

	return true
end

local StepSounds = {
	Sound("npc/barnacle/neck_snap1.wav"),
	Sound("npc/barnacle/neck_snap2.wav")
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	pl:EmitSound(StepSounds[math_random(#StepSounds)], 50, math_random(210, 220), 0.5)

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	return GAMEMODE.BaseClass.PlayerStepSoundTime(GAMEMODE, pl, iType, bWalking) --* 2
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
end

function CLASS:ManipulateOverrideModel(pl, overridemodel)
	overridemodel:ManipulateBoneScale(0, vector_origin)
	overridemodel:ManipulateBoneScale(2, vector_origin)
	overridemodel:ManipulateBoneScale(4, vector_origin)
	for i=18, 25 do
		overridemodel:ManipulateBoneScale(i, vector_origin)
	end
end

if SERVER then
function CLASS:ProcessDamage(pl, dmginfo)
	if dmginfo:GetInflictor().IsMelee then
		dmginfo:SetDamage(dmginfo:GetDamage() / 2)
	end
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
	local effectdata = EffectData()
		effectdata:SetOrigin(pl:GetPos())
		effectdata:SetNormal(pl:GetForward())
		effectdata:SetEntity(pl)
	util.Effect("death_shadowlurker", effectdata, nil, true)

	local fakedeath = pl:FakeDeath(462, 1, 1, 1)
	if fakedeath and fakedeath:IsValid() then
		fakedeath:SetColor(color_black)
		fakedeath:SetModel(self.OverrideModel)
		fakedeath:SetPos(fakedeath:GetPos() - fakedeath:GetDeathAngles():Up() * 46)

		self:ManipulateOverrideModel(pl, fakedeath)
	end

	return true
end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/skeletal_lurker"
CLASS.IconColor = Color(20, 20, 20)

local render_SetBlend = render.SetBlend
local render_SetColorModulation = render.SetColorModulation
local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local render_ModelMaterialOverride = render.ModelMaterialOverride
local angle_zero = angle_zero
local LocalToWorld = LocalToWorld

local colGlow = Color(255, 0, 0)
local matGlow = Material("sprites/glow04_noz")
local matBlack = CreateMaterial("shadowlurkersheet", "UnlitGeneric", {["$basetexture"] = "Tools/toolsblack", ["$model"] = 1})
local vecEyeLeft = Vector(5, -3.5, -1)
local vecEyeRight = Vector(5, -3.5, 1)

function CLASS:PrePlayerDraw(pl)
	render_SetBlend(0.45)
	render_SetColorModulation(0.1, 0.1, 0.1)
end

function CLASS:PostPlayerDraw(pl)
	render_SetBlend(1)
	render_SetColorModulation(1, 1, 1)
end

function CLASS:PrePlayerDrawOverrideModel(pl)
	render_ModelMaterialOverride(matBlack)
end

function CLASS:PostPlayerDrawOverrideModel(pl)
	render_ModelMaterialOverride(nil)

	if pl == MySelf and not pl:ShouldDrawLocalPlayer() or pl.SpawnProtection then return end

	local pos, ang = pl:GetBonePositionMatrixed(5)
	if pos then
		render_SetMaterial(matGlow)
		render_DrawSprite(LocalToWorld(vecEyeLeft, angle_zero, pos, ang), 4, 4, colGlow)
		render_DrawSprite(LocalToWorld(vecEyeRight, angle_zero, pos, ang), 4, 4, colGlow)
	end
end
