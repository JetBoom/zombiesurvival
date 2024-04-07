CLASS.Hidden = true
CLASS.Disabled = true
CLASS.Unlocked = true

CLASS.Name = "Chem Zombie"
CLASS.TranslationName = "class_chem_zombie"
CLASS.Description = "description_chem_zombie"
CLASS.Help = "controls_chem_zombie"

CLASS.Wave = 6 / 6
--CLASS.Sanity = 2 / 3
CLASS.Health = 100
CLASS.SWEP = "weapon_zs_chemzombie"
CLASS.Model = Model("models/Zombie/Poison.mdl")
CLASS.Speed = 160

CLASS.Points = 3

CLASS.PainSounds = {Sound("npc/metropolice/knockout2.wav"), Sound("npc/metropolice/pain1.wav"), Sound("npc/metropolice/pain2.wav"), Sound("npc/metropolice/pain3.wav"), Sound("npc/metropolice/pain4.wav")}
CLASS.DeathSounds = {Sound("ambient/fire/gascan_ignite1.wav")}
CLASS.VoicePitch = 0.65

CLASS.ViewOffset = Vector(0, 0, 50)
CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 64)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 35)}

local math_random = math.random

local ACT_IDLE = ACT_IDLE

function CLASS:CanUse(pl)
	return false
end

function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2DSqr() <= 1 then
		return ACT_IDLE, -1
	end

	return 1, 2
end

local StepSounds = {
	"npc/zombie_poison/pz_left_foot1.wav"
}
local ScuffSounds = {
	"npc/zombie_poison/pz_right_foot1.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 and math_random() < 0.333 then
		pl:EmitSound(ScuffSounds[math_random(#ScuffSounds)], 80, 90)
	else
		pl:EmitSound(StepSounds[math_random(#StepSounds)], 80, 90)
	end

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 365 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 300
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 450
	end

	return 150
end

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("chemzombieambience")
	end

	hook.Add("InitPostEntityMap", "MakeChemDummy", function()
		DUMMY_CHEMZOMBIE = ents.Create("dummy_chemzombie")
		if DUMMY_CHEMZOMBIE:IsValid() then
			DUMMY_CHEMZOMBIE:Spawn()
		end
	end)

	local function ChemBomb(pl, pos)
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("explosion_chem", effectdata, true)

		if DUMMY_CHEMZOMBIE:IsValid() then
			DUMMY_CHEMZOMBIE:SetPos(pos)
		end
		util.PoisonBlastDamage(DUMMY_CHEMZOMBIE, pl, pos, 128, 85, true)

		pl:CheckRedeem()
	end

	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
		if attacker ~= pl and not suicide then
			local pos = pl:LocalToWorld(pl:OBBCenter())

			pl:Gib(dmginfo)
			timer.Simple(0, function() ChemBomb(pl, pos) end)

			return true
		end
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/chemzombie"
