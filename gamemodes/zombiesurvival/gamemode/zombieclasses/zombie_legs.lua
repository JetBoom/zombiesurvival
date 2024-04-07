CLASS.Name = "Zombie Legs"
CLASS.TranslationName = "class_zombie_legs"
CLASS.Description = "description_zombie_legs"

CLASS.Model = Model("models/player/zombie_classic.mdl")
CLASS.OverrideModel = Model("models/Zombie/Classic_legs.mdl")
CLASS.NoHead = true

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.Health = 100
CLASS.Speed = 170
CLASS.JumpPower = 250

CLASS.CanTaunt = true

CLASS.Points = CLASS.Health/GM.LegsZombiePointRatio

CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 32)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
CLASS.ViewOffset = Vector(0, 0, 32)
CLASS.ViewOffsetDucked = Vector(0, 0, 32)
CLASS.Mass = DEFAULT_MASS * 0.5
CLASS.CrouchedWalkSpeed = 1

CLASS.CantDuck = true

CLASS.CanFeignDeath = true

CLASS.VoicePitch = 0.65

CLASS.SWEP = "weapon_zs_zombielegs"

CLASS.BloodColor = -1

local math_random = math.random

function CLASS:DoesntGiveFear(pl)
	return pl.FeignDeath and pl.FeignDeath:IsValid()
end

if SERVER then
	function CLASS:AltUse(pl)
		pl:StartFeignDeath()
	end

	function CLASS:IgnoreLegDamage(pl, dmginfo)
		return true
	end
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	if not dmginfo:IsBulletDamage() then return true end

	if hitgroup ~= HITGROUP_LEFTLEG and hitgroup ~= HITGROUP_RIGHTLEG and hitgroup ~= HITGROUP_GEAR and hitgroup ~= HITGROUP_GENERIC and dmginfo:GetDamagePosition().z > pl:LocalToWorld(Vector(0, 0, self.Hull[2].z * 1.33)).z then
		dmginfo:SetDamage(0)
		dmginfo:ScaleDamage(0)
	end

	return true
end

--[[function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end
end]]

function CLASS:ShouldDrawLocalPlayer(pl)
	return true
end

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
	if math_random() < 0.15 then
		pl:EmitSound(ScuffSounds[math_random(#ScuffSounds)], 70)
	else
		pl:EmitSound(StepSounds[math_random(#StepSounds)], 70)
	end

	return true
end
--[[function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		if math_random() < 0.15 then
			pl:EmitSound("Zombie.ScuffLeft")
		else
			pl:EmitSound("Zombie.FootstepLeft")
		end
	else
		if math_random() < 0.15 then
			pl:EmitSound("Zombie.ScuffRight")
		else
			pl:EmitSound("Zombie.FootstepRight")
		end
	end

	return true
end]]

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
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetDirection() == DIR_BACK then
			return 1, pl:LookupSequence("zombie_slump_rise_02_fast")
		end

		return ACT_HL2MP_ZOMBIE_SLUMP_RISE, -1
	end

	if velocity:Length2DSqr() <= 1 then
		return ACT_HL2MP_IDLE_ZOMBIE, -1
	end

	return ACT_HL2MP_RUN_ZOMBIE, -1
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
	if len2d > 1 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.75, 3))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/legs"

-- This whole point of this is to stop drawing decals on the upper part of the model. It doesn't actually do anything to the visible model.
local undo = false
function CLASS:PrePlayerDraw(pl)
	local boneid = pl:LookupBone("ValveBiped.Bip01_Spine")
	if boneid and boneid > 0 then
		local pos, ang = pl:GetBonePosition(boneid)
		if pos then
			local normal = ang:Forward() * -1
			render.EnableClipping(true)
			render.PushCustomClipPlane(normal, normal:Dot(pos))
			undo = true
		end
	end
end

function CLASS:PostPlayerDraw(pl)
	if undo then
		render.PopCustomClipPlane()
		render.EnableClipping(false)
	end
end

function CLASS:BuildBonePositions(pl)
	local desired

	local bone = "ValveBiped.Bip01_L_Thigh"

	local wep = pl:GetActiveWeapon()
	if wep:IsValid() then
		if wep.GetSwingEndTime and wep:GetSwingEndTime() > 0 then
			desired = 1 - math.Clamp((wep:GetSwingEndTime() - CurTime()) / wep.MeleeDelay, 0, 1)
		end

		if wep:GetDTBool(3) then
			bone = "ValveBiped.Bip01_R_Thigh"
		end
	end

	desired = desired or 0

	if desired > 0 then
		pl.m_KickDelta = CosineInterpolation(0, 1, desired)
	else
		pl.m_KickDelta = math.Approach(pl.m_KickDelta or 0, desired, FrameTime() * 4)
	end

	local boneid = pl:LookupBone(bone)
	if boneid and boneid > 0 then
		pl:ManipulateBoneAngles(boneid, pl.m_KickDelta * Angle(bone == "ValveBiped.Bip01_L_Thigh" and 0 or 20, -110, 30))
	end
end
