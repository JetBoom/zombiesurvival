AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = translate.Get("weapon_katana")

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -45.715, 0) },
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -49.524, 0) }
	}
	SWEP.VElements = {
		["katana"] = { type = "Model", model = "models/weapons/w_katana.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.941, 2.631, -6.678), angle = Angle(90, 180, -53.116), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		--["katana"] = { type = "Model", model = "models/weapons/w_katana.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-5.941, -10.631, -6.678), angle = Angle(90, 180, -53.116), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		--["base"] = { type = "Model", model = "models/weapons/w_katana.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 4.091, -8.636), angle = Angle(180, -60.341, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/v_katana.mdl"
SWEP.WorldModel = "models/weapons/w_katana.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 100
SWEP.MeleeRange = 60
SWEP.MeleeSize = 1.25

SWEP.Primary.Delay = 0.6

SWEP.SwingTime = 0.5



swings = {"30, -30, -30", "10, -20, -30","50, 20, -30" }
swings2 = {"0, -30, 0", "0, -60, 0" }

SWEP.SwingRotation = Angle(table.Random(swings))
SWEP.SwingOffset = Vector(table.Random(swings2))
SWEP.SwingHoldType = "grenade"

function SWEP:Deploy()
	if SERVER then
		--if self.Owner:FlashlightIsOn() and self.Owner:GetHumanClass() ~= 3 then
			--self.Owner:Flashlight( false )
		--end
	
	end
	self.Weapon:EmitSound("weapons/katana/draw.wav")
	-- Draw animation
	self.Weapon:SendWeaponAnim ( ACT_VM_DRAW )

	if SERVER then
		GAMEMODE:WeaponDeployed( self.Owner, self )
	end
	
	return true
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/katana/katana_0"..math.random(3)..".wav")
end