CLASS.Name = "Giga Gore Child"
CLASS.TranslationName = "class_giga_gore_child"
CLASS.Description = "description_giga_gore_child"
CLASS.Help = "controls_giga_gore_child"

CLASS.Boss = true

CLASS.KnockbackScale = 0

CLASS.Health = 2500
CLASS.Speed = 230

CLASS.Points = 40

CLASS.CanTaunt = true

CLASS.FearPerInstance = 1

CLASS.SWEP = "weapon_zs_gigagorechild"

CLASS.Model = Model("models/vinrax/player/doll_player.mdl")

CLASS.VoicePitch = 1

CLASS.ModelScale = 1.3

CLASS.CanFeignDeath = true

CLASS.Mass = 500
CLASS.ViewOffset = DEFAULT_VIEW_OFFSET * CLASS.ModelScale
CLASS.ViewOffsetDucked = DEFAULT_VIEW_OFFSET_DUCKED * CLASS.ModelScale
CLASS.StepSize = 25
CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 72)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 36)}

local math_random = math.random
local math_min = math.min
local math_max = math.max
local math_ceil = math.ceil
local CurTime = CurTime

local DIR_BACK = DIR_BACK
local ACT_HL2MP_ZOMBIE_SLUMP_RISE = ACT_HL2MP_ZOMBIE_SLUMP_RISE
local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)

	pl:EmitSound(StepSounds[math_random(#StepSounds)], 77, 50)

	if iFoot == 0 then
		pl:EmitSound("^npc/strider/strider_step4.wav", 90, math_random(90, 110))
	else
		pl:EmitSound("^npc/strider/strider_step5.wav", 90, math_random(90, 110))
	end

	return true
end

function CLASS:PlayDeathSound(pl)
	local pitch = math_random(60, 70)
	for i=1, 2 do
		pl:EmitSound("ambient/creatures/town_child_scream1.wav", 75, pitch)
	end

	return true
end

function CLASS:PlayPainSound(pl)
	pl:EmitSound("ambient/voices/citizen_beaten"..math_random(5)..".wav", 70, math_random(50, 60))
	pl.NextPainSound = CurTime() + 1.25

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetDirection() == DIR_BACK then
			return 1, pl:LookupSequence("zombie_slump_rise_02_fast")
		end

		return ACT_HL2MP_ZOMBIE_SLUMP_RISE, -1
	end

	if pl:WaterLevel() >= 3 then
		return ACT_HL2MP_SWIM_PISTOL, -1
	end

	if pl:Crouching() and pl:OnGround() then
		if velocity:Length2DSqr() <= 1 then
			return ACT_HL2MP_IDLE_CROUCH_ZOMBIE, -1
		end

		return ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math_ceil((CurTime() / 4 + pl:EntIndex()) % 3), -1
	end

	return ACT_HL2MP_RUN_ZOMBIE, -1
end

function CLASS:Move(pl, move)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsCrying and wep:IsCrying() then
		move:SetMaxSpeed(move:GetMaxSpeed() * 0.5)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.5)

		return true
	end
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	return GAMEMODE.BaseClass.PlayerStepSoundTime(GAMEMODE.BaseClass, pl, iType, bWalking) * 1.8
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetState() == 1 then
			pl:SetCycle(1 - math_max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		else
			pl:SetCycle(math_max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		end
		pl:SetPlaybackRate(0)
		return true
	end

	local len2d = velocity:Length2D()
	if len2d > 1 then
		pl:SetPlaybackRate(math_min(len2d / maxseqgroundspeed, 3))
	else
		pl:SetPlaybackRate(1)
	end

	pl:SetPlaybackRate(pl:GetPlaybackRate() * 0.5)

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:DoZombieAttackAnim(data)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_RELOAD then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_THROW, true)
		return ACT_INVALID
	end
end

function CLASS:DoesntGiveFear(pl)
	return pl.FeignDeath and pl.FeignDeath:IsValid()
end

if SERVER then
	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
		pl:FakeDeath(pl:LookupSequence("death_0"..math.random(4)), self.ModelScale)

		return true
	end

	function CLASS:PostOnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
		pl:SetZombieClass(GAMEMODE.DefaultZombieClass)
	end

	function CLASS:AltUse(pl)
		pl:StartFeignDeath()
	end

	function CLASS:OnSpawned(pl)
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
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/gigagorechild"

local render_ModelMaterialOverride = render.ModelMaterialOverride

local matSheet = Material("models/props_c17/doll01")
function CLASS:DrawHands(pl, hands)
	render_ModelMaterialOverride(matSheet)

	hands:DrawModel()

	render_ModelMaterialOverride(nil)

	return true
end

--[[function CLASS:ShouldDrawLocalPlayer()
	return true
end]]
