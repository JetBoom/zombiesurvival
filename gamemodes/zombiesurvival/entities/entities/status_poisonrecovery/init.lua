AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.PoisonRecovery = self
end

function ENT:Think()
	local owner = self:GetOwner()

	if self:GetDamage() <= 0 or owner:Team() == TEAM_UNDEAD then
		self:Remove()
		return
	end

	owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + 1))
	self:AddDamage(-1)

	self:NextThink(CurTime() + 0.75)
	--self:NextThink(CurTime() + (owner.BuffResistant and 0.375 or 0.75))
	return true
end
