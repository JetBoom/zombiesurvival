AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = "'sawdoff' Shotgun"
SWEP.Description = "A basic shotgun that can deal significant amounts of damage at close range."

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DPos = Vector(4, -3.5, -1.2)
	SWEP.HUD3DAng = Angle(90, 0, -30)
	SWEP.HUD3DScale = 0.02
	SWEP.HUD3DBone = "SS.Grip.Dummy"
end

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true


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


SWEP.ReloadDelay = 1.0

SWEP.Primary.Sound = Sound("weapons/zs_sawnoff/sawnoff_fire1.ogg")
SWEP.Primary.Damage = 13.325
SWEP.Primary.NumShots = 8
SWEP.Primary.Delay = 0.8

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 8.75
SWEP.ConeMin = 5

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.PumpSound = Sound("Weapon_M3.Pump")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

SWEP.PumpActivity = ACT_SHOTGUN_PUMP

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'double' Slug Gun", "Single accurate slug round, less total damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 8.5
	wept.Primary.NumShots = 1
	wept.ConeMin = wept.ConeMin * 0.15
	wept.ConeMax = wept.ConeMax * 0.3
end)

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)

	timer.Simple(0.15, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)

			if CLIENT and self:GetOwner() == MySelf then
				self:EmitSound("weapons/m3/m3_pump.wav", 65, 100, 0.4, CHAN_AUTO)
			end
		end
	end)
end
