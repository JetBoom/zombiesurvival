include("shared.lua")
function ENT:Draw()
	render.ModelMaterialOverride(Material("models/flesh"))
	self:ManipulateBoneScale(0, Vector(3, 3,0.4 ))
	self:DrawModel()
	render.ModelMaterialOverride()
	self:ManipulateBoneScale(0, Vector(1,1,1))
end
