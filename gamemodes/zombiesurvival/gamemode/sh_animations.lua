local TEAM_UNDEAD = TEAM_UNDEAD
local ACT_MP_STAND_IDLE = ACT_MP_STAND_IDLE

function GM:PlayerShouldTaunt(pl, actid)
	return (pl:Team() == TEAM_HUMAN or pl:Team() == TEAM_UNDEAD and pl:GetZombieClassTable().CanTaunt) and not IsValid(pl.Revive) and not IsValid(pl.FeignDeath)
end

function GM:CalcMainActivity(pl, velocity)
	pl.CalcIdeal = ACT_MP_STAND_IDLE
	pl.CalcSeqOverride = -1

	--[[if pl:CallZombieFunction("CalcMainActivity", velocity) then
		return pl.CalcIdeal, pl.CalcSeqOverride
	end]]
	if pl:Team() == TEAM_UNDEAD then
		local tab = pl:GetZombieClassTable()
		if tab.CalcMainActivity and tab:CalcMainActivity(pl, velocity) then
			return pl.CalcIdeal, pl.CalcSeqOverride
		end
	end

	return self.BaseClass.CalcMainActivity(self, pl, velocity)
end

function GM:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.UpdateAnimation and wep:UpdateAnimation(pl, velocity, maxseqgroundspeed) or pl:CallZombieFunction("UpdateAnimation", velocity, maxseqgroundspeed) then
		--[[if CLIENT then
			GAMEMODE:GrabEarAnimation(pl)
			GAMEMODE:MouthMoveAnimation(pl)
		end]]

		return
	end

	return self.BaseClass.UpdateAnimation(self, pl, velocity, maxseqgroundspeed)
end

function GM:DoAnimationEvent(pl, event, data)
	return pl:CallZombieFunction("DoAnimationEvent", event, data) or self.BaseClass:DoAnimationEvent(pl, event, data)
end

local CarryingActivityTranslate = {}
CarryingActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_SLAM
CarryingActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_IDLE_SLAM + 1
CarryingActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_IDLE_SLAM + 2
CarryingActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_SLAM + 3
CarryingActivityTranslate[ACT_MP_CROUCHWALK] = ACT_HL2MP_IDLE_SLAM + 4
CarryingActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_HL2MP_IDLE_SLAM + 5
CarryingActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_HL2MP_IDLE_SLAM + 5
CarryingActivityTranslate[ACT_MP_RELOAD_STAND] = ACT_HL2MP_IDLE_SLAM + 6
CarryingActivityTranslate[ACT_MP_RELOAD_CROUCH] = ACT_HL2MP_IDLE_SLAM + 6
CarryingActivityTranslate[ACT_MP_JUMP] = ACT_HL2MP_IDLE_SLAM + 7
CarryingActivityTranslate[ACT_RANGE_ATTACK1] = ACT_HL2MP_IDLE_SLAM + 8

function GM:TranslateActivity(pl, act)
	if pl:IsCarrying() then
		return CarryingActivityTranslate[act] or act
	end

	return self.BaseClass:TranslateActivity(pl, act)
end
