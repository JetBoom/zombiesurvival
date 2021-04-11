CLASS.Base = "fast_headcrab"

CLASS.Name = "Bloodsucker Headcrab"
CLASS.TranslationName = "class_bloodsucker_headcrab"
CLASS.Description = "description_bloodsucker_headcrab"
CLASS.Help = "controls_bloodsucker_headcrab"

CLASS.Wave = 3 / 6

CLASS.Model = Model("models/headcrab.mdl")

CLASS.SWEP = "weapon_zs_bloodsucker_headcrab"

CLASS.Health = 50

CLASS.Points = CLASS.Health/GM.HeadcrabZombiePointRatio

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/fastheadcrab"
CLASS.IconColor = Color(175, 100, 100)

local matSkin = Material("Models/leech/leech.vtf")
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(0.68, 0.39, 0.39)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
end
