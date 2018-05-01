GM.WorldConversions = {}
GM.StarterTrinkets = {
	"trinket_armband",
	"trinket_condiments",
	"trinket_emanual",
	"trinket_aimaid",
	"trinket_vitamins",
	"trinket_welfare",
	"trinket_chemistry"
}

function GM:AddWorldPropConversionRecipe(model, result)
	local datatab = {Result = result, Index = wcindex}
	self.WorldConversions[model] = datatab
	self.WorldConversions[#self.WorldConversions + 1] = datatab
end

GM:AddWorldPropConversionRecipe("models/props_combine/breenbust.mdl", 		"comp_busthead")
GM:AddWorldPropConversionRecipe("models/props_junk/sawblade001a.mdl", 		"comp_sawblade")
GM:AddWorldPropConversionRecipe("models/props_junk/propane_tank001a.mdl", 	"comp_propanecan")
GM:AddWorldPropConversionRecipe("models/items/car_battery01.mdl", 			"comp_electrobattery")
GM:AddWorldPropConversionRecipe("models/props_lab/reciever01b.mdl", 		"comp_reciever")
GM:AddWorldPropConversionRecipe("models/props_lab/harddrive01.mdl", 		"comp_cpuparts")
