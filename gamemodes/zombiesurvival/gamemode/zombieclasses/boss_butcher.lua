CLASS.Name = "The Butcher"
CLASS.TranslationName = "class_butcher"
CLASS.Description = "description_butcher"
CLASS.Help = "controls_butcher"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = true

CLASS.Health = 750
CLASS.Speed = 190

CLASS.CanTaunt = true

CLASS.FearPerInstance = 1

CLASS.Points = 30

CLASS.SWEP = "weapon_zs_butcherknifez"

CLASS.Model = Model("models/player/corpse1.mdl")

CLASS.VoicePitch = 0.65

CLASS.PainSounds = {"npc/zombie/zombie_pain1.wav", "npc/zombie/zombie_pain2.wav", "npc/zombie/zombie_pain3.wav", "npc/zombie/zombie_pain4.wav", "npc/zombie/zombie_pain5.wav", "npc/zombie/zombie_pain6.wav"}
CLASS.DeathSounds = {"npc/zombie/zombie_die1.wav", "npc/zombie/zombie_die2.wav", "npc/zombie/zombie_die3.wav"}

local ACT_HL2MP_SWIM_MELEE = ACT_HL2MP_SWIM_MELEE
local ACT_HL2MP_IDLE_CROUCH_MELEE = ACT_HL2MP_IDLE_CROUCH_MELEE
local ACT_HL2MP_WALK_CROUCH_MELEE = ACT_HL2MP_WALK_CROUCH_MELEE
local ACT_HL2MP_IDLE_MELEE = ACT_HL2MP_IDLE_MELEE
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE
local ACT_HL2MP_RUN_MELEE = ACT_HL2MP_RUN_MELEE
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

local mathrandom = math.random
local StepLeftSounds = {
	"npc/fast_zombie/foot1.wav",
	"npc/fast_zombie/foot2.wav"
}
local StepRightSounds = {
	"npc/fast_zombie/foot3.wav",
	"npc/fast_zombie/foot4.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound(StepLeftSounds[mathrandom(#StepLeftSounds)], 70)
	else
		pl:EmitSound(StepRightSounds[mathrandom(#StepRightSounds)], 70)
	end

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	if pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_HL2MP_SWIM_MELEE
		return true
	end

	local swinging = false
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and CurTime() < wep:GetNextPrimaryFire() then
		swinging = true
	end

	if pl:Crouching() then
		if velocity:Length2D() <= 0.5 then
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_MELEE
		else
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_MELEE
		end
	elseif velocity:Length2D() <= 0.5 then
		if swinging then
			pl.CalcIdeal = ACT_HL2MP_IDLE_MELEE
		else
			pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
		end
	elseif swinging then
		pl.CalcIdeal = ACT_HL2MP_RUN_MELEE
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
	end

	return true
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
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
		return ACT_INVALID
	end
end

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("butcherambience")
	end

	local function MakeButcherKnife(pos)
		local ent = ents.Create("prop_weapon")
		if ent:IsValid() then
			ent:SetPos(pos)
			ent:SetAngles(AngleRand())
			ent:SetWeaponType("weapon_zs_butcherknife")
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:SetVelocityInstantaneous(VectorRand():GetNormalized() * math.Rand(24, 100))
				phys:AddAngleVelocity(VectorRand() * 200)
			end
		end
	end

	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
		local pos = pl:LocalToWorld(pl:OBBCenter())
		timer.Simple(0, function()
			MakeButcherKnife(pos)
		end)
	end
end

if not CLIENT then return end

--CLASS.Icon = "zombiesurvival/killicons/butcher"

function CLASS:PrePlayerDraw(pl)
	render.SetColorModulation(1, 0.5, 0.5)
end

function CLASS:PostPlayerDraw(pl)
	render.SetColorModulation(1, 1, 1)
end
