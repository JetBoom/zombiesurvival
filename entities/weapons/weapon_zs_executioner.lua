AddCSLuaFile()

SWEP.PrintName = "'Executioner' Axe"
SWEP.Description = "Instantly kills zombies brought bellow 10% of their max health."

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["base+++"] = { type = "Model", model = "models/hunter/triangles/1x1mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(3.743, 0, 19.208), angle = Angle(180, 0, 90), size = Vector(0.12, 0.029, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/props_docks/channelmarker_gib01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.207, 1.348, -11.422), angle = Angle(-180, 0, 0), size = Vector(0.15, 0.15, 0.813), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 15.366), angle = Angle(0, 0, 0), size = Vector(0.09, 0.09, 0.143), color = Color(211, 255, 255, 255), surpresslightning = false, material = "models/props_debris/rebar_medthin01", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/hunter/tubes/circle2x2d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.888, 0, 19.982), angle = Angle(-33.882, 0, 90), size = Vector(0.231, 0.268, 0.159), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_docks/channelmarker_gib01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.664, 2.203, -11.2), angle = Angle(174.453, 19.062, 3.076), size = Vector(0.15, 0.15, 0.813), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/hunter/triangles/1x1mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(3.743, 0, 19.208), angle = Angle(180, 0, 90), size = Vector(0.12, 0.029, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 15.366), angle = Angle(0, 0, 0), size = Vector(0.09, 0.09, 0.143), color = Color(211, 255, 255, 255), surpresslightning = false, material = "models/props_debris/rebar_medthin01", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/hunter/tubes/circle2x2d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.888, 0, 19.982), angle = Angle(-33.882, 0, 90), size = Vector(0.231, 0.268, 0.159), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 125
SWEP.MeleeRange = 75
SWEP.MeleeSize = 2.75
SWEP.MeleeKnockBack = 225

SWEP.Primary.Delay = 1.35

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingTime = 0.7
SWEP.SwingRotation = Angle(0, -20, -40)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.SwingHoldType = "melee"

SWEP.Tier = 3

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
