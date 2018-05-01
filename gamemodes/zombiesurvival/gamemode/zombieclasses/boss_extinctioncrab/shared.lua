CLASS.Name = "Extinction Crab"
CLASS.TranslationName = "class_extinctioncrab"
CLASS.Description = "description_extinctioncrab"
CLASS.Help = "controls_extinctioncrab"

CLASS.Boss = true

CLASS.KnockbackScale = 0

CLASS.FearPerInstance = 1

CLASS.Points = 35

CLASS.Model = Model("models/headcrab.mdl")

CLASS.SWEP = "weapon_zs_extinctioncrab"

CLASS.Health = 1900
CLASS.Speed = 250
--CLASS.JumpPower = 160

CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true

CLASS.ModelScale = 3
CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 12 * CLASS.ModelScale)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 12 * CLASS.ModelScale)}
CLASS.ViewOffset = Vector(0, 0, 48)
CLASS.ViewOffsetDucked = Vector(0, 0, 48)
CLASS.StepSize = 8 * CLASS.ModelScale
CLASS.CrouchedWalkSpeed = 1
CLASS.Mass = 25 * CLASS.ModelScale

CLASS.CantDuck = true

CLASS.BloodColor = BLOOD_COLOR_YELLOW

local math_random = math.random
local CurTime = CurTime

local ACT_RUN = ACT_RUN

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end
end

local StepLeftSounds = {
	"npc/headcrab_poison/ph_step1.wav",
	"npc/headcrab_poison/ph_step3.wav"
}
local StepRightSounds = {
	"npc/headcrab_poison/ph_step2.wav",
	"npc/headcrab_poison/ph_step4.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound(StepLeftSounds[math_random(#StepLeftSounds)], 75, math_random(50, 75))
	else
		pl:EmitSound(StepRightSounds[math_random(#StepRightSounds)], 75, math_random(50, 75))
	end

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	return GAMEMODE.BaseClass.PlayerStepSoundTime(GAMEMODE.BaseClass, pl, iType, bWalking) * 1.3
end

function CLASS:PlayPainSound(pl)
	pl:EmitSound(string.format("npc/antlion_guard/angry%d.wav", math_random(3)))
	pl.NextPainSound = CurTime() + 0.5

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/ichthyosaur/water_growl5.wav")

	return true
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsAttacking and wep:IsAttacking() then
		return 1, pl:LookupSequence("Idle02")
	end

	if pl:OnGround() then
		if velocity:Length2DSqr() > 1 then
			return ACT_RUN, -1
		end

		return 1, pl:LookupSequence("Idle01")
	end

	return 1, pl:LookupSequence("Drown")
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsAttacking and wep:IsAttacking() then
		pl:SetPlaybackRate(0)
		if wep.GetAttackEndTime then --??? How can this be nil?
			pl:SetCycle(1 - ((wep:GetAttackEndTime() - CurTime()) / wep.AttackTime))
		end
	end

	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed / self.ModelScale, 2))
	else
		pl:SetPlaybackRate(1 / self.ModelScale)
	end

	return true
end
