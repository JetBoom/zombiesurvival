AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "FN F2000"
SWEP.Description = "Very accurate, very precise, very nice."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = true
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.aug_Parent"
	SWEP.HUD3DPos = Vector(-1, -2.5, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/f2000/v_rif_aug.mdl"
SWEP.WorldModel = "models/weapons/f2000/w_rif_aug.mdl"
SWEP.ShowWorldModel = false

SWEP.WElements = {
	["world"] = { type = "Model", model = "models/weapons/f2000/w_rif_aug.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-5.715, 0.518, 4.675), angle = Angle(-15.195, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/aug/aug-1.wav")
SWEP.Primary.Damage = 24
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.07
SWEP.Recoil = 0.7
SWEP.ReloadSpeed = 1.0
SWEP.FireAnimSpeed = 1.0
SWEP.Primary.KnockbackScale = 2

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 5 -- assault rifles min cone is 1, max is accurate range
SWEP.ConeMin = 1

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.IronSightsPos = Vector(4.37, -2, -2)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end


-- GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)
-- GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Inferno' Incendiary Rifle", "Fires incendiary assault rifle rounds, but reduced damage", function(wept)
	-- wept.Primary.Damage = wept.Primary.Damage * 0.85

	-- wept.BulletCallback = function(attacker, tr, dmginfo)
		-- local ent = tr.Entity
		-- if SERVER and math.random(6) == 1 and ent:IsValidLivingZombie() then
			-- ent:Ignite(6)
			-- for __, fire in pairs(ents.FindByClass("entityflame")) do
				-- if fire:IsValid() and fire:GetParent() == ent then
					-- fire:SetOwner(attacker)
					-- fire:SetPhysicsAttacker(attacker)
					-- fire.AttackerForward = attacker
				-- end
			-- end
		-- end
	-- end
-- end)