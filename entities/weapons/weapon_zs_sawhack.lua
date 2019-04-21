AddCSLuaFile()

SWEP.PrintName = "Sawhack"

if CLIENT then
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["axe"] = { type = "Model", model = "models/props/cs_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.184, 1.501, -7.421), angle = Angle(2.427, -10, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["saw"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "axe", pos = Vector(0, 14, -0.021), angle = Angle(0, 0, 0), size = Vector(0.449, 0.449, 0.805), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["saw2"] = { type = "Model", model = "models/XQM/Rails/trackball_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "axe", pos = Vector(0, 14, 0), angle = Angle(0, 90, 0), size = Vector(0.234, 0.234, 0.133), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/door_klab01", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["axe"] = { type = "Model", model = "models/props/cs_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.023, 2.147, -8.32), angle = Angle(-6.166, 20.881, 86.675), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["saw2"] = { type = "Model", model = "models/XQM/Rails/trackball_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "axe", pos = Vector(0, 14, 0), angle = Angle(0, 90, 0), size = Vector(0.234, 0.234, 0.133), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/door_klab01", skin = 0, bodygroup = {} },
		["saw"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "axe", pos = Vector(0, 14, -0.021), angle = Angle(0, 0, 0), size = Vector(0.449, 0.449, 0.805), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.Primary.Delay = 0.45

SWEP.MeleeDamage = 32
SWEP.MeleeRange = 55
SWEP.MeleeSize = 1.9
SWEP.MeleeKnockBack = 100
SWEP.MeleeViewPunchScale = 0.25

SWEP.WalkSpeed = SPEED_FAST

SWEP.SwingTime = 0.15
SWEP.SwingRotation = Angle(0, -35, -50)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.HoldType = "melee2"
SWEP.SwingHoldType = "melee2"

SWEP.HitDecal = "Manhackcut"
SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_KNOCK, 10, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "Razorhack", "Increased attack delay, but deals more damage while bleeding", function(wept)
	wept.Primary.Delay = wept.Primary.Delay * 1.25
	wept.OnMeleeHit = function(self, hitent, hitflesh, tr)
		if self:GetOwner():GetBleedDamage() > 1 then
			self.MeleeDamage = wept.MeleeDamage * 1.5
		end
	end

	wept.PostOnMeleeHit = function(self, hitent, hitflesh, tr)
		self.MeleeDamage = wept.MeleeDamage
	end
end)

SWEP.NoHitSoundFlesh = true

SWEP.Tier = 2
SWEP.DismantleDiv = 2

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(75, 80))
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/manhack/grind"..math.random(5)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitflesh then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetMagnitude(2)
			effectdata:SetScale(1)
		util.Effect("sparks", effectdata)
	end
end
