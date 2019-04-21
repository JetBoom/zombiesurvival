function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local normal = data:GetNormal()

	util.Decal("Scorch", pos + normal, pos - normal)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
