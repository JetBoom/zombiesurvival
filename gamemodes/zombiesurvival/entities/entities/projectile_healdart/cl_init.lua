include("shared.lua")

ENT.NextEmit = 0

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 32)

	local cmodel = ClientsideModel("models/healthvial.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(-4, 0, 0)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(90, 0, 0)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetParent(self)
		cmodel:SetOwner(self)
		cmodel:SetModelScale(0.6, 0)
		cmodel:Spawn()

		self.CModel = cmodel
	end
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
end

function ENT:OnRemove()
	if self.CModel and self.CModel:IsValid() then
		self.CModel:Remove()
	end
end

local matOverride = Material("models/shiny")
function ENT:Draw()
	--[[local parent = self:GetParent()
	if parent == LocalPlayer() and parent:IsValid() and not parent:ShouldDrawLocalPlayer() then return end]]

	local hittime = self:GetHitTime()
	local charged = self:GetCharged()
	
	if charged then
		self.CModel:SetColor(Color(255, 0, 255))
	end
	
	if hittime == 0 then
		if charged then
			render.SetColorModulation(1, 0, 1)
		else
			render.SetColorModulation(0, 1, 0)
		end
	else
		if charged then
			local c =  1 - math.Clamp(CurTime() - hittime, 0, 1)
			render.SetColorModulation(c, 0, c)
		else
			render.SetColorModulation(0, 1 - math.Clamp(CurTime() - hittime, 0, 1), 0)
		end
	end
	render.ModelMaterialOverride(matOverride)

	self:DrawModel()

	render.ModelMaterialOverride()
	if charged then
		render.SetColorModulation(1, 0, 1)
	else
		render.SetColorModulation(1, 1, 1)
	end

	if self:GetMoveType() == MOVETYPE_NONE or CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.01

	local pos = self:GetPos()

	local emitter = self.Emitter

	local particle = emitter:Add("particles/smokey", pos)
	particle:SetDieTime(0.35)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetStartSize(1)
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 255))
	particle:SetRollDelta(math.Rand(-10, 10))
	if self:GetCharged() then
		particle:SetColor(255, 30, 255)
	else
		particle:SetColor(30, 255, 30)
	end

	emitter:Finish()
end
