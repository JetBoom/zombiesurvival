AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "Walther WA 2000"
SWEP.Description = "A bad ass autosniper."

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.g3sg1_Parent"
	SWEP.HUD3DPos = Vector(-1.2, -5.75, -1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/walther/v_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/walther/w_snip_sg550.mdl"
SWEP.ShowWorldModel = false

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/walther/w_snip_sg550.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.558, 1.679, 0), angle = Angle(-5.5, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.UseHands = true
SWEP.Primary.Sound = Sound("weapons/walther/WA2000_Fire.wav")
SWEP.Primary.Damage = 72
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25
SWEP.Recoil = .25
SWEP.ReloadSpeed = 1.0
SWEP.FireAnimSpeed = 1.0
SWEP.Primary.KnockbackScale = 7

SWEP.Primary.ClipSize = 10 -- if 10 is too much, try 6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 7 -- snipers have cone of 0, cone max set to accurate range, we also don't want shots to be pin-perfect unless scoped
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(-2, -8, -2.5)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 4
SWEP.MaxStock = 3

-- GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05)
-- GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Mercurial' Birdshot Rifle", "Fires a spread of less accurate shots that deal more total damage", function(wept)
	-- wept.Primary.Damage = wept.Primary.Damage / 5
	-- wept.Primary.NumShots = 6
	-- wept.ConeMin = 3
-- end)

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
