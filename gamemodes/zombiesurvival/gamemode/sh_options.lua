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
GM.CartFile = "zsclassiccarts.txt"

ITEMCAT_GUNS = 1
ITEMCAT_AMMO = 2
ITEMCAT_MELEE = 3
ITEMCAT_TOOLS = 4
ITEMCAT_OTHER = 5
ITEMCAT_REMODEL = 6
ITEMCAT_TRAITS = 7
ITEMCAT_RETURNS = 8

GM.ItemCategories = {
	[ITEMCAT_GUNS] = "총기류",
	[ITEMCAT_AMMO] = "탄약류",
	[ITEMCAT_MELEE] = "근접 무기",
	[ITEMCAT_TOOLS] = "도구",
	[ITEMCAT_OTHER] = "기타",
	[ITEMCAT_REMODEL] = "개조",
	[ITEMCAT_TRAITS] = "특성",
	[ITEMCAT_RETURNS] = "반환"
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
GM.AmmoCache["smg1_grenade"] = 1
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
GM.AmmoCache["rpg"] = 1
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

local isobjective
local mapname = game.GetMap()
if string.find(mapname, "_obj") or string.find(mapname, "_objective") then
	isobjective = true
else
	isobjective = false
end

GM:AddStartingItem("pshtr", "'Peashooter' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_peashooter")
GM:AddStartingItem("btlax", "'Battleaxe' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_battleaxe")
GM:AddStartingItem("owens", "'Owens' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_owens")
GM:AddStartingItem("blstr", "'Blaster' 샷건", nil, ITEMCAT_GUNS, 55, "weapon_zs_blaster")
GM:AddStartingItem("tossr", "'Tosser' SMG", nil, ITEMCAT_GUNS, 50, "weapon_zs_tosser")
GM:AddStartingItem("stbbr", "'Stubber' 소총", nil, ITEMCAT_GUNS, 55, "weapon_zs_stubber")
GM:AddStartingItem("crklr", "'Crackler' 돌격 소총", nil, ITEMCAT_GUNS, 50, "weapon_zs_crackler")
GM:AddStartingItem("z9000", "'Z9000' 펄스 권총", nil, ITEMCAT_GUNS, 50, "weapon_zs_z9000")

GM:AddStartingItem("2pcp", "3 권총 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 3, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("2sgcp", "3 샷건 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 3, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("2smgcp", "3 SMG 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 3, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("2arcp", "3 돌격 소총 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 3, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("2rcp", "3 소총 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 3, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("2pls", "3 펄스 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 3, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddStartingItem("3pcp", "5 권총 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 5, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("3sgcp", "5 샷건 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 5, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("3smgcp", "5 SMG 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 5, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("3arcp", "5 돌격 소총 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 5, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("3rcp", "5 소총 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 5, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("3pls", "5 펄스 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 5, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")

GM:AddStartingItem("zpaxe", "도끼", nil, ITEMCAT_MELEE, 30, "weapon_zs_axe")
GM:AddStartingItem("crwbar", "빠루", nil, ITEMCAT_MELEE, 30, "weapon_zs_crowbar")
GM:AddStartingItem("stnbtn", "전기 충격기", nil, ITEMCAT_MELEE, 45, "weapon_zs_stunbaton")
GM:AddStartingItem("csknf", "스위스 육군 칼", nil, ITEMCAT_MELEE, 10, "weapon_zs_swissarmyknife")
GM:AddStartingItem("zpplnk", "판자때기", nil, ITEMCAT_MELEE, 10, "weapon_zs_plank")
GM:AddStartingItem("zpfryp", "프라이팬", nil, ITEMCAT_MELEE, 20, "weapon_zs_fryingpan")
GM:AddStartingItem("zpcpot", "냄비", nil, ITEMCAT_MELEE, 20, "weapon_zs_pot")
GM:AddStartingItem("pipe", "납 파이프", nil, ITEMCAT_MELEE, 45, "weapon_zs_pipe")
GM:AddStartingItem("hook", "갈고리", nil, ITEMCAT_MELEE, 30, "weapon_zs_hook")

GM:AddStartingItem("medkit", "의료킷", nil, ITEMCAT_TOOLS, 50, "weapon_zs_medicalkit")
GM:AddStartingItem("medgun", "메딕 건", nil, ITEMCAT_TOOLS, 45, "weapon_zs_medicgun")
GM:AddStartingItem("150mkit", "150 의료킷 에너지", nil, ITEMCAT_TOOLS, 30, nil, function(pl) pl:GiveAmmo(150, "Battery", true) end, "models/healthvial.mdl")
GM:AddStartingItem("arscrate", "상점 상자", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate").Countables = "prop_arsenalcrate"
GM:AddStartingItem("resupplybox", "보급 상자", nil, ITEMCAT_TOOLS, 70, "weapon_zs_resupplybox").Countables = "prop_resupplybox"
local item = GM:AddStartingItem("infturret", "적외선 타겟팅 터렛", nil, ITEMCAT_TOOLS, 75, nil, function(pl)
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
	pl:GiveAmmo(250, "smg1")
end)
item.Countables = {"weapon_zs_gunturret", "prop_gunturret"}
item.NoClassicMode = true
local item = GM:AddStartingItem("manhack", "맨핵", nil, ITEMCAT_TOOLS, 60, "weapon_zs_manhack")
item.Countables = "prop_manhack"
GM:AddStartingItem("wrench", "메카닉 렌치", nil, ITEMCAT_TOOLS, 15, "weapon_zs_wrench").NoClassicMode = true
GM:AddStartingItem("crphmr", "목수의 망치", nil, ITEMCAT_TOOLS, 45, "weapon_zs_hammer").NoClassicMode = true
GM:AddStartingItem("6nails", "못 한 박스(12개입)", "바리케이딩에 필요한 못 한 박스.", ITEMCAT_TOOLS, 25, nil, function(pl) pl:GiveAmmo(12, "GaussEnergy", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("junkpack", "판자 더미", nil, ITEMCAT_TOOLS, 40, "weapon_zs_boardpack")
GM:AddStartingItem("spotlamp", "스팟 램프", nil, ITEMCAT_TOOLS, 25, "weapon_zs_spotlamp").Countables = "prop_spotlamp"
GM:AddStartingItem("msgbeacon", "메세지 비콘", nil, ITEMCAT_TOOLS, 10, "weapon_zs_messagebeacon").Countables = "prop_messagebeacon"
--GM:AddStartingItem("ffemitter", "Force Field Emitter", nil, ITEMCAT_TOOLS, 60, "weapon_zs_ffemitter").Countables = "prop_ffemitter"

GM:AddStartingItem("stone", "돌맹이", nil, ITEMCAT_OTHER, 5, "weapon_zs_stone")
GM:AddStartingItem("grenade", "수류탄", nil, ITEMCAT_OTHER, 30, "weapon_zs_grenade")
GM:AddStartingItem("molotov", "화염병", nil, ITEMCAT_OTHER, 15, "weapon_zs_molotov")
GM:AddStartingItem("detpck", "폭발물 패키지", nil, ITEMCAT_OTHER, 35, "weapon_zs_detpack").Countables = "prop_detpack"
GM:AddStartingItem("oxtank", "산소 탱크", "물속에서 숨쉴 수 있는 시간을 늘린다.", ITEMCAT_OTHER, 15, "weapon_zs_oxygentank")

GM:AddStartingItem("10hp", "헬스 3개월차", "HP가 10 증가해 생존에 유리해진다.", ITEMCAT_TRAITS, 10, nil, function(pl) pl:SetMaxHealth(pl:GetMaxHealth() + 10) pl:SetHealth(pl:Health() + 10) end, "models/healthvial.mdl")
GM:AddStartingItem("25hp", "헬스 트레이너", "HP가 25 증가해 생존에 유리해진다.", ITEMCAT_TRAITS, 20, nil, function(pl) pl:SetMaxHealth(pl:GetMaxHealth() + 25) pl:SetHealth(pl:Health() + 25) end, "models/items/healthkit.mdl")
local item = GM:AddStartingItem("5spd", "조기축구회원", "이동속도가 약간 증가한다.", ITEMCAT_TRAITS, 10, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 7 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
local item = GM:AddStartingItem("10spd", "육상선수", "이동속도가 상당히 증가한다.", ITEMCAT_TRAITS, 15, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 14 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
GM:AddStartingItem("bfhandy", "뛰어난 손재주", "수리시 25%가 추가로 수리된다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.HumanRepairMultiplier = (pl.HumanRepairMultiplier or 1) + 0.25 end, "models/props_c17/tools_wrench01a.mdl")
GM:AddStartingItem("bfsurgeon", "동의보감", "의료 키트의 치유량이 30%, 메딕 건의 치유량이 33% 상승한다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.HumanHealMultiplier = (pl.HumanHealMultiplier or 1) + 0.3 end, "models/healthvial.mdl")
GM:AddStartingItem("bfresist", "독 내성", "독 데미지를 절반만 받는다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffResistant = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfregen", "리제네레이터", "체력이 최대 체력의 절반 이하로 내려갈 경우 1초에 1의 체력이 회복된다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffRegenerative = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfzerg", "저그출신", "5초당 1.5의 체력이 회복된다.", ITEMCAT_TRAITS, 35, nil, function(pl) pl.buffZerg = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfmusc", "근육질", "근접 무기로 20%의 추가 데미지를 가하고 더 무거운 물건을 들 수 있게 된다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffMuscular = true pl:DoMuscularBones() end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("bfmedic", "의무병", "의료킷의 재사용 대기시간이 25% 감소한다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.buffMedic = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfbattleengineer", "전투공병", "좀비를 처치할 경우 다음 3회의 수리 효율이 20% 증가한다. (중첩 안 됨)", ITEMCAT_TRAITS, 15, nil, function(pl) pl.buffBattleEngineer = true pl.battleEngineerCount = 0 end, "models/weapons/w_hammer.mdl")
GM:AddStartingItem("bfberserk", "광전사", "체력이 20% 이하일 때 근접 무기의 공격력이 50% 증가한다.", ITEMCAT_TRAITS, 15, nil, function(pl) pl.buffBerserk = true end, "models/weapons/w_knife_ct.mdl")
GM:AddStartingItem("bfbeliefjump", "신뢰의 도약", "낙하 데미지를 25% 덜 받는다.", ITEMCAT_TRAITS, 30, nil, function(pl) pl.buffBeliefJump = true end, "models/props_junk/shoe001a.mdl")
if !isobjective then
	GM:AddStartingItem("bfrevolution", "진화론", "최대 속도의 90% 이상으로 달릴 경우 3초마다 이동속도 8이 증가한다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.buffRevolution = true pl.revolutionSpd = 0 pl.revolutionTime = 0 pl:SendLua("LocalPlayer().buffRevolution = true") end, "models/props_junk/shoe001a.mdl")
end
GM:AddStartingItem("bfblueprint", "설계도", "설치형 구조물의 회수 시간이 70% 단축된다.", ITEMCAT_TRAITS, 5, nil, function(pl) pl.buffBlueprint = true end, "models/props_lab/binderblue.mdl")
GM:AddStartingItem("bfstrong", "강인함", "근접 공격에 의한 화면 흔들림이 90% 감소하고 넉다운에 80% 저항이 생긴다.", ITEMCAT_TRAITS, 5, nil, function(pl) pl.buffStrong = true pl:SendLua("LocalPlayer().buffStrong = true") end, nil)
GM:AddStartingItem("bfsupplier", "보급병", "보급상자의 재사용 대기시간이 25% 감소한다.", ITEMCAT_TRAITS, 15, nil, function(pl) pl.buffSupplier = true end, "models/items/ammocrate_smg1.mdl")
GM:AddStartingItem("bfthornarmor", "가시갑옷", "좀비에게 피격시 공격한 좀비에게 150%의 데미지를 돌려준다.\n돌려준 데미지로는 포인트를 얻을 수 없다.", ITEMCAT_TRAITS, 30, nil, function(pl) pl.buffThornArmor = true end, "models/Items/hevsuit.mdl")
GM:AddStartingItem("bfbalsense", "균형감각", "뒤로 걷거나 옆으로 걸어도 이동속도가 느려지지 않는다.", ITEMCAT_TRAITS, 10, nil, function(pl) pl.buffBalSense = true pl:SendLua("LocalPlayer().buffBalSense = true") end, "models/props_junk/shoe001a.mdl")
GM:AddStartingItem("bfpitcher", "국민투수", "돌맹이를 포함한 물체를 던지는 힘이 100% 상승한다.\n 돌덩이의 데미지가 40% 증가한다.", ITEMCAT_TRAITS, 10, nil, function(pl) pl.buffPitcher = true end, "models/props_junk/rock001a.mdl")
GM:AddStartingItem("bfpunch", "골목대장", "주먹의 데미지가 3배 증가한다. \n운이 좋게 치명타를 꽂으면 보스 좀비는 1초, 그 외 3초동안 기절한다.", ITEMCAT_TRAITS, 10, nil, function(pl) pl.buffPunch = true end, "models/weapons/w_knife_ct.mdl")
GM:AddStartingItem("bfredeem", "최후의 발악", "체력이 0이하로 내려갈 경우 1초 동안 체력의 50%를 회복하고\n거리 500 이내의 좀비를 800의 힘으로 밀쳐낸다.", ITEMCAT_TRAITS, 30, nil, function(pl) pl.buffRedeem = true pl.buffRedeemCount = 0 end, "models/props_junk/glassjug01.mdl")
GM:AddStartingItem("bfcannibal","식인종","인간이나 좀비의 고기를 먹어 체력을 회복할 수 있다.\n메디킷, 메딕 건으로 치료 불가.\n방탄복 착용 불가.",ITEMCAT_TRAITS, 20, nil, function(pl) pl.Cannibalistic = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("bfbloodsucking", "뱀파이어", "좀비에게 가한 누적 데미지 75당 1의 체력을 회복한다.\n메디킷, 메딕 건으로 치료 불가.\n방탄복 착용 불가.", ITEMCAT_TRAITS, 30, nil, function(pl) pl.buffVampire = true end,  "models/gibs/HGIBS.mdl")
GM:AddStartingItem("bfantiphead", "독 연구원", "포이즌 헤드크랩의 공격에 눈이 멀지 않으며 지속데미지를 무시한다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.buffAntiPoisonHead = true end, "models/healthvial.mdl")

GM:AddStartingItem("dbfweak", "약골", "최대 체력이 30 낮아진다.", ITEMCAT_RETURNS, -15, nil, function(pl) pl:SetMaxHealth(math.max(1, pl:GetMaxHealth() - 30)) pl:SetHealth(pl:GetMaxHealth()) pl.IsWeak = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfslow", "느림보", "속도가 약간 낮아진다.", ITEMCAT_RETURNS, -5, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 1) - 20 pl:ResetSpeed() pl.IsSlow = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfpalsy", "수전증", "조준을 하기 힘들어진다.", ITEMCAT_RETURNS, -5, nil, function(pl) pl:SetPalsy(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfhemo", "헤모필리아", "출혈 데미지가 적용된다.", ITEMCAT_RETURNS, -15, nil, function(pl) pl:SetHemophilia(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfunluc", "도둑 낙인", "포인트 샵을 이용할 수 없다.", ITEMCAT_RETURNS, -25, nil, function(pl) pl:SetUnlucky(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfclumsy", "골다공증", "매우 쉽게 넉다운된다.", ITEMCAT_RETURNS, -25, nil, function(pl) pl.Clumsy = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfnoghosting", "뚱땡이", "프롭을 통과할 수 없게 된다.", ITEMCAT_RETURNS, -20, nil, function(pl) pl.NoGhosting = true end, "models/gibs/HGIBS.mdl").NoClassicMode = true
GM:AddStartingItem("dbfnopickup", "초 저체중", "설치된 물건을 집어들 수 없다.", ITEMCAT_RETURNS, -10, nil, function(pl) pl.NoObjectPickup = true pl:DoNoodleArmBones() end, "models/gibs/HGIBS.mdl")

------------
-- Points --
------------

GM:AddPointShopItem("deagle", "'Zombie Drill' 데저트 이글", nil, ITEMCAT_GUNS, 30, "weapon_zs_deagle")
GM:AddPointShopItem("glock3", "'Crossfire' 글록 3", nil, ITEMCAT_GUNS, 30, "weapon_zs_glock3")
GM:AddPointShopItem("magnum", "'Ricochet' 매그넘", nil, ITEMCAT_GUNS, 35, "weapon_zs_magnum")
GM:AddPointShopItem("eraser", "'Eraser' 전략 권총", nil, ITEMCAT_GUNS, 35, "weapon_zs_eraser")
GM:AddPointShopItem("shredder", "'Shredder' SMG", nil, ITEMCAT_GUNS, 55, "weapon_zs_smg")

GM:AddPointShopItem("uzi", "'Sprayer' Uzi 9mm", nil, ITEMCAT_GUNS, 70, "weapon_zs_uzi")
GM:AddPointShopItem("bulletstorm", "'Bullet Storm' SMG", nil, ITEMCAT_GUNS, 70, "weapon_zs_bulletstorm")
GM:AddPointShopItem("silencer", "'Silencer' SMG", nil, ITEMCAT_GUNS, 70, "weapon_zs_silencer")
GM:AddPointShopItem("hunter", "'Hunter' 저격 소총", nil, ITEMCAT_GUNS, 70, "weapon_zs_hunter")

GM:AddPointShopItem("reaper", "'Reaper' UMP", nil, ITEMCAT_GUNS, 80, "weapon_zs_reaper")
GM:AddPointShopItem("ender", "'Ender' 자동 샷건", nil, ITEMCAT_GUNS, 75, "weapon_zs_ender")
GM:AddPointShopItem("akbar", "'Akbar' 돌격 소총", nil, ITEMCAT_GUNS, 80, "weapon_zs_akbar")
GM:AddPointShopItem("annabelle", "'Annabelle' 소총", nil, ITEMCAT_GUNS, 100, "weapon_zs_annabelle")
GM:AddPointShopItem("immortal", "'Immortal' 권총", nil, ITEMCAT_GUNS, 110, "weapon_zs_immortal")
GM:AddPointShopItem("ppsh", "'Shpagina' SMG", nil, ITEMCAT_GUNS, 115, "weapon_zs_ppsh41")

GM:AddPointShopItem("stalker", "'Stalker' 돌격 소총", nil, ITEMCAT_GUNS, 125, "weapon_zs_m4")
GM:AddPointShopItem("inferno", "'Inferno' 돌격 소총", nil, ITEMCAT_GUNS, 135, "weapon_zs_inferno")
GM:AddPointShopItem("krieg", "'Krieg' 돌격 소총", nil, ITEMCAT_GUNS, 155, "weapon_zs_krieg")
GM:AddPointShopItem("neutrino", "'Neutrino' 펄스 LMG", nil, ITEMCAT_GUNS, 175, "weapon_zs_neutrino")
GM:AddPointShopItem("crossbow", "'Impaler' 크로스보우", nil, ITEMCAT_GUNS, 175, "weapon_zs_crossbow")
GM:AddPointShopItem("g3sg1", "'Zeus' DMR", nil, ITEMCAT_GUNS, 175, "weapon_zs_zeus")

GM:AddPointShopItem("sweeper", "'Sweeper' 샷건", nil, ITEMCAT_GUNS, 200, "weapon_zs_sweepershotgun")
GM:AddPointShopItem("boomstick", "붐스틱", nil, ITEMCAT_GUNS, 200, "weapon_zs_boomstick")
GM:AddPointShopItem("slugrifle", "'Tiny' 슬러그 라이플", nil, ITEMCAT_GUNS, 200, "weapon_zs_slugrifle")
GM:AddPointShopItem("sg550", "'Helvetica' DMR", nil, ITEMCAT_GUNS, 210, "weapon_zs_sg550")
GM:AddPointShopItem("pulserifle", "'Adonis' 펄스 라이플", nil, ITEMCAT_GUNS, 225, "weapon_zs_pulserifle")
GM:AddPointShopItem("m249", "'Chainsaw' M249", nil, ITEMCAT_GUNS, 255, "weapon_zs_m249")
GM:AddPointShopItem("rpg", "'알라봉' RPG-7", nil, ITEMCAT_GUNS, 240, "weapon_zs_rpg")
--GM:AddPointShopItem("railgun", "레일건", nil, ITEMCAT_GUNS, 240, "weapon_zs_railgun")

GM:AddPointShopItem("pistolammo", "권총 탄약 박스", nil, ITEMCAT_AMMO, 4, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 12, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddPointShopItem("shotgunammo", "샷건 탄약 박스", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["buckshot"] or 8, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddPointShopItem("smgammo", "SMG 탄약 박스", nil, ITEMCAT_AMMO, 4, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["smg1"] or 30, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddPointShopItem("assaultrifleammo", "돌격 소총 탄약 박스", nil, ITEMCAT_AMMO, 3, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["ar2"] or 30, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddPointShopItem("rifleammo", "소총 탄약 박스", nil, ITEMCAT_AMMO, 4, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["357"] or 6, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddPointShopItem("crossbowammo", "크로스보우 볼트", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(1, "XBowBolt", true) end, "models/Items/CrossbowRounds.mdl")
GM:AddPointShopItem("pulseammo", "펄스 탄약 박스", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pulse"] or 30, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddPointShopItem("m249ammo", "M249 탄약 박스", nil, ITEMCAT_AMMO, 14, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["m249"] or 150, "m249", true) end, nil)
GM:AddPointShopItem("rpgammo", "RPG-7 탄약", nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["rpg"] or 1, "rpg", true) end, nil)
--GM:AddPointShopItem("railgunammo", "열화 우라늄 탄환", nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo(1, "combinecannon", true) end, "models/props_combine/breenlight.mdl")

GM:AddPointShopItem("axe", "도끼", nil, ITEMCAT_MELEE, 20, "weapon_zs_axe")
GM:AddPointShopItem("crowbar", "빠루", nil, ITEMCAT_MELEE, 20, "weapon_zs_crowbar")
GM:AddPointShopItem("stunbaton", "스턴 막대", nil, ITEMCAT_MELEE, 25, "weapon_zs_stunbaton")
GM:AddPointShopItem("knife", "스위스 육군 칼", nil, ITEMCAT_MELEE, 5, "weapon_zs_swissarmyknife")
GM:AddPointShopItem("shovel", "삽", nil, ITEMCAT_MELEE, 30, "weapon_zs_shovel")
GM:AddPointShopItem("sledgehammer", "오함마", nil, ITEMCAT_MELEE, 30, "weapon_zs_sledgehammer")
GM:AddPointShopItem("rivet", "리벳건", nil, ITEMCAT_TOOLS, 60, "weapon_zs_nailgun")
GM:AddPointShopItem("junkpack", "판자 더미", nil, ITEMCAT_TOOLS, 95, "weapon_zs_boardpack")
GM:AddPointShopItem("crphmr", "목수의 망치", nil, ITEMCAT_TOOLS, 50, "weapon_zs_hammer").NoClassicMode = true
GM:AddPointShopItem("wrench", "메카닉 렌치", nil, ITEMCAT_TOOLS, 25, "weapon_zs_wrench").NoClassicMode = true
GM:AddPointShopItem("arsenalcrate", "상점 상자", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate")
GM:AddPointShopItem("resupplybox", "보급 상자", nil, ITEMCAT_TOOLS, 70, "weapon_zs_resupplybox")
GM:AddPointShopItem("medkit", "의료킷", nil, ITEMCAT_TOOLS, 160, "weapon_zs_medicalkit")
GM:AddPointShopItem("medcharger", "자동 치료기", nil, ITEMCAT_TOOLS, 60, "weapon_zs_mediccharger")
GM:AddPointShopItem("defenceprojectile", "트위스터", nil, ITEMCAT_TOOLS, 35, "weapon_zs_defenceprojectile")
GM:AddPointShopItem("infturret", "적외선 타겟팅 터렛", nil, ITEMCAT_TOOLS, 50, "weapon_zs_gunturret", nil).NoClassicMode = true
GM:AddPointShopItem("manhack", "맨핵", nil, ITEMCAT_TOOLS, 45, "weapon_zs_manhack")
GM:AddPointShopItem("barricadekit", "'Aegis' 바리케이드 킷", nil, ITEMCAT_TOOLS, 125, "weapon_zs_barricadekit")
GM:AddPointShopItem("nail", "못",  "못 세 개.", ITEMCAT_TOOLS, 7, nil, function(pl) pl:GiveAmmo(3, "GaussEnergy", true) end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("boards", "판자 묶음",  "판자 세 개 묶음", ITEMCAT_TOOLS, 10, nil, function(pl) pl:GiveAmmo(3, "SniperRound", true) end, "models/props_debris/wood_board06a.mdl").NoClassicMode = true
GM:AddPointShopItem("mkit50", "50 의료킷 에너지",nil, ITEMCAT_TOOLS, 30, nil, function(pl) pl:GiveAmmo(50, "Battery", true) end, "models/healthvial.mdl")

if SERVER then 
	util.AddNetworkString("shop_bodyarmor")
	function GM:setBodyArmor(pl, amount)
		pl.bodyarmor = amount
		net.Start("shop_bodyarmor")
			net.WriteFloat(amount)
		net.Send(pl)
	end
end
GM:AddPointShopItem("bodyarmor", "방탄복", "좀비 공격 피해량의 30%를 흡수해 사용자를 보호하는 방탄복. 흡수한 피해만큼 소모된다.\n방탄복은 중첩 구매되지 않는다. (구매시 다시 내구도가 100으로 채워짐)", ITEMCAT_TOOLS, 40, nil, function(pl) GAMEMODE:setBodyArmor(pl, 100) end, nil)
if CLIENT then
	net.Receive("shop_bodyarmor", function(len)
		LocalPlayer().bodyarmor = net.ReadFloat()
	end)
end

GM:AddPointShopItem("grenade", "수류탄", nil, ITEMCAT_OTHER, 60, "weapon_zs_grenade")
GM:AddPointShopItem("detpck", "폭발물 패키지", nil, ITEMCAT_OTHER, 70, "weapon_zs_detpack")

GM:AddPointShopItem("steelnail", "강철 못", "자신의 못이 박힌 바리케이드의 최대 체력이 50% 증가한다.", ITEMCAT_REMODEL, 50, nil, function(pl) pl.steelNail = true end, "models/crossbow_bolt.mdl")
GM:AddPointShopItem("carbonhammer", "신소재: 카본 망치", "망치의 공격 대기시간이 25% 줄어든다.", ITEMCAT_REMODEL, 30, nil, function(pl) pl.carbonHammer = true end, "models/weapons/w_hammer.mdl")
GM:AddPointShopItem("builderunion", "노동연합 가입", "노동연합에 가입해 바리케이드 수리 시 일정 확률로 추가 포인트를 받게 된다.", ITEMCAT_REMODEL, 25, nil, function(pl) pl.hammerunion = true end, "models/weapons/w_hammer.mdl")
GM:AddPointShopItem("steeldetector", "고철 탐지기", "망치로 바리케이드를 수리할 경우 5% 확률로 추가적인 판자나 못을 얻는다.", ITEMCAT_REMODEL, 40, nil, function(pl) pl.metalDetector = true end, "models/weapons/w_hammer.mdl")
GM:AddPointShopItem("huntercharge", "연사 트리거: Hunter", "Hunter 소총을 들고 달리기 키(기본값: SHIFT)를 누르면 차지 기능을 사용할 수 있게 된다.", ITEMCAT_REMODEL, 30, nil, function(pl) pl.hunterCharge = true end, "models/weapons/w_snip_awp.mdl")
GM:AddPointShopItem("hunteraddclip", "확장 탄창: Hunter", "Hunter 소총의 기본 탄창 수가 2가 된다.", ITEMCAT_REMODEL, 25, nil, function(pl) pl.hunterAddClip = true end, "models/weapons/w_snip_awp.mdl")
GM:AddPointShopItem("pointgravity", "포인트-그래비티", "트위스터의 중력장에 폭발 물질이 들어온다면\n그 부분의 중력을 극대화시켜 소멸시킨다.", ITEMCAT_REMODEL, 45, nil, function(pl) pl.pointGravity = true end, "models/Roller.mdl")
GM:AddPointShopItem("twisteros", "OS 탑재: 트위스터", "트위스터에 OS를 탑재해 피아 식별을 가능하게 한다.\n 이제 트위스터는 정확히 좀비의 발사체만 격추한다.", ITEMCAT_REMODEL, 20, nil, function(pl) pl.twisterOS = true end, "models/Roller.mdl")
GM:AddPointShopItem("swepperinc", "발화 탄: Sweeper", "스웨퍼의 탄환을 발화탄으로 업그레이드한다.", ITEMCAT_REMODEL, 20, nil, function(pl) pl.sweeperInc = true end, "models/weapons/w_shot_m3super90.mdl")
GM:AddPointShopItem("thorncade", "가시 철책: 바리케이드", "바리케이드에 가시 철책을 둘러 공격한 좀비에게 입은 피해의 75%를 돌려준다.", ITEMCAT_REMODEL, 35, nil, function(pl) pl.thorncade = true end, "models/props_junk/meathook001a.mdl")


-- These are the honorable mentions that come at the end of the round.

local function genericcallback(pl, magnitude) return pl:Name(), magnitude end
GM.HonorableMentions = {}
GM.HonorableMentions[HM_MOSTZOMBIESKILLED] = {Name = "좀비 학살자", String = "%s, %d마리의 좀비를 처치했습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD] = {Name = "생존자 하드캐리", String = "%s, 언데드에게 %d 데미지를 입혔습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_PACIFIST] = {Name = "평화주의자", String = "%s, 이번 라운드에 단 한 마리의 좀비도 죽이지 않았습니다!", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTHELPFUL] = {Name = "최고의 서포터", String = "%s, %d마리의 좀비 처치를 도왔습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_LASTHUMAN] = {Name = "최후의 생존자", String = "%s님이 최후의 생존자입니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_OUTLANDER] = {Name = "도망자", String = "%s, 좀비 스폰 지역에서 %d피트 떨어진 곳에서 살해당했습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_GOODDOCTOR] = {Name = "의사양반", String = "%s, 아군의 체력을 %d만큼 회복시켰습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_HANDYMAN] = {Name = "슈퍼 공돌이", String = "%s, 바리케이드를 수리하여 %d포인트를 벌었습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SCARECROW] = {Name = "까마귀 학살자", String = "%s, %d마리의 불쌍한 까마귀를 학살했습니다.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTBRAINSEATEN] = {Name = "인간 학살자", String = "%s, %d개의 뇌를 먹어치웠습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS] = {Name = "좀비 하드캐리", String = "%s, 생존자 그룹에 총 %d데미지를 입혔습니다!", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_LASTBITE] = {Name = "종결자", String = "%s, 최후의 인간을 먹어치워 이번 라운드를 끝냈습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_USEFULTOOPPOSITE] = {Name = "트롤", String = "%s, 무려 %d킬을 내줬습니다!", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_STUPID] = {Name = "멍청이", String = "%s, 좀비 스폰 지점에서 겨우 %d피트 떨어진 곳에서 사망했습니다.", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_SALESMAN] = {Name = "세일즈맨", String = "%s, 자신의 무기 상자로 %d포인트를 벌어들였습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_WAREHOUSE] = {Name = "보급창고", String = "%s님의 보급 상자가 %d번 사용되었습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SPAWNPOINT] = {Name = "살아있는 스폰지점", String = "%s, %d마리의 좀비를 스폰시켰습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_CROWFIGHTER] = {Name = "성깔있는 까마귀", String = "%s, 동족을 %d마리나 학살했습니다.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_CROWBARRICADEDAMAGE] = {Name = "알 수 없는 결함", String = "%s, 까마귀로 바리케이드에 %d 데미지를 입혔습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_BARRICADEDESTROYER] = {Name = "바리케이드 파괴자", String = "%s, 바리케이드에 %d 데미지를 입혔습니다!", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTDESTROYER] = {Name = "둥지 파괴자", String = "%s, %d개의 둥지를 파괴했습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTMASTER] = {Name = "제비집", String = "%s, %d마리의 좀비를 자신의 둥지에서 스폰시켰습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}

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

GM.TimeLimit = CreateConVar("zs_timelimit", "30", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Time in minutes before the game will change maps. It will not change maps if a round is currently in progress but after the current round ends. -1 means never switch maps. 0 means always switch maps."):GetInt() * 60
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
GM.EndGameTime = 30

-- How many clips of ammo guns from the Worth menu start with. Some guns such as shotguns and sniper rifles have multipliers on this.
GM.SurvivalClips = 2

-- Put your unoriginal, 5MB Rob Zombie and Metallica music here.
GM.LastHumanSound = Sound("zombiesurvival/surften1.ogg")

-- Sound played when humans all die.
GM.AllLoseSound = Sound("zombiesurvival/music_sadv.ogg")

-- Sound played when humans survive.
GM.HumanWinSound = Sound("zombiesurvival/music_qethics1.ogg")

-- Sound played to a person when they die as a human.
GM.DeathSound = Sound("music/stingers/HL1_stinger_song28.mp3")
