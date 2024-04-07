AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	pl:FakeDeath(pl:LookupSequence("releasecrab"), self.ModelScale)

	return true
end
