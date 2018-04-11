include("shared.lua")

SWEP.PrintName = "Claws"
SWEP.ViewModelFOV = 60
SWEP.DrawCrosshair = false

function SWEP:Initialize() 

	self.GrenadeModel = ClientsideModel("models/weapons/w_grenade.mdl", RENDERGROUP_BOTH )
	self.GrenadeModel:SetNoDraw( true )
	
end

local matGlow = Material("sprites/glow04_noz")
function SWEP:DrawWorldModel()

	if not self:GetGrenading() then return end

	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local boneid = owner:LookupBone("ValveBiped.Bip01_L_Hand")
	if not boneid or boneid <= 0 then return end

	local bonepos, boneang = owner:GetBonePositionMatrixed(boneid)
	
	local test = boneang:Up() * 3
	
	local test2 = boneang:Forward() * 5
	
	local test3 = boneang:Right() * 3
	
	local test4 = boneang:Up() * 2.5
	
	local test5 = boneang:Forward() * 6
	
	local test6 = boneang:Right() * -4

	self.GrenadeModel:SetPos( bonepos + test + test2 + test3 )
	boneang:RotateAroundAxis(boneang:Right(), 240)
	boneang:RotateAroundAxis(boneang:Forward(), -80)
	self.GrenadeModel:SetAngles(boneang)
	
	self.GrenadeModel:DrawModel()
	
	if self:GetGrenading() then
	
	if CLIENT then

		render.SetMaterial(matGlow)
		render.DrawSprite(bonepos + test4 + test5 + test6, 16, 16, COLOR_RED)

		local dlight = DynamicLight(self.GrenadeModel:EntIndex())
		if dlight then
			dlight.Pos = bonepos + test + test2 + test3
			dlight.r = 255
			dlight.g = 0
			dlight.b = 0
			dlight.Brightness = 0.75
			dlight.Size = 64
			dlight.Decay = 256
			dlight.DieTime = CurTime() + 0.1
		end
	
	end
	
	end
	
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
