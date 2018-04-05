CLASS.Name = "PVP"
CLASS.TranslationName = "class_pvp"
CLASS.Description = "description_pvp"
CLASS.Help = "controls_pvp"

CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.Health = 100
CLASS.Speed = 215
CLASS.Revives = false

CLASS.CanTaunt = true

CLASS.Points = 50

CLASS.SWEP = "weapon_zs_boomstick"

CLASS.Model = Model("models/player/riot.mdl")

--CLASS.PainSounds = {"npc/zombie/zombie_pain1.wav", "npc/zombie/zombie_pain2.wav", "npc/zombie/zombie_pain3.wav", "npc/zombie/zombie_pain4.wav", "npc/zombie/zombie_pain5.wav", "npc/zombie/zombie_pain6.wav"}

CLASS.VoicePitch = 0.65

CLASS.CanFeignDeath = false

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	return false
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
	return false
end

function CLASS:CalcMainActivity(pl, velocity)
	return false
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	return false
end

function CLASS:DoAnimationEvent(pl, event, data)

end

function CLASS:DoesntGiveFear(pl)

end

if CLIENT then
	CLASS.Icon = "zombiesurvival/killicons/zombie"
end
