AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = translate.Get("craft_nukemasher")
	SWEP.ViewModelFOV = 75

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/iBeam01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.706, 2.761, -22), angle = Angle(13, -12.5, 0), size = Vector(0.15, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base2"] = { type = "Model", model = "models/props_wasteland/buoy01.mdl", bone = "ValveBiped.Bip01", rel = "base", pos = Vector(12, 0, 0), angle = Angle(0, 90, 270), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base3"] = { type = "Model", model = "models/shadertest/vertexlitselfillummaskenvmaptex.mdl", bone = "ValveBiped.Bip01", rel = "base", pos = Vector(1.5, 0, 0), angle = Angle(110, 270, 90), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/iBeam01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10, 1, -35), angle = Angle(0, 0, 0), size = Vector(0.15, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base2"] = { type = "Model", model = "models/props_wasteland/buoy01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(12, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base3"] = { type = "Model", model = "models/shadertest/vertexlitselfillummaskenvmaptex.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.5, 0, 0), angle = Angle(90, 270, 90), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/v_sledgehammer/v_sledgehammer.mdl"
SWEP.WorldModel = "models/weapons/w_sledgehammer.mdl"

SWEP.MeleeDamage = 1000
SWEP.MeleeRange = 75
SWEP.MeleeSize = 4
SWEP.MeleeKnockBack = 100

SWEP.Primary.Delay = 10.05

SWEP.WalkSpeed = SPEED_SLOWEST * 0.7

SWEP.SwingRotation = Angle(60, 0, -80)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingTime = 1.83
SWEP.SwingHoldType = "melee"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(20, 25))
end

function SWEP:PlayHitSound()
	self:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(4)..".wav", 80, math.Rand(95, 105))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_bloody_break.wav", 80, math.Rand(90, 100))
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("skyhammer3", effectdata)
end


local function BlastDamage2NoSelf(inflictor, attacker, epicenter, radius, damage)
    for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
        if ent and ent:IsValid() and ent != attacker then
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
        util.Effect("skyhammer3", effectdata) 
    end
    BlastDamage2NoSelf(self, self.Owner, tr.HitPos, 650, 800)
	self.Owner:SetGroundEntity(NULL)
    self.Owner:SetVelocity(-420 * 1 * self.Owner:GetAimVector())
end