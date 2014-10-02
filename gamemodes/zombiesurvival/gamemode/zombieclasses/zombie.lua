CLASS.Name = "Zombie"
CLASS.TranslationName = "class_zombie"
CLASS.Description = "description_zombie"
CLASS.Help = "controls_zombie"

CLASS.Wave = 0
CLASS.Unlocked = true
CLASS.IsDefault = true
CLASS.Order = 0

CLASS.Health = 200
CLASS.Speed = 140
CLASS.Revives = true

CLASS.CanTaunt = true

CLASS.Points = 5

CLASS.SWEP = "weapon_zs_zombie"

CLASS.Model = Model("models/player/zombie_classic.mdl")

CLASS.PainSounds = {"npc/zombie/zombie_pain1.wav", "npc/zombie/zombie_pain2.wav", "npc/zombie/zombie_pain3.wav", "npc/zombie/zombie_pain4.wav", "npc/zombie/zombie_pain5.wav", "npc/zombie/zombie_pain6.wav"}
CLASS.DeathSounds = {"npc/zombie/zombie_die1.wav", "npc/zombie/zombie_die2.wav", "npc/zombie/zombie_die3.wav"}

CLASS.VoicePitch = 0.65

CLASS.CanFeignDeath = true

function CLASS:KnockedDown(pl, status, exists)
	pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
end

local mathrandom = math.random
local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
local ScuffSounds = {
	"npc/zombie/foot_slide1.wav",
	"npc/zombie/foot_slide2.wav",
	"npc/zombie/foot_slide3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if mathrandom() < 0.15 then
		pl:EmitSound(ScuffSounds[mathrandom(#ScuffSounds)], 70)
	else
		pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 70)
	end

	return true
end

-- Sound scripts are LITERALLY 100x slower than raw file input. Test it yourself if you don't believe me.
--[[function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		if mathrandom() < 0.15 then
			pl:EmitSound("Zombie.ScuffLeft")
		else
			pl:EmitSound("Zombie.FootstepLeft")
		end
	else
		if mathrandom() < 0.15 then
			pl:EmitSound("Zombie.ScuffRight")
		else
			pl:EmitSound("Zombie.FootstepRight")
		end
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
	local revive = pl.Revive
	if revive and revive:IsValid() then
		pl.CalcIdeal = ACT_HL2MP_ZOMBIE_SLUMP_RISE
		return true
	end

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
		return true
	end

	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsMoaning and wep:IsMoaning() then
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
	elseif velocity:Length2D() <= 0.5 then
		if pl:Crouching() then
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
		else
			pl.CalcIdeal = ACT_HL2MP_IDLE_ZOMBIE
		end
	elseif pl:Crouching() then
		pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
	else
		pl.CalcIdeal = ACT_HL2MP_WALK_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local revive = pl.Revive
	if revive and revive:IsValid() then
		pl:SetCycle(0.4 + (1 - math.Clamp((revive:GetReviveTime() - CurTime()) / revive.AnimTime, 0, 1)) * 0.6)
		pl:SetPlaybackRate(0)
		return true
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
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() and wep.IsMoaning and wep:IsMoaning() then
			pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed, 3))
		else
			pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.666, 3))
		end
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
		return ACT_INVALID
	end
end

function CLASS:DoesntGiveFear(pl)
	return pl.FeignDeath and pl.FeignDeath:IsValid()
end

if SERVER then
	function CLASS:AltUse(pl)
		pl:StartFeignDeath()
	end

	function CLASS:ProcessDamage(pl, dmginfo)
		local attacker, inflictor, damage = dmginfo:GetAttacker(), dmginfo:GetInflictor(), dmginfo:GetDamage()
		if attacker ~= pl and damage >= pl:Health() and pl:LastHitGroup() ~= HITGROUP_HEAD and damage < 70 and not inflictor.IsMelee and not inflictor.NoReviveFromKills and dmginfo:GetDamageType() ~= DMG_BLAST and dmginfo:GetDamageType() ~= DMG_BURN and dmginfo:GetDamageType() ~= DMG_CRUSH and (pl.NextZombieRevive or 0) <= CurTime() and pl:LastHitGroup() ~= HITGROUP_LEFTLEG and pl:LastHitGroup() ~= HITGROUP_RIGHTLEG then
			pl.NextZombieRevive = CurTime() + 3

			dmginfo:SetDamage(0)
			pl:SetHealth(10)

			local status = pl:GiveStatus("revive_slump")
			if status then
				status:SetReviveTime(CurTime() + 2.25)
			end

			return true
		end
	end

	function CLASS:ReviveCallback(pl, attacker, dmginfo)
		if not pl.Revive and not dmginfo:GetInflictor().IsMelee and not dmginfo:GetInflictor().NoReviveFromKills and dmginfo:GetDamageType() ~= DMG_BLAST and dmginfo:GetDamageType() ~= DMG_BURN and (pl:LastHitGroup() == HITGROUP_LEFTLEG or pl:LastHitGroup() == HITGROUP_RIGHTLEG) then
			local classtable = math.random(1) == 3 and GAMEMODE.ZombieClasses["Zombie Legs"] or GAMEMODE.ZombieClasses["Zombie Torso"]
			if classtable then
				pl:RemoveStatus("overridemodel", false, true)
				local deathclass = pl.DeathClass or pl:GetZombieClass()
				pl:SetZombieClass(classtable.Index)
				pl:DoHulls(classtable.Index, TEAM_UNDEAD)
				pl.DeathClass = deathclass

				pl:EmitSound("physics/flesh/flesh_bloody_break.wav", 100, 75)

				if classtable == GAMEMODE.ZombieClasses["Zombie Torso"] then
					local ent = ents.Create("prop_dynamic_override")
					if ent:IsValid() then
						ent:SetModel(Model("models/Zombie/Classic_legs.mdl"))
						ent:SetPos(pl:GetPos())
						ent:SetAngles(pl:GetAngles())
						ent:Spawn()
						ent:Fire("kill", "", 1.5)
					end
				end

				pl:Gib()
				pl.Gibbed = nil

				timer.Simple(0, function()
					if pl:IsValid() then
						pl:SecondWind()
					end
				end)

				return true
			end
		end

		return false
	end

	function CLASS:OnSecondWind(pl)
		pl:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav", 100, 85)
	end
end

if CLIENT then
	CLASS.Icon = "zombiesurvival/killicons/zombie"
end
