CLASS.Name = "Fast Zombie"
CLASS.TranslationName = "class_fast_zombie"
CLASS.Description = "description_fast_zombie"
CLASS.Help = "controls_fast_zombie"

CLASS.Model = Model("models/player/zombie_fast.mdl") --Model("models/Zombie/Fast.mdl")

CLASS.Wave = 1 / 2
CLASS.Revives = true
CLASS.Infliction = 0.5 -- We auto-unlock this class if 50% of humans are dead regardless of what wave it is.

CLASS.Health = 125
CLASS.Speed = 250
CLASS.SWEP = "weapon_zs_fastzombie"

CLASS.Points = 4

CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 58)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
CLASS.ViewOffset = Vector(0, 0, 50)
CLASS.ViewOffsetDucked = Vector(0, 0, 24)

CLASS.PainSounds = {"NPC_FastZombie.Pain"}
CLASS.DeathSounds = {"npc/fast_zombie/leap1.wav"} --{"NPC_FastZombie.Die"}

CLASS.VoicePitch = 0.75

CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end

	if mv:GetForwardSpeed() <= 0 then
		mv:SetMaxSpeed(math.min(mv:GetMaxSpeed(), 90))
		mv:SetMaxClientSpeed(math.min(mv:GetMaxClientSpeed(), 90))
	end
end

local mathrandom = math.random
local StepLeftSounds = {
	"npc/fast_zombie/foot1.wav",
	"npc/fast_zombie/foot2.wav"
}
local StepRightSounds = {
	"npc/fast_zombie/foot3.wav",
	"npc/fast_zombie/foot4.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound(StepLeftSounds[mathrandom(#StepLeftSounds)], 70)
	else
		pl:EmitSound(StepRightSounds[mathrandom(#StepRightSounds)], 70)
	end

	return true
end
--[[function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound("NPC_FastZombie.GallopLeft")
	else
		pl:EmitSound("NPC_FastZombie.GallopRight")
	end

	return true
end]]

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 450 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 400
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 550
	end

	return 250
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if not wep:IsValid() or not wep.GetClimbing then return end

	if wep:GetClimbing() then
		pl.CalcIdeal = ACT_ZOMBIE_CLIMB_UP
		return true
	elseif wep:GetPounceTime() > 0 then
		pl.CalcIdeal = ACT_ZOMBIE_LEAP_START
		return true
	end

	local speed = velocity:Length2D()
	if not pl:OnGround() or pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_ZOMBIE_LEAPING
	elseif speed <= 0.5 and wep:IsRoaring() then
		pl.CalcSeqOverride = pl:LookupSequence("menu_zombie_01")
	elseif speed > 16 and wep:GetSwinging() then
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE_FAST
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if not wep:IsValid() or not wep.GetClimbing then return end

	if wep:GetSwinging() then
		if not pl.PlayingFZSwing then
			pl.PlayingFZSwing = true
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY)
		end
	elseif pl.PlayingFZSwing then
		pl.PlayingFZSwing = false
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD) --pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY, true)
	end

	if wep:GetClimbing() then
		local vel = pl:GetVelocity()
		local speed = vel:Length()
		if speed > 8 then
			pl:SetPlaybackRate(math.Clamp(speed / 160, 0, 1) * (vel.z < 0 and -1 or 1))
		else
			pl:SetPlaybackRate(0)
		end

		return true
	end

	if wep:GetPounceTime() > 0 then
		pl:SetPlaybackRate(0.25)

		if not pl.m_PrevFrameCycle then
			pl.m_PrevFrameCycle = true
			pl:SetCycle(0)
		end

		return true
	elseif pl.m_PrevFrameCycle then
		pl.m_PrevFrameCycle = nil
	end

	local speed = velocity:Length2D()
	if not pl:OnGround() or pl:WaterLevel() >= 3 then
		pl:SetPlaybackRate(1)

		if pl:GetCycle() >= 1 then
			pl:SetCycle(pl:GetCycle() - 1)
		end

		return true
	end
	if speed <= 0.5 and wep:IsRoaring() then
		pl:SetPlaybackRate(0)
		pl:SetCycle(math.Clamp(1 - (wep:GetRoarEndTime() - CurTime()) / wep.RoarTime, 0, 1) * 0.9)

		return true
	end
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		return ACT_INVALID
	end
end

if SERVER then
	function CLASS:ReviveCallback(pl, attacker, dmginfo)
		if not pl.Revive and not dmginfo:GetInflictor().IsMelee and dmginfo:GetDamageType() ~= DMG_BLAST and dmginfo:GetDamageType() ~= DMG_BURN and (pl:LastHitGroup() == HITGROUP_LEFTLEG or pl:LastHitGroup() == HITGROUP_RIGHTLEG) and math.random(3) == 1 then
			local classtable = GAMEMODE.ZombieClasses["Fast Zombie Legs"]
			if classtable then
				pl:RemoveStatus("overridemodel", false, true)
				local deathclass = pl.DeathClass or pl:GetZombieClass()
				pl:SetZombieClass(classtable.Index)
				pl:DoHulls(classtable.Index, TEAM_UNDEAD)
				pl.DeathClass = deathclass

				pl:EmitSound("physics/flesh/flesh_bloody_break.wav", 100, 75)

				pl:Gib()
				pl.Gibbed = nil

				timer.Simple(0, function()
					if IsValid(pl) then
						pl:SecondWind()
					end
				end)

				return true
			end
		end

		return false
	end
end

if SERVER then return end

CLASS.Icon = "zombiesurvival/killicons/fastzombie"

function CLASS:CreateMove(pl, cmd)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsPouncing then
		if wep.m_ViewAngles and wep:IsPouncing() then
			local maxdiff = FrameTime() * 20
			local mindiff = -maxdiff
			local originalangles = wep.m_ViewAngles
			local viewangles = cmd:GetViewAngles()

			local diff = math.AngleDifference(viewangles.yaw, originalangles.yaw)
			if diff > maxdiff or diff < mindiff then
				viewangles.yaw = math.NormalizeAngle(originalangles.yaw + math.Clamp(diff, mindiff, maxdiff))
			end

			wep.m_ViewAngles = viewangles

			cmd:SetViewAngles(viewangles)
		--[[elseif wep:IsClimbing() then
			local buttons = cmd:GetButtons()
			if bit.band(buttons, IN_DUCK) ~= 0 then
				cmd:SetButtons(buttons - IN_DUCK)
			end]]
		end
	end
end
