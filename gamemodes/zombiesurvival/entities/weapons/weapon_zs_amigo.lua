AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Amigo' Assault Rifle"
SWEP.Description = "The Amigo gets extra headshot damage, but has a slow fire rate for an assault rifle."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

	SWEP.HUD3DBone = "v_weapon.sg552_Parent"
	SWEP.HUD3DPos = Vector(-2.12, -6.25, -2)
	SWEP.HUD3DAng = Angle(0, -6, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_sg552.mdl"
SWEP.WorldModel = "models/weapons/w_rif_sg552.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_SG552.Clipout")
SWEP.Primary.Sound = Sound("Weapon_SG552.Single")
SWEP.Primary.Damage = 18.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15

SWEP.Primary.ClipSize = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2
SWEP.ConeMin = 0.8
SWEP.HeadshotMulti = 2.1

SWEP.ReloadSpeed = 0.9

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 2

SWEP.IronSightsPos = Vector(-5, 1, 3)
SWEP.IronSightsAng = Vector(0, 0, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.07)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Comrade' Micronaut Rifle", "Reduced accuracy, damage but increased clip size and fires additional projectiles", function(wept)
	wept.ConeMax = wept.ConeMax * 1.5
	wept.ConeMin = wept.ConeMin * 1.5
	wept.Primary.Damage = wept.Primary.Damage * 0.8
	wept.Primary.ClipSize = 35

	wept.ShootBullets = function(self, dmg, numbul, cone)
		local owner = self:GetOwner()

		self:SendWeaponAnimation()
		owner:DoAttackEvent()

		if SERVER and self:Clip1() % 10 == 1 then
			local ent = ents.Create("projectile_juggernaut")
			if ent:IsValid() then
				ent:SetPos(owner:GetShootPos())

				local angle = owner:GetAimVector():Angle()
				angle:RotateAroundAxis(angle:Up(), 90)
				ent:SetAngles(angle)

				ent:SetOwner(owner)
				ent.ProjDamage = self.Primary.Damage * 1.75 * (owner.ProjectileDamageMul or 1)
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

		owner:LagCompensation(true)
		owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
		owner:LagCompensation(false)
	end
end)
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, "'Horizon' Battle Rifle", "Extremely accurate, more damage and fires in slow bursts", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 1.12
	wept.Primary.Delay = wept.Primary.Delay * 6
	wept.Primary.BurstShots = 3
	wept.ConeMin = wept.ConeMin * 0.6
	wept.ConeMax = wept.ConeMax * 0.85

	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self:EmitFireSound()

		self:SetNextShot(CurTime())
		self:SetShotsLeft(self.Primary.BurstShots)

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	wept.Think = function(self)
		BaseClass.Think(self)

		local shotsleft = self:GetShotsLeft()
		if shotsleft > 0 and CurTime() >= self:GetNextShot() then
			self:SetShotsLeft(shotsleft - 1)
			self:SetNextShot(CurTime() + self:GetFireDelay()/12)

			if self:Clip1() > 0 and self:GetReloadFinish() == 0 then
				self:EmitFireSound()
				self:TakeAmmo()
				self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())

				self.IdleAnimation = CurTime() + self:SequenceDuration()
			else
				self:SetShotsLeft(0)
			end
		end
	end

	wept.ViewModel = "models/weapons/cstrike/c_rif_famas.mdl"
	wept.WorldModel = "models/weapons/w_rif_famas.mdl"

	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/famas/famas-1.wav", 75, math.random(80, 85), 0.8)
		self:EmitSound("npc/sniper/echo1.wav", 75, math.random(81, 85), 1, CHAN_WEAPON+20)
	end

	if CLIENT then
		wept.VElements = {
			["underside"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 5.438, 8.074), angle = Angle(0, 0, 88), size = Vector(0.024, 0.021, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scopeback+"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0, 4.012), angle = Angle(0, 0, 0), size = Vector(0.025, 0.025, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["mid"] = { type = "Model", model = "models/props_phx/trains/double_wheels.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0.726, 0.008, 1.82), angle = Angle(90, 90, -90), size = Vector(0.02, 0.02, 0.016), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["top"] = { type = "Model", model = "models/props_borealis/mooring_cleat01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0, 1.815), angle = Angle(0, 0, -90), size = Vector(0.048, 0.039, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scopeback"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0, -0.29), angle = Angle(180, 0, 0), size = Vector(0.025, 0.025, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["glass"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0, -0.285), angle = Angle(90, 0, 0), size = Vector(0.123, 0.023, 0.023), color = Color(0, 0, 115, 255), surpresslightning = false, material = "models/props/cs_office/snowmana", skin = 0, bodygroup = {} },
			["scope"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.082, -5.666, 9.55), angle = Angle(0, 0, 1.254), size = Vector(0.025, 0.025, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["back"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.104, -1.573, 10.755), angle = Angle(90, 90.005, 0), size = Vector(0.361, 0.476, 0.597), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["hold"] = { type = "Model", model = "models/props_c17/playgroundTick-tack-toe_post01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0.694, 1.85), angle = Angle(0, 0, -90), size = Vector(0.152, 0.041, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["midsection"] = { type = "Model", model = "models/props_combine/eli_pod_inner.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 3.048, 13.31), angle = Angle(0.15, 90, 180), size = Vector(0.15, 0.107, 0.194), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} }
		}
		wept.WElements = {
			["underside"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 6.301, 10.373), angle = Angle(0, 0, 88), size = Vector(0.025, 0.027, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scopeback+"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, 4.012), angle = Angle(0, 0, 0), size = Vector(0.025, 0.025, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["mid"] = { type = "Model", model = "models/props_phx/trains/double_wheels.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0.811, -0.03, 1.82), angle = Angle(90, 90, -90), size = Vector(0.02, 0.02, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["top"] = { type = "Model", model = "models/props_borealis/mooring_cleat01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, 1.815), angle = Angle(0, 0, -90), size = Vector(0.048, 0.039, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scopeback"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, -0.29), angle = Angle(180, 0, 0), size = Vector(0.025, 0.025, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["glass"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, -0.424), angle = Angle(90, 0, 0), size = Vector(0.123, 0.023, 0.023), color = Color(0, 0, 115, 255), surpresslightning = false, material = "models/props/cs_office/snowmana", skin = 0, bodygroup = {} },
			["scope"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.99, 0.794, -8.33), angle = Angle(0, -90, -99.326), size = Vector(0.025, 0.025, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["back"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 4.708, 1.435), angle = Angle(90, 90.005, 0), size = Vector(0.361, 0.583, 0.708), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["hold"] = { type = "Model", model = "models/props_c17/playgroundTick-tack-toe_post01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0.694, 1.85), angle = Angle(0, 0, -90), size = Vector(0.152, 0.041, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["midsection"] = { type = "Model", model = "models/props_combine/eli_pod_inner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 3.368, 17.281), angle = Angle(0.15, 90, 180), size = Vector(0.185, 0.151, 0.245), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["glass+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, 4.243), angle = Angle(90, 0, 0), size = Vector(0.123, 0.023, 0.023), color = Color(0, 0, 115, 255), surpresslightning = false, material = "models/props/cs_office/snowmana", skin = 0, bodygroup = {} }
		}

		wept.HUD3DBone = "v_weapon.famas"
		wept.HUD3DPos = Vector(-0.2, -4, 8.6)
		wept.HUD3DAng = BaseClass.HUD3DAng

		wept.IronsightsMultiplier = 0.25

		wept.GetViewModelPosition = function(self, pos, ang)
			if GAMEMODE.DisableScopes then return end

			if self:IsScoped() then
				return pos + ang:Up() * 256, ang
			end

			return BaseClass.GetViewModelPosition(self, pos, ang)
		end

		wept.DrawHUDBackground = function(self)
			if GAMEMODE.DisableScopes then return end

			if self:IsScoped() then
				self:DrawRegularScope()
			end
		end
	end
end)
branch.Colors = {Color(110, 160, 170), Color(90, 140, 150), Color(70, 120, 130)}
branch.NewNames = {"Focused", "Transfixed", "Orphic"}
branch.Killicon = "weapon_zs_battlerifle"

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:SetNextShot(nextshot)
	self:SetDTFloat(5, nextshot)
end

function SWEP:GetNextShot()
	return self:GetDTFloat(5)
end

function SWEP:SetShotsLeft(shotsleft)
	self:SetDTInt(1, shotsleft)
end

function SWEP:GetShotsLeft()
	return self:GetDTInt(1)
end
