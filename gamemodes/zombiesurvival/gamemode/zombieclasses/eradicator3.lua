CLASS.Base = "eradicator2"

CLASS.Name = "Eradicator III"
CLASS.TranslationName = "class_eradicator_iii"
CLASS.Description = "description_eradicator_iii"
CLASS.Help = "controls_eradicator"

CLASS.Wave = 11 / GM.NumberOfWaves

CLASS.Health = 555
CLASS.DynamicHealth = 8
CLASS.Speed = 160

CLASS.CanTaunt = true

CLASS.Points = CLASS.Health/GM.HumanoidZombiePointRatio

CLASS.SWEP = "weapon_zs_eradicator3"

CLASS.Model = Model("models/player/zombie_classic_hbfix.mdl")
CLASS.OverrideModel = Model("models/Zombie/Poison.mdl")

CLASS.VoicePitch = 0.63

local math_random = math.random
local StepLeftSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav"
}
local StepRightSounds = {
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound(StepLeftSounds[math_random(#StepLeftSounds)], 75)
	else
		pl:EmitSound(StepRightSounds[math_random(#StepRightSounds)], 75)
	end

	return true
end

function CLASS:PlayPainSound(pl)
	pl:EmitSound("npc/combine_soldier/pain"..math_random(3)..".wav", 75, math.Rand(62.5, 67.5))
	pl.NextPainSound = CurTime() + 0.5

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/combine_gunship/gunship_pain.wav", 75, math.Rand(72.5, 82.5))

	return true
end

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("eradicatorambience")
		pl.EradiVived = false
	end
end


if SERVER then return end

CLASS.Icon = "zombiesurvival/killicons/poisonzombie"
CLASS.IconColor = Color(88, 44, 220)

local matSkin = Material("Models/charple/charple4_sheet.vtf")
function CLASS:PrePlayerDrawOverrideModel(pl)
	render.ModelMaterialOverride(matSkin)
end

function CLASS:PostPlayerDrawOverrideModel(pl)
	render.ModelMaterialOverride(nil)
end
