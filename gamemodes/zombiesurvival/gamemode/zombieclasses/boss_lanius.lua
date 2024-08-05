CLASS.Name = "커럽터"
CLASS.TranslationName = "class_lanius"
CLASS.Description = "description_lanius"
CLASS.Help = "controls_lanius"

CLASS.Health = 750
CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.SWEP = "weapon_zs_lanius"
CLASS.Model = Model("models/pigeon.mdl")
CLASS.Speed = 60
CLASS.JumpPower = 230
CLASS.VoicePitch = 0.5
CLASS.FearPerInstance = 3
CLASS.ModelScale = 2.2

CLASS.PainSounds = {"npc/scanner/cbot_servoscared.wav"}
CLASS.DeathSounds = {"npc/combine_gunship/see_enemy.wav"}

CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = true

CLASS.Hull = {Vector(-6.6, -6.6, 0), Vector(6.6, 6.6, 9)}
--CLASS.HullDuck = {Vector(-7, -7, 0), Vector(7, 7, 8)}
CLASS.ViewOffset = Vector(0,0,8)
CLASS.ViewOffsetDucked = Vector(0,0,8)
CLASS.CrouchedWalkSpeed = 3
CLASS.StepSize = 8
CLASS.Mass = 6

CLASS.NoUse = false
CLASS.NoGibs = false
CLASS.NoCollideAll = false
CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true
CLASS.NoDeaths = false
CLASS.Points = 16

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
			pl.CalcSeqOverride = 5
		elseif velocity:Length2D() > 0.5 then
			pl.CalcIdeal = ACT_RUN
		else
			pl.CalcIdeal = ACT_IDLE
		end
	elseif velocity:Length() > 210 then
		pl.CalcIdeal = ACT_FLY
	else
		pl.CalcSeqOverride = 7
	end

	return true
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
		local dir = pl:EyeAngles()
		if pl:KeyDown(IN_MOVELEFT) then
			dir:RotateAroundAxis(dir:Up(), 20)
		elseif pl:KeyDown(IN_MOVERIGHT) then
			dir:RotateAroundAxis(dir:Up(), -20)
		end

		if pl:KeyDown(IN_FORWARD) then
			if pl:KeyDown(IN_DUCK) then
			mv:SetVelocity(dir:Forward() * 150)
			else 
			mv:SetVelocity(dir:Forward() * 260)
			end
		else
			mv:SetVelocity(dir:Forward() * 220)
		end

		return true
	end
end

if not CLIENT then return end

--[[function CLASS:ShouldDrawLocalPlayer(pl)
	return true
end]]
local matSkin = Material("models/flesh")
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(0.3, 0.4, 0.4)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
end


CLASS.Icon = "zombiesurvival/killicons/crow"
