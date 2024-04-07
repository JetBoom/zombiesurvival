INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self.Seed = math.Rand(0, 10)

	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "ambient/machines/combine_shield_loop3.wav")
	self.AmbientSound:PlayEx(0.3, 150)
end

function ENT:Think()
	local emitter = self:GetEmitter()
	if emitter:IsValid() and emitter.GetAmmo and emitter:GetAmmo() > 1 then
		self.AmbientSound:PlayEx(0.3, 150 + RealTime() % 1)
	else
		self.AmbientSound:Stop()
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

local materialp = {}
materialp["$refractamount"] = 0.01
materialp["$colortint"] = "[1.0 1.3 1.9]"
materialp["$SilhouetteColor"] = "[2.1 3.5 5.0]"
materialp["$BlurAmount"] = 0.001
materialp["$SilhouetteThickness"] = 0.5
materialp["$normalmap"] = "effects/combineshield/comshieldwall"
local matRefract = CreateMaterial("forcefieldxd","Aftershock_dx9", materialp)
local matGlow = Material("models/shiny")
function ENT:DrawTranslucent()
	local emitter = self:GetEmitter()
	if not (emitter and emitter:IsValid() and emitter.GetAmmo) then return end
	if emitter:GetAmmo() < 1 then return end

	local lowammo = emitter:GetAmmo() < 30

	render.SuppressEngineLighting(true)
	render.ModelMaterialOverride(matGlow)

	local red = 1 - math.Clamp((CurTime() - self:GetLastDamaged()) * 3, 0, 1)
	local redadj = math.min(1, red + (lowammo and 1 or 0))

	render.SetColorModulation(redadj, 0.6 - redadj, 1 - redadj)
	render.SetBlend(0.007 + redadj * 0.05 + math.max(0, math.cos(CurTime())) ^ 4 * 0.007)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)

	if render.SupportsPixelShaders_2_0() then
		render.UpdateRefractTexture()

		matRefract:SetFloat("$refractamount", 0.005 + (0.01 * red))

		render.SetBlend(1)

		render.ModelMaterialOverride(matRefract)
		self:DrawModel()
	else
		render.SetBlend(1)
	end

	render.SetColorModulation(1, 1, 1)

	render.ModelMaterialOverride(0)
	render.SuppressEngineLighting(false)
end
