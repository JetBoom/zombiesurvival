INC_SERVER()

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsPlayer() then
		ent:GiveStatus("dimvision", 2.5)
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end
