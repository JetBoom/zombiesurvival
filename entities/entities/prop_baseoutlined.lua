AddCSLuaFile()

ENT.Type = "anim"

if not CLIENT then return end

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.ColorModulation = Color(1, 0.5, 1)
ENT.Seed = 0

function ENT:Initialize()
	self.Seed = math.Rand(0, 10)
end

local matWireframe = Material("models/wireframe")
local matWhite = Material("models/debug/debugwhite")
function ENT:DrawTranslucent()
	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN then
		self:DrawModel()
		return
	end

	local time = (CurTime() * 1.5 + self.Seed) % 2

	self:DrawModel()

	if time <= 1 and EyePos():Distance(self:GetPos()) <= 1024 then
		self.NoDrawSubModels = true

		local oldscale = self:GetModelScale()
		local normal = self:GetUp()
		local rnormal = normal * -1
		local mins = self:OBBMins()
		local dist = self:OBBMaxs().z - mins.z
		mins.x = 0
		mins.y = 0
		local pos = self:LocalToWorld(mins)

		self:SetModelScale(oldscale * 1.01, 0)

		if render.SupportsVertexShaders_2_0() then
			render.EnableClipping(true)
			render.PushCustomClipPlane(normal, normal:Dot(pos + dist * time * normal))
			render.PushCustomClipPlane(rnormal, rnormal:Dot(pos + dist * time * 1.25 * normal))
		end

		render.SetColorModulation(self.ColorModulation.r, self.ColorModulation.g, self.ColorModulation.b)
		render.SuppressEngineLighting(true)

		render.SetBlend(0.15)
		render.ModelMaterialOverride(matWhite)
		self:DrawModel()

		render.SetBlend(0.4)
		render.ModelMaterialOverride(matWireframe)
		self:DrawModel()

		render.ModelMaterialOverride(0)
		render.SuppressEngineLighting(false)
		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)

		if render.SupportsVertexShaders_2_0() then
			render.PopCustomClipPlane()
			render.PopCustomClipPlane()
			render.EnableClipping(false)
		end
		self:SetModelScale(oldscale, 0)

		self.NoDrawSubModels = false
	end
end
