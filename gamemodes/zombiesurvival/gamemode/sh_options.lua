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
	[ITEMCAT_GUNS] = "총기류",
	[ITEMCAT_AMMO] = "탄약",
	[ITEMCAT_MELEE] = "근접무기",
	[ITEMCAT_TOOLS] = "도구",
	[ITEMCAT_OTHER] = "기타",
	[ITEMCAT_TRAITS] = "퍼크",
	[ITEMCAT_RETURNS] = "리턴"
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
GM.AmmoCache["357"] = 10 -- Rifles, especially of the sniper variety.
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
GM.AmmoCache["gravity"] = 200 -- m249.
GM.AmmoCache["battery"] = 30 -- Used with the Medical Kit.
GM.AmmoCache["gaussenergy"] = 1 -- Nails used with the Carpenter's Hammer.
GM.AmmoCache["combinecannon"] = 1 -- Railgun.
GM.AmmoCache["airboatgun"] = 1 -- Arsenal crates.
GM.AmmoCache["striderminigun"] = 1 -- Message beacons.
GM.AmmoCache["helicoptergun"] = 1 --Resupply boxes.
GM.AmmoCache["spotlamp"] = 1
GM.AmmoCache["manhack"] = 1
GM.AmmoCache["charger"] = 1
GM.AmmoCache["pulse"] = 30

-- These ammo types are available at ammunition boxes.
-- The amount is the ammo to give them.
-- If the player isn't holding a weapon that uses one of these then they will get smg1 ammo.
GM.AmmoResupply = {}
GM.AmmoResupply["ar2"] = 30
GM.AmmoResupply["alyxgun"] = GM.AmmoCache["alyxgun"]
GM.AmmoResupply["pistol"] = GM.AmmoCache["pistol"]
GM.AmmoResupply["smg1"] = 30
GM.AmmoResupply["357"] = GM.AmmoCache["357"]
GM.AmmoResupply["xbowbolt"] = GM.AmmoCache["xbowbolt"]
GM.AmmoResupply["buckshot"] = GM.AmmoCache["buckshot"]
GM.AmmoResupply["battery"] = 50
GM.AmmoResupply["pulse"] = GM.AmmoCache["pulse"]
GM.AmmoResupply["gravity"] = GM.AmmoCache["gravity"]
GM.AmmoResupply["combinecannon"] = GM.AmmoCache["combinecannon"]
-----------
-- Worth --
-----------

GM:AddStartingItem("pshtr", "'피슈터' 헨드건", nil, ITEMCAT_GUNS, 40, "weapon_zs_peashooter")
GM:AddStartingItem("btlax", "'배틀엑스' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_battleaxe")
GM:AddStartingItem("owens", "'오웬' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_owens")
GM:AddStartingItem("blstr", "'블래스터' 산탄총", nil, ITEMCAT_GUNS, 55, "weapon_zs_blaster")
GM:AddStartingItem("tossr", "'토저' SMG", nil, ITEMCAT_GUNS, 50, "weapon_zs_tosser")
GM:AddStartingItem("stbbr", "'슈레더' 소총", nil, ITEMCAT_GUNS, 55, "weapon_zs_stubber")
GM:AddStartingItem("crklr", "'크래클러' 돌격소총", nil, ITEMCAT_GUNS, 50, "weapon_zs_crackler")
GM:AddStartingItem("z9000", "'Z9000' 펄스 권총", nil, ITEMCAT_GUNS, 50, "weapon_zs_z9000")

GM:AddStartingItem("2pcp", "36 권총 탄약", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 3, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("2sgcp", "24 산탄총 탄약", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 3, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("2smgcp", "90 SMG 탄약", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 3, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("2arcp", "90 돌격소총 탄약", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 3, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("2rcp", "18 소총 탄약", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 3, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("2pls", "90 펄스 탄약", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 3, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddStartingItem("3pcp", "60 권총 탄약", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 5, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("3sgcp", "40 산탄총 탄약", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 5, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("3smgcp", "150 SMG 탄약", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 5, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("3arcp", "150 돌격소총 탄약", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 5, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("3rcp", "30 소총 탄약", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 5, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("3pls", "150 펄스 탄약", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 5, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")

GM:AddStartingItem("zpaxe", "도끼", nil, ITEMCAT_MELEE, 30, "weapon_zs_axe")
GM:AddStartingItem("crwbar", "행성파괴무기(빠루)", nil, ITEMCAT_MELEE, 30, "weapon_zs_crowbar")
GM:AddStartingItem("stnbtn", "스턴 막대", nil, ITEMCAT_MELEE, 45, "weapon_zs_stunbaton")
GM:AddStartingItem("csknf", "칼", nil, ITEMCAT_MELEE, 10, "weapon_zs_swissarmyknife")
GM:AddStartingItem("zpplnk", "판자", nil, ITEMCAT_MELEE, 10, "weapon_zs_plank")
GM:AddStartingItem("zpfryp", "후라이 펜", nil, ITEMCAT_MELEE, 20, "weapon_zs_fryingpan")
GM:AddStartingItem("zpcpot", "냄비", nil, ITEMCAT_MELEE, 20, "weapon_zs_pot")
GM:AddStartingItem("pipe", "쇠파이프", nil, ITEMCAT_MELEE, 45, "weapon_zs_pipe")
GM:AddStartingItem("hook", "갈고리", nil, ITEMCAT_MELEE, 30, "weapon_zs_hook")

GM:AddStartingItem("medickit", "메딕킷", nil, ITEMCAT_TOOLS, 50, "weapon_zs_medicalkit")
GM:AddStartingItem("medicgun", "메딕건", nil, ITEMCAT_TOOLS, 45, "weapon_zs_medicgun")
GM:AddStartingItem("150mkit", "의료에너지 x150", "150 extra power for the Medical Kit.", ITEMCAT_TOOLS, 30, nil, function(pl) pl:GiveAmmo(150, "Battery", true) end, "models/healthvial.mdl")
GM:AddStartingItem("arscrate", "상점 상자", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate").Countables = "prop_arsenalcrate"
GM:AddStartingItem("resupplybox", "보급 상자", nil, ITEMCAT_TOOLS, 70, "weapon_zs_resupplybox").Countables = "prop_resupplybox"
local item = GM:AddStartingItem("infturret", "자동 설치형 터렛", nil, ITEMCAT_TOOLS, 75, "weapon_zs_gunturret")
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
	pl:GiveAmmo(250, "smg1")
end)
item.Countables = {"weapon_zs_gunturret", "prop_gunturret"}
item.NoClassicMode = true
local item = GM:AddStartingItem("manhack", "맨핵", nil, ITEMCAT_TOOLS, 60, "weapon_zs_manhack")
item.Countables = "prop_manhack"
GM:AddStartingItem("wrench", "공돌이의 렌치", nil, ITEMCAT_TOOLS, 15, "weapon_zs_wrench").NoClassicMode = true
GM:AddStartingItem("crphmr", "목수의 망치", nil, ITEMCAT_TOOLS, 45, "weapon_zs_hammer").NoClassicMode = true
GM:AddStartingItem("6nails", "못 상자 (12개입)", "An extra box of nails for all your barricading needs.", ITEMCAT_TOOLS, 25, nil, function(pl) pl:GiveAmmo(12, "GaussEnergy", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("junkpack", "판자", nil, ITEMCAT_TOOLS, 40, "weapon_zs_boardpack")
GM:AddStartingItem("spotlamp", "설치형 램프", nil, ITEMCAT_TOOLS, 25, "weapon_zs_spotlamp").Countables = "prop_spotlamp"
GM:AddStartingItem("msgbeacon", "메세지 비컨", nil, ITEMCAT_TOOLS, 10, "weapon_zs_messagebeacon").Countables = "prop_messagebeacon"
--GM:AddStartingItem("ffemitter", "Force Field Emitter", nil, ITEMCAT_TOOLS, 60, "weapon_zs_ffemitter").Countables = "prop_ffemitter"

GM:AddStartingItem("stone", "짱돌", nil, ITEMCAT_OTHER, 5, "weapon_zs_stone")
GM:AddStartingItem("grenade", "수류탄", nil, ITEMCAT_OTHER, 30, "weapon_zs_grenade")
GM:AddStartingItem("detpck", "C4", nil, ITEMCAT_OTHER, 35, "weapon_zs_detpack").Countables = "prop_detpack"
GM:AddStartingItem("oxtank", "산소통", "물 속에서 살아남을 수 있는 시간을 증가시킨다.", ITEMCAT_OTHER, 15, "weapon_zs_oxygentank")

GM:AddStartingItem("10hp", "맷집", "체력을 10 증가시킨다.", ITEMCAT_TRAITS, 10, nil, function(pl) if SERVER then pl:SetMaxHealth(pl:GetMaxHealth() + 10) pl:SetHealth(pl:GetMaxHealth()) end end, "models/healthvial.mdl")
GM:AddStartingItem("25hp", "모르핀 성애자", "체력을 25 증가시킨다.", ITEMCAT_TRAITS, 20, nil, function(pl) if SERVER then pl:SetMaxHealth(pl:GetMaxHealth() + 25) pl:SetHealth(pl:GetMaxHealth()) end end, "models/items/healthkit.mdl")
local item = GM:AddStartingItem("5spd", "체대 출신", "이동 속도를 약간 증가시킨다.", ITEMCAT_TRAITS, 10, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 7 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
local item = GM:AddStartingItem("10spd", "육상선수", "이동 속도를 증가시킨다.", ITEMCAT_TRAITS, 15, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 14 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
GM:AddStartingItem("bfhandy", "공돌이", "수리 시 수리량을 25% 증가시킨다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.HumanRepairMultiplier = (pl.HumanRepairMultiplier or 1) + 0.25 end, "models/props_c17/tools_wrench01a.mdl")
GM:AddStartingItem("bfsurgeon", "의대 출신", "자신이 소유하는 의료기기의 모든 회복량을 30% 증가시킨다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.HumanHealMultiplier = (pl.HumanHealMultiplier or 1) + 0.3 end, "models/healthvial.mdl")
GM:AddStartingItem("bfresist", "항체", "독 데미지가 더욱 빨리 회복된다.", ITEMCAT_TRAITS, 20, nil, function(pl) pl.BuffResistant = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfregen", "리제네레이터", "체력이 4초에 1씩 회복된다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffRegenerative = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfmusc", "근육돼지", "무거운 물체도 들어 나를 수 있다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffMuscular = true if SERVER then pl:DoMuscularBones() end end, "models/props_c17/FurnitureCouch001a.mdl")
GM:AddStartingItem("bfback", "뒷걸음질", "뒤로 움직여도 이동속도가 저하되지 않는다.", ITEMCAT_TRAITS, 20, nil, function(pl) pl.CoB = true end, "models/props_junk/shoe001a.mdl")
GM:AddStartingItem("bfnimble", "순발력", "바리게이트를 통과할 때 더 빠르게 통과할 수 있다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.Nimb = true end, "models/props_junk/shoe001a.mdl").NoClassicMode = true
GM:AddStartingItem("bfantiphead", "독 연구원", "포이즌 헤드크랩의 공격에 눈이 멀지 않으며 지속데미지를 무시한다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.AntiPoisonHead = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfcannibal", "식인종", "바닥에 떨어진 고기를 먹어 체력을 회복할 수 있다.", ITEMCAT_TRAITS, 40, nil, function(pl) pl.Cannibalistic = true end, "models/props_lab/cleaver.mdl")

GM:AddStartingItem("dbfweak", "약골", "최대 체력이 30 줄어든다.", ITEMCAT_RETURNS, -15, nil, function(pl) if SERVER then pl:SetMaxHealth(math.max(1, pl:GetMaxHealth() - 30)) pl:SetHealth(pl:GetMaxHealth()) end pl.IsWeak = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfslow", "느림보", "최대 속도가 줄어든다.", ITEMCAT_RETURNS, -10, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) - 20 pl:ResetSpeed() pl.IsSlow = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfpalsy", "수전증", "정확히 조준할 수 없게 된다.", ITEMCAT_RETURNS, -5, nil, function(pl) if SERVER then pl:SetPalsy(true) end end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfhemo", "헤모필리아", "다칠 경우 출혈로 데미지를 더 입는다.", ITEMCAT_RETURNS, -15, nil, function(pl) if SERVER then pl:SetHemophilia(true) end end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfunluc", "거지", "상점 상자에서 아무것도 구매할 수 없다.", ITEMCAT_RETURNS, -25, nil, function(pl) if SERVER then pl:SetUnlucky(true) end end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfclumsy", "골다공증", "매우 쉽게 넉다운된다.", ITEMCAT_RETURNS, -25, nil, function(pl) pl.Clumsy = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfnoghosting", "뚱땡이", "바리케이드를 통과해 지나갈 수 없다.", ITEMCAT_RETURNS, -20, nil, function(pl) pl.NoGhosting = true end, "models/gibs/HGIBS.mdl").NoClassicMode = true
GM:AddStartingItem("dbfnopickup", "팔 장애", "물체를 회수할 수 없다.", ITEMCAT_RETURNS, -10, nil, function(pl) pl.NoObjectPickup = true if SERVER then pl:DoNoodleArmBones() end end, "models/gibs/HGIBS.mdl")

------------
-- Points --
------------

GM:AddPointShopItem("deagle", "'좀비 드릴' 데저트 이글", nil, ITEMCAT_GUNS, 30, "weapon_zs_deagle")
GM:AddPointShopItem("glock3", "'크로스파이어' 개조형 글록", nil, ITEMCAT_GUNS, 30, "weapon_zs_glock3")
GM:AddPointShopItem("magnum", "'리코세' 매그넘", nil, ITEMCAT_GUNS, 35, "weapon_zs_magnum")
GM:AddPointShopItem("eraser", "'이레이저' 전략 권총", nil, ITEMCAT_GUNS, 35, "weapon_zs_eraser")

GM:AddPointShopItem("shredder", "'슈레더' SMG", nil, ITEMCAT_GUNS, 55, "weapon_zs_smg")
GM:AddPointShopItem("uzi", "'스프레이어' Uzi 9mm", nil, ITEMCAT_GUNS, 70, "weapon_zs_uzi")
GM:AddPointShopItem("bulletstorm", "'불릿 스톰' SMG", nil, ITEMCAT_GUNS, 70, "weapon_zs_bulletstorm")
GM:AddPointShopItem("hunter", "'헌터' 소총", nil, ITEMCAT_GUNS, 70, "weapon_zs_hunter")

GM:AddPointShopItem("reaper", "'리퍼' UMP", nil, ITEMCAT_GUNS, 80, "weapon_zs_reaper")
GM:AddPointShopItem("ender", "'엔더' 자동 샷건", nil, ITEMCAT_GUNS, 80, "weapon_zs_ender")
GM:AddPointShopItem("akbar", "'아크바' 돌격소총", nil, ITEMCAT_GUNS, 80, "weapon_zs_akbar")

GM:AddPointShopItem("annabelle", "'애나멜' 소총", nil, ITEMCAT_GUNS, 100, "weapon_zs_annabelle")
GM:AddPointShopItem("silencer", "'사일렌서' SMG", nil, ITEMCAT_GUNS, 100, "weapon_zs_silencer")
GM:AddPointShopItem("immortal", "'불멸' 권총", nil, ITEMCAT_GUNS, 110, "weapon_zs_immortal")
GM:AddPointShopItem("ppsh", "'파파샤' SMG", nil, ITEMCAT_GUNS, 115, "weapon_zs_ppsh41")
GM:AddPointShopItem("stalker", "'스토커' M4", nil, ITEMCAT_GUNS, 125, "weapon_zs_m4")
GM:AddPointShopItem("inferno", "'인페르노' AUG", nil, ITEMCAT_GUNS, 125, "weapon_zs_inferno")

GM:AddPointShopItem("krieg", "'크리그' SG552", nil, ITEMCAT_GUNS, 150, "weapon_zs_krieg")
GM:AddPointShopItem("pulseboomstick", "'오버차지' 펄스 방출기", nil, ITEMCAT_GUNS, 160, "weapon_zs_pulseboomstick")
GM:AddPointShopItem("crossbow", "'임펠러' 석궁", nil, ITEMCAT_GUNS, 175, "weapon_zs_crossbow")
GM:AddPointShopItem("neutrino", "'뉴트리노' 펄스 LMG", nil, ITEMCAT_GUNS, 175, "weapon_zs_neutrino")
GM:AddPointShopItem("sweeper", "'스위퍼' 샷건", nil, ITEMCAT_GUNS, 180, "weapon_zs_sweepershotgun")
GM:AddPointShopItem("zeus", "'제우스' 자동소총", nil, ITEMCAT_GUNS, 180, "weapon_zs_zeus")

GM:AddPointShopItem("slugrifle", "'티니' 슬러그 소총", nil, ITEMCAT_GUNS, 200, "weapon_zs_slugrifle")
GM:AddPointShopItem("boomstick", "붐스틱", nil, ITEMCAT_GUNS, 200, "weapon_zs_boomstick")
GM:AddPointShopItem("m249", "'헤비레인' M249", nil, ITEMCAT_GUNS, 210, "weapon_zs_m249")
GM:AddPointShopItem("pulserifle", "'아도니스' 펄스 소총", nil, ITEMCAT_GUNS, 235, "weapon_zs_pulserifle")
GM:AddPointShopItem("railgun", "실험용 가우스 레일건", nil, ITEMCAT_GUNS, 240, "weapon_zs_railgun")

GM:AddPointShopItem("pistolammo", "권총 탄약", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 12, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddPointShopItem("shotgunammo", "샷건 탄약", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["buckshot"] or 8, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddPointShopItem("smgammo", "SMG 탄약", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["smg1"] or 30, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddPointShopItem("assaultrifleammo", "돌격소총 탄약", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["ar2"] or 30, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddPointShopItem("rifleammo", "소총 탄약", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["357"] or 10, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddPointShopItem("crossbowammo", "크로스보우 화살 묶음", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(5, "XBowBolt", true) end, "models/Items/CrossbowRounds.mdl")
GM:AddPointShopItem("pulseammo", "펄스건 탄약", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pulse"] or 40, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddPointShopItem("m249ammo", "m249 탄약 박스", nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["gravity"] or 400, "gravity", true) end, "models/props_junk/cardboard_box004a.mdl")
GM:AddPointShopItem("railgunammo", "우라늄 탄환 1발", nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo(1, "combinecannon", true) end, "models/props_combine/breenlight.mdl")

GM:AddPointShopItem("axe", "도끼", nil, ITEMCAT_MELEE, 20, "weapon_zs_axe")
GM:AddPointShopItem("crowbar", "빠루", nil, ITEMCAT_MELEE, 20, "weapon_zs_crowbar")
GM:AddPointShopItem("stunbaton", "스턴 막대", nil, ITEMCAT_MELEE, 25, "weapon_zs_stunbaton")
GM:AddPointShopItem("knife", "칼", nil, ITEMCAT_MELEE, 5, "weapon_zs_swissarmyknife")
GM:AddPointShopItem("shovel", "삽", nil, ITEMCAT_MELEE, 30, "weapon_zs_shovel")
GM:AddPointShopItem("sledgehammer", "오함마", nil, ITEMCAT_MELEE, 30, "weapon_zs_sledgehammer")

GM:AddPointShopItem("crphmr", "목수의 망치", nil, ITEMCAT_TOOLS, 50, "weapon_zs_hammer").NoClassicMode = true
--GM:AddPointShopItem("crphmrspr", "대목장의 전동 드라이버", nil, ITEMCAT_TOOLS, 160, "weapon_zs_superhammer").NoClassicMode = true
GM:AddPointShopItem("wrench", "메카닉의 렌치", nil, ITEMCAT_TOOLS, 25, "weapon_zs_wrench").NoClassicMode = true
GM:AddPointShopItem("arsenalcrate", "상점상자", nil, ITEMCAT_TOOLS, 30, "weapon_zs_arsenalcrate")
GM:AddPointShopItem("resupplybox", "탄약보급 상자", nil, ITEMCAT_TOOLS, 50, "weapon_zs_resupplybox")
GM:AddPointShopItem("medicalcharger", "자동 치료기", nil, ITEMCAT_TOOLS, 120, "weapon_zs_mediccharger")
GM:AddPointShopItem("infturret", "센트리 터렛", nil, ITEMCAT_TOOLS, 50, "weapon_zs_gunturret").NoClassicMode = true
GM:AddPointShopItem("manhack", "맨헥", nil, ITEMCAT_TOOLS, 45, "weapon_zs_manhack")
GM:AddPointShopItem("barricadekit", "'이지스 바리케이드 키트", nil, ITEMCAT_TOOLS, 170, "weapon_zs_barricadekit")
GM:AddPointShopItem("nail", "못", "못이다.", ITEMCAT_TOOLS, 3, nil, function(pl) pl:GiveAmmo(1, "GaussEnergy", true) end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("10mkit", "10 메딕킷 에너지", "", ITEMCAT_TOOLS, 8, nil, function(pl) pl:GiveAmmo(10, "Battery", true) end, "models/healthvial.mdl")
GM:AddPointShopItem("plank", "판자 한 개","판자 한 개", ITEMCAT_TOOLS, 7, nil, function(pl) pl:GiveAmmo(1, "sniperround", true) end, "models/props_debris/wood_board06a.mdl").NoClassicMode = true
GM:AddPointShopItem("grenade", "슈류탄", nil, ITEMCAT_OTHER, 60, "weapon_zs_grenade")
GM:AddPointShopItem("detpck", "C4", nil, ITEMCAT_OTHER, 70, "weapon_zs_detpack")
GM:AddPointShopItem("fhammer", "망치 업그레이드", "목수의 망치 종류의 휘두르는 속도가 감소한다.", ITEMCAT_OTHER, 30, nil, function(pl) pl:SetFastHammer(true) end, "models/weapons/w_hammer.mdl").NoClassicMode = true
GM:AddPointShopItem("builderunion", "노동연합 가입", "노동연합의 가입자는 망치로 바리케이드를 수리할 경우 일정 확률로 추가 포인트를 얻는다.", ITEMCAT_OTHER, 40, nil, function(pl) pl.hammerunion = true end, "models/weapons/w_hammer.mdl").NoClassicMode = true

-- These are the honorable mentions that come at the end of the round.

local function genericcallback(pl, magnitude) return pl:Name(), magnitude end
GM.HonorableMentions = {}
GM.HonorableMentions[HM_MOSTZOMBIESKILLED] = {Name = "좀비 학살자", String = "%s님께서 %d마리의 좀비를 학살하셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD] = {Name = "깡패", String = "%s님께서 좀비에게 %d 데미지를 입히셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_PACIFIST] = {Name = "평화주의자", String = "%s님께서 살아있는 동안 단 한 마리의 좀비도 죽이지 않으셨습니다!", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTHELPFUL] = {Name = "조력자", String = "%s님께서 좀비 %d마리의 사살을 도우셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_LASTHUMAN] = {Name = "최후의 생존자", String = "%s님께서 인간 최후의 생존자셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_OUTLANDER] = {Name = "외지인", String = "%s님이 좀비 스폰 지역에서 %d피트 떨어진 곳에서 사망하셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_GOODDOCTOR] = {Name = "의무병", String = "%s님께서 동료의 체력을 %d만큼 회복시키셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_HANDYMAN] = {Name = "슈퍼 공돌이", String = "%s님께서 바리케이드를 %d만큼 수리하셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SCARECROW] = {Name = "까마귀 학살자", String = "%s님께서 %d마리의 불쌍한 까마귀를 학살하셨습니다.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTBRAINSEATEN] = {Name = "잔혹한 학살자", String = "%s님께서 %d명의 뇌를 먹어치웠습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS] = {Name = "네임드", String = "%s님께서 인간에게 %d 데미지를 입히셨습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_LASTBITE] = {Name = "종족 말살", String = "%s님께서 최후의 인간을 죽이셨습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_USEFULTOOPPOSITE] = {Name = "저승사자의 친구", String = "%s님께서 %d번 학살당했습니다.", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_STUPID] = {Name = "어리버리", String = "%s님은 좀비 스폰 지역에서 단지 %d피트 떨어진 곳에서 사망하셨습니다.", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_SALESMAN] = {Name = "판매원", String = "인간이 %s님의 상점상자에 %d포인트를 지불했습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_WAREHOUSE] = {Name = "보급창고", String = "%s님의 보급 상자가 %d회 사용되었습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SPAWNPOINT] = {Name = "소환사", String = "%s님께 %d마리의 좀비가 스폰되었습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_CROWFIGHTER] = {Name = "까마귀 파이터", String = "%s님께서 %d마리의 까마귀를 전멸시키셨습니다.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_CROWBARRICADEDAMAGE] = {Name = "영리한 까마귀", String = "%s님께서 까마귀가 되어 바리케이드에 %d 데미지를 입히셨습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_BARRICADEDESTROYER] = {Name = "바리케이드 디스트로이어", String = "%s님께서 바리케이드에 %d 데미지를 입히셨습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTDESTROYER] = {Name = "둥지 파괴자", String = "%s님께서 %d개의 둥지를 파괴했습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTMASTER] = {Name = "둥지 마스터", String = "%s님의 둥지를 통해 %d마리의 좀비가 스폰했습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
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
GM.ZombieSpeedMultiplier = math.ceil(100 * CreateConVar("zs_zombiespeedmultiplier", "1.1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Zombie running speed will be scaled by this value."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_zombiespeedmultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieSpeedMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

-- This is a resistance, not for claw damage. 0.5 will make zombies take half damage, 0.25 makes them take 1/4, etc.
GM.ZombieDamageMultiplier = math.ceil(100 * CreateConVar("zs_zombiedamagemultiplier", "0.75", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Scales the amount of damage that zombies take. Use higher values for easy zombies, lower for harder."):GetFloat()) * 0.01
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
GM.WaveZeroLength = 180

-- Time humans have between waves to do stuff without NEW zombies spawning. Any dead zombies will be in spectator (crow) view and any living ones will still be living.
GM.WaveIntermissionLength = 90

-- For Classic Mode
GM.WaveIntermissionLengthClassic = 20

-- Time in seconds between end round and next map.
GM.EndGameTime = 50

-- How many clips of ammo guns from the Worth menu start with. Some guns such as shotguns and sniper rifles have multipliers on this.
GM.SurvivalClips = 2

-- Put your unoriginal, 5MB Rob Zombie and Metallica music here.
GM.LastHumanSound = Sound("zombiesurvival/lasthumansector.ogg")

-- Sound played when humans all die.
GM.AllLoseSound = Sound("zombiesurvival/music_sadv.ogg")

-- Sound played when humans survive.
GM.HumanWinSound = Sound("zombiesurvival/music_qethics1.ogg")

-- Sound played to a person when they die as a human.
GM.DeathSound = Sound("music/stingers/HL1_stinger_song28.mp3")
