CLASS.Base = "poison_zombie"

CLASS.Name = "Wild Poison Zombie"
CLASS.TranslationName = "class_wild_poison_zombie"
CLASS.Description = "description_wild_poison_zombie"
CLASS.Help = "controls_poison_zombie"

CLASS.Wave = 5 / 6

CLASS.Health = 460
CLASS.SWEP = "weapon_zs_wildpoisonzombie"

CLASS.Points = CLASS.Health/GM.PoisonZombiePointRatio

local math_random = math.random

function CLASS:PlayPainSound(pl)
	pl:EmitSound("npc/zombie_poison/pz_pain"..math_random(3)..".wav", 74, math.random(88, 95))
	pl.NextPainSound = CurTime() + 0.5

	return true
end
