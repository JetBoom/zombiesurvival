INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/props_wasteland/medbridge_post01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end
