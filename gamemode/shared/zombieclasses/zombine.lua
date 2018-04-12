CLASS.Name = "Zombine"
CLASS.TranslationName = "class_zombine"
CLASS.Description = "description_zombine"
CLASS.Help = "controls_zombine"

CLASS.Wave = 6 / 6

CLASS.Health = 380
CLASS.Speed = 120
CLASS.JumpPower = 150
CLASS.Mass = DEFAULT_MASS

CLASS.CanTaunt = false

CLASS.Points = 7

CLASS.SWEP = "weapon_zs_zombine"

CLASS.Model = Model("models/zombie/zombie_soldier.mdl")

CLASS.DeathSounds = {"weapons/npc/zombine/zombine_die"..math.random(1, 2)..".wav"}

CLASS.PainSounds = {"weapons/npc/zombine/zombine_pain"..math.random(1, 4)..".wav"}

CLASS.VoicePitch = 0.6

CLASS.CanFeignDeath = false

local AddHeadCrab = true

sound.Add({
	name = "fatty.footstep",
    channel = CHAN_BODY,
    volume = 0.8,
    soundlevel = 65,
    pitchstart = 75,
    pitchend = 75,
    sound = {"npc/combine_soldier/gear1.wav", "npc/combine_soldier/gear2.wav", "npc/combine_soldier/gear3.wav"}
})

sound.Add({
	name = "fatty.footscuff",
    channel = CHAN_BODY,
    volume = 0.8,
    soundlevel = 65,
    pitchstart = 75,
    pitchend = 75,
    sound = {"npc/combine_soldier/gear4.wav", "npc/combine_soldier/gear5.wav", "npc/combine_soldier/gear6.wav"}
})

local mathrandom = math.random

local StepSounds = {

	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav"
	
}
local ScuffSounds = {

	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav"
}

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if mathrandom() < 0.15 then
		pl:EmitSound(ScuffSounds[mathrandom(#ScuffSounds)], 70, 75)
	else
		pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 70, 75)
	end

	return true
end

function CLASS:Move(pl, mv)

	local wep = pl:GetActiveWeapon()
	
	if wep:IsValid() and wep.IsInAttackAnim then
		if wep:IsInAttackAnim() then
			mv:SetForwardSpeed( 0 )
			mv:SetSideSpeed( 0 )
		end
	end
	
	if wep:IsValid() then
		if wep.GetGrenading && wep:GetGrenading() && CurTime() < wep:GetGrenadeTime() then
			mv:SetForwardSpeed( 0 )
			mv:SetSideSpeed( 0 )
		end
	end
	
end

function CLASS:CalcMainActivity(pl, velocity)

	local wep = pl:GetActiveWeapon()
	
	if not wep:IsValid() then return end
	
	if wep.IsInAttackAnim then
		if wep:IsInAttackAnim() then
			pl.CalcSeqOverride = pl:LookupSequence("FastAttack")
			return true
		end
	end
	
	if wep.IsMoaning then
		if wep:IsMoaning() then
			if velocity:Length2D() > 0.5 then
				if not wep:GetGrenading() then
					pl.CalcIdeal = ACT_RUN
				else
					pl.CalcSeqOverride = pl:LookupSequence("Run_All_grenade")
				end	
			else	
				if not wep:GetGrenading() then
					pl.CalcIdeal = ACT_IDLE
				else
					pl.CalcSeqOverride = pl:LookupSequence("Idle_Grenade")
				end	
			end	
			return true
		end	
	end
	
	if wep.GetGrenading then
		if wep:GetGrenading() then
			if CurTime() <= wep:GetGrenadeTime() then
				pl.CalcSeqOverride = pl:LookupSequence("pullGrenade")
			else
				if velocity:Length2D() > 0.5 then
					pl.CalcSeqOverride = pl:LookupSequence("walk_All_Grenade")
				else	
					pl.CalcSeqOverride = pl:LookupSequence("Idle_Grenade")
				end	
			end
			return true
		end	
		
	end
	
	if pl:OnGround() then
		if velocity:Length2D() > 0.5 then
			pl.CalcIdeal = ACT_WALK
		else
			pl.CalcIdeal = ACT_IDLE
		end
	elseif pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_RUN
	else
		pl.CalcIdeal = ACT_RUN
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)

	pl:FixModelAngles(velocity)
	
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsInAttackAnim then
		if wep:IsInAttackAnim() then
			pl:SetPlaybackRate(0)
			pl:SetCycle((1 - (wep:GetAttackAnimTime() - CurTime()) / wep.Primary.Delay))

			return true
		end
	end	

	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() and wep.IsMoaning and wep:IsMoaning() then
			pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed, 3))	
		elseif wep:IsValid() and wep.GetGrenading and wep:GetGrenading() then
			pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.555, 2))
		else
			pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.555, 3))
		end
	else
		pl:SetPlaybackRate(1)
	end
	
	if !pl:IsOnGround() || pl:WaterLevel() >= 3 then
	
		pl:SetPlaybackRate(1)
	
		if pl:GetCycle() >= 1 then
			pl:SetCycle(pl:GetCycle() - 1)
		end

		return true
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		return ACT_INVALID
	end
end

function CLASS:ProcessDamage(pl, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local wep = pl:GetActiveWeapon()
	if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		if wep:IsValid() and wep:IsMoaning() and wep.IsMoaning then
			wep:StopMoaning()
		end	
	end
end

function CLASS:DoesntGiveFear(pl)
	return IsValid(pl.FeignDeath)
end

if SERVER then
	
	function CLASS:OnSpawned(pl)
	
		if AddHeadCrab then
			if pl:GetZombieClassTable().Name == "Zombine" then
	
				pl:SetBodygroup( 1, 1 )
			
			end
		
		end	
		
	end

	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
	
		if AddHeadCrab then
		
			if pl:GetZombieClassTable().Name == "Zombine" then
	
				pl:SetBodygroup( 1, 0 )
			
			end
		
		end	
		
	end
	
end	

if CLIENT then
	CLASS.Icon = "zombiesurvival/killicons/zs_zombine"
end