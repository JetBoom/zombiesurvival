AddCSLuaFile()

SWEP.PrintName = "Rebar Mace"
SWEP.Description = "Disorients zombies hit."

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_debris/rebar004b_48.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.194, 2.111, -16.512), angle = Angle(0, 0, 0), size = Vector(0.8, 0.8, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_debris/rebar004b_48.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.244, 3.529, -15.808), angle = Angle(-3.796, 1.958, -4.97), size = Vector(0.8, 0.8, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 135
SWEP.MeleeRange = 70
SWEP.MeleeSize = 3
SWEP.MeleeKnockBack = 300

SWEP.Primary.Delay = 1.4

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.SwingRotation = Angle(60, 0, -80)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingTime = 0.8
SWEP.SwingHoldType = "melee"

SWEP.Tier = 3

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.15)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "Rebar Ward Hammer", "Grants defence on kill, does not knockback zombie vision, faster but less damage and knockback", function(wept)
	wept.Primary.Delay = wept.Primary.Delay * 0.8
	wept.MeleeDamage = wept.MeleeDamage * 0.75
	wept.MeleeKnockBack = 200

	wept.OnZombieKilled = function(self, zombie, total, dmginfo)
		local killer = self:GetOwner()

		if killer:IsValid() then
			killer:GiveStatus("medrifledefboost", 15)
		end
	end

	if SERVER then
		wept.OnMeleeHit = function() end
	end
end)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(55, 65))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav", 75, math.random(95, 105))
end

if SERVER then
function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and CurTime() >= (hitent._NextLeadPipeEffect or 0) then
		hitent._NextLeadPipeEffect = CurTime() + 1.5

		--hitent:GiveStatus("disorientation")
		local x = math.Rand(0.75, 1)
		x = x * (math.random(2) == 2 and 1 or -1)

		local ang = Angle(1 - x, x, 0) * 50
		hitent:ViewPunch(ang)

		local eyeangles = hitent:EyeAngles()
		eyeangles:RotateAroundAxis(eyeangles:Up(), ang.yaw)
		eyeangles:RotateAroundAxis(eyeangles:Right(), ang.pitch)
		eyeangles.pitch = math.Clamp(ang.pitch, -89, 89)
		eyeangles.roll = 0
		hitent:SetEyeAngles(eyeangles)
	end
end
end
