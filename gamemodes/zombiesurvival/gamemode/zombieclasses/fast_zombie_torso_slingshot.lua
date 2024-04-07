CLASS.Base = "zombie_torso"

CLASS.Hidden = true

CLASS.Name = "Slingshot Zombie Torso"
CLASS.TranslationName = "class_fast_zombie_torso_slingshot"
CLASS.Description = "description_fast_zombie_torso_slingshot"

CLASS.Model = Model("models/zombie/fast_torso.mdl")

CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 28)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 28)}

CLASS.SWEP = "weapon_zs_fastzombietorso_slingshot"

CLASS.Health = 140
CLASS.Speed = 160
CLASS.JumpPower = 130

CLASS.Points = CLASS.Health/GM.TorsoZombiePointRatio

CLASS.PainSounds = {"NPC_FastZombie.Pain"}
CLASS.DeathSounds = {"npc/fast_zombie/leap1.wav"}

CLASS.VoicePitch = 0.75

CLASS.IsTorso = true

CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true

local math_min = math.min

local ACT_IDLE = ACT_IDLE
local ACT_WALK = ACT_WALK

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end
end

function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2DSqr() <= 1 then
		return ACT_IDLE, -1
	end

	return ACT_WALK, -1
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local len2d = velocity:Length2D()
	if pl:IsOnGround() then
		pl:SetPlaybackRate(math_min(len2d / maxseqgroundspeed * 0.66, 3))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

if SERVER then
	function CLASS:ProcessDamage(pl, dmginfo)
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() and wep.IsPouncing and wep:IsPouncing() then
			if dmginfo:GetAttacker():IsValidLivingHuman() and dmginfo:GetDamage() >= 8 then
				wep:StopPounce()
				pl:SetLocalVelocity(pl:GetVelocity() * 0.9)
			end
		end
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/fast_torso"
CLASS.IconColor = Color(163, 94, 99)

function CLASS:CreateMove(pl, cmd)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsPouncing and wep.m_ViewAngles then
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
	end
end

local matSkin = Material("models/barnacle/barnacle_sheet")

function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(0.64, 0.37, 0.39)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
end
