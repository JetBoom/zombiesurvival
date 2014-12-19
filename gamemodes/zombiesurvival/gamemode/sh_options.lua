GM.ZombieEscapeWeapons = {
	"weapon_zs_zedeagle",
	"weapon_zs_zeakbar",
	"weapon_zs_zesweeper",
	"weapon_zs_zesmg",
	"weapon_zs_zestubber",
	"weapon_zs_zebulletstorm"
}

-- Change this if you plan to alter the cost of items or you severely change how Worth works.
-- Having separate cart files allows people to have separate loadouts for different servers.
GM.CartFile = "zscarts.txt"

ITEMCAT_GUNS = 1
ITEMCAT_AMMO = 2
ITEMCAT_MELEE = 3
ITEMCAT_TOOLS = 4
ITEMCAT_OTHER = 5
ITEMCAT_TRAITS = 6
ITEMCAT_RETURNS = 7

GM.ItemCategories = {
	[ITEMCAT_GUNS] = "Guns",
	[ITEMCAT_AMMO] = "Ammunition",
	[ITEMCAT_MELEE] = "Melee Weapons",
	[ITEMCAT_TOOLS] = "Tools",
	[ITEMCAT_OTHER] = "Other",
	[ITEMCAT_TRAITS] = "Traits",
	[ITEMCAT_RETURNS] = "Returns"
}

--[[
Humans select what weapons (or other things) they want to start with and can even save favorites. Each object has a number of 'Worth' points.
Signature is a unique signature to give in case the item is renamed or reordered. Don't use a number or a string number!
A human can only use 100 points (default) when they join. Redeeming or joining late starts you out with a random loadout from above.
SWEP is a swep given when the player spawns with that perk chosen.
Callback is a function called. Model is a display model. If model isn't defined then the SWEP model will try to be used.
swep, callback, and model can all be nil or empty
]]
GM.Items = {}
function GM:AddItem(signature, name, desc, category, worth, swep, callback, model, worthshop, pointshop)
	local tab = {Signature = signature, Name = name, Description = desc, Category = category, Worth = worth or 0, SWEP = swep, Callback = callback, Model = model, WorthShop = worthshop, PointShop = pointshop}
	self.Items[#self.Items + 1] = tab

	return tab
end

function GM:AddStartingItem(signature, name, desc, category, points, worth, callback, model)
	return self:AddItem(signature, name, desc, category, points, worth, callback, model, true, false)
end

function GM:AddPointShopItem(signature, name, desc, category, points, worth, callback, model)
	return self:AddItem("ps_"..signature, name, desc, category, points, worth, callback, model, false, true)
end

-- Weapons are registered after the gamemode.
timer.Simple(0, function()
	for _, tab in pairs(GAMEMODE.Items) do
		if not tab.Description and tab.SWEP then
			local sweptab = weapons.GetStored(tab.SWEP)
			if sweptab then
				tab.Description = sweptab.Description
			end
		end
	end
end)

-- How much ammo is considered one 'clip' of ammo? For use with setting up weapon defaults. Works directly with zs_survivalclips
GM.AmmoCache = {}
GM.AmmoCache["ar2"] = 30 -- Assault rifles.
GM.AmmoCache["alyxgun"] = 24 -- Not used.
GM.AmmoCache["pistol"] = 12 -- Pistols.
GM.AmmoCache["smg1"] = 30 -- SMG's and some rifles.
GM.AmmoCache["357"] = 6 -- Rifles, especially of the sniper variety.
GM.AmmoCache["xbowbolt"] = 4 -- Crossbows
GM.AmmoCache["buckshot"] = 8 -- Shotguns
GM.AmmoCache["ar2altfire"] = 1 -- Not used.
GM.AmmoCache["slam"] = 1 -- Force Field Emitters.
GM.AmmoCache["rpg_round"] = 1 -- Not used. Rockets?
GM.AmmoCache["smg1_grenade"] = 1 -- Not used.
GM.AmmoCache["sniperround"] = 1 -- Barricade Kit
GM.AmmoCache["sniperpenetratedround"] = 1 -- Remote Det pack.
GM.AmmoCache["grenade"] = 1 -- Grenades.
GM.AmmoCache["thumper"] = 1 -- Gun turret.
GM.AmmoCache["gravity"] = 1 -- Unused.
GM.AmmoCache["battery"] = 30 -- Used with the Medical Kit.
GM.AmmoCache["gaussenergy"] = 1 -- Nails used with the Carpenter's Hammer.
GM.AmmoCache["combinecannon"] = 1 -- Not used.
GM.AmmoCache["airboatgun"] = 1 -- Arsenal crates.
GM.AmmoCache["striderminigun"] = 1 -- Message beacons.
GM.AmmoCache["helicoptergun"] = 1 --Resupply boxes.
GM.AmmoCache["spotlamp"] = 1
GM.AmmoCache["manhack"] = 1
GM.AmmoCache["pulse"] = 30

-- These ammo types are available at ammunition boxes.
-- The amount is the ammo to give them.
-- If the player isn't holding a weapon that uses one of these then they will get smg1 ammo.
GM.AmmoResupply = {}
GM.AmmoResupply["ar2"] = 20
GM.AmmoResupply["alyxgun"] = GM.AmmoCache["alyxgun"]
GM.AmmoResupply["pistol"] = GM.AmmoCache["pistol"]
GM.AmmoResupply["smg1"] = 20
GM.AmmoResupply["357"] = GM.AmmoCache["357"]
GM.AmmoResupply["xbowbolt"] = GM.AmmoCache["xbowbolt"]
GM.AmmoResupply["buckshot"] = GM.AmmoCache["buckshot"]
GM.AmmoResupply["battery"] = 20
GM.AmmoResupply["pulse"] = GM.AmmoCache["pulse"]


-----------
-- Worth --
-----------

GM:AddStartingItem("pshtr", "'Peashooter' Handgun", nil, ITEMCAT_GUNS, 40, "weapon_zs_peashooter")
GM:AddStartingItem("btlax", "'Battleaxe' Handgun", nil, ITEMCAT_GUNS, 40, "weapon_zs_battleaxe")
GM:AddStartingItem("owens", "'Owens' Handgun", nil, ITEMCAT_GUNS, 40, "weapon_zs_owens")
GM:AddStartingItem("blstr", "'Blaster' Shotgun", nil, ITEMCAT_GUNS, 55, "weapon_zs_blaster")
GM:AddStartingItem("tossr", "'Tosser' SMG", nil, ITEMCAT_GUNS, 50, "weapon_zs_tosser")
GM:AddStartingItem("stbbr", "'Stubber' Rifle", nil, ITEMCAT_GUNS, 55, "weapon_zs_stubber")
GM:AddStartingItem("crklr", "'Crackler' Assault Rifle", nil, ITEMCAT_GUNS, 50, "weapon_zs_crackler")
GM:AddStartingItem("z9000", "'Z9000' Pulse Pistol", nil, ITEMCAT_GUNS, 50, "weapon_zs_z9000")

GM:AddStartingItem("2pcp", "3 pistol ammo boxes", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 3, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("2sgcp", "3 shotgun ammo boxes", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 3, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("2smgcp", "3 SMG ammo boxes", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 3, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("2arcp", "3 assault rifle ammo boxes", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 3, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("2rcp", "3 rifle ammo boxes", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 3, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("2pls", "3 pulse ammo boxes", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 3, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddStartingItem("3pcp", "5 pistol ammo boxes", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 5, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("3sgcp", "5 shotgun ammo boxes", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 5, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("3smgcp", "5 SMG ammo boxes", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 5, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("3arcp", "5 assault rifle ammo boxes", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 5, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("3rcp", "5 rifle ammo boxes", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 5, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("3pls", "5 pulse ammo boxes", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 5, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")

GM:AddStartingItem("zpaxe", "Axe", nil, ITEMCAT_MELEE, 30, "weapon_zs_axe")
GM:AddStartingItem("crwbar", "Crowbar", nil, ITEMCAT_MELEE, 30, "weapon_zs_crowbar")
GM:AddStartingItem("stnbtn", "Stun Baton", nil, ITEMCAT_MELEE, 45, "weapon_zs_stunbaton")
GM:AddStartingItem("csknf", "Knife", nil, ITEMCAT_MELEE, 10, "weapon_zs_swissarmyknife")
GM:AddStartingItem("zpplnk", "Plank", nil, ITEMCAT_MELEE, 10, "weapon_zs_plank")
GM:AddStartingItem("zpfryp", "Frying Pan", nil, ITEMCAT_MELEE, 20, "weapon_zs_fryingpan")
GM:AddStartingItem("zpcpot", "Cooking Pot", nil, ITEMCAT_MELEE, 20, "weapon_zs_pot")
GM:AddStartingItem("pipe", "Lead Pipe", nil, ITEMCAT_MELEE, 45, "weapon_zs_pipe")
GM:AddStartingItem("hook", "Meat Hook", nil, ITEMCAT_MELEE, 30, "weapon_zs_hook")

GM:AddStartingItem("medkit", "Medical Kit", nil, ITEMCAT_TOOLS, 50, "weapon_zs_medicalkit")
GM:AddStartingItem("medgun", "Medic Gun", nil, ITEMCAT_TOOLS, 45, "weapon_zs_medicgun")
GM:AddStartingItem("150mkit", "150 Medical Kit power", "150 extra power for the Medical Kit.", ITEMCAT_TOOLS, 30, nil, function(pl) pl:GiveAmmo(150, "Battery", true) end, "models/healthvial.mdl")
GM:AddStartingItem("arscrate", "Arsenal Crate", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate").Countables = "prop_arsenalcrate"
GM:AddStartingItem("resupplybox", "Resupply Box", nil, ITEMCAT_TOOLS, 70, "weapon_zs_resupplybox").Countables = "prop_resupplybox"
local item = GM:AddStartingItem("infturret", "Infrared Gun Turret", nil, ITEMCAT_TOOLS, 75, nil, function(pl)
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
	pl:GiveAmmo(250, "smg1")
end)
item.Countables = {"weapon_zs_gunturret", "prop_gunturret"}
item.NoClassicMode = true
local item = GM:AddStartingItem("manhack", "Manhack", nil, ITEMCAT_TOOLS, 60, "weapon_zs_manhack")
item.Countables = "prop_manhack"
GM:AddStartingItem("wrench", "Mechanic's Wrench", nil, ITEMCAT_TOOLS, 15, "weapon_zs_wrench").NoClassicMode = true
GM:AddStartingItem("crphmr", "Carpenter's Hammer", nil, ITEMCAT_TOOLS, 45, "weapon_zs_hammer").NoClassicMode = true
GM:AddStartingItem("6nails", "Box of 12 nails", "An extra box of nails for all your barricading needs.", ITEMCAT_TOOLS, 25, nil, function(pl) pl:GiveAmmo(12, "GaussEnergy", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("junkpack", "Junk Pack", nil, ITEMCAT_TOOLS, 40, "weapon_zs_boardpack")
GM:AddStartingItem("spotlamp", "Spot Lamp", nil, ITEMCAT_TOOLS, 25, "weapon_zs_spotlamp").Countables = "prop_spotlamp"
GM:AddStartingItem("msgbeacon", "Message Beacon", nil, ITEMCAT_TOOLS, 10, "weapon_zs_messagebeacon").Countables = "prop_messagebeacon"
--GM:AddStartingItem("ffemitter", "Force Field Emitter", nil, ITEMCAT_TOOLS, 60, "weapon_zs_ffemitter").Countables = "prop_ffemitter"

GM:AddStartingItem("stone", "Stone", nil, ITEMCAT_OTHER, 5, "weapon_zs_stone")
GM:AddStartingItem("grenade", "Grenade", nil, ITEMCAT_OTHER, 30, "weapon_zs_grenade")
GM:AddStartingItem("detpck", "Detonation Pack", nil, ITEMCAT_OTHER, 35, "weapon_zs_detpack").Countables = "prop_detpack"
GM:AddStartingItem("oxtank", "Oxygen Tank", "Grants signitifantly more underwater breathing time to the user.", ITEMCAT_OTHER, 15, "weapon_zs_oxygentank")

GM:AddStartingItem("10hp", "Fit", "Increases survivability by increasing maximum health by a small amount.", ITEMCAT_TRAITS, 10, nil, function(pl) pl:SetMaxHealth(pl:GetMaxHealth() + 10) pl:SetHealth(pl:Health() + 10) end, "models/healthvial.mdl")
GM:AddStartingItem("25hp", "Tough", "Increases survivability by increasing maximum health.", ITEMCAT_TRAITS, 20, nil, function(pl) pl:SetMaxHealth(pl:GetMaxHealth() + 25) pl:SetHealth(pl:Health() + 25) end, "models/items/healthkit.mdl")
local item = GM:AddStartingItem("5spd", "Quick", "Gives a slight bonus to running speed.", ITEMCAT_TRAITS, 10, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 7 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
local item = GM:AddStartingItem("10spd", "Surged", "Gives a noticeable bonus to running speed.", ITEMCAT_TRAITS, 15, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 14 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
GM:AddStartingItem("bfhandy", "Handy", "Gives a 25% bonus to all repair rates.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.HumanRepairMultiplier = (pl.HumanRepairMultiplier or 1) + 0.25 end, "models/props_c17/tools_wrench01a.mdl")
GM:AddStartingItem("bfsurgeon", "Surgeon", "Increases the rate by which you can heal yourself and others with the Medical Kit by 30%. Increases Medic Gun effectiveness by 33%.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.HumanHealMultiplier = (pl.HumanHealMultiplier or 1) + 0.3 end, "models/healthvial.mdl")
GM:AddStartingItem("bfresist", "Resistant", "You will take half damage from poison.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffResistant = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfregen", "Regenerative", "If you drop below 50% health, you will regenerate 1 health every 6 seconds.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffRegenerative = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfmusc", "Muscular", "You do 20% extra damage with melee weapons and you can carry heavy objects instead of dragging them.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffMuscular = true pl:DoMuscularBones() end, "models/props_wasteland/kitchen_shelf001a.mdl")

GM:AddStartingItem("dbfweak", "Weakness", "Reduces health by 30 in exchange for Worth.", ITEMCAT_RETURNS, -15, nil, function(pl) pl:SetMaxHealth(math.max(1, pl:GetMaxHealth() - 30)) pl:SetHealth(pl:GetMaxHealth()) pl.IsWeak = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfslow", "Slowness", "Reduces speed by a significant amount in exchange for Worth.", ITEMCAT_RETURNS, -5, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 1) - 20 pl:ResetSpeed() pl.IsSlow = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfpalsy", "Palsy", "Reduces aiming ability while hurt in exchange for Worth.", ITEMCAT_RETURNS, -5, nil, function(pl) pl:SetPalsy(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfhemo", "Hemophilia", "Applies bleeding damage when hit in exchange for Worth.", ITEMCAT_RETURNS, -15, nil, function(pl) pl:SetHemophilia(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfunluc", "Banned for Life", "Disallows point purchases in exchange for Worth.", ITEMCAT_RETURNS, -25, nil, function(pl) pl:SetUnlucky(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfclumsy", "Clumsy", "Makes you extremely easy to knock down in exchange for Worth.", ITEMCAT_RETURNS, -25, nil, function(pl) pl.Clumsy = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfnoghosting", "Wide Load", "Prevents you from ghosting through props in exchange for Worth.", ITEMCAT_RETURNS, -20, nil, function(pl) pl.NoGhosting = true end, "models/gibs/HGIBS.mdl").NoClassicMode = true
GM:AddStartingItem("dbfnopickup", "Noodle Arms", "Disallows picking up of objects in exchange for Worth.", ITEMCAT_RETURNS, -10, nil, function(pl) pl.NoObjectPickup = true pl:DoNoodleArmBones() end, "models/gibs/HGIBS.mdl")

------------
-- Points --
------------

GM:AddPointShopItem("deagle", "'Zombie Drill' Desert Eagle", nil, ITEMCAT_GUNS, 30, "weapon_zs_deagle")
GM:AddPointShopItem("glock3", "'Crossfire' Glock 3", nil, ITEMCAT_GUNS, 30, "weapon_zs_glock3")
GM:AddPointShopItem("magnum", "'Ricochet' Magnum", nil, ITEMCAT_GUNS, 35, "weapon_zs_magnum")
GM:AddPointShopItem("eraser", "'Eraser' Tactical Pistol", nil, ITEMCAT_GUNS, 35, "weapon_zs_eraser")

GM:AddPointShopItem("uzi", "'Sprayer' Uzi 9mm", nil, ITEMCAT_GUNS, 70, "weapon_zs_uzi")
GM:AddPointShopItem("shredder", "'Shredder' SMG", nil, ITEMCAT_GUNS, 70, "weapon_zs_smg")
GM:AddPointShopItem("bulletstorm", "'Bullet Storm' SMG", nil, ITEMCAT_GUNS, 70, "weapon_zs_bulletstorm")
GM:AddPointShopItem("silencer", "'Silencer' SMG", nil, ITEMCAT_GUNS, 70, "weapon_zs_silencer")
GM:AddPointShopItem("hunter", "'Hunter' Rifle", nil, ITEMCAT_GUNS, 70, "weapon_zs_hunter")

GM:AddPointShopItem("reaper", "'Reaper' UMP", nil, ITEMCAT_GUNS, 80, "weapon_zs_reaper")
GM:AddPointShopItem("ender", "'Ender' Automatic Shotgun", nil, ITEMCAT_GUNS, 75, "weapon_zs_ender")
GM:AddPointShopItem("akbar", "'Akbar' Assault Rifle", nil, ITEMCAT_GUNS, 80, "weapon_zs_akbar")

GM:AddPointShopItem("stalker", "'Stalker' Assault Rifle", nil, ITEMCAT_GUNS, 125, "weapon_zs_m4")
GM:AddPointShopItem("inferno", "'Inferno' Assault Rifle", nil, ITEMCAT_GUNS, 125, "weapon_zs_inferno")
GM:AddPointShopItem("annabelle", "'Annabelle' Rifle", nil, ITEMCAT_GUNS, 100, "weapon_zs_annabelle")

GM:AddPointShopItem("crossbow", "'Impaler' Crossbow", nil, ITEMCAT_GUNS, 175, "weapon_zs_crossbow")

GM:AddPointShopItem("sweeper", "'Sweeper' Shotgun", nil, ITEMCAT_GUNS, 200, "weapon_zs_sweepershotgun")
GM:AddPointShopItem("boomstick", "Boom Stick", nil, ITEMCAT_GUNS, 200, "weapon_zs_boomstick")
GM:AddPointShopItem("slugrifle", "'Tiny' Slug Rifle", nil, ITEMCAT_GUNS, 200, "weapon_zs_slugrifle")
GM:AddPointShopItem("pulserifle", "'Adonis' Pulse Rifle", nil, ITEMCAT_GUNS, 225, "weapon_zs_pulserifle")

GM:AddPointShopItem("pistolammo", "pistol ammo box", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 12, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddPointShopItem("shotgunammo", "shotgun ammo box", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["buckshot"] or 8, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddPointShopItem("smgammo", "SMG ammo box", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["smg1"] or 30, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddPointShopItem("assaultrifleammo", "assault rifle ammo box", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["ar2"] or 30, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddPointShopItem("rifleammo", "rifle ammo box", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["357"] or 6, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddPointShopItem("crossbowammo", "crossbow bolt", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(1, "XBowBolt", true) end, "models/Items/CrossbowRounds.mdl")
GM:AddPointShopItem("pulseammo", "pulse ammo box", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pulse"] or 30, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")

GM:AddPointShopItem("axe", "Axe", nil, ITEMCAT_MELEE, 20, "weapon_zs_axe")
GM:AddPointShopItem("crowbar", "Crowbar", nil, ITEMCAT_MELEE, 20, "weapon_zs_crowbar")
GM:AddPointShopItem("stunbaton", "Stun Baton", nil, ITEMCAT_MELEE, 25, "weapon_zs_stunbaton")
GM:AddPointShopItem("knife", "Knife", nil, ITEMCAT_MELEE, 5, "weapon_zs_swissarmyknife")
GM:AddPointShopItem("shovel", "Shovel", nil, ITEMCAT_MELEE, 30, "weapon_zs_shovel")
GM:AddPointShopItem("sledgehammer", "Sledge Hammer", nil, ITEMCAT_MELEE, 30, "weapon_zs_sledgehammer")

GM:AddPointShopItem("crphmr", "Carpenter's Hammer", nil, ITEMCAT_TOOLS, 50, "weapon_zs_hammer").NoClassicMode = true
GM:AddPointShopItem("wrench", "Mechanic's Wrench", nil, ITEMCAT_TOOLS, 25, "weapon_zs_wrench").NoClassicMode = true
GM:AddPointShopItem("arsenalcrate", "Arsenal Crate", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate")
GM:AddPointShopItem("resupplybox", "Resupply Box", nil, ITEMCAT_TOOLS, 200, "weapon_zs_resupplybox")
local item = GM:AddPointShopItem("infturret", "Infrared Gun Turret", nil, ITEMCAT_TOOLS, 50, nil, function(pl)
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
	pl:GiveAmmo(250, "smg1")
end)
item.NoClassicMode = true
GM:AddPointShopItem("manhack", "Manhack", nil, ITEMCAT_TOOLS, 45, "weapon_zs_manhack")
GM:AddPointShopItem("barricadekit", "'Aegis' Barricade Kit", nil, ITEMCAT_TOOLS, 125, "weapon_zs_barricadekit")
GM:AddPointShopItem("nail", "Nail", "It's just one nail.", ITEMCAT_TOOLS, 5, nil, function(pl) pl:GiveAmmo(1, "GaussEnergy", true) end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("50mkit", "50 Medical Kit power", "50 extra power for the Medical Kit.", ITEMCAT_TOOLS, 30, nil, function(pl) pl:GiveAmmo(50, "Battery", true) end, "models/healthvial.mdl")

GM:AddPointShopItem("grenade", "Grenade", nil, ITEMCAT_OTHER, 60, "weapon_zs_grenade")
GM:AddPointShopItem("detpck", "Detonation Pack", nil, ITEMCAT_OTHER, 70, "weapon_zs_detpack")


-- These are the honorable mentions that come at the end of the round.

local function genericcallback(pl, magnitude) return pl:Name(), magnitude end
GM.HonorableMentions = {}
GM.HonorableMentions[HM_MOSTZOMBIESKILLED] = {Name = "Most zombies killed", String = "by %s, with %d killed zombies.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD] = {Name = "Most damage to undead", String = "goes to %s, with a total of %d damage dealt to the undead.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_PACIFIST] = {Name = "Pacifist", String = "goes to %s for not killing a single zombie and still surviving!", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTHELPFUL] = {Name = "Most helpful", String = "goes to %s for assisting in the disposal of %d zombies.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_LASTHUMAN] = {Name = "Last Human", String = "goes to %s for being the last person alive.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_OUTLANDER] = {Name = "Outlander", String = "goes to %s for getting killed %d feet away from a zombie spawn.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_GOODDOCTOR] = {Name = "Good Doctor", String = "goes to %s for healing their team for %d points of health.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_HANDYMAN] = {Name = "Handy Man", String = "goes to %s for getting %d barricade assistance points.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SCARECROW] = {Name = "Scarecrow", String = "goes to %s for killing %d poor crows.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTBRAINSEATEN] = {Name = "Most brains eaten", String = "by %s, with %d brains eaten.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS] = {Name = "Most damage to humans", String = "goes to %s, with a total of %d damage given to living players.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_LASTBITE] = {Name = "Last Bite", String = "goes to %s for ending the round.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_USEFULTOOPPOSITE] = {Name = "Most useful to opposite team", String = "goes to %s for giving up a whopping %d kills!", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_STUPID] = {Name = "Stupid", String = "is what %s is for getting killed %d feet away from a zombie spawn.", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_SALESMAN] = {Name = "Salesman", String = "is what %s is for having %d points worth of items taken from their arsenal crate.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_WAREHOUSE] = {Name = "Warehouse", String = "describes %s well since they had their resupply boxes used %d times.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SPAWNPOINT] = {Name = "Spawn Point", String = "goes to %s for having %d zombies spawn on them.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_CROWFIGHTER] = {Name = "Crow Fighter", String = "goes to %s for annihilating %d of his crow brethren.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_CROWBARRICADEDAMAGE] = {Name = "Minor Annoyance", String = "is what %s is for dealing %d damage to barricades while a crow.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_BARRICADEDESTROYER] = {Name = "Barricade Destroyer", String = "goes to %s for doing %d damage to barricades.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTDESTROYER] = {Name = "Nest Destroyer", String = "goes to %s for destroying %d nests.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTMASTER] = {Name = "Nest Master", String = "goes to %s for having %d zombies spawn through their nest.", Callback = genericcallback, Color = COLOR_LIMEGREEN}

-- Don't let humans use these models because they look like undead models. Must be lower case.
GM.RestrictedModels = {
	"models/player/zombie_classic.mdl",
	"models/player/zombine.mdl",
	"models/player/zombie_soldier.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/corpse1.mdl",
	"models/player/charple.mdl",
	"models/player/skeleton.mdl"
}

-- If a person has no player model then use one of these (auto-generated).
GM.RandomPlayerModels = {}
for name, mdl in pairs(player_manager.AllValidModels()) do
	if not table.HasValue(GM.RestrictedModels, string.lower(mdl)) then
		table.insert(GM.RandomPlayerModels, name)
	end
end

-- Utility function to setup a weapon's DefaultClip.
function GM:SetupDefaultClip(tab)
	tab.DefaultClip = math.ceil(tab.ClipSize * self.SurvivalClips * (tab.ClipMultiplier or 1))
end

GM.MaxSigils = CreateConVar("zs_maxsigils", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How many sigils to spawn. 0 for none."):GetInt()
cvars.AddChangeCallback("zs_maxsigils", function(cvar, oldvalue, newvalue)
	GAMEMODE.MaxSigils = math.Clamp(tonumber(newvalue) or 0, 0, 10)
end)

GM.DefaultRedeem = CreateConVar("zs_redeem", "4", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The amount of kills a zombie needs to do in order to redeem. Set to 0 to disable."):GetInt()
cvars.AddChangeCallback("zs_redeem", function(cvar, oldvalue, newvalue)
	GAMEMODE.DefaultRedeem = math.max(0, tonumber(newvalue) or 0)
end)

GM.WaveOneZombies = math.ceil(100 * CreateConVar("zs_waveonezombies", "0.1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The percentage of players that will start as zombies when the game begins."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_waveonezombies", function(cvar, oldvalue, newvalue)
	GAMEMODE.WaveOneZombies = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.NumberOfWaves = CreateConVar("zs_numberofwaves", "6", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Number of waves in a game."):GetInt()
cvars.AddChangeCallback("zs_numberofwaves", function(cvar, oldvalue, newvalue)
	GAMEMODE.NumberOfWaves = tonumber(newvalue) or 1
end)

-- Game feeling too easy? Just change these values!
GM.ZombieSpeedMultiplier = math.ceil(100 * CreateConVar("zs_zombiespeedmultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Zombie running speed will be scaled by this value."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_zombiespeedmultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieSpeedMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

-- This is a resistance, not for claw damage. 0.5 will make zombies take half damage, 0.25 makes them take 1/4, etc.
GM.ZombieDamageMultiplier = math.ceil(100 * CreateConVar("zs_zombiedamagemultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Scales the amount of damage that zombies take. Use higher values for easy zombies, lower for harder."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_zombiedamagemultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieDamageMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.TimeLimit = CreateConVar("zs_timelimit", "15", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Time in minutes before the game will change maps. It will not change maps if a round is currently in progress but after the current round ends. -1 means never switch maps. 0 means always switch maps."):GetInt() * 60
cvars.AddChangeCallback("zs_timelimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.TimeLimit = tonumber(newvalue) or 15
	if GAMEMODE.TimeLimit ~= -1 then
		GAMEMODE.TimeLimit = GAMEMODE.TimeLimit * 60
	end
end)

GM.RoundLimit = CreateConVar("zs_roundlimit", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How many times the game can be played on the same map. -1 means infinite or only use time limit. 0 means once."):GetInt()
cvars.AddChangeCallback("zs_roundlimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.RoundLimit = tonumber(newvalue) or 3
end)

-- Static values that don't need convars...

-- Initial length for wave 1.
GM.WaveOneLength = 220

-- For Classic Mode
GM.WaveOneLengthClassic = 120

-- Add this many seconds for each additional wave.
GM.TimeAddedPerWave = 15

-- For Classic Mode
GM.TimeAddedPerWaveClassic = 10

-- New players are put on the zombie team if the current wave is this or higher. Do not put it lower than 1 or you'll break the game.
GM.NoNewHumansWave = 2

-- Humans can not commit suicide if the current wave is this or lower.
GM.NoSuicideWave = 1

-- How long 'wave 0' should last in seconds. This is the time you should give for new players to join and get ready.
GM.WaveZeroLength = 150

-- Time humans have between waves to do stuff without NEW zombies spawning. Any dead zombies will be in spectator (crow) view and any living ones will still be living.
GM.WaveIntermissionLength = 90

-- For Classic Mode
GM.WaveIntermissionLengthClassic = 20

-- Time in seconds between end round and next map.
GM.EndGameTime = 60

-- How many clips of ammo guns from the Worth menu start with. Some guns such as shotguns and sniper rifles have multipliers on this.
GM.SurvivalClips = 2

-- Put your unoriginal, 5MB Rob Zombie and Metallica music here.
GM.LastHumanSound = Sound("zombiesurvival/lasthuman.ogg")

-- Sound played when humans all die.
GM.AllLoseSound = Sound("zombiesurvival/music_lose.ogg")

-- Sound played when humans survive.
GM.HumanWinSound = Sound("zombiesurvival/music_win.ogg")

-- Sound played to a person when they die as a human.
GM.DeathSound = Sound("music/stingers/HL1_stinger_song28.mp3")
