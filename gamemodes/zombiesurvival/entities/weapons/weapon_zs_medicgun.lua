AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'세이버' 메딕 건"
	SWEP.Description = "미량의 체력을 회복하고 아드레날린을 주입시키는 주사기를 발사해 이동속도를 증가시킨다.\n 충전해서 쏘면 한 번에 많은 양의 체력이 회복된다."
	SWEP.Slot = 4
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "ValveBiped.square"
	SWEP.HUD3DPos = Vector(1.1, 0.25, -2)
	SWEP.HUD3DScale = 0.015

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.5, 2, -3.701), angle = Angle(0, -90, -8), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/airboatgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, -3, 0), angle = Angle(0, 90, 180), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2+"] = { type = "Model", model = "models/airboatgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, -3, 0), angle = Angle(0, 90, 180), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 0.5, 3), angle = Angle(0, 0, 90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/airboatgun.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(0, -3, 0), angle = Angle(0, 90, 180), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2+"] = { type = "Model", model = "models/airboatgun.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(0, -3, 0), angle = Angle(0, 90, 180), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

sound.Add( {
	name = "Loop_medicgun_charging",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 80,
	pitch = { 100,100 },
	sound = "items/medshot4.wav"
} )

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Ammo = "Battery"
SWEP.RequiredClip = 5
SWEP.Primary.Recoil = 0.3

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.NoMagazine = true

SWEP.ConeMax = 0.005
SWEP.ConeMin = 0.005

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)

SWEP.MaxCharged = 25
SWEP.PlayCharging = nil

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Charged")
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
	if self.Charging then
		return false
	end
	return self.BaseClass.CanPrimaryAttack(self)
end


function SWEP:Think()
	local owner = self.Owner
	if self:GetNextReload() + 0.3 > CurTime() then
		self:SetCharged(0)
		return
	end
		
	
	local charged = self:GetCharged()
	self.CannotCharged = false
	if owner:KeyDown(IN_ATTACK2) then
		if self:Clip1() == 25 then
			self:SetCharged(math.Clamp(charged + FrameTime() * 8, 0, self.MaxCharged))
			self.Charging = true
			if self.PlayCharging then
				self:StopSound("medicgun_charging")
				self.PlayCharging = nil				
			elseif not self.PlayCharging then		
				self:EmitSound("medicgun_charging")
				self.PlayCharging = true
			end
		else
			self.CannotCharged = true
			self:StopSound("medicgun_charging")
			self.PlayCharging = nil		
		end
	else
		if charged == self.MaxCharged then
			self:SetCharged(0)
			self.Charging = false
			self:TakePrimaryAmmo(25)
			self:ShootChargedBullet()
			self:StopSound("medicgun_charging")
			self.PlayCharging = nil		
		end
		if charged > 0 then
			self:SetCharged(math.Clamp(charged - FrameTime() * 16, 0, self.MaxCharged))
		else
			self.Charging = false
			self:StopSound("medicgun_charging")
			self.PlayCharging = nil		
		end
	end
end

if CLIENT then
	function SWEP:DrawHUD()
		if self.CannotCharged then
			surface.SetDrawColor(255, 0, 0, 120)
			surface.DrawOutlinedRect(ScrW() / 2 - 100, ScrH() / 2 + 32, 200, 16)
			surface.SetFont("Default")
			surface.SetTextColor(255, 0, 0, 120)
			surface.SetTextPos(ScrW() / 2 - 98, ScrH() / 2 + 34)
			surface.DrawText("탄창이 꽉 찬 상태여야 합니다.")
		elseif self.Charging then
			local charged = self:GetCharged()
			local ratio = charged / self.MaxCharged
			surface.SetDrawColor(255 - 255 * ratio, 255 * ratio, 0, 120)
			surface.DrawRect(ScrW() / 2 - 100, ScrH() / 2 + 32, 200 * ratio, 16)
			if charged == self.MaxCharged then
				surface.SetDrawColor(13, 255, 150, 120)
				surface.DrawOutlinedRect(ScrW() / 2 - 104, ScrH() / 2 + 28, 208, 24)
				surface.DrawOutlinedRect(ScrW() / 2 - 103, ScrH() / 2 + 29, 206, 22)
			end
		end
		self.BaseClass.DrawHUD(self)
	end
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self.Owner
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	if CLIENT then return end

	local aimvec = owner:GetAimVector()

	local ent = ents.Create("projectile_healdart")
	if ent:IsValid() then
		ent:SetPos(owner:GetShootPos())
		ent:SetAngles(aimvec:Angle())
		ent:SetOwner(owner)
		ent:Spawn()

		ent.Heal = math.ceil(ent.Heal * (owner.HumanHealMultiplier or 1))

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocityInstantaneous(aimvec * 2560)
		end
	end
end

function SWEP:ShootChargedBullet(dmg, numbul, cone)
	local owner = self.Owner
	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	
	self:EmitSound("beams/beamstart5.wav")

	if CLIENT then return end

	local aimvec = owner:GetAimVector()

	local ent = ents.Create("projectile_healdart")
	if ent:IsValid() then
		ent:SetPos(owner:GetShootPos())
		ent:SetAngles(aimvec:Angle())
		ent:SetOwner(owner)
		ent:SetCharged(true)
		ent:Spawn()

		ent.Heal = math.ceil(30 * (owner.HumanHealMultiplier or 1))

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocityInstantaneous(aimvec * 5120)
		end
	end
end

--[[function SWEP:Initialize()
	if CLIENT and self:GetOwner() == LocalPlayer() and LocalPlayer():GetActiveWeapon() == self then
		hook.Add("PostPlayerDraw", "PostPlayerDrawMedical", GAMEMODE.PostPlayerDrawMedical)
	end
end]]

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		hook.Add("PostPlayerDraw", "PostPlayerDrawMedical", GAMEMODE.PostPlayerDrawMedical)
	end

	return true
end

function SWEP:Holster()
	if CLIENT then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
	end
	self:StopSound("medicgun_charging")
	return true
end
