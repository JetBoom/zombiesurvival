INC_SERVER()

SWEP.ThrownProjectile = "projectile_mediccloudbomb"
SWEP.ThrowAngVel = 30
SWEP.ThrowVel = 600

function SWEP:EntModify(ent)
    ent.MedicCloudHealAmount = self.MedicCloudHealAmount
    ent.MedicCloudTickTime   = self.MedicCloudTickTime
    ent.MedicCloudTicks      = self.MedicCloudTicks
    ent.MedicCloudRadius     = self.MedicCloudRadius
end
