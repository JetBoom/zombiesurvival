AddCSLuaFile()

SWEP.PrintName = "Meat Hook"
SWEP.Description = "Impales itself into zombies, dealing damage over time for a seconds. The hook can be recollected by the owner."

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.363, -5), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.181, 4, -9), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_SLASH

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_junk/meathook001a.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 40
SWEP.MeleeRange = 50
SWEP.MeleeSize = 1.15

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingTime = 0.75
SWEP.SwingHoldType = "grenade"

SWEP.NoGlassWeapons = true

SWEP.AllowQualityWeapons = true
SWEP.Weaken = false

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_IMPACT_DELAY, -0.1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "Meat Grapple", "Deals less damage but zombies affected by it take more damage from any source", function(wept)
	wept.Weaken = true
	wept.MeleeDamage = wept.MeleeDamage * 0.65
end)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(95, 105))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.random(120, 130))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_sheet_impact_bullet"..math.random(2)..".wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if SERVER and hitent:IsValid() and hitent:IsPlayer() and hitent:Health() > self.MeleeDamage and not hitent.SpawnProtection then
		local ang = self:GetOwner():EyeAngles()
		ang:RotateAroundAxis(ang:Forward(), 180)

		local ent = ents.Create("prop_meathook")
		if ent:IsValid() then
			ent:SetPos(tr.HitPos)
			ent.BaseWeapon = self:GetClass()
			ent.Weaken = true
			ent:Spawn()
			ent.BleedPerTick = 2
			ent.TicksRemaining = 20
			ent:SetOwner(self:GetOwner())
			ent:SetParent(hitent)
			ent:SetAngles(ang)
		end

		timer.Simple(0, function() self:GetOwner():StripWeapon(self:GetClass()) end)
	end
end
