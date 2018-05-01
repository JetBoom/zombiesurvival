AddCSLuaFile()

--in memory of Gormaoife 1999-2016 rip

SWEP.PrintName = "'Splinter' Sawed-Off Shotgun"
SWEP.Description = "Can fire both rounds at once for higher burst damage."

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(0.052, 1.702, -7.329), angle = Angle(-54.559, -90, -180), size = Vector(0.057, 0.035, 0.041), color = Color(190, 150, 95, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-5.421, -0.101, -0.819), angle = Angle(-52.792, 0, 0), size = Vector(0.187, 0.382, 0.035), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["barrel"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "break", pos = Vector(-1.89, 0.186, 1.929), angle = Angle(0, 36.453, 0), size = Vector(0.1, 0.019, 0.019), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["break"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(-1.063, 0.196, 2.507), angle = Angle(-126.469, 90, 90), size = Vector(0.019, 0.019, 0.045), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_lab/blastdoor001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-6.325, -0.13, -4.14), angle = Angle(0, 90, -36.279), size = Vector(0.211, 0.05, 0.014), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["barrel+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "break", pos = Vector(-1.89, 0.186, 0.338), angle = Angle(0, 36.453, 0), size = Vector(0.1, 0.019, 0.019), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_combine/combine_interface003.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-2.258, 0, -1.691), angle = Angle(35.486, 0, 0), size = Vector(0.097, 0.041, 0.071), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/combine_dropship_container.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "break", pos = Vector(-1.009, 1.552, 1.004), angle = Angle(0, 37.951, -90), size = Vector(0.018, 0.019, 0.014), color = Color(190, 150, 95, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["break"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-8.749, -1.099, -4.579), angle = Angle(135, 0, 90), size = Vector(0.019, 0.019, 0.045), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-5.421, -0.101, -0.819), angle = Angle(-52.792, 0, 0), size = Vector(0.187, 0.382, 0.035), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["barrel"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-10.634, 0.66, -4.819), angle = Angle(37.5, 0, 0), size = Vector(0.1, 0.019, 0.019), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/combine_dropship_container.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-9.98, -0.201, -6.435), angle = Angle(39.694, 0, 0), size = Vector(0.018, 0.019, 0.014), color = Color(190, 150, 95, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.888, 1.406, -0.543), angle = Angle(130.128, 5.808, 0), size = Vector(0.057, 0.035, 0.041), color = Color(190, 150, 95, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["barrel+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-10.634, -0.854, -4.819), angle = Angle(37.5, 0, 0), size = Vector(0.1, 0.019, 0.019), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_combine/combine_interface003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-2.258, 0, -1.691), angle = Angle(35.486, 0, 0), size = Vector(0.097, 0.041, 0.071), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_lab/blastdoor001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-6.325, -0.13, -4.14), angle = Angle(0, 90, -36.279), size = Vector(0.211, 0.05, 0.014), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} }
	}

	SWEP.HUD3DBone = "ValveBiped.Crossbow_base"
	SWEP.HUD3DPos = Vector(1.8, -0.65, -3.3)
	SWEP.HUD3DScale = 0.015
end

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/zs_sawnoff/sawnoff_fire1.ogg")
SWEP.Primary.Damage = 11.35
SWEP.Primary.NumShots = 8
SWEP.Primary.Delay = 0.6
SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSound = Sound("weapons/zs_sawnoff/barrelup.ogg")
SWEP.ReloadFinishSound = Sound("weapons/zs_sawnoff/barreldown.ogg")
SWEP.ReloadPlugSound = Sound("Weapon_Shotgun.Reload")

SWEP.ConeMax = 9
SWEP.ConeMin = 7.75
SWEP.Recoil = 7.5

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.ReloadSpeed = 0.6
SWEP.ReloadDelay = 0.5

SWEP.Tier = 2

SWEP.DryFireSound = Sound("Weapon_Shotgun.Empty")

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -1.125, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -1.069, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Splinter' Slug Gun", "Single accurate slug round, less total damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 5.5
	wept.Primary.NumShots = 1
	wept.ConeMin = wept.ConeMin * 0.15
	wept.ConeMax = wept.ConeMax * 0.3
end)

SWEP.ReloadStartActivity = ACT_VM_RELOAD
SWEP.ReloadActivity = ACT_VM_HOLSTER

function SWEP:StartReloading()
	local delay = self:GetReloadDelay()
	self:SetDTFloat(3, CurTime() + delay)
	self:SetDTBool(2, true) -- force one shell load
	self:SetNextPrimaryFire(CurTime() + math.max(self.Primary.Delay, delay))

	self:GetOwner():DoReloadEvent()

	if self.ReloadStartActivity then
		self:SendWeaponAnim(self.ReloadStartActivity)
		self:ProcessReloadAnim()
		self:SetNextPlugSound(CurTime() + delay * 0.9)
		self:SetNextStateChange(CurTime() + delay * 0.8)
	end

	self:EmitSound(self.ReloadSound)
end

function SWEP:StopReloading()
	self:SetDTFloat(3, 0)
	self:SetDTBool(2, false)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 0.45)
	self:SetNextStateChange(CurTime())

	if self:Clip1() > 0 then
		self:EmitSound(self.ReloadFinishSound)
		self:SendWeaponAnim(ACT_VM_IDLE)
		self:ProcessReloadAnim()
	end
end

function SWEP:Think()
	if self:ShouldDoReload() then
		self:DoReload()
	end

	if self:GetNextPlugSound() ~= 0 and CurTime() > self:GetNextPlugSound() then
		if self:Clip1() ~= 2 then
			self:EmitSound(self.ReloadPlugSound)
		end
		self:SetNextPlugSound(0)
	end

	if self:GetNextStateChange() ~= 0 and CurTime() > self:GetNextStateChange() then
		self:SetSawnoffState((self:GetSawnoffState() + 1) % 2)
		self:SetNextStateChange(0)
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:DoReload()
	if not self:CanReload() then
		self:StopReloading()
		return
	end

	local delay = self:GetReloadDelay()
	if self.ReloadActivity then
		self:SendWeaponAnim(self.ReloadActivity)
		self:ProcessReloadAnim()
		self:SetNextPlugSound(CurTime() + delay * 0.9)

		timer.Simple(0, function() if IsValid(self) then self:SendWeaponAnim(ACT_VM_RELOAD) end end)
	end

	self:GetOwner():RemoveAmmo(1, self.Primary.Ammo, false)
	self:SetClip1(self:Clip1() + 1)

	self:SetDTBool(2, false)
	self:SetDTFloat(3, CurTime() + delay)

	self:SetNextPrimaryFire(CurTime() + math.max(self.Primary.Delay, delay))
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)

		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end

	local multiplier = self:Clip1()

	self.Primary.NumShots = self.Primary.NumShots * multiplier
	self.RequiredClip = multiplier
	self.OldEmitFireSound = self.EmitFireSound
	self.EmitFireSound = self.EmitFireSoundDouble

	self:PrimaryAttack()

	self.Primary.NumShots = self.Primary.NumShots / multiplier
	self.RequiredClip = 1
	self.EmitFireSound = self.OldEmitFireSound
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(97, 103), 1, CHAN_WEAPON + 20)
end

function SWEP:EmitFireSoundDouble()
	if self:Clip1() == 2 then
		self:EmitSound(self.Primary.Sound, 80, math.random(80, 85), 1, CHAN_WEAPON + 20)
	else
		self:OldEmitFireSound()
	end
end

function SWEP:GetNextPlugSound()
	return self:GetDTFloat(10)
end

function SWEP:SetNextPlugSound(nexttime)
	self:SetDTFloat(10, nexttime)
end

function SWEP:GetNextStateChange()
	return self:GetDTFloat(11)
end

function SWEP:SetNextStateChange(nexttime)
	self:SetDTFloat(11, nexttime)
end

function SWEP:GetSawnoffState()
	return self:GetDTInt(10)
end

function SWEP:SetSawnoffState(state)
	self:SetDTInt(10, state)
end

if CLIENT then
	function SWEP:PreDrawViewModel(vm)
		self.BaseClass.PreDrawViewModel(self, vm)

		local ang = self.VElements["break"].angle
		ang.pitch = math.Approach(ang.pitch, self:GetSawnoffState() == 1 and 16 or -126, FrameTime() * 730)
	end
end
