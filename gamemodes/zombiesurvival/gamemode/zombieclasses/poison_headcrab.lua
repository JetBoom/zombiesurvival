CLASS.Name = "Poison Headcrab"
CLASS.TranslationName = "class_poison_headcrab"
CLASS.Description = "description_poison_headcrab"
CLASS.Help = "controls_poison_headcrab"

CLASS.Model = Model("models/headcrabblack.mdl")

CLASS.Wave = 2 / 3
CLASS.Threshold = 0.6

CLASS.SWEP = "weapon_zs_poisonheadcrab"

CLASS.Health = 70
CLASS.Speed = 145
CLASS.JumpPower = 100

CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true

CLASS.IsHeadcrab = true

CLASS.Points = 4

CLASS.Hull = {Vector(-12, -12, 0), Vector(12, 12, 18.1)}
CLASS.HullDuck = {Vector(-12, -12, 0), Vector(12, 12, 18.1)}
CLASS.ViewOffset = Vector(0, 0, 10)
CLASS.ViewOffsetDucked = Vector(0, 0, 10)
CLASS.StepSize = 8
CLASS.CrouchedWalkSpeed = 1
CLASS.Mass = 40

CLASS.CantDuck = true

CLASS.PainSounds = {"NPC_BlackHeadcrab.Pain"}
CLASS.DeathSounds = {"NPC_BlackHeadcrab.Die"}

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	return true
end

local mathrandom = math.random
local StepSounds = {
	"npc/headcrab_poison/ph_step1.wav",
	"npc/headcrab_poison/ph_step2.wav",
	"npc/headcrab_poison/ph_step3.wav",
	"npc/headcrab_poison/ph_step4.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 60)

	return true
end
--[[function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	pl:EmitSound("NPC_BlackHeadcrab.Footstep")

	return true
end]]

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 285 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 200
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 280
	end

	return 175
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() then
		if wep.ShouldPlayLeapAnimation and wep:ShouldPlayLeapAnimation() then
			pl.CalcSeqOverride = 7
			return true
		elseif wep.IsGoingToSpit and wep:IsGoingToSpit() then
			pl.CalcSeqOverride = 2
			return true
		end
	end

	if pl:OnGround() then
		if velocity:Length2D() > 0.5 then
			pl.CalcIdeal = ACT_RUN
		else
			pl.CalcSeqOverride = 4
		end
	else
		pl.CalcSeqOverride = 6
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)

	local seq = pl:GetSequence()
	if seq == 2 or seq == 7 then
		pl:SetPlaybackRate(1)

		if not pl.m_PrevFrameCycle then
			pl.m_PrevFrameCycle = true
			pl:SetCycle(0)
		end

		return true
	elseif pl.m_PrevFrameCycle then
		pl.m_PrevFrameCycle = nil
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/poisonheadcrab"

function CLASS:CreateMove(pl, cmd)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.m_ViewAngles and (wep.IsLeaping and wep:IsLeaping() or wep.IsGoingToLeap and wep:IsGoingToLeap()) then
		local maxdiff = FrameTime() * 15
		local mindiff = -maxdiff
		local originalangles = wep.m_ViewAngles
		local viewangles = cmd:GetViewAngles()

		local diff = math.AngleDifference(viewangles.yaw, originalangles.yaw)
		if diff > maxdiff or diff < mindiff then
			viewangles.yaw = math.NormalizeAngle(originalangles.yaw + math.Clamp(diff, mindiff, maxdiff))
		end

		wep.m_ViewAngles = viewangles

		cmd:SetViewAngles(viewangles)
	end
end
