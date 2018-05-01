INC_CLIENT()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.5, 0)

	if self:GetOwner() == MySelf then
		self.AmbientSound = CreateSound(self, "player/breathe1.wav")
	end
end

function ENT:Think()
	if self.AmbientSound then
		if MySelf:WaterLevel() >= 3 then
			self.AmbientSound:Play()
		else
			self.AmbientSound:Stop()
		end
	end
end

function ENT:OnRemove()
	if self.AmbientSound then
		self.AmbientSound:Stop()
	end
end

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end

	local wep = owner:GetActiveWeapon()
	if wep:IsValid() and wep:GetClass() == "weapon_zs_t_oxygentank" then return end

	local boneid = owner:LookupBone("ValveBiped.Bip01_Spine2")
	if not boneid or boneid <= 0 then return end

	local bonepos, boneang = owner:GetBonePositionMatrixed(boneid)

	self:SetPos(bonepos + boneang:Forward() + boneang:Right() * 4)
	boneang:RotateAroundAxis(boneang:Right(), 270)
	boneang:RotateAroundAxis(boneang:Up(), 180)
	self:SetAngles(boneang)

	if owner.ShadowMan then
		render.SetBlend(0.2)
	end

	self:DrawModel()

	if owner.ShadowMan then
		render.SetBlend(1)
	end
end
