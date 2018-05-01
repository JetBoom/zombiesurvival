SWEP.PrintName = "'Carrion' Impact Mine Layer"
SWEP.Description = "A mine layer that shoots out simple tripmines that attach to surfaces."

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.ViewModelFOV = 60

SWEP.Primary.Sound = Sound("weapons/grenade_launcher1.wav")
SWEP.Primary.Delay = 1

SWEP.Primary.Damage = 26.67
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.DefaultClip = 7

SWEP.ReloadSound = Sound("weapons/ar2/ar2_reload.wav")

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.WalkSpeed = SPEED_SLOWEST * 0.9

SWEP.UseHands = true

SWEP.MaxMines = 6

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAXIMUM_MINES, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Sparkler' Laser Miner", "Fires damaging laser trip mines that last several seconds", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.22
	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTBool(0, true)
			ent.Branch = true
			ent.Range = 64
		end
	end
end)

function SWEP:CanPrimaryAttack()
	if self.BaseClass.CanPrimaryAttack(self) then
		local c = 0
		for _, ent in pairs(ents.FindByClass("projectile_impactmine")) do
			if (CLIENT or ent.CreateTime + 300 > CurTime()) and ent:GetOwner() == self:GetOwner() then
				c = c + 1
			end
		end

		if c >= self.MaxMines then return false end

		return true
	end

	return false
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	return self:GetNextSecondaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	self:SetNextSecondaryFire(CurTime() + 0.1)

	local owner = self:GetOwner()
	local hitpos = owner:CompensatedMeleeTrace(2048, 1, nil, nil, false).HitPos

	if SERVER then
		for _, ent in pairs(ents.FindInSphere(hitpos, 24)) do
			if ent:GetClass() == "projectile_impactmine" and ent:GetOwner() == owner then
				local mine = ents.Create("prop_ammo")
				if mine:IsValid() then
					mine:SetAmmo(1)
					mine:SetAmmoType("impactmine")
					mine:SetPos(ent:GetStartPos())
					mine:SetAngles(ent:GetAngles())
					mine:Spawn()
				end

				if owner:IsValidLivingHuman() then
					mine.NoPickupsTime = CurTime() + 15
					mine.NoPickupsOwner = owner
				end

				ent:Remove()
			end
		end
	end
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 60, math.random(137, 143), 0.5)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound(self.ReloadSound, 60, 110, 0.5, CHAN_WEAPON + 21)
	end
end
