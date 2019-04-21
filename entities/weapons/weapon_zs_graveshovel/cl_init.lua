INC_CLIENT()

SWEP.ViewModelFOV = 80

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.VElements = {
	["eye+"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_Spine4", rel = "spine", pos = Vector(-3.097, 1.175, 32.965), size = { x = 2.072, y = 2.072 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["skull"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "spine", pos = Vector(-0.245, 1.638, 32.466), angle = Angle(0, -159.118, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["eye"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_Spine4", rel = "spine", pos = Vector(-3.097, 1.175, 32.965), size = { x = 2.072, y = 2.072 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["spade2"] = { type = "Model", model = "models/Gibs/HGIBS_scapula.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "spine", pos = Vector(-1.019, -0.357, -22.178), angle = Angle(24.246, -107.839, 6.21), size = Vector(2.15, 2.15, 2.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["eye+++"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_Spine4", rel = "spine", pos = Vector(-2.108, 3.815, 32.942), size = { x = 2.072, y = 2.072 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["spade"] = { type = "Model", model = "models/Gibs/HGIBS_scapula.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "spine", pos = Vector(-1.538, 0.66, -21.781), angle = Angle(0, 59.147, 30.173), size = Vector(2.15, 2.15, 2.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["eye++"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_Spine4", rel = "spine", pos = Vector(-2.108, 3.815, 32.942), size = { x = 2.072, y = 2.072 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["spine"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.125, 1.445, -21.761), angle = Angle(6.393, -2.498, -3.169), size = Vector(0.899, 0.665, 3.928), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["eye+"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "spine", pos = Vector(-3.097, 1.175, 33.444), size = { x = 2.072, y = 2.072 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["eye"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "spine", pos = Vector(-3.097, 1.175, 33.444), size = { x = 2.072, y = 2.072 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["skull"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "spine", pos = Vector(-0.245, 1.603, 32.875), angle = Angle(0, -159.118, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["spade+"] = { type = "Model", model = "models/Gibs/HGIBS_scapula.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "spine", pos = Vector(-1.019, -0.357, -25.78), angle = Angle(24.246, -107.839, 6.21), size = Vector(2.15, 2.15, 2.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["eye+++"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "spine", pos = Vector(-2.108, 3.815, 33.444), size = { x = 2.072, y = 2.072 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["spade"] = { type = "Model", model = "models/Gibs/HGIBS_scapula.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "spine", pos = Vector(-1.538, 0.66, -26.781), angle = Angle(0, 59.147, 30.173), size = Vector(2.15, 2.15, 2.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["spine"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.831, 2.115, -21.778), angle = Angle(-2.964, 174.585, -0.41), size = Vector(0.899, 0.665, 4.128), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["eye++"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "spine", pos = Vector(-2.108, 3.815, 33.444), size = { x = 2.072, y = 2.072 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
}

-- Yes it is from the frotchet
function SWEP:PreDrawViewModel(vm)
	self.BaseClass.PreDrawViewModel(self, vm)

	local charge = math.min(self:GetShovelCharge()/66, 1)
	for mdl, tab in pairs(self.VElements) do
		if tab.type == "Model" then
			tab.color = Color(255, 255 - (168 * charge), 255 - (192 * charge), 255)
		end
	end
end

function SWEP:DrawWorldModel()
	self.BaseClass.DrawWorldModel(self)

	local charge = math.min(self:GetShovelCharge()/66, 1)
	for mdl, tab in pairs(self.WElements) do
		if tab.type == "Model" then
			tab.color = Color(255, 255 - (168 * charge), 255 - (192 * charge), 255)
		end
	end

	local owner = self:GetOwner()
	if math.random(66) <= charge*66 and math.random(6) == 1 and owner:IsValid() and not owner.ShadowMan then
		local boneindex = owner:LookupBone("valvebiped.bip01_r_hand")
		if boneindex then
			local pos, ang = owner:GetBonePosition(boneindex)
			if pos then
				pos = pos + ang:Up() * -36

				local curvel = owner:GetVelocity() * 0.5
				local emitter = ParticleEmitter(pos)
				emitter:SetNearClip(24, 48)
				local dir = curvel + VectorRand():GetNormalized() * (70 + charge*66)

				for i=1, math.min(16, math.ceil(FrameTime() * 200)) do
					local particle = emitter:Add("sprites/light_glow02_add", pos)
					particle:SetVelocity(dir)
					particle:SetGravity(dir * -3)
					particle:SetDieTime(0.5)
					particle:SetStartAlpha(125)
					particle:SetEndAlpha(0)
					particle:SetStartSize(3)
					particle:SetEndSize(0)
					particle:SetColor(255, 30, 30)
					particle:SetAirResistance(90)
				end
				emitter:Finish() emitter = nil collectgarbage("step", 64)
			end
		end
	end
end
