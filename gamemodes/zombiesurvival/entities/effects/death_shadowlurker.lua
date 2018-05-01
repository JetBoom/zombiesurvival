EFFECT.LifeTime = 1

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local normal = data:GetNormal()
	local ent = data:GetEntity()

	self.Entity:SetPos(pos)
	self.Entity:SetAngles(normal:Angle())

	if ent:IsValid() then
		self.DieTime = CurTime() + self.LifeTime
		self.Entity:SetModel(ent:GetModel())
	else
		self.DieTime = 0
	end
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

function EFFECT:Render()
	local delta = (self.DieTime - CurTime()) / self.LifeTime

	self.Entity:SetModelScale(2 - delta ^ 2, 0)

	render.SetBlend(delta)
	render.SetColorModulation(0.05, 0.05, 0.05)
	self.Entity:DrawModel()
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
end
