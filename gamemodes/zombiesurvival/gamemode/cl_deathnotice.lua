if not killicon.GetFont then
	killicon.OldAddFont = killicon.AddFont
	killicon.OldAddAlias = killicon.AddAlias
	killicon.OldAdd = killicon.Add

	local storedfonts = {}
	local storedicons = {}

	function killicon.AddFont(sClass, sFont, sLetter, cColor)
		storedfonts[sClass] = {sFont, sLetter, cColor}
		return killicon.OldAddFont(sClass, sFont, sLetter, cColor)
	end

	function killicon.Add(sClass, sTexture, cColor)
		storedicons[sClass] = {sTexture, cColor}
		return killicon.OldAdd(sClass, sTexture, cColor)
	end

	function killicon.AddAlias(sClass, sBaseClass)
		if storedfonts[sClass] then
			return killicon.AddFont(sBaseClass, storedfonts[sClass][1], storedfonts[sClass][2], storedfonts[sClass][3])
		elseif storedicons[sClass] then
			return killicon.Add(sBaseClass, storedicons[sClass][1], storedicons[sClass][2])
		end
	end

	function killicon.Get(sClass)
		return killicon.GetFont(sClass) or killicon.GetIcon(sClass)
	end

	function killicon.GetFont(sClass)
		return storedfonts[sClass]
	end

	function killicon.GetIcon(sClass)
		return storedicons[sClass]
	end
end

killicon.AddFont("default", "zsdeathnoticecs", "C", color_white)
killicon.AddFont("suicide", "zsdeathnoticecs", "C", color_white)
killicon.AddFont("player", "zsdeathnoticecs", "C", color_white)
killicon.AddFont("worldspawn", "zsdeathnoticecs", "C", color_white)
killicon.AddFont("func_move_linear", "zsdeathnoticecs", "C", color_white)
killicon.AddFont("func_rotating", "zsdeathnoticecs", "C", color_white)
killicon.AddFont("trigger_hurt", "zsdeathnoticecs", "C", color_white)

killicon.AddFont("prop_physics", "zsdeathnotice", "9", color_white)
killicon.AddFont("prop_physics_multiplayer", "zsdeathnotice", "9", color_white)
killicon.AddFont("func_physbox", "zsdeathnotice", "9", color_white)
killicon.AddFont("weapon_smg1", "zsdeathnotice", "/", color_white)
killicon.AddFont("weapon_357", "zsdeathnotice", ".", color_white)
killicon.AddFont("weapon_ar2", "zsdeathnotice", "2", color_white)
killicon.AddFont("crossbow_bolt", "zsdeathnotice", "1", color_white)
killicon.AddFont("weapon_shotgun", "zsdeathnotice", "0", color_white)
killicon.AddFont("rpg_missile", "zsdeathnotice", "3", color_white)
killicon.AddFont("npc_grenade_frag", "zsdeathnotice", "4", color_white)
killicon.AddFont("weapon_pistol", "zsdeathnotice", "-", color_white)
killicon.AddFont("prop_combine_ball", "zsdeathnotice", "8", color_white)
killicon.AddFont("grenade_ar2", "zsdeathnotice", "7", color_white)
killicon.AddFont("weapon_stunstick", "zsdeathnotice", "!", color_white)
killicon.AddFont("weapon_slam", "zsdeathnotice", "*", color_white)
killicon.AddFont("weapon_crowbar", "zsdeathnotice", "6", color_white)

killicon.AddFont("headshot", "zsdeathnoticecs", "D", color_white)
killicon.Add("redeem", "killicon/redeem_v2", color_white)

killicon.Add("weapon_zs_zombie", "zombiesurvival/killicons/zombie", color_white)
killicon.Add("weapon_zs_freshdead", "zombiesurvival/killicons/zombie", color_white)
killicon.Add("weapon_zs_classiczombie", "zombiesurvival/killicons/zombie", color_white)
killicon.Add("weapon_zs_superzombie", "zombiesurvival/killicons/zombie", color_white)
killicon.Add("weapon_zs_zombietorso", "zombiesurvival/killicons/torso", color_white)
killicon.Add("weapon_zs_zombielegs", "zombiesurvival/killicons/legs", color_white)
killicon.Add("weapon_zs_fastzombielegs", "zombiesurvival/killicons/legs", color_white)
killicon.Add("weapon_zs_nightmare", "zombiesurvival/killicons/nightmare", color_white)
killicon.Add("weapon_zs_pukepus", "zombiesurvival/killicons/pukepus", color_white)
killicon.Add("weapon_zs_ticklemonster", "zombiesurvival/killicons/tickle", color_white)
killicon.Add("weapon_zs_crow", "zombiesurvival/killicons/crow", color_white)
killicon.Add("weapon_zs_fastzombie", "zombiesurvival/killicons/fastzombie", color_white)
killicon.Add("weapon_zs_poisonzombie", "zombiesurvival/killicons/poisonzombie", color_white)
killicon.Add("weapon_zs_chemzombie", "zombiesurvival/killicons/chemzombie", color_white)
killicon.Add("weapon_zs_ghoul", "zombiesurvival/killicons/ghoul", color_white)
killicon.Add("dummy_chemzombie", "zombiesurvival/killicons/chemzombie", color_white)
killicon.Add("weapon_zs_wraith", "zombiesurvival/killicons/wraithv2", color_white)
killicon.Add("weapon_zs_headcrab", "zombiesurvival/killicons/headcrab", color_white)
killicon.Add("weapon_zs_fastheadcrab", "zombiesurvival/killicons/fastheadcrab", color_white)
killicon.Add("weapon_zs_poisonheadcrab", "zombiesurvival/killicons/poisonheadcrab", color_white)
killicon.Add("projectile_poisonspit", "zombiesurvival/killicons/projectile_poisonspit", color_white)
killicon.Add("projectile_poisonflesh", "zombiesurvival/killicons/projectile_poisonflesh", color_white)
killicon.Add("projectile_poisonpuke", "zombiesurvival/killicons/pukepus", color_white)
killicon.Add("weapon_zs_special_wow", "sprites/glow04_noz", color_white)

killicon.Add("prop_gunturret", "zombiesurvival/killicons/prop_gunturret", color_white)
killicon.Add("weapon_zs_gunturret", "zombiesurvival/killicons/prop_gunturret", color_white)
killicon.Add("weapon_zs_gunturretremove", "zombiesurvival/killicons/prop_gunturret", color_white)
killicon.AddFont("projectile_zsgrenade", "zsdeathnotice", "4", color_white)
killicon.AddFont("weapon_zs_grenade", "zsdeathnotice", "4", color_white)
killicon.AddFont("prop_detpack", "zsdeathnotice", "*", color_white)
killicon.AddFont("weapon_zs_detpack", "zsdeathnotice", "*", color_white)
killicon.AddFont("weapon_zs_detpackremote", "zsdeathnotice", "*", color_white)
killicon.AddFont("weapon_zs_stubber", "zsdeathnoticecs", "n", color_white)
killicon.AddFont("weapon_zs_hunter", "zsdeathnoticecs", "r", color_white)
killicon.AddFont("weapon_zs_tosser", "zsdeathnotice", "/", color_white)
killicon.AddFont("weapon_zs_owens", "zsdeathnotice", "-", color_white)
killicon.AddFont("weapon_zs_battleaxe", "zsdeathnoticecs", "c", color_white)
killicon.AddFont("weapon_zs_boomstick", "zsdeathnotice", "0", color_white)
killicon.AddFont("weapon_zs_annabelle", "zsdeathnotice", "0", color_white)
killicon.AddFont("weapon_zs_silencer", "zsdeathnoticecs", "d", color_white)
killicon.AddFont("weapon_zs_blaster", "zsdeathnotice", "0", color_white)
killicon.AddFont("weapon_zs_eraser", "zsdeathnoticecs", "u", color_white)
killicon.AddFont("weapon_zs_sweepershotgun", "zsdeathnoticecs", "k", color_white)
killicon.AddFont("weapon_zs_zesweeper", "zsdeathnoticecs", "k", color_white)
killicon.AddFont("weapon_zs_barricadekit", "zsdeathnotice", "3", color_white)
killicon.AddFont("weapon_zs_bulletstorm", "zsdeathnoticecs", "m", color_white)
killicon.AddFont("weapon_zs_crossbow", "zsdeathnotice", "1", color_white)
killicon.AddFont("projectile_arrow", "zsdeathnotice", "1", color_white)
killicon.AddFont("weapon_zs_deagle", "zsdeathnoticecs", "f", color_white)
killicon.AddFont("weapon_zs_zedeagle", "zsdeathnoticecs", "f", color_white)
killicon.AddFont("weapon_zs_glock3", "zsdeathnoticecs", "c", color_white)
killicon.AddFont("weapon_zs_magnum", "zsdeathnotice", ".", color_white)
killicon.AddFont("weapon_zs_peashooter", "zsdeathnoticecs", "a", color_white)
killicon.AddFont("weapon_zs_slugrifle", "zsdeathnoticecs", "n", color_white)
killicon.AddFont("weapon_zs_smg", "zsdeathnoticecs", "x", color_white)
killicon.AddFont("weapon_zs_zesmg", "zsdeathnoticecs", "x", color_white)
killicon.AddFont("weapon_zs_swissarmyknife", "zsdeathnoticecs", "j", color_white)
killicon.AddFont("weapon_zs_zeknife", "zsdeathnoticecs", "j", color_white)
killicon.AddFont("weapon_zs_uzi", "zsdeathnoticecs", "l", color_white)
killicon.AddFont("weapon_zs_inferno", "zsdeathnoticecs", "e", color_white)
killicon.AddFont("weapon_zs_m4", "zsdeathnoticecs", "w", color_white)
killicon.AddFont("weapon_zs_reaper", "zsdeathnoticecs", "q", color_white)
killicon.AddFont("weapon_zs_crackler", "zsdeathnoticecs", "t", color_white)
killicon.AddFont("weapon_zs_pulserifle", "zsdeathnotice", "2", color_white)
killicon.AddFont("weapon_zs_akbar", "zsdeathnoticecs", "b", color_white)
killicon.AddFont("weapon_zs_zeakbar", "zsdeathnoticecs", "b", color_white)
killicon.AddFont("weapon_zs_ender", "zsdeathnoticecs", "v", color_white)
killicon.AddFont("weapon_zs_redeemers", "zsdeathnoticecs", "s", color_white)
killicon.Add("weapon_zs_axe", "killicon/zs_axe", color_white)
killicon.Add("weapon_zs_sawhack", "killicon/zs_axe", color_white)
killicon.Add("weapon_zs_keyboard", "killicon/zs_keyboard", color_white)
killicon.Add("weapon_zs_sledgehammer", "killicon/zs_sledgehammer", color_white)
killicon.Add("weapon_zs_megamasher", "killicon/zs_sledgehammer", color_white)
killicon.Add("weapon_zs_fryingpan", "killicon/zs_fryingpan", color_white)
killicon.Add("weapon_zs_pot", "killicon/zs_pot", color_white)
killicon.Add("weapon_zs_plank", "killicon/zs_plank", color_white)
killicon.Add("weapon_zs_hammer", "killicon/zs_hammer", color_white)
killicon.Add("weapon_zs_electrohammer", "killicon/zs_hammer", color_white)
killicon.Add("weapon_zs_shovel", "killicon/zs_shovel", color_white)
killicon.AddFont("weapon_zs_crowbar", "zsdeathnotice", "6", color_white)
killicon.AddFont("weapon_zs_stunbaton", "zsdeathnotice", "!", color_white)

net.Receive("zs_crow_kill_crow", function(length)
	local victim = net.ReadString()
	local attacker = net.ReadString()

	--gamemode.Call("AddDeathNotice", attacker, TEAM_UNDEAD, "weapon_zs_crow", victim, TEAM_UNDEAD)
	GAMEMODE:TopNotify(attacker, " ", {killicon = "weapon_zs_crow"}, " ", victim)
end)

net.Receive("zs_pl_kill_pl", function(length)
	local victim = net.ReadEntity()
	local attacker = net.ReadEntity()

	local inflictor = net.ReadString()

	local victimteam = net.ReadUInt(16)
	local attackerteam = net.ReadUInt(16)

	local headshot = net.ReadBit() == 1

	if victim:IsValid() and attacker:IsValid() then
		local attackername = attacker:Name()
		local victimname = victim:Name()

		if victim == MySelf then
			if victimteam == TEAM_HUMAN then
				gamemode.Call("LocalPlayerDied", attackername)
			end
		elseif attacker == MySelf then
			if attacker:Team() == TEAM_UNDEAD then
				gamemode.Call("FloatingScore", victim, "floatingscore_und", 1, 0)
			end
		end

		victim:CallZombieFunction("OnKilled", attacker, attacker, attacker == victim, headshot, DamageInfo())

		print(attackername.." killed "..victimname.." with "..inflictor)

		--gamemode.Call("AddDeathNotice", attackername, attackerteam, inflictor, victimname, victimteam, headshot)
		GAMEMODE:TopNotify(attacker, " ", {killicon = inflictor, headshot = headshot}, " ", victim)
	end
end)

net.Receive("zs_pls_kill_pl", function(length)
	local victim = net.ReadEntity()
	local attacker = net.ReadEntity()
	local assister = net.ReadEntity()

	local inflictor = net.ReadString()

	local victimteam = net.ReadUInt(16)
	local attackerteam = net.ReadUInt(16)

	local headshot = net.ReadBit() == 1

	if victim:IsValid() and attacker:IsValid() and assister:IsValid() then
		local victimname = victim:Name()
		local attackername = attacker:Name()
		local assistername = assister:Name()

		if victim == MySelf and victimteam == TEAM_HUMAN then
			gamemode.Call("LocalPlayerDied", attackername.." and "..assistername)
		end

		victim:CallZombieFunction("OnKilled", attacker, attacker, attacker == victim, headshot, DamageInfo())

		print(attackername.." and "..assistername.." killed "..victimname.." with "..inflictor)

		--gamemode.Call("AddDeathNotice", attackername.." and "..assistername, attackerteam, inflictor, victimname, victimteam, headshot)
		GAMEMODE:TopNotify(attacker, " and ", assister, " ", {killicon = inflictor, headshot = headshot}, " ", victim)
	end
end)

net.Receive("zs_pl_kill_self", function(length)
	local victim = net.ReadEntity()
	local victimteam = net.ReadUInt(16)

	if victim:IsValid() then
		if victim == MySelf and victimteam == TEAM_HUMAN then
			gamemode.Call("LocalPlayerDied")
		end

		victim:CallZombieFunction("OnKilled", victim, victim, true, false, DamageInfo())

		local victimname = victim:Name()

		print(victimname.." killed themself")

		--gamemode.Call("AddDeathNotice", nil, 0, "suicide", victimname, victimteam)
		GAMEMODE:TopNotify({killicon = "suicide"}, " ", victim)
	end
end)

net.Receive("zs_playerredeemed", function(length)
	local pl = net.ReadEntity()
	local name = net.ReadString()

	--gamemode.Call("AddDeathNotice", nil, 0, "redeem", name, TEAM_HUMAN)

	if pl:IsValid() then
		GAMEMODE:TopNotify(pl, " has redeemed! ", {killicon = "redeem"})

		if pl == MySelf then
			GAMEMODE:CenterNotify(COLOR_CYAN, translate.Get("you_redeemed"))
		end
	end
end)

net.Receive("zs_death", function(length)
	local victim = net.ReadEntity()
	local inflictor = net.ReadString()
	local attacker = "#" .. net.ReadString()
	local victimteam = net.ReadUInt(16)

	if victim:IsValid() then
		if victim == MySelf and victimteam == TEAM_HUMAN then
			gamemode.Call("LocalPlayerDied")
		end

		victim:CallZombieFunction("OnKilled", attacker, NULL, attacker == victim, false, DamageInfo())

		local victimname = victim:Name()

		print(victimname.." was killed by "..attacker.." with "..inflictor)

		--gamemode.Call("AddDeathNotice", attacker, -1, inflictor, victimname, victimteam)
		GAMEMODE:TopNotify(COLOR_RED, attacker, " ", {deathicon = inflictor}, " ", victim)
	end
end)

-- Handled above.
function GM:AddDeathNotice()
end
