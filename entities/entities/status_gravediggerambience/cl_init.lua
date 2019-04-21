INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_NONE

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "npc/fast_zombie/gurgle_loop1.wav")
	self.AmbientSound:PlayEx(0.55, 110)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsValid() then
		self.AmbientSound:PlayEx(0.6, 50 + math.Rand(-15, 15) + math.sin(RealTime() * 4) * 10)
	end
end

function ENT:Draw()
end
