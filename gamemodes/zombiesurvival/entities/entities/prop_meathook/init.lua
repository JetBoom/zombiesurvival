AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.NextDamage = 0
ENT.TicksLeft = 50

function ENT:Initialize()
	self:SetModel("models/props_junk/meathook001a.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEFlags(EFL_SETTING_UP_BONES)
end

function ENT:Think()
	local parent = self:GetParent()
	if parent:IsValid() and parent:IsPlayer() then
		if parent:Alive() and parent:Team() == TEAM_UNDEAD and self.TicksLeft >= 1 then
			if CurTime() >= self.NextDamage then
				self.NextDamage = CurTime() + 0.5
				self.TicksLeft = self.TicksLeft - 1

				util.Blood((parent:NearestPoint(self:GetPos()) + parent:WorldSpaceCenter()) / 2, math.random(4, 9), Vector(0, 0, 1), 100)
				parent:TakeDamage(6, self:GetOwner(), self)
			end
		else
			local ent = ents.Create("prop_weapon")
			if ent:IsValid() then
				ent:SetWeaponType("weapon_zs_hook")
				ent:SetPos(self:GetPos())
				ent:SetAngles(self:GetAngles())
				ent:Spawn()

				local owner = self:GetOwner()
				if owner:IsValid() and owner:IsPlayer() and owner:Team() == TEAM_HUMAN then
					ent.NoPickupsTime = CurTime() + 3
					ent.NoPickupsOwner = self:GetOwner()
				end

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:AddAngleVelocity(VectorRand() * 200)
					phys:SetVelocityInstantaneous(Vector(0, 0, 200) + parent:GetVelocity())
				end
			end

			self:Remove()
		end
	else
		self:Remove()
	end
end
