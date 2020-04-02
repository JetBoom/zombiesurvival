--[[

Zombie Survival
by William "JetBoom" Moodhe
williammoodhe@gmail.com -or- jetboom@noxiousnet.com
http://www.noxiousnet.com/

Further credits displayed by pressing F1 in-game.
This was my first ever gamemode. A lot of stuff is from years ago and some stuff is very recent.

]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("sh_translate.lua")
AddCSLuaFile("sh_colors.lua")
AddCSLuaFile("sh_serialization.lua")
AddCSLuaFile("sh_globals.lua")
AddCSLuaFile("sh_util.lua")
AddCSLuaFile("sh_options.lua")
AddCSLuaFile("sh_zombieclasses.lua")
AddCSLuaFile("sh_animations.lua")
AddCSLuaFile("sh_sigils.lua")
AddCSLuaFile("sh_channel.lua")
AddCSLuaFile("sh_weaponquality.lua")

AddCSLuaFile("vault/shared.lua")

AddCSLuaFile("cl_draw.lua")
AddCSLuaFile("cl_net.lua")
AddCSLuaFile("cl_util.lua")
AddCSLuaFile("cl_options.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("cl_postprocess.lua")
AddCSLuaFile("cl_deathnotice.lua")
AddCSLuaFile("cl_floatingscore.lua")
AddCSLuaFile("cl_dermaskin.lua")
AddCSLuaFile("cl_hint.lua")
AddCSLuaFile("cl_thirdperson.lua")
AddCSLuaFile("cl_voicesets.lua")

AddCSLuaFile("skillweb/sh_skillweb.lua")
AddCSLuaFile("skillweb/cl_skillweb.lua")
AddCSLuaFile("skillweb/registry.lua")

AddCSLuaFile("obj_vector_extend.lua")
AddCSLuaFile("obj_entity_extend.lua")
AddCSLuaFile("obj_entity_extend_cl.lua")
AddCSLuaFile("obj_player_extend.lua")
AddCSLuaFile("obj_player_extend_cl.lua")
AddCSLuaFile("obj_weapon_extend.lua")
AddCSLuaFile("obj_weapon_extend_cl.lua")

AddCSLuaFile("vgui/dteamcounter.lua")
AddCSLuaFile("vgui/dmodelpanelex.lua")
AddCSLuaFile("vgui/dammocounter.lua")
AddCSLuaFile("vgui/dpingmeter.lua")
AddCSLuaFile("vgui/dteamheading.lua")
AddCSLuaFile("vgui/dsidemenu.lua")
AddCSLuaFile("vgui/dspawnmenu.lua")
AddCSLuaFile("vgui/dmodelkillicon.lua")

AddCSLuaFile("vgui/dexroundedpanel.lua")
AddCSLuaFile("vgui/dexroundedframe.lua")
AddCSLuaFile("vgui/dexrotatedimage.lua")
AddCSLuaFile("vgui/dexnotificationslist.lua")
AddCSLuaFile("vgui/dexchanginglabel.lua")

AddCSLuaFile("vgui/mainmenu.lua")
AddCSLuaFile("vgui/pmainmenu.lua")
AddCSLuaFile("vgui/poptions.lua")
AddCSLuaFile("vgui/phelp.lua")
AddCSLuaFile("vgui/pclassselect.lua")
AddCSLuaFile("vgui/pweapons.lua")
AddCSLuaFile("vgui/pendboard.lua")
AddCSLuaFile("vgui/pworth.lua")
AddCSLuaFile("vgui/parsenal.lua")
AddCSLuaFile("vgui/premantle.lua")
AddCSLuaFile("vgui/zshealtharea.lua")
AddCSLuaFile("vgui/zsstatusarea.lua")
AddCSLuaFile("vgui/zsgamestate.lua")

include("sh_globals.lua")

include("obj_entity_extend_sv.lua")
include("obj_player_extend_sv.lua")
include("obj_weapon_extend_sv.lua")

AddCSLuaFile("loader.lua")
include("loader.lua")

include("shared.lua")
include("sv_options.lua")
include("mapeditor.lua")
include("sv_playerspawnentities.lua")
include("sv_profiling.lua")
include("sv_sigils.lua")
include("sv_concommands.lua")

include("itemstocks/sv_stock.lua")

include("vault/server.lua")

include("skillweb/sv_registry.lua")
include("skillweb/sv_skillweb.lua")

include("sv_zombieescape.lua")

include("zsbots/init.lua")

include_library("statistics")

local pairs = pairs
local ipairs = ipairs
local IN_WALK = IN_WALK
local IN_USE = IN_USE
local IN_RELOAD = IN_RELOAD
local IN_MOVERIGHT = IN_MOVERIGHT
local IN_MOVELEFT = IN_MOVELEFT
local IN_ATTACK = IN_ATTACK
local IN_ATTACK2 = IN_ATTACK2
local IN_ZOOM = IN_ZOOM
local IN_SPEED = IN_SPEED
local CurTime = CurTime
local Vector = Vector
local Angle = Angle
local vector_origin = vector_origin
local HITGROUP_HEAD = HITGROUP_HEAD
local HITGROUP_LEFTLEG = HITGROUP_LEFTLEG
local HITGROUP_RIGHTLEG = HITGROUP_RIGHTLEG
local math_max = math.max

local M_Player = FindMetaTable("Player")

local P_GetBarricadeGhosting = M_Player.GetBarricadeGhosting
local P_BarricadeGhostingThink = M_Player.BarricadeGhostingThink
local P_Team = M_Player.Team
local P_Alive = M_Player.Alive
local player_GetAll = player.GetAll
local P_GetPhantomHealth = M_Player.GetPhantomHealth

function GM:WorldHint(hint, pos, ent, lifetime, filter)
	net.Start("zs_worldhint")
		net.WriteString(hint)
		net.WriteVector(pos or ent and ent:IsValid() and ent:GetPos() or vector_origin)
		net.WriteEntity(ent or NULL)
		net.WriteFloat(lifetime or 8)
	if filter then
		net.Send(filter)
	else
		net.Broadcast()
	end
end

function GM:CreateGibs(pos, headoffset)
	headoffset = headoffset or 0

	local headpos = Vector(pos.x, pos.y, pos.z + headoffset)
	for i = 1, 2 do
		local ent = ents.CreateLimited("prop_playergib")
		if ent:IsValid() then
			ent:SetPos(headpos + VectorRand():GetNormalized() * math.Rand(1, 5))
			ent:SetAngles(VectorRand():Angle())
			ent:SetGibType(i)
			ent:Spawn()
		end
	end

	for i = 1, 4 do
		local ent = ents.CreateLimited("prop_playergib")
		if ent:IsValid() then
			ent:SetPos(pos + VectorRand():GetNormalized() * math.Rand(1, 12))
			ent:SetAngles(VectorRand():Angle())
			ent:SetGibType(math.random(3, #GAMEMODE.HumanGibs))
			ent:Spawn()
		end
	end
end

function GM:DisallowHumanPickup(pl, entity)
end

function GM:TryHumanPickup(pl, entity)
	if self.ZombieEscape or pl.NoObjectPickup or not pl:Alive() or pl:Team() ~= TEAM_HUMAN or (entity.NoPickupsTime and CurTime() < entity.NoPickupsTime and entity.NoPickupsOwner ~= pl) then return end

	if gamemode.Call("DisallowHumanPickup", pl, entity) or pl:GetInfo("zs_nopickupprops") == "1" then return end

	if entity:IsValid() and not entity.m_NoPickup then
		local phys = entity:GetPhysicsObject()
		if phys:IsValid() and phys:HasGameFlag(FVPHYSICS_PLAYER_HELD) then return end

		local entclass = string.sub(entity:GetClass(), 1, 12)
		local carrymaxmass = CARRY_MAXIMUM_MASS * (pl.PropCarryCapacityMul or 1)
		local carrymaxvol = CARRY_MAXIMUM_VOLUME * (pl.PropCarryCapacityMul or 1)
		if (entclass == "prop_physics" or entclass == "func_physbox" or entity.HumanHoldable and entity:HumanHoldable(pl)) and not entity:IsNailed() and entity:GetMoveType() == MOVETYPE_VPHYSICS and entity:GetPhysicsObject():IsValid() and entity:GetPhysicsObject():GetMass() <= carrymaxmass and entity:GetPhysicsObject():IsMoveable() and entity:OBBMins():Length() + entity:OBBMaxs():Length() <= carrymaxvol then
			local holder = entity:GetHolder()
			if not holder and not pl:IsHolding() and CurTime() >= (pl.NextHold or 0)
			and pl:GetShootPos():DistToSqr(entity:NearestPoint(pl:GetShootPos())) <= 4096 and pl:GetGroundEntity() ~= entity then --64^2
				local newstatus = ents.Create("status_human_holding")
				if newstatus:IsValid() then
					pl.NextHold = CurTime() + 0.25
					pl.NextUnHold = CurTime() + 0.05
					newstatus:SetPos(pl:GetShootPos())
					newstatus:SetOwner(pl)
					newstatus:SetParent(pl)
					newstatus:SetObject(entity)
					newstatus:Spawn()
				end
			end
		end
	end
end

function GM:AddResources()
	resource.AddFile("resource/fonts/typenoksidi.ttf")
	resource.AddFile("resource/fonts/hidden.ttf")
	resource.AddFile("resource/fonts/ghoulfriaoe.ttf")
	resource.AddFile("resource/fonts/remingtonnoiseless.ttf")

	resource.AddFile("particles/vman_explosion.pcf")

	for _, filename in pairs(file.Find("materials/zombiesurvival/*.vmt", "GAME")) do
		resource.AddFile("materials/zombiesurvival/"..filename)
	end

	for _, filename in pairs(file.Find("materials/zombiesurvival/*.png", "GAME")) do
		resource.AddFile("materials/zombiesurvival/"..filename)
	end

	for _, filename in pairs(file.Find("materials/zombiesurvival/killicons/*.vmt", "GAME")) do
		resource.AddFile("materials/zombiesurvival/killicons/"..filename)
	end

	for _, filename in pairs(file.Find("materials/zombiesurvival/killicons/*.png", "GAME")) do
		resource.AddFile("materials/zombiesurvival/killicons/"..filename)
	end

	resource.AddFile("materials/zombiesurvival/filmgrain/filmgrain.vmt")
	resource.AddFile("materials/zombiesurvival/filmgrain/filmgrain.vtf")

	for _, filename in pairs(file.Find("sound/zombiesurvival/*.ogg", "GAME")) do
		resource.AddFile("sound/zombiesurvival/"..filename)
	end
	for _, filename in pairs(file.Find("sound/zombiesurvival/ui/*.ogg", "GAME")) do
		resource.AddFile("sound/zombiesurvival/ui/"..filename)
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
	resource.AddFile("models/weapons/c_annabelle.mdl")
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
	resource.AddFile("models/weapons/v_sledgehammer/c_sledgehammer.mdl")
	resource.AddFile("models/weapons/w_hammer.mdl")
	resource.AddFile("models/weapons/v_hammer/c_hammer.mdl")

	resource.AddFile("models/weapons/c_aegiskit.mdl")

	resource.AddFile("materials/models/weapons/v_hand/armtexture.vmt")

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

	resource.AddFile("models/player/zelpa/stalker.mdl")

	resource.AddFile("models/vinrax/player/doll_player.mdl")

	resource.AddFile("models/player/zombie_classic_hbfix.mdl")
	resource.AddFile("models/player/zombie_lacerator2.mdl")

	resource.AddFile("sound/weapons/melee/golf club/golf_hit-01.ogg")
	resource.AddFile("sound/weapons/melee/golf club/golf_hit-02.ogg")
	resource.AddFile("sound/weapons/melee/golf club/golf_hit-03.ogg")
	resource.AddFile("sound/weapons/melee/golf club/golf_hit-04.ogg")
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

	resource.AddFile("sound/weapons/zs_sawnoff/sawnoff_fire1.ogg")
	resource.AddFile("sound/weapons/zs_sawnoff/barrelup.ogg")
	resource.AddFile("sound/weapons/zs_sawnoff/barreldown.ogg")

	resource.AddFile("sound/weapons/zs_longarm/longarm_fire.ogg")

	resource.AddFile("sound/weapons/zs_scar/scar_fire1.ogg")

	resource.AddFile("sound/nox/sword_hit.ogg")
	resource.AddFile("sound/nox/sword_miss.ogg")
	resource.AddFile("sound/nox/frotchet_test1.ogg")
	resource.AddFile("sound/nox/scatterfrost.ogg")

	resource.AddFile("sound/weapons/zs_gluon/egon_off1.wav")

	resource.AddFile("sound/weapons/zs_heph/electro4.wav")
	resource.AddFile("sound/weapons/zs_heph/electro5.wav")
	resource.AddFile("sound/weapons/zs_heph/electro6.wav")

	resource.AddFile("sound/weapons/zs_inner/innershot.ogg")

	resource.AddFile("sound/weapons/zs_glad/gladshot4.wav")

	resource.AddFile("sound/weapons/zs_flak/load1.wav")
	resource.AddFile("sound/weapons/zs_flak/shot1.wav")

	resource.AddFile("sound/weapons/zs_rail/rail.wav")

	resource.AddFile("sound/weapons/zs_asmd/secondary2.wav")
	resource.AddFile("sound/weapons/zs_asmd/main3.wav")

	resource.AddFile("sound/weapons/zs_power/power1.ogg")
	resource.AddFile("sound/weapons/zs_power/power4.wav")

	resource.AddFile("materials/zombiesurvival/arsenalcrate.png")

	resource.AddFile("sound/"..tostring(self.LastHumanSound))
	resource.AddFile("sound/"..tostring(self.AllLoseSound))
	resource.AddFile("sound/"..tostring(self.HumanWinSound))
	resource.AddFile("sound/"..tostring(self.DeathSound))
end

function GM:Initialize()
	self:FixSkillConnections()
	self:RegisterPlayerSpawnEntities()
	self:AddResources()
	self:PrecacheResources()
	self:AddCustomAmmo()
	self:CreateWeaponQualities()
	self:AddNetworkStrings()
	self:RegisterFood()
	self:LoadProfiler()

	self:SetPantsMode(self.PantsMode, true)
	self:SetClassicMode(self:IsClassicMode(), true)
	self:SetBabyMode(self:IsBabyMode(), true)
	self:SetRedeemBrains(self.DefaultRedeem)

	self:RefreshMapIsObjective()

	game.ConsoleCommand("fire_dmgscale 1\n")
	game.ConsoleCommand("mp_flashlight 1\n")
	game.ConsoleCommand("sv_gravity 600\n")
end

function GM:AddNetworkStrings()
	util.AddNetworkString("zs_gamestate")
	util.AddNetworkString("zs_wavestart")
	util.AddNetworkString("zs_waveend")
	util.AddNetworkString("zs_lasthuman")
	util.AddNetworkString("zs_gamemodecall")
	util.AddNetworkString("zs_lasthumanpos")
	util.AddNetworkString("zs_endround")
	util.AddNetworkString("zs_centernotify")
	util.AddNetworkString("zs_topnotify")
	util.AddNetworkString("zs_zvols")
	util.AddNetworkString("zs_nextboss")
	util.AddNetworkString("zs_classunlock")
	util.AddNetworkString("zs_sigilcorrupted")
	util.AddNetworkString("zs_sigiluncorrupted")
	util.AddNetworkString("zs_survivor")
	util.AddNetworkString("zs_itemstock")
	util.AddNetworkString("zs_playerredeemed")
	util.AddNetworkString("zs_dohulls")
	util.AddNetworkString("zs_penalty")
	util.AddNetworkString("zs_nextresupplyuse")
	util.AddNetworkString("zs_stowagecaches")
	util.AddNetworkString("zs_lifestats")
	util.AddNetworkString("zs_lifestatsbd")
	util.AddNetworkString("zs_lifestatshd")
	util.AddNetworkString("zs_lifestatsbe")
	util.AddNetworkString("zs_boss_spawned")
	util.AddNetworkString("zs_boss_slain")
	util.AddNetworkString("zs_commission")
	util.AddNetworkString("zs_healother")
	util.AddNetworkString("zs_healby")
	util.AddNetworkString("zs_buffby")
	util.AddNetworkString("zs_buffwith")
	util.AddNetworkString("zs_repairobject")
	util.AddNetworkString("zs_worldhint")
	util.AddNetworkString("zs_honmention")
	util.AddNetworkString("zs_floatscore")
	util.AddNetworkString("zs_floatscore_vec")
	util.AddNetworkString("zs_zclass")
	util.AddNetworkString("zs_dmg")
	util.AddNetworkString("zs_dmg_prop")
	util.AddNetworkString("zs_legdamage")
	util.AddNetworkString("zs_armdamage")
	util.AddNetworkString("zs_extrastartingworth")
	util.AddNetworkString("zs_ammopickup")
	util.AddNetworkString("zs_ammogive")
	util.AddNetworkString("zs_ammogiven")
	util.AddNetworkString("zs_deployablelost")
	util.AddNetworkString("zs_deployableclaim")
	util.AddNetworkString("zs_deployableout")
	util.AddNetworkString("zs_trinketconsumed")
	util.AddNetworkString("zs_nailremoved")
	util.AddNetworkString("zs_remantlercontent")
	util.AddNetworkString("zs_classunlockstate")
	util.AddNetworkString("zs_changeclass")
	util.AddNetworkString("zs_currentround")
	util.AddNetworkString("zs_zsfriend")
	util.AddNetworkString("zs_zsfriendadded")
	util.AddNetworkString("zs_remantleconf")
	util.AddNetworkString("zs_nestbuilt")
	util.AddNetworkString("zs_nestspec")
	util.AddNetworkString("zs_tvcamera")

	util.AddNetworkString("zs_inventoryitem")
	util.AddNetworkString("zs_trycraft")
	util.AddNetworkString("zs_updatealtselwep")
	util.AddNetworkString("zs_invitem")
	util.AddNetworkString("zs_invgiven")
	util.AddNetworkString("zs_wipeinventory")

	util.AddNetworkString("zs_skills_active")
	util.AddNetworkString("zs_skills_unlocked")
	util.AddNetworkString("zs_skills_desired")
	util.AddNetworkString("zs_skill_is_desired")
	util.AddNetworkString("zs_skill_is_unlocked")
	util.AddNetworkString("zs_skills_all_desired")
	util.AddNetworkString("zs_skill_set_desired")
	util.AddNetworkString("zs_skills_init")
	util.AddNetworkString("zs_skills_reset")
	util.AddNetworkString("zs_skills_remort")
	util.AddNetworkString("zs_skills_nextreset")
	util.AddNetworkString("zs_skills_notify")
	util.AddNetworkString("zs_skills_refunded")

	util.AddNetworkString("zs_crow_kill_crow")
	util.AddNetworkString("zs_pl_kill_pl")
	util.AddNetworkString("zs_pls_kill_pl")
	util.AddNetworkString("zs_pl_kill_self")
	util.AddNetworkString("zs_death")

	util.AddNetworkString("voice_eyepain")
	util.AddNetworkString("voice_giveammo")
	util.AddNetworkString("voice_death")
	util.AddNetworkString("voice_zombiedeath")
	util.AddNetworkString("voice_pain")
	util.AddNetworkString("voice_zombiepain")
end

function GM:IsClassicMode()
	return self.ClassicMode
end

function GM:IsBabyMode()
	return self.BabyMode
end

function GM:CenterNotifyAll(...)
	net.Start("zs_centernotify")
		net.WriteTable({...})
	net.Broadcast()
end
GM.CenterNotify = GM.CenterNotifyAll

function GM:TopNotifyAll(...)
	net.Start("zs_topnotify")
		net.WriteTable({...})
	net.Broadcast()
end
GM.TopNotify = GM.TopNotifyAll

function GM:ShowHelp(pl)
	pl:SendLua("GAMEMODE:ShowHelp()")
end

function GM:ShowTeam(pl)
	if pl:Team() == TEAM_HUMAN and not self.ZombieEscape then
		pl:SendLua(self:GetWave() > 0 and "GAMEMODE:OpenArsenalMenu()" or "MakepWorth()")
	end
end

function GM:ShowSpare1(pl)
	if pl:Team() == TEAM_UNDEAD then
		if self:ShouldUseAlternateDynamicSpawn() then
			pl:CenterNotify(COLOR_RED, translate.ClientGet(pl, "no_class_switch_in_this_mode"))
		else
			pl:SendLua("GAMEMODE:OpenClassSelect()")
		end
	elseif pl:Team() == TEAM_HUMAN then
		pl:SendLua("GAMEMODE:ToggleSkillWeb()")
	end
end

function GM:ShowSpare2(pl)
	pl:SendLua("MakepOptions()")
end

function GM:SetupSpawnPoints()
	local ztab = ents.FindByClass("info_player_undead")
	ztab = table.Add(ztab, ents.FindByClass("info_player_zombie"))

	local htab = ents.FindByClass("info_player_human")

	-- Terrorist spawns are usually in some kind of house or a main base in CS_  in order to guard the hosties. Put the humans there.
	-- Otherwise, this is probably a DE_, ZM_, or ZH_ map. In DE_ maps, the T's spawn away from the main part of the map and are zombies in zombie plugins so let's do the same.
	local mapname = string.lower(game.GetMap())
	local stockspawnbehavior = string.sub(mapname, 1, 3) == "cs_" or string.sub(mapname, 1, 3) == "zs_"

	-- Only add CS:S and HL2:DM spawn points if no ZS specific spawn points exist.
	if #ztab == 0 then
		if stockspawnbehavior then
			ztab = table.Add(ztab, ents.FindByClass("info_player_counterterrorist"))
		else
			ztab = table.Add(ztab, ents.FindByClass("info_player_terrorist"))
		end

		ztab = table.Add(ztab, ents.FindByClass("info_player_rebel"))
	end
	if #htab == 0 then
		if stockspawnbehavior then
			htab = table.Add(htab, ents.FindByClass("info_player_terrorist"))
		else
			htab = table.Add(htab, ents.FindByClass("info_player_counterterrorist"))
		end

		htab = table.Add(htab, ents.FindByClass("info_player_combine"))
	end

	-- Add all the old ZS spawns from GMod9.
	for _, oldspawn in pairs(ents.FindByClass("gmod_player_start")) do
		if oldspawn.BlueTeam then
			table.insert(htab, oldspawn)
		else
			table.insert(ztab, oldspawn)
		end
	end

	-- You shouldn't play a DM map since spawns are shared but whatever. Let's make sure that there aren't team spawns first.
	if #htab == 0 then
		htab = ents.FindByClass("info_player_start")
		htab = table.Add(htab, ents.FindByClass("info_player_deathmatch")) -- Zombie Master
	end
	if #ztab == 0 then
		ztab = ents.FindByClass("info_player_start")
		ztab = table.Add(ztab, ents.FindByClass("info_zombiespawn")) -- Zombie Master
	end

	team.SetSpawnPoint(TEAM_UNDEAD, ztab)
	team.SetSpawnPoint(TEAM_HUMAN, htab)
	team.SetSpawnPoint(TEAM_SPECTATOR, htab)

	self.RedeemSpawnPoints = ents.FindByClass("info_player_redeemed")
	self.BossSpawnPoints = table.Add(ents.FindByClass("info_player_zombie_boss"), ents.FindByClass("info_player_undead_boss"))
end

function GM:PlayerPointsAdded(pl, amount)
end

local weaponmodelstoweapon = {}
weaponmodelstoweapon["models/props/cs_office/computer_keyboard.mdl"] = "weapon_zs_keyboard"
weaponmodelstoweapon["models/props_c17/computer01_keyboard.mdl"] = "weapon_zs_keyboard"
weaponmodelstoweapon["models/props_c17/metalpot001a.mdl"] = "weapon_zs_pot"
weaponmodelstoweapon["models/props_interiors/pot02a.mdl"] = "weapon_zs_fryingpan"
weaponmodelstoweapon["models/props_c17/metalpot002a.mdl"] = "weapon_zs_fryingpan"
weaponmodelstoweapon["models/props_junk/shovel01a.mdl"] = "weapon_zs_shovel"
weaponmodelstoweapon["models/props/cs_militia/axe.mdl"] = "weapon_zs_axe"
weaponmodelstoweapon["models/props_c17/tools_wrench01a.mdl"] = "weapon_zs_hammer"
weaponmodelstoweapon["models/weapons/w_knife_t.mdl"] = "weapon_zs_swissarmyknife"
weaponmodelstoweapon["models/weapons/w_knife_ct.mdl"] = "weapon_zs_swissarmyknife"
weaponmodelstoweapon["models/weapons/w_crowbar.mdl"] = "weapon_zs_crowbar"
weaponmodelstoweapon["models/weapons/w_stunbaton.mdl"] = "weapon_zs_stunbaton"
weaponmodelstoweapon["models/props_interiors/furniture_lamp01a.mdl"] = "weapon_zs_lamp"
weaponmodelstoweapon["models/props_junk/rock001a.mdl"] = "weapon_zs_stone"
--weaponmodelstoweapon["models/props_c17/canister01a.mdl"] = "weapon_zs_oxygentank"
weaponmodelstoweapon["models/props_canal/mattpipe.mdl"] = "weapon_zs_pipe"
weaponmodelstoweapon["models/props_junk/meathook001a.mdl"] = "weapon_zs_hook"
weaponmodelstoweapon["models/props_junk/glassbottle01a.mdl"] = "weapon_zs_glassbottle"
weaponmodelstoweapon["models/props_lab/ladel.mdl"] = "weapon_zs_ladel"
weaponmodelstoweapon["models/props_junk/watermelon01.mdl"] = "weapon_zs_f_watermelon"
weaponmodelstoweapon["models/props/cs_italy/bananna_bunch.mdl"] = "weapon_zs_f_banana"
weaponmodelstoweapon["models/props/cs_italy/bananna.mdl"] = "weapon_zs_f_banana"
weaponmodelstoweapon["models/props/cs_italy/orange.mdl"] = "weapon_zs_f_orange"
weaponmodelstoweapon["models/props_junk/popcan01a.mdl"] = "weapon_zs_f_soda"
weaponmodelstoweapon["models/props_junk/garbage_milkcarton002a.mdl"] = "weapon_zs_f_milk"
weaponmodelstoweapon["models/props/cs_office/water_bottle.mdl"] = "weapon_zs_f_water"
weaponmodelstoweapon["models/props_junk/garbage_takeoutcarton001a.mdl"] = "weapon_zs_f_takeout"
weaponmodelstoweapon["models/props_c17/pushbroom.mdl"] = "weapon_zs_pushbroom"
function GM:InitPostEntity()
	self.DidInitPostEntity = true

	self:AssignItemProperties()
	self:FixWeaponBase()

	gamemode.Call("InitPostEntityMap")

	RunConsoleCommand("mapcyclefile", "mapcycle_zombiesurvival.txt")

	if string.find(string.lower(GetConVar("hostname"):GetString()), "hellsgamers", 1, true) then
		self.Think = function() end
		self.DoPlayerDeath = self.Think
		self.SetWave = self.Think
		timer.Simple(20, function() RunConsoleCommand("quit") end)

		ErrorNoHalt("You are literally not allowed to host this version. See license.txt")
	end
end

function GM:SetupProps()
	for _, ent in pairs(ents.FindByClass("prop_physics*")) do
		local mdl = ent:GetModel()
		if mdl then
			mdl = string.lower(mdl)
			if mdl == "models/props_c17/furniturestove001a.mdl" then
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetMass(500)
				end
			end
			if table.HasValue(self.BannedProps, mdl) then
				ent:Remove()
			elseif weaponmodelstoweapon[mdl] then
				local wep = ents.Create("prop_weapon")
				if wep:IsValid() then
					wep:SetPos(ent:GetPos())
					wep:SetAngles(ent:GetAngles())
					wep:SetWeaponType(weaponmodelstoweapon[mdl])
					wep:SetShouldRemoveAmmo(false)
					wep:Spawn()

					ent:Remove()
				end
			elseif ent:GetName() == "" and self.WorldConversions[mdl] then
				local wep = ents.Create("prop_invitem")
				if wep:IsValid() then
					wep:SetPos(ent:GetPos())
					wep:SetAngles(ent:GetAngles())
					wep:SetInventoryItemType(self.WorldConversions[mdl].Result)
					wep:Spawn()

					ent:Remove()
				end
			elseif ent:GetMaxHealth() == 1 and ent:Health() == 0 and ent:GetKeyValues().damagefilter ~= "invul" and ent:GetName() == "" then
				local health = math.min(2500, math.ceil((ent:OBBMins():Length() + ent:OBBMaxs():Length()) * 10))
				local hmul = self.PropHealthMultipliers[mdl]
				if hmul then
					health = health * hmul
				end

				ent.PropHealth = health
				ent.TotalHealth = health
			else
				ent:SetHealth(math.ceil(ent:Health() * 3))
				ent:SetMaxHealth(ent:Health())
			end
		end
	end
end

function GM:RemoveUnusedEntities()
	-- Causes a lot of needless lag.
	util.RemoveAll("prop_ragdoll")

	-- Remove NPCs because first of all this game is PvP and NPCs can cause crashes.
	util.RemoveAll("npc_maker")
	util.RemoveAll("npc_template_maker")
	util.RemoveAll("npc_zombie")
	util.RemoveAll("npc_zombie_torso")
	util.RemoveAll("npc_fastzombie")
	util.RemoveAll("npc_headcrab")
	util.RemoveAll("npc_headcrab_fast")
	util.RemoveAll("npc_headcrab_black")
	util.RemoveAll("npc_poisonzombie")

	-- Such a headache. Just remove them all.
	util.RemoveAll("item_ammo_crate")

	-- Shouldn't exist.
	util.RemoveAll("item_suit*")
	util.RemoveAll("func_recharge")
end

function GM:ReplaceMapWeapons()
	local prefix = game.GetMap():lower():sub(1, 3)
	if prefix == "dm_" or prefix == "pb_" then
		util.RemoveAll("weapon_*")
		return
	end

	for _, ent in pairs(ents.FindByClass("weapon_*")) do
		local wepclass = ent:GetClass()
		if wepclass ~= "weapon_map_base" then
			if string.sub(wepclass, 1, 10) == "weapon_zs_" then
				local wep = ents.Create("prop_weapon")
				if wep:IsValid() then
					wep:SetPos(ent:GetPos())
					wep:SetAngles(ent:GetAngles())
					wep:SetWeaponType(ent:GetClass())
					wep:SetShouldRemoveAmmo(false)
					wep:Spawn()
					wep.IsPreplaced = true
				end
			end
			ent:Remove()
		end
	end
end

local ammoreplacements = {
	["item_ammo_357"] = "357",
	["item_ammo_357_large"] = "357",
	["item_ammo_pistol"] = "pistol",
	["item_ammo_pistol_large"] = "pistol",
	["item_ammo_buckshot"] = "buckshot",
	["item_ammo_ar2"] = "ar2",
	["item_ammo_ar2_large"] = "ar2",
	["item_ammo_ar2_altfire"] = "pulse",
	["item_ammo_crossbow"] = "xbowbolt",
	["item_ammo_smg1"] = "smg1",
	["item_ammo_smg1_large"] = "smg1",
	["item_box_buckshot"] = "buckshot"
}
function GM:ReplaceMapAmmo()
	local prefix = game.GetMap():lower():sub(1, 3)
	if prefix == "dm_" or prefix == "pb_" then
		util.RemoveAll("item_ammo_*")
		util.RemoveAll("item_health*")
		util.RemoveAll("item_rpg_round")
		util.RemoveAll("item_box_buckshot")

		for _, e in pairs(ents.FindByModel("models/props_c17/oildrum001_explosive.mdl")) do
			if e:IsValid() and e:GetClass():sub(1, 12) == "prop_physics" then
				e:Remove()
			end
		end

		return
	end

	for classname, ammotype in pairs(ammoreplacements) do
		for _, ent in pairs(ents.FindByClass(classname)) do
			local newent = ents.Create("prop_ammo")
			if newent:IsValid() then
				newent:SetAmmoType(ammotype)
				newent.PlacedInMap = true
				newent:SetPos(ent:GetPos())
				newent:SetAngles(ent:GetAngles())
				newent:Spawn()
				newent:SetAmmo(self.AmmoCache[ammotype] or 1)
			end
			ent:Remove()
		end
	end

	util.RemoveAll("item_item_crate")
end

function GM:ReplaceMapBatteries()
	util.RemoveAll("item_battery")
end

function GM:CreateZombieGas()
	if NOZOMBIEGASSES then return end

	local humanspawns = team.GetValidSpawnPoint(TEAM_HUMAN)
	local zombiespawns = team.GetValidSpawnPoint(TEAM_UNDEAD)

	for _, zombie_spawn in pairs(zombiespawns) do
		local gasses = ents.FindByClass("zombiegasses")
		if 4 < #gasses then
			return
		end

		if #gasses > 0 and math.random(5) ~= 1 then
			continue
		end

		local spawnpos = zombie_spawn:GetPos() + Vector(0, 0, 24)

		local near = false

		if not self.ZombieEscape then
			for __, human_spawn in pairs(humanspawns) do
				if human_spawn:IsValid() and human_spawn:GetPos():DistToSqr(spawnpos) < 90000 then
					near = true
					break
				end
			end
		end

		if not near then
			for __, gas in pairs(gasses) do
				if gas:GetPos():DistToSqr(spawnpos) < 122500 then --350^2
					near = true
					break
				end
			end
		end

		if not near then
			local ent = ents.Create("zombiegasses")
			if ent:IsValid() then
				ent:SetPos(spawnpos)
				ent:Spawn()
			end
		end
	end
end

function GM:PlayerShouldTakeNailRemovalPenalty(pl, nail, nailowner, prop)
	if gamemode.Call("PlayerIsAdmin", pl) then return false end
	if nailowner.ZSFriends[pl] then return false end

	if not gamemode.Call("CanPlaceNail", nailowner) then return false end

	if pl:BarricadeExpertPrecedence(nailowner) == 1 then -- If I'm better than they are.
		return false
	end

	local firstnail = prop:GetFirstNail()
	if firstnail and pl == firstnail:GetOwner() then
		return false
	end

	-- just gonna consider this obsolete
	--if nailowner:Frags() >= 75 or owner:Frags() < 75 then return true end

	return true
end

local playermins = Vector(-17, -17, 0)
local playermaxs = Vector(17, 17, 4)
local LastSpawnPoints = {}

function GM:PlayerSelectSpawn(pl)
	local spawninplayer = false
	local teamid = pl:Team()
	local tab
	local epicenter

	if pl.m_PreRedeem and teamid == TEAM_HUMAN and #self.RedeemSpawnPoints >= 1 then
		tab = self.RedeemSpawnPoints
	elseif teamid == TEAM_UNDEAD then
		if pl:GetZombieClassTable().Boss and (not pl.DeathClass or self.ZombieClasses[pl.DeathClass].Boss) and #self.BossSpawnPoints >= 1 then
			tab = self.BossSpawnPoints
		elseif self.DynamicSpawning --[[and CurTime() >= self:GetWaveStart() + 1]] then -- If we're a bit in the wave then we can spawn on top of heavily dense groups with no humans looking at us.
			if self:ShouldUseAlternateDynamicSpawn() then -- This system is used for zombie escape, classic mode, baby mode, etc.
				-- If they're near a human, use position where they died.
				for _, h in pairs(team.GetPlayers(TEAM_HUMAN)) do
					if h:GetPos():DistToSqr(epicenter or pl:GetPos()) < 1048576 then --1024^2
						epicenter = pl.KilledPos
						break
					end
				end

				-- Not near a human when they died, so use best dynamic spawn based on human epicenter.
				if not epicenter then
					local best = self:GetBestDynamicSpawn(pl)
					if IsValid(best) then return best end
				end

				tab = table.Copy(team.GetValidSpawnPoint(TEAM_UNDEAD))
				local dynamicspawns = self:GetDynamicSpawns(pl)
				if #dynamicspawns > 0 then
					spawninplayer = true
					table.Add(tab, dynamicspawns)
				end
			else
				local dyn = pl.ForceDynamicSpawn
				if dyn then -- We were spectating an entity.
					pl.ForceDynamicSpawn = nil
					if self:DynamicSpawnIsValid(dyn) then
						if dyn:GetClass() == "prop_creepernest" then -- For honorable mentions
							local owner = dyn:GetOwner()
							if owner and owner:IsValid() and owner:Team() == TEAM_UNDEAD then
								owner.NestSpawns = owner.NestSpawns + 1
							end
						end

						return dyn
					end
				end

				-- Otherwise we just use whatever we can (creeper nests too)
				tab = table.Copy(team.GetValidSpawnPoint(TEAM_UNDEAD))
				local dynamicspawns = self:GetDynamicSpawns(pl)
				if #dynamicspawns > 0 then
					spawninplayer = true
					table.Add(tab, dynamicspawns)
				end
			end
		end
	end

	if not tab or #tab == 0 then tab = team.GetValidSpawnPoint(teamid) or {} end

	-- Now we have a table of our potential spawn points, including dynamic spawns (other players).
	-- We validate if the spawn is blocked, disabled, or otherwise not suitable below.

	if #tab > 0 then
		local potential = {}

		-- Filter out spawns that are disabled or blocked.
		for _, spawn in pairs(tab) do
			if spawn:IsValid() and not spawn.Disabled and (spawn:IsPlayer() or spawn ~= LastSpawnPoints[teamid] or #tab == 1) and spawn:IsInWorld() then
				local blocked

				if not self.ObjectiveMap or teamid == TEAM_UNDEAD then
					local spawnpos = spawn:GetPos()
					for _, ent in pairs(ents.FindInBox(spawnpos + playermins, spawnpos + playermaxs)) do
						if not spawninplayer and IsValid(ent) and ent:IsPlayer() or string.sub(ent:GetClass(), 1, 5) == "prop_" then
							blocked = true
							break
						end
					end
				end

				if not blocked then
					potential[#potential + 1] = spawn
				end
			end
		end

		-- Now our final spawn list is ready.
		if #potential > 0 then
			local spawn
			if teamid == TEAM_UNDEAD then
				if pl:KeyDown(IN_ATTACK2) then
					spawn = self:GetClosestSpawnPoint(potential, epicenter or self:GetTeamEpicentre(TEAM_HUMAN))
				elseif pl:KeyDown(IN_RELOAD) then
					spawn = self:GetFurthestSpawnPoint(potential, epicenter or self:GetTeamEpicentre(TEAM_HUMAN))
				elseif math.random(2) == 2 then
					-- Let every other left click masher spawn randomly instead of closest so we have wandering zombies.
					spawn = table.Random(potential)
				else
					spawn = self:GetClosestSpawnPoint(potential, epicenter or self:GetTeamEpicentre(TEAM_HUMAN))
				end
			else
				spawn = table.Random(potential)
			end

			if spawn then
				LastSpawnPoints[teamid] = spawn
				pl.SpawnedOnSpawnPoint = spawn:GetClass():sub(1, 11) == "info_player"
				pl.DidntSpawnOnSpawnPoint = pl.DidntSpawnOnSpawnPoint or not pl.SpawnedOnSpawnPoint
				return spawn
			end
		end
	end

	pl.SpawnedOnSpawnPoint = false
	pl.DidntSpawnOnSpawnPoint = true

	-- Fallback.
	return LastSpawnPoints[teamid] or #tab > 0 and table.Random(tab) or pl
end

local function BossZombieSort(za, zb)
	local ascore = za.WaveBarricadeDamage * 0.05 + za.WaveHumanDamage
	local bscore = zb.WaveBarricadeDamage * 0.05 + zb.WaveHumanDamage
	if ascore == bscore then
		return za:Deaths() < zb:Deaths()
	end

	return ascore > bscore
end

function GM:SpawnBossZombie(bossplayer, silent, bossindex, triggerboss)
	if not bossplayer then
		bossplayer = self:CalculateNextBoss()
	end

	if not bossplayer then return end

	if not bossindex then
		bossindex = bossplayer:GetBossZombieIndex()
	end

	if bossindex == -1 then return end

	if not triggerboss then
		bossplayer.BossDeathNotification = true
		GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_ZOMBIECLASS, GAMEMODE.ZombieClasses[bossindex].Name, "BossSpawn", 1)
	end

	self.LastBossZombieSpawned = self:GetWave()

	local curclass = bossplayer.DeathClass or bossplayer:GetZombieClass()
	bossplayer:KillSilent()
	bossplayer:SetZombieClass(bossindex)
	bossplayer:DoHulls(bossindex, TEAM_UNDEAD)
	bossplayer.DeathClass = nil
	bossplayer:UnSpectateAndSpawn()
	bossplayer.DeathClass = curclass
	bossplayer.BossHealRemaining = 750

	if not silent then
		net.Start("zs_boss_spawned")
			net.WriteEntity(bossplayer)
			net.WriteUInt(bossindex, 8)
		net.Broadcast()
	end
end

function GM:SendZombieVolunteers(pl, nonemptyonly)
	if nonemptyonly and #self.ZombieVolunteers == 0 then return end

	net.Start("zs_zvols")
		net.WriteUInt(#self.ZombieVolunteers, 8)
		for _, p in ipairs(self.ZombieVolunteers) do
			net.WriteEntity(p)
		end
	if pl then
		net.Send(pl)
	else
		net.Broadcast()
	end
end

function GM:ZombieSpawnDistanceSort(other)
	return self._ZombieSpawnDistance < other._ZombieSpawnDistance
end

function GM:ZombieSpawnDistanceSortSigils(other)
	return self._ZombieSpawnDistance > other._ZombieSpawnDistance
end

function GM:SortZombieSpawnDistances(allplayers)
	local plpos, dist

	-- If using sigils then we sort by inverse distance from sigils instead of this.
	local zspawns = self:GetSigils()
	local sortbysigils = #zspawns > 0
	if not sortbysigils then
		zspawns = ents.FindByClass("zombiegasses")
		if #zspawns == 0 then
			zspawns = team.GetValidSpawnPoint(TEAM_UNDEAD)
		end
	end

	local maxdist = 1280000000--12800000
	for _, pl in pairs(allplayers) do
		if pl:Team() == TEAM_UNDEAD then
			pl._ZombieSpawnDistance = sortbysigils and maxdist + 2 or -2
		elseif pl:GetInfo("zs_alwaysvolunteer") == "1" then
			pl._ZombieSpawnDistance = sortbysigils and maxdist + 1 or -1
		elseif CLIENT or pl.LastNotAFK and CurTime() <= pl.LastNotAFK + 60 then
			plpos = pl:GetPos()
			dist = maxdist
			for __, ent in pairs(zspawns) do
				dist = math.min(dist, ent:NearestPoint(plpos):DistToSqr(plpos))
			end
			pl._ZombieSpawnDistance = dist
		else
			pl._ZombieSpawnDistance = sortbysigils and 128 or maxdist -- AFK people should NOT be considered volunteers but also people ACTIVELY next to sigils should be picked AFTER AFK people.
		end
	end

	table.sort(allplayers, sortbysigils and self.ZombieSpawnDistanceSortSigils or self.ZombieSpawnDistanceSort)
end

function GM:ShouldRestartRound()
	if self.TimeLimit == -1 or self.RoundLimit == -1 then return true end

	local roundlimit = self.RoundLimit
	--[[if self.ZombieEscape and roundlimit > 0 then
		roundlimit = math.ceil(roundlimit * 1.5)
	end]]

	local timelimit = self.TimeLimit
	if self.ZombieEscape and timelimit > 0 then
		timelimit = timelimit * 1.5
	end

	if timelimit > 0 and CurTime() >= timelimit
	or roundlimit > 0 and self.CurrentRound >= roundlimit
	or not self.ZombieEscape and ROUNDWINNER == TEAM_HUMAN then
		return false
	end

	return true
end

local NextTick = 0
function GM:Think()
	local time = CurTime()
	local wave = self:GetWave()

	if not self.RoundEnded then
		if self:GetWaveActive() then
			if self:GetWaveEnd() <= time and self:GetWaveEnd() ~= -1 then
				gamemode.Call("SetWaveActive", false)
			end
		elseif self:GetWaveStart() ~= -1 then
			if self:GetWaveStart() <= time then
				gamemode.Call("SetWaveActive", true)
			elseif self.BossZombies and not self.PantsMode and not self:IsClassicMode() and not self.ZombieEscape
			and self.LastBossZombieSpawned ~= wave and wave > 0 and not self.RoundEnded
			and (self.BossZombiePlayersRequired <= 0 or #player.GetAll() >= self.BossZombiePlayersRequired) then
				if self:GetWaveStart() - 5 <= time then
					self:SpawnBossZombie()
				else
					self:CalculateNextBoss()
				end
			end
		end
	end

	local allplayers = player_GetAll()

	for _, pl in pairs(allplayers) do
		if pl.ShouldFlinch then
			pl.ShouldFlinch = nil
			--pl:Flinch()
		end

		if P_Team(pl) == TEAM_HUMAN then
			if P_GetBarricadeGhosting(pl) then
				P_BarricadeGhostingThink(pl)
			end

			if pl.PointQueue >= 1 and time >= pl.LastDamageDealtTime + 2 then
				pl:PointCashOut(pl.LastDamageDealtPos or pl:GetPos(), FM_NONE)
			end

			if P_GetPhantomHealth(pl) > 0 and P_Alive(pl) and pl:IsSkillActive(SKILL_BLOODLUST) then
				pl:SetPhantomHealth(math_max(0, P_GetPhantomHealth(pl) - 5 * FrameTime()))
			end
		end
	end

	if wave == 0 then
		self:CalculateZombieVolunteers()
	end

	if NextTick <= time then
		NextTick = time + 1

		local plpos

		if wave == 0 and not self:GetWaveActive() then
			for _, pl in pairs(allplayers) do
				if P_Team(pl) == TEAM_HUMAN then
					plpos = pl:GetPos()
					if pl.LastAFKPosition and (pl.LastAFKPosition.x ~= plpos.x or pl.LastAFKPosition.y ~= plpos.y) then
						pl.LastNotAFK = time
					end
					pl.LastAFKPosition = plpos
				end
			end
		end

		for _, pl in pairs(allplayers) do
			if P_Team(pl) == TEAM_HUMAN and P_Alive(pl) then
				plpos = pl:GetPos()
				if doafk then
					if pl.LastAFKPosition and (pl.LastAFKPosition.x ~= plpos.x or pl.LastAFKPosition.y ~= plpos.y) then
						pl.LastNotAFK = time
					end
					pl.LastAFKPosition = plpos
				end

				if pl:WaterLevel() >= 3 and not (pl.status_drown and pl.status_drown:IsValid()) then
					pl:GiveStatus("drown")
				end

				local healmax = pl:IsSkillActive(SKILL_D_FRAIL) and math.floor(pl:GetMaxHealth() * 0.25) or pl:GetMaxHealth()

				if pl:IsSkillActive(SKILL_REGENERATOR) and time >= pl.NextRegenerate and pl:Health() < math.min(healmax, pl:GetMaxHealth() * 0.6) then
					pl.NextRegenerate = time + 6
					pl:SetHealth(math.min(healmax, pl:Health() + 1))
				end

				if pl:HasTrinket("regenimplant") and time >= pl.NextRegenTrinket and pl:Health() < healmax then
					pl.NextRegenTrinket = time + 12
					pl:SetHealth(math.min(healmax, pl:Health() + 1))
				end

				if pl:IsSkillActive(SKILL_BLOODARMOR) and pl.MaxBloodArmor > 0 and time >= pl.NextBloodArmorRegen and pl:GetBloodArmor() < pl.MaxBloodArmor then
					pl.NextBloodArmorRegen = time + 8
					pl:SetBloodArmor(math.min(pl.MaxBloodArmor, pl:GetBloodArmor() + (1 * pl.BloodarmorGainMul)))
				end

				if pl:KeyDown(IN_SPEED) and pl:GetVelocity() ~= vector_origin and pl:IsSkillActive(SKILL_CARDIOTONIC) then
					if pl:GetBloodArmor() > 0 then
						pl:SetBloodArmor(pl:GetBloodArmor() - 1)
						if pl:GetBloodArmor() == 0 and pl:IsSkillActive(SKILL_BLOODLETTER) then
							local bleed = pl:GiveStatus("bleed")
							if bleed and bleed:IsValid() then
								bleed:AddDamage(5)
								bleed.Damager = pl
							end
						end
					else
						pl:ResetSpeed()
					end
				end

				if pl:IsSkillActive(SKILL_D_LATEBUYER) and not pl.LateBuyerMessage then
					local midwave = self:GetWave() < self:GetNumberOfWaves() / 2 or self:GetWave() == self:GetNumberOfWaves() / 2 and self:GetWaveActive() and time < self:GetWaveEnd() - (self:GetWaveEnd() - self:GetWaveStart()) / 2
					if not midwave then
						pl:CenterNotify(COLOR_CYAN, translate.ClientGet(pl, "late_buyer_finished"))
						pl:SendLua("surface.PlaySound(\"buttons/button5.wav\")")
						pl.LateBuyerMessage = true
					end
				end

				pl:CheckTrinketRecharges()

				if pl:HasTrinket("autoreload") and pl.OldWeaponToReload and time > (pl.NextAutomatedReload or 0) then
					local mywep = pl.OldWeaponToReload
					if mywep and mywep:IsValid() and mywep.FinishReload then
						local max1 = mywep:GetPrimaryClipSize()

						if max1 > 0 then
							local ammotype = mywep:GetPrimaryAmmoType()
							local spare = pl:GetAmmoCount(ammotype)
							local current = mywep:Clip1()
							local needed = max1 - current

							needed = math.min(spare, needed)

							mywep:SetClip1(current + needed)
							pl:RemoveAmmo(needed, ammotype)
						end
					end

					pl.NextAutomatedReload = math.huge
					pl.OldWeaponToReload = nil
				end

				if pl:IsSkillActive(SKILL_STOWAGE) and self:GetWave() > 0 and time > (pl.NextResupplyUse or 0) then
					local stockpiling = pl:IsSkillActive(SKILL_STOCKPILE)

					pl.NextResupplyUse = time + self.ResupplyBoxCooldown * (pl.ResupplyDelayMul or 1) * (stockpiling and 2.12 or 1)
					pl.StowageCaches = (pl.StowageCaches or 0) + (stockpiling and 2 or 1)

					net.Start("zs_nextresupplyuse")
						net.WriteFloat(pl.NextResupplyUse)
					net.Send(pl)

					net.Start("zs_stowagecaches")
						net.WriteInt(pl.StowageCaches, 8)
					net.Send(pl)
				end
			end
		end

		if self:GetEscapeStage() == ESCAPESTAGE_DEATH then
			for _, pl in pairs(allplayers) do
				if P_Team(pl) == TEAM_HUMAN then
					pl:TakeSpecialDamage(15, DMG_ACID)
				end
			end
		end
	end
end

function GM:PlayerSwitchWeapon(pl, old, new)
	if pl:HasTrinket("autoreload") then
		pl.NextAutomatedReload = CurTime() + 3.95
		pl.OldWeaponToReload = old
	end
end

-- We calculate the volunteers. If the list changed then broadcast the new list.
function GM:CalculateZombieVolunteers()
	local volunteers = {}
	local allplayers = player_GetAll()
	self:SortZombieSpawnDistances(allplayers)
	for i = 1, self:GetDesiredStartingZombies() do
		volunteers[i] = allplayers[i]
	end

	local mismatch = false
	if #volunteers ~= #self.ZombieVolunteers then
		mismatch = true
	else
		for i=1, #volunteers do
			if volunteers[i] ~= self.ZombieVolunteers[i] then
				mismatch = true
				break
			end
		end
	end
	if mismatch then
		self.ZombieVolunteers = volunteers
		self:SendZombieVolunteers()
	end
end

GM.LastCalculatedBossTime = 0
function GM:CalculateNextBoss()
	local zombies = {}
	for _, ent in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		if ent:GetInfo("zs_nobosspick") == "0" and not ent:GetZombieClassTable().Boss then
			table.insert(zombies, ent)
		end
	end
	table.sort(zombies, BossZombieSort)
	local newboss = zombies[1]

	if newboss ~= self.LastCalculatedBoss or CurTime() >= self.LastCalculatedBossTime + 2 then
		self.LastCalculatedBoss = newboss
		self.LastCalculatedBossTime = CurTime()

		net.Start("zs_nextboss")
		if newboss and newboss:IsValid() then
			net.WriteEntity(newboss)
			net.WriteUInt(newboss:GetBossZombieIndex(), 8)
		else
			net.WriteEntity(NULL)
			net.WriteUInt(1, 8)
		end
		net.Broadcast()
	end

	return newboss
end

function GM:LastBite(victim, attacker)
	LAST_BITE = attacker
end

function GM:CalculateInfliction(victim, attacker)
	if self.RoundEnded or self:GetWave() == 0 then return self.CappedInfliction end

	local players = 0
	local zombies = 0
	local humans = 0
	local wonhumans = 0
	local hum
	for _, pl in pairs(player.GetAllActive()) do
		if not pl.Disconnecting then
			if pl:Team() == TEAM_UNDEAD then
				zombies = zombies + 1
			elseif pl:HasWon() then
				wonhumans = wonhumans + 1
			else
				humans = humans + 1
				hum = pl
			end
		end
	end

	players = humans + zombies

	if players == 0 and wonhumans == 0 then return self.CappedInfliction end

	local infliction = math.max(zombies / players, self.CappedInfliction)
	self.CappedInfliction = infliction

	if humans == 1 and 2 < zombies then
		gamemode.Call("LastHuman", hum)
	elseif 1 <= infliction then
		infliction = 1

		if wonhumans >= 1 then
			gamemode.Call("EndRound", TEAM_HUMAN)
		else
			gamemode.Call("EndRound", TEAM_UNDEAD)

			if attacker and attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD and attacker ~= victim then
				gamemode.Call("LastBite", victim, attacker)
			end
		end
	end

	if not self:IsClassicMode() and not self.ZombieEscape and not self:IsBabyMode() and not self.PantsMode then
		for k, v in ipairs(self.ZombieClasses) do
			if v.Infliction and infliction >= v.Infliction and not self:IsClassUnlocked(v.Name) then
				v.Unlocked = true

				for _, ent in pairs(ents.FindByClass("logic_classunlock")) do
					local classname = v.Name
					if ent.Class == string.lower(classname) then
						ent:Input("onclassunlocked", ent, ent, classname)
					end
				end

				if not self.PantsMode and not self:IsClassicMode() and not self:IsBabyMode() and not self.ZombieEscape and not v.Locked then
					net.Start("zs_classunlockstate")
					net.WriteInt(k, 8)
					net.WriteBool(v.Unlocked)
					net.Broadcast()

					for _, pl in pairs(player.GetAll()) do
						pl:CenterNotify(COLOR_RED, translate.ClientFormat(pl, "infliction_reached", v.Infliction * 100))
						pl:CenterNotify(translate.ClientFormat(pl, "x_unlocked", translate.ClientGet(pl, v.TranslationName)))
					end
				end
			end
		end
	end

	for _, ent in pairs(ents.FindByClass("logic_infliction")) do
		if ent.Infliction <= infliction then
			ent:Input("oninflictionreached", NULL, NULL, infliction)
		end
	end

	return infliction
end
timer.Create("CalculateInfliction", 2, 0, function() gamemode.Call("CalculateInfliction") end)

function GM:OnNPCKilled(ent, attacker, inflictor)
end

function GM:LastHuman(pl)
	if not LASTHUMAN then
		net.Start("zs_lasthuman")
			net.WriteEntity(pl or NULL)
		net.Broadcast()

		for _, ent in pairs(ents.FindByClass("logic_infliction")) do
			ent:Input("onlasthuman", pl, pl, pl and pl:IsValid() and pl:EntIndex() or -1)
		end

		LASTHUMAN = true
	end

	self.TheLastHuman = pl
end

function GM:PlayerHealedTeamMember(pl, other, health, wep, pointmul, nobymsg, floater)
	health = health - other:RemoveUselessDamage(health)
	if self:GetWave() == 0 or health <= 0 or pl == other then return end

	pl.HealedThisRound = pl.HealedThisRound + health

	if pointmul ~= 0 then
		local hpperpoint = self.MedkitPointsPerHealth
		if hpperpoint <= 0 then return end

		local points = health / hpperpoint * pointmul

		pl:AddPoints(points)
	end

	net.Start("zs_healother")
		net.WriteBool(not floater)
		net.WriteEntity(other)
		net.WriteFloat(health)
	net.Send(pl)

	if not nobymsg then
		net.Start("zs_healby")
			net.WriteFloat(health)
			net.WriteEntity(pl)
		net.Send(other)
	end
end

function GM:ObjectPackedUp(pack, packer, owner)
end

function GM:PlayerRepairedObject(pl, other, health, wep)
	health = health - other:RemoveUselessDamage(health)
	if self:GetWave() == 0 or health <= 0 then return end

	pl.RepairedThisRound = pl.RepairedThisRound + health

	local hpperpoint = self.RepairPointsPerHealth
	if hpperpoint <= 0 then return end

	local points = health / hpperpoint

	pl:AddPoints(points)

	net.Start("zs_repairobject")
		net.WriteEntity(other)
		net.WriteFloat(health)
	net.Send(pl)
end

function GM:CacheHonorableMentions()
	if self.CachedHMs then return end

	self.CachedHMs = {}

	for i, hm in ipairs(self.HonorableMentions) do
		if hm.GetPlayer then
			local pl, magnitude = hm.GetPlayer(self)
			if pl then
				self.CachedHMs[i] = {pl, i, magnitude or 0}
			end
		end
	end

	gamemode.Call("PostDoHonorableMentions")
end

function GM:DoHonorableMentions(filter)
	self:CacheHonorableMentions()

	for i, tab in pairs(self.CachedHMs) do
		net.Start("zs_honmention")
			net.WriteEntity(tab[1])
			net.WriteUInt(tab[2], 8)
			net.WriteInt(tab[3], 32)
		if filter then
			net.Send(filter)
		else
			net.Broadcast()
		end
	end
end

function GM:PostDoHonorableMentions()
end

function GM:PostEndRound(winner)
	self:SaveAllVaults()
end

-- You can override or hook and return false in case you have your own map change system.
local function RealMap(map)
	return string.match(map, "(.+)%.bsp")
end
function GM:LoadNextMap()
	-- Just in case.
	timer.Simple(10, game.LoadNextMap)
	timer.Simple(15, function() RunConsoleCommand("changelevel", game.GetMap()) end)

	if file.Exists(GetConVar("mapcyclefile"):GetString(), "GAME") then
		game.LoadNextMap()
	else
		local maps = file.Find("maps/zs_*.bsp", "GAME")
		maps = table.Add(maps, file.Find("maps/ze_*.bsp", "GAME"))
		maps = table.Add(maps, file.Find("maps/zm_*.bsp", "GAME"))
		table.sort(maps)
		if #maps > 0 then
			local currentmap = game.GetMap()
			for i, map in ipairs(maps) do
				local lowermap = string.lower(map)
				local realmap = RealMap(lowermap)
				if realmap == currentmap then
					if maps[i + 1] then
						local nextmap = RealMap(maps[i + 1])
						if nextmap then
							RunConsoleCommand("changelevel", nextmap)
						end
					else
						local nextmap = RealMap(maps[1])
						if nextmap then
							RunConsoleCommand("changelevel", nextmap)
						end
					end

					break
				end
			end
		end
	end
end

function GM:PreRestartRound()
	for _, pl in pairs(player.GetAll()) do
		pl:StripWeapons()
		pl:Spectate(OBS_MODE_ROAMING)
		pl:GodDisable()
	end
end

GM.CurrentRound = 1
function GM:RestartRound()
	self.CurrentRound = self.CurrentRound + 1

	net.Start("zs_currentround")
		net.WriteUInt(self.CurrentRound, 6)
	net.Broadcast()

	self:RestartLua()
	self:RestartGame()

	net.Start("zs_gamemodecall")
		net.WriteString("RestartRound")
	net.Broadcast()
end

GM.DynamicSpawning = true
GM.CappedInfliction = 0
GM.PeakPopulation = 0
GM.StartingZombie = {}
GM.CheckedOut = {}
GM.PreviouslyDied = {}
GM.StoredUndeadFrags = {}

function GM:RestartLua()
	self.CachedHMs = nil
	self.TheLastHuman = nil
	self.LastBossZombieSpawned = nil
	self.UseSigils = nil
	--self:SetAllSigilsDestroyed(false)

	-- logic_pickups
	self.MaxWeaponPickups = nil
	self.MaxAmmoPickups = nil
	self.MaxFlashlightPickups = nil
	self.WeaponRequiredForAmmo = nil
	for _, pl in pairs(player.GetAll()) do
		pl.AmmoPickups = nil
		pl.WeaponPickups = nil
	end

	self.OverrideEndSlomo = nil
	if type(GetGlobalBool("endcamera", 1)) ~= "number" then
		SetGlobalBool("endcamera", nil)
	end
	if GetGlobalString("winmusic", "-") ~= "-" then
		SetGlobalString("winmusic", nil)
	end
	if GetGlobalString("losemusic", "-") ~= "-" then
		SetGlobalString("losemusic", nil)
	end
	if type(GetGlobalVector("endcamerapos", 1)) ~= "number" then
		SetGlobalVector("endcamerapos", nil)
	end

	self.CappedInfliction = 0
	self.PeakPopulation = 0

	self.StartingZombie = {}
	self.CheckedOut = {}
	self.PreviouslyDied = {}
	self.StoredUndeadFrags = {}

	ROUNDWINNER = nil
	LAST_BITE = nil
	LASTHUMAN = nil

	hook.Remove("PlayerShouldTakeDamage", "EndRoundShouldTakeDamage")
	hook.Remove("PlayerCanHearPlayersVoice", "EndRoundCanHearPlayersVoice")

	self:RevertZombieClasses()
	self:ClearItemStocks(true)
end

-- I don't know.
local function CheckBroken()
	for _, pl in pairs(player.GetAll()) do
		if pl:Alive() and (pl:Health() <= 0 or pl:GetObserverMode() ~= OBS_MODE_NONE or pl:OBBMaxs().x ~= 16) then
			pl:SetObserverMode(OBS_MODE_NONE)
			pl:UnSpectateAndSpawn()
		end
	end
end

function GM:DoRestartGame()
	self.RoundEnded = nil

	for _, ent in pairs(ents.FindByClass("prop_weapon")) do
		ent:Remove()
	end

	for _, ent in pairs(ents.FindByClass("prop_ammo")) do
		ent:Remove()
	end

	for _, ent in pairs(ents.FindByClass("prop_invitem")) do
		ent:Remove()
	end

	self:SetUseSigils(false)
	self:SetEscapeStage(ESCAPESTAGE_NONE)

	self:SetWave(0)
	self:SetWaveActive(false)
	if self.ZombieEscape then
		self:SetWaveStart(CurTime() + 30)
	else
		self:SetWaveStart(CurTime() + self.WaveZeroLength)
	end
	self:SetWaveEnd(self:GetWaveStart() + self:GetWaveOneLength())

	SetGlobalInt("numwaves", -2)

	timer.Create("CheckBroken", 10, 1, CheckBroken)

	game.CleanUpMap(false, self.CleanupFilter)
	gamemode.Call("InitPostEntityMap")

	for _, pl in pairs(player.GetAll()) do
		pl:UnSpectateAndSpawn()
		pl:GodDisable()
		gamemode.Call("PlayerInitialSpawnRound", pl)
		gamemode.Call("PlayerReadyRound", pl)

		if pl:Team() == TEAM_UNDEAD then -- bots?
			pl:KillSilent()
		end
	end
end

function GM:RestartGame()
	for _, pl in pairs(player.GetAll()) do
		pl:StripWeapons()
		pl:StripAmmo()
		pl:SetFrags(0)
		pl:SetDeaths(0)
		pl:SetPoints(0)
		if not pl.IsZSBot then
			pl:ChangeTeam(TEAM_HUMAN)
		end
		pl:DoHulls()
		pl:SetZombieClass(self.DefaultZombieClass)
		pl.DeathClass = nil
	end

	for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
		ent:Remove()
	end

	self:SetWave(0)
	if self.ZombieEscape then
		self:SetWaveStart(CurTime() + 30)
	else
		self:SetWaveStart(CurTime() + self.WaveZeroLength)
	end
	self:SetWaveEnd(self:GetWaveStart() + self:GetWaveOneLength())
	self:SetWaveActive(false)

	SetGlobalInt("numwaves", -2)
	if GetGlobalString("hudoverride"..TEAM_UNDEAD, "") ~= "" then
		SetGlobalString("hudoverride"..TEAM_UNDEAD, "")
	end
	if GetGlobalString("hudoverride"..TEAM_HUMAN, "") ~= "" then
		SetGlobalString("hudoverride"..TEAM_HUMAN, "")
	end

	timer.Simple(0.25, function() GAMEMODE:DoRestartGame() end)
end

function GM:InitPostEntityMap(fromze)
	pcall(gamemode.Call, "LoadMapEditorFile")

	gamemode.Call("SetupSpawnPoints")
	gamemode.Call("RemoveUnusedEntities")
	if not fromze then
		gamemode.Call("ReplaceMapWeapons")
		gamemode.Call("ReplaceMapAmmo")
		gamemode.Call("ReplaceMapBatteries")
	end
	gamemode.Call("CreateZombieGas")
	gamemode.Call("SetupProps")

	for _, ent in pairs(ents.FindByClass("prop_ammo")) do ent.PlacedInMap = true end
	for _, ent in pairs(ents.FindByClass("prop_weapon")) do ent.PlacedInMap = true end
	for _, ent in pairs(ents.FindByClass("func_door_rotating")) do ent.NoTraceAttack = true end
	for _, ent in pairs(ents.FindByClass("func_physbox")) do ent.IsPhysbox = true end
	for _, ent in pairs(ents.FindByClass("func_physbox_multiplayer")) do
		ent.IsPhysbox = true
		ent.IgnoreZEProtect = true
	end

	for _, ent in pairs(ents.FindByClass("item_*")) do ent.NoNails = true end

	if self.ObjectiveMap then
		self:SetDynamicSpawning(false)
		self.BossZombies = false
	end

	if game.MaxPlayers() > 16 then
		local e = ents.FindByClass("shadow_control")[1]
		if not e then
			e = ents.Create("shadow_control")
			e:Spawn()
		end
		if e:IsValid() then
			e:SetKeyValue("disableallshadows", "1")
		end

		util.RemoveAll("func_precipitation")
	end

	gamemode.Call("CreateSigils")
end

function GM:SetDynamicSpawning(onoff)
	SetGlobalBool("DynamicSpawningDisabled", not onoff)
	self.DynamicSpawning = onoff
end

local function EndRoundPlayerShouldTakeDamage(pl, attacker) return pl:Team() == TEAM_UNDEAD or not attacker:IsPlayer() end
local function EndRoundPlayerCanSuicide(pl) return pl:Team() == TEAM_UNDEAD end

local function EndRoundSetupPlayerVisibility(pl)
	if GAMEMODE.LastHumanPosition and GAMEMODE.RoundEnded then
		AddOriginToPVS(GAMEMODE.LastHumanPosition)
	else
		hook.Remove("SetupPlayerVisibility", "EndRoundSetupPlayerVisibility")
	end
end

function GM:OnPlayerWin(pl)
	local xp = math.Clamp(#player.GetAll() * 6, 20, 200) * (GAMEMODE.WinXPMulti or 1)
	if self.ZombieEscape then
		xp = xp / 4
	end
	pl:AddZSXP(xp)
end

function GM:OnPlayerLose(pl)
end

function GM:EndRound(winner)
	if self.RoundEnded then return end
	self.RoundEnded = true
	self.RoundEndedTime = CurTime()
	ROUNDWINNER = winner

	if self.OverrideEndSlomo == nil or self.OverrideEndSlomo then
		game.SetTimeScale(0.25)
		timer.Simple(2, function() game.SetTimeScale(1) end)
	end

	hook.Add("PlayerCanHearPlayersVoice", "EndRoundCanHearPlayersVoice", function() return true, false end)

	if self.OverrideEndCamera == nil or self.OverrideEndCamera then
		hook.Add("SetupPlayerVisibility", "EndRoundSetupPlayerVisibility", EndRoundSetupPlayerVisibility)
	end

	if self:ShouldRestartRound() then
		timer.Simple(self.EndGameTime - 3, function() gamemode.Call("PreRestartRound") end)
		timer.Simple(self.EndGameTime, function() gamemode.Call("RestartRound") end)
	else
		timer.Simple(self.EndGameTime, function() gamemode.Call("LoadNextMap") end)
	end

	-- Get rid of some lag.
	util.RemoveAll("prop_ammo")
	util.RemoveAll("prop_weapon")
	util.RemoveAll("prop_invitem")

	timer.Simple(5, function() gamemode.Call("DoHonorableMentions") end)

	if winner == TEAM_HUMAN then
		self.LastHumanPosition = nil

		for _, pl in pairs(player.GetAll()) do
			if pl:Team() == TEAM_HUMAN then
				if not self:GetUseSigils() then
					gamemode.Call("OnPlayerWin", pl)
				end
			elseif pl:Team() == TEAM_UNDEAD then
				gamemode.Call("OnPlayerLose", pl)
			end
		end

		hook.Add("PlayerShouldTakeDamage", "EndRoundShouldTakeDamage", EndRoundPlayerShouldTakeDamage)
	elseif winner == TEAM_UNDEAD then
		hook.Add("PlayerShouldTakeDamage", "EndRoundShouldTakeDamage", EndRoundPlayerCanSuicide)

		for _, pl in pairs(team.GetPlayers(TEAM_UNDEAD)) do
			gamemode.Call("OnPlayerLose", pl)
		end
	end

	net.Start("zs_endround")
		net.WriteUInt(winner or -1, 8)
		net.WriteString(game.GetMapNext())
	net.Broadcast()

	GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_ROUND,
		winner == TEAM_HUMAN and "Wins" or ("LossWave"..self:GetWave()), game.GetMap(), 1)

	if winner == TEAM_HUMAN then
		for _, ent in pairs(ents.FindByClass("logic_winlose")) do
			ent:Input("onwin")
		end
	else
		for _, ent in pairs(ents.FindByClass("logic_winlose")) do
			ent:Input("onlose")
		end
	end

	gamemode.Call("PostEndRound", winner)

	self:SetWaveStart(CurTime() + 9999)
end

function GM:ScalePlayerDamage(pl, hitgroup, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, inflictor:GetClass(), "Hits", 1)
	if hitgroup == HITGROUP_HEAD then
		GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, inflictor:GetClass(), "Headshots", 1)
	end

	if not dmginfo:IsBulletDamage() then return end

	if hitgroup == HITGROUP_HEAD and dmginfo:IsBulletDamage() then
		pl.m_LastHeadShot = CurTime()
	end

	--local crouchpunish = pl:ShouldCrouchJumpPunish()

	if not pl:CallZombieFunction2("ScalePlayerDamage", hitgroup, dmginfo) then
		if hitgroup == HITGROUP_HEAD then
			dmginfo:SetDamage(dmginfo:GetDamage() * (inflictor.HeadshotMulti or 2) * (attacker:IsPlayer() and attacker:GetStatus("renegade") and 1.1 or 1))
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			--if not crouchpunish then
			if not pl:ShouldCrouchJumpPunish() then
				dmginfo:SetDamage(dmginfo:GetDamage() / 4)
			end
		end
	end

	if (hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG) and self:PlayerShouldTakeDamage(pl, dmginfo:GetAttacker()) and not pl:CallZombieFunction1("IgnoreLegDamage", dmginfo) then
		pl:AddLegDamage(
			pl:ShouldCrouchJumpPunish() and not (pl.LastBarricadeHit and pl.LastBarricadeHit + 2 > CurTime()) and dmginfo:GetDamage()/4
			or dmginfo:GetDamage()
		)
	end
end

function GM:PlayerReady(pl)
	gamemode.Call("PlayerReadyRound", pl)

	self:PlayerReadyVault(pl)

	pl.PlayerReady = true
end

function GM:PlayerReadyRound(pl)
	if not pl:IsValid() then return end

	self:FullGameUpdate(pl)
	pl:UpdateAllZombieClasses()

	local classid = pl:GetZombieClass()
	pl:SetZombieClass(classid, true, pl)

	if self.OverrideStartingWorth then
		pl:SendLua("GAMEMODE.StartingWorth="..tostring(self.StartingWorth))
	end

	if pl:Team() == TEAM_UNDEAD then
		-- This is just so they get updated on what class they are and have their hulls set up right.
		pl:DoHulls(classid, TEAM_UNDEAD)
	elseif pl:Team() == TEAM_HUMAN then
		if self:GetWave() <= 0 and self.StartingWorth > 0 and not self.StartingLoadout and not self.ZombieEscape then
			pl:SendLua("InitialWorthMenu()")
		else
			gamemode.Call("GiveDefaultOrRandomEquipment", pl)
		end
	end

	net.Start("zs_currentround")
		net.WriteUInt(self.CurrentRound, 6)
	net.Send(pl)

	if self.RoundEnded then
		pl:SendLua("gamemode.Call(\"EndRound\", "..tostring(ROUNDWINNER)..", \""..game.GetMapNext().."\")")
		gamemode.Call("DoHonorableMentions", pl)
	end

	if pl:GetInfo("zs_noredeem") == "1" then
		pl.NoRedeeming = true
	end

	if self:GetWave() == 0 then
		self:SendZombieVolunteers(pl, true)
	end

	if self:IsClassicMode() then
		pl:SendLua("SetGlobalBool(\"classicmode\", true)")
	elseif self:IsBabyMode() then
		pl:SendLua("SetGlobalBool(\"babymode\", true)")
	end

	self:RefreshItemStocks(pl)
	self:ClassUnlocksUpdate(pl)
end

function GM:FullGameUpdate(pl)
	net.Start("zs_gamestate")
		net.WriteInt(self:GetWave(), 16)
		net.WriteFloat(self:GetWaveStart())
		net.WriteFloat(self:GetWaveEnd())
	if pl then
		net.Send(pl)
	else
		net.Broadcast()
	end
end

concommand.Add("initpostentity", function(sender, command, arguments)
	if not sender.DidInitPostEntity then
		sender.DidInitPostEntity = true

		gamemode.Call("PlayerReady", sender)
	end
end)

local playerheight = Vector(0, 0, 72)
local function groupsort(ga, gb)
	return #ga > #gb
end
function GM:AttemptHumanDynamicSpawn(pl)
	if not self.DynamicSpawning or not pl:IsValidLivingHuman() then return false end

	local sigils = self:GetSigils()
	local randsigil = sigils[math.random(#sigils)]
	if randsigil and randsigil:IsValid() and not randsigil:GetSigilCorrupted() then
		pl:SetBarricadeGhosting(true)
		pl:SetPos(randsigil:GetPos())
		return true
	end

	local group, pos, nearzombie

	local allplayers = team.GetPlayers(TEAM_HUMAN)

	local groups = self:GetTeamRallyGroups(TEAM_HUMAN)
	table.sort(groups, groupsort)

	for i=1, #groups do
		group = groups[i]

		for _, otherpl in pairs(group) do
			if otherpl ~= pl then
				pos = otherpl:GetPos() + Vector(0, 0, 1)
				if otherpl:Alive() and otherpl:GetMoveType() == MOVETYPE_WALK and not util.TraceHull({start = pos, endpos = pos + playerheight, mins = playermins, maxs = playermaxs, mask = MASK_SOLID, filter = allplayers}).Hit then
					nearzombie = false
					for __, ent in pairs(team.GetPlayers(TEAM_UNDEAD)) do
						if ent:Alive() and ent:GetPos():DistToSqr(pos) <= 65536 then --256^2
							nearzombie = true
						end
					end

					if not nearzombie then
						pl:SetPos(otherpl:GetPos())
						return true
					end
				end
			end
		end
	end

	return false
end

function GM:PlayerInitialSpawn(pl)
	pl.MaxBloodArmor = GAMEMODE.ZombieEscape and 0 or 10
	pl.NextFlashlightSwitch = 0
	pl.NextPainSound = 0
	pl.NextFlinch = 0
	pl.LastSentESW = 0
	pl.m_LastWaveStartSpawn = 0
	pl.m_LastGasHeal = 0

	self:InitializeVault(pl)

	gamemode.Call("PlayerInitialSpawnRound", pl)

	self.PeakPopulation = math.max(self.PeakPopulation, #player.GetAll())
end

function GM:PlayerInitialSpawnRound(pl)
	pl:SprintDisable()
	if pl:KeyDown(IN_WALK) then
		pl:ConCommand("-walk")
	end

	pl:SetCanWalk(false)
	pl:SetCanZoom(false)

	-- This is the culprit for shitty player to player collisions when standing on an enemy's head. No idea why.
	pl:SetNoCollideWithTeammates(false) --pl:SetNoCollideWithTeammates(true)
	pl:SetCustomCollisionCheck(true)

	pl.ZombiesKilled = 0
	pl.ZombiesKilledAssists = 0
	pl.Headshots = 0
	pl.BrainsEaten = 0

	pl.ResupplyBoxUsedByOthers = 0

	pl.WaveJoined = self:GetWave()

	pl.CrowKills = 0
	pl.DefenceDamage = 0
	pl.StrengthBoostDamage = 0

	pl.BarricadeDamage = 0

	pl.PointsRemainder = 0

	pl.XPRemainder = 0

	pl.LegDamage = 0
	pl.ArmDamage = 0

	pl.DamageDealt = {}
	pl.DamageDealt[TEAM_UNDEAD] = 0
	pl.DamageDealt[TEAM_HUMAN] = 0

	pl.ZSFriends = {}

	pl.LifeBarricadeDamage = 0
	pl.LifeHumanDamage = 0
	pl.LifeBrainsEaten = 0

	pl.WaveBarricadeDamage = 0
	pl.WaveHumanDamage = 0

	pl.PointQueue = 0
	pl.LastDamageDealtTime = 0

	pl.HealedThisRound = 0
	pl.RepairedThisRound = 0
	pl.NextRegenerate = 0
	pl.NextBloodArmorRegen = 0
	pl.NextRegenTrinket = 0
	pl.LateBuyerMessage = nil
	pl.NestsDestroyed = 0
	pl.NestSpawns = 0
	pl.LastRevive = 0

	pl.ZSInventory = {}

	--local nosend = not pl.DidInitPostEntity
	pl.DamageVulnerability = nil

	self:LoadVault(pl)

	local uniqueid = pl:UniqueID()

	if self.PreviouslyDied[uniqueid] or ZSBOT then
		-- They already died and reconnected.
		pl:ChangeTeam(TEAM_UNDEAD)
	elseif LASTHUMAN then ----
		pl.SpawnedTime = CurTime()
		pl:ChangeTeam(TEAM_UNDEAD)
	elseif self:GetWave() <= 0 then
		pl.SpawnedTime = CurTime()
		pl:ChangeTeam(TEAM_HUMAN)
		if self.DynamicSpawning then
			timer.Simple(1, function()
				GAMEMODE:AttemptHumanDynamicSpawn(pl)
				pl:SetBarricadeGhosting(true, true)
			end)
		end
	elseif self:GetNumberOfWaves() == -1 or self.NoNewHumansWave <= self:GetWave() or team.NumPlayers(TEAM_UNDEAD) == 0 and 1 <= team.NumPlayers(TEAM_HUMAN) then -- Joined during game, no zombies, some humans or joined past the deadline.
		pl:ChangeTeam(TEAM_UNDEAD)
		self.PreviouslyDied[uniqueid] = CurTime()
	else
		pl.SpawnedTime = CurTime()
		pl:ChangeTeam(TEAM_HUMAN)
		if self.DynamicSpawning then
			timer.Simple(0, function()
				GAMEMODE:AttemptHumanDynamicSpawn(pl)
				pl:SetBarricadeGhosting(true, true)
			end)
		end
	end

	if pl:Team() == TEAM_UNDEAD and not self:GetWaveActive() then
		pl:SetZombieClassName("Crow")
		pl.DeathClass = self.DefaultZombieClass
	else
		pl:SetZombieClass(self.DefaultZombieClass)
	end

	if pl:Team() == TEAM_UNDEAD and self.StoredUndeadFrags[uniqueid] then
		pl:SetFrags(self.StoredUndeadFrags[uniqueid])
		self.StoredUndeadFrags[uniqueid] = nil
	end
end

function GM:GetDynamicSpawning()
	return self.DynamicSpawning
end

function GM:PrePlayerRedeemed(pl, silent, noequip)
end

function GM:PostPlayerRedeemed(pl, silent, noequip)
end

function GM:PlayerDisconnected(pl)
	pl.Disconnecting = true

	local uid = pl:UniqueID()

	self.PreviouslyDied[uid] = CurTime()

	if pl:Team() == TEAM_HUMAN then
		pl:DropAll()
	elseif pl:Team() == TEAM_UNDEAD then
		self.StoredUndeadFrags[uid] = pl:Frags()
	end

	if pl:Health() > 0 and not pl:IsSpectator() then
		local lastattacker = pl:GetLastAttacker()
		if IsValid(lastattacker) then
			pl:TakeDamage(1000, lastattacker, lastattacker)

			PrintTranslatedMessage(HUD_PRINTCONSOLE, "disconnect_killed", pl:Name(), lastattacker:Name())
		end
	end

	self:SaveVault(pl)

	gamemode.Call("CalculateInfliction")
end

function GM:CanDamageNail(ent, attacker, inflictor, damage, dmginfo)
	return not attacker:IsPlayer() or attacker:Team() == TEAM_UNDEAD
end

function GM:CanPlaceNail(pl, tr)
	if tr and not pl:HasBarricadeExpert() and tr.Entity.ExpertProtection and tr.Entity.ExpertProtection > CurTime() then
		return false
	end

	return true
end

function GM:CanRemoveNail(pl, nail)
	return not nail.m_NailUnremovable
end

function GM:CanRemoveOthersNail(pl, nailowner, ent)
	-- obsolete
	--[[local plpoints = pl:Frags()
	local ownerpoints = nailowner:Frags()
	if plpoints >= 75 or ownerpoints < 75 then return true end]]

	if gamemode.Call("PlayerIsAdmin", pl) then return true end
	if nailowner.ZSFriends[pl] then return true end

	if pl:BarricadeExpertPrecedence(nailowner) == -1 then
		pl:PrintTranslatedMessage(HUD_PRINTCENTER, "cant_remove_nails_of_superior_player")
		return false
	end

	return true
end

function GM:SetRedeemBrains(amount)
	SetGlobalInt("redeembrains", amount)
end

-- Reevaluates a prop and its constraint system (or all props if no arguments) to determine if they should be frozen or not from nails.
function GM:EvaluatePropFreeze(ent, neighbors)
	if not ent then
		for _, e in pairs(ents.GetAll()) do
			if e and e:IsValid() then
				self:EvaluatePropFreeze(e)
			end
		end

		return
	end

	if ent:IsNailedToWorldHierarchy() then
		ent:SetNailFrozen(true)
	elseif ent:GetNailFrozen() then
		ent:SetNailFrozen(false)
	end

	neighbors = neighbors or {}
	table.insert(neighbors, ent)

	local baseent, attachent

	for _, nail in pairs(ent:GetNails()) do
		if nail:IsValid() then
			baseent = nail:GetBaseEntity()
			attachent = nail:GetAttachEntity()
			if baseent:IsValid() and not baseent:IsWorld() and not table.HasValue(neighbors, baseent) then
				self:EvaluatePropFreeze(baseent, neighbors)
			end
			if attachent:IsValid() and not attachent:IsWorld() and not table.HasValue(neighbors, attachent) then
				self:EvaluatePropFreeze(attachent, neighbors)
			end
		end
	end
end

-- A nail takes some damage. isdead is true if the damage is enough to remove the nail. The nail is invalid after this function call if it dies.
function GM:OnNailDamaged(ent, attacker, inflictor, damage, dmginfo)
end

-- A nail is removed between two entities. The nail is no longer considered valid right after this function and is not in the entities' Nails tables. remover may not be nil if it was removed with the hammer's unnail ability.
local function evalfreeze(ent)
	if ent and ent:IsValid() then
		gamemode.Call("EvaluatePropFreeze", ent)
	end
end
function GM:OnNailRemoved(nail, ent1, ent2, remover)
	if ent1 and ent1:IsValid() and not ent1:IsWorld() then
		timer.Simple(0, function() evalfreeze(ent1) end)
		timer.Simple(0.2, function() evalfreeze(ent1) end)
	end
	if ent2 and ent2:IsValid() and not ent2:IsWorld() then
		timer.Simple(0, function() evalfreeze(ent2) end)
		timer.Simple(0.2, function() evalfreeze(ent2) end)
	end

	if remover and remover:IsValid() and remover:IsPlayer() then
		local deployer = nail:GetDeployer()
		local deployername = "[unconnected]"
		if deployer:IsValid() and deployer:Team() == TEAM_HUMAN then
			deployername = deployer:Name()

			if deployer ~= remover then
				net.Start("zs_nailremoved")
					net.WriteEntity(remover)
				net.Send(deployer)
			end
		end

		PrintTranslatedMessage(HUD_PRINTCONSOLE, "nail_removed_by", remover:Name(), deployername)

		if remover:HasBarricadeExpert() then
			if ent1 and ent1:IsValid() and not ent1:IsWorld() then ent1.ExpertProtection = CurTime() + 5 end
			if ent2 and ent2:IsValid() and not ent2:IsWorld() then ent2.ExpertProtection = CurTime() + 5 end
		end
	end
end

-- A nail is created between two entities.
function GM:OnNailCreated(ent1, ent2, nail)
	if ent1 and ent1:IsValid() and not ent1:IsWorld() then
		timer.Simple(0, function() evalfreeze(ent1) end)
	end
	if ent2 and ent2:IsValid() and not ent2:IsWorld() then
		timer.Simple(0, function() evalfreeze(ent2) end)
	end
end

function GM:RemoveDuplicateAmmo(pl)
	local AmmoCounts = {}
	local WepAmmos = {}

	for _, wep in pairs(pl:GetWeapons()) do
		if wep.Primary then
			local ammotype = wep:ValidPrimaryAmmo()
			if ammotype and wep.Primary.DefaultClip > 0 then
				AmmoCounts[ammotype] = (AmmoCounts[ammotype] or 0) + 1
				WepAmmos[wep] = wep.Primary.DefaultClip - wep.Primary.ClipSize
			end
			local ammotype2 = wep:ValidSecondaryAmmo()
			if ammotype2 and wep.Secondary.DefaultClip > 0 then
				AmmoCounts[ammotype2] = (AmmoCounts[ammotype2] or 0) + 1
				WepAmmos[wep] = wep.Secondary.DefaultClip - wep.Secondary.ClipSize
			end
		end
	end

	for ammotype, count in pairs(AmmoCounts) do
		if count > 1 then
			local highest = 0
			local highestwep
			for wep, extraammo in pairs(WepAmmos) do
				if wep.Primary.Ammo == ammotype then
					highest = math.max(highest, extraammo)
					highestwep = wep
				end
			end
			if highestwep then
				for wep, extraammo in pairs(WepAmmos) do
					if wep ~= highestwep and wep.Primary.Ammo == ammotype then
						pl:RemoveAmmo(extraammo, ammotype)
					end
				end
			end
		end
	end
end

local function TimedOut(pl)
	if pl:IsValid() and pl:Team() == TEAM_HUMAN and pl:Alive() and not GAMEMODE.CheckedOut[pl:UniqueID()] then
		gamemode.Call("GiveRandomEquipment", pl)
	end
end

function GM:GiveDefaultOrRandomEquipment(pl)
	if not self.CheckedOut[pl:UniqueID()] and not self.ZombieEscape then
		if self.StartingLoadout then
			self:GiveStartingLoadout(pl)
		else
			pl:SendLua("GAMEMODE:RequestedDefaultCart()")
			if self.StartingWorth > 0 then
				timer.Simple(4, function() TimedOut(pl) end)
			end
		end
	end
end

function GM:GiveStartingLoadout(pl)
	if self.CheckedOut[pl:UniqueID()] then return end
	self.CheckedOut[pl:UniqueID()] = true

	for item, amount in pairs(self.StartingLoadout) do
		for i=1, amount do
			pl:Give(item)

			GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, item, "StartingLoadout", 1)
		end
	end
end

function GM:GiveRandomEquipment(pl)
	if self.CheckedOut[pl:UniqueID()] or self.ZombieEscape then return end
	self.CheckedOut[pl:UniqueID()] = true

	if self.StartingLoadout then
		self:GiveStartingLoadout(pl)
	elseif GAMEMODE.OverrideStartingWorth then
		pl:Give("weapon_zs_swissarmyknife")
	elseif #self.StartLoadouts >= 1 then
		for _, id in pairs(self.StartLoadouts[math.random(#self.StartLoadouts)]) do
			local tab = FindStartingItem(id)
			if tab then
				if tab.Callback then
					tab.Callback(pl)
				elseif tab.SWEP then
					if not pl:AddInventoryItem(tab.SWEP) then
						pl:StripWeapon(tab.SWEP)
						pl:Give(tab.SWEP)
					end

					GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, tab.SWEP, "RandomCheckouts", 1)
				end
			end
		end
	end
end

function GM:PlayerCanCheckout(pl)
	return pl:IsValid() and pl:Team() == TEAM_HUMAN and pl:Alive() and not self.CheckedOut[pl:UniqueID()] and not self.StartingLoadout and not self.ZombieEscape and self.StartingWorth > 0 and self:GetWave() < 2
end

function GM:PlayerDeathThink(pl)
	if self.RoundEnded or pl.Revive or self:GetWave() == 0 then return end

	if pl:GetObserverMode() == OBS_MODE_CHASE then
		local target = pl:GetObserverTarget()
		if not target or not target:IsValid() or target:IsPlayer() and (not target:Alive() or target:Team() ~= pl:Team()) then
			pl:StripWeapons()
			pl:Spectate(OBS_MODE_ROAMING)
			pl:SpectateEntity(NULL)
		end
	end

	if pl:Team() ~= TEAM_UNDEAD then
		pl.StartCrowing = nil
		pl.StartSpectating = nil
		return
	end

	if pl.NextSpawnTime and pl.NextSpawnTime <= CurTime() then -- Force spawn.
		pl.NextSpawnTime = nil

		pl:RefreshDynamicSpawnPoint()
		pl:UnSpectateAndSpawn()
	elseif pl:GetObserverMode() == OBS_MODE_NONE then -- Not in spectator yet.
		if self:GetWaveActive() then -- During wave.
			if not pl.StartSpectating or CurTime() >= pl.StartSpectating then
				pl.StartSpectating = nil

				pl:StripWeapons()
				local best = self:GetBestDynamicSpawn(pl)
				if best then
					pl:Spectate(OBS_MODE_CHASE)
					pl:SpectateEntity(best)
				else
					pl:Spectate(OBS_MODE_ROAMING)
					pl:SpectateEntity(NULL)
				end
			end
		elseif not pl.StartCrowing or CurTime() >= pl.StartCrowing then -- Not during wave. Turn in to a crow. If we die as a crow then we get turned to spectator anyway.
			pl:ChangeToCrow()
		end
	else -- In spectator.
		if pl:KeyDown(IN_ATTACK) or pl:KeyDown(IN_ATTACK2) or pl:IsBot() then
			pl:RefreshDynamicSpawnPoint()

			local forcespawn = pl.ForceDynamicSpawn
			if forcespawn and forcespawn.MinionSpawn then
				pl:TrySpawnAsGoreChild(forcespawn)
			else
				if self:GetWaveActive() then
					pl:UnSpectateAndSpawn()
				else
					pl:ChangeToCrow()
				end
			end
		elseif pl:KeyDown(IN_RELOAD) then
			if self:GetWaveActive() then
				pl.ForceDynamicSpawn = nil
				local prev = self.DynamicSpawning
				self.DynamicSpawning = false
				pl:UnSpectateAndSpawn()
				self.DynamicSpawning = prev
			else
				pl:ChangeToCrow()
			end
		elseif pl:KeyPressed(IN_JUMP) then
			if pl:GetObserverMode() ~= OBS_MODE_ROAMING then
				pl:Spectate(OBS_MODE_ROAMING)
				pl:SpectateEntity(NULL)
				pl.SpectatedPlayerKey = nil
			end
		end
	end
end

function GM:ShouldAntiGrief(ent, attacker, dmginfo, health)
	return ent.m_AntiGrief and self.GriefMinimumHealth <= health and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and not dmginfo:IsExplosionDamage()
end

function GM:PropBreak(attacker, ent)
	gamemode.Call("PropBroken", ent, attacker)
end

function GM:PropBroken(ent, attacker)
	if IsValid(ent) and IsValid(attacker) and not ent._PROPBROKEN and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		ent._PROPBROKEN = true

		PrintMessage(HUD_PRINTCONSOLE, attacker:LogID().." broke "..ent:GetModel())
	end
end

function GM:NestDestroyed(ent, attacker)
	if IsValid(ent) and IsValid(attacker) and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
		PrintMessage(HUD_PRINTCONSOLE, attacker:LogID().." team killed a nest at "..tostring(ent:GetPos()).." (builder: "..(ent:GetOwner() and ent:GetOwner():IsValid() and ent:GetOwner():IsPlayer() and ent:GetOwner():LogID() or "unknown")..")")
	end
end

function GM:EntityTakeDamage(ent, dmginfo)
	local attacker, inflictor = dmginfo:GetAttacker(), dmginfo:GetInflictor()

	if attacker == inflictor and attacker:IsProjectile() and dmginfo:GetDamageType() == DMG_CRUSH then -- Fixes projectiles doing physics-based damage.
		dmginfo:SetDamage(0)
		dmginfo:ScaleDamage(0)
		return
	end

	if ent.LastHeld and CurTime() < ent.LastHeld + 0.1 and attacker:IsPlayer() and P_Team(attacker) == TEAM_HUMAN then
		dmginfo:SetDamage(0)
		dmginfo:SetDamageType(0)
		dmginfo:ScaleDamage(0)
		dmginfo:SetDamageForce(vector_origin)
		return
	end

	-- Props about to be broken props take 3x damage from anything except zombies
	if ent._BARRICADEBROKEN and not (attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD) then
		dmginfo:SetDamage(dmginfo:GetDamage() * 3)
	end

	if ent.GetObjectHealth and not (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		ent.m_LastDamaged = CurTime()
	end

	if ent.ProcessDamage and ent:ProcessDamage(dmginfo) then return end
	attacker, inflictor = dmginfo:GetAttacker(), dmginfo:GetInflictor()

	-- Don't allow blowing up props during wave 0.
	if self:GetWave() <= 0 and string.sub(ent:GetClass(), 1, 12) == "prop_physics" and inflictor.NoPropDamageDuringWave0 then
		dmginfo:SetDamage(0)
		dmginfo:SetDamageType(DMG_ALWAYSGIB)
		return
	end

	-- We need to stop explosive chains team killing.
	if inflictor:IsValid() then
		local dmgtype = dmginfo:GetDamageType()
		if ent:IsPlayer() and (dmgtype == DMG_ALWAYSGIB or dmgtype == DMG_BURN or dmgtype == DMG_SLOWBURN) and string.sub(inflictor:GetClass(), 1, 12) == "prop_physics" then -- We'll assume a barrel did this damage to a player
			if inflictor.LastDamagedByTeam == ent:Team() and inflictor.LastDamagedBy ~= ent then -- A team member is trying to screw with us
				dmginfo:SetDamage(0)
				dmginfo:ScaleDamage(0)
				return
			end
		elseif string.sub(ent:GetClass(), 1, 12) == "prop_physics" then -- Physics object damaged by...
			if inflictor:IsPlayer() then
				ent.LastDamagedByTeam = inflictor:Team()
				ent.LastDamagedBy = inflictor
			elseif (dmgtype == DMG_ALWAYSGIB or dmgtype == DMG_BURN or dmgtype == DMG_SLOWBURN) and string.sub(inflictor:GetClass(), 1, 12) == "prop_physics" then -- A barrel damaging a barrel. Probably.
				if inflictor.LastDamagedByTeam then
					ent.LastDamagedByTeam = inflictor.LastDamagedByTeam
					ent.LastDamagedBy = inflictor.LastDamagedBy
				end
			end
		end
	end

	-- Prop is nailed. Forward damage to the nails.
	if ent:DamageNails(attacker, inflictor, dmginfo:GetDamage(), dmginfo) then return end

	local dispatchdamagedisplay = false
	local entclass = ent:GetClass()

	if ent:IsPlayer() then
		dispatchdamagedisplay = true

		if attacker.PBAttacker and attacker.PBAttacker:IsValid() then
			attacker = attacker.PBAttacker
		end

		if attacker:IsValid() then
			if attacker:IsPlayer() then
				ent:SetLastAttacker(attacker)

				local myteam = attacker:Team()
				local otherteam = ent:Team()

				if myteam ~= otherteam then
					local damage = math.min(dmginfo:GetDamage(), ent:Health())
					if damage > 0 then
						local time = CurTime()

						attacker.DamageDealt[myteam] = attacker.DamageDealt[myteam] + damage

						if myteam == TEAM_UNDEAD then
							if otherteam == TEAM_HUMAN then
								attacker:AddLifeHumanDamage(damage)
								GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_ZOMBIECLASS, attacker:GetZombieClassTable().Name, "HumanDamage", damage)
							end
						elseif myteam == TEAM_HUMAN and otherteam == TEAM_UNDEAD then
							ent.DamagedBy[attacker] = (ent.DamagedBy[attacker] or 0) + damage
							if time >= ent.m_LastWaveStartSpawn + 3 and time >= ent.m_LastGasHeal + 2 then
								local points = damage / ent:GetMaxHealth() * ent:GetZombieClassTable().Points
								if POINTSMULTIPLIER then
									points = points * POINTSMULTIPLIER
								end
								if ent.PointsMultiplier then
									points = points * ent.PointsMultiplier
								end
								attacker.PointQueue = attacker.PointQueue + points

								GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, inflictor:GetClass(), "PointsEarned", points)
								GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, inflictor:GetClass(), "Damage", damage)
							end

							local pos = ent:GetPos()
							pos.z = pos.z + 32
							attacker.LastDamageDealtPos = pos
							attacker.LastDamageDealtTime = time
						end
					end
				end
			elseif attacker:GetClass() == "trigger_hurt" then
				ent.LastHitWithTriggerHurt = CurTime()
			end
		end
	elseif ent.PropHealth then -- A prop that was invulnerable and converted to vulnerable.
		if ent._PROPBROKEN or self.NoPropDamageFromHumanMelee and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and inflictor.IsMelee then
			dmginfo:SetDamage(0)
			return
		end

		if gamemode.Call("ShouldAntiGrief", ent, attacker, dmginfo, ent.PropHealth) then
			attacker:AntiGrief(dmginfo)
			if dmginfo:GetDamage() <= 0 then return end
		end

		ent.PropHealth = ent.PropHealth - dmginfo:GetDamage()

		dispatchdamagedisplay = true

		if ent.PropHealth <= 0 then
			local effectdata = EffectData()
				effectdata:SetOrigin(ent:GetPos())
			util.Effect("Explosion", effectdata, true, true)
			ent:Fire("break")

			gamemode.Call("PropBroken", ent, attacker)
		else
			local brit = math.Clamp(ent.PropHealth / ent.TotalHealth, 0, 1)
			local col = ent:GetColor()
			col.r = 255
			col.g = 255 * brit
			col.b = 255 * brit
			ent:SetColor(col)
		end
	elseif entclass == "func_door_rotating" then
		if ent:GetKeyValues().damagefilter == "invul" or ent.Broken then return end

		if self.ZombieEscape then
			return
		end

		if not ent.Heal then
			local br = ent:BoundingRadius()
			if br > 80 then return end -- Don't break these kinds of doors that are bigger than this.

			local health = br * 35
			ent.Heal = health
			ent.TotalHeal = health
		end

		if gamemode.Call("ShouldAntiGrief", ent, attacker, dmginfo, ent.TotalHeal) then
			attacker:AntiGrief(dmginfo)
			if dmginfo:GetDamage() <= 0 then return end
		end

		if dmginfo:GetDamage() >= 20 and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
			ent:EmitSound(math.random(2) == 1 and "npc/zombie/zombie_pound_door.wav" or "ambient/materials/door_hit1.wav")
		end

		ent.Heal = ent.Heal - dmginfo:GetDamage()
		local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
		local col = ent:GetColor()
		col.r = 255
		col.g = 255 * brit
		col.b = 255 * brit
		ent:SetColor(col)

		dispatchdamagedisplay = true

		if ent.Heal <= 0 then
			ent.Broken = true

			ent:EmitSound("Breakable.Metal")
			ent:Fire("unlock", "", 0)
			ent:Fire("open", "", 0.01) -- Trigger any area portals.
			ent:Fire("break", "", 0.1)
			ent:Fire("kill", "", 0.15)
		end
	elseif entclass == "prop_door_rotating" then
		if ent:GetKeyValues().damagefilter == "invul" or ent:HasSpawnFlags(2048) and ent:IsDoorLocked() or ent.Broken then return end

		if not ent.Heal then
			ent.Heal = ent:BoundingRadius() * 35
			ent.TotalHeal = ent.Heal
		end

		if dmginfo:GetDamage() >= 20 and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
			ent:EmitSound(math.random(2) == 1 and "npc/zombie/zombie_pound_door.wav" or "ambient/materials/door_hit1.wav")
		end

		if self.ZombieEscape then
			return
		end

		if gamemode.Call("ShouldAntiGrief", ent, attacker, dmginfo, ent.TotalHeal) then
			attacker:AntiGrief(dmginfo)
			if dmginfo:GetDamage() <= 0 then return end
		end

		ent.Heal = ent.Heal - dmginfo:GetDamage()
		local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
		local col = ent:GetColor()
		col.r = 255
		col.g = 255 * brit
		col.b = 255 * brit
		ent:SetColor(col)

		dispatchdamagedisplay = true

		if ent.Heal <= 0 then
			ent.Broken = true

			ent:EmitSound("Breakable.Metal")
			ent:Fire("unlock", "", 0)
			ent:Fire("open", "", 0.01) -- Trigger any area portals.
			ent:Fire("break", "", 0.1)
			ent:Fire("kill", "", 0.15)

			local physprop = ents.Create("prop_physics")
			if physprop:IsValid() then
				physprop:SetPos(ent:GetPos())
				physprop:SetAngles(ent:GetAngles())
				physprop:SetSkin(ent:GetSkin() or 0)
				physprop:SetMaterial(ent:GetMaterial())
				physprop:SetModel(ent:GetModel())
				physprop:Spawn()
				physprop:SetPhysicsAttacker(attacker)
				if attacker:IsValid() then
					local phys = physprop:GetPhysicsObject()
					if phys:IsValid() then
						phys:SetVelocityInstantaneous((physprop:NearestPoint(attacker:EyePos()) - attacker:EyePos()):GetNormalized() * math.Clamp(dmginfo:GetDamage() * 3, 40, 300))
					end
				end
				if physprop:GetMaxHealth() == 1 and physprop:Health() == 0 then
					local health = math.ceil((physprop:OBBMins():Length() + physprop:OBBMaxs():Length()) * 2)
					if health < 2000 then
						physprop.PropHealth = health
						physprop.TotalHealth = health
					end
				end
			end
		end
	elseif entclass == "func_breakable" then
		if ent:GetKeyValues().damagefilter == "invul" then return end

		if self.ZombieEscape then
			dispatchdamagedisplay = true
			return
		end

		if gamemode.Call("ShouldAntiGrief", ent, attacker, dmginfo, ent:GetMaxHealth()) then
			attacker:AntiGrief(dmginfo, true)
			if dmginfo:GetDamage() <= 0 then return end
		end

		if ent:Health() == 0 and ent:GetMaxHealth() == 1 then return end

		local brit = math.Clamp(ent:Health() / ent:GetMaxHealth(), 0, 1)
		local col = ent:GetColor()
		col.r = 255
		col.g = 255 * brit
		col.b = 255 * brit
		ent:SetColor(col)

		dispatchdamagedisplay = true
	elseif string.sub(entclass, 1, 12) == "func_physbox" then
		local holder, status = ent:GetHolder()
		if holder then status:Remove() end

		if ent:GetKeyValues().damagefilter == "invul" then return end

		if not ent.IgnoreZEProtect and self.ZombieEscape then
			dispatchdamagedisplay = true
			return
		end

		ent.Heal = ent.Heal or ent:BoundingRadius() * 35
		ent.TotalHeal = ent.TotalHeal or ent.Heal

		if gamemode.Call("ShouldAntiGrief", ent, attacker, dmginfo, ent.TotalHeal) then
			attacker:AntiGrief(dmginfo)
			if dmginfo:GetDamage() <= 0 then return end
		end

		ent.Heal = ent.Heal - dmginfo:GetDamage()
		local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
		local col = ent:GetColor()
		col.r = 255
		col.g = 255 * brit
		col.b = 255 * brit
		ent:SetColor(col)

		dispatchdamagedisplay = true

		if ent.Heal <= 0 then
			local foundaxis = false
			local entname = ent:GetName()
			local allaxis = ents.FindByClass("phys_hinge")
			for _, axis in pairs(allaxis) do
				local keyvalues = axis:GetKeyValues()
				if keyvalues.attach1 == entname or keyvalues.attach2 == entname then
					foundaxis = true
					axis:Remove()
					ent.Heal = ent.Heal + 120
				end
			end

			if not foundaxis then
				ent:Fire("break", "", 0)
			end
		end
	elseif ent:IsBarricadeProp() and attacker:IsValidLivingZombie() or ent.ZombieConstruction and attacker:IsValidLivingHuman() then
		dispatchdamagedisplay = true
	end

	local dmg = dmginfo:GetDamage()
	if dmg > 0 then
		local holder, status = ent:GetHolder()
		if holder and not holder.BuffTaut then status:Remove() end

		local dmgpos = dmginfo:GetDamagePosition()
		local hasdmgsess = attacker:IsPlayer() and attacker:HasDamageNumberSession()

		if attacker:IsPlayer() and dispatchdamagedisplay and not hasdmgsess then
			self:DamageFloater(attacker, ent, dmgpos, dmg)
		elseif hasdmgsess and dispatchdamagedisplay then
			attacker:CollectDamageNumberSession(dmg, dmgpos, ent:IsPlayer())
		end
	end
end

function GM:DamageFloater(attacker, victim, dmgpos, dmg, definiteply)
	if attacker == victim then return end
	if dmgpos == vector_origin then dmgpos = victim:NearestPoint(attacker:EyePos()) end

	net.Start((definiteply or victim:IsPlayer()) and "zs_dmg" or "zs_dmg_prop")
		if INFDAMAGEFLOATER then
			INFDAMAGEFLOATER = nil
			net.WriteUInt(9999, 16)
		else
			net.WriteUInt(math.ceil(dmg), 16)
		end
		net.WriteVector(dmgpos)
	net.Send(attacker)
end

function GM:SetRandomToZombie()
	local plays = team.GetPlayers(TEAM_HUMAN)
	local pl = plays[math.random(#plays)]

	if not pl then return end

	pl:ChangeTeam(TEAM_UNDEAD)
	pl:SetFrags(0)
	pl:SetDeaths(0)

	self.StartingZombie[pl:UniqueID()] = true
	self.PreviouslyDied[pl:UniqueID()] = CurTime()
	pl:UnSpectateAndSpawn()

	return pl
end

function GM:PreOnPlayerChangedTeam(pl, oldteam, newteam)
	--[[if oldteam == TEAM_HUMAN then
		self:SaveVault(pl)
	end]]
end

function GM:OnPlayerChangedTeam(pl, oldteam, newteam)
	if newteam == TEAM_UNDEAD then
		pl:SetPoints(0)

		--pl.WaveBarricadeDamage = 0
		--pl.WaveHumanDamage = 0
		pl.DamagedBy = {}

		pl:SetBarricadeGhosting(false)
		self.CheckedOut[pl:UniqueID()] = true
	elseif newteam == TEAM_HUMAN then
		self.PreviouslyDied[pl:UniqueID()] = nil

		if self.PointSaving > 0 and pl.PointsVault ~= nil and not self.ZombieEscape and not self:IsClassicMode() then
			pl:SetPoints(math.floor(pl.PointsVault))
		else
			pl:SetPoints(0)
		end

		self:RefreshItemStocks(pl)
	end

	if newteam ~= TEAM_HUMAN then
		pl:RemoveSkills()
	end

	pl:SetLastAttacker(nil)
	for _, p in pairs(player.GetAll()) do
		if p.LastAttacker == pl then
			p.LastAttacker = nil
		end
	end

	pl.PointQueue = 0

	timer.Simple(0, function() gamemode.Call("CalculateInfliction") end)
end

function GM:SetToDefaultZombieClass(pl)
	if pl:Team() == TEAM_UNDEAD then
		pl:KillSilent()
		pl:SetZombieClass(self.DefaultZombieClass or 1)
		pl:UnSpectateAndSpawn()
	else
		pl:SetZombieClass(self.DefaultZombieClass or 1)
	end
end

function GM:SetPantsMode(mode)
	if self.ZombieEscape then return end

	self.PantsMode = mode and self.ZombieClasses["Zombie Legs"] ~= nil and not self:IsClassicMode() and not self:IsBabyMode()

	if self.PantsMode then
		local index = self.ZombieClasses["Zombie Legs"].Index

		self.PreOverrideDefaultZombieClass = self.PreOverrideDefaultZombieClass or self.DefaultZombieClass
		self.DefaultZombieClass = index

		for _, pl in pairs(player.GetAll()) do
			local classname = pl:GetZombieClassTable().Name
			if classname ~= "Zombie Legs" and classname ~= "Crow" then
				if pl:Team() == TEAM_UNDEAD then
					pl:KillSilent()
					pl:SetZombieClass(index)
					pl:UnSpectateAndSpawn()
				else
					pl:SetZombieClass(index)
				end
			end
			pl.DeathClass = index
		end
	else
		self.DefaultZombieClass = self.PreOverrideDefaultZombieClass or self.DefaultZombieClass

		for _, pl in pairs(player.GetAll()) do
			if pl:GetZombieClassTable().Name == "Zombie Legs" then
				self:SetToDefaultZombieClass(pl)
			end
		end
	end
end

function GM:SetClassicMode(mode)
	if self.ZombieEscape then return end

	self.ClassicMode = mode and self.ZombieClasses["Classic Zombie"] ~= nil and not self.PantsMode and not self:IsBabyMode()

	SetGlobalBool("classicmode", self.ClassicMode)

	if self:IsClassicMode() then
		util.RemoveAll("prop_nail")

		local index = self.ZombieClasses["Classic Zombie"].Index

		self.PreOverrideDefaultZombieClass = self.PreOverrideDefaultZombieClass or self.DefaultZombieClass
		self.DefaultZombieClass = index

		for _, pl in pairs(player.GetAll()) do
			local classname = pl:GetZombieClassTable().Name
			if classname ~= "Classic Zombie" and classname ~= "Crow" then
				if pl:Team() == TEAM_UNDEAD then
					pl:KillSilent()
					pl:SetZombieClass(index)
					pl:UnSpectateAndSpawn()
				else
					pl:SetZombieClass(index)
				end
			end
			pl.DeathClass = index
		end
	else
		self.DefaultZombieClass = self.PreOverrideDefaultZombieClass or self.DefaultZombieClass

		for _, pl in pairs(player.GetAll()) do
			if pl:GetZombieClassTable().Name == "Classic Zombie" then
				self:SetToDefaultZombieClass(pl)
			end
		end
	end
end

function GM:SetBabyMode(mode)
	if self.ZombieEscape then return end

	self.BabyMode = mode and self.ZombieClasses["Gore Child"] ~= nil and not self.PantsMode and not self:IsClassicMode()

	SetGlobalBool("babymode", self.BabyMode)

	if self:IsBabyMode() then
		local index = self.ZombieClasses["Gore Child"].Index

		self.PreOverrideDefaultZombieClass = self.PreOverrideDefaultZombieClass or self.DefaultZombieClass
		self.DefaultZombieClass = index

		for _, pl in pairs(player.GetAll()) do
			local classname = pl:GetZombieClassTable().Name
			if classname ~= "Gore Child" and classname ~= "Giga Gore Child" and classname ~= "Crow" then
				if pl:Team() == TEAM_UNDEAD then
					pl:KillSilent()
					pl:SetZombieClass(index)
					pl:UnSpectateAndSpawn()
				else
					pl:SetZombieClass(index)
				end
			end
			pl.DeathClass = index
		end
	else
		self.DefaultZombieClass = self.PreOverrideDefaultZombieClass or self.DefaultZombieClass

		for _, pl in pairs(player.GetAll()) do
			if pl:GetZombieClassTable().Name == "Gore Child" then
				self:SetToDefaultZombieClass(pl)
			end
		end
	end
end

GM.InitialVolunteers = {}
function GM:SetClosestsToZombie()
	local allplayers = player.GetAllActive()
	local numplayers = #allplayers
	if numplayers <= 1 then return end

	local desiredzombies = self:GetDesiredStartingZombies()

	self:SortZombieSpawnDistances(allplayers)

	local zombies = {}
	for _, pl in pairs(allplayers) do
		if pl:Team() ~= TEAM_HUMAN or not pl:Alive() then
			table.insert(zombies, pl)
		end
	end

	-- Need to place some people back on the human team.
	if #zombies > desiredzombies then
		local toswap = #zombies - desiredzombies
		for _, pl in pairs(zombies) do
			if pl.DiedDuringWave0 and pl:GetInfo("zs_alwaysvolunteer") ~= "1" and not pl.IsZSBot then
				pl:ChangeTeam(TEAM_HUMAN)
				pl:UnSpectateAndSpawn()
				toswap = toswap - 1
				if toswap <= 0 then
					break
				end
			end
		end
	end

	for i = 1, desiredzombies do
		local pl = allplayers[i]
		if pl:Team() ~= TEAM_UNDEAD then
			pl:ChangeTeam(TEAM_UNDEAD)
			self.PreviouslyDied[pl:UniqueID()] = CurTime()
			self.InitialVolunteers[pl:UniqueID()] = true
		end
		pl:SetFrags(0)
		pl:SetDeaths(0)

		local unlocked = {}
		for _, v in ipairs(self.ZombieClasses) do
			if v.Unlocked and not v.Hidden and v.NotRandomStart then
				unlocked[#unlocked + 1] = v.Index
			end
		end
		pl:SetZombieClass(unlocked[math.random(#unlocked)])

		self.StartingZombie[pl:UniqueID()] = true
		pl:UnSpectateAndSpawn()
	end
end

function GM:AllowPlayerPickup(pl, ent)
	return false
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	if attacker.PBAttacker and attacker.PBAttacker:IsValid() and CurTime() < attacker.NPBAttacker then -- Protection against prop_physbox team killing. physboxes don't respond to SetPhysicsAttacker()
		attacker = attacker.PBAttacker
	end

	if attacker:IsPlayer() and attacker ~= pl and not attacker.AllowTeamDamage and not pl.AllowTeamDamage and attacker:Team() == pl:Team() then return false end

	return true
end

function GM:PlayerHurt(victim, attacker, healthremaining, damage)
	if healthremaining < 1 then return end

	if victim:Team() == TEAM_HUMAN then
		victim:PlayPainSound()

		if healthremaining < 75 then
			victim:ResetSpeed(nil, healthremaining)
		end

		if healthremaining < victim:GetMaxHealth() * 0.5 and victim:GetBloodArmor() < victim.MaxBloodArmor + 10 and victim:HasTrinket("bloodpack") then
			victim:SetBloodArmor(math.min(victim:GetBloodArmor() + (20 * victim.BloodarmorGainMul), victim.MaxBloodArmor + (20 * victim.MaxBloodArmorMul)))
			victim:TakeInventoryItem("trinket_bloodpack")

			net.Start("zs_trinketconsumed")
				net.WriteString("Blood Transfusion Pack")
			net.Send(victim)
		end
	else
		victim:PlayZombiePainSound()
	end
end

function GM:WeaponDeployed(pl, wep)
	self:DoChangeDeploySpeed(wep)

	-- Don't change speed instantly to stop people from shooting and then running away with a faster weapon.
	local timername = tostring(pl).."speedchange"
	timer.Remove(timername)

	local speed = pl:ResetSpeed(true) -- Determine what speed we SHOULD get without actually setting it.
	if speed < pl:GetMaxSpeed() then
		pl:SetSpeed(speed)
	elseif pl:GetMaxSpeed() < speed then
		local unbound = pl:IsSkillActive(SKILL_UNBOUND) and 0.4 or 1

		timer.Create(timername, (0.333 / (pl.DeploySpeedMultiplier or 1)) * unbound, 1, function() if pl:IsValid() then pl:SetHumanSpeed(speed) end end)
	end
end

function GM:KeyPress(pl, key)
	if key == IN_USE then
		if pl:Team() == TEAM_HUMAN and pl:Alive() then
			if pl:IsCarrying() then
				pl.status_human_holding:OnRemove() -- No idea...
				pl.status_human_holding:RemoveNextFrame()
			else
				self:TryHumanPickup(pl, pl:TraceLine(64).Entity)
			end
		end
	elseif key == IN_SPEED then
		if pl:Alive() then
			if pl:Team() == TEAM_HUMAN then
				pl:DispatchAltUse()

				if not pl:IsCarrying() and pl:KeyPressed(IN_SPEED) and pl:IsSkillActive(SKILL_CARDIOTONIC) and pl:GetBloodArmor() > 0 then
					pl:SetBloodArmor(pl:GetBloodArmor() - 1)
					pl:EmitSound("player/suit_sprint.wav", 50)
					if pl:GetBloodArmor() == 0 and pl:IsSkillActive(SKILL_BLOODLETTER) then
						local bleed = pl:GiveStatus("bleed")
						if bleed and bleed:IsValid() then
							bleed:AddDamage(5)
							bleed.Damager = pl
						end
					end
					pl:ResetSpeed()
				end
			elseif pl:Team() == TEAM_UNDEAD then
				pl:CallZombieFunction0("AltUse")
			end
		end
	elseif key == IN_ZOOM then
		if pl:Team() == TEAM_HUMAN and pl:Alive() and not self.ZombieEscape then
			if pl:IsOnGround() then
				pl.LastGhostFailureVelocity = nil
				pl:SetBarricadeGhosting(true)
			else
				local plvel = pl:GetVelocity()
				if pl:GetPhysicsObject():IsPenetrating() then
					if (plvel.x == 0 and plvel.y == 0 and (plvel.z == -4.5 or plvel.z == 0)) then
						pl.LastGhostFailureVelocity = nil
						pl:SetBarricadeGhosting(true)
					else
						pl:SetLocalVelocity(vector_origin)
					end
				elseif pl.LastGhostFailureVelocity == plvel then
					pl.LastGhostFailureVelocity = nil
					pl:SetBarricadeGhosting(true)
				else
					pl.LastGhostFailureVelocity = plvel
				end
			end
		end
	end
end

function GM:GetNearestSpawn(pos, teamid)
	local nearest = NULL

	local nearestdist = math.huge
	for _, ent in pairs(team.GetValidSpawnPoint(teamid)) do
		if ent.Disabled then continue end

		local dist = ent:GetPos():DistToSqr(pos)
		if dist < nearestdist then
			nearestdist = dist
			nearest = ent
		end
	end

	return nearest
end

function GM:EntityWouldBlockSpawn(ent)
	local spawnpoint = self:GetNearestSpawn(ent:GetPos(), TEAM_UNDEAD)

	if spawnpoint:IsValid() then
		local spawnpos = spawnpoint:GetPos()
		if spawnpos:DistToSqr(ent:NearestPoint(spawnpos)) <= 1600 then return true end
	end

	return false
end

function GM:GetNearestSpawnDistance(pos, teamid)
	local nearest = self:GetNearestSpawn(pos, teamid)
	if nearest:IsValid() then
		return nearest:GetPos():Distance(pos)
	end

	return -1
end

function GM:ShutDown()
	self:SaveAllVaults()
end

function GM:PlayerUse(pl, ent)
	if not pl:Alive() or pl:Team() == TEAM_UNDEAD and pl:GetZombieClassTable().NoUse or pl:GetBarricadeGhosting() then return false end

	if pl:IsHolding() and pl:GetHolding() ~= ent then return false end

	local entclass = ent:GetClass()
	if entclass == "prop_door_rotating" then
		if CurTime() < (ent.m_AntiDoorSpam or 0) then -- Prop doors can be glitched shut by mashing the use button.
			return false
		end
		ent.m_AntiDoorSpam = CurTime() + 0.85
	elseif entclass == "item_healthcharger" then
		if pl:Team() == TEAM_UNDEAD then
			return false
		elseif pl:IsSkillActive(SKILL_D_FRAIL) and pl:Health() >= math.floor(pl:GetMaxHealth() * 0.25) then
			return false
		end
	elseif pl:Team() == TEAM_HUMAN and not pl:IsCarrying() and pl:KeyPressed(IN_USE) then
		self:TryHumanPickup(pl, ent)
	end

	return true
end

function GM:PlayerDeath(pl, inflictor, attacker)
end

function GM:PlayerDeathSound()
	return true
end

local function SortDist(pa, pb)
	return pa._temp < pb._temp
end
function GM:CanPlayerSuicide(pl)
	if self.RoundEnded or pl:HasWon() then return false end

	if pl:Team() == TEAM_HUMAN then
		if self:GetWave() <= self.NoSuicideWave then
			pl:PrintTranslatedMessage(HUD_PRINTCENTER, "give_time_before_suicide")
			return false
		end

		-- If a person is going to suicide with no last attacker, give the kill to the closest zombie.
		if not IsValid(pl:GetLastAttacker()) then
			local plpos = pl:EyePos()
			local tosort = {}
			for _, zom in pairs(team.GetPlayers(TEAM_UNDEAD)) do
				if zom:Alive() then
					local dist = zom:GetPos():DistToSqr(plpos)
					if dist <= 262144 then --512^2
						zom._temp = dist
						table.insert(tosort, zom)
					end
				end
			end

			table.sort(tosort, SortDist)

			if tosort[1] then
				pl:SetLastAttacker(tosort[1])
			end
		end
	elseif pl:Team() == TEAM_UNDEAD then
		local ret = pl:CallZombieFunction0("CanPlayerSuicide")
		if ret == false then return false end
	end

	return pl:GetObserverMode() == OBS_MODE_NONE and pl:Alive() and (not pl.SpawnNoSuicide or pl.SpawnNoSuicide < CurTime())
end

function GM:DefaultRevive(pl)
	local status = pl:GiveStatus("revive")
	if status and status:IsValid() then
		status:SetReviveTime(CurTime() + 2)
	end
end

function GM:HumanKilledZombie(pl, attacker, inflictor, dmginfo, headshot, suicide)
	if (pl:GetZombieClassTable().Points or 0) == 0 or self.RoundEnded then return end

	-- Simply distributes based on damage but also do some stuff for assists.

	local totaldamage = 0
	for otherpl, dmg in pairs(pl.DamagedBy) do
		if otherpl:IsValid() and otherpl:Team() == TEAM_HUMAN then
			totaldamage = totaldamage + dmg
		end
	end

	local mostassistdamage = 0
	local halftotaldamage = totaldamage / 2
	local mostdamager
	for otherpl, dmg in pairs(pl.DamagedBy) do
		if otherpl ~= attacker and otherpl:IsValid() and otherpl:Team() == TEAM_HUMAN and dmg > mostassistdamage and dmg >= halftotaldamage then
			mostassistdamage = dmg
			mostdamager = otherpl
		end
	end

	attacker.ZombiesKilled = attacker.ZombiesKilled + 1

	if mostdamager then
		attacker:PointCashOut(pl, FM_LOCALKILLOTHERASSIST)
		mostdamager:PointCashOut(pl, FM_LOCALASSISTOTHERKILL)

		mostdamager.ZombiesKilledAssists = mostdamager.ZombiesKilledAssists + 1
	else
		attacker:PointCashOut(pl, FM_NONE)
	end

	if inflictor:IsValid() and inflictor == attacker:GetActiveWeapon() then
		local wep = attacker:GetActiveWeapon()
		if attacker.MeleeMovementSpeedOnKill and attacker.MeleeMovementSpeedOnKill ~= 0 and wep.IsMelee then
			local boost = attacker:GiveStatus("adrenalineamp", 10)
			if boost and boost:IsValid() then
				boost:SetSpeed(attacker.MeleeMovementSpeedOnKill)
			end
		end

		if #self.Food > 0 and pl.ChefMarkTime and pl.ChefMarkTime > CurTime() and pl.ChefMarkOwner == attacker then
			local rfood = self.Food[math.random(#self.Food)]
			if not attacker:HasWeapon(rfood) then
				attacker:Give(rfood)
			end
		end

		if pl:WasHitInHead() then
			attacker.Headshots = (attacker.Headshots or 0) + 1
		end

		GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, wep:GetClass(), "Kills", 1)

		if wep.OnZombieKilled then
			wep:OnZombieKilled(pl, totaldamage, dmginfo)
		end
	end

	gamemode.Call("PostHumanKilledZombie", pl, attacker, inflictor, dmginfo, mostdamager, mostassistdamage, headshot)

	return mostdamager
end

function GM:PostHumanKilledZombie(pl, attacker, inflictor, dmginfo, assistpl, assistamount, headshot)
end

function GM:ZombieKilledHuman(pl, attacker, inflictor, dmginfo, headshot, suicide)
	if self.RoundEnded then return end

	local plpos = pl:GetPos()
	local dist = 999999999
	local xp = 18 * (GAMEMODE.ZombieXPMulti or 1)
	for _, ent in pairs(team.GetValidSpawnPoint(TEAM_UNDEAD)) do
		dist = math.min(ent:GetPos():DistToSqr(plpos), dist)
	end
	pl.ZombieSpawnDeathDistance = math.ceil(math.sqrt(dist))

	attacker:AddBrains(1)
	attacker:AddLifeBrainsEaten(1)
	attacker:AddZSXP(self.InitialVolunteers[attacker:UniqueID()] and xp or math.floor(xp/4))

	local classtab = attacker:GetZombieClassTable()
	if classtab and classtab.Name then
		GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_ZOMBIECLASS, classtab.Name, "BrainsEaten", 1)
	end

	if not pl.Gibbed and not suicide then
		local status = pl:GiveStatus("revive_slump_human")
		if status then
			status:SetReviveTime(CurTime() + 4)
			status:SetZombieInitializeTime(CurTime() + 2)
		end

		pl:SetZombieClassName(self.ZombieEscape and "Super Zombie" or self:IsClassicMode() and "Classic Zombie" or self:IsBabyMode() and "Gore Child" or "Fresh Dead")
	end

	gamemode.Call("PostZombieKilledHuman", pl, attacker, inflictor, dmginfo, headshot, suicide)

	return attacker:Frags()
end

function GM:PostZombieKilledHuman(pl, attacker, inflictor, dmginfo, headshot, suicide)
end

local function DelayedChangeToZombie(pl)
	if pl:IsValid() then
		if pl.ChangeTeamFrags then
			pl:SetFrags(pl.ChangeTeamFrags)
			pl.ChangeTeamFrags = 0
		end

		pl:ChangeTeam(TEAM_UNDEAD)
	end
end
function GM:DoPlayerDeath(pl, attacker, dmginfo)
	pl:RemoveEphemeralStatuses()
	pl:Extinguish()
	pl:SetPhantomHealth(0)

	local inflictor = dmginfo:GetInflictor()
	local plteam = pl:Team()
	local ct = CurTime()
	local suicide = attacker == pl or attacker:IsWorld()

	if attacker.PBAttacker and attacker.PBAttacker:IsValid() then
		attacker = attacker.PBAttacker
	end

	pl:Freeze(false)

	local headshot = pl:WasHitInHead()

	if suicide then attacker = pl:GetLastAttacker() or attacker end
	pl:SetLastAttacker()

	if inflictor == NULL then inflictor = attacker end

	if inflictor == attacker and attacker:IsPlayer() then
		local wep = attacker:GetActiveWeapon()
		if wep:IsValid() then
			inflictor = wep
		end
	end

	if headshot then
		local effectdata = EffectData()
			effectdata:SetOrigin(dmginfo:GetDamagePosition())
			local force = dmginfo:GetDamageForce()
			effectdata:SetMagnitude(force:Length() * 3)
			effectdata:SetNormal(force:GetNormalized())
			effectdata:SetEntity(pl)
		util.Effect("headshot", effectdata, true, true)
	end

	if not pl:CallZombieFunction5("OnKilled", attacker, inflictor, suicide, headshot, dmginfo) then
		if pl:Health() <= -70 and not pl.NoGibs and not self.ZombieEscape then
			pl:Gib(dmginfo)
		elseif not pl.KnockedDown then
			pl:CreateRagdoll()
		end
	end

	pl:RemoveStatus("overridemodel", false, true)

	local revive = false
	local assistpl
	if plteam == TEAM_UNDEAD then
		if GAMEMODE.ZombieEscape then
			local zewep = pl:GetWeapon("weapon_knife")
			if zewep and zewep:IsValid() then
				pl:DropWeapon(zewep)
			end
		end

		local classtable = pl:GetZombieClassTable()

		pl:PlayZombieDeathSound()

		if classtable.Boss and not self.ObjectiveMap and pl.BossDeathNotification then
			net.Start("zs_boss_slain")
				net.WriteEntity(pl)
				net.WriteUInt(classtable.Index, 8)
			net.Broadcast()

			timer.Simple(0, function()
				pl:MakeBossDrop()
			end)

			pl.BossDeathNotification = nil
		end

		if not classtable.NoDeaths then
			pl:AddDeaths(1)
		end

		if self:GetWaveActive() then
			pl.StartSpectating = ct + 2
		else
			pl.StartCrowing = ct + 3
		end

		if attacker:IsValid() and attacker:IsPlayer() and attacker ~= pl then
			if classtable.Revives and not pl.Gibbed and not headshot and CurTime() > pl.LastRevive + 4 then
				if classtable.ReviveCallback then
					revive = classtable:ReviveCallback(pl, attacker, dmginfo)
				elseif math.random(4) ~= 1 then
					self:DefaultRevive(pl)
					revive = true
				end
			end

			if revive then
				pl.LastRevive = CurTime()
			elseif attacker:Team() == TEAM_HUMAN then
				assistpl = gamemode.Call("HumanKilledZombie", pl, attacker, inflictor, dmginfo, headshot, suicide)
			end
		end

		if not revive and (pl.LifeBarricadeDamage ~= 0 or pl.LifeHumanDamage ~= 0 or pl.LifeBrainsEaten ~= 0) then
			timer.Simple(0, function() if pl:IsValid() then pl:SendLifeStats() end end)
		end

		pl:CallZombieFunction5("PostOnKilled", attacker, inflictor, suicide, headshot, dmginfo)
	elseif plteam == TEAM_HUMAN then
		pl.NextSpawnTime = ct + 4

		pl:PlayDeathSound()

		if attacker:IsPlayer() and attacker ~= pl then
			gamemode.Call("ZombieKilledHuman", pl, attacker, inflictor, dmginfo, headshot, suicide)
		end

		pl:DropAll()
		timer.Simple(0, function() DelayedChangeToZombie(pl) end) -- We don't want people shooting barrels near teammates.
		self.PreviouslyDied[pl:UniqueID()] = CurTime()
		if self:GetWave() == 0 then
			pl.DiedDuringWave0 = true
		end

		local frags = pl:Frags()
		if frags < 0 then
			pl.ChangeTeamFrags = math.ceil(frags / 5)
		else
			pl.ChangeTeamFrags = 0
		end

		if pl.SpawnedTime then
			pl.SurvivalTime = math.max(ct - pl.SpawnedTime, pl.SurvivalTime or 0)
			pl.SpawnedTime = nil
		end

		if team.NumPlayers(TEAM_HUMAN) <= 1 then
			self.LastHumanPosition = pl:WorldSpaceCenter()

			net.Start("zs_lasthumanpos")
				net.WriteVector(self.LastHumanPosition)
			net.Broadcast()
		end

		local hands = pl:GetHands()
		if IsValid(hands) then
			hands:Remove()
		end
	end

	if revive or pl:CallZombieFunction2("NoDeathMessage", attacker, dmginfo) or pl:IsSpectator() then return end

	if attacker == pl then
		net.Start("zs_pl_kill_self")
			net.WriteEntity(pl)
			net.WriteUInt(plteam, 8)
		net.Broadcast()
	elseif attacker:IsPlayer() then
		if assistpl then
			net.Start("zs_pls_kill_pl")
				net.WriteEntity(pl)
				net.WriteEntity(attacker)
				net.WriteEntity(assistpl)
				net.WriteString(inflictor:GetClass())
				net.WriteUInt(plteam, 8)
				net.WriteUInt(attacker:Team(), 8) -- Assuming assistants are always on the same team.
				net.WriteBit(headshot)
			net.Broadcast()

			gamemode.Call("PlayerKilledByPlayer", pl, assistpl, inflictor, headshot, dmginfo, true)
		else
			net.Start("zs_pl_kill_pl")
				net.WriteEntity(pl)
				net.WriteEntity(attacker)
				net.WriteString(inflictor:GetClass())
				net.WriteUInt(plteam, 8)
				net.WriteUInt(attacker:Team(), 8)
				net.WriteBit(headshot)
			net.Broadcast()
		end

		gamemode.Call("PlayerKilledByPlayer", pl, attacker, inflictor, headshot, dmginfo)
	else
		net.Start("zs_death")
			net.WriteEntity(pl)
			net.WriteString(inflictor:GetClass())
			net.WriteString(attacker:GetClass())
			net.WriteUInt(plteam, 8)
		net.Broadcast()
	end
end

function GM:WeaponEquip(wep)
	if wep.m_WeaponDeploySpeed then
		timer.Simple(0, function() GAMEMODE:DoChangeDeploySpeed(wep) end)
	end
end

function GM:PlayerKilledByPlayer(pl, attacker, inflictor, headshot, dmginfo, is_assistant)
end

function GM:PlayerCanPickupWeapon(pl, ent)
	if pl:IsSpectator() then return false end

	if pl:Team() == TEAM_UNDEAD then return ent:GetClass() == pl:GetZombieClassTable().SWEP end

	return not ent.ZombieOnly
end

function GM:PlayerCanPickupItem(pl, ent)
	if pl:IsSkillActive(SKILL_D_FRAIL) then
		local class = ent:GetClass()
		if class == "item_healthkit" or class == "item_healthvial" then
			local healamount = #class == 14 and 25 or 10
			if pl:Health() + healamount > math.floor(pl:GetMaxHealth() * 0.25) then
				return false
			end
		end
	end

	return true
end

-- This function is only for footsteps for players not in the local player's pvs or something.
-- The cl_init.lua version usually overrides this number so I just set it to a static number to save cycles.
function GM:PlayerStepSoundTime(pl, iType, bWalking)
	return 350
end

-- Again, don't bother overriding anything due to above.
function GM:PlayerFootstep(pl, vPos, iFoot, strSoundName, fVolume, pFilter)
end

local VoiceSetTranslate = {}
VoiceSetTranslate["models/player/alyx.mdl"] = VOICESET_ALYX
VoiceSetTranslate["models/player/barney.mdl"] = VOICESET_BARNEY
VoiceSetTranslate["models/player/combine_soldier.mdl"] = VOICESET_COMBINE
VoiceSetTranslate["models/player/combine_soldier_prisonguard.mdl"] = VOICESET_COMBINE
VoiceSetTranslate["models/player/combine_super_soldier.mdl"] = VOICESET_COMBINE
VoiceSetTranslate["models/player/police.mdl"] = VOICESET_COMBINE
VoiceSetTranslate["models/grim.mdl"] = VOICESET_COMBINE
VoiceSetTranslate["models/player/police_fem.mdl"] = VOICESET_COMBINE
VoiceSetTranslate["models/player/monk.mdl"] = VOICESET_MONK
VoiceSetTranslate["models/jason278-players/gabe_3.mdl"] = VOICESET_MONK
VoiceSetTranslate["models/player/mossman.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/player/brsp.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/player/moe_glados_p.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/player/mossman_arctic.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/player/p2_chell.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/dawson/obese_male_deluxe/obese_male_deluxe.mdl"] = VOICESET_MONK
VoiceSetTranslate["models/player/cirno/cirno_player.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/player/dewobedil/eromanga_sensei/sagiri/pajama_p.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/loyalists/mmd/remilia/remilia_mp_pm.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/loyalists/mmd/flandre/flandre_mp_pm.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/jazzmcfly/kantai/yuudachi/yuudachi.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/player/dewobedil/vocaloid/haku/bikini_p.mdl"] = VOICESET_FEMALE
VoiceSetTranslate["models/player/dewobedil/touhou/junko/default_p.mdl"] = VOICESET_FEMALE
function GM:PlayerSpawn(pl)
	pl:StripWeapons()
	pl:WipePlayerInventory()
	pl:GiveAmmo(1, "dummy", true) -- Fixes empty weapon deploy bug.
	pl:RemoveStatus("confusion", false, true)
	pl:RemoveFlags(FL_ONGROUND) -- fixes :OnGround() returning true on spawn even if they're not on the ground.

	if pl:GetMaterial() ~= "" then
		pl:SetMaterial("")
	end

	pl:UnSpectate()

	pl.StartCrowing = nil
	pl.StartSpectating = nil
	pl.NextSpawnTime = nil
	pl.Gibbed = nil

	pl.SpawnNoSuicide = CurTime() + 1
	pl.SpawnedTime = CurTime()

	pl:ShouldDropWeapon(false)

	pl:SetLegDamage(0)
	pl:SetLastAttacker()

	local pcol = Vector(pl:GetInfo("cl_playercolor"))
	pcol.x = math.Clamp(pcol.x, 0, 2.5)
	pcol.y = math.Clamp(pcol.y, 0, 2.5)
	pcol.z = math.Clamp(pcol.z, 0, 2.5)
	pl:SetPlayerColor(pcol)

	if pl:Team() == TEAM_UNDEAD then
		if pl.ActivatedHumanSkills then
			pl.ActivatedHumanSkills = false
			pl:ApplySkills({})
		end

		if not pl.Revived then
			pl.DamagedBy = {}
		end

		pl.LifeBarricadeDamage = 0
		pl.LifeHumanDamage = 0
		pl.LifeBrainsEaten = 0

		pl.BossHealRemaining = nil

		if self:GetUseSigils() and self:GetEscapeSequence() and self:GetEscapeStage() >= ESCAPESTAGE_BOSS and not pl.Revived then
			pl:SetZombieClassName("Super Zombie")
		elseif pl.DeathClass and self:GetWaveActive() then
			pl:SetZombieClass(self:GetBestAvailableZombieClass(pl.DeathClass))
			pl.DeathClass = nil
		end

		local cur = pl:GetZombieClassTable().Name
		local best = self:GetBestAvailableZombieClass(cur)
		if cur ~= best then
			pl:SetZombieClass(best)
		end

		local classtab = pl:GetZombieClassTable()
		pl:DoHulls(pl:GetZombieClass(), TEAM_UNDEAD)
		--pl:SetCustomCollisionCheck(pl.NoCollideAll == true)
		pl:CollisionRulesChanged()

		if classtab.Model then
			pl:SetModel(classtab.Model)
		elseif classtab.UsePlayerModel then
			local mdl = player_manager.TranslatePlayerModel(pl:GetInfo("cl_playermodel"))
			if table.HasValue(self.RestrictedModels, mdl) then
				pl:SelectRandomPlayerModel()
			else
				pl:SetModel(mdl)
			end
		elseif classtab.UsePreviousModel then
			local curmodel = string.lower(pl:GetModel())
			if table.HasValue(self.RestrictedModels, curmodel) or (not VoiceSetTranslate[curmodel] and string.sub(curmodel, 1, 14) ~= "models/player") then
				pl:SelectRandomPlayerModel()
			end
		elseif classtab.UseRandomModel then
			pl:SelectRandomPlayerModel()
		else
			pl:SetModel("models/player/zombie_classic_hbfix.mdl")
		end

		if classtab.NoPlayerColor then
			pl:SetColor(COLOR_WHITE)
			pl:SetPlayerColor(Vector(255, 255, 255))
		end

		if classtab.Boss then
			pl:SetHealth(classtab.Health)
		else
			local lowundead = team.NumPlayers(TEAM_UNDEAD) < 4

			local healthmulti = (self.ObjectiveMap or self.ZombieEscape) and 1 or lowundead and 1.5 or 1
			pl:SetHealth(classtab.Health * healthmulti)
		end

		if classtab.SWEP then
			pl:Give(classtab.SWEP)
		end

		pl:SetNoTarget(true)
		pl:SetMaxHealth(1)

		pl:ResetSpeed()
		pl:SetCrouchedWalkSpeed(classtab.CrouchedWalkSpeed or 0.45)

		if not pl.Revived or not self:GetWaveActive() or CurTime() > self:GetWaveEnd() then
			pl.StartCrowing = 0
		end

		if pl.ForceSpawnAngles then
			pl:SetEyeAngles(pl.ForceSpawnAngles)
			pl.ForceSpawnAngles = nil
		end

		if not pl.Revived and not pl:GetZombieClassTable().NeverAlive and pl.SpawnedOnSpawnPoint and not pl.DidntSpawnOnSpawnPoint then
			pl:GiveStatus("zombiespawnbuff", self.ObjectiveMap and 1.5 or 3)
		end
		pl.DidntSpawnOnSpawnPoint = nil
		pl.SpawnedOnSpawnPoint = nil

		local overridemodel = pl:GetZombieClassTable().OverrideModel
		if overridemodel then
			local current = pl:GiveStatus("overridemodel")
			if current and current:IsValid() then
				current:SetModel(overridemodel)
				current:ResetBones()
				pl:CallZombieFunction1("ManipulateOverrideModel", current)
			end
		else
			pl:RemoveStatus("overridemodel", false, true)
		end

		local oldhands = pl:GetHands()
		if IsValid(oldhands) then
			oldhands:Remove()
		end

		GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_ZOMBIECLASS, classtab.Name, "ClassSpawn", 1)

		pl:CallZombieFunction0("OnSpawned")
	elseif pl:Team() == TEAM_HUMAN then
		pl.PointQueue = 0
		pl.PackedItems = {}
		pl:ClearUselessDamage()

		local desiredname = pl:GetInfo("cl_playermodel")
		local modelname = player_manager.TranslatePlayerModel(#desiredname == 0 and self.RandomPlayerModels[math.random(#self.RandomPlayerModels)] or desiredname)
		local lowermodelname = string.lower(modelname)
		if table.HasValue(self.RestrictedModels, lowermodelname) then
			modelname = "models/player/alyx.mdl"
			lowermodelname = modelname
		end
		pl:SetModel(modelname)

		-- Cache the voice set.
		if VoiceSetTranslate[lowermodelname] then
			pl:SetDTInt(DT_PLAYER_INT_VOICESET, VoiceSetTranslate[lowermodelname])
		elseif string.find(lowermodelname, "female", 1, true) then
			pl:SetDTInt(DT_PLAYER_INT_VOICESET, VOICESET_FEMALE)
		else
			pl:SetDTInt(DT_PLAYER_INT_VOICESET, VOICESET_MALE)
		end

		--pl.HumanSpeedAdder = nil

		pl:SetNoTarget(false)
		pl:SetMaxHealth(100)
		--pl:SetCustomCollisionCheck(false)
		pl:CollisionRulesChanged()

		if not self.NoSkills then
			pl.ActivatedHumanSkills = true
			pl.AdjustedStartPointsSkill = nil
			pl.AdjustedStartScrapSkill = nil
			pl:ApplySkills()
		end

		pl.StowageCaches = 0

		net.Start("zs_stowagecaches")
			net.WriteInt(pl.StowageCaches, 8)
		net.Send(pl)

		pl:ResetSpeed()
		pl:ResetJumpPower()
		pl:SetCrouchedWalkSpeed(0.45)

		pl:SetViewOffset(DEFAULT_VIEW_OFFSET)
		pl:SetViewOffsetDucked(DEFAULT_VIEW_OFFSET_DUCKED)

		if self.ZombieEscape then
			pl:Give("weapon_zs_zeknife")
			pl:Give("weapon_zs_zegrenade")
			pl:Give(table.Random(self.ZombieEscapeWeaponsPrimary))
			pl:Give(table.Random(self.ZombieEscapeWeaponsSecondary))
		else
			local start = pl:GetRandomStartingItem()
			if start then
				local func = self:GetInventoryItemType(start) == INVCAT_TRINKETS and pl.AddInventoryItem or pl.Give
				func(pl, start)
			end

			pl:Give("weapon_zs_fists")

			if self.StartingLoadout then
				self:GiveStartingLoadout(pl)
			elseif pl.m_PreRedeem then
				if self.RedeemLoadout then
					for _, class in pairs(self.RedeemLoadout) do
						pl:Give(class)
					end
				else
					pl:Give("weapon_zs_redeemers")
					pl:Give("weapon_zs_swissarmyknife")
				end
			end
		end

		local oldhands = pl:GetHands()
		if IsValid(oldhands) then
			oldhands:Remove()
		end

		local hands = ents.Create("zs_hands")
		if hands:IsValid() then
			hands:DoSetup(pl)
			hands:Spawn()
		end
	end

	local wcol = Vector(pl:GetInfo("cl_weaponcolor"))
	wcol.x = math.Clamp(wcol.x, 0, 2.5)
	wcol.y = math.Clamp(wcol.y, 0, 2.5)
	wcol.z = math.Clamp(wcol.z, 0, 2.5)
	pl:SetWeaponColor(wcol)
end

function GM:SetWave(wave)
	local previouslylocked = {}
	local UnlockedClasses = {}
	for classid, classtab in ipairs(GAMEMODE.ZombieClasses) do
		if not gamemode.Call("IsClassUnlocked", classid) then
			previouslylocked[classid] = true
		end
	end

	SetGlobalInt("wave", wave)

	for classid in pairs(previouslylocked) do
		if gamemode.Call("IsClassUnlocked", classid) then
			local classtab = self.ZombieClasses[classid]
			classtab.Locked = false
			classtab.Unlocked = true

			if not classtab.UnlockedNotify then
				classtab.UnlockedNotify = true
				table.insert(UnlockedClasses, classid)
			end

			for _, ent in pairs(ents.FindByClass("logic_classunlock")) do
				local classname = GAMEMODE.ZombieClasses[classid].Name
				if ent.Class == string.lower(classname) then
					ent:Input("onclassunlocked", ent, ent, classname)
				end
			end

			net.Start("zs_classunlockstate")
				net.WriteInt(classid, 8)
				net.WriteBool(classtab.Unlocked)
			net.Broadcast()
		end
	end

	if #UnlockedClasses > 0 then
		for _, pl in pairs(player.GetAll()) do
			local classnames = {}
			for __, classid in pairs(UnlockedClasses) do
				local classtbl = self.ZombieClasses[classid]

				table.insert(classnames, translate.ClientGet(pl, classtbl.TranslationName))
			end
			net.Start("zs_classunlock")
				net.WriteString(string.AndSeparate(classnames))
			net.Send(pl)
		end
	end
end

GM.NextEscapeDamage = 0
function GM:WaveStateChanged(newstate)
	if newstate then
		if self:GetWave() == 0 then
			gamemode.Call("CreateSigils", true) -- Try creating sigils again. Only really matters if nobody seeded the map yet.

			self:SetClosestsToZombie()

			local humans = {}
			for _, pl in pairs(player.GetAll()) do
				if pl:Team() == TEAM_HUMAN and pl:Alive() then
					table.insert(humans, pl)
				end
			end

			for _, pl in pairs(humans) do
				if pl.PlayerReady then -- There's a chance they might not be ready to send their desired cart yet.
					gamemode.Call("GiveDefaultOrRandomEquipment", pl)
				end
			end

			-- We should spawn a crate in a random spawn point if no one has any.
			if not self.ZombieEscape and #ents.FindByClass("prop_arsenalcrate") == 0 then
				local have = false
				for _, pl in pairs(humans) do
					if pl:HasWeapon("weapon_zs_arsenalcrate") then
						have = true
						break
					end
				end

				if not have and #humans >= 1 then
					local spawn = self:PlayerSelectSpawn(humans[math.random(#humans)])
					if spawn and spawn:IsValid() then
						local ent = ents.Create("prop_arsenalcrate")
						if ent:IsValid() then
							ent:SetPos(spawn:GetPos() + Vector(0, 0, 8))
							ent:Spawn()
							ent:DropToFloor()
							ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER) -- Just so no one gets stuck in it.
							ent.NoTakeOwnership = true
						end
					end
				end
			end
		end

		local prevwave = self:GetWave()

		if self:GetUseSigils() and prevwave >= self:GetNumberOfWaves() then return end

		gamemode.Call("SetWave", prevwave + 1)
		gamemode.Call("SetWaveStart", CurTime())
		if self.ZombieEscape then
			gamemode.Call("SetWaveEnd", -1)
			SetGlobalInt("numwaves", -1)
		else
			gamemode.Call("SetWaveEnd", self:GetWaveStart() + self:GetWaveOneLength() + (self:GetWave() - 1) * (GetGlobalBool("classicmode") and self.TimeAddedPerWaveClassic or self.TimeAddedPerWave))
		end

		net.Start("zs_wavestart")
			net.WriteInt(self:GetWave(), 16)
			net.WriteFloat(self:GetWaveEnd())
		net.Broadcast()

		for _, pl in pairs(team.GetPlayers(TEAM_UNDEAD)) do
			pl.m_LastWaveStartSpawn = CurTime()

			if pl:GetZombieClassTable().Name == "Crow" then
				pl:SetZombieClass(pl.DeathClass or 1)
				pl:UnSpectateAndSpawn()
			elseif not pl:Alive() and not pl.Revive then
				pl:UnSpectateAndSpawn()
			end
		end

		for _, pl in pairs(player.GetAll()) do
			pl.WaveBarricadeDamage = 0
			pl.WaveHumanDamage = 0
		end

		local curwave = self:GetWave()
		for _, ent in pairs(ents.FindByClass("logic_waves")) do
			if ent.Wave == curwave or ent.Wave == -1 then
				ent:Input("onwavestart", ent, ent, curwave)
			end
		end
		for _, ent in pairs(ents.FindByClass("logic_wavestart")) do
			if ent.Wave == curwave or ent.Wave == -1 then
				ent:Input("onwavestart", ent, ent, curwave)
			end
		end
	elseif self:GetWave() >= self:GetNumberOfWaves() then -- Last wave is over
		if self:GetUseSigils() then
			if self:GetEscapeStage() == ESCAPESTAGE_BOSS then
				-- 2 minutes is enough to decide people left are stuck or griefing.
				self:SetEscapeStage(ESCAPESTAGE_DEATH)

				gamemode.Call("SetWaveEnd", -1)
			elseif self:GetEscapeStage() == ESCAPESTAGE_ESCAPE then
				self:SetEscapeStage(ESCAPESTAGE_BOSS)

				-- Some time to get out with everyone spawning as bosses.
				gamemode.Call("SetWaveEnd", CurTime() + 45)

				-- Start spawning boss zombies.
			elseif self:GetEscapeStage() == ESCAPESTAGE_NONE then
				-- If we're using sigils, remove them all and spawn the doors.
				for _, sigil in pairs(ents.FindByClass("prop_obj_sigil")) do
					local ent = ents.Create("prop_obj_exit")
					if ent:IsValid() then
						ent:SetPos(sigil.NodePos or sigil:GetPos())
						ent:SetAngles(sigil:GetAngles())
						ent:Spawn()
					end

					sigil:Remove()
				end

				-- Some time to escape.
				gamemode.Call("SetWaveActive", true)
				gamemode.Call("SetWaveEnd", CurTime() + 45)
				self:SetEscapeStage(ESCAPESTAGE_ESCAPE)

				local curwave = self:GetWave()
				for _, ent in pairs(ents.FindByClass("logic_waves")) do
					if ent.Wave == curwave or ent.Wave == -1 then
						ent:Input("onwaveend", ent, ent, curwave)
					end
				end
				for _, ent in pairs(ents.FindByClass("logic_waveend")) do
					if ent.Wave == curwave or ent.Wave == -1 then
						ent:Input("onwaveend", ent, ent, curwave)
					end
				end
			end
		else
			-- If not using sigils then humans all win.
			gamemode.Call("EndRound", TEAM_HUMAN)

			local curwave = self:GetWave()
			for _, ent in pairs(ents.FindByClass("logic_waves")) do
				if ent.Wave == curwave or ent.Wave == -1 then
					ent:Input("onwaveend", ent, ent, curwave)
				end
			end
			for _, ent in pairs(ents.FindByClass("logic_waveend")) do
				if ent.Wave == curwave or ent.Wave == -1 then
					ent:Input("onwaveend", ent, ent, curwave)
				end
			end
		end
	else
		gamemode.Call("SetWaveStart", CurTime() + (GetGlobalBool("classicmode") and self.WaveIntermissionLengthClassic or self.WaveIntermissionLength))

		net.Start("zs_waveend")
			net.WriteInt(self:GetWave(), 16)
			net.WriteFloat(self:GetWaveStart())
		net.Broadcast()

		local pointsbonus
		if self.EndWavePointsBonus > 0 then
			pointsbonus = self.EndWavePointsBonus + (self:GetWave() - 1) * self.EndWavePointsBonusPerWave
		end

		for _, pl in pairs(player.GetAll()) do
			if pl:Team() == TEAM_HUMAN and pl:Alive() then
				if self.EndWaveHealthBonus > 0 then
					pl:SetHealth(math.min(pl:GetMaxHealth(), pl:Health() + self.EndWaveHealthBonus))
				end
				if pointsbonus then
					local pointsreward = pointsbonus + (pl.EndWavePointsExtra or 0)

					if pl:IsSkillActive(SKILL_SCOURER) then
						pl:GiveAmmo(math.ceil(pointsreward), "scrap")
					else
						pl:AddPoints(pointsreward, nil, nil, true)
					end
				end
			elseif pl:Team() == TEAM_UNDEAD and not pl:Alive() and not pl.Revive then
				local curclass = pl.DeathClass or pl:GetZombieClass()
				local crowindex = GAMEMODE.ZombieClasses["Crow"].Index
				pl:SetZombieClass(crowindex)
				pl:DoHulls(crowindex, TEAM_UNDEAD)
				pl.DeathClass = nil
				pl:UnSpectateAndSpawn()
				pl.DeathClass = curclass
			end

			pl.SkipCrow = nil
		end

		local curwave = self:GetWave()
		for _, ent in pairs(ents.FindByClass("logic_waves")) do
			if ent.Wave == curwave or ent.Wave == -1 then
				ent:Input("onwaveend", ent, ent, curwave)
			end
		end
		for _, ent in pairs(ents.FindByClass("logic_waveend")) do
			if ent.Wave == curwave or ent.Wave == -1 then
				ent:Input("onwaveend", ent, ent, curwave)
			end
		end
	end

	gamemode.Call("OnWaveStateChanged")
end

function GM:PlayerSwitchFlashlight(pl, newstate)
	if pl:Team() == TEAM_UNDEAD then
		return false
	end

	if pl:Team() == TEAM_HUMAN and CurTime() >= pl.NextFlashlightSwitch then
		pl.NextFlashlightSwitch = CurTime() + 0.75
		return true
	end

	return false
end

function GM:PlayerStepSoundTime(pl, iType, bWalking)
	return 350
end

function GM:OnZEWeaponPickup(pl, wep)
end

net.Receive("zs_changeclass", function(len, sender)
	if sender:Team() ~= TEAM_UNDEAD or sender.Revive or GAMEMODE.PantsMode or GAMEMODE:IsClassicMode() or GAMEMODE:IsBabyMode() or GAMEMODE.ZombieEscape then return end

	local classname = GAMEMODE:GetBestAvailableZombieClass(net.ReadString())
	local suicide = net.ReadBool()
	local classtab = GAMEMODE.ZombieClasses[classname]
	if not classtab or classtab.Disabled or classtab.Hidden and not (classtab.CanUse and classtab:CanUse(sender)) then return end

	if not gamemode.Call("IsClassUnlocked", classname) then
		sender:CenterNotify(COLOR_RED, translate.ClientFormat(sender, "class_not_unlocked_will_be_unlocked_x", classtab.Wave))
	elseif sender:GetZombieClassTable().Name == classname and not sender.DeathClass then
		sender:CenterNotify(COLOR_RED, translate.ClientFormat(sender, "you_are_already_a_x", translate.ClientGet(sender, classtab.TranslationName)))
	else
		sender.DeathClass = classtab.Index
		sender:CenterNotify(translate.ClientFormat(sender, "you_will_spawn_as_a_x", translate.ClientGet(sender, classtab.TranslationName)))

		if suicide and sender:Alive() and GAMEMODE:GetWaveActive() and (CurTime() < GAMEMODE:GetWaveEnd() - 4 or GAMEMODE:GetWaveEnd() < 0) and not sender:GetZombieClassTable().Boss and gamemode.Call("CanPlayerSuicide", sender) then
			sender:Kill()
		end
	end
end)

net.Receive("zs_zsfriend", function(len, sender)
	local zsfriendid = net:ReadString()
	local zsfriendent = player.GetBySteamID(zsfriendid)

	if not zsfriendent then return end
	local isfriend = net:ReadBool()
	sender.ZSFriends[zsfriendent] = isfriend

	net.Start("zs_zsfriendadded")
		net.WriteEntity(sender)
		net.WriteBool(isfriend)
	net.Send(zsfriendent)
end)


net.Receive("zs_nestspec", function(len, sender)
	if not sender:IsValidZombie() then return end
	if sender:GetObserverMode() == OBS_MODE_NONE then return end

	local nest = net:ReadEntity()
	local neveralive = sender:GetZombieClassTable().NeverAlive

	if neveralive and nest.MinionSpawn then
		sender:TrySpawnAsGoreChild(nest)
	end

	if sender:Alive() or neveralive then return end

	if nest:IsValid() then
		sender:Spectate(OBS_MODE_CHASE)
		sender:SpectateEntity(nest)
	end
end)
