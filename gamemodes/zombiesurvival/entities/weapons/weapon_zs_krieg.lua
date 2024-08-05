AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'크리그' SG552"
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.sg552_Parent"
	SWEP.HUD3DPos = Vector(-2.791, -5.597, -2.984)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.04
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_sg552.mdl"
SWEP.WorldModel = "models/weapons/w_rif_sg552.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_SG552.Single")
SWEP.Primary.Damage = 24
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Primary.DefaultDelay = 0.15
SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 0.09
SWEP.ConeMin = 0.04

SWEP.WalkSpeed = SPEED_SLOW
SWEP.IronSightsPos = Vector(-2.52, 3.819, 3.599)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:SetIronsights(b)
	self:SetDTBool(0, b)
	if self.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(self.IronSightsHoldType)
		else
			self:SetWeaponHoldType(self.HoldType)
		end
	end

	gamemode.Call("WeaponDeployed", self.Owner, self)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:Think()
	local owner = self.Owner
	if not self.Owner:KeyDown(IN_ATTACK2) then
		if self:GetIronsights() then
			self:SetIronsights(false)
		end
	end
end


if CLIENT then
SWEP.IronsightsMultiplier = 0.35
	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	local matScope = Material("zombiesurvival/scope")
	function SWEP:DrawHUDBackground()
		if self:IsScoped() then
			local scrw, scrh = ScrW(), ScrH()
			local size = math.min(scrw, scrh)
			surface.SetMaterial(matScope)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect((scrw - size) * 0.5, (scrh - size) * 0.5, size, size)
			surface.SetDrawColor(0, 0, 0, 255)
			if scrw > size then
				local extra = (scrw - size) * 0.5
				surface.DrawRect(0, 0, extra, scrh)
				surface.DrawRect(scrw - extra, 0, extra, scrh)
			end
			if scrh > size then
				local extra = (scrh - size) * 0.5
				surface.DrawRect(0, 0, scrw, extra)
				surface.DrawRect(0, scrh - extra, scrw, extra)
			end
		end
	end
end
