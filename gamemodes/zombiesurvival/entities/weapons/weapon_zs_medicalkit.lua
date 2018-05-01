AddCSLuaFile()

SWEP.PrintName = "Medical Kit"
SWEP.Description = "An advanced kit of medicine, bandages, and morphine.\nVery useful for keeping a group of survivors healthy.\nUse PRIMARY FIRE to heal other players.\nUse SECONDARY FIRE to heal yourself.\nHealing other players is not only faster but you get a nice point bonus!"
SWEP.Slot = 4
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 57
	SWEP.ViewModelFlip = false

	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
end

SWEP.Base = "weapon_zs_base"

SWEP.WorldModel = "models/weapons/w_medkit.mdl"
SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.UseHands = true

SWEP.Heal = 15
SWEP.Primary.Delay = 10

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Ammo = "Battery"

SWEP.Secondary.DelayMul = 20 / SWEP.Primary.Delay
SWEP.Secondary.HealMul = 10 / SWEP.Heal

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HealRange = 36

SWEP.NoMagazine = true
SWEP.AllowQualityWeapons = true

SWEP.HoldType = "slam"

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_HEALCOOLDOWN, -0.8)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALRANGE, 4, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALING, 1.5)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "Restoration Kit", "Always uses the same amount of ammo, increased cooldown", function(wept)
	wept.FixUsage = true
	wept.Primary.Delay = wept.Primary.Delay * 1.3
end)

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	GAMEMODE:DoChangeDeploySpeed(self)
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self:GetOwner()

	local trtbl = owner:CompensatedPenetratingMeleeTrace(self.HealRange, 2, nil, nil, true)
	local ent
	for _, tr in pairs(trtbl) do
		local test = tr.Entity
		if test and test:IsValidLivingHuman() and gamemode.Call("PlayerCanBeHealed", test) then
			ent = test

			break
		end
	end

	if not ent then return end

	local multiplier = self.MedicHealMul or 1
	local cooldownmultiplier = self.MedicCooldownMul or 1
	local healed = owner:HealPlayer(ent, math.min(self:GetCombinedPrimaryAmmo(), self.Heal))
	local totake = self.FixUsage and 15 or math.ceil(healed / multiplier)

	if totake > 0 then
		self:SetNextCharge(CurTime() + self.Primary.Delay * math.min(1, healed / self.Heal) * cooldownmultiplier)
		owner.NextMedKitUse = self:GetNextCharge()

		self:TakeCombinedPrimaryAmmo(totake)

		self:EmitSound("items/medshot4.wav")

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		owner:DoAttackEvent()
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if not self:CanPrimaryAttack() or not gamemode.Call("PlayerCanBeHealed", owner) then return end

	local multiplier = self.MedicHealMul or 1
	local cooldownmultiplier = self.MedicCooldownMul or 1
	local healed = owner:HealPlayer(owner, math.min(self:GetCombinedPrimaryAmmo(), self.Heal * self.Secondary.HealMul))
	local totake = self.FixUsage and 10 or math.ceil(healed / multiplier)

	if totake > 0 then
		self:SetNextCharge(CurTime() + self.Primary.Delay * self.Secondary.DelayMul * math.min(1, healed / self.Heal * self.Secondary.HealMul) * cooldownmultiplier)
		owner.NextMedKitUse = self:GetNextCharge()

		self:TakeCombinedPrimaryAmmo(totake)

		self:EmitSound("items/smallmedkit1.wav")

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		owner:DoAttackEvent()
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		hook.Add("PostPlayerDraw", "PostPlayerDrawMedical", GAMEMODE.PostPlayerDrawMedical)
		GAMEMODE.MedicalAura = true
	end

	return true
end

function SWEP:Holster()
	if CLIENT and self:GetOwner() == MySelf then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end

	return true
end

function SWEP:OnRemove()
	if CLIENT and self:GetOwner() == MySelf then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end
end

function SWEP:Reload()
end

function SWEP:SetNextCharge(tim)
	self:SetDTFloat(0, tim)
end

function SWEP:GetNextCharge()
	return self:GetDTFloat(0)
end

function SWEP:CanPrimaryAttack()
	local owner = self:GetOwner()
	if owner:IsHolding() or owner:GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:EmitSound("items/medshotno1.wav")

		self:SetNextCharge(CurTime() + 0.75)
		owner.NextMedKitUse = self:GetNextCharge()
		return false
	end

	return self:GetNextCharge() <= CurTime() and (owner.NextMedKitUse or 0) <= CurTime()
end

if not CLIENT then return end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

local texGradDown = surface.GetTextureID("VGUI/gradient_down")
function SWEP:DrawHUD()
	local wid, hei = 384, 16
	local x, y = ScrW() - wid - 32, ScrH() - hei - 72
	local texty = y - 4 - draw.GetFontHeight("ZSHUDFontSmall")

	local timeleft = self:GetNextCharge() - CurTime()
	if 0 < timeleft then
		surface.SetDrawColor(5, 5, 5, 180)
		surface.DrawRect(x, y, wid, hei)

		surface.SetDrawColor(50, 255, 50, 180)
		surface.SetTexture(texGradDown)
		surface.DrawTexturedRect(x, y, math.min(1, timeleft / math.max(self.Primary.Delay, self.Primary.Delay * self.Secondary.DelayMul)) * wid, hei)

		surface.SetDrawColor(50, 255, 50, 180)
		surface.DrawOutlinedRect(x, y, wid, hei)
	end

	draw.SimpleText(self.PrintName, "ZSHUDFontSmall", x, texty, COLOR_GREEN, TEXT_ALIGN_LEFT)

	local charges = self:GetPrimaryAmmoCount()
	if charges > 0 then
		draw.SimpleText(charges, "ZSHUDFontSmall", x + wid, texty, COLOR_GREEN, TEXT_ALIGN_RIGHT)
	else
		draw.SimpleText(charges, "ZSHUDFontSmall", x + wid, texty, COLOR_DARKRED, TEXT_ALIGN_RIGHT)
	end

	if GetConVar("crosshair"):GetInt() == 1 then
		self:DrawCrosshairDot()
	end
end
