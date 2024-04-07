CLASS.Base = "poison_headcrab"

CLASS.Name = "Barbed Headcrab"
CLASS.TranslationName = "class_barbed_headcrab"
CLASS.Description = "description_barbed_headcrab"
CLASS.Help = "controls_barbed_headcrab"

CLASS.Health = 100
CLASS.Points = CLASS.Health/GM.HeadcrabZombiePointRatio
CLASS.Speed = 160

CLASS.Wave = 4 / 6

CLASS.SWEP = "weapon_zs_barbedheadcrab"

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/poisonheadcrab"
CLASS.IconColor = Color(236, 218, 0)

local matSkin = Material("Models/Barnacle/barnacle_sheet")
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(0.65, 0.65, 0.5)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
end
