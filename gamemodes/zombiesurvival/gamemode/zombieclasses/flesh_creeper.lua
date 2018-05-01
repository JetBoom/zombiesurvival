CLASS.Name = "Flesh Creeper"
CLASS.TranslationName = "class_flesh_creeper"
CLASS.Description = "description_flesh_creeper"
CLASS.Help = "controls_flesh_creeper"

CLASS.Wave = 0
CLASS.Hidden = true
CLASS.Unlocked = true
CLASS.NotRandomStart = true

CLASS.Health = 175
CLASS.SWEP = "weapon_zs_fleshcreeper"
CLASS.Model = Model("models/antlion.mdl")
CLASS.Speed = 160
CLASS.JumpPower = 220

CLASS.Points = CLASS.Health/GM.NoHeadboxZombiePointRatio

CLASS.VoicePitch = 0.55

CLASS.PainSounds = {Sound("npc/barnacle/barnacle_pull1.wav"), Sound("npc/barnacle/barnacle_pull2.wav"), Sound("npc/barnacle/barnacle_pull3.wav"), Sound("npc/barnacle/barnacle_pull4.wav")}
CLASS.DeathSounds = {Sound("npc/barnacle/barnacle_die1.wav"), Sound("npc/barnacle/barnacle_die2.wav")}

CLASS.ModelScale = 0.65
--[[CLASS.ModelScale = 0.6324555
CLASS.ClientsideModelScale = 0.4 / CLASS.ModelScale]]

CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 36)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 36)}

CLASS.ViewOffset = Vector(0, 0, 35.5)
CLASS.ViewOffsetDucked = Vector(0, 0, 35.5)

local CurTime = CurTime
local math_random = math.random
local math_sin = math.sin
local IN_JUMP = IN_JUMP

function CLASS:CanUse(pl)
	return GAMEMODE:GetDynamicSpawning() and not GAMEMODE.ZombieEscape
end

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end

	if mv:GetForwardSpeed() <= 0 then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.45)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.45)
	end
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsInAttackAnim then
		if wep:IsInAttackAnim() then
			return 1, 14
		end

		if wep:GetHoldingRightClick() then
			return 1, 21
		end
	end

	if wep.IsPouncing and wep:IsPouncing() then
		return ACT_GLIDE, -1
	end

	if velocity:Length2DSqr() > 1 then
		--[[if pl:Crouching() and pl:OnGround() then
			return 1, 17
		else]]
			return 1, 4
		--[[end
	elseif pl:Crouching() and pl:OnGround() then
		pl.CalcSeqOverride = 40]]
	end


	return 1, 2
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsInAttackAnim then
		if wep:IsInAttackAnim() then
			pl:SetPlaybackRate(0)
			pl:SetCycle(1 - (wep:GetAttackAnimTime() - CurTime()) / wep.Primary.Delay)

			return true
		elseif wep:GetHoldingRightClick() then
			pl:SetPlaybackRate(0)

			local delta = CurTime() - wep:GetRightClickStart()
			if delta > 1 then
				--pl:SetCycle(0.333 + (delta * 3 % 1) * 0.2)
				pl:SetCycle(0.5 + math_sin(delta * 12) * 0.05)
			else
				--pl:SetCycle(delta / 3)
				pl:SetCycle(delta / 2)
			end

			return true
		end
	end

	if velocity:Length2DSqr() >= 256 then
		GAMEMODE.BaseClass.UpdateAnimation(GAMEMODE.BaseClass, pl, velocity, maxseqgroundspeed)

		--[[local dir = Vector(0, 0, 0)
		dir:Set(velocity)
		dir.z = 0
		dir:Normalize()
		local aimdir = pl:GetAimVector()
		aimdir.z = 0
		aimdir:Normalize()

		if dir:Dot(aimdir) >= 0.5 then
			pl:SetPlaybackRate(pl:GetPlaybackRate() / self.ModelScale / 2)
		else]]
			pl:SetPlaybackRate(pl:GetPlaybackRate() / self.ModelScale)
		--end

		--[[if pl:Crouching() then
			pl:SetPoseParameter("move_yaw", 0)
		end]]

		return true
	end

	--[[if pl:Crouching() then
		pl:SetCycle(0.5 + math.sin(CurTime() * 2) * 0.025)
		pl:SetPlaybackRate(0)

		return true
	end]]

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		return ACT_INVALID
	end
end

function CLASS:CreateMove(pl, cmd)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsSwinging and wep:IsSwinging() and bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 then
		cmd:SetButtons(cmd:GetButtons() - IN_JUMP)
	end
end

local FootSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	pl:EmitSound(FootSounds[math_random(#FootSounds)], 65, math.random(105, 115))

	return true
end

if SERVER then
	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
		local ent = pl:FakeDeath(pl:LookupSequence("Flip1"), self.ModelScale, math.Rand(0.45, 0.5))
		if ent:IsValid() then
			ent:SetMaterial("models/flesh")
		end

		return true
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/fleshcreeper"

local matFlesh = Material("models/flesh")
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matFlesh)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
end

function CLASS:ShouldDrawLocalPlayer()
	return true
end
