INC_CLIENT()

ENT.NextEmit = 0

function ENT:Initialize()
	local cmodel = ClientsideModel("models/healthvial.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(-4, 0, 0)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(90, 0, 0)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetParent(self)
		cmodel:SetOwner(self)
		cmodel:SetModelScale(0.4, 0)
		cmodel:Spawn()

		self.CModel = cmodel
	end
end

function ENT:OnRemove()
	if self.CModel and self.CModel:IsValid() then
		self.CModel:Remove()
	end
end

local matOverride = Material("models/shiny")
function ENT:Draw()
	local hittime = self:GetHitTime()
	if hittime == 0 then
		render.SetColorModulation(0, 1, 0)
	else
		render.SetColorModulation(0, 1 - math.Clamp(CurTime() - hittime, 0, 1), 0)
	end
	render.ModelMaterialOverride(matOverride)

	self:DrawModel()

	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)

	if self:GetMoveType() == MOVETYPE_NONE or CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.01

	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	local particle = emitter:Add("particles/smokey", pos)
	particle:SetDieTime(0.35)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetStartSize(1)
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 255))
	particle:SetRollDelta(math.Rand(-10, 10))
	particle:SetColor(30, 255, 30)

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
