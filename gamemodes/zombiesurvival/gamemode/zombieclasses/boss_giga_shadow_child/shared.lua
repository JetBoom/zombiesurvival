CLASS.Base = "boss_giga_gore_child"

CLASS.Name = "Giga Shadow Child"
CLASS.TranslationName = "class_giga_shadow_child"
CLASS.Description = "description_giga_shadow_child"
CLASS.Help = "controls_giga_shadow_child"

CLASS.Boss = true

CLASS.Health = 2000
CLASS.Speed = 235

CLASS.Points = 35

CLASS.SWEP = "weapon_zs_gigashadowchild"

CLASS.OverrideModel = Model("models/player/skeleton.mdl")

CLASS.NoHideMainModel = true

local string_format = string.format
local math_random = math.random

function CLASS:PlayPainSound(pl)
	pl:EmitSound(string_format("ambient/creatures/town_scared_sob%d.wav", math_random(2)), 70, math_random(50, 60))
	pl.NextPainSound = CurTime() + 2

	return true
end
