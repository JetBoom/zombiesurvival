include("shared.lua")

CLASS.Icon = "zombiesurvival/killicons/poisonzombie"
CLASS.IconColor = Color(190, 240, 0)

local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local LocalToWorld = LocalToWorld

local colGlow = Color(110, 160, 40)
local matSkin = Material("models/headcrab/allinonebacup2")
local matGlow = Material("sprites/glow04_noz")
local angEye = Angle(0, 90, 90)
local vecEyeLeft = Vector(9.1, 1.2, -4)
local vecEyeRight = Vector(9.1, -1.2, -4)

function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(0.7, 0.9, 0.2)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)

	if pl == MySelf and not pl:ShouldDrawLocalPlayer() or pl.SpawnProtection then return end

	local pos, ang = pl:GetBonePositionMatrixed(4)
	if pos then
		render_SetMaterial(matGlow)
		render_DrawSprite(LocalToWorld(vecEyeLeft, angEye, pos, ang), 4, 4, colGlow)
		render_DrawSprite(LocalToWorld(vecEyeRight, angEye, pos, ang), 4, 4, colGlow)
	end
end
