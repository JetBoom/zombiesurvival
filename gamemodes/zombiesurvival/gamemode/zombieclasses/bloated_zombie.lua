CLASS.Name = "Bloated Zombie"
CLASS.TranslationName = "class_bloated_zombie"
CLASS.Description = "description_bloated_zombie"
CLASS.Help = "controls_bloated_zombie"

CLASS.Wave = 3 / 6

CLASS.Health = 325
CLASS.Speed = 120
CLASS.JumpPower = 150
CLASS.Mass = DEFAULT_MASS * 2

CLASS.CanTaunt = true

CLASS.Points = 6

CLASS.SWEP = "weapon_zs_bloatedzombie"

CLASS.Model = Model("models/player/fatty/fatty.mdl")

CLASS.DeathSounds = {"npc/ichthyosaur/water_growl5.wav"}

CLASS.VoicePitch = 0.6

CLASS.CanFeignDeath = true

sound.Add({
	name = "fatty.footstep",
    channel = CHAN_BODY,
    volume = 0.8,
    soundlevel = 65,
    pitchstart = 75,
    pitchend = 75,
    sound = {"npc/zombie/foot1.wav", "npc/zombie/foot2.wav", "npc/zombie/foot3.wav"}
})

sound.Add({
	name = "fatty.footscuff",
    channel = CHAN_BODY,
    volume = 0.8,
    soundlevel = 65,
    pitchstart = 75,
    pitchend = 75,
    sound = {"npc/zombie/foot_slide1.wav", "npc/zombie/foot_slide2.wav", "npc/zombie/foot_slide3.wav"}
})

local DIR_BACK = DIR_BACK
local ACT_HL2MP_ZOMBIE_SLUMP_RISE = ACT_HL2MP_ZOMBIE_SLUMP_RISE
local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

function CLASS:PlayPainSound(pl)
	pl:EmitSound("npc/zombie_poison/pz_idle"..math.random(2, 3)..".wav", 72, math.Rand(75, 85))

	return true
end

local mathrandom = math.random
local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
local ScuffSounds = {
	"npc/zombie/foot_slide1.wav",
	"npc/zombie/foot_slide2.wav",
	"npc/zombie/foot_slide3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if mathrandom() < 0.15 then
		pl:EmitSound(ScuffSounds[mathrandom(#ScuffSounds)], 70, 75)
	else
		pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 70, 75)
	end

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetDirection() == DIR_BACK then
			pl.CalcSeqOverride = pl:LookupSequence("zombie_slump_rise_02_fast")
		else
			pl.CalcIdeal = ACT_HL2MP_ZOMBIE_SLUMP_RISE
		end

		return true
	end

	if pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_HL2MP_SWIM_PISTOL
	elseif pl:Crouching() then
		if velocity:Length2D() <= 0.5 then
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
		else
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
		end
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetState() == 1 then
			pl:SetCycle(1 - math.max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		else
			pl:SetCycle(math.max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		end
		pl:SetPlaybackRate(0)
		return true
	end

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
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
		return ACT_INVALID
	end
end

function CLASS:DoesntGiveFear(pl)
	return pl.FeignDeath and pl.FeignDeath:IsValid()
end

if SERVER then
	function CLASS:AltUse(pl)
		pl:StartFeignDeath()
	end

	local function Bomb(pl, pos, dir)
		if not IsValid(pl) then return end

		dir:RotateAroundAxis(dir:Right(), 30)

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(dir:Forward())
		util.Effect("fatexplosion", effectdata, true)

		for i=1, 6 do
			local ang = Angle()
			ang:Set(dir)
			ang:RotateAroundAxis(ang:Up(), math.Rand(-30, 30))
			ang:RotateAroundAxis(ang:Right(), math.Rand(-30, 30))

			local heading = ang:Forward()

			local ent = ents.CreateLimited("projectile_poisonflesh")
			if ent:IsValid() then
				ent:SetPos(pos)
				ent:SetOwner(pl)
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:SetVelocityInstantaneous(heading * math.Rand(120, 250))
				end
			end
		end
	end

	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
		if attacker ~= pl and not suicide then
			local pos = pl:LocalToWorld(pl:OBBCenter())
			local ang = pl:SyncAngles()
			timer.Simple(0, function() Bomb(pl, pos, ang) end)
		end
	end
end

if CLIENT then
	CLASS.Icon = "zombiesurvival/killicons/zombie"
end
