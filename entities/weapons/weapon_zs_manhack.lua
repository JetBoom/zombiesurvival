AddCSLuaFile()

SWEP.PrintName = "Manhack"
SWEP.Description = "A deployable, remotely controlled device.\nIdeal for scouting but also can be used for attacking from safety.\nHas sharp blades that pierce into zombies."

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false

	SWEP.ViewModelBoneMods = {
		["ValveBiped.cube1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.cube2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.cube3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.cube"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/manhack.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 4, 0), angle = Angle(-54.206, 58.294, -50.114), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/manhack.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 5, 0), angle = Angle(-43.978, 27.614, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_bugbait.mdl"
SWEP.WorldModel = "models/manhack.mdl"
SWEP.UseHands = true

SWEP.DeployClass = "prop_manhack"
SWEP.ControlWeapon = "weapon_zs_manhackcontrol"

SWEP.HoldType = "grenade"

SWEP.WalkSpeed = SPEED_FAST

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "manhack"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"

SWEP.MaxStock = 10

SWEP.WalkSpeed = SPEED_FAST

function SWEP:Initialize()
	self:SetWeaponHoldType("grenade")
	GAMEMODE:DoChangeDeploySpeed(self)

	if CLIENT then
		self:Anim_Initialize()
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	for _, ent in pairs(ents.FindByClass("prop_manhack*")) do
		if ent:GetObjectOwner() == self:GetOwner() then return false end
	end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local owner = self:GetOwner()
	self:SendWeaponAnim(ACT_VM_THROW)
	owner:DoAttackEvent()

	self:TakePrimaryAmmo(1)
	self.NextDeploy = CurTime() + 0.75

	if SERVER then
		local ent = ents.Create(self.DeployClass)
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:Spawn()
			ent:SetObjectOwner(owner)
			ent:SetupPlayerSkills()

			local stored = owner:PopPackedItem(ent:GetClass())
			if stored then
				ent:SetObjectHealth(stored[1])
			end

			ent:EmitSound("WeaponFrag.Throw")
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:SetVelocityInstantaneous(self:GetOwner():GetAimVector() * 200)
			end

			if not owner:HasWeapon(self.ControlWeapon) then
				owner:Give(self.ControlWeapon)
			end
			owner:SelectWeapon(self.ControlWeapon)

			if self:GetPrimaryAmmoCount() <= 0 then
				owner:StripWeapon(self:GetClass())
			end
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:Deploy()
	GAMEMODE:WeaponDeployed(self:GetOwner(), self)

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SendWeaponAnim(ACT_VM_THROW)
	end

	return true
end

function SWEP:Holster()
	self.NextDeploy = nil

	if CLIENT then
		self:Anim_Holster()
	end

	return true
end

function SWEP:Think()
	if self.NextDeploy and self.NextDeploy <= CurTime() then
		self.NextDeploy = nil

		if 0 < self:GetPrimaryAmmoCount() then
			self:SendWeaponAnim(ACT_VM_DRAW)
		else
			self:SendWeaponAnim(ACT_VM_THROW)
			if SERVER then
				self:Remove()
			end
		end
	end
end

local colBG = Color(16, 16, 16, 90)
local colWhite = Color(220, 220, 220, 230)

SWEP.HUD3DPos = Vector(5, 2, 0)

function SWEP:PostDrawViewModel(vm)
	if not self.HUD3DPos or not GAMEMODE:ShouldDraw3DWeaponHUD() then return end

	local bone = vm:LookupBone("ValveBiped.Bip01_R_Hand")
	if not bone then return end

	local m = vm:GetBoneMatrix(bone)
	if not m then return end

	local pos, ang = m:GetTranslation(), m:GetAngles()

	local offset = self.HUD3DPos

	pos = pos + ang:Forward() * offset.x + ang:Right() * offset.y + ang:Up() * offset.z

	ang:RotateAroundAxis(ang:Up(), math.sin(CurTime() * math.pi) * 20)
	ang:RotateAroundAxis(ang:Right(), CurTime() * 180)

	pos = pos + ang:Forward() * 7

	ang:RotateAroundAxis(ang:Right(), 270)
	ang:RotateAroundAxis(ang:Up(), 180)

	local wid, hei = 144, 144
	local x, y = wid * -0.5, hei * -0.5
	local clip = self:GetPrimaryAmmoCount()

	cam.Start3D2D(pos, ang, 0.0125)
		draw.RoundedBox(32, x, y, wid, hei, colBG)
		draw.SimpleText(clip, "ZS3D2DFontBig", x + wid * 0.5, y + hei * 0.5, colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
