AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Hunter' 저격 소총"
	SWEP.Description = "매우 강력한 대구경 탄환을 발사한다. 재장전 속도가 매우 느리지만 그만큼 큰 파괴력을 지닌다. 달리기 키를 눌러 탄환을 차징한 후 더욱 강력한 한 발을 발사할 수 있다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.awm_parent"
	SWEP.HUD3DPos = Vector(-1.25, -3.5, -16)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02
end

sound.Add(
{
	name = "Weapon_Hunter.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitchstart = 134,
	pitchend = 10,
	sound = "weapons/awp/awp1.wav"
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AWP.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_Hunter.Single")
SWEP.Primary.Damage = 130
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.Primary.Recoil = 22
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 15

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 3
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.TracerName = "AR2Tracer"

SWEP.Charged = 0
SWEP.MaxCharged = 5
SWEP.ChargedBullet = 0

SWEP.PrevValue = 0

SWEP.ChargeSound = "npc/scanner/scanner_electric"

SWEP.ChargeShotDelay = 0.2

SWEP.NextCharge = 0
SWEP.ChargeDelay = 25

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "NoAmmo")
	self:NetworkVar("Float", 0, "NextCharge")
	self:NetworkVar("Float", 1, "Charged")
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

--[[function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 85, 80)
end]]

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("hit_hunter", effectdata)

	GenericBulletCallback(attacker, tr, dmginfo)
end

function SWEP:Think()
	local owner = self.Owner
	if SERVER then
		if owner.hunterAddClip and !self.hunterAddClip then
			self.Primary.ClipSize = 2
		elseif !owner.hunterAddClip and self.hunterAddClip then
			self.Primary.ClipSize = 1
		end
		if owner:KeyDown(IN_SPEED) and owner.hunterCharge then
			if owner:GetAmmoCount(self.Primary.Ammo) + self.ChargedBullet + self:Clip1() < 5 then
				self:SetNoAmmo(true)
				return
			else
				self:SetNoAmmo(false)
			end
			
			if self.NextCharge > CurTime() then
				return
			else
				self:SetNextCharge(0)
			end
			
			if self:GetCharged() < self.MaxCharged then
				self:SetCharged(math.min(self:GetCharged() + engine.TickInterval() * 1.5, self.MaxCharged))
				local curval = math.floor(self:GetCharged())
				
				if self.PrevValue ~= curval then
					self:TakePrimaryAmmo(1)
					self.ChargedBullet = self.ChargedBullet + 1
					self:EmitSound(self.ReloadSound)
				end
				self:EmitSound(self.ChargeSound .. math.random(1, 2) .. ".wav", 100, 100, 1, CHAN_WEAPON)
				self.PrevValue = math.floor(self:GetCharged())
			end
		else
			if self:GetCharged() > 0 then
				if self.ChargedBullet > 0 then
					for i = 1, self.ChargedBullet do
						timer.Simple(self.ChargeShotDelay * (i - 1), function()
							self:ShootChargedBullet()
						end)
					end
					self.ChargedBullet = 0
				end
				self:SetCharged(0)
				self.PrevValue = 0
				self.NextCharge = CurTime() + self.ChargeDelay
				self:SetNextCharge(self.NextCharge)
			end
		end
	else
		local nextcharge = self:GetNextCharge()
		self.NextCharge = nextcharge
		
		local curval = self:GetCharged()
		
		if curval > 0 and curval < self.MaxCharged then
			self:EmitSound(self.ChargeSound .. math.random(1, 2) .. ".wav", 100, 100, 1, CHAN_WEAPON)
		elseif curval == 0 then
			
		end
		
		if math.floor(curval) ~= self.PrevValue and curval ~= 0 then
			owner:EmitSound(self.ReloadSound)
		end
		
		self.PrevValue = math.floor(curval)
	end
	self.BaseClass.Think(self)
end

function SWEP:ShootChargedBullet()
	local owner = self.Owner
	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	local cone = self:GetCone() * 0.3
	local dmg = self.Primary.Damage * 1.1
	self:StartBulletKnockback()
	owner:FireBullets({Num = 1, Src = owner:GetShootPos(), Dir = owner:GetAimVector(), Spread = Vector(cone, cone, 0), Tracer = 1, TracerName = self.TracerName, Force = dmg * 0.1, Damage = dmg, Callback = self.BulletCallback})
	self:DoBulletKnockback(self.Primary.KnockbackScale * 0.05)
	self:EndBulletKnockback()
	
	self:EmitSound("Weapon_Hunter.Single")
	self.OriginalRecoil = self.Primary.Recoil
	self.Primary.Recoil = self.OriginalRecoil * 0.3
	self:DoRecoil()
	self.Primary.Recoil = self.OriginalRecoil
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	local matScope = Material("zombiesurvival/scope")
	function SWEP:DrawHUDBackground()
		if self:IsScoped() then
			local scrw, scrh = ScrW(), ScrH()
			local size = math.min(scrw, scrh)
			surface.SetMaterial(matScope)
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
	
	function SWEP:DrawHUD()
		if self:GetNWBool("noammo") and LocalPlayer():KeyDown(IN_SPEED) then
			local scrW = ScrW()
			local scrH = ScrH()
			local width = 200
			local height = 20
			local x = scrW / 2 - width / 2
			local y = scrH / 2 - height / 2 + 30
			local ratio = self.Charged / self.MaxCharged
			surface.SetDrawColor(Color(0, 0, 255, 80))
			surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
			draw.RoundedBox(0, x, y, width, height, Color(255, 0, 0, 80))
			draw.DrawText("NO AMMO ( REQUIRE AT LEAST 5 )", "DefaultFontBold", x + 100, y + 3, Color(0, 0, 0, 80), TEXT_ALIGN_CENTER)
		elseif self.NextCharge > CurTime() and LocalPlayer():KeyDown(IN_SPEED) then
			local scrW = ScrW()
			local scrH = ScrH()
			local width = 200
			local height = 20
			local x = scrW / 2 - width / 2
			local y = scrH / 2 - height / 2 + 30
			local ratio = self.Charged / self.MaxCharged
			surface.SetDrawColor(Color(0, 0, 255, 80))
			surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
			draw.RoundedBox(0, x, y, width, height, Color(255, 0, 0, 80))
			draw.DrawText("CHARGING... " .. tostring(math.ceil(self.NextCharge - CurTime())) .. " SEC", "DefaultFontBold", x + 100, y + 3, Color(0, 0, 0, 80), TEXT_ALIGN_CENTER)
		end
		
		if self.Charged > 0 then
			if self.Charged < self.MaxCharged then
				local scrW = ScrW()
				local scrH = ScrH()
				local width = 200
				local height = 20
				local x = scrW / 2 - width / 2
				local y = scrH / 2 - height / 2 + 30
				local ratio = self.Charged / self.MaxCharged
				surface.SetDrawColor(Color(0, 0, 255, 80))
				surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
				draw.RoundedBox(0, x, y, width * ratio, height, Color(255 * (1 - ratio), 255 * ratio, 0, 80))
				if math.floor(self.Charged) <= 0 then
					draw.DrawText("CHARGING", "DefaultFontBold", x + 100, y + 3, Color(0 + (255 * ratio), 0 + (255 * ratio), 0 + (255 * ratio), 80), TEXT_ALIGN_CENTER)
				else
					draw.DrawText("CHARGED: " .. tostring(math.floor(self.Charged)) .. " BULLET", "DefaultFontBold", x + 100, y + 3, Color(0 + (255 * ratio), 0 + (255 * ratio), 0 + (255 * ratio), 80), TEXT_ALIGN_CENTER)
				end
			end
			
			if self.Charged == self.MaxCharged then
				local scrW = ScrW()
				local scrH = ScrH()
				local width = 200
				local height = 20
				local x = scrW / 2 - width / 2
				local y = scrH / 2 - height / 2 + 30
				local ratio = self.Charged / self.MaxCharged
				surface.SetDrawColor(Color(0, 0, 255, 80))
				surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
				draw.RoundedBox(0, x, y, width * ratio, height, Color(0, 255, 0, 80))
				draw.DrawText("MAX CHARGED!", "DefaultFontBold", x + 100, y + 3, Color(255, 0, 0, 80), TEXT_ALIGN_CENTER)
			end
		end
		
		self.BaseClass.DrawHUD(self)
	end
end