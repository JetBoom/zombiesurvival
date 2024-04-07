ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.CanPackUp = true
ENT.PackUpTime = 4
ENT.MaxAmmo = 150
ENT.PointsMultiplier = 1.25
ENT.Damage = 25
ENT.LegDamage = 10

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.IgnoreBullets = true

ENT.IsBarricadeObject = false
ENT.AlwaysGhostable = true

function ENT:SetObjectHealth(health)
	self:SetDTFloat(1, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetModel(self:GetModel())
			ent:SetMaterial(self:GetMaterial())
			ent:SetAngles(self:GetAngles())
			ent:SetPos(self:GetPos())
			ent:SetSkin(self:GetSkin() or 0)
			ent:SetColor(self:GetColor())
			ent:Spawn()
			ent:Fire("break", "", 0)
			ent:Fire("kill", "", 0.1)
		end
	end
end

function ENT:GetObjectHealth()
	return self:GetDTFloat(1)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(2, health)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(2)
end

function ENT:GetNextZap()
	return self:GetDTFloat(0)
end

function ENT:SetNextZap(time)
	self:SetDTFloat(0, time)
end

function ENT:SetObjectOwner(owner)
	self:SetDTEntity(0, owner)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(0)
end

function ENT:SetAmmo(ammo)
	self:SetDTInt(0, ammo)
end

function ENT:GetAmmo()
	return self:GetDTInt(0)
end

function ENT:ClearObjectOwner()
	self:SetObjectOwner(NULL)
end
