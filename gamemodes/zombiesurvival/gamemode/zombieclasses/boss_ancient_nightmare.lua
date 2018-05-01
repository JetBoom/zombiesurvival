CLASS.Base = "boss_nightmare"

CLASS.Name = "Ancient Nightmare"
CLASS.TranslationName = "class_ancient_nightmare"
CLASS.Description = "description_ancient_nightmare"
CLASS.Help = "controls_ancient_nightmare"

CLASS.Boss = true

CLASS.Health = 1825
CLASS.Speed = 165

CLASS.Points = 30

CLASS.SWEP = "weapon_zs_anightmare"

CLASS.Model = Model("models/player/skeleton.mdl")
CLASS.OverrideModel = false

CLASS.Skeletal = true

local math_random = math.random

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if math_random(2) == 1 then
		pl:EmitSound("npc/barnacle/neck_snap1.wav", 65, math_random(115, 130), 0.27)
	else
		pl:EmitSound("npc/barnacle/neck_snap2.wav", 65, math_random(115, 130), 0.27)
	end

	return true
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/ancient_nightmare"
