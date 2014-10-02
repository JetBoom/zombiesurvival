if string.sub(string.lower(game.GetMap()), 1, 3) ~= "ze_" then return end

GM.ZombieEscape = true
GM.WaveZeroLength = 90
GM.EndGameTime = 35
GM.ZE_FreezeTime = 20
GM.ZE_TimeLimit = 60 * 16

GM.DefaultZombieClass = GM.ZombieClasses["Super Zombie"].Index

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
	elseif pl:CallZombieFunction("Move", move) then
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
	if dmginfo:IsBulletDamage() then
		if hitgroup == HITGROUP_HEAD then
			pl.m_LastHeadShot = CurTime()
		end
	end

	if not pl:CallZombieFunction("ScalePlayerDamage", hitgroup, dmginfo) then
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
	scripted_ents.Register(ENT, "weapon_elite")
	scripted_ents.Register(ENT, "weapon_knife")
	scripted_ents.Register(ENT, "weapon_deagle")
	scripted_ents.Register(ENT, "ammo_50ae")
	scripted_ents.Register(ENT, "ammo_556mm_box")
	scripted_ents.Register(ENT, "player_weaponstrip")
end)
