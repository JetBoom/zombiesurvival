AddCSLuaFile()

SWEP.PrintName = "Harpoon"
SWEP.Description = "The harpoon has a very long range for a melee weapon. The harpoon can be thrown to impale into zombies, dealing damage over time."

if CLIENT then
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, -40), angle = Angle(-90, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.2, 1.363, -18), angle = Angle(-90, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "knife"

SWEP.DamageType = DMG_SLASH

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 45
SWEP.MeleeRange = 94
SWEP.MeleeSize = 0.8

SWEP.Primary.Delay = 1.65

SWEP.Tier = 2

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingRotation = Angle(0, -90, -60)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.6
SWEP.SwingHoldType = "slam"

SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.15, 1)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_sheet_impact_bullet"..math.random(2)..".wav", 70, math.random(90, 95))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(4)..".wav", 80, math.random(80, 85))
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	local owner = self:GetOwner()
	local tr = owner:TraceLine(60)
	if tr.HitWorld or (tr.Entity:IsValid() and not tr.Entity:IsPlayer()) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:SendWeaponAnim(ACT_VM_MISSCENTER)
	owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE)

	self.NextDeploy = CurTime() + 0.75

	if SERVER then
		local ent = ents.Create("projectile_harpoon")
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:SetAngles(owner:EyeAngles())
			ent:SetOwner(owner)
			ent.ProjDamage = self.MeleeDamage * (owner.ProjectileDamageMul or 1)
			ent.BaseWeapon = self:GetClass()
			ent:Spawn()
			ent.Team = owner:Team()
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:SetVelocityInstantaneous(self:GetOwner():GetAimVector() * 900 * (owner.ObjectThrowStrengthMul or 1))
			end
		end

		owner:StripWeapon(self:GetClass())
	end
end
