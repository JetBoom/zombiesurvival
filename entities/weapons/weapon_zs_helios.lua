AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Helios' Gluon Gun"
	SWEP.Description = "Projects a stream of gluons at the target, causing immense damage."
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 58
	SWEP.OverrideAmmoDisplay = true
	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(5.8, -1.2, -7)
	SWEP.HUD3DAng = Angle(180, -9, 00)
	SWEP.HUD3DScale = 0.05
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["egon_base++++++"] = { type = "Model", model = "models/props_phx/misc/iron_beam2.mdl", bone = "", rel = "egon_base", pos = Vector(1.5, -4, -2), angle = Angle(-17.532, 90, 0), size = Vector(0.119, 0.119, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunstick/v_stunstick_diffuse", skin = 0, bodygroup = {} },
		["egon_base+"] = { type = "Model", model = "models/props_phx/construct/metal_wire_angle360x2.mdl", bone = "", rel = "egon_base", pos = Vector(18.181, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.095, 0.095, 0.11), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base+++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "", rel = "egon_base", pos = Vector(-3.5, 5, 1), angle = Angle(90, -90, 0), size = Vector(0.05, 0.05, 0.14), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base++++++++"] = { type = "Model", model = "models/props_combine/combine_interface001a.mdl", bone = "", rel = "egon_base", pos = Vector(-3, 4, 0.6), angle = Angle(70, 0, 0), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base+++++++"] = { type = "Model", model = "models/props_lab/reciever01a.mdl", bone = "", rel = "egon_base", pos = Vector(-10.91, 3.635, 1.557), angle = Angle(120, 0, 0), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base+++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "", rel = "egon_base", pos = Vector(4, 0, -1.601), angle = Angle(180, 90, 0), size = Vector(0.064, 0.064, 0.064), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base+++++"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "", rel = "egon_base", pos = Vector(-10.91, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.079, 0.079, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "Base", rel = "", pos = Vector(0.699, 1, -7.792), angle = Angle(90, -90, 0), size = Vector(0.301, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "", rel = "egon_base", pos = Vector(3.635, 0, 1.5), angle = Angle(0, 90, 0), size = Vector(0.064, 0.064, 0.064), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["egon_base++++++"] = { type = "Model", model = "models/props_phx/misc/iron_beam2.mdl", bone = "", rel = "egon_base", pos = Vector(1.5, -4, -2), angle = Angle(-17.532, 90, 0), size = Vector(0.119, 0.119, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base+"] = { type = "Model", model = "models/props_phx/construct/metal_wire_angle360x2.mdl", bone = "", rel = "egon_base", pos = Vector(15.064, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.071, 0.071, 0.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base++++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "", rel = "egon_base", pos = Vector(-4.676, 0.5, -6), angle = Angle(0, 0, 0), size = Vector(0.029, 0.029, 0.159), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base+++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "", rel = "egon_base", pos = Vector(4, 0, -1.601), angle = Angle(180, 90, 0), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.8, 1, -7), angle = Angle(0, 0, -170), size = Vector(0.17, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base++++++++"] = { type = "Model", model = "models/props_combine/combine_interface001a.mdl", bone = "", rel = "egon_base", pos = Vector(4.675, 5, 0.6), angle = Angle(70, 0, 0), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base+++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "", rel = "egon_base", pos = Vector(0.518, 5, 1), angle = Angle(90, -90, 0), size = Vector(0.039, 0.039, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base+++++"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "", rel = "egon_base", pos = Vector(-2.597, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.079, 0.079, 0.129), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base+++++++"] = { type = "Model", model = "models/props_lab/reciever01a.mdl", bone = "", rel = "egon_base", pos = Vector(-2, 5, 1.557), angle = Angle(120, 0, 0), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["egon_base++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "", rel = "egon_base", pos = Vector(3.635, 0, 1.5), angle = Angle(0, 90, 0), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -3), angle = Angle(0, 0, 0) },
		["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 3), angle = Angle(0, 0, 0) }
	}

	SWEP.ShowDroppedWElements = true
end

SWEP.WalkSpeed = SPEED_SLOWEST * 0.4
SWEP.Base = "weapon_zs_base"
SWEP.HoldType = "physgun"
SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.UseHands = true
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.06
SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)
SWEP.ConeMin = 0
SWEP.ConeMax = 0
SWEP.TracerName = "tracer_gluon"
SWEP.IsPulseWeapon = true
SWEP.FireAnimSpeed = 0.24
SWEP.FireSoundPitch = 125
SWEP.HeatBuildShort = 0.09
SWEP.HeatBuildLong = 0.03
SWEP.HeatVentShort = 0.16
SWEP.HeatVentLong = 0.13
SWEP.HeatDecayShort = 0.06
SWEP.HeatDecayLong = 0.01
SWEP.HeatInitialLong = 0.05
SWEP.MaxDistance = 700

function SWEP:Initialize()
	self.FiringSound = CreateSound(self, "^thrusters/rocket02.wav")
	self.FiringSound:SetSoundLevel(85)
	
	if CLIENT then self.VentingSound = CreateSound(self, "ambient/levels/labs/teleport_alarm_loop1.wav") end
	self.BaseClass.Initialize(self)
end



function SWEP:Deploy()
	local owner = self:GetOwner()

	if not self.PostOwner then
		self.PostOwner = owner
	end

	local timediff = owner.GluonInactiveTime and CurTime() - owner.GluonInactiveTime or 0
	self:SetShortHeat(math.Clamp((owner.ShortGluonHeat or 0) - timediff * self.HeatDecayShort, 0, 1))
	self:SetLongHeat(math.Clamp((owner.LongGluonHeat or 0) - timediff * self.HeatDecayLong, 0, 1))

	if self:GetLongHeat() > 0.5 then
		self:SetGunState(2)
		self:EmitSound("npc/scanner/scanner_siren1.wav")
	end

	self.BaseClass.Deploy(self)
end



function SWEP:Holster()
	self:EndGluonState()
	
	return self.BaseClass.Holster(self)
end



function SWEP:OnRemove()

	self.BaseClass.OnRemove(self)
	self:EndGluonState()
end



function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local altuse = self:GetAltUsage()

	if altuse then
		self:TakeCombinedPrimaryAmmo(1)
	end
	self:SetAltUsage(not altuse)
	self:ZSShootBullet(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if self:GetGunState() ~= 1 then
		if IsFirstTimePredicted() then
			self:EmitSound("ambient/machines/teleport1.wav", 75, 210)
			self:GetOwner():ViewPunch(Angle(math.Rand(-2, 2), math.Rand(-2, 2), math.Rand(-5, 5)))
		end

		self:SetLongHeat(math.min(self:GetLongHeat() + self.HeatInitialLong, 1))
		self:SetGunState(1)
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetPrimaryAmmoCount() <= 0 then

		return false
	end
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end
	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:m_BulletCallback(attacker, tr, dmginfo)
	if tr.HitWorld then
		util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
end

function SWEP:Reload()
	if self:GetGunState() == 0 and self:GetLongHeat() ~= 0 then
		self:SetGunState(2)
		self:EmitSound("npc/scanner/scanner_siren1.wav")
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:StopGluonSounds()
	self.FiringSound:Stop()
	if CLIENT then self.VentingSound:Stop() end
end

function SWEP:EndGluonState()
	local owner = self.PostOwner or self:GetOwner()
	if owner:IsValid() then
		owner.ShortGluonHeat = self:GetShortHeat()
		owner.LongGluonHeat = self:GetLongHeat()
		owner.GluonInactiveTime = CurTime()
	end
	
	self:StopGluonSounds()
end

function SWEP:SetGunState(state)
	self:SetDTInt(1, state)
end

function SWEP:GetGunState(state)
	return self:GetDTInt(1)
end

function SWEP:SetAltUsage(usage)
	self:SetDTBool(1, usage)
end

function SWEP:GetAltUsage()
	return self:GetDTBool(1)
end

function SWEP:SetShortHeat(heat)
	self:SetDTFloat(8, heat)
end

function SWEP:GetShortHeat()
	return self:GetDTFloat(8)
end

function SWEP:SetLongHeat(heat)
	self:SetDTFloat(9, heat)
end

function SWEP:GetLongHeat()
	return self:GetDTFloat(9)
end

function SWEP:ManageHeat()
	local owner = self:GetOwner()
	
	if owner and owner:IsValid() then
		local frametime = FrameTime()

		if self:GetGunState() == 1 then
			self.FiringSound:PlayEx(1, self.FireSoundPitch + CurTime() % 1)
			self:SetShortHeat(math.min(self:GetShortHeat() + frametime * self.HeatBuildShort, 1))
			self:SetLongHeat(math.min(self:GetLongHeat() + frametime * self.HeatBuildLong, 1))
		elseif self:GetGunState() == 2 then
			self.FiringSound:Stop()

			if CLIENT then self.VentingSound:PlayEx(1, 55 + CurTime() % 1) end
			
			self:SetShortHeat(math.max(self:GetShortHeat() - frametime * self.HeatVentShort, 0))
			self:SetLongHeat(math.max(self:GetLongHeat() - frametime * self.HeatVentLong, 0))
			self:SetNextPrimaryFire(CurTime() + 0.25)

			if self:GetLongHeat() == 0 and self:GetShortHeat() < self.HeatBuildShort then
				self:SetGunState(0)
				self:EmitSound("npc/scanner/combat_scan3.wav", 65, 90)
			end
		else
			self:StopGluonSounds()
			self:SetShortHeat(math.max(self:GetShortHeat() - frametime * self.HeatDecayShort, 0))
			self:SetLongHeat(math.max(self:GetLongHeat() - frametime * self.HeatDecayLong, 0))
		end
	else
		self:StopGluonSounds()
	end
end

function SWEP:Think()
	self.BaseClass.Think(self)

	local overheat = self:GetShortHeat() + self:GetLongHeat() >= 1
	
	if self:GetGunState() == 1 and CurTime() >= self:GetNextPrimaryFire() + 0.1 or overheat then
		self:SetGunState(overheat and 2 or 0)
		self:SetNextPrimaryFire(CurTime() + 0.15)

		if overheat then
			self:EmitSound("npc/scanner/scanner_siren1.wav", 75)
		end
		self:EmitSound("weapons/zs_gluon/egon_off1.wav", 75, 115, 0.9, CHAN_WEAPON + 20)
	end
	self:ManageHeat()
end

local DT_WEAPON_BASE_FLOAT_NEXTRELOAD = 0
local DT_WEAPON_BASE_FLOAT_RELOADSTART = 1
local DT_WEAPON_BASE_FLOAT_RELOADEND = 2

function SWEP:SetNextReload(fTime)
	self:SetDTFloat(DT_WEAPON_BASE_FLOAT_NEXTRELOAD, fTime)
end

function SWEP:GetNextReload()
	return self:GetDTFloat(DT_WEAPON_BASE_FLOAT_NEXTRELOAD)
end

function SWEP:SetReloadStart(fTime)
	self:SetDTFloat(DT_WEAPON_BASE_FLOAT_RELOADSTART, fTime)
end

function SWEP:GetReloadStart()
	return self:GetDTFloat(DT_WEAPON_BASE_FLOAT_RELOADSTART)
end

function SWEP:SetReloadFinish(fTime)
	self:SetDTFloat(DT_WEAPON_BASE_FLOAT_RELOADEND, fTime)
end

function SWEP:GetReloadFinish()
	return self:GetDTFloat(DT_WEAPON_BASE_FLOAT_RELOADEND)
end

if CLIENT then
	local colBG = Color(16, 16, 16, 90)
	local colRed = Color(220, 0, 0, 230)
	local colWhite = Color(220, 220, 220, 230)

	local function DrawHeatBar(self, x, y, wid, hei, is3d)
		local heatcolor = (1 - (self:GetShortHeat() + self:GetLongHeat())) * 220
		colWhite.g = heatcolor
		colWhite.b = heatcolor
		colWhite.a = 230

		local barrelcol = self.VElements["egon_base+"].color
		barrelcol.g = heatcolor
		barrelcol.b = heatcolor

		local shortdiv = self:GetShortHeat()
		local longdiv = self:GetLongHeat()
		local barheight = 20
		local bary = y + hei * 0.6
		local barshortwid = math.max(wid * shortdiv - 8, 0)
		local barlongwid = math.max(wid * longdiv - 8, 0)

		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(x, bary, wid - 8, barheight)
		surface.SetDrawColor(255, 30, 10, 220)
		surface.DrawRect(x + 4, bary + 4, barlongwid, barheight - 8)
		surface.SetDrawColor(255, 190, 0, 220)
		surface.DrawRect(x + 4 + barlongwid, bary + 4, barshortwid, barheight - 8)
		surface.SetDrawColor(100, 0, 0, 255)
		surface.DrawRect(x - 12 + wid, bary - 4, 4, barheight + 8)

		if self:GetGunState() == 2 then
			colWhite.b = 0
			colWhite.g = 0
			if ((CurTime() * 4) % 2) > 1 then
				colWhite.a = 0
			else
				draw.SimpleText("VENTING", is3d and "ZS3D2DFontSmaller" or "ZSHUDFontSmaller", x + (wid / 2), bary + (barheight / 2), colRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end

	function SWEP:DrawHUD()
		self:DrawCrosshair()

		local screenscale = BetterScreenScale()
		local wid, hei = 180 * screenscale, 64 * screenscale
		local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
		local spare = self:GetPrimaryAmmoCount()
		local yy = ScrH() - hei * 2 - screenscale * 84

		DrawHeatBar(self, x + wid * 0.25 - wid/4, yy + hei * 0.2, wid, hei)
		draw.RoundedBox(16, x, y, wid, hei, colBG)
		draw.SimpleText(spare, spare >= 1000 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Heat", "ZSHUDFont", x + wid * 0.5, yy + hei * 0.45, colRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function SWEP:Draw3DHUD(vm, pos, ang)
		local wid, hei = 180, 64
		local x, y = wid * -0.6, hei * -0.5
		local spare = self:GetPrimaryAmmoCount()

		cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
			DrawHeatBar(self, x + wid * 0.25 - wid/4, y - hei * 1, wid, hei, true)
			draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
			draw.SimpleText(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Heat", "ZS3D2DFontSmall", x + wid * 0.5, y - hei * 1, colRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end