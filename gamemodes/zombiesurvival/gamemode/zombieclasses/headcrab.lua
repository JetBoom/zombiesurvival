CLASS.Name = "Headcrab"
CLASS.TranslationName = "class_headcrab"
CLASS.Description = "description_headcrab"
CLASS.Help = "controls_headcrab"

CLASS.Model = Model("models/headcrabclassic.mdl")

CLASS.Wave = 0
CLASS.Unlocked = true

CLASS.SWEP = "weapon_zs_headcrab"

CLASS.Health = 70
CLASS.Speed = 175
CLASS.JumpPower = 100

CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true

CLASS.Points = CLASS.Health/GM.HeadcrabZombiePointRatio

CLASS.Hull = {Vector(-12, -12, 0), Vector(12, 12, 18.1)}
CLASS.HullDuck = {Vector(-12, -12, 0), Vector(12, 12, 18.1)}
CLASS.ViewOffset = Vector(0, 0, 10)
CLASS.ViewOffsetDucked = Vector(0, 0, 10)
CLASS.StepSize = 8
CLASS.CrouchedWalkSpeed = 1
CLASS.Mass = 25

CLASS.CantDuck = true

CLASS.IsHeadcrab = true

CLASS.PainSounds = {"NPC_HeadCrab.Pain"}
CLASS.DeathSounds = {"NPC_HeadCrab.Die"}

CLASS.BloodColor = BLOOD_COLOR_YELLOW

local CurTime = CurTime
local math_min = math.min
local math_Clamp = math.Clamp
local math_abs = math.abs

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end
end

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	return true
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime then
		local time = wep:GetBurrowTime()
		if time > 0 then
			return 1, 11
		end
		if time < 0 then
			return 1, 10
		end
	end

	if pl:OnGround() then
		if velocity:Length2DSqr() > 1 then
			return ACT_RUN, -1
		end

		return 1, 1
	end

	if pl:WaterLevel() >= 3 then
		return 1, 6
	end

	return 1, 5
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime then
		local time = wep:GetBurrowTime()
		if time ~= 0 then
			pl:SetCycle(math_Clamp((math_abs(time) - CurTime()) / wep.BurrowTime, 0, 1))
			pl:SetPlaybackRate(0)
			return true
		end
	end

	local seq = pl:GetSequence()
	if seq == 5 then
		if not pl.m_PrevFrameCycle then
			pl.m_PrevFrameCycle = true
			pl:SetCycle(0)
		end

		pl:SetPlaybackRate(1)

		return true
	elseif pl.m_PrevFrameCycle then
		pl.m_PrevFrameCycle = nil
	end

	local len2d = velocity:Length2D()
	if len2d > 1 then
		pl:SetPlaybackRate(math_min(len2d / maxseqgroundspeed * 0.5, 2))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoesntGiveFear(pl)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime then
		return wep:GetBurrowTime() > 0 and CurTime() > math_abs(wep:GetBurrowTime())
	end
end
CLASS.NoDraw = CLASS.DoesntGiveFear

function CLASS:ShouldDrawLocalPlayer(pl)
	local wep = pl:GetActiveWeapon()
	return wep:IsValid() and wep.GetBurrowTime and wep:GetBurrowTime() ~= 0
end

if SERVER then
	function CLASS:AltUse(pl)
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() then wep:Reload() end
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/headcrab"

function CLASS:PrePlayerDraw(pl)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime and wep:GetBurrowTime() ~= 0 and CurTime() >= math_abs(wep:GetBurrowTime()) then
		return true
	end
end

function CLASS:CreateMove(pl, cmd)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.m_ViewAngles and wep.IsPouncing and wep:IsPouncing() then
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
