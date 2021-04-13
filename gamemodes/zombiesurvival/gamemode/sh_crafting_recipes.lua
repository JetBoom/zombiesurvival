AddCSLuaFile()

GM.Assemblies = {}

function InsertRecipeTbl(recipe)
	table.insert(GM.Assemblies, recipe)
end

--To create a new recipe, use below as a template:
--[[
	local 'itemname_recipe' = {
		["Recipes"] = {
			["item_name_here"] = 1,
			["item_name_here_2"] = 2
			--NOTE: Recipes are not limited
		},
		
		["Desc"] = "A nice template description, would be nice to mention item requirements here too",
		["Icon"] = "zombiesurvival/killicons/weapon_fists"
		["Weapon"] = "weapon_fists",
		["Result"] = "weapon_fists"
		["Reward"] = 1
	}

	InsertRecipeTbl(itemname_recipe)

--]]
--To understand how this works:
--Recipes: they should contain the requiremnts to craft it
--Desc: a description describing it, might wanna include requirements too
--Icon: what it looks like in-gameNetwork.init()
--Weapon: the required weapon if any
--Result: The result when crafted
--Reward: how much does the owner receive from other players crafting items

local molotov_recipe = {
	["Recipes"] = {
		["comp_propanecan"] = 1
	},
	["Desc"] = "A bottle turned into an incendiary grenade\nREQUIRES: 1 Propane tank, 1 Glass bottle",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_molotov2",
	["Weapon"] = "weapon_zs_glassbottle",
	["Result"] = "weapon_zs_molotov",
	["Reward"] = 2
}

InsertRecipeTbl(molotov_recipe)

local manhacksaw_recipe = {
	["Recipes"] = {
		["comp_sawblade"] = 2
	},
	["Desc"] = "An improved manhack with sawblades\nREQUIRES: 2 Sawblades, 1 Manhack",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_manhack_saw",
	["Weapon"] = "weapon_zs_manhack",
	["Result"] = "weapon_zs_manhack_saw",
	["Reward"] = 10
}
InsertRecipeTbl(manhacksaw_recipe)

local electrichammer_recipe = {
	["Recipes"] = {
		["comp_electrobattery"] = 1,
		["comp_plug"] = 1
	},
	["Desc"] = "A more efficient hammer for cading\nREQUIRES: 1 Electric battery, 1 Plug, 1 Hammer",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_hammer2",
	["Weapon"] = "weapon_zs_hammer",
	["Result"] = "weapon_zs_electrohammer"
}
InsertRecipeTbl(electrichammer_recipe)

local axehack_recipe = {
	["Recipes"] = {
		["comp_sawblade"] = 1
	},
	["Desc"] = "An axe with a sawblade head\nREQUIRES: 1 Sawblade, 1 Axe",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_sawhack.png",
	["Weapon"] = "weapon_zs_axe",
	["Result"] = "weapon_zs_sawhack",
	["Reward"] = 5
}
InsertRecipeTbl(axehack_recipe)

local buststick_recipe = {
	["Recipes"] = {
		["comp_busthead"] = 1,
		["comp_adhesive"] = 1
	},
	["Desc"] = "A plank with a head statue\nREQUIRES: 1 Busthead, 1 Strong adhesive, 1 Plank",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_bust2",
	["Weapon"] = "weapon_zs_plank",
	["Result"] = "weapon_zs_bust",
	["Reward"] = 10
}
InsertRecipeTbl(buststick_recipe)

local megamasher_recipe = {
	["Recipes"] = {
		["comp_propanecan"] = 2
	},
	["Desc"] = "A powerful sledgehammer but heavy to wield\nREQUIRES: 2 Propane Tank, 1 Strong adhesive, 1 Plank",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_megamasher2",
	["Weapon"] = "weapon_zs_sledgehammer",
	["Result"] = "weapon_zs_megamasher",
	["Reward"] = 15
}
InsertRecipeTbl(megamasher_recipe)

local novablaster_recipe = {
	["Recipes"] = {
		["comp_basicecore"] = 2
	},
	["Desc"] = "Some form of future weapon, tomorrow is now!\nREQUIRES: 2 Basic core, 1 Magnum revolver",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_novablaster2",
	["Weapon"] = "weapon_zs_magnum",
	["Result"] = "weapon_zs_novablaster",
	["Reward"] = 10
}
InsertRecipeTbl(novablaster_recipe)

local tithonus_recipe = {
	["Recipes"] = {
		["comp_contaecore"] = 1
	},
	["Desc"] = "A charged energy shotgun\nREQUIRES: 1 Contained energy core, 1 Oberon",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_tithonus2",
	["Weapon"] = "weapon_zs_oberon",
	["Result"] = "weapon_zs_tithonus",
	["Reward"] = 5
}
InsertRecipeTbl(tithonus_recipe)

local fracture_recipe = {
	["Recipes"] = {
		["comp_pumpaction"] = 1
	},
	["Desc"] = "A charged energy shotgun\nREQUIRES: 1 Pump action, 1 Sawed-Off",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_fracture2",
	["Weapon"] = "weapon_zs_sawedoff",
	["Result"] = "weapon_zs_fracture",
	["Reward"] = 10
}
InsertRecipeTbl(fracture_recipe)

local seditionist_recipe = {
	["Recipes"] = {
		["comp_focusbarrel"] = 1
	},
	["Desc"] = "A charged energy shotgun\nREQUIRES: 1 Focus Barrel, 1 Deagle",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_seditionist2",
	["Weapon"] = "weapon_zs_deagle",
	["Result"] = "weapon_zs_seditionist",
	["Reward"] = 5
}
InsertRecipeTbl(seditionist_recipe)

local blareduct_recipe = {
	["Recipes"] = {
		["trinket_ammovestii"] = 1
	},
	["Desc"] = "High powered weapon with a big recoil\nREQUIRES: 1 Ammo trinket, 1 Pipe",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_blareduct2",
	["Weapon"] = "weapon_zs_pipe",
	["Result"] = "weapon_zs_blareduct",
	["Reward"] = 5
}
InsertRecipeTbl(blareduct_recipe)

local cinderrod_recipe = {
	["Recipes"] = {
		["comp_propanecan"] = 1
	},
	["Desc"] = "A dangerous explosive weapon, handle with care\nREQUIRES: 1 Propane tank, 1 Blareduct",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_blareduct2",
	["Weapon"] = "weapon_zs_blareduct",
	["Result"] = "weapon_zs_cinderrod",
	["Reward"] = 5
}
InsertRecipeTbl(cinderrod_recipe)

local innervator_recipe = {
	["Recipes"] = {
		["comp_electrobattery"] = 1
	},
	["Desc"] = "High powered weapon with a big recoil\nREQUIRES: 1 Electric battery, 1 Jackhammer",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_innervator2",
	["Weapon"] = "weapon_zs_jackhammer",
	["Result"] = "weapon_zs_innervator",
	["Reward"] = 5
}
InsertRecipeTbl(innervator_recipe)

local hephaestus_recipe = {
	["Recipes"] = {
		["comp_gaussframe"] = 1
	},
	["Desc"] = "An improved tau cannon\nREQUIRES: 1 Gauss frame, 1 Tithonus",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_heph",
	["Weapon"] = "weapon_zs_tithonus",
	["Result"] = "weapon_zs_hephaestus",
	["Reward"] = 5
}
InsertRecipeTbl(hephaestus_recipe)

local stabber_recipe = {
	["Recipes"] = {
		["comp_shortblade"] = 1
	},
	["Desc"] = "Stabby long range weapon\nREQUIRES: 1 Short blade, 1 Annabelle",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_stabber",
	["Weapon"] = "weapon_zs_annabelle",
	["Result"] = "weapon_zs_stabber",
	["Reward"] = 5
}
InsertRecipeTbl(stabber_recipe)

local galestorm_recipe = {
	["Recipes"] = {
		["comp_multibarrel"] = 1
	},
	["Desc"] = "High powered Uzi\nREQUIRES: 1 Multi-Barrel, 1 Uzi",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_galestorm",
	["Weapon"] = "weapon_zs_uzi",
	["Result"] = "weapon_zs_galestorm",
	["Reward"] = 5
}
InsertRecipeTbl(galestorm_recipe)

local eminence_recipe = {
	["Recipes"] = {
		["trinket_ammovestiii"] = 1
	},
	["Desc"] = "A particle weapon, quite fascinating\nREQUIRES: 1 Ammo trinket, 1 Barrage",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_eminence",
	["Weapon"] = "weapon_zs_barrage",
	["Result"] = "weapon_zs_eminence",
	["Reward"] = 5
}
InsertRecipeTbl(eminence_recipe)

local gladiator_recipe = {
	["Recipes"] = {
		["trinket_ammovestiii"] = 1
	},
	["Desc"] = "Double barrel shotgun that can hold more shells\nREQUIRES: 1 Ammo trinket, 1 Sweeper shotgun",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_gladiator",
	["Weapon"] = "weapon_zs_sweepershotgun",
	["Result"] = "weapon_zs_gladiator",
	["Reward"] = 5
}
InsertRecipeTbl(gladiator_recipe)

local ripper_recipe = {
	["Recipes"] = {
		["comp_sawblade"] = 1
	},
	["Desc"] = "Tear those zombies apart in two pieces\nREQUIRES: 1 Sawblade, 1 Zeus",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_ripper",
	["Weapon"] = "weapon_zs_zeus",
	["Result"] = "weapon_zs_ripper",
	["Reward"] = 5
}
InsertRecipeTbl(ripper_recipe)

local avelyn_recipe = {
	["Recipes"] = {
		["trinket_ammovestiii"] = 1
	},
	["Desc"] = "What's better than one crossbow?, three of them\nREQUIRES: 1 Ammo trinket, 1 Charon",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_avelyn",
	["Weapon"] = "weapon_zs_charon",
	["Result"] = "weapon_zs_avelyn",
	["Reward"] = 5
}
InsertRecipeTbl(avelyn_recipe)

local asmd_recipe = {
	["Recipes"] = {
		["comp_precision"] = 1
	},
	["Desc"] = "IMMA FIRIN MY LAZOR\nREQUIRES: 1 Percision component, 1 Quasar",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_asmd",
	["Weapon"] = "weapon_zs_quasar",
	["Result"] = "weapon_zs_asmd",
	["Reward"] = 5
}
InsertRecipeTbl(asmd_recipe)

local enkindler_recipe = {
	["Recipes"] = {
		["comp_launcher"] = 1
	},
	["Desc"] = "Launch not rockets, but mines that can stick\nREQUIRES: 1 Launcher component, 1 Cinder rod",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_enkindler.png",
	["Weapon"] = "weapon_zs_cinderrod",
	["Result"] = "weapon_zs_enkindler",
	["Reward"] = 5
}
InsertRecipeTbl(enkindler_recipe)

local proliferator_recipe = {
	["Recipes"] = {
		["comp_linearactuator"] = 1
	},
	["Desc"] = "Pro efficent... am I right?\nREQUIRES: 1 Linear actuator, 1 Galestorm",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_proliferator.png",
	["Weapon"] = "weapon_zs_galestorm",
	["Result"] = "weapon_zs_proliferator",
	["Reward"] = 5
}
InsertRecipeTbl(proliferator_recipe)
--[[
-TODO, get trinkets to be taken away from player and rework crafting
local electromagnet_recipe = {
	["Recipes"] = {
		["comp_electrobattery"] = 1
	},
	["Trinket"] = "trinket_magnet",
	["Desc"] = "A magnet that draws items towards you\nREQUIRES: 1 Electric battery, 1 Magnet trinket",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_trinket",
	["Result"] = "trinket_electromagnet"
}
InsertRecipeTbl(electromagnet_recipe)

local guideproj_recipe = {
	["Recipes"] = {
		["comp_cpuparts"] = 1
	},
	["Trinket"] = "trinket_targetingvisori",
	["Desc"] = "Guide your projectile... how?\nREQUIRES: 1 CPU part, 1 Targeting visor trinket",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_trinket",
	["Result"] = "trinket_projguide"
}
InsertRecipeTbl(guideproj_recipe)

local projwei_recipe = {
	["Recipes"] = {
		["comp_busthead"] = 1
	},
	["Trinket"] = "trinket_projguide",
	["Desc"] = "More bullet speed\nREQUIRES: 1 Busthead, 1 projectile guide trinket",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_trinket",
	["Result"] = "trinket_projwei"
}
InsertRecipeTbl(projwei_recipe)

local controlplat_recipe = {
	["Recipes"] = {
		["comp_cpuparts"] = 1
	},
	["Trinket"] = "trinket_mainsuite",
	["Desc"] = "Guide your what?\nREQUIRES: 1 CPU part, 1 Main suite trinket",
	["Icon"] = "zombiesurvival/killicons/weapon_zs_trinket",
	["Result"] = "trinket_controlplat"
}
InsertRecipeTbl(controlplat_recipe)
--]]