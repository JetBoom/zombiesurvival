CLASS.Base = "eradicator"

CLASS.Name = "Eradicator II"
CLASS.TranslationName = "class_eradicator_ii"
CLASS.Description = "description_eradicator_ii"
CLASS.Help = "controls_eradicator"

CLASS.BetterVersion = "Eradicator III"

CLASS.Wave = 8 / GM.NumberOfWaves

CLASS.Health = 475
CLASS.DynamicHealth = 7
CLASS.Speed = 155

CLASS.CanTaunt = true

CLASS.Points = CLASS.Health/GM.HumanoidZombiePointRatio

CLASS.SWEP = "weapon_zs_eradicator2"

CLASS.Model = Model("models/player/zombie_classic_hbfix.mdl")
CLASS.OverrideModel = Model("models/Zombie/Poison.mdl")

CLASS.VoicePitch = 0.6

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("eradicatorambience")
		pl.EradiVived = false
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/poisonzombie"
CLASS.IconColor = Color(88, 0, 0)

local matSkin = Material("Models/charple/charple4_sheet.vtf")
function CLASS:PrePlayerDrawOverrideModel(pl)
	render.ModelMaterialOverride(matSkin)
end

function CLASS:PostPlayerDrawOverrideModel(pl)
	render.ModelMaterialOverride(nil)
end
