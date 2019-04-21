INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_NONE

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "npc/antlion_guard/confused1.wav")
	self.AmbientSound:PlayEx(0.55, 110)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	self.AmbientSound:PlayEx(0.5, 70 + math.sin(RealTime() * 3) * 10)
end

function ENT:Draw()
end
