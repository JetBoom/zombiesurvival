CLASS.Name = "Red Marrow"
CLASS.TranslationName = "class_red_marrow"
CLASS.Description = "description_red_marrow"
CLASS.Help = "controls_red_marrow"

CLASS.Boss = true

CLASS.KnockbackScale = 0

CLASS.FearPerInstance = 1

CLASS.Points = 30

CLASS.Model = Model("models/player/skeleton.mdl")

CLASS.VoicePitch = 0.65

CLASS.SWEP = "weapon_zs_redmarrow"

CLASS.Health = 1800
CLASS.Speed = 165

CLASS.Skeletal = true

local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

local math_random = math.random
local math_ceil = math.ceil
local math_Clamp = math.Clamp

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if math_random(2) == 1 then
		pl:EmitSound("npc/barnacle/neck_snap1.wav", 75, math_random(125, 135))
	else
		pl:EmitSound("npc/barnacle/neck_snap2.wav", 75, math_random(125, 135))
	end

	return true
end

local painsounds = {"npc/metropolice/pain1.wav", "npc/metropolice/pain2.wav", "npc/metropolice/pain3.wav", "npc/metropolice/pain4.wav"}
function CLASS:PlayPainSound(pl)
	pl:EmitSound(table.Random(painsounds), 75, math_random(80, 90), 0.5)
	pl:EmitSound(table.Random(painsounds), 75, math_random(72, 82), 0.5)

	pl.NextPainSound = CurTime() + .7

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/stalker/go_alert2a.wav", 75, 75, 0.5)
	pl:EmitSound("npc/stalker/go_alert2a.wav", 75, 85, 0.5)

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	if pl:WaterLevel() >= 3 then
		return ACT_HL2MP_SWIM_PISTOL, -1
	end

	if pl:Crouching() and pl:OnGround() then
		if velocity:Length2D() <= 0.5 then
			return ACT_HL2MP_IDLE_CROUCH_ZOMBIE, -1
		end

		return ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3), -1
	end

	return ACT_HL2MP_RUN_ZOMBIE, -1

end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed, 3))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:DoZombieAttackAnim(data)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_RELOAD then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
		return ACT_INVALID
	end
end

function CLASS:ProcessDamage(pl, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local dmg = dmginfo:GetDamage()
	local hp = pl:Health()

	if pl:GetStatus("redmarrow") and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		dmginfo:SetDamage(0)
		dmginfo:ScaleDamage(0)
		dmg = 0
	end

	local numthreshold = math_Clamp(math_ceil(hp / 200), 1, 9)
	local dmgthreshold = math_Clamp(numthreshold * 200 - 200, 1, 1600)

	local newhp = hp - dmg
	local nulldmg = dmgthreshold - newhp

	if newhp <= dmgthreshold and pl["bloodth"..numthreshold] then
		pl["bloodth"..numthreshold] = false
		dmginfo:SetDamage(dmg - nulldmg)
		pl:GiveStatus("redmarrow", 3)

		local effectdata = EffectData()
			effectdata:SetOrigin(pl:WorldSpaceCenter())
		util.Effect("explosion_bonemesh", effectdata)

		pl:GodEnable()
		util.BlastDamageEx(pl, pl, pl:GetPos(), 55, 7, DMG_CLUB)
		pl:GodDisable()
	end
end
