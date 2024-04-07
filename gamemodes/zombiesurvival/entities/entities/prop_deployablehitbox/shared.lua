ENT.Type = "anim"

ENT.IgnoreMelee = true
ENT.IgnoreBullets = true
ENT.IgnoreTraces = true

ENT.CanPackUp = true

ENT.BoxMin = Vector(-8, -8, 0)
ENT.BoxMax = Vector(8, 8, 8)

function ENT:ShouldNotCollide(ent)
	if ent:IsProjectile() then
		local owner = ent:GetOwner()
		if owner:IsValid() and owner:IsHuman() then return true end
	end

	local colgroup = ent:GetCollisionGroup()
	if colgroup == COLLISION_GROUP_PLAYER or colgroup == COLLISION_GROUP_WEAPON or colgroup == COLLISION_GROUP_NONE then
		return true
	end

	return false
end

function ENT:GetObjectOwner()
	local parent = self:GetParent()
	if parent:IsValid() then return parent:GetObjectOwner() end

	return NULL
end
