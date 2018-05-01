CLASS.Base = "boss_willowisp"

CLASS.Name = "Cool Wisp"
CLASS.TranslationName = "class_coolwisp"
CLASS.Description = "description_coolwisp"
CLASS.Help = "controls_coolwisp"

CLASS.Boss = true

CLASS.SWEP = "weapon_zs_coolwisp"

CLASS.Health = 900

CLASS.Points = 20

CLASS.ResistFrost = true

CLASS.DeathSounds = {Sound("npc/scanner/cbot_energyexplosion1.wav")}

local math_random = math.random
local string_format = string.format
local math_Rand = math.Rand

function CLASS:PlayPainSound(pl)
	pl:EmitSound(string_format("physics/glass/glass_impact_bullet%d.wav", math_random(4)), 75, math_Rand(105, 128))
	pl.NextPainSound = CurTime() + 0.75

	return true
end
