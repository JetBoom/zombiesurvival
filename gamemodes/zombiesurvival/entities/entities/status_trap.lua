AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.LifeTime = 3

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	if SERVER then
		hook.Add("Move", self, self.Move)
	end
	self.DieTime = CurTime() + self.LifeTime
end

function ENT:Move(pl, move)
		if pl ~= self:GetOwner() then return end
		move:SetMaxSpeed(1)
		move:SetMaxClientSpeed(1)
end