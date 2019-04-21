INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_NONE

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "npc/fast_zombie/gurgle_loop1.wav")
	self.AmbientSound:PlayEx(1, 26)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	--[[owner = self:GetOwner()
	if owner:IsValid() then
		local wep = owner:GetActiveWeapon()
		if wep:IsValid() and wep.IsSwinging and wep:IsSwinging() then
			self.AmbientSound:Stop()
		else
			self.AmbientSound:PlayEx(1, 26 + math.sin(RealTime()))
		end
	end]]
end

function ENT:Draw()
end
