include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self.Seed = math.Rand(0, 10)

	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "ambient/machines/combine_shield_touch_loop1.wav")
	self.AmbientSound:PlayEx(0.1, 100)
end

function ENT:Think()
	self.AmbientSound:PlayEx(0.1, 100 + RealTime() % 1)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

local matRefract = Material("models/spawn_effect")
local matGlow = Material("Models/props_combine/combine_fenceglow")
function ENT:DrawTranslucent()
	render.SuppressEngineLighting(true)
	render.ModelMaterialOverride(matGlow)

	render.SetBlend(0.05 + math.max(0, math.cos(CurTime())) ^ 4 * 0.01)
	self:DrawModel()

	if render.SupportsPixelShaders_2_0() then
		render.UpdateRefractTexture()

		matRefract:SetFloat("$refractamount", 0.0125 + math.sin(CurTime() * 2) ^ 2 * 0.0025)

		render.SetBlend(1)

		render.ModelMaterialOverride(matRefract)
		self:DrawModel()
	else
		render.SetBlend(1)
	end
	
	render.ModelMaterialOverride(0)
	render.SuppressEngineLighting(false)
end
