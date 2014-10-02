AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.NextAura = 0
function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self.NextAura <= CurTime() then
		self.NextAura = CurTime() + 2

		local origin = self.Owner:LocalToWorld(self.Owner:OBBCenter())
		for _, ent in pairs(ents.FindInSphere(origin, 40)) do
			if ent:IsPlayer() and ent:Team() ~= TEAM_UNDEAD and ent:Alive() and TrueVisible(origin, ent:NearestPoint(origin)) then
				ent:PoisonDamage(1, self.Owner, self)
			end
		end
	end
end
