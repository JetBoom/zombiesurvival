CLASS.Name = "Fast Zombie Legs"
CLASS.TranslationName = "class_fast_zombie_legs"
CLASS.Description = "description_fast_zombie_legs"

CLASS.Model = Model("models/player/zombie_fast.mdl")
CLASS.OverrideModel = Model("models/Gibs/Fast_Zombie_Legs.mdl")
CLASS.NoHead = true

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.Health = 75
CLASS.Speed = 200
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
CLASS.CanFeignDeath = false

CLASS.VoicePitch = 0.65

CLASS.BloodColor = -1

CLASS.SWEP = "weapon_zs_fastzombielegs"

if SERVER then
	function CLASS:AltUse(pl)
		local feigndeath = pl.FeignDeath
		if feigndeath and feigndeath:IsValid() then
			if CurTime() >= feigndeath:GetStateEndTime() then
				feigndeath:SetState(1)
				feigndeath:SetStateEndTime(CurTime() + 1.5)
			end
		elseif pl:IsOnGround() and not pl:KeyDown(IN_FORWARD) and not pl:KeyDown(IN_MOVERIGHT) and not pl:KeyDown(IN_MOVELEFT) and not pl:KeyDown(IN_BACK) then
			local wep = pl:GetActiveWeapon()
			if wep:IsValid() and not wep:IsSwinging() and CurTime() > wep:GetNextPrimaryFire() then
				local status = pl:GiveStatus("feigndeath")
				if status and status:IsValid() then
					status:SetStateEndTime(CurTime() + 1.5)
				end
			end
		end
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
		return 1, pl:LookupSequence("zombie_slump_rise_02_fast")
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

CLASS.Icon = "zombiesurvival/killicons/fast_legs"

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
