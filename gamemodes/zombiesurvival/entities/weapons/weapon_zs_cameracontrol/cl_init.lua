INC_CLIENT()

SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false

SWEP.BobScale = 0.15
SWEP.SwayScale = 0.15

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.VElements = {
	["base"] = { type = "Model", model = "models/props_c17/tv_monitor01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.791, 3.635, -1.558), angle = Angle(0, -118.053, 180), size = Vector(0.1, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["base"] = { type = "Model", model = "models/props_c17/tv_monitor01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 4.5, -1.558), angle = Angle(0, 180, 180), size = Vector(0.1, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_c17/tv_monitor01_screen.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.1, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "effects/tvscreen_noise003a", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 4, 3), angle = Angle(0, 0, 0) }
}

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	if self:GetOwner() == MySelf then
		hook.Add("RenderScene", self, self.RenderScene)
	end
end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

local w, h = 320, 256
local x, y = -w / 2, -h / 2
local CamPos = Vector(8, -4, -2)
local CamAng = Angle(180, -28, 90)
local CamScale = 0.025
local CamData = {x = 0, y = 0, w = h * 2, h = h * 2, drawhud = false, drawmonitors = false, drawviewmodel = false, aspectratio = w / h}
local rt = GetRenderTarget("prop_camera", w * 2, h * 2)
local matRT = Material("prop_camera")
local matStatic = Material("zombiesurvival/filmgrain/filmgrain")
local matNoSignal = Material("effects/tvscreen_noise003a")
function SWEP:PostDrawViewModel(vm)
	self.BaseClass.PostDrawViewModel(self, vm)

	if not vm or not vm:IsValid() then return end

	local boneid = vm:LookupBone("ValveBiped.Bip01_R_Hand")
	if not boneid or boneid == 0 then return end

	local bpos, bang = vm:GetBonePositionMatrixed(boneid)

	bpos, bang = LocalToWorld(CamPos, CamAng, bpos, bang)

	cam.Start3D2D(bpos, bang, CamScale)

	surface.SetDrawColor(255, 255, 255, 255)

	local camera = self:GetCamera()
	if camera:IsValid() then
		matRT:SetTexture("$basetexture", rt)
		surface.SetMaterial(matRT)
		surface.DrawTexturedRect(x, y, w, h)

		surface.SetDrawColor(30, 30, 30, 200)
		surface.SetMaterial(matStatic)
		surface.DrawTexturedRectUV(x, y, w, h, 2, 2, 0, 0)
	else
		surface.SetMaterial(matNoSignal)
		surface.DrawTexturedRect(x, y, w, h)
	end

	cam.End3D2D()
end

function SWEP:RenderScene(origin, angles, fov)
	if FROM_CAMERA then return end

	local camera = self:GetCamera()
	if not camera:IsValid() then return end

	FROM_CAMERA = camera

	CamData.origin = camera:GetPos() + camera:GetUp() * -16
	CamData.angles = angles

	local originalRT = render.GetRenderTarget()
	render.SetRenderTarget(rt)
	render.RenderView(CamData)
	render.SetRenderTarget(originalRT)

	FROM_CAMERA = nil
end

function SWEP:Draw3DHUD(vm, pos, ang)
end

function SWEP:Draw2DHUD()
end
