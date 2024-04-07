ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if SERVER then
		hook.Add("EntityTakeDamage", self, self.EntityTakeDamage)

		self:SetDTInt(1, 0)
	end

	if CLIENT then
		hook.Add("Draw", self, self.Draw)
	end

	hook.Add("Move", self, self.Move)
end

function ENT:Move(pl, move)
	if pl ~= self:GetOwner() then return end

	move:SetMaxSpeed(move:GetMaxSpeed() + 20)
	move:SetMaxClientSpeed(move:GetMaxSpeed())
end
