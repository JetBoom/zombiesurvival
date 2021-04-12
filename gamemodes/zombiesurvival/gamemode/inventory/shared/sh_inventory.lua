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

GM:AddInventoryItemData("comp_modbarrel",		"Modular Barrel",			"A modular barrel suited for pairing up with another gun barrel.",								"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_burstmech",		"Burst Fire Mechanism",		"A mechanism that could be used to make a gun burst fire.",										"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_basicecore",		"Basic Energy Core",		"A small energy core. Needs a weapon with a cylinder mechanism to contain the energy output.",	"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_busthead",		"Bust Head",				"A bust head that could be fitted on to something handle shaped.",								"models/props_combine/breenbust.mdl")
GM:AddInventoryItemData("comp_sawblade",		"Saw Blade",				"A sharp saw blade ready to be fitted onto fast moving objects.",								"models/props_junk/sawblade001a.mdl")
GM:AddInventoryItemData("comp_propanecan",		"Propane Canister",			"A propane canister. With the correct setup, has the potential to ignite things.",				"models/props_junk/propane_tank001a.mdl")
GM:AddInventoryItemData("comp_electrobattery",	"Electrobattery",			"An electrobattery. Could be used to improve repairing motions.",								"models/items/car_battery01.mdl")
--GM:AddInventoryItemData("comp_hungrytether",	"Hungry Tether",			"A hungry tether from a devourer that comes from a devourer rib.",								"models/gibs/HGIBS_rib.mdl")]]
GM:AddInventoryItemData("comp_contaecore",		"Contained Energy Core",	"A contained energy core, that has an internal charging mechanism.",							"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_pumpaction",		"Pump Action Mechanism",	"A standard pump action mechanism from a blaster shotgun.",										"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_focusbarrel",		"Focused Barrel",			"A large focused barrel made from the barrels of the waraxe. Suitable for a handcannon.",		"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_gaussframe",		"Gauss Frame",				"A highly advanced gauss frame. It's almost alien in design, making it hard to use.",			"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_metalpole",		"Metal Pole",				"Long metal pole that could be used to attack things from a distance.",							"models/props_c17/signpole001.mdl")
GM:AddInventoryItemData("comp_salleather",		"Salvaged Leather",			"Pieces of leather that are hard enough to make a nasty impact.",								"models/props_junk/shoe001.mdl")
GM:AddInventoryItemData("comp_gyroscope",		"Gyroscope",				"A metal gyroscope used to calculate orientation.",												"models/maxofs2d/hover_rings.mdl")
GM:AddInventoryItemData("comp_reciever",		"Reciever",					"A radio reciever. Could be used for automation and communication purposes.",					"models/props_lab/reciever01b.mdl")
GM:AddInventoryItemData("comp_cpuparts",		"CPU Parts",				"Parts from a central processor.",																"models/props_lab/harddrive01.mdl")
GM:AddInventoryItemData("comp_launcher",		"Launching Tube",			"A metal tube made to launch objects.",															"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_launcherh",		"Heavy Launching Tube",		"A heavy metal tube made to launch large objects.",												"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_shortblade",		"Short Blade",				"A short metal blade for cutting and stabbing.",												"models/weapons/w_knife_t.mdl")
GM:AddInventoryItemData("comp_multibarrel",		"Multi-Bored Barrel",		"An unusual gun barrel which allows multiple bullets to pass through.",							"models/props_lab/pipesystem03a.mdl")
GM:AddInventoryItemData("comp_holoscope",		"Holographic Scope",		"A holographic weapon sight with magnification.",												{
	["base"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.273, 1.728, -0.843), angle = Angle(74.583, 180, 0), size = Vector(2.207, 0.105, 0.316), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_combine/tprotato1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.492, -1.03, 0), angle = Angle(0, -78.715, 90), size = Vector(0.03, 0.02, 0.032), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} }
})
GM:AddInventoryItemData("comp_linearactuator",	"Linear Actuator",			"A linear actuator from a shell holder. Requires a heavy base to mount properly.",				"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_pulsespool",		"Pulse Spool",				"Used to inject more pulse power to a system. Could be used to stabilise something.",			"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_flak",			"Flak Chamber",				"An internal chamber for projecting heated scrap.",												"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_precision",		"Precision Chassis",		"A suite setup for rewarding precise shots on moving targets.",									"models/Items/combine_rifle_cartridge01.mdl")

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
trinket, trinketwep = GM:AddTrinket("Health Package", "vitpackagei", false, hpveles, hpweles, 2, "+10 maximum health\n+5% healing received")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 10)
GM:AddSkillModifier(trinket, SKILLMOD_HEALING_RECEIVED, 0.05)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket("Vitality Bank", "vitpackageii", false, hpveles, hpweles, 4, "+21 maximum health\n+6% healing received")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 21)
GM:AddSkillModifier(trinket, SKILLMOD_HEALING_RECEIVED, 0.06)

trinket, trinketwep = GM:AddTrinket("Blood Transfusion Pack", "bloodpack", false, hpveles, hpweles, 2, "Generates 20 blood armor if health falls bellow 50%\nConsumes itself on activation.", nil, 15)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Blood Package", "cardpackagei", false, hpveles, hpweles, 2, "+10 maximum blood armor")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 10)
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket("Blood Bank", "cardpackageii", false, hpveles, hpweles, 4, "+30 maximum blood armor"), SKILLMOD_BLOODARMOR, 30)

GM:AddTrinket("Regeneration Implant", "regenimplant", false, hpveles, hpweles, 3, "Heals 1 health every 12 seconds provided no damage was taken recently")

trinket, trinketwep = GM:AddTrinket("Bio Cleanser", "biocleanser", false, hpveles, hpweles, 2, "Blocks one harmful status effect every 20 seconds")
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket("Cutlery Set", "cutlery", false, hpveles, hpweles, nil, "-80% time to eat food"), SKILLMOD_FOODEATTIME_MUL, -0.8)

-- Melee Trinkets

description = "5 hits from fist weapons applies significant leg and arm damage\n-15% time before next unarmed strike"
trinket = GM:AddTrinket("Boxing Training Manual", "boxingtraining", false, mveles, mweles, nil, description)
GM:AddSkillModifier(trinket, SKILLMOD_UNARMED_SWING_DELAY_MUL, -0.15)
GM:AddSkillFunction(trinket, function(pl, active) pl.BoxingTraining = active end)

trinket, trinketwep = GM:AddTrinket("Momentum Support", "momentumsupsysii", false, mveles, mweles, 2, "-13% melee swing impact delay\n+10% melee knockback")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.13)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_KNOCKBACK_MUL, 0.1)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket("Momentum Scaffold", "momentumsupsysiii", false, mveles, mweles, 3, "-20% melee swing impact delay\n+12% melee knockback")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.20)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_KNOCKBACK_MUL, 0.12)

GM:AddSkillModifier(GM:AddTrinket("Hemo-Adrenal Converter I", "hemoadrenali", false, mveles, mweles, nil, "+2% melee damage converted to blood armor."), SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.02)

trinket = GM:AddTrinket("Hemo-Adrenaline Amplifier", "hemoadrenalii", false, mveles, mweles, 3, "+3% melee damage converted to blood armor\n+30 speed on melee kill for 10 seconds")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.03)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, 30)

GM:AddSkillModifier(GM:AddTrinket("Hemo-Adrenal Converter II", "hemoadrenaliii", false, mveles, mweles, 4, "+4% melee damage converted to blood armor."), SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.04)

GM:AddSkillModifier(GM:AddTrinket("Power Gauntlet", "powergauntlet", false, mveles, mweles, 3, "Charges your melee damage up to +45% with each hit\nMissing resets damage"), SKILLMOD_MELEE_POWERATTACK_MUL, 0.45)

GM:AddTrinket("Finesse Kit", "sharpkit", false, mveles, mweles, 2, "Deal up to +32% melee damage to slowed zombies")

GM:AddTrinket("Sharp Stone", "sharpstone", false, mveles, mweles, 3, "+5% melee damage")

-- Performance Trinkets
GM:AddTrinket("Oxygen Tank", "oxygentank", true, nil, {
	["base"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 3, -1), angle = Angle(180, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, nil, "10x breathing time underwater.", "oxygentank")

GM:AddSkillModifier(GM:AddTrinket("Acrobat Frame", "acrobatframe", false, pveles, pweles, nil, "+8% jump power."), SKILLMOD_JUMPPOWER_MUL, 0.08)

trinket = GM:AddTrinket("Night Vision Goggles", "nightvision", true, pveles, pweles, 2, "-50% effect of dim vision and ability to see in the dark\n-40% effect of vision affecting effects\n-45% fright duration")
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

trinket = GM:AddTrinket("Portable Weapons Satchel", "portablehole", false, pveles, pweles, nil, "+15% weapon switch speed\n+3% reload speed")
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYSPEED_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_RELOADSPEED_MUL, 0.03)

trinket = GM:AddTrinket("Agility Magnifier", "pathfinder", false, pveles, pweles, 2, "+40% barricade phasing movement speed\n-45% sigil teleportation time\n+13% jump power")
GM:AddSkillModifier(trinket, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.4)
GM:AddSkillModifier(trinket, SKILLMOD_SIGIL_TELEPORT_MUL, -0.45)
GM:AddSkillModifier(trinket, SKILLMOD_JUMPPOWER_MUL, 0.13)

trinket = GM:AddTrinket("Galvanizer Implant", "analgestic", false, pveles, pweles, 3, "-50% low health slow intensity\n-50% slow vulnerability\n-50% knockdown time\n-66% duration of pulling attacks\n+25% weapon switch speed")
GM:AddSkillModifier(trinket, SKILLMOD_SLOW_EFF_TAKEN_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_KNOCKDOWN_RECOVERY_MUL, -0.5)
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYSPEED_MUL, 0.25)

GM:AddSkillModifier(GM:AddTrinket("Ammo Vest", "ammovestii", false, ammoveles, ammoweles, 2, "+5% reload speed"), SKILLMOD_RELOADSPEED_MUL, 0.05)
GM:AddSkillModifier(GM:AddTrinket("Ammo Bandolier", "ammovestiii", false, ammoveles, ammoweles, 4, "+12% reload speed"), SKILLMOD_RELOADSPEED_MUL, 0.12)

GM:AddTrinket("Automated Reloader", "autoreload", false, ammoveles, ammoweles, 2, "Reloads one weapon you switched away from 4 seconds ago automatically")

-- Offensive Implants
GM:AddSkillModifier(GM:AddTrinket("Targeting Visor", "targetingvisori", false, oveles, oweles, nil, "+5% tighter aiming reticule."), SKILLMOD_AIMSPREAD_MUL, -0.05)

GM:AddSkillModifier(GM:AddTrinket("Targeting Unifier", "targetingvisoriii", false, oveles, oweles, 4, "+11% tighter aiming reticule."), SKILLMOD_AIMSPREAD_MUL, -0.11)

GM:AddTrinket("Refined Subscope", "refinedsub", false, oveles, oweles, 4, "+27% tighter aiming reticule with tier 3 or lower weapons")

trinket = GM:AddTrinket("Aim Compensator", "aimcomp", false, oveles, oweles, 3, "-52% reduced effect of aim shake effects\n+5% tighter aiming reticule\nZombies you look at have an indicator showing their health")
GM:AddSkillModifier(trinket, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_AIM_SHAKE_MUL, -0.52)
GM:AddSkillFunction(trinket, function(pl, active) pl.TargetLocus = active end)

GM:AddSkillModifier(GM:AddTrinket("Pulse Booster", "pulseampi", false, oveles, oweles, nil, "+14% slow from pulse weapons and stun batons"), SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.14)

trinket = GM:AddTrinket("Pulse Infuser", "pulseampii", false, oveles, oweles, 3, "+20% slow from pulse weapons and stun batons\n+7% explosion radius")
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.2)
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_RADIUS, 0.07)

trinket = GM:AddTrinket("Resonance Cascade Device", "resonance", false, oveles, oweles, 4, "Dealing enough pulse damage will cause a pulse explosion\n-25% slow from pulse weapons and stun batons")
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, -0.25)

trinket = GM:AddTrinket("Cryogenic Inductor", "cryoindu", false, oveles, oweles, 4, "Ice based weapons have a chance to shatter zombies based on how much health they have")

trinket = GM:AddTrinket("Extended Magazine", "extendedmag", false, oveles, oweles, 3, "Increases the clip size of weapons with 8 or more clip size by +15%")

trinket = GM:AddTrinket("Pulse Impedance Module", "pulseimpedance", false, oveles, oweles, 5, "Slow from pulse weapons and stun batons also slow zombie attack speed\n+24% slow from pulse weapons and stun batons")
GM:AddSkillFunction(trinket, function(pl, active) pl.PulseImpedance = active end)
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.24)

trinket = GM:AddTrinket("Curb Stompers", "curbstompers", false, oveles, oweles, 2, "Instantly kills headcrabs and deals 50 damage to torso classes you land on\nDeals 500% fall damage to zombies landed on\nNo fall damage taken when landing on zombies\n-25% slow down from landing or fall damage")
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, -0.25)

GM:AddTrinket("Superior Assembly", "supasm", false, oveles, oweles, 5, "Increases to weapon damage via remantling affect reload speed on tier 2 or lower weapons")

trinket = GM:AddTrinket("Olympian Frame", "olympianframe", false, oveles, oweles, 2, "+100% object throwing strength\n-25% prop carrying slow down\n-35% movement speed reduction with heavy weapons")
GM:AddSkillModifier(trinket, SKILLMOD_PROP_THROW_STRENGTH_MUL, 1)
GM:AddSkillModifier(trinket, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.25)
GM:AddSkillModifier(trinket, SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, -0.35)

-- Defensive Trinkets
trinket, trinketwep = GM:AddTrinket("Kevlar Underlay", "kevlar", false, develes, deweles, 2, "-11% melee damage taken\n-11% projectile damage taken")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.11)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, -0.11)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket("Barbed Armor", "barbedarmor", false, develes, deweles, 3, "100% of melee damage taken reflected back to melee attackers\nAdditional 14 damage reflected back to melee attackers\nMelee attackers take 14 arm damage\n-4% melee damage taken")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_ATTACKER_DMG_REFLECT, 14)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT, 1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.04)

trinket = GM:AddTrinket("Antitoxin Package", "antitoxinpack", false, develes, deweles, 2, "-17% poison damage taken\n-40% poison damage over time speed")
GM:AddSkillModifier(trinket, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, -0.17)
GM:AddSkillModifier(trinket, SKILLMOD_POISON_SPEED_MUL, -0.4)

trinket = GM:AddTrinket("Hemostasis Implant", "hemostasis", false, develes, deweles, 2, "-30% bleed damage taken\n-60% bleeding speed.")
GM:AddSkillModifier(trinket, SKILLMOD_BLEED_DAMAGE_TAKEN_MUL, -0.3)
GM:AddSkillModifier(trinket, SKILLMOD_BLEED_SPEED_MUL, -0.6)

trinket = GM:AddTrinket("EOD Vest", "eodvest", false, develes, deweles, 4, "-35% explosive damage taken\n-50% fire damage taken\n-5% self damage taken")
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.35)
GM:AddSkillModifier(trinket, SKILLMOD_FIRE_DAMAGE_TAKEN_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_SELF_DAMAGE_MUL, -0.05)

trinket = GM:AddTrinket("Feather Fall Frame", "featherfallframe", false, develes, deweles, 3, "-35% fall damage taken\n+30% fall damage threshold\n-65% slow down from landing or fall damage")
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_DAMAGE_MUL, -0.35)
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_THRESHOLD_MUL, 0.30)
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, -0.65)

local eicev = {
	["base"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.339, 2.697, -2.309), angle = Angle(4.558, -34.502, -72.395), size = Vector(0.5, 0.5, 0.5), color = Color(0, 137, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

local eicew = {
	["base"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.556, 2.519, -1.468), angle = Angle(0, -5.844, -75.974), size = Vector(0.5, 0.5, 0.5), color = Color(0, 137, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

GM:AddTrinket("Iceburst Shield", "iceburst", false, eicev, eicew, nil, "Releases an ice burst when taking a melee hit, slowing zombies down\nRecharges every 40 seconds")

GM:AddSkillModifier(GM:AddTrinket("Force Dampening Field Emitter", "forcedamp", false, develes, deweles, 2, "-33% physics impact damage taken\nImmune to knockdowns from props\nTake normal physics damage from shades."), SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL, -0.33)

GM:AddSkillFunction(GM:AddTrinket("Necrotic Senses Distorter", "necrosense", false, develes, deweles, 2, "Hides aura from zombies in close proximity"), function(pl, active) pl:SetDTBool(DT_PLAYER_BOOL_NECRO, active) end)

trinket, trinketwep = GM:AddTrinket("Reactive Flasher", "reactiveflasher", false, develes, deweles, 2, "Blinds and disorients melee attacker for 2 seconds\nRecharges every 75 seconds")
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket("Composite Underlay", "composite", false, develes, deweles, 4, "-16% melee damage taken\n-16% projectile damage taken")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.16)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, -0.16)

-- Support Trinkets
trinket, trinketwep = GM:AddTrinket("Arsenal Pack", "arsenalpack", false, {
	["base"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, {
	["base"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, 4, "Allows nearby humans to purchase from the arsenal menu.", "arsenalpack", 3)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Resupply Pack", "resupplypack", true, nil, {
	["base"] = { type = "Model", model = "models/Items/ammocrate_ar2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, 4, "Allows humans to resupply from you\nPress LMB with the pack in your hand to resupply yourself.", "resupplypack", 3)
trinketwep.PermitDismantle = true

GM:AddTrinket("Magnet", "magnet", true, supveles, supweles, nil, "Slowly pulls ammo and weapons towards you\nMust be equipped to take effect", "magnet")
GM:AddTrinket("Electromagnet", "electromagnet", true, supveles, supweles, nil, "Pulls ammo and weapons towards you quickly\nMust be equipped to take effect", "magnet_electro")

trinket, trinketwep = GM:AddTrinket("Loading Exoskeleton", "loadingex", false, supveles, supweles, 2, "-55% prop carrying slow down\n-20% deployable pack time")
GM:AddSkillModifier(trinket, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.55)
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYABLE_PACKTIME_MUL, -0.2)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Blueprints", "blueprintsi", false, supveles, supweles, 2, "+10% repair rate")
GM:AddSkillModifier(trinket, SKILLMOD_REPAIRRATE_MUL, 0.1)
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket("Advanced Blueprints", "blueprintsii", false, supveles, supweles, 4, "+20% repair rate"), SKILLMOD_REPAIRRATE_MUL, 0.2)

trinket, trinketwep = GM:AddTrinket("Medical Processor", "processor", false, supveles, supweles, 2, "-5% medic kit cooldown\n-10% medic tool fire delay\nReprocess food into medical ammo with right click")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, -0.1)

trinket = GM:AddTrinket("Curative Kit", "curativeii", false, supveles, supweles, 3, "-10% medic kit cooldown\n-20% medic tool fire delay")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, -0.2)

trinket = GM:AddTrinket("Remedial Booster", "remedy", false, supveles, supweles, 3, "+8% medic tool effectiveness")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.08)

trinket = GM:AddTrinket("Maintenance Suite", "mainsuite", false, supveles, supweles, 2, "+10% zapper and repair field range\n-7% zapper and repair field delay\n+10% turret range")
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_RANGE_MUL, 0.1)
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_DELAY_MUL, -0.07)
GM:AddSkillModifier(trinket, SKILLMOD_TURRET_RANGE_MUL, 0.1)

trinket = GM:AddTrinket("Control Platform", "controlplat", false, supveles, supweles, 2, "+15% controllable health\n+15% controllable speed\n+20% manhack damage")
GM:AddSkillModifier(trinket, SKILLMOD_CONTROLLABLE_HEALTH_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_CONTROLLABLE_SPEED_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_MANHACK_DAMAGE_MUL, 0.2)

trinket = GM:AddTrinket("Projectile Guidance", "projguide", false, supveles, supweles, 2, "+25% projectile speed")
GM:AddSkillModifier(trinket, SKILLMOD_PROJ_SPEED, 0.25)

trinket = GM:AddTrinket("Projectile Weight", "projwei", false, supveles, supweles, 2, "-50% projectile speed\n+5% projectile damage")
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

trinket = GM:AddTrinket("Reactive Chemicals", "reachem", false, ectov, ectow, 3, "+30% explosive damage taken\n+10% explosive damage radius")
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, 0.3)
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_RADIUS, 0.1)

trinket = GM:AddTrinket("Operations Matrix", "opsmatrix", false, supveles, supweles, 4, "+15% zapper and repair field range\n-13% zapper and repair field delay\n+15% turret range")
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_RANGE_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_DELAY_MUL, -0.13)
GM:AddSkillModifier(trinket, SKILLMOD_TURRET_RANGE_MUL, 0.15)

GM:AddSkillModifier(GM:AddTrinket("Acquisitions Manifest", "acqmanifest", false, supveles, supweles, 2, "-6% resupply delay time"), SKILLMOD_RESUPPLY_DELAY_MUL, -0.06)
GM:AddSkillModifier(GM:AddTrinket("Procurement Manifest", "promanifest", false, supveles, supweles, 4, "-9% resupply delay time"), SKILLMOD_RESUPPLY_DELAY_MUL, -0.09)

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

GM:AddTrinket("Bleak Soul", "bleaksoul", false, blcorev, blcorew, nil, "Blinds and knocks zombies away when attacked\nRecharges every 35 seconds")

trinket = GM:AddTrinket("Spirit Essence", "spiritess", false, nil, {
	["black_core_2"] = { type = "Sprite", sprite = "effects/splashwake3", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 7.697, y = 7.697 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core_2+"] = { type = "Sprite", sprite = "effects/splashwake1", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 10, y = 10 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, 0), angle = Angle(0, 0, 0), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}, nil, "+10% jump height.")
GM:AddSkillModifier(trinket, SKILLMOD_JUMPPOWER_MUL, 0.13)

-- Starter Trinkets

trinket, trinketwep = GM:AddTrinket("Armband", "armband", false, mveles, mweles, nil, "-10% melee swing impact delay\n-6% melee damage taken")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.06)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Condiments", "condiments", false, supveles, supweles, nil, "+20% recovery from food\n-20% time to eat food")
GM:AddSkillModifier(trinket, SKILLMOD_FOODRECOVERY_MUL, 0.20)
GM:AddSkillModifier(trinket, SKILLMOD_FOODEATTIME_MUL, -0.20)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Escape Manual", "emanual", false, develes, deweles, nil, "+20% phasing speed\n-12% low health slow intensity")
GM:AddSkillModifier(trinket, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.20)
GM:AddSkillModifier(trinket, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.12)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Aiming Aid", "aimaid", false, develes, deweles, nil, "+5% tighter aiming reticule\n-7% reduced effect of aim shake effects")
GM:AddSkillModifier(trinket, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_AIM_SHAKE_MUL, -0.06)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Vitamin Capsules", "vitamins", false, hpveles, hpweles, nil, "+5 maximum health\n-12% poison damage taken")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 5)
GM:AddSkillModifier(trinket, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, -0.12)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Welfare Shield", "welfare", false, hpveles, hpweles, nil, "-5% resupply delay\n-7% self damage taken")
GM:AddSkillModifier(trinket, SKILLMOD_RESUPPLY_DELAY_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_SELF_DAMAGE_MUL, -0.07)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Chemistry Set", "chemistry", false, hpveles, hpweles, nil, "+6% medic tool effectiveness\n+12% cloud bomb time")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.06)
GM:AddSkillModifier(trinket, SKILLMOD_CLOUD_TIME, 0.12)
trinketwep.PermitDismantle = true
