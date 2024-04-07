AddCSLuaFile()

SWEP.PrintName = "'Reaper' UMP"
SWEP.Description = "A hard hitting SMG that provides a short duration stacking damage buff if you earn a kill."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.ump45_Release"
	SWEP.HUD3DPos = Vector(-1.5, -3, 2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_UMP45.Single")
SWEP.Primary.Damage = 19.125
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 4
SWEP.ConeMin = 2.1

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ReloadSpeed = 1.05

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.IronSightsPos = Vector(-5.3, -3, 4.4)
SWEP.IronSightsAng = Vector(-1, 0.2, 2.55)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.015)

function SWEP:OnZombieKilled()
	local killer = self:GetOwner()

	if killer:IsValid() then
		local reaperstatus = killer:GiveStatus("reaper", 14)
		if reaperstatus and reaperstatus:IsValid() then
			reaperstatus:SetDTInt(1, math.min(reaperstatus:GetDTInt(1) + 1, 3))
			killer:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetDTInt(1) * 30, 0.45)
		end
	end
end

function SWEP.BulletCallback(attacker, tr)
	local hitent = tr.Entity
	if hitent:IsValidLivingZombie() and hitent:Health() <= hitent:GetMaxHealthEx() * 0.04 and gamemode.Call("PlayerShouldTakeDamage", hitent, attacker) then
		if SERVER then
			hitent:SetWasHitInHead()
		end
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, attacker, attacker:GetActiveWeapon(), tr.HitPos)
		hitent:EmitSound("npc/roller/blade_out.wav", 80, 125)
	end
end

if not CLIENT then return end

function SWEP:Draw3DHUD(vm, pos, ang)
	self.BaseClass.Draw3DHUD(self, vm, pos, ang)

	local wid, hei = 180, 200
	local x, y = wid * -0.6, hei * -0.5

	cam.Start3D2D(pos, ang, self.HUD3DScale)
		local owner = self:GetOwner()
		local ownerstatus = owner:GetStatus("reaper")
		if ownerstatus then
			local text = ""
			for i = 0, ownerstatus:GetDTInt(1)-1 do
				text = text .. "+"
			end
			draw.SimpleTextBlurry(text, "ZS3D2DFontSmall", x + wid/2, y + hei * 0.15, Color(60, 30, 175, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end
