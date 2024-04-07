CLASS.Base = "zombie_torso"

CLASS.Hidden = true

CLASS.Name = "Fast Zombie Torso"
CLASS.TranslationName = "class_fast_zombie_torso"
CLASS.Description = "description_fast_zombie_torso"

CLASS.Model = Model("models/zombie/fast_torso.mdl")

CLASS.SWEP = "weapon_zs_fastzombietorso"

CLASS.Health = 75
CLASS.Speed = 150
CLASS.JumpPower = 130

CLASS.Points = CLASS.Health/GM.TorsoZombiePointRatio

CLASS.PainSounds = {"NPC_FastZombie.Pain"}
CLASS.DeathSounds = {"npc/fast_zombie/leap1.wav"}

CLASS.VoicePitch = 0.75

CLASS.IsTorso = true

local ACT_IDLE = ACT_IDLE
local ACT_WALK = ACT_WALK

function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2DSqr() <= 1 then
		return ACT_IDLE, -1
	end

	return ACT_WALK, -1
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
end

if SERVER then
	function CLASS:OnSecondWind(pl)
		pl:EmitSound("NPC_FastZombie.Frenzy")
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/fast_torso"
