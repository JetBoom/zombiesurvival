CLASS.Base = "bloated_zombie"

CLASS.Name = "Vile Bloated Zombie"
CLASS.TranslationName = "class_vile_bloated_zombie"
CLASS.Description = "description_vile_bloated_zombie"
CLASS.Help = "controls_vile_bloated_zombie"

CLASS.BetterVersion = "Poison Zombie"

CLASS.Wave = 3 / 6

CLASS.Health = 350
CLASS.Speed = 135

CLASS.Points = CLASS.Health/GM.HumanoidZombiePointRatio

CLASS.SWEP = "weapon_zs_vilebloatedzombie"

CLASS.Model = Model("models/player/fatty/fatty.mdl")

local math_random = math.random
local string_format = string.format

function CLASS:PlayPainSound(pl)
	pl:EmitSound(string_format("npc/zombie_poison/pz_idle%d.wav", math_random(2, 3)), 72, 75)
	pl.NextPainSound = CurTime() + 0.5

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/ichthyosaur/water_growl5.wav", 72, 60)

	return true
end
