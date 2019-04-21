AddCSLuaFile()

ENT.Type = "anim"

if not CLIENT then return end

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.ColorModulation = Color(1, 0.5, 1)
ENT.Seed = 0

function ENT:Initialize()
	self.Seed = math.Rand(0, 10)
end

function ENT:DrawPreciseModel(ble, cmod)
	if self.PropWeapon and not self.ShowBaseModel then
		render.SetBlend(0)
	end
	self:DrawModel()
	if self.PropWeapon and not self.ShowBaseModel then
		render.SetBlend(1)
	end
	if self.RenderModels and not self.NoDrawSubModels then
		self:RenderModels(ble, cmod)
	end
end

local matWireframe = Material("models/wireframe")
local matWhite = Material("models/debug/debugwhite")
function ENT:DrawTranslucent()
	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN then
		self:DrawPreciseModel()
		return
	end

	local mul = self.QualityTier and (self.QualityTier + 1) or 1
	local time = (CurTime() * 1.5*mul + self.Seed) % 2/mul

	self:DrawPreciseModel()

	if time > 1 then return end

	local eyepos = EyePos()
	local pos = self:GetPos()
	local dist = eyepos:DistToSqr(pos)

	if dist > 1048576 then return end--or (self.PropWeapon and not self.ShowBaseModel) then return end -- 1024^2

	--self.NoDrawSubModels = true

	local oldscale = self:GetModelScale()
	local normal = self:GetUp()
	local rnormal = normal * -1
	local mins = self:OBBMins()
	local mdist = self:OBBMaxs().z - mins.z
	mins.x = 0
	mins.y = 0
	local minpos = self:LocalToWorld(mins)

	self:SetModelScale(oldscale * 1.01, 0)

	if render.SupportsVertexShaders_2_0() then
		render.EnableClipping(true)
		render.PushCustomClipPlane(normal, normal:Dot(minpos + mdist * time * normal))
		render.PushCustomClipPlane(rnormal, rnormal:Dot(minpos + mdist * time * (1 + 0.25 * mul) * normal))
	end

	local qcol = {self.ColorModulation.r, self.ColorModulation.g, self.ColorModulation.b}
	if self.QualityTier then
		local customcols = self.BranchData and self.BranchData.Colors and self.BranchData.Colors[self.QualityTier]

		if customcols then
			qcol = {customcols.r/255, customcols.g/255, customcols.b/255}
		else
			local qcolt = GAMEMODE.WeaponQualityColors[self.QualityTier][self.Branch and 2 or 1]
			qcol = {qcolt.r/255, qcolt.g/255, qcolt.b/255}
		end
	end
	render.SetColorModulation(unpack(qcol))
	render.SuppressEngineLighting(true)

	render.SetBlend(0.1 + 0.05 * mul)
	render.ModelMaterialOverride(matWhite)
	if MySelf:IsSkillActive(SKILL_SCAVENGER) then
		cam.IgnoreZ(true)
	end
	self:DrawPreciseModel(0.1 + 0.05 * mul, qcol)

	render.SetBlend(0.05 + 0.1 * mul)
	render.ModelMaterialOverride(matWireframe)
	self:DrawPreciseModel(0.05 + 0.1 * mul, qcol)

	cam.IgnoreZ(false)

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

	--self.NoDrawSubModels = false
end

function ENT:Draw()
	self:DrawTranslucent()
end
