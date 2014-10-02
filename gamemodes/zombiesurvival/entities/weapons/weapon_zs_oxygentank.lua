AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Oxygen Tank"
	SWEP.Description = "Grants the user much higher air capacity."

	SWEP.ViewModelFOV = 60

	SWEP.Slot = 4

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 3, -1), angle = Angle(180, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 3, -1), angle = Angle(180, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/props_c17/canister01a.mdl"
SWEP.ModelScale = 0.5
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HoldType = "slam"

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

if CLIENT then return end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	timer.Simple(0, function()
		if IsValid(self) then
			self:SpawnTank()
		end
	end)
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)

	self:SpawnTank()
end

function SWEP:SpawnTank()
	local owner = self.Owner
	if not owner:IsValid() then return end

	for _, ent in pairs(ents.FindByClass("status_oxygentank")) do
		if ent:GetOwner() == owner then return end
	end

	local ent = ents.Create("status_oxygentank")
	if ent:IsValid() then
		ent:SetPos(owner:EyePos())
		ent:SetParent(owner)
		ent:SetOwner(owner)
		ent:Spawn()
	end
end
