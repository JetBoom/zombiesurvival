include("shared.lua")

CLASS.Icon = "zombiesurvival/killicons/gigagorechild"
CLASS.IconColor = Color(20, 20, 20)

local render_ModelMaterialOverride = render.ModelMaterialOverride
local render_SetBlend = render.SetBlend
local render_SetColorModulation = render.SetColorModulation
local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local angle_zero = angle_zero
local LocalToWorld = LocalToWorld

local colGlow = Color(255, 0, 0)
local matGlow = Material("sprites/glow04_noz")
local matBlack = CreateMaterial("shadowlurkersheet", "UnlitGeneric", {["$basetexture"] = "Tools/toolsblack", ["$model"] = 1})
local vecEyeLeft = Vector(8, -5.5, -1.5)
local vecEyeRight = Vector(8, -5.5, 1.5)
local matSheet = Material("models/props_c17/doll01")

function CLASS:DrawHands(pl, hands)
	render_ModelMaterialOverride(matSheet)
	render_SetColorModulation(0.1, 0.1, 0.1)
	render_SetBlend(0.55)

	hands:DrawModel()

	render_SetBlend(1)
	render_SetColorModulation(1, 1, 1)
	render_ModelMaterialOverride(nil)

	return true
end

function CLASS:PrePlayerDraw(pl)
	render_SetBlend(0.55)
	render_SetColorModulation(0.1, 0.1, 0.1)
end

function CLASS:PostPlayerDraw(pl)
	render_SetBlend(1)
	render_SetColorModulation(1, 1, 1)
end

function CLASS:PrePlayerDrawOverrideModel(pl)
	render_ModelMaterialOverride(matBlack)
end

function CLASS:PostPlayerDrawOverrideModel(pl)
	render_ModelMaterialOverride(nil)

	if pl == MySelf and not pl:ShouldDrawLocalPlayer() then return end

	local pos, ang = pl:GetBonePositionMatrixed(6)
	if pos then
		render_SetMaterial(matGlow)
		render_DrawSprite(LocalToWorld(vecEyeLeft, angle_zero, pos, ang), 4, 4, colGlow)
		render_DrawSprite(LocalToWorld(vecEyeRight, angle_zero, pos, ang), 4, 4, colGlow)
	end
end
