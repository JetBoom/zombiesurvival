INC_SERVER()

local BaseClassMelee = baseclass.Get("weapon_zs_basemelee") -- Don't swap these two around. The order matters...but only in this file. For some reason.
DEFINE_BASECLASS("weapon_zs_base")

function SWEP:ServerMeleeHitEntity(tr, hitent, damagemultiplier)
	BaseClassMelee.ServerMeleeHitEntity(self, tr, hitent, damagemultiplier)
end

function SWEP:ServerMeleePostHitEntity(tr, hitent, damagemultiplier)
	BaseClassMelee.ServerMeleePostHitEntity(self, tr, hitent, damagemultiplier)
end

function SWEP:ServerHitFleshEffects(hitent, tr, damagemultiplier)
	BaseClassMelee.ServerHitFleshEffects(self, hitent, tr, damagemultiplier)
end
