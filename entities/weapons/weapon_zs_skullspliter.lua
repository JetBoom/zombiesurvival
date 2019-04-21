AddCSLuaFile()

SWEP.PrintName = "'skull spliter' Axe"
SWEP.Description = "Instantly kills zombies brought bellow 10% of their max health."

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false

end


SWEP.WElements = {
	["Axe"] = { type = "Model", model = "models/aoc_weapon/w_doubleaxe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.518, -0, 15.064), angle = Angle(3.506, -111.04, 101.688), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel 	= "models/aoc_weapon/v_doubleaxe.mdl" 
SWEP.WorldModel = "models/aoc_weapon/w_doubleaxe.mdl"
SWEP.UseHands = false


SWEP.MeleeDamage = 350
SWEP.MeleeRange = 70
SWEP.MeleeSize = 2.75
SWEP.MeleeKnockBack = 225

SWEP.Primary.Delay = 2.00

SWEP.WalkSpeed = SPEED_FAST

SWEP.SwingTime = 1.5
SWEP.SwingRotation = Angle(-35, -30, -40)
SWEP.SwingOffset = Vector(20, 0, 0)
SWEP.SwingHoldType = "melee"

SWEP.HitDecal = "Manhackcut"


SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.13)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf club/golf_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Alive() and hitent:Health() <= hitent:GetMaxHealthEx() * 0.1 and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		if SERVER then
			hitent:SetWasHitInHead()
		end
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
		hitent:EmitSound("npc/roller/blade_out.wav", 80, 75)
	end
end
