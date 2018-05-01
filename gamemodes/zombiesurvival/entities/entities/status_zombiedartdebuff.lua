AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if SERVER then
		hook.Add("EntityTakeDamage", self, self.EntityTakeDamage)

		self:SetDTInt(1, 0)
	end
end

function ENT:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker ~= self:GetOwner() then return end

	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
		local dmg = dmginfo:GetDamage()
		dmginfo:SetDamage(dmg * 0.75)
	end
end
