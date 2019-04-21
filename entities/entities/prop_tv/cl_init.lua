INC_CLIENT()

function ENT:SetObjectHealth(health)
	self:SetDTFloat(3, health)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(1, ent)
end

local w, h = 320, 256
local x, y = -w / 2, -h / 2
local rt = GetRenderTarget("prop_camera", w * 2, h * 2)
local matRT = Material("prop_camera")
local matStatic = Material("zombiesurvival/filmgrain/filmgrain")
local CamPos = Vector(6, -2, 0)
local LightPos = Vector(7.4, 8, 3)
local LightPos2 = Vector(7.4, 8, 1)
local CamAng = Angle(0, 90, 90)
local CamScale = 0.05
MyCamera = NULL

local matGlow = Material("sprites/glow04_noz")
function ENT:Draw()
	self:DrawModel()

	local dist = EyePos():DistToSqr(self:GetPos())
	if dist < 9000 then
		local bpos, bang = self:LocalToWorld(CamPos), self:LocalToWorldAngles(CamAng)

		cam.Start3D2D(bpos, bang, CamScale)

		surface.SetDrawColor(255, 255, 255, 255)

		local camera = MyCamera
		if camera:IsValid() then
			matRT:SetTexture("$basetexture", rt)
			surface.SetMaterial(matRT)
			surface.DrawTexturedRect(x, y, w, h)

			surface.SetDrawColor(30, 30, 30, 200)
			surface.SetMaterial(matStatic)
			surface.DrawTexturedRectUV(x, y, w, h, 2, 2, 0, 0)
		else
			surface.SetDrawColor(50, 60, 80, 255)
			surface.SetMaterial(matStatic)
			surface.DrawTexturedRect(x, y, w, h)
		end

		cam.End3D2D()
	end

	render.SetMaterial(matGlow)
	render.DrawSprite(self:LocalToWorld(LightPos), 3, 3, COLOR_DARKBLUE)
	render.DrawSprite(self:LocalToWorld(LightPos2), 2, 2, COLOR_HURT)
end

local CamData = {x = 0, y = 0, w = h * 2, h = h * 2, drawhud = false, drawmonitors = false, drawviewmodel = false, aspectratio = w / h}
function RenderScene(origin, angles, fov)
	if FROM_CAMERA then return end

	local camera = MyCamera
	if not camera:IsValid() then return end

	FROM_CAMERA = camera

	local camangs = camera:GetAngles()
	camangs:RotateAroundAxis(camera:GetRight(), 90)
	camangs:RotateAroundAxis(camera:GetUp(), 180)
	camangs:RotateAroundAxis(camera:GetForward(), 180)

	CamData.origin = camera:GetPos() + camera:GetUp() * -16
	CamData.angles = camangs

	local originalRT = render.GetRenderTarget()
	render.SetRenderTarget(rt)
	render.RenderView(CamData)
	render.SetRenderTarget(originalRT)

	FROM_CAMERA = nil
end

net.Receive("zs_tvcamera", function(length)
	MyCamera = net.ReadEntity()

	hook.Add("RenderScene", "TVCamera", RenderScene)
end)
