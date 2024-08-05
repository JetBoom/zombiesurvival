AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'알라봉' RPG-7"
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "base"
	SWEP.HUD3DPos = Vector(10, 2.5, 0)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.035
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "rpg"

SWEP.ViewModel = Model( "models/weapons/v_rpg.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_rocket_launcher.mdl" )
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_RPG.Single")
SWEP.Primary.Damage = 250
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 6
SWEP.Primary.Recoil = 120

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "rpg"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then
		return
	end
	
	local owner = self.Owner
	if !IsValid(owner) then
		return
	end
	if SERVER then
		local ent = ents.Create("projectile_rocket")
		ent:SetPos(owner:GetShootPos() + owner:GetAimVector() * 10)
		ent:SetAngles((owner:GetAimVector()):Angle())
		ent.OriginalAngles = owner:GetAimVector():Angle()
		ent:SetOwner(owner)
		ent:SetInflictor(self)
		ent.Damage = self.Primary.Damage
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(owner:GetAimVector() * ent.Vel)
		end
		owner:SetVelocity(-(owner:GetAimVector() * Vector(1, 1, 0.35)) * ent.Vel)
	end
	
	self:TakePrimaryAmmo(1)
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end