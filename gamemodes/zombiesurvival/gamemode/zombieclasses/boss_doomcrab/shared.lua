CLASS.Name = "Doom Crab"
CLASS.TranslationName = "class_doomcrab"
CLASS.Description = "description_doomcrab"
CLASS.Help = "controls_doomcrab"

CLASS.Boss = true

CLASS.KnockbackScale = 0

CLASS.FearPerInstance = 1

CLASS.Points = 35

CLASS.Model = Model("models/headcrabclassic.mdl")

CLASS.SWEP = "weapon_zs_doomcrab"

CLASS.Health = 2200
CLASS.Speed = 210
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

--CLASS.NoCollideAll = true

CLASS.CantDuck = true

--CLASS.IsHeadcrab = true

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
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav"
}
local StepRightSounds = {
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound(StepLeftSounds[math_random(#StepLeftSounds)], 77, 50)
	else
		pl:EmitSound(StepRightSounds[math_random(#StepRightSounds)], 77, 50)
	end

	return true
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
		return 1, 5
	end

	if pl:OnGround() then
		if velocity:Length2DSqr() > 1 then
			return ACT_RUN, -1
		end

		return 1, 1
	end

	--if pl:WaterLevel() >= 3 then
		return 1, 6
	--[[else
		pl.CalcSeqOverride = 5
	end]]
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsAttacking and wep:IsAttacking() then
		pl:SetPlaybackRate(0)
		if wep.GetAttackEndTime then --??? How can this be nil?
			pl:SetCycle(1 - ((wep:GetAttackEndTime() - CurTime()) / wep.AttackTime))
		end
	end

	local seq = pl:GetSequence()
	if seq == 5 then
		if not pl.m_PrevFrameCycle then
			pl.m_PrevFrameCycle = true
			pl:SetCycle(0)
		end

		pl:SetPlaybackRate(1 / self.ModelScale)

		return true
	elseif pl.m_PrevFrameCycle then
		pl.m_PrevFrameCycle = nil
	end

	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed / 2 / self.ModelScale, 2))
	else
		pl:SetPlaybackRate(1 / self.ModelScale)
	end

	return true
end
