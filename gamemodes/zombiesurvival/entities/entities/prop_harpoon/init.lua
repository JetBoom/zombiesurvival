INC_SERVER()

ENT.NextDamage = 0
ENT.TicksLeft = 10

function ENT:Initialize()
	self:SetModel("models/props_junk/harpoon002a.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEFlags(EFL_SETTING_UP_BONES)
end

function ENT:Think()
	local parent = self:GetParent()
	if parent:IsValid() and parent:IsPlayer() then
		if parent:Alive() and parent:Team() == TEAM_UNDEAD and self.TicksLeft >= 1 and not parent.SpawnProtection then
			if CurTime() >= self.NextDamage then
				self.NextDamage = CurTime() + 0.35
				self.TicksLeft = self.TicksLeft - 1

				util.Blood((parent:NearestPoint(self:GetPos()) + parent:WorldSpaceCenter()) / 2, math.random(4, 9), Vector(0, 0, 1), 100)
				parent:TakeSpecialDamage(self.BleedPerTick, DMG_SLASH, self:GetOwner(), self)
			end
		else
			local ang = self:GetAngles()
			ang:RotateAroundAxis(ang:Up(), 180)

			local ent = ents.Create("prop_weapon")
			if ent:IsValid() then
				ent:SetWeaponType(self.BaseWeapon)
				ent:SetPos(self:GetPos())
				ent:SetAngles(ang)
				ent:Spawn()

				local owner = self:GetOwner()
				if owner:IsValidHuman() then
					ent.NoPickupsTime = CurTime() + 15
					ent.NoPickupsOwner = self:GetOwner()
				end

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:AddAngleVelocity(VectorRand() * 120)
					phys:SetVelocityInstantaneous(Vector(0, 0, 200))
				end
			end

			self:Remove()
		end
	else
		self:Remove()
	end
end
