CLASS.Name = "Gore Child"
CLASS.TranslationName = "class_gore_child"
CLASS.Description = "description_gore_child"
CLASS.Help = "controls_gore_child"

CLASS.Wave = 0
CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.Health = 15
CLASS.Speed = 120

CLASS.Points = 0.5

CLASS.CanTaunt = true

CLASS.SWEP = "weapon_zs_gorechild"

CLASS.Model = Model("models/vinrax/player/doll_player.mdl")

CLASS.VoicePitch = 1.5

CLASS.ModelScale = 0.4

CLASS.Mass = 30
CLASS.ViewOffset = DEFAULT_VIEW_OFFSET * CLASS.ModelScale
CLASS.ViewOffsetDucked = DEFAULT_VIEW_OFFSET_DUCKED * CLASS.ModelScale
CLASS.StepSize = 8
CLASS.Hull = {Vector(-16, -16, 0) * CLASS.ModelScale, Vector(16, 16, 100) * CLASS.ModelScale}
CLASS.HullDuck = {Vector(-16, -16, 0) * CLASS.ModelScale, Vector(16, 16, 60) * CLASS.ModelScale}

CLASS.CanFeignDeath = true

local mathrandom = math.random
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
		pl:EmitSound(StepLeftSounds[mathrandom(#StepLeftSounds)], 55, 150)
	else
		pl:EmitSound(StepRightSounds[mathrandom(#StepRightSounds)], 55, 150)
	end

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetDirection() == DIR_BACK then
			pl.CalcSeqOverride = pl:LookupSequence("zombie_slump_rise_02_fast")
		else
			pl.CalcIdeal = ACT_HL2MP_ZOMBIE_SLUMP_RISE
		end
		return true
	end

	if pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_HL2MP_SWIM_PISTOL
	elseif pl:Crouching() then
		if velocity:Length2D() <= 0.5 then
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
		else
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
		end
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if not wep:IsValid() or not wep.GetSwinging then return end

	if wep:GetSwinging() then
		if not pl.PlayingFZSwing then
			pl.PlayingFZSwing = true
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY)
		end
	elseif pl.PlayingFZSwing then
		pl.PlayingFZSwing = false
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end

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
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed, 3))
	else
		pl:SetPlaybackRate(1)
	end

	if velocity:Length2D() >= 16 then
		pl:SetPlaybackRate(pl:GetPlaybackRate() * 1.5)
	end

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	return GAMEMODE.BaseClass.PlayerStepSoundTime(GAMEMODE.BaseClass, pl, iType, bWalking) * 0.5
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		return ACT_INVALID
	end
end

function CLASS:DoesntGiveFear(pl)
	return pl.FeignDeath and pl.FeignDeath:IsValid()
end

function CLASS:PlayPainSound(pl)
	pl:EmitSound("ambient/creatures/teddy.wav", 65, math.random(140, 150))
	pl.NextPainSound = CurTime() + 0.6

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("ambient/voices/citizen_beaten"..math.random(5)..".wav", 70, math.random(140, 150))

	return true
end

if SERVER then
	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
		pl:FakeDeath(pl:LookupSequence("death_0"..math.random(4)), self.ModelScale)

		return true
	end

	function CLASS:PostOnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
		pl:SetZombieClass(GAMEMODE.DefaultZombieClass)
	end

	function CLASS:AltUse(pl)
		pl:StartFeignDeath()
	end
end

--[[function CLASS:Move(pl, move)
	local mypos = move:GetOrigin()

	for _, ent in pairs(team.GetPlayers(TEAM_HUMAN)) do
		local pos = ent:GetPos()
		local dist = mypos:Distance(pos)
		if dist <= 16 then
			local dir = mypos - pos
			dir.z = 0
			dir:Normalize()
			move:SetVelocity(move:GetVelocity() + FrameTime() * 400 * (1 - dist / 16) * dir)
		end
	end
end]]

if not CLIENT then return end

function CLASS:ShouldDrawLocalPlayer(pl)
	return true
end
