CLASS.Base = "boss_nightmare"

CLASS.Name = "night reaver"
CLASS.TranslationName = "class_night_reaver"
CLASS.Description = "description_night_reaver"
CLASS.Help = "controls_night_reaver"

CLASS.Boss = true

CLASS.Health = 1800
CLASS.Speed = 200

CLASS.Points = 60

CLASS.SWEP = "weapon_zs_nightreaver"

CLASS.Model = Model("models/player/zafast.mdl")
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
