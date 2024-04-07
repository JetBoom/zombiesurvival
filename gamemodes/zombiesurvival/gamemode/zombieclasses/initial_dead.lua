CLASS.Base = "freshdead"

CLASS.Name = "Initial Dead"
CLASS.TranslationName = "class_initial_dead"
CLASS.Description = ""
CLASS.Help = ""

CLASS.Wave = 0
CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.Health = 180
CLASS.Speed = 230

CLASS.Points = CLASS.Health/GM.HumanoidZombiePointRatio

CLASS.CanTaunt = true

CLASS.UsePreviousModel = true

CLASS.SWEP = "weapon_zs_freshdead"

if SERVER then
	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/fresh_dead"

local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local angle_zero = angle_zero
local LocalToWorld = LocalToWorld

local colGlow = Color(255, 0, 0)
local matGlow = Material("sprites/glow04_noz")
local vecEyeLeft = Vector(5, -3.5, -1)
local vecEyeRight = Vector(5, -3.5, 1)

function CLASS:PostPlayerDrawOverrideModel(pl)
	if pl == MySelf and not pl:ShouldDrawLocalPlayer() then return end

	local id = pl:LookupBone("ValveBiped.Bip01_Head1")
	if id and id > 0 then
		local pos, ang = pl:GetBonePositionMatrixed(id)
		if pos then
			render_SetMaterial(matGlow)
			render_DrawSprite(LocalToWorld(vecEyeLeft, angle_zero, pos, ang), 4, 4, colGlow)
			render_DrawSprite(LocalToWorld(vecEyeRight, angle_zero, pos, ang), 4, 4, colGlow)
		end
	end
end
