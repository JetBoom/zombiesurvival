AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Impaler' Crossbow"
	SWEP.Description = "This ancient weapon can easily skewer groups of zombies."

	SWEP.HUD3DBone = "ValveBiped.Crossbow_base"
	SWEP.HUD3DPos = Vector(1.5, 0.5, 11)
	SWEP.HUD3DScale = 0.025

	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.Slot = 3
	SWEP.SlotPos = 0
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "crossbow"

SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Delay = 2.0
SWEP.Primary.DefaultClip = 15

SWEP.SecondaryDelay = 0.25

SWEP.WalkSpeed = SPEED_SLOW

SWEP.NextZoom = 0

if SERVER then
	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

			local owner = self.Owner

			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			owner:RestartGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW)

			self:TakePrimaryAmmo(1)

			self.IdleAnimation = CurTime() + self:SequenceDuration()

			self:EmitSound("Weapon_Crossbow.Single")

			local ent = ents.Create("projectile_arrow")
			if ent:IsValid() then
				ent:SetOwner(owner)
				ent:SetPos(owner:GetShootPos())
				ent:SetAngles(owner:GetAimVector():Angle())
				ent.Team = owner:Team()
				ent:Spawn()
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:SetVelocityInstantaneous(owner:GetAimVector() * 1400)
				end
			end
		end
	end

	function SWEP:Reload()
		if self:GetNextReload() <= CurTime() and self:Clip1() == 0 and 0 < self.Owner:GetAmmoCount("XBowBolt") then
			self:EmitSound("weapons/crossbow/bolt_load"..math.random(2)..".wav", 50, 100)
			self:EmitSound("weapons/crossbow/reload1.wav")
			self:DefaultReload(ACT_VM_RELOAD)
			self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_CROSSBOW)
			self:SetNextReload(CurTime() + self:SequenceDuration())
		end
	end

	function SWEP:SecondaryAttack()
		if CurTime() < self.NextZoom then return end

		self.NextZoom = CurTime() + self.SecondaryDelay

		local zoomed = self:GetDTBool(1)
		self:SetDTBool(1, not zoomed)

		if zoomed then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.15)
			self:EmitSound("weapons/sniper/sniper_zoomout.wav", 50, 100)
		else
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired") * 0.25, 0.15)
			self:EmitSound("weapons/sniper/sniper_zoomin.wav", 50, 100)
		end
	end
end

if CLIENT then
	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:TakePrimaryAmmo(1)
			self:EmitSound("Weapon_Crossbow.Single")
			self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW)
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.IdleAnimation = CurTime() + self:SequenceDuration()
		end
	end

	function SWEP:SecondaryAttack()
		if CurTime() < self.NextZoom then return end
		self.NextZoom = CurTime() + self.SecondaryDelay

		local zoomed = self:GetDTBool(1)
		self:SetDTBool(1, not zoomed)
		if zoomed then
			surface.PlaySound("weapons/sniper/sniper_zoomout.wav")
		else
			surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
		end
	end

	function SWEP:Reload()
		if self:GetNextReload() <= CurTime() and self:Clip1() == 0 and 0 < self.Owner:GetAmmoCount("XBowBolt") then
			surface.PlaySound("weapons/crossbow/bolt_load"..math.random(1,2)..".wav")
			self:DefaultReload(ACT_VM_RELOAD)
			self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_CROSSBOW)
			self:SetNextReload(CurTime() + self:SequenceDuration())
		end
	end

	local texScope = surface.GetTextureID("zombiesurvival/scope")
	function SWEP:DrawHUDBackground()
		if self:GetDTBool(1) then
			local scrw, scrh = ScrW(), ScrH()
			local size = math.min(scrw, scrh)

			local hw = scrw * 0.5
			local hh = scrh * 0.5

			surface.SetDrawColor(255, 0, 0, 180)
			surface.DrawLine(0, hh, scrw, hh)
			surface.DrawLine(hw, 0, hw, scrh)
			for i=1, 10 do
				surface.DrawLine(hw, hh + i * 7, hw + (50 - i * 5), hh + i * 7)
			end

			surface.SetTexture(texScope)
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

function SWEP:Holster()
	if self:GetDTBool(1) then
		self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.5)
		self:EmitSound("weapons/sniper/sniper_zoomout.wav", 50, 100)
		self:SetDTBool(1, false)
	end

	return true
end

function SWEP:OnRemove()
	if self.Owner:IsValid() and self:GetDTBool(1) then
		self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.5)
	end
end

util.PrecacheSound("weapons/crossbow/bolt_load1.wav")
util.PrecacheSound("weapons/crossbow/bolt_load2.wav")
util.PrecacheSound("weapons/sniper/sniper_zoomin.wav")
util.PrecacheSound("weapons/sniper/sniper_zoomout.wav")
