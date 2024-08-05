AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Savior' 메딕 건"
	SWEP.Description = "멀리 있는 사람도 치료할 수 있는 의료 주사기를 발사한다. 한 방의 치유량은 적지만, 먼 대상에게 빠르게 발사할 수 있어 유용하다."
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

SWEP.Primary.ClipSize = 21
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Ammo = "Battery"
SWEP.RequiredClip = 3
SWEP.Charged = 0
SWEP.MaxCharged = 30
SWEP.ChargeSound = "items/medcharge4.wav"
SWEP.ChargeShotSound = "beams/beamstart5.wav"
SWEP.ChargeReadySound = "zombiesurvival/ding.ogg"
SWEP.ChargeShotReady = false
SWEP.ChargedClip = 0

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.NoMagazine = true

SWEP.ConeMax = 0.005
SWEP.ConeMin = 0.005

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)

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
		ent.FirstShot = self:Clip1() == 0
		
		ent.Heal = math.ceil(ent.Heal * (owner.HumanHealMultiplier or 1))

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocityInstantaneous(aimvec * 2500)
		end
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		hook.Add("PostPlayerDraw", "PostPlayerDrawMedical", GAMEMODE.PostPlayerDrawMedical)
		GAMEMODE.MedicalAura = true
	end

	return true
end

if SERVER then
	util.AddNetworkString("MedicGunCharge")
end
function SWEP:Think()
	local owner = self.Owner
	if SERVER then
		local charge = (engine.TickInterval() * 10)
		
		if self:Clip1() > 0 then
			net.Start("MedicGunCharge")
				net.WriteString("yesammo")
			net.Send(owner)
		end
		
		if owner:KeyDown(IN_SPEED) then
		
			if owner:GetAmmoCount(self.Primary.Ammo) < self.MaxCharged then
				net.Start("MedicGunCharge")
					net.WriteString("noammo")
				net.Send(owner)
				return
			end
			
			if self:Clip1() <= 0 then
				net.Start("MedicGunCharge")
					net.WriteString("noclip")
				net.Send(owner)
				return
			end
			
			if self.Charged < self.MaxCharged then
				self.Charged = math.Clamp(self.Charged + charge, 0, self.MaxCharged)
				self:EmitSound(self.ChargeSound, 65, 255, 1, CHAN_WEAPON)
				net.Start("MedicGunCharge")
					net.WriteString("charge")
					net.WriteFloat(self.Charged)
				net.Send(owner)
			elseif !self.ChargeShotReady then
				self.ChargeShotReady = true
				self:EmitSound(self.ChargeReadySound, 70, 100, 1, CHAN_WEAPON)
				local clip1 = self:Clip1()
				self.ChargedClip = clip1
				self:TakePrimaryAmmo(clip1)
				net.Start("MedicGunCharge")
					net.WriteString("ready")
				net.Send(owner)
			end
		elseif self.Charged == self.MaxCharged then
			local aimvec = owner:GetAimVector()
			local ent = ents.Create("projectile_healdart")
			if ent:IsValid() then
				ent:SetPos(owner:GetShootPos())
				ent:SetAngles(aimvec:Angle())
				ent:SetOwner(owner)
				ent:Spawn()
				ent.FirstShot = true
				ent:SetCharged(true)
				ent.Heal = math.ceil((self.ChargedClip / self.RequiredClip) * ent.Heal * 1.2 * (owner.HumanHealMultiplier or 1))
				
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:SetVelocityInstantaneous(aimvec * 5000)
				end
				
				self.Charged = 0
				self:EmitSound(self.ChargeShotSound, 100, 100, 1, CHAN_WEAPON)
				
				self.ChargeShotReady = false
			end
			net.Start("MedicGunCharge")
				net.WriteString("shoot")
			net.Send(owner)
		elseif self.Charged > 0 then
			self.Charged = math.Clamp(self.Charged - charge * 1.5, 0, self.MaxCharged)
			self:StopSound(self.ChargeSound)
			net.Start("MedicGunCharge")
				net.WriteString("charge")
				net.WriteFloat(self.Charged)
			net.Send(owner)
			self.ChargeShotReady = false
		end
	end
	
	self.BaseClass.Think(self)
end

if CLIENT then
	net.Receive("MedicGunCharge", function()
		local state = net.ReadString()
		local wep = LocalPlayer():GetActiveWeapon()
		
		if !wep or !IsValid(wep) or wep:GetClass() != "weapon_zs_medicgun" then
		end
		
		if state == "noclip" then
			if wep.Charged < wep.MaxCharged then
				wep:EmitSound("buttons/combine_button_locked.wav", 60, 100, 1, CHAN_WEAPON)
			end
		end
		
		if state == "noammo" then
			wep.Noammo = true
			wep.NoammoTime = CurTime()
		end
		
		if state == "yesammo" then
			wep.Noammo = false
		end
		
		if state == "charge" then
			local charged = net.ReadFloat()
			wep.Charged = charged
		end
		
		if state == "ready" then
			wep.Charged = wep.MaxCharged
			wep:EmitSound(wep.ChargeReadySound, 70, 100, 1, CHAN_WEAPON)
		end
		
		if state == "shoot" then
			wep.Charged = 0
			wep:EmitSound(wep.ChargeShotSound, 100, 100, 1, CHAN_WEAPON)
		end
		
		if state == "stopsound" then
			wep:StopSound(wep.ChargeSound)
		end
	end)
end

function SWEP:Holster()
	if CLIENT then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end

	return true
end

function SWEP:OnRemove()
	if CLIENT and self.Owner == LocalPlayer() then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end
end

function SWEP:DrawHUD()
	if !self.Noammo then
		if self.Charged > 0 and self.Charged < self.MaxCharged then
			self:EmitSound(self.ChargeSound, 65, 255, 1, CHAN_WEAPON)
		end
		
		if self.Charged > 0 then
			local scrW = ScrW()
			local scrH = ScrH()
			local width = 200
			local height = 20
			local x = scrW / 2 - width / 2
			local y = scrH / 2 - height / 2 + 30
			local ratio = self.Charged / self.MaxCharged
			surface.SetDrawColor(Color(0, 0, 255))
			surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
			draw.RoundedBox(0, x, y, width * ratio, height, Color(255 * (1 - ratio), 255 * ratio, 0))
			draw.DrawText("CHARGING", "DefaultFontBold", x + 100, y + 3, Color(0 + (255 * ratio), 0 + (255 * ratio), 0 + (255 * ratio)), TEXT_ALIGN_CENTER)
		end
	else
		local scrW = ScrW()
		local scrH = ScrH()
		local width = 200
		local height = 20
		local x = scrW / 2 - width / 2
		local y = scrH / 2 - height / 2 + 30
		local ratio = self.Charged / self.MaxCharged
		surface.SetDrawColor(Color(0, 0, 255))
		surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
		draw.RoundedBox(0, x, y, width * ratio, height, Color(255, 0, 0, 70))
		draw.DrawText("NO AMMO", "DefaultFontBold", x + 100, y + 3, Color(0, 0, 0), TEXT_ALIGN_CENTER)
		
		if self.NoammoTime and self.NoammoTime + 1 <= CurTime() then
			self.Noammo = false
			self.NoammoTime = nil
		end
	end
	if self.BaseClass.DrawHUD then
		self.BaseClass.DrawHUD(self)
	end
end