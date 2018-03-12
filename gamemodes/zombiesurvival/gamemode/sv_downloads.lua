function GM:AddResources()
	resource.AddFile("resource/fonts/typenoksidi.ttf")
	resource.AddFile("resource/fonts/hidden.ttf")

	for _, filename in pairs(file.Find("materials/zombiesurvival/*.vmt", "GAME")) do
		resource.AddFile("materials/zombiesurvival/"..filename)
	end

	for _, filename in pairs(file.Find("materials/zombiesurvival/killicons/*.vmt", "GAME")) do
		resource.AddFile("materials/zombiesurvival/killicons/"..filename)
	end

	resource.AddFile("materials/zombiesurvival/filmgrain/filmgrain.vmt")
	resource.AddFile("materials/zombiesurvival/filmgrain/filmgrain.vtf")

	for _, filename in pairs(file.Find("sound/zombiesurvival/*.ogg", "GAME")) do
		resource.AddFile("sound/zombiesurvival/"..filename)
	end
	for _, filename in pairs(file.Find("sound/zombiesurvival/*.wav", "GAME")) do
		resource.AddFile("sound/zombiesurvival/"..filename)
	end
	for _, filename in pairs(file.Find("sound/zombiesurvival/*.mp3", "GAME")) do
		resource.AddFile("sound/zombiesurvival/"..filename)
	end

	local _____, dirs = file.Find("sound/zombiesurvival/beats/*", "GAME")
	for _, dirname in pairs(dirs) do
		for __, filename in pairs(file.Find("sound/zombiesurvival/beats/"..dirname.."/*.ogg", "GAME")) do
			resource.AddFile("sound/zombiesurvival/beats/"..dirname.."/"..filename)
		end
		for __, filename in pairs(file.Find("sound/zombiesurvival/beats/"..dirname.."/*.wav", "GAME")) do
			resource.AddFile("sound/zombiesurvival/beats/"..dirname.."/"..filename)
		end
		for __, filename in pairs(file.Find("sound/zombiesurvival/beats/"..dirname.."/*.mp3", "GAME")) do
			resource.AddFile("sound/zombiesurvival/beats/"..dirname.."/"..filename)
		end
	end

	resource.AddFile("materials/refract_ring.vmt")
	resource.AddFile("materials/killicon/redeem_v2.vtf")
	resource.AddFile("materials/killicon/redeem_v2.vmt")
	resource.AddFile("materials/killicon/zs_axe.vtf")
	resource.AddFile("materials/killicon/zs_keyboard.vtf")
	resource.AddFile("materials/killicon/zs_sledgehammer.vtf")
	resource.AddFile("materials/killicon/zs_fryingpan.vtf")
	resource.AddFile("materials/killicon/zs_pot.vtf")
	resource.AddFile("materials/killicon/zs_plank.vtf")
	resource.AddFile("materials/killicon/zs_hammer.vtf")
	resource.AddFile("materials/killicon/zs_shovel.vtf")
	resource.AddFile("materials/killicon/zs_axe.vmt")
	resource.AddFile("materials/killicon/zs_keyboard.vmt")
	resource.AddFile("materials/killicon/zs_sledgehammer.vmt")
	resource.AddFile("materials/killicon/zs_fryingpan.vmt")
	resource.AddFile("materials/killicon/zs_pot.vmt")
	resource.AddFile("materials/killicon/zs_plank.vmt")
	resource.AddFile("materials/killicon/zs_hammer.vmt")
	resource.AddFile("materials/killicon/zs_shovel.vmt")
	resource.AddFile("models/weapons/v_zombiearms.mdl")
	resource.AddFile("materials/models/weapons/v_zombiearms/zombie_classic_sheet.vmt")
	resource.AddFile("materials/models/weapons/v_zombiearms/zombie_classic_sheet.vtf")
	resource.AddFile("materials/models/weapons/v_zombiearms/zombie_classic_sheet_normal.vtf")
	resource.AddFile("materials/models/weapons/v_zombiearms/ghoulsheet.vmt")
	resource.AddFile("materials/models/weapons/v_zombiearms/ghoulsheet.vtf")
	resource.AddFile("models/weapons/v_fza.mdl")
	resource.AddFile("models/weapons/v_pza.mdl")
	resource.AddFile("materials/models/weapons/v_fza/fast_zombie_sheet.vmt")
	resource.AddFile("materials/models/weapons/v_fza/fast_zombie_sheet.vtf")
	resource.AddFile("materials/models/weapons/v_fza/fast_zombie_sheet_normal.vtf")
	resource.AddFile("models/weapons/v_annabelle.mdl")
	resource.AddFile("materials/models/weapons/w_annabelle/gun.vtf")
	resource.AddFile("materials/models/weapons/sledge.vtf")
	resource.AddFile("materials/models/weapons/sledge.vmt")
	resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vtf")
	resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vmt")
	resource.AddFile("materials/models/weapons/hammer2.vtf")
	resource.AddFile("materials/models/weapons/hammer2.vmt")
	resource.AddFile("materials/models/weapons/hammer.vtf")
	resource.AddFile("materials/models/weapons/hammer.vmt")
	resource.AddFile("models/weapons/w_sledgehammer.mdl")
	resource.AddFile("models/weapons/v_sledgehammer/v_sledgehammer.mdl")
	resource.AddFile("models/weapons/w_hammer.mdl")
	resource.AddFile("models/weapons/v_hammer/v_hammer.mdl")
	resource.AddFile( "materials/zombiesurvival/killicons/acidcrab_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/acidcrab_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/acidzombie_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/acidzombie_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/bastardzine_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/bastardzine_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/bloatedzombie_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/bloatedzombie_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/bloodspore_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/bloodspore_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/butcher_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/butcher_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/chemzombie_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/chemzombie_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/crawler_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/crawler_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/creeper_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/creeper_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/fastcrab_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/fastcrab_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/fastzombie_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/fastzombie_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/flesh_creeper_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/flesh_creeper_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/freshdead_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/freshdead_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/ghoul_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/ghoul_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/headcrab_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/headcrab_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/legs.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/legs.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/nightmare_hd_2.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/nightmare_hd_2.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/nugget_hd_2.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/nugget_hd_2.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/pukepus_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/pukepus_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/shade_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/shade_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/ticklemonster_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/ticklemonster_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/wraith_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/wraith_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/zombiebaby_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/zombiebaby_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/zombie_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/zombie_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/zombine_hd.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/zombine_hd.vtf" )
	resource.AddFile( "materials/zombiesurvival/killicons/zombiebaby_hd_4.vmt" )
	resource.AddFile( "materials/zombiesurvival/killicons/zombiebaby_hd_4.vtf" )

	resource.AddFile("models/weapons/v_aegiskit.mdl")

	resource.AddFile("materials/models/weapons/v_hand/armtexture.vmt")

	resource.AddFile("models/wraith_zsv1.mdl")
	for _, filename in pairs(file.Find("materials/models/wraith1/*.vmt", "GAME")) do
		resource.AddFile("materials/models/wraith1/"..filename)
	end
	for _, filename in pairs(file.Find("materials/models/wraith1/*.vtf", "GAME")) do
		resource.AddFile("materials/models/wraith1/"..filename)
	end

	resource.AddFile("models/weapons/v_supershorty/v_supershorty.mdl")
	resource.AddFile("models/weapons/w_supershorty.mdl")
	for _, filename in pairs(file.Find("materials/weapons/v_supershorty/*.vmt", "GAME")) do
		resource.AddFile("materials/weapons/v_supershorty/"..filename)
	end
	for _, filename in pairs(file.Find("materials/weapons/v_supershorty/*.vtf", "GAME")) do
		resource.AddFile("materials/weapons/v_supershorty/"..filename)
	end
	for _, filename in pairs(file.Find("materials/weapons/w_supershorty/*.vmt", "GAME")) do
		resource.AddFile("materials/weapons/w_supershorty/"..filename)
	end
	for _, filename in pairs(file.Find("materials/weapons/w_supershorty/*.vtf", "GAME")) do
		resource.AddFile("materials/weapons/w_supershorty/"..filename)
	end
	for _, filename in pairs(file.Find("materials/weapons/survivor01_hands/*.vmt", "GAME")) do
		resource.AddFile("materials/weapons/survivor01_hands/"..filename)
	end
	for _, filename in pairs(file.Find("materials/weapons/survivor01_hands/*.vtf", "GAME")) do
		resource.AddFile("materials/weapons/survivor01_hands/"..filename)
	end

	for _, filename in pairs(file.Find("materials/models/weapons/v_pza/*.*", "GAME")) do
		resource.AddFile("materials/models/weapons/v_pza/"..string.lower(filename))
	end

	resource.AddFile("models/player/fatty/fatty.mdl")
	resource.AddFile("materials/models/player/elis/fty/001.vmt")
	resource.AddFile("materials/models/player/elis/fty/001.vtf")
	resource.AddFile("materials/models/player/elis/fty/001_normal.vtf")

	resource.AddFile("models/vinrax/player/doll_player.mdl")

	resource.AddFile("sound/weapons/melee/golf_club/golf_hit-01.ogg")
	resource.AddFile("sound/weapons/melee/golf_club/golf_hit-02.ogg")
	resource.AddFile("sound/weapons/melee/golf_club/golf_hit-03.ogg")
	resource.AddFile("sound/weapons/melee/golf_club/golf_hit-04.ogg")
	resource.AddFile("sound/weapons/melee/crowbar/crowbar_hit-1.ogg")
	resource.AddFile("sound/weapons/melee/crowbar/crowbar_hit-2.ogg")
	resource.AddFile("sound/weapons/melee/crowbar/crowbar_hit-3.ogg")
	resource.AddFile("sound/weapons/melee/crowbar/crowbar_hit-4.ogg")
	resource.AddFile("sound/weapons/melee/shovel/shovel_hit-01.ogg")
	resource.AddFile("sound/weapons/melee/shovel/shovel_hit-02.ogg")
	resource.AddFile("sound/weapons/melee/shovel/shovel_hit-03.ogg")
	resource.AddFile("sound/weapons/melee/shovel/shovel_hit-04.ogg")
	resource.AddFile("sound/weapons/melee/frying_pan/pan_hit-01.ogg")
	resource.AddFile("sound/weapons/melee/frying_pan/pan_hit-02.ogg")
	resource.AddFile("sound/weapons/melee/frying_pan/pan_hit-03.ogg")
	resource.AddFile("sound/weapons/melee/frying_pan/pan_hit-04.ogg")
	resource.AddFile("sound/weapons/melee/keyboard/keyboard_hit-01.ogg")
	resource.AddFile("sound/weapons/melee/keyboard/keyboard_hit-02.ogg")
	resource.AddFile("sound/weapons/melee/keyboard/keyboard_hit-03.ogg")
	resource.AddFile("sound/weapons/melee/keyboard/keyboard_hit-04.ogg")

	resource.AddFile("materials/noxctf/sprite_bloodspray1.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray2.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray3.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray4.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray5.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray6.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray7.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray8.vmt")

	resource.AddFile("sound/"..tostring(self.LastHumanSound))
	resource.AddFile("sound/"..tostring(self.AllLoseSound))
	resource.AddFile("sound/"..tostring(self.HumanWinSound))
	resource.AddFile("sound/"..tostring(self.DeathSound))
end