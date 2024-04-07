AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:ProcessDamage(pl, dmginfo)
	if dmginfo:GetInflictor().IsMelee then
		dmginfo:SetDamage(dmginfo:GetDamage() / 2)
	end
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	local fd = pl:FakeDeath(pl:LookupSequence("death_0"..math.random(4)), self.ModelScale)
	if fd and fd:IsValid() then
		fd:SetColor(Color(0,0,0,255))
	end

	return true
end
