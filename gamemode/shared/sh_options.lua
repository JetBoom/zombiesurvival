--[[version 1.1 - tier system.
You must be running at least version of ZS:R (being Version 7 - Tier System)
for this file to be working. 
Also you need version 1.1 of this file for the current ZS:R version
listed or the client can not buy certain items such as ammo types.]]--

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
GM.CartFile = "zsrmct.txt"

ITEMCAT_GUNS = 1
ITEMCAT_AMMO = 2
ITEMCAT_MELEE = 3
ITEMCAT_TOOLS = 4
ITEMCAT_OTHER = 5
ITEMCAT_TRAITS = 6
ITEMCAT_RETURNS = 7

GM.ItemCategories = {
	[ITEMCAT_GUNS] = ""..translate.Get("title_guns"),
	[ITEMCAT_AMMO] = ""..translate.Get("title_ammo"),
	[ITEMCAT_MELEE] = ""..translate.Get("title_melee"),
	[ITEMCAT_TOOLS] = ""..translate.Get("title_tools"),
	[ITEMCAT_OTHER] = ""..translate.Get("title_other"),
	[ITEMCAT_TRAITS] = ""..translate.Get("title_traits"),
	[ITEMCAT_RETURNS] = ""..translate.Get("title_returns")
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
function GM:AddItem(signature, name, desc, category, worth, swep, callback, model, worthshop, pointshop, wave, unlocked, infliction)
	local tab = {Signature = signature, Name = name, Description = desc, Category = category, Worth = worth or 0, SWEP = swep, Callback = callback, Model = model, WorthShop = worthshop, PointShop = pointshop, Wave = wave or 0, Unlocked = unlocked, Infliction = infliction}
	self.Items[#self.Items + 1] = tab

	return tab
end

function GM:AddStartingItem(signature, name, desc, category, points, worth, callback, model)
	return self:AddItem(signature, name, desc, category, points, worth, callback, model, true, false, 0, true, nil)
end

function GM:AddPointShopItem(signature, name, desc, category, points, worth, wave, unlocked, infliction, callback, model)
	return self:AddItem("ps_"..signature, name, desc, category, points, worth, callback, model, false, true, wave, unlocked, infliction)
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

GM:AddStartingItem("pshtr", ""..translate.Get("worth_peashooter"), nil, ITEMCAT_GUNS, 15, "weapon_zs_peashooter")
GM:AddStartingItem("btlax", ""..translate.Get("worth_battleaxe"), nil, ITEMCAT_GUNS, 15, "weapon_zs_battleaxe")
GM:AddStartingItem("owens", ""..translate.Get("worth_owens"), nil, ITEMCAT_GUNS, 15, "weapon_zs_owens")
GM:AddStartingItem("tossr", ""..translate.Get("worth_tosser"), nil, ITEMCAT_GUNS, 20, "weapon_zs_tosser")
GM:AddStartingItem("z9000", ""..translate.Get("worth_z9000"), nil, ITEMCAT_GUNS, 20, "weapon_zs_z9000")
GM:AddStartingItem("stbbr", ""..translate.Get("worth_stubber"), nil, ITEMCAT_GUNS, 25, "weapon_zs_stubber")
GM:AddStartingItem("crklr", ""..translate.Get("worth_crackler"), nil, ITEMCAT_GUNS, 25, "weapon_zs_crackler")
GM:AddStartingItem("blstr", ""..translate.Get("worth_blaster"), nil, ITEMCAT_GUNS, 25, "weapon_zs_blaster")

-----------
-- W.AMMO --
-----------

GM:AddStartingItem("2pcp", ""..translate.Get("worth_3pistol"), nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 3, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("2sgcp", ""..translate.Get("worth_3shotgun"), nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 3, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("2smgcp", ""..translate.Get("worth_3smg"), nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 3, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("2arcp", ""..translate.Get("worth_3assaultrifle"), nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 3, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("2rcp", ""..translate.Get("worth_3rifle"), nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 3, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("2pls", ""..translate.Get("worth_3pulse"), nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 3, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddStartingItem("3pcp", ""..translate.Get("worth_5pistol"), nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 5, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("3sgcp", ""..translate.Get("worth_5shotgun"), nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 5, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("3smgcp", ""..translate.Get("worth_5smg"), nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 5, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("3arcp", ""..translate.Get("worth_5assaultrifle"), nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 5, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("3rcp", ""..translate.Get("worth_5rifle"), nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 5, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("3pls", ""..translate.Get("worth_5pulse"), nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 5, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")

-----------
-- W.MELEE --
-----------

GM:AddStartingItem("zpfryp", ""..translate.Get("worth_fryingpan"), nil, ITEMCAT_MELEE, 5, "weapon_zs_fryingpan")
GM:AddStartingItem("zpcpot", ""..translate.Get("worth_cookingpot"), nil, ITEMCAT_MELEE, 5, "weapon_zs_pot")
GM:AddStartingItem("csknf", ""..translate.Get("worth_knife"), nil, ITEMCAT_MELEE, 5, "weapon_zs_swissarmyknife")
GM:AddStartingItem("zpaxe", ""..translate.Get("worth_axe"), nil, ITEMCAT_MELEE, 10, "weapon_zs_axe")
GM:AddStartingItem("crwbar", ""..translate.Get("worth_crowbar"), nil, ITEMCAT_MELEE, 15, "weapon_zs_crowbar")
GM:AddStartingItem("hook", ""..translate.Get("worth_meathook"), nil, ITEMCAT_MELEE, 15, "weapon_zs_hook")
GM:AddStartingItem("stnbtn", ""..translate.Get("worth_stun"), nil, ITEMCAT_MELEE, 20, "weapon_zs_stunbaton")
GM:AddStartingItem("zpplnk", ""..translate.Get("worth_plank"), nil, ITEMCAT_MELEE, 20, "weapon_zs_plank")
GM:AddStartingItem("pipe", ""..translate.Get("worth_leadpipe"), nil, ITEMCAT_MELEE, 25, "weapon_zs_pipe")

-----------
-- W.TOOLS --
-----------
GM:AddStartingItem("msgbeacon", ""..translate.Get("worth_beacon"), nil, ITEMCAT_TOOLS, 1, "weapon_zs_messagebeacon").Countables = "prop_messagebeacon"
GM:AddStartingItem("spotlamp", ""..translate.Get("worth_spotlamp"), nil, ITEMCAT_TOOLS, 5, "weapon_zs_spotlamp").Countables = "prop_spotlamp"
GM:AddStartingItem("6nails", ""..translate.Get("worth_6nails"), ""..translate.Get("worth_6nails2"), ITEMCAT_TOOLS, 12, nil, function(pl) pl:GiveAmmo(12, "GaussEnergy", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("wrench", ""..translate.Get("worth_wrench"), nil, ITEMCAT_TOOLS, 15, "weapon_zs_wrench").NoClassicMode = true
GM:AddStartingItem("crphmr", ""..translate.Get("worth_hammer"), nil, ITEMCAT_TOOLS, 15, "weapon_zs_hammer").NoClassicMode = true
GM:AddStartingItem("arscrate", ""..translate.Get("worth_arsenalcrate"), nil, ITEMCAT_TOOLS, 15, "weapon_zs_arsenalcrate").Countables = "prop_arsenalcrate"
GM:AddStartingItem("150mkit", ""..translate.Get("worth_150meds"), ""..translate.Get("worth_150meds2"), ITEMCAT_TOOLS, 15, nil, function(pl) pl:GiveAmmo(150, "Battery", true) end, "models/healthvial.mdl")
GM:AddStartingItem("medkit", ""..translate.Get("worth_medkit"), nil, ITEMCAT_TOOLS, 20, "weapon_zs_medicalkit")
GM:AddStartingItem("junkpack", ""..translate.Get("worth_junkpack"), nil, ITEMCAT_TOOLS, 20, "weapon_zs_boardpack")
GM:AddStartingItem("medgun", ""..translate.Get("worth_medgun"), nil, ITEMCAT_TOOLS, 25, "weapon_zs_medicgun")
local item = GM:AddStartingItem("manhack", ""..translate.Get("worth_manhack"), nil, ITEMCAT_TOOLS, 20, "weapon_zs_manhack")
item.Countables = "prop_manhack"
GM:AddStartingItem("resupplybox", ""..translate.Get("worth_resupplybox"), nil, ITEMCAT_TOOLS, 30, "weapon_zs_resupplybox").Countables = "prop_resupplybox"
GM:AddStartingItem("ffemitter", ""..translate.Get("worth_fieldemiter"), nil, ITEMCAT_TOOLS, 50, "weapon_zs_ffemitter").Countables = "prop_ffemitter"
local item = GM:AddStartingItem("infturret", ""..translate.Get("worth_turret"), ""..translate.Get("worth_turret2"),
	ITEMCAT_TOOLS, 65, nil, function(pl)
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
	pl:GiveAmmo(250, "smg1")
end, "models/combine_turrets/floor_turret.mdl")
item.Countables = {"weapon_zs_gunturret", "prop_gunturret"}
item.NoClassicMode = true

-----------
-- W.OTHER --
-----------

GM:AddStartingItem("stone", ""..translate.Get("worth_stone"), nil, ITEMCAT_OTHER, 0, "weapon_zs_stone")
GM:AddStartingItem("oxtank", ""..translate.Get("worth_oxygentank"), ""..translate.Get("worth_oxygentank2"), ITEMCAT_OTHER, 1, "weapon_zs_oxygentank")

-----------
-- W.TRAITS --
-----------

GM:AddStartingItem("10hp", ""..translate.Get("worth_fit"), ""..translate.Get("worth_fit2"), ITEMCAT_TRAITS, 10, nil, function(pl) pl:SetMaxHealth(pl:GetMaxHealth() + 10) pl:SetHealth(pl:Health() + 10) end, "models/healthvial.mdl")
GM:AddStartingItem("25hp", ""..translate.Get("worth_tough"), ""..translate.Get("worth_tough2"), ITEMCAT_TRAITS, 20, nil, function(pl) pl:SetMaxHealth(pl:GetMaxHealth() + 25) pl:SetHealth(pl:Health() + 25) end, "models/items/healthkit.mdl")
local item = GM:AddStartingItem("5spd", ""..translate.Get("worth_quick"), ""..translate.Get("worth_quick2"), ITEMCAT_TRAITS, 10, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 7 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
local item = GM:AddStartingItem("10spd", ""..translate.Get("worth_surged"), ""..translate.Get("worth_surged2"), ITEMCAT_TRAITS, 20, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 14 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
GM:AddStartingItem("bfsurgeon", ""..translate.Get("worth_surgeon"), ""..translate.Get("worth_surgeon2"), ITEMCAT_TRAITS, 10, nil, function(pl) pl.HumanHealMultiplier = (pl.HumanHealMultiplier or 1) + 0.3 end, "models/healthvial.mdl")
GM:AddStartingItem("bfmedicine", ""..translate.Get("worth_medicine"), ""..translate.Get("worth_medicine2"), ITEMCAT_TRAITS, 20, nil, function(pl) pl.HumanHealMultiplier = (pl.HumanHealMultiplier or 1) + 1.0 end, "models/healthvial.mdl")
GM:AddStartingItem("bfresist", ""..translate.Get("worth_resistant"), ""..translate.Get("worth_resistant2"), ITEMCAT_TRAITS, 15, nil, function(pl) pl.BuffResistant = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfregen", ""..translate.Get("worth_regen"), ""..translate.Get("worth_regen2"), ITEMCAT_TRAITS, 20, nil, function(pl) pl.BuffRegenerative = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfhandy", ""..translate.Get("worth_handy"), ""..translate.Get("worth_handy2"), ITEMCAT_TRAITS, 25, nil, function(pl) pl.HumanRepairMultiplier = (pl.HumanRepairMultiplier or 1) + 0.25 end, "models/props_c17/tools_wrench01a.mdl")
GM:AddStartingItem("bfengineer", ""..translate.Get("worth_engi"), ""..translate.Get("worth_engi2"), ITEMCAT_TRAITS, 35, nil, function(pl) pl.HumanRepairMultiplier = (pl.HumanRepairMultiplier or 1) + 0.50 end, "models/props_c17/tools_wrench01a.mdl")
GM:AddStartingItem("bfmusc", ""..translate.Get("worth_muscular"),""..translate.Get("worth_muscular2"), ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffMuscular = true pl:DoMuscularBones() end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("bfcarpenter", ""..translate.Get("worth_carpenter"), ""..translate.Get("worth_carpenter2"), ITEMCAT_TRAITS, 35, nil, function(pl) pl.Carpenter = true end, "models/weapons/w_hammer.mdl")
GM:AddStartingItem("bfcannibal", ""..translate.Get("worth_cannibal"), ""..translate.Get("worth_cannibal2"), ITEMCAT_TRAITS, 30, nil, function(pl) pl.Cannibal = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("bfcannibal", ""..translate.Get("worth_ghostmode"), ""..translate.Get("worth_ghostmode2"), ITEMCAT_TRAITS, 40, nil, function(pl) pl.GhostCade = true end, "models/healthvial.mdl")

-----------
-- W.RETURNS --
-----------

GM:AddStartingItem("dbfallergic", ""..translate.Get("worth_allergic"), ""..translate.Get("worth_allergic2"), ITEMCAT_RETURNS, -30, nil, function(pl) pl.Allergic = true end, "models/gibs/hgibs_spine.mdl")
GM:AddStartingItem("dbfpalsy", ""..translate.Get("worth_palasy"), ""..translate.Get("worth_palasy2"), ITEMCAT_RETURNS, -10, nil, function(pl) pl:SetPalsy(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfnopickup", ""..translate.Get("worth_noodlearms"), ""..translate.Get("worth_noodlearms2"), ITEMCAT_RETURNS, -15, nil, function(pl) pl.NoObjectPickup = true pl:DoNoodleArmBones() end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfhemo", ""..translate.Get("worth_hemo"), ""..translate.Get("worth_hemo2"), ITEMCAT_RETURNS, -15, nil, function(pl) pl:SetHemophilia(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfweak", ""..translate.Get("worth_weak"), ""..translate.Get("worth_weak2"), ITEMCAT_RETURNS, -20, nil, function(pl) pl:SetMaxHealth(math.max(1, pl:GetMaxHealth() - 30)) pl:SetHealth(pl:GetMaxHealth()) pl.IsWeak = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfnoghosting", ""..translate.Get("worth_wideload"), ""..translate.Get("worth_wideload2"), ITEMCAT_RETURNS, -25, nil, function(pl) pl.NoGhosting = true end, "models/gibs/HGIBS.mdl").NoClassicMode = true
GM:AddStartingItem("dbfslow", ""..translate.Get("worth_slow"), ""..translate.Get("worth_slow2"), ITEMCAT_RETURNS, -30, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 1) - 20 pl:ResetSpeed() pl.IsSlow = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfclumsy", ""..translate.Get("worth_clumsy"), ""..translate.Get("worth_clumsy2"), ITEMCAT_RETURNS, -30, nil, function(pl) pl.Clumsy = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfunluc", ""..translate.Get("worth_banlive"), ""..translate.Get("worth_banlive2"), ITEMCAT_RETURNS, -40, nil, function(pl) pl:SetUnlucky(true) end, "models/gibs/HGIBS.mdl")

------------
-- Points --
------------

------------
-- P.EXAMPLE --
------------

--[[ Below are examples what you can use for the tier system. setting "6 / 6," false at the end locks
--that item till wave 6. The boomstick below would unlock at wave 6 costing 50 points.]]--

--GM:AddPointShopItem("boomstick", ""..translate.Get("ars_boomstick"), nil, ITEMCAT_GUNS, 50, "weapon_zs_boomstick", 6 / 6, false)

------------
 -- P.GUNS --
------------

GM:AddPointShopItem("deagle", ""..translate.Get("ars_deagle"), nil, ITEMCAT_GUNS, 30, "weapon_zs_deagle")
GM:AddPointShopItem("glock3", ""..translate.Get("ars_glock"), nil, ITEMCAT_GUNS, 30, "weapon_zs_glock3")
GM:AddPointShopItem("magnum", ""..translate.Get("ars_magnum"), nil, ITEMCAT_GUNS, 35, "weapon_zs_magnum")
GM:AddPointShopItem("eraser", ""..translate.Get("ars_tacticalpistol"), nil, ITEMCAT_GUNS, 35, "weapon_zs_eraser")
GM:AddPointShopItem("uzi", ""..translate.Get("ars_uzi"), nil, ITEMCAT_GUNS, 70, "weapon_zs_uzi")
GM:AddPointShopItem("shredder", ""..translate.Get("ars_shredder"), nil, ITEMCAT_GUNS, 70, "weapon_zs_smg")
GM:AddPointShopItem("bulletstorm", ""..translate.Get("ars_bulletstorm"), nil, ITEMCAT_GUNS, 70, "weapon_zs_bulletstorm")
GM:AddPointShopItem("hunter", ""..translate.Get("ars_hunter"), nil, ITEMCAT_GUNS, 70, "weapon_zs_hunter")
GM:AddPointShopItem("reaper", ""..translate.Get("ars_reaperump"), nil, ITEMCAT_GUNS, 80, "weapon_zs_reaper")
GM:AddPointShopItem("ender", ""..translate.Get("ars_autoen"), nil, ITEMCAT_GUNS, 85, "weapon_zs_ender")
GM:AddPointShopItem("akbar", ""..translate.Get("ars_akbar"), nil, ITEMCAT_GUNS, 85, "weapon_zs_akbar")
GM:AddPointShopItem("galil", ""..translate.Get("ars_galil"), nil, ITEMCAT_GUNS, 90, "weapon_zs_galil")
GM:AddPointShopItem("python", ""..translate.Get("weapon_python"), nil, ITEMCAT_GUNS, 95, "weapon_zs_python")
GM:AddPointShopItem("silencer", ""..translate.Get("ars_silencer"), nil, ITEMCAT_GUNS, 100, "weapon_zs_silencer")
GM:AddPointShopItem("annabelle", ""..translate.Get("ars_annabele"), nil, ITEMCAT_GUNS, 100, "weapon_zs_annabelle")
GM:AddPointShopItem("g3sg1", ""..translate.Get("ars_infiltrator"), nil, ITEMCAT_GUNS, 110, "weapon_zs_g3sg1")
GM:AddPointShopItem("stalker", ""..translate.Get("ars_stalker"), nil, ITEMCAT_GUNS, 120, "weapon_zs_m4")
GM:AddPointShopItem("inferno", ""..translate.Get("ars_inferno"), nil, ITEMCAT_GUNS, 125, "weapon_zs_inferno")
GM:AddPointShopItem("crossbow", ""..translate.Get("ars_crossbow"), nil, ITEMCAT_GUNS, 140, "weapon_zs_crossbow")
GM:AddPointShopItem("sg552", ""..translate.Get("ars_eliminator"), nil, ITEMCAT_GUNS, 150, "weapon_zs_sg552")
GM:AddPointShopItem("sweeper", ""..translate.Get("ars_sweeper"), nil, ITEMCAT_GUNS, 170, "weapon_zs_sweepershotgun")
GM:AddPointShopItem("slugrifle", ""..translate.Get("ars_tiny"), nil, ITEMCAT_GUNS, 200, "weapon_zs_slugrifle")
GM:AddPointShopItem("pulserifle", ""..translate.Get("ars_adonis"), nil, ITEMCAT_GUNS, 230, "weapon_zs_pulserifle")
GM:AddPointShopItem("m249", ""..translate.Get("ars_punisher"), nil, ITEMCAT_GUNS, 230, "weapon_zs_m249")
GM:AddPointShopItem("sg550", ""..translate.Get("ars_killer"), nil, ITEMCAT_GUNS, 240, "weapon_zs_sg550")
GM:AddPointShopItem("boomstick", ""..translate.Get("ars_boomstick"), nil, ITEMCAT_GUNS, 250, "weapon_zs_boomstick")

------------
 -- P.AMMO --
------------

GM:AddPointShopItem("pistolammo", ""..translate.Get("ars_pistol_ammo"), nil, ITEMCAT_AMMO, 3, nil, 0, true, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 12, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddPointShopItem("shotgunammo", ""..translate.Get("ars_shotgun_ammo"), nil, ITEMCAT_AMMO, 4, nil, 0, true, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["buckshot"] or 8, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddPointShopItem("smgammo", ""..translate.Get("ars_smg_ammo"), nil, ITEMCAT_AMMO, 3, nil, 0, true, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["smg1"] or 30, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddPointShopItem("assaultrifleammo", ""..translate.Get("ars_assaultrifle_ammo"), nil, ITEMCAT_AMMO, 5, nil, 0, true, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["ar2"] or 30, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddPointShopItem("rifleammo", ""..translate.Get("ars_rifle_ammo"), nil, ITEMCAT_AMMO, 4, nil, 0, true, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["357"] or 6, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddPointShopItem("crossbowammo", ""..translate.Get("ars_bolt"), nil, ITEMCAT_AMMO, 2, nil, 0, true, nil, function(pl) pl:GiveAmmo(1, "XBowBolt", true) end, "models/Items/CrossbowRounds.mdl")
GM:AddPointShopItem("pulseammo", ""..translate.Get("ars_pulse_ammo"), nil, ITEMCAT_AMMO, 4, nil, 0, true, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pulse"] or 30, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
------------
-- P.MELEE --
------------

GM:AddPointShopItem("zpfryp", ""..translate.Get("worth_fryingpan"), nil, ITEMCAT_MELEE, 5, "weapon_zs_fryingpan")
GM:AddPointShopItem("zpcpot", ""..translate.Get("worth_cookingpot"), nil, ITEMCAT_MELEE, 5, "weapon_zs_pot")
GM:AddPointShopItem("knife", ""..translate.Get("worth_knife"), nil, ITEMCAT_MELEE, 5, "weapon_zs_swissarmyknife")
GM:AddPointShopItem("axe", ""..translate.Get("worth_axe"), nil, ITEMCAT_MELEE, 10, "weapon_zs_axe")
GM:AddPointShopItem("hook", ""..translate.Get("worth_meathook"), nil, ITEMCAT_MELEE, 15, "weapon_zs_hook")
GM:AddPointShopItem("crowbar", ""..translate.Get("worth_crowbar"), nil, ITEMCAT_MELEE, 15, "weapon_zs_crowbar")
GM:AddPointShopItem("stunbaton", ""..translate.Get("worth_stun"), nil, ITEMCAT_MELEE, 20, "weapon_zs_stunbaton")
GM:AddPointShopItem("shovel", ""..translate.Get("ars_shovel"), nil, ITEMCAT_MELEE, 20, "weapon_zs_shovel")
GM:AddPointShopItem("zpplnk", ""..translate.Get("worth_plank"), nil, ITEMCAT_MELEE, 20, "weapon_zs_plank")
GM:AddPointShopItem("pipe", ""..translate.Get("worth_leadpipe"), nil, ITEMCAT_MELEE, 25, "weapon_zs_pipe")
GM:AddPointShopItem("sledgehammer", ""..translate.Get("ars_sledge"), nil, ITEMCAT_MELEE, 30, "weapon_zs_sledgehammer")
GM:AddPointShopItem("katana", ""..translate.Get("weapon_katana"), nil, ITEMCAT_MELEE, 50, "weapon_zs_katana")




------------
-- P.TOOLS --
------------

GM:AddPointShopItem("nail", ""..translate.Get("ars_nail"), ""..translate.Get("ars_nail2"), ITEMCAT_TOOLS, 1, nil, 0, true, nil, function(pl) pl:GiveAmmo(1, "GaussEnergy", true) end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("wrench", ""..translate.Get("worth_wrench"), nil, ITEMCAT_TOOLS, 15, "weapon_zs_wrench").NoClassicMode = true
GM:AddPointShopItem("crphmr", ""..translate.Get("worth_hammer"), nil, ITEMCAT_TOOLS, 20, "weapon_zs_hammer").NoClassicMode = true
GM:AddPointShopItem("arsenalcrate", ""..translate.Get("worth_arsenalcrate"), nil, ITEMCAT_TOOLS, 30, "weapon_zs_arsenalcrate")
GM:AddPointShopItem("resupplybox", ""..translate.Get("worth_resupplybox"), nil, ITEMCAT_TOOLS, 35, "weapon_zs_resupplybox")
GM:AddPointShopItem("50mkit", ""..translate.Get("ars_50meds"), ""..translate.Get("ars_50meds2"), ITEMCAT_TOOLS, 25, nil, 0, true, nil, function(pl) pl:GiveAmmo(50, "Battery", true) end, "models/healthvial.mdl")
GM:AddPointShopItem("manhack", ""..translate.Get("worth_manhack"), nil, ITEMCAT_TOOLS, 30, "weapon_zs_manhack")
GM:AddPointShopItem("medkit", ""..translate.Get("worth_medkit"), nil, ITEMCAT_TOOLS, 35, "weapon_zs_medicalkit")
GM:AddPointShopItem("ffemitter", ""..translate.Get("worth_fieldemiter"), nil, ITEMCAT_TOOLS, 50, "weapon_zs_ffemitter").Countables = "prop_ffemitter"
local item = GM:AddPointShopItem("infturret", ""..translate.Get("worth_turret"), nil, ITEMCAT_TOOLS, 65, nil, 0, true, nil, function(pl)
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
	pl:GiveAmmo(250, "smg1")
end, "models/combine_turrets/floor_turret.mdl")
item.Countables = {"weapon_zs_gunturret", "prop_gunturret"}
item.NoClassicMode = true
GM:AddPointShopItem("barricadekit", ""..translate.Get("ars_aegis"), nil, ITEMCAT_TOOLS, 70, "weapon_zs_barricadekit")

------------
-- P.OTHER --
------------
GM:AddPointShopItem("pstone", ""..translate.Get("worth_stone"), nil, ITEMCAT_OTHER, 3, "weapon_zs_stone")
GM:AddPointShopItem("poxtank", ""..translate.Get("worth_oxygentank"), ""..translate.Get("worth_oxygentank2"), ITEMCAT_OTHER, 5, "weapon_zs_oxygentank")
GM:AddPointShopItem("grenade", ""..translate.Get("ars_grenade"), nil, ITEMCAT_OTHER, 200, "weapon_zs_grenade")
GM:AddPointShopItem("empower", ""..translate.Get("craft_empower"), nil, ITEMCAT_OTHER, 230, "weapon_zs_empower")
GM:AddPointShopItem("detpck", ""..translate.Get("ars_detpack"), nil, ITEMCAT_OTHER, 500, "weapon_zs_detpack")



-- These are the honorable mentions that come at the end of the round.

local function genericcallback(pl, magnitude) return pl:Name(), magnitude end
GM.HonorableMentions = {}
GM.HonorableMentions[HM_MOSTZOMBIESKILLED] = {Name = ""..translate.Get("hm_most_zombies_killed"), String = ""..translate.Get("hm_most_zombies_killed2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD] = {Name = ""..translate.Get("hm_most_dmg_undead"), String = ""..translate.Get("hm_most_dmg_undead2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_PACIFIST] = {Name = ""..translate.Get("hm_pacifist"), String = ""..translate.Get("hm_pacifist2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTHELPFUL] = {Name = ""..translate.Get("hm_most_helpful"), String = ""..translate.Get("hm_most_helpful2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_LASTHUMAN] = {Name = ""..translate.Get("hm_last_human"), String = ""..translate.Get("hm_last_human2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_OUTLANDER] = {Name = ""..translate.Get("hm_outlander"), String = ""..translate.Get("hm_outlander2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_GOODDOCTOR] = {Name = ""..translate.Get("hm_good_doctor"), String = ""..translate.Get("hm_good_doctor2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_HANDYMAN] = {Name = ""..translate.Get("hm_handy_man"), String = ""..translate.Get("hm_handy_man2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SCARECROW] = {Name = ""..translate.Get("hm_scarecrow"), String = ""..translate.Get("hm_scarecrow2"), Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTBRAINSEATEN] = {Name = ""..translate.Get("hm_most_brains_eaten"), String = ""..translate.Get("hm_most_brains_eaten2"), Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS] = {Name = ""..translate.Get("hm_most_dmg_tohumans"), String = ""..translate.Get("hm_most_dmg_tohumans2"), Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_LASTBITE] = {Name = ""..translate.Get("hm_last_bite"), String = ""..translate.Get("hm_last_bite2"), Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_USEFULTOOPPOSITE] = {Name = ""..translate.Get("hm_most_useful"), String = ""..translate.Get("hm_most_useful2"), Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_STUPID] = {Name = ""..translate.Get("hm_stupid"), String = ""..translate.Get("hm_stupid2"), Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_SALESMAN] = {Name = ""..translate.Get("hm_salesman"), String = ""..translate.Get("hm_salesman2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_WAREHOUSE] = {Name = ""..translate.Get("hm_warehouse"), String = ""..translate.Get("hm_warehouse2"), Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SPAWNPOINT] = {Name = ""..translate.Get("hm_spawn_point"), String = ""..translate.Get("hm_spawn_point2"), Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_CROWFIGHTER] = {Name = ""..translate.Get("hm_crow_fighter"), String = ""..translate.Get("hm_crow_fighter2"), Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_CROWBARRICADEDAMAGE] = {Name = ""..translate.Get("hm_minor_annoyance"), String = ""..translate.Get("hm_minor_annoyance2"), Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_BARRICADEDESTROYER] = {Name = ""..translate.Get("hm_barricade_destroyer"), String = ""..translate.Get("hm_barricade_destroyer2"), Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTDESTROYER] = {Name = ""..translate.Get("hm_nest_destroyer"), String = ""..translate.Get("hm_nest_destroyer2"), Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTMASTER] = {Name = ""..translate.Get("hm_nest_master"), String = ""..translate.Get("hm_nest_master2"), Callback = genericcallback, Color = COLOR_LIMEGREEN}

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