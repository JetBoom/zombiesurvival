INVCAT_TRINKETS = 1
INVCAT_COMPONENTS = 2
INVCAT_CONSUMABLES = 3

GM.ZSInventoryItemData = {}
GM.ZSInventoryCategories = {
	[INVCAT_TRINKETS] = "Trinkets",
	[INVCAT_COMPONENTS] = "Components",
	[INVCAT_CONSUMABLES] = "Consumables"
}
GM.ZSInventoryPrefix = {
	[INVCAT_TRINKETS] = "trin",
	[INVCAT_COMPONENTS] = "comp",
	[INVCAT_CONSUMABLES] = "cons"
}

GM.Assemblies = {}
GM.Breakdowns = {}

function GM:GetInventoryItemType(item)
	for typ, aff in pairs(self.ZSInventoryPrefix) do
		if string.sub(item, 1, 4) == aff then
			return typ
		end
	end

	return -1
end

local index = 1
function GM:AddInventoryItemData(intname, name, description, weles, tier, stocks)
	local datatab = {PrintName = name, DroppedEles = weles, Tier = tier, Description = description, Stocks = stocks, Index = index}
	self.ZSInventoryItemData[intname] = datatab
	self.ZSInventoryItemData[index] = datatab

	index = index + 1
end


function GM:AddWeaponBreakdownRecipe(weapon, result)
	local datatab = {Result = result, Index = index}
	self.Breakdowns[weapon] = datatab
	for i = 1, 3 do
		self.Breakdowns[self:GetWeaponClassOfQuality(weapon, i)] = datatab
		self.Breakdowns[self:GetWeaponClassOfQuality(weapon, i, 1)] = datatab
	end

	self.Breakdowns[#self.Breakdowns + 1] = datatab
end

GM:AddWeaponBreakdownRecipe("weapon_zs_stubber",							"comp_modbarrel")
GM:AddWeaponBreakdownRecipe("weapon_zs_z9000",								"comp_basicecore")
GM:AddWeaponBreakdownRecipe("weapon_zs_blaster",							"comp_pumpaction")
GM:AddWeaponBreakdownRecipe("weapon_zs_novablaster",						"comp_contaecore")
GM:AddWeaponBreakdownRecipe("weapon_zs_waraxe", 							"comp_focusbarrel")
GM:AddWeaponBreakdownRecipe("weapon_zs_innervator",							"comp_gaussframe")
GM:AddWeaponBreakdownRecipe("weapon_zs_swissarmyknife",						"comp_shortblade")
GM:AddWeaponBreakdownRecipe("weapon_zs_owens",								"comp_multibarrel")
GM:AddWeaponBreakdownRecipe("weapon_zs_onyx",								"comp_precision")
GM:AddWeaponBreakdownRecipe("weapon_zs_minelayer",							"comp_launcher")
GM:AddWeaponBreakdownRecipe("weapon_zs_fracture",							"comp_linearactuator")
GM:AddWeaponBreakdownRecipe("weapon_zs_harpoon",							"comp_metalpole")

-- Assemblies (Assembly, Component, Weapon)
GM.Assemblies["weapon_zs_waraxe"] 								= {"comp_modbarrel", 		"weapon_zs_glock3"}
GM.Assemblies["weapon_zs_bust"] 								= {"comp_busthead", 		"weapon_zs_plank"}
GM.Assemblies["weapon_zs_sawhack"] 								= {"comp_sawblade", 		"weapon_zs_axe"}
GM.Assemblies["weapon_zs_manhack_saw"] 							= {"comp_sawblade", 		"weapon_zs_manhack"}
GM.Assemblies["weapon_zs_megamasher"] 							= {"comp_propanecan", 		"weapon_zs_sledgehammer"}
GM.Assemblies["weapon_zs_electrohammer"] 						= {"comp_electrobattery",	"weapon_zs_hammer"}
GM.Assemblies["weapon_zs_novablaster"] 							= {"comp_basicecore",		"weapon_zs_magnum"}
GM.Assemblies["weapon_zs_tithonus"] 							= {"comp_contaecore",		"weapon_zs_oberon"}
GM.Assemblies["weapon_zs_fracture"] 							= {"comp_pumpaction",		"weapon_zs_sawedoff"}
GM.Assemblies["weapon_zs_seditionist"] 							= {"comp_focusbarrel",		"weapon_zs_deagle"}
GM.Assemblies["weapon_zs_molotov"] 								= {"comp_propanecan",		"weapon_zs_glassbottle"}
GM.Assemblies["weapon_zs_blareduct"] 							= {"trinket_ammovestii",	"weapon_zs_pipe"}
GM.Assemblies["weapon_zs_cinderrod"] 							= {"comp_propanecan",		"weapon_zs_blareduct"}
GM.Assemblies["weapon_zs_innervator"] 							= {"comp_electrobattery",	"weapon_zs_jackhammer"}
GM.Assemblies["weapon_zs_hephaestus"] 							= {"comp_gaussframe",		"weapon_zs_tithonus"}
GM.Assemblies["weapon_zs_stabber"] 								= {"comp_shortblade",		"weapon_zs_annabelle"}
GM.Assemblies["weapon_zs_galestorm"] 							= {"comp_multibarrel",		"weapon_zs_uzi"}
GM.Assemblies["weapon_zs_eminence"] 							= {"trinket_ammovestiii",	"weapon_zs_barrage"}
GM.Assemblies["weapon_zs_gladiator"] 							= {"trinket_ammovestiii",	"weapon_zs_sweepershotgun"}
GM.Assemblies["weapon_zs_ripper"]								= {"comp_sawblade",			"weapon_zs_zeus"}
GM.Assemblies["weapon_zs_avelyn"]								= {"trinket_ammovestiii",	"weapon_zs_charon"}
GM.Assemblies["weapon_zs_asmd"]									= {"comp_precision",		"weapon_zs_quasar"}
GM.Assemblies["weapon_zs_enkindler"]							= {"comp_launcher",			"weapon_zs_cinderrod"}
GM.Assemblies["weapon_zs_proliferator"]							= {"comp_linearactuator",	"weapon_zs_galestorm"}
GM.Assemblies["trinket_electromagnet"]							= {"comp_electrobattery",	"trinket_magnet"}
GM.Assemblies["trinket_projguide"]								= {"comp_cpuparts",			"trinket_targetingvisori"}
GM.Assemblies["trinket_projwei"]								= {"comp_busthead",			"trinket_projguide"}
GM.Assemblies["trinket_controlplat"]							= {"comp_cpuparts",			"trinket_mainsuite"}

GM:AddInventoryItemData("comp_modbarrel",		""..translate.Get"comp_mod_barrel",			""..translate.Get"comp_mod_barrel_desc",								"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_burstmech",		""..translate.Get"comp_burst_mech",		""..translate.Get"comp_burst_mech_desc",										"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_basicecore",		""..translate.Get"comp_basic_core",		""..translate.Get"comp_basic_core_desc",	"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_busthead",		""..translate.Get"comp_bust_head",				""..translate.Get"comp_bust_head_desc",								"models/props_combine/breenbust.mdl")
GM:AddInventoryItemData("comp_sawblade",		""..translate.Get"comp_saw_blade",				""..translate.Get"comp_saw_blade_desc",								"models/props_junk/sawblade001a.mdl")
GM:AddInventoryItemData("comp_propanecan",		""..translate.Get"comp_propane_can",			""..translate.Get"comp_propane_can_desc",				"models/props_junk/propane_tank001a.mdl")
GM:AddInventoryItemData("comp_electrobattery",	""..translate.Get"comp_electro_battery",			""..translate.Get"comp_electro_battery_desc",								"models/items/car_battery01.mdl")
--GM:AddInventoryItemData("comp_hungrytether",	""..translate.Get"comp_hungry_tether",			""..translate.Get"comp_hungry_tether_desc",								"models/gibs/HGIBS_rib.mdl")]]
GM:AddInventoryItemData("comp_contaecore",		""..translate.Get"comp_contae_core",	""..translate.Get"comp_contae_core_desc",							"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_pumpaction",		""..translate.Get"comp_pump_action",	""..translate.Get"comp_pump_action_desc",										"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_focusbarrel",		""..translate.Get"comp_focus_barrel",			""..translate.Get"comp_focus_barrel_desc",		"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_gaussframe",		""..translate.Get"comp_gauss_frame",				""..translate.Get"comp_gauss_frame_desc",			"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_metalpole",		""..translate.Get"comp_metal_pole",				""..translate.Get"comp_metal_pole_desc",							"models/props_c17/signpole001.mdl")
GM:AddInventoryItemData("comp_salleather",		""..translate.Get"comp_sal_leather",			""..translate.Get"comp_sal_leather_desc",								"models/props_junk/shoe001.mdl")
GM:AddInventoryItemData("comp_gyroscope",		""..translate.Get"comp_gyroscope",				""..translate.Get"comp_gyroscope_desc",												"models/maxofs2d/hover_rings.mdl")
GM:AddInventoryItemData("comp_reciever",		""..translate.Get"comp_reciever",					""..translate.Get"comp_reciever_desc",					"models/props_lab/reciever01b.mdl")
GM:AddInventoryItemData("comp_cpuparts",		""..translate.Get"comp_cpu_parts",				""..translate.Get"comp_cpu_parts_desc",																"models/props_lab/harddrive01.mdl")
GM:AddInventoryItemData("comp_launcher",		""..translate.Get"comp_launcher",			""..translate.Get"comp_launcher_desc",															"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_launcherh",		""..translate.Get"comp_launcher_h",		""..translate.Get"comp_launcher_h_desc",												"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_shortblade",		""..translate.Get"comp_short_blade",				""..translate.Get"comp_short_blade_desc",												"models/weapons/w_knife_t.mdl")
GM:AddInventoryItemData("comp_multibarrel",		""..translate.Get"comp_multi_barrel",		""..translate.Get"comp_multi_barrel_desc",							"models/props_lab/pipesystem03a.mdl")
GM:AddInventoryItemData("comp_holoscope",		""..translate.Get"comp_holo_scope",		""..translate.Get"comp_holo_scope_desc",												{
	["base"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.273, 1.728, -0.843), angle = Angle(74.583, 180, 0), size = Vector(2.207, 0.105, 0.316), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_combine/tprotato1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.492, -1.03, 0), angle = Angle(0, -78.715, 90), size = Vector(0.03, 0.02, 0.032), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} }
})
GM:AddInventoryItemData("comp_linearactuator",	""..translate.Get"comp_linear_actuator",			""..translate.Get"comp_linear_actuator_desc",				"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_pulsespool",		""..translate.Get"comp_pulse_spool",				""..translate.Get"comp_pulse_spool_desc",			"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_flak",			""..translate.Get"comp_flak",				""..translate.Get"comp_flak_desc",												"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_precision",		""..translate.Get"comp_precision",		""..translate.Get"comp_precision_desc",									"models/Items/combine_rifle_cartridge01.mdl")

-- Trinkets
local trinket, description, trinketwep
local hpveles = {
	["ammo"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 3.5, 3), angle = Angle(15.194, 80.649, 180), size = Vector(0.6, 0.6, 1.2), color = Color(145, 132, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local hpweles = {
	["ammo"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 2.5, 3), angle = Angle(15.194, 80.649, 180), size = Vector(0.6, 0.6, 1.2), color = Color(145, 132, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local ammoveles = {
	["ammo"] = { type = "Model", model = "models/props/de_prodigy/ammo_can_02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 3, -0.519), angle = Angle(0, 85.324, 101.688), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local ammoweles = {
	["ammo"] = { type = "Model", model = "models/props/de_prodigy/ammo_can_02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 2, -1.558), angle = Angle(5.843, 82.986, 111.039), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local mveles = {
	["band++"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(2.599, 1, 1), angle = Angle(0, -25, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 3, -1), angle = Angle(97.013, 29.221, 0), size = Vector(0.045, 0.045, 0.025), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band+"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(-2.401, -1, 0.5), angle = Angle(0, 155.455, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}
local mweles = {
	["band++"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(2.599, 1, 1), angle = Angle(0, -25, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band+"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(-2.401, -1, 0.5), angle = Angle(0, 155.455, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 2, -0.5), angle = Angle(111.039, -92.338, 97.013), size = Vector(0.045, 0.045, 0.025), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}
local pveles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -2.597), angle = Angle(5.843, 90, 0), size = Vector(0.25, 0.15, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local pweles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 0.5, -2), angle = Angle(5, 90, 0), size = Vector(0.25, 0.15, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local oveles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 2, -1.5), angle = Angle(5, 180, 0), size = Vector(0.05, 0.039, 0.07), color = Color(196, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local oweles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 2, -1.5), angle = Angle(5, 180, 0), size = Vector(0.05, 0.039, 0.07), color = Color(196, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local develes = {
	["perf"] = { type = "Model", model = "models/props_lab/blastdoor001b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 2.5, -5.715), angle = Angle(5, 180, 0), size = Vector(0.1, 0.039, 0.09), color = Color(168, 155, 0, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} }
}
local deweles = {
	["perf"] = { type = "Model", model = "models/props_lab/blastdoor001b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 2, -5.715), angle = Angle(0, 180, 0), size = Vector(0.1, 0.039, 0.09), color = Color(168, 155, 0, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} }
}
local supveles = {
	["perf"] = { type = "Model", model = "models/props_lab/reciever01c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.299, 2.5, -2), angle = Angle(5, 180, 92.337), size = Vector(0.2, 0.699, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local supweles = {
	["perf"] = { type = "Model", model = "models/props_lab/reciever01c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.5, -2), angle = Angle(5, 180, 92.337), size = Vector(0.2, 0.699, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

-- Health Trinkets
trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_health_package", "vitpackagei", false, hpveles, hpweles, 2, ""..translate.Get"trin_health_package_desc")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 10)
GM:AddSkillModifier(trinket, SKILLMOD_HEALING_RECEIVED, 0.05)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(""..translate.Get"trin_vitality_bank", "vitpackageii", false, hpveles, hpweles, 4, ""..translate.Get"trin_vitality_bank_desc")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 21)
GM:AddSkillModifier(trinket, SKILLMOD_HEALING_RECEIVED, 0.06)

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_blood_pack", "bloodpack", false, hpveles, hpweles, 2, ""..translate.Get"trin_blood_pack_desc", nil, 15)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_blood_package", "cardpackagei", false, hpveles, hpweles, 2, ""..translate.Get"trin_blood_package_desc")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 10)
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_blood_bank", "cardpackageii", false, hpveles, hpweles, 4, ""..translate.Get"trin_blood_bank_desc"), SKILLMOD_BLOODARMOR, 30)

GM:AddTrinket(""..translate.Get"trin_regen_implant", "regenimplant", false, hpveles, hpweles, 3, ""..translate.Get"trin_regen_implant_desc")

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_bio_cleanser", "biocleanser", false, hpveles, hpweles, 2, ""..translate.Get"trin_bio_cleanser_desc")
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_cutlery", "cutlery", false, hpveles, hpweles, nil, ""..translate.Get"trin_cutlery_desc"), SKILLMOD_FOODEATTIME_MUL, -0.8)

-- Melee Trinkets

description = ""..translate.Get"trin_boxing_training_desc"
trinket = GM:AddTrinket(""..translate.Get"trin_boxing_training", "boxingtraining", false, mveles, mweles, nil, description)
GM:AddSkillModifier(trinket, SKILLMOD_UNARMED_SWING_DELAY_MUL, -0.15)
GM:AddSkillFunction(trinket, function(pl, active) pl.BoxingTraining = active end)

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_momentum_support", "momentumsupsysii", false, mveles, mweles, 2, ""..translate.Get"trin_momentum_support_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.13)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_KNOCKBACK_MUL, 0.1)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(""..translate.Get"trin_momentum_scaffold", "momentumsupsysiii", false, mveles, mweles, 3, ""..translate.Get"trin_momentum_scaffold_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.20)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_KNOCKBACK_MUL, 0.12)

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_hemo_adrenali", "hemoadrenali", false, mveles, mweles, nil, ""..translate.Get"trin_hemo_adrenali_desc"), SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.02)

trinket = GM:AddTrinket(""..translate.Get"trin_hemo_adrenalii", "hemoadrenalii", false, mveles, mweles, 3, ""..translate.Get"trin_hemo_adrenalii_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.03)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, 30)

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_hemo_adrenaliii", "hemoadrenaliii", false, mveles, mweles, 4, ""..translate.Get"trin_hemo_adrenaliii_desc"), SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.04)

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_power_gauntlet", "powergauntlet", false, mveles, mweles, 3, ""..translate.Get"trin_power_gauntlet_desc"), SKILLMOD_MELEE_POWERATTACK_MUL, 0.45)

GM:AddTrinket(""..translate.Get"trin_sharp_kit", "sharpkit", false, mveles, mweles, 2, ""..translate.Get"trin_sharp_kit_desc")

GM:AddTrinket(""..translate.Get"trin_sharp_stone", "sharpstone", false, mveles, mweles, 3, ""..translate.Get"trin_sharp_stone_desc")

-- Performance Trinkets
GM:AddTrinket(""..translate.Get"trin_oxygen_tank", "oxygentank", true, nil, {
	["base"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 3, -1), angle = Angle(180, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, nil, ""..translate.Get"trin_oxygen_tank_desc", "oxygentank")

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_acrobat_frame", "acrobatframe", false, pveles, pweles, nil, ""..translate.Get"trin_acrobat_frame_desc"), SKILLMOD_JUMPPOWER_MUL, 0.08)

trinket = GM:AddTrinket(""..translate.Get"trin_night_vision", "nightvision", true, pveles, pweles, 2, ""..translate.Get"trin_night_vision_desc")
GM:AddSkillModifier(trinket, SKILLMOD_DIMVISION_EFF_MUL, -0.5)
GM:AddSkillModifier(trinket, SKILLMOD_FRIGHT_DURATION_MUL, -0.45)
GM:AddSkillModifier(trinket, SKILLMOD_VISION_ALTER_DURATION_MUL, -0.4)
GM:AddSkillFunction(trinket, function(pl, active)
	if CLIENT and pl == MySelf and GAMEMODE.m_NightVision and not active then
		surface.PlaySound("items/nvg_off.wav")
		GAMEMODE.m_NightVision = false
	end
end)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(""..translate.Get"trin_portable_hole", "portablehole", false, pveles, pweles, nil, ""..translate.Get"trin_portable_hole_desc")
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYSPEED_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_RELOADSPEED_MUL, 0.03)

trinket = GM:AddTrinket(""..translate.Get"trin_path_finder", "pathfinder", false, pveles, pweles, 2, ""..translate.Get"trin_path_finder_desc")
GM:AddSkillModifier(trinket, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.4)
GM:AddSkillModifier(trinket, SKILLMOD_SIGIL_TELEPORT_MUL, -0.45)
GM:AddSkillModifier(trinket, SKILLMOD_JUMPPOWER_MUL, 0.13)

trinket = GM:AddTrinket(""..translate.Get"trin_galvaniser_implant", "analgestic", false, pveles, pweles, 3, ""..translate.Get"trin_galvaniser_implant_desc")
GM:AddSkillModifier(trinket, SKILLMOD_SLOW_EFF_TAKEN_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_KNOCKDOWN_RECOVERY_MUL, -0.5)
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYSPEED_MUL, 0.25)

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_ammo_vest", "ammovestii", false, ammoveles, ammoweles, 2, ""..translate.Get"trin_ammo_vest_desc"), SKILLMOD_RELOADSPEED_MUL, 0.05)
GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_ammo_bandolier", "ammovestiii", false, ammoveles, ammoweles, 4, ""..translate.Get"trin_ammo_bandolier_desc"), SKILLMOD_RELOADSPEED_MUL, 0.12)

GM:AddTrinket(""..translate.Get"trin_auto_reload", "autoreload", false, ammoveles, ammoweles, 2, ""..translate.Get"trin_auto_reload_desc")

-- Offensive Implants
GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_targeting_visor", "targetingvisori", false, oveles, oweles, nil, ""..translate.Get"trin_targeting_visor_desc"), SKILLMOD_AIMSPREAD_MUL, -0.05)

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_targeting_unifier", "targetingvisoriii", false, oveles, oweles, 4, ""..translate.Get"trin_targeting_unifier_desc"), SKILLMOD_AIMSPREAD_MUL, -0.11)

GM:AddTrinket(""..translate.Get"trin_refined_sub", "refinedsub", false, oveles, oweles, 4, ""..translate.Get"trin_refined_sub_desc")

trinket = GM:AddTrinket(""..translate.Get"trin_aim_comp", "aimcomp", false, oveles, oweles, 3, ""..translate.Get"trin_aim_comp_desc")
GM:AddSkillModifier(trinket, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_AIM_SHAKE_MUL, -0.52)
GM:AddSkillFunction(trinket, function(pl, active) pl.TargetLocus = active end)

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_pulse_booster", "pulseampi", false, oveles, oweles, nil, ""..translate.Get"trin_pulse_booster_desc"), SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.14)

trinket = GM:AddTrinket(""..translate.Get"trin_pulse_infuser", "pulseampii", false, oveles, oweles, 3, ""..translate.Get"trin_pulse_infuser_desc")
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.2)
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_RADIUS, 0.07)

trinket = GM:AddTrinket(""..translate.Get"trin_resonance_cascade", "resonance", false, oveles, oweles, 4, ""..translate.Get"trin_resonance_cascade_desc")
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, -0.25)

trinket = GM:AddTrinket(""..translate.Get"trin_cryo_indu", "cryoindu", false, oveles, oweles, 4, ""..translate.Get"trin_cryo_indu_desc")

trinket = GM:AddTrinket(""..translate.Get"trin_extended_mag", "extendedmag", false, oveles, oweles, 3, ""..translate.Get"trin_extended_mag_desc")

trinket = GM:AddTrinket(""..translate.Get"trin_pulse_impedance", "pulseimpedance", false, oveles, oweles, 5, ""..translate.Get"trin_pulse_impedance_desc")
GM:AddSkillFunction(trinket, function(pl, active) pl.PulseImpedance = active end)
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.24)

trinket = GM:AddTrinket(""..translate.Get"trin_curb_stompers", "curbstompers", false, oveles, oweles, 2, ""..translate.Get"trin_curb_stompers_desc")
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, -0.25)

GM:AddTrinket(""..translate.Get"trin_sup_asm", "supasm", false, oveles, oweles, 5, ""..translate.Get"trin_sup_asm_desc")

trinket = GM:AddTrinket(""..translate.Get"trin_olympian_frame", "olympianframe", false, oveles, oweles, 2, ""..translate.Get"trin_olympian_frame_desc")
GM:AddSkillModifier(trinket, SKILLMOD_PROP_THROW_STRENGTH_MUL, 1)
GM:AddSkillModifier(trinket, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.25)
GM:AddSkillModifier(trinket, SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, -0.35)

-- Defensive Trinkets
trinket, trinketwep = GM:AddTrinket(""..translate.Get("trin_kevlar"), "kevlar", false, develes, deweles, 2, ""..translate.Get("trin_kevlar_desc"))
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.11)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, -0.11)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(""..translate.Get"trin_barbed_armor", "barbedarmor", false, develes, deweles, 3, ""..translate.Get"trin_barbed_armor_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_ATTACKER_DMG_REFLECT, 14)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT, 1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.04)

trinket = GM:AddTrinket(""..translate.Get"trin_antitoxin_pack", "antitoxinpack", false, develes, deweles, 2, ""..translate.Get"trin_antitoxin_pack_desc")
GM:AddSkillModifier(trinket, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, -0.17)
GM:AddSkillModifier(trinket, SKILLMOD_POISON_SPEED_MUL, -0.4)

trinket = GM:AddTrinket(""..translate.Get"trin_hemo_stasis", "hemostasis", false, develes, deweles, 2, ""..translate.Get"trin_hemo_stasis_desc")
GM:AddSkillModifier(trinket, SKILLMOD_BLEED_DAMAGE_TAKEN_MUL, -0.3)
GM:AddSkillModifier(trinket, SKILLMOD_BLEED_SPEED_MUL, -0.6)

trinket = GM:AddTrinket(""..translate.Get"trin_eod_vest", "eodvest", false, develes, deweles, 4, ""..translate.Get"trin_eod_vest_desc")
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.35)
GM:AddSkillModifier(trinket, SKILLMOD_FIRE_DAMAGE_TAKEN_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_SELF_DAMAGE_MUL, -0.05)

trinket = GM:AddTrinket(""..translate.Get"trin_fall_frame", "featherfallframe", false, develes, deweles, 3, ""..translate.Get"trin_fall_frame_desc")
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_DAMAGE_MUL, -0.35)
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_THRESHOLD_MUL, 0.30)
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, -0.65)

local eicev = {
	["base"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.339, 2.697, -2.309), angle = Angle(4.558, -34.502, -72.395), size = Vector(0.5, 0.5, 0.5), color = Color(0, 137, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

local eicew = {
	["base"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.556, 2.519, -1.468), angle = Angle(0, -5.844, -75.974), size = Vector(0.5, 0.5, 0.5), color = Color(0, 137, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

GM:AddTrinket(""..translate.Get"trin_ice_burst", "iceburst", false, eicev, eicew, nil, ""..translate.Get"trin_ice_burst_desc")

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_force_damp", "forcedamp", false, develes, deweles, 2, ""..translate.Get"trin_force_damp_desc"), SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL, -0.33)

GM:AddSkillFunction(GM:AddTrinket(""..translate.Get"trin_necro_sense", "necrosense", false, develes, deweles, 2, ""..translate.Get"trin_necro_sense_desc"), function(pl, active) pl:SetDTBool(DT_PLAYER_BOOL_NECRO, active) end)

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_reactive_flasher", "reactiveflasher", false, develes, deweles, 2, ""..translate.Get"trin_reactive_flasher_desc")
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(""..translate.Get"trin_composite_underlay", "composite", false, develes, deweles, 4, ""..translate.Get"trin_composite_underlay_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.16)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, -0.16)

-- Support Trinkets
trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_arsenal_pack", "arsenalpack", false, {
	["base"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, {
	["base"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, 4, ""..translate.Get"trin_arsenal_pack_desc", "arsenalpack", 3)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_resupply_pack", "resupplypack", true, nil, {
	["base"] = { type = "Model", model = "models/Items/ammocrate_ar2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, 4, ""..translate.Get"trin_resupply_pack_desc", "resupplypack", 3)
trinketwep.PermitDismantle = true

GM:AddTrinket(""..translate.Get"trin_magnet", "magnet", true, supveles, supweles, nil, ""..translate.Get"trin_magnet_desc", "magnet")
GM:AddTrinket(""..translate.Get"trin_electro_magnet", "electromagnet", true, supveles, supweles, nil, ""..translate.Get"trin_electro_magnet_desc", "magnet_electro")

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_loading_ex", "loadingex", false, supveles, supweles, 2, ""..translate.Get"trin_loading_ex_desc")
GM:AddSkillModifier(trinket, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.55)
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYABLE_PACKTIME_MUL, -0.2)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_blueprints_i", "blueprintsi", false, supveles, supweles, 2, ""..translate.Get"trin_blueprints_i_desc")
GM:AddSkillModifier(trinket, SKILLMOD_REPAIRRATE_MUL, 0.1)
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_advanced_blueprints", "blueprintsii", false, supveles, supweles, 4, ""..translate.Get"trin_advanced_blueprints_desc"), SKILLMOD_REPAIRRATE_MUL, 0.2)

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_medical_processor", "processor", false, supveles, supweles, 2, ""..translate.Get"trin_medical_processor_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, -0.1)

trinket = GM:AddTrinket(""..translate.Get"trin_curative_kit", "curativeii", false, supveles, supweles, 3, ""..translate.Get"trin_curative_kit_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, -0.2)

trinket = GM:AddTrinket(""..translate.Get"trin_remedy_booster", "remedy", false, supveles, supweles, 3, ""..translate.Get"trin_remedy_booster_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.08)

trinket = GM:AddTrinket(""..translate.Get"trin_main_suite", "mainsuite", false, supveles, supweles, 2, ""..translate.Get"trin_main_suite_desc")
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_RANGE_MUL, 0.1)
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_DELAY_MUL, -0.07)
GM:AddSkillModifier(trinket, SKILLMOD_TURRET_RANGE_MUL, 0.1)

trinket = GM:AddTrinket(""..translate.Get"trin_control_plat", "controlplat", false, supveles, supweles, 2, ""..translate.Get"trin_control_plat_desc")
GM:AddSkillModifier(trinket, SKILLMOD_CONTROLLABLE_HEALTH_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_CONTROLLABLE_SPEED_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_MANHACK_DAMAGE_MUL, 0.2)

trinket = GM:AddTrinket(""..translate.Get"trin_proj_guide", "projguide", false, supveles, supweles, 2, ""..translate.Get"trin_proj_guide_desc")
GM:AddSkillModifier(trinket, SKILLMOD_PROJ_SPEED, 0.25)

trinket = GM:AddTrinket(""..translate.Get"trin_proj_wei", "projwei", false, supveles, supweles, 2, ""..translate.Get"trin_proj_wei_desc")
GM:AddSkillModifier(trinket, SKILLMOD_PROJ_SPEED, -0.5)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_MUL, 0.05)

local ectov = {
	["base"] = { type = "Model", model = "models/props_junk/glassjug01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.381, 2.617, 2.062), angle = Angle(180, 12.243, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 4.07), angle = Angle(180, 12.243, 0), size = Vector(0.123, 0.123, 0.085), color = Color(0, 0, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

local ectow = {
	["base"] = { type = "Model", model = "models/props_junk/glassjug01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.506, 1.82, 1.758), angle = Angle(-164.991, 19.691, 8.255), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 4.07), angle = Angle(180, 12.243, 0), size = Vector(0.123, 0.123, 0.085), color = Color(0, 0, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

trinket = GM:AddTrinket(""..translate.Get"trin_reachem", "reachem", false, ectov, ectow, 3, ""..translate.Get"trin_reachem_desc")
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, 0.3)
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_RADIUS, 0.1)

trinket = GM:AddTrinket(""..translate.Get"trin_operat_rix", "opsmatrix", false, supveles, supweles, 4, ""..translate.Get"trin_operat_rix_desc")
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_RANGE_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_DELAY_MUL, -0.13)
GM:AddSkillModifier(trinket, SKILLMOD_TURRET_RANGE_MUL, 0.15)

GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_acq_manifest", "acqmanifest", false, supveles, supweles, 2, ""..translate.Get"trin_acq_manifest_desc"), SKILLMOD_RESUPPLY_DELAY_MUL, -0.06)
GM:AddSkillModifier(GM:AddTrinket(""..translate.Get"trin_pro_manifest", "promanifest", false, supveles, supweles, 4, ""..translate.Get"trin_pro_manifest_desc"), SKILLMOD_RESUPPLY_DELAY_MUL, -0.09)

-- Boss Trinkets

local blcorev = {
	["black_core_2+"] = { type = "Sprite", sprite = "effects/splashwake1", bone = "ValveBiped.Bip01_Spine4", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 10, y = 10 }, color = Color(0, 0, 0, 255), nocull = false, additive = false, vertexalpha = true, vertexcolor = true, ignorez = true},
	["black_core"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(0, 0.5, -1.701), angle = Angle(0, 0, 0), size = Vector(0.349, 0.349, 0.349), color = Color(20, 20, 20, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["black_core_2"] = { type = "Sprite", sprite = "effects/splashwake3", bone = "ValveBiped.Bip01_Spine4", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 7.697, y = 7.697 }, color = Color(0, 0, 0, 255), nocull = false, additive = false, vertexalpha = true, vertexcolor = true, ignorez = true}
}

local blcorew = {
	["black_core_2"] = { type = "Sprite", sprite = "effects/splashwake3", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 7.697, y = 7.697 }, color = Color(0, 0, 0, 255), nocull = false, additive = false, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core_2+"] = { type = "Sprite", sprite = "effects/splashwake1", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 10, y = 10 }, color = Color(0, 0, 0, 255), nocull = false, additive = false, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, 0), angle = Angle(0, 0, 0), size = Vector(0.349, 0.349, 0.349), color = Color(20, 20, 20, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} }
}

GM:AddTrinket(""..translate.Get"trin_bleak_soul", "bleaksoul", false, blcorev, blcorew, nil, ""..translate.Get"trin_bleak_soul_desc")

trinket = GM:AddTrinket(""..translate.Get"trin_spirit_ess", "spiritess", false, nil, {
	["black_core_2"] = { type = "Sprite", sprite = "effects/splashwake3", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 7.697, y = 7.697 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core_2+"] = { type = "Sprite", sprite = "effects/splashwake1", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 10, y = 10 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, 0), angle = Angle(0, 0, 0), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}, nil, ""..translate.Get"trin_spirit_ess_desc")
GM:AddSkillModifier(trinket, SKILLMOD_JUMPPOWER_MUL, 0.13)

-- Starter Trinkets

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_arm_band", "armband", false, mveles, mweles, nil, ""..translate.Get"trin_arm_band_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.06)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_condiments", "condiments", false, supveles, supweles, nil, ""..translate.Get"trin_condiments_desc")
GM:AddSkillModifier(trinket, SKILLMOD_FOODRECOVERY_MUL, 0.20)
GM:AddSkillModifier(trinket, SKILLMOD_FOODEATTIME_MUL, -0.20)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_emanual", "emanual", false, develes, deweles, nil, ""..translate.Get"trin_emanual_desc")
GM:AddSkillModifier(trinket, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.20)
GM:AddSkillModifier(trinket, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.12)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_aimaid", "aimaid", false, develes, deweles, nil, ""..translate.Get"trin_aimaid_desc")
GM:AddSkillModifier(trinket, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_AIM_SHAKE_MUL, -0.06)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_vitamins", "vitamins", false, hpveles, hpweles, nil, ""..translate.Get"trin_vitamins_desc")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 5)
GM:AddSkillModifier(trinket, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, -0.12)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_welfare", "welfare", false, hpveles, hpweles, nil, ""..translate.Get"trin_welfare_desc")
GM:AddSkillModifier(trinket, SKILLMOD_RESUPPLY_DELAY_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_SELF_DAMAGE_MUL, -0.07)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(""..translate.Get"trin_chemistry", "chemistry", false, hpveles, hpweles, nil, ""..translate.Get"trin_chemistry_desc")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.06)
GM:AddSkillModifier(trinket, SKILLMOD_CLOUD_TIME, 0.12)
trinketwep.PermitDismantle = true
