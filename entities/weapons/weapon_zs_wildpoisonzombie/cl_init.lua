INC_CLIENT()

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
	render.SetColorModulation(1, 1, 1)
end

local matSheet = Material("Models/headcrab/allinonebacup2.vtf")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
	render.SetColorModulation(0.7, 0.9, 0.2)
end
