AddCSLuaFile()

SWEP.PrintName = "'Juggernaut' M249"
SWEP.Description = "A light machine gun capable of immense firepower, firing additional red projectiles as it fires."

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.m249"
	SWEP.HUD3DPos = Vector(1.4, -1.3, 5)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/m249/m249-1.wav")
SWEP.Primary.Damage = 20
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.08

SWEP.Primary.ClipSize = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.Recoil = 4

SWEP.ConeMax = 6
SWEP.ConeMin = 2.4

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 5
SWEP.MaxStock = 2

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * (self:Clip1() == 2 and 5 or 1))

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)

	if self:Clip1() == 1 then
		self:EmitSound("weapons/sg552/sg552-1.wav", 70, 45, 0.95, CHAN_AUTO)
	end
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local zeroclip = self:Clip1() == 0

	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	if self.Recoil > 0 then
		local r2 = zeroclip and 1 or 0
		local r = math.Rand(0.8, 1) * r2
		owner:ViewPunch(Angle(r * -self.Recoil, r * (math.random(2) == 1 and -1 or 1) * self.Recoil, (r2 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
	end

	if SERVER and (self:Clip1() % 10 == 1 or zeroclip) then
		for i = 1, zeroclip and 8 or 1 do
			local ent = ents.Create("projectile_juggernaut")
			if ent:IsValid() then
				ent:SetPos(owner:GetShootPos())

				local angle = owner:GetAimVector():Angle()
				angle:RotateAroundAxis(angle:Up(), 90)
				ent:SetAngles(angle)

				ent:SetOwner(owner)
				ent.ProjDamage = self.Primary.Damage * 0.75 * (owner.ProjectileDamageMul or 1)
				ent.ProjSource = self
				ent.Team = owner:Team()

				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()

					angle = owner:GetAimVector():Angle()
					angle:RotateAroundAxis(angle:Forward(), math.Rand(0, 360))
					angle:RotateAroundAxis(angle:Up(), math.Rand(-cone/1.5, cone/1.5))
					phys:SetVelocityInstantaneous(angle:Forward() * 700 * (owner.ProjectileSpeedMul or 1))
				end
			end
		end
	end

	owner:LagCompensation(true)
	owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul * (zeroclip and 12 or 1), dmg / (zeroclip and 1.5 or 1), nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)
end
