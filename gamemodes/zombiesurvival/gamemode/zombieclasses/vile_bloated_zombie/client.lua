include("shared.lua")

local render_SetColorModulation = render.SetColorModulation
local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local render_ModelMaterialOverride = render.ModelMaterialOverride

local angle_zero = angle_zero
local LocalToWorld = LocalToWorld

local colGlow = Color(70, 200, 70)
local matGlow = Material("sprites/glow04_noz")
local vecEyeLeft = Vector(5, -4, -1.2)
local vecEyeRight = Vector(5, -4, 1.2)

CLASS.Icon = "zombiesurvival/killicons/bloatedzombie"
CLASS.IconColor = Color(10, 94, 0)

local matSkin = Material("Models/Barnacle/barnacle_sheet")
function CLASS:PrePlayerDraw(pl)
	render_ModelMaterialOverride(matSkin)
	render_SetColorModulation(0.16, 0.3, 0.12)
end

function CLASS:PostPlayerDraw(pl)
	render_ModelMaterialOverride()
	render_SetColorModulation(1, 1, 1)

	if pl == MySelf and not pl:ShouldDrawLocalPlayer() or pl.SpawnProtection then return end

	local pos, ang = pl:GetBonePositionMatrixed(14)
	if pos then
		render_SetMaterial(matGlow)
		render_DrawSprite(LocalToWorld(vecEyeLeft, angle_zero, pos, ang), 4, 4, colGlow)
		render_DrawSprite(LocalToWorld(vecEyeRight, angle_zero, pos, ang), 4, 4, colGlow)
	end
end
