INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.CreateTime = CurTime()

	local cmodel = ClientsideModel("models/props_c17/substation_circuitbreaker01a.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, 0, 7)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
		cmodel:SetColor(Color(255, 205, 175, 255))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetParent(self)
		cmodel:SetOwner(self)
		cmodel:SetModelScale(0.02, 0)
		cmodel:Spawn()

		self.CModel = cmodel
	end
end

function ENT:OnRemove()
	if self.CModel and self.CModel:IsValid() then
		self.CModel:Remove()
	end
end

function ENT:Draw()
	self:DrawModel()
end

local matGlow = Material("sprites/glow04_noz")
function ENT:DrawTranslucent()
	local lightpos = self:GetPos() + self:GetUp() * 9

	if self:GetExplodeTime() ~= 0 then
		local size = (CurTime() * 8.5 % 1) * 24
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, size, size, Color(255, 50, 50, size * 5))
		render.DrawSprite(lightpos, size / 2, size / 2, Color(255, 50, 50, size * 15))
	elseif self.CreateTime + self.ArmTime < CurTime() then
		local size = 4 + (CurTime() * 2 % 1) * 6
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, size, size, Color(50, 255, 50, size * 5))
		render.DrawSprite(lightpos, size / 2, size / 2, Color(50, 255, 50, size * 15))
	end
end
