CLASS.Name = "Will O' Wisp"
CLASS.TranslationName = "class_wilowisp"
CLASS.Description = "description_wilowisp"

CLASS.Health = 10000
CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Model = Model("models/error.mdl")
CLASS.Speed = 260
CLASS.JumpPower = 0

CLASS.PainSounds = {Sound("npc/scanner/photo1.wav")}
CLASS.DeathSounds = {Sound("zombiesurvival/wraithdeath1.ogg"), Sound("zombiesurvival/wraithdeath2.ogg"), Sound("zombiesurvival/wraithdeath3.ogg"), Sound("zombiesurvival/wraithdeath4.ogg")}

CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.SWEP = "weapon_zs_special_wow"

CLASS.Hull = {Vector(-3, -3, 0), Vector(3, 3, 6)}
CLASS.HullDuck = {Vector(-3, -3, 0), Vector(3, 3, 6)}
CLASS.ViewOffset = Vector(0, 0, 3)
CLASS.ViewOffsetDucked = Vector(0, 0, 3)
CLASS.CrouchedWalkSpeed = 1
CLASS.Mass = 2
CLASS.MoveType = MOVETYPE_FLY

CLASS.NoGibs = true
CLASS.NoCollideAll = true
CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true
CLASS.Points = 0

CLASS.CameraDistance = 64

function CLASS:CanUse(pl)
	return pl:SteamID() == "STEAM_0:1:3307510" or pl:SteamID() == "STEAM_0:0:4187062"
end

function CLASS:NoDeathMessage(pl, attacker, dmginfo)
	return true
end

function CLASS:DoesntGiveFear()
	return true
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	dmginfo:SetDamage(0)
	dmginfo:ScaleDamage(0)
	return true
end

function CLASS:ShouldDrawLocalPlayer(pl)
	return true
end

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	pl.CalcIdeal = ACT_IDLE
	pl.CalcSeqOverride = -1

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	return ACT_INVALID
end

function CLASS:Move(pl, mv)
	pl:SetGroundEntity(NULL)

	mv:SetForwardSpeed(0)
	mv:SetSideSpeed(0)

	local vel = mv:GetVelocity()

	if pl:KeyDown(IN_FORWARD) then
		vel = vel + 180 * FrameTime() * pl:GetAimVector()
	elseif pl:KeyDown(IN_BACK) then
		vel = vel - 180 * FrameTime() * pl:GetAimVector()
	else
		vel = vel * math.max(1 - FrameTime() * 0.5, 0)
	end

	if vel:Length() >= self.Speed then
		vel:Normalize()
		vel = vel * self.Speed
	end

	mv:SetVelocity(vel)

	return true
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	return true
end

if not CLIENT then return end

CLASS.Icon = "sprites/glow04_noz"

function CLASS:PrePlayerDraw(pl)
	return true
end
