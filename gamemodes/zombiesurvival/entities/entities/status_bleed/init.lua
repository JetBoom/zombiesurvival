AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.Bleed = self
end

function ENT:Think()
	local owner = self:GetOwner()

	if self:GetDamage() <= 0 or owner:Team() == TEAM_UNDEAD then
		self:Remove()
		return
	end

	local dmg = math.Clamp(self:GetDamage(), 1, 2)

	owner:TakeDamage(dmg, self.Damager and self.Damager:IsValid() and self.Damager:IsPlayer() and self.Damager:Team() ~= owner:Team() and self.Damager or owner, self)
	self:AddDamage(-dmg)

	local dir = VectorRand()
	dir:Normalize()
	util.Blood(owner:WorldSpaceCenter(), 3, dir, 32)

	self:NextThink(CurTime() + 1)
	return true
end
