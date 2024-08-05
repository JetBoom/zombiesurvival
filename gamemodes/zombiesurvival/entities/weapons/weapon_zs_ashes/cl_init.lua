include("shared.lua")

SWEP.PrintName = "갈탄 럴커"
SWEP.ViewModelFOV = 50
SWEP.DrawCrosshair = true

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/Charple/Charple4_sheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end
