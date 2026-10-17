INC_SERVER()

SWEP.ThrownProjectile = "projectile_nanitecloudbomb"
SWEP.ThrowAngVel = 30
SWEP.ThrowVel = 600

function SWEP:EntModify(ent)
    ent.NaniteCloudHealPower = self.NaniteCloudHealPower
    ent.NaniteCloudTickTime  = self.NaniteCloudTickTime
    ent.NaniteCloudTicks     = self.NaniteCloudTicks
    ent.NaniteCloudRadius    = self.NaniteCloudRadius
end
