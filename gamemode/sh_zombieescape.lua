if string.sub(string.lower(game.GetMap()), 1, 3) ~= "ze_" then return end

GM.ZombieEscape = true
GM.WaveZeroLength = 90
GM.EndGameTime = 35
GM.ZE_FreezeTime = 20
GM.ZE_TimeLimit = 60 * 16

GM.DefaultZombieClass = GM.ZombieClasses["Super Zombie"].Index

DEFAULT_JUMP_POWER = 195

local CSSWEAPONS = {"weapon_knife","weapon_glock","weapon_usp","weapon_p228","weapon_deagle",
	"weapon_elite","weapon_fiveseven","weapon_m3","weapon_xm1014","weapon_galil",
	"weapon_ak47","weapon_scout","weapon_sg552","weapon_awp","weapon_g3sg1",
	"weapon_famas","weapon_m4a1","weapon_aug","weapon_sg550","weapon_mac10",
	"weapon_tmp","weapon_mp5navy","weapon_ump45","weapon_p90","weapon_m249"}

function GM:Move(pl, move)
	if pl:Team() == TEAM_HUMAN then
		if pl:GetBarricadeGhosting() then
			move:SetMaxSpeed(36)
			move:SetMaxClientSpeed(36)
		elseif move:GetForwardSpeed() < 0 then
			move:SetMaxSpeed(move:GetMaxSpeed() * 0.9)
			move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.9)
		elseif move:GetForwardSpeed() == 0 then
			move:SetMaxSpeed(move:GetMaxSpeed() * 0.95)
			move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.95)
		end
	elseif pl:CallZombieFunction1("Move", move) then
		return
	end

	local legdamage = pl:GetLegDamage()
	if legdamage > 0 then
		local scale = 1 - math.min(1, legdamage * 0.25)
		move:SetMaxSpeed(move:GetMaxSpeed() * scale)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed() * scale)
	end
end

function GM:GetZombieDamageScale(pos, ignore)
	return self.ZombieDamageMultiplier
end

function GM:ScalePlayerDamage(pl, hitgroup, dmginfo)
	if not dmginfo:IsBulletDamage() then return end

	if dmginfo:IsBulletDamage() and hitgroup == HITGROUP_HEAD then
		pl.m_LastHeadShot = CurTime()
	end

	if not pl:CallZombieFunction2("ScalePlayerDamage", hitgroup, dmginfo) then
		if hitgroup == HITGROUP_HEAD then
			dmginfo:SetDamage(dmginfo:GetDamage() * 2)
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_GEAR then
			dmginfo:SetDamage(dmginfo:GetDamage() * 0.25)
		elseif hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			dmginfo:SetDamage(dmginfo:GetDamage() * 0.75)
		end
	end

	if pl:Team() == TEAM_UNDEAD and self:PlayerShouldTakeDamage(pl, dmginfo:GetAttacker()) then
		pl:AddLegDamage(((hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG) and 1 or 0.125) * dmginfo:GetDamage())
	end
end

-- Creates some dummy entities so we don't get spammed in the console.

local ENT = {}

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_NONE

function ENT:Initialize()
	self:SetNoDraw(true)
end

if SERVER then
function ENT:Think()
	self:Remove()
end
end

hook.Add("Initialize", "RegisterDummyEntities", function()
	scripted_ents.Register(ENT, "ammo_50ae")
	scripted_ents.Register(ENT, "ammo_556mm_box")
	scripted_ents.Register(ENT, "player_weaponstrip")

	--CSS Weapons for ZE map parenting
	for i, weapon in pairs(CSSWEAPONS) do
		weapons.Register({Base = "weapon_map_base"},weapon)
	end
end)

hook.Add( "PlayerCanPickupWeapon", "RestrictMapWeapons", function( ply, wep )
	if wep:GetClass() == "weapon_knife" then
		if ply:Team() == TEAM_HUMAN then return false end
	else
		if table.HasValue(CSSWEAPONS,wep:GetClass()) and ply:Team() == TEAM_UNDEAD then return false end
	end

	local weps = ply:GetWeapons()
	--Only allow one special weapon per player
	for k, v in pairs(weps) do
		if table.HasValue( CSSWEAPONS, v:GetClass() ) or v:GetClass() == "weapon_map_base" then return false end
	end

	return true
end)
