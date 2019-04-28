AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = translate.Get("craft_electricshovel")
	SWEP.Description = translate.Get("shovel_desk")

	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
	["element_name2"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-10.313, 9.486, -23.882), angle = Angle(-1.787, -88.184, 97.097), size = Vector(0.246, 0.246, 0.246), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name2+"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-10.235, 6.385, -23.882), angle = Angle(180, -89.081, 84.383), size = Vector(0.246, 0.246, 0.246), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-8.311, 6.609, -11.733), angle = Angle(177.225, -2.448, -175.146), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["element_name2"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.475, 3.788, -48.227), angle = Angle(1.728, -102.403, 83.916), size = Vector(0.384, 0.384, 0.384), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name2+"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.793, -1.04, -48.227), angle = Angle(180, -102.403, 94.777), size = Vector(0.384, 0.384, 0.384), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.065, 1.046, -21.812), angle = Angle(-2.266, 168.904, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true
SWEP.ShowWorldModel = false

SWEP.MeleeDamage = 60
SWEP.MeleeRange = 98
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 30

SWEP.Primary.Delay = 1.2 SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingRotation = Angle(0, -90, -60)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.64 
SWEP.SwingHoldType = "melee"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/shovel/shovel_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

local function BlastDamage2NoSelf(inflictor, attacker, epicenter, radius, damage)
    for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
        if ent and ent:IsValid() and ent ~= attacker then
            local nearest = ent:NearestPoint(epicenter)
            if TrueVisibleFilters(epicenter, nearest, inflictor, ent) then
                ent:TakeSpecialDamage(((radius - nearest:Distance(epicenter)) / radius) * damage, DMG_BLAST, attacker, inflictor, nearest)
            end
        end
    end
end


function SWEP:OnMeleeHit(hitent, hitflesh, tr)
    local effectdata = EffectData()
        effectdata:SetOrigin(tr.HitPos)
        effectdata:SetNormal(tr.HitNormal)
    if IsFirstTimePredicted() then
        util.Effect("cball_explode", effectdata) 
    end

    BlastDamage2NoSelf(self, self.Owner, tr.HitPos, 50, 40)
	local ent = tr.Entity
	if ent:IsValid() and ent:IsPlayer()  then
		ent:AddLegDamage(30)
		self.Owner:TakeSpecialDamage(0, DMG_GENERIC, owner, self)

end
end
