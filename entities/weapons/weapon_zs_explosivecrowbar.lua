AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = translate.Get("wn_explosivecrowbar")
	SWEP.Description = translate.Get("crowbar_desk")

	SWEP.ViewModelFOV = 65
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.346, 0.792, -11.096), angle = Angle(-2.635, 99.983, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.989, 2.937, -38.341), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}



SWEP.HoldType = "melee"

SWEP.MeleeDamage = 35
SWEP.MeleeRange = 90
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 10

SWEP.Primary.Delay = 0.8 

SWEP.SwingTime = 0.3
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingHoldType = "grenade"

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_Crowbar.Single")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_Crowbar.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_Crowbar.Melee_Hit")
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
        util.Effect("explosion", effectdata) 
    end
	self.Owner:TakeSpecialDamage(1, DMG_GENERIC, owner, self)

    BlastDamage2NoSelf(self, self.Owner, tr.HitPos, 70, 30)
	local ent = tr.Entity
	if ent:IsValid() and ent:IsPlayer()  then
		ent:GiveStatus("healdartboost")

end
end
