INC_CLIENT()

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
	render.SetColorModulation(1, 1, 1)
end

local matSheet = Material("Models/humans/corpse/corpse1.vtf")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
	render.SetColorModulation(0.2, 0.5, 0.95)
end
