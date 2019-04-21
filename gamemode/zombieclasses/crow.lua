CLASS.Name = "Crow"
CLASS.TranslationName = "class_crow"
CLASS.Description = "description_crow"

CLASS.Health = 5
CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.SWEP = "weapon_zs_crow"
CLASS.Model = Model("models/crow.mdl")
CLASS.Speed = 90
CLASS.JumpPower = 230

CLASS.PainSounds = {"NPC_Crow.Pain"}
CLASS.DeathSounds = {"NPC_Crow.Die"}

CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.Hull = {Vector(-4, -4, 0), Vector(4, 4, 9)}
CLASS.HullDuck = {Vector(-4, -4, 0), Vector(4, 4, 9)}
CLASS.ViewOffset = Vector(0,0,8)
CLASS.ViewOffsetDucked = Vector(0,0,8)
CLASS.CrouchedWalkSpeed = 1
CLASS.StepSize = 8
CLASS.Mass = 2

CLASS.NoUse = true
CLASS.NoGibs = true
CLASS.NoCollideAll = true
CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true
CLASS.NeverAlive = true
CLASS.AllowTeamDamage = true
CLASS.NoDeaths = true
CLASS.Points = 0

local ACT_RUN = ACT_RUN
local ACT_IDLE = ACT_IDLE
local ACT_FLY = ACT_FLY
local IN_JUMP = IN_JUMP
local IN_MOVELEFT = IN_MOVELEFT
local IN_MOVERIGHT = IN_MOVERIGHT
local IN_FORWARD = IN_FORWARD

function CLASS:NoDeathMessage(pl, attacker, dmginfo)
	return true
end

function CLASS:DoesntGiveFear()
	return true
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	return true
end

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	if pl:OnGround() then
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() and wep.IsPecking and wep:IsPecking() then
			return 1, 5
		end

		if velocity:Length2DSqr() > 1 then
			return ACT_RUN, -1
		end

		return ACT_IDLE, -1
	end

	if velocity:LengthSqr() > 122500 then --350^2
		return ACT_FLY, -1
	end

	return 1, 7
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)
	pl:SetPlaybackRate(1)
	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1, true)
		return ACT_INVALID
	end
end

function CLASS:Move(pl, mv)
	if not pl:GetActiveWeapon().IsCrow then return end

	if not pl:IsOnGround() and pl:KeyDown(IN_JUMP) then
		local dir = mv:GetAngles() --pl:EyeAngles()
		if pl:KeyDown(IN_MOVELEFT) then
			dir:RotateAroundAxis(dir:Up(), 20)
		elseif pl:KeyDown(IN_MOVERIGHT) then
			dir:RotateAroundAxis(dir:Up(), -20)
		end

		if pl:KeyDown(IN_FORWARD) then
			mv:SetVelocity(dir:Forward() * 450)
		else
			mv:SetVelocity(dir:Forward() * 300)
		end

		return true
	end
end

if SERVER then

function CLASS:SwitchedAway(pl)
	pl:SetAllowFullRotation(false)
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	pl:SetAllowFullRotation(false)

	if attacker:IsPlayer() and attacker ~= pl and attacker:Team() == TEAM_HUMAN then
		attacker.CrowKills = attacker.CrowKills + 1
	end

	if pl:Health() < -45 then
		local amount = pl:OBBMaxs():Length()
		local vel = pl:GetVelocity()
		util.Blood(pl:LocalToWorld(pl:OBBCenter()), math.Rand(amount * 0.25, amount * 0.5), vel:GetNormalized(), vel:Length() * 0.75)

		return true
	elseif not pl.KnockedDown then
		pl:CreateRagdoll()
	end

	pl:SetHealth(pl:GetMaxHealth())
	pl:StripWeapons()
	pl:Spectate(OBS_MODE_ROAMING)
end
end

if not CLIENT then return end

function CLASS:ShouldDrawLocalPlayer(pl)
	return true
end

CLASS.Icon = "zombiesurvival/killicons/crow"
