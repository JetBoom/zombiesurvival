CLASS.Name = "Headcrab"
CLASS.TranslationName = "class_headcrab"
CLASS.Description = "description_headcrab"
CLASS.Help = "controls_headcrab"

CLASS.Model = Model("models/headcrabclassic.mdl")

CLASS.Wave = 0
CLASS.Unlocked = true

CLASS.SWEP = "weapon_zs_headcrab"

CLASS.Health = 40
CLASS.Speed = 160
CLASS.JumpPower = 100

CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true

CLASS.Points = 2

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
			pl.CalcSeqOverride = 11
			return true
		elseif time < 0 then
			pl.CalcSeqOverride = 10
			return true
		end
	end

	if pl:OnGround() then
		if velocity:Length2D() > 0.5 then
			pl.CalcIdeal = ACT_RUN
		else
			pl.CalcSeqOverride = 1
		end
	elseif pl:WaterLevel() >= 3 then
		pl.CalcSeqOverride = 6
	else
		pl.CalcSeqOverride = 5
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)

	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime then
		local time = wep:GetBurrowTime()
		if time ~= 0 then
			pl:SetCycle(math.Clamp((math.abs(time) - CurTime()) / wep.BurrowTime, 0, 1))
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
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.5, 2))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoesntGiveFear(pl)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime then
		return wep:GetBurrowTime() > 0 and CurTime() > math.abs(wep:GetBurrowTime())
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
	if wep:IsValid() and wep.GetBurrowTime and wep:GetBurrowTime() ~= 0 and CurTime() >= math.abs(wep:GetBurrowTime()) then
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
