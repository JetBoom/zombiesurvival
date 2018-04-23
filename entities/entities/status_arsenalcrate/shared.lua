ENT.Type = "anim"
ENT.IsBarricadeObject = true
ENT.AlwaysGhostable = true

function ENT:ShouldNotCollide(ent)
    return false
end