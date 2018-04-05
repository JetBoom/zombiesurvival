function EFFECT:Init(data)
	local ent = data:GetEntity()
	if ent:IsValid() then
		self.DieTime = CurTime() + 1

		self.Entity:SetModel(ent:GetModel())
		self.Entity:SetPos(data:GetOrigin())
		self.Entity:SetAngles(data:GetNormal():Angle())
	else
		self.DieTime = 0
	end
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

function EFFECT:Render()
	local delta = self.DieTime - CurTime()

	local brightness = delta * 120
	self.Entity:SetColor(Color(brightness, brightness, brightness, delta * 220))
	local size = 1 + math.sin(delta * 20) * (delta + 0.25)
	self.Entity:SetModelScale(size, 0)
	self.Entity:DrawModel()
end
