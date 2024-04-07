INC_CLIENT()

function ENT:CreateSubModel()
	local ent = ClientsideModel("models/props_junk/sawblade001a.mdl", RENDERGROUP_OPAQUE)
	if ent:IsValid() then
		ent:SetOwner(self)
		ent:SetParent(self)
		ent:SetPos(self:LocalToWorld(Vector(0, 0, -1.5)))
		ent:SetNoDraw(true)
		ent:SetModelScale(0.8, 0)
		ent:Spawn()
		self.SubModel = ent
	end
end

function ENT:RemoveSubModel()
	if self.SubModel and self.SubModel:IsValid() then
		self.SubModel:Remove()
	end
end

function ENT:DrawSubModel()
	if self.SubModel and self.SubModel:IsValid() then
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), (CurTime() * 2000) % 360)

		self.SubModel:SetRenderAngles(ang)
		self.SubModel:DrawModel()
	end
end

function ENT:CreateAmbientSounds()
	self.AmbientSound = CreateSound(self, "ambient/machines/spin_loop.wav")
	self.AmbientSound2 = CreateSound(self, "npc/manhack/mh_blade_loop1.wav")
end

function ENT:PlayAmbientSounds()
	self.AmbientSound:PlayEx(0.5, math.min(100 + self:GetVelocity():Length() * 0.2, 140))
	self.AmbientSound2:PlayEx(0.3, 85 + math.sin(CurTime()))
end
