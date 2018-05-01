SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Wraith"

SWEP.MeleeDelay = 0.8
SWEP.MeleeReach = 48
SWEP.MeleeSize = 4.5
SWEP.MeleeDamage = 43
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.25

SWEP.AlertDelay = 6

SWEP.Primary.Delay = 1.8

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = ""

function SWEP:StopMoaningSound()
end

function SWEP:StartMoaningSound()
	self:GetOwner():EmitSound("zombiesurvival/wraithdeath"..math.random(4)..".ogg")
end

function SWEP:PlayHitSound()
	self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/antlion/distract1.wav")
end


local function viewpunch(ent, power)
	if ent:IsValid() and ent:Alive() then
		ent:ViewPunch(Angle(math.Rand(0.75, 1) * (math.random(0, 1) == 0 and 1 or -1), math.Rand(0.75, 1) * (math.random(0, 1) == 0 and 1 or -1), math.Rand(0.75, 1) * (math.random(0, 1) == 0 and 1 or -1)) * power)
	end
end

function SWEP:DoAlert()
	local owner = self:GetOwner()

	owner:EmitSound("npc/stalker/go_alert2a.wav", 90)
	owner:ViewPunch(Angle(-20, 0, math.Rand(-10, 10)))
	owner:DoReloadEvent()

	owner:LagCompensation(true)

	local mouthpos = owner:EyePos() + owner:GetUp() * -3
	local screampos = mouthpos + owner:GetAimVector() * 16
	for _, ent in pairs(ents.FindInSphere(screampos, 92)) do
		if ent and ent:IsValidHuman() then
			local entearpos = ent:EyePos()
			local dist = screampos:Distance(entearpos)
			if dist <= 92 and TrueVisible(entearpos, screampos) then
				local power = (92 / dist - 1) * 2
				viewpunch(ent, power)
				for i=1, 5 do
					timer.Simple(0.15 * i, function() viewpunch(ent, power - i * 0.125) end)
				end
			end
		end
	end

	owner:LagCompensation(false)
end

util.PrecacheSound("npc/antlion/distract1.wav")
util.PrecacheSound("ambient/machines/slicer1.wav")
util.PrecacheSound("ambient/machines/slicer2.wav")
util.PrecacheSound("ambient/machines/slicer3.wav")
util.PrecacheSound("ambient/machines/slicer4.wav")
util.PrecacheSound("npc/zombie/claw_miss1.wav")
util.PrecacheSound("npc/zombie/claw_miss2.wav")
