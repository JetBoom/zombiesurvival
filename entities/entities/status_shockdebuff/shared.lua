ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if CLIENT then
		hook.Add("Draw", self, self.Draw)
	end
end
