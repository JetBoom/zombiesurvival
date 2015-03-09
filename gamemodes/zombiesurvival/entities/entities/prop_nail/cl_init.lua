include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:OnRemove()
	local normal = self:GetForward() * -1
	local pos = self:GetPos() + normal

	sound.Play("physics/metal/metal_box_impact_bullet"..math.random(1, 3)..".wav", pos, 75, math.random(90, 110))

	local grav = Vector(0, 0, -300)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(22, 32)
	for i=1, math.random(32, 48) do
		local vNormal = (VectorRand() * 0.6 + normal):GetNormalized()
		local particle = emitter:Add("effects/spark", pos + vNormal)
		particle:SetVelocity(vNormal * math.Rand(16, 100))
		particle:SetDieTime(math.Rand(0.5, 1))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.Rand(0.4, 1.5))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-8, 8))
		particle:SetCollide(true)
		particle:SetBounce(0.8)
		particle:SetGravity(grav)
	end
	emitter:Finish()
end

local matOutlineWhite = Material("white_outline")
local ScaleOutline = 1.4
local colNail = Color(0, 0, 5, 220)
function ENT:DrawTranslucent()
	local drawowner = MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN and (GAMEMODE.AlwaysShowNails or MySelf:KeyDown(IN_SPEED) or MySelf:TraceLine(256, MASK_SHOT).HitPos:Distance(self:GetPos()) <= 16)

	if drawowner then
		render.SuppressEngineLighting(true)
		render.SetAmbientLight(1, 1, 1)

		local health = self:GetNailHealth() / self:GetMaxNailHealth()
		render.SetColorModulation(1 - health, health, 0)

		local scale = self:GetModelScale()
		self:SetModelScale(ScaleOutline * scale, 0)
		render.ModelMaterialOverride(matOutlineWhite)

		self:DrawModel()

		render.ModelMaterialOverride()
		self:SetModelScale(scale, 0)

		render.SuppressEngineLighting(false)
		render.SetColorModulation(1, 1, 1)
	end

	self:DrawModel()

	if drawowner then
		local displayowner = self:GetDTString(0)
		local redname = false
		if displayowner == "" then
			displayowner = nil

			local deployer = self:GetOwner()
			if deployer:IsValid() then
				displayowner = deployer:Name()
				if deployer:Team() ~= TEAM_HUMAN or not deployer:Alive() then
					displayowner = "(DEAD) "..displayowner
					redname = true
				end
			end
		end

		local ang = EyeAngles()
		ang:RotateAroundAxis(ang:Up(), -90)
		ang:RotateAroundAxis(ang:Forward(), 90)

		cam.Start3D2D(self:GetPos(), ang, 0.05)
			local wid, hei = 180, 5
			local x, y = wid * -0.5 + 2, 0

			if self:GetMaxRepairs() > 0 then
				local repairs = self:GetRepairs()
				local ru = 1 - math.Clamp(repairs / self:GetMaxRepairs(), 0, 1)
				surface.SetDrawColor(0, 0, 0, 220)
				surface.DrawRect(x, y, wid, hei)
				surface.SetDrawColor(40, 40, 40, 220)
				surface.DrawOutlinedRect(x, y, wid, hei)
				surface.SetDrawColor(230, 5, 5, ru == 1 and (150 + math.abs(math.sin(RealTime() * 5)) * 105) or 220)
				surface.DrawRect(x + 1, y + 1, (wid - 2) * ru, hei - 2)

				draw.SimpleText(math.ceil(repairs), "ZS3D2DFont2Smaller", x + wid, y - 1, repairs <= 0 and COLOR_DARKRED or COLOR_GRAY, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end

			if self:GetMaxNailHealth() > 0 then
				local mu = math.Clamp(self:GetNailHealth() / self:GetMaxNailHealth(), 0, 1)
				local green = mu * 200
				colNail.r = 200 - green
				colNail.g = green

				y = y + hei + 3
				hei = 8
				x = wid * -0.5 + 2
				surface.SetDrawColor(0, 0, 0, 220)
				surface.DrawRect(x, y, wid, hei)
				surface.SetDrawColor(40, 40, 40, 220)
				surface.DrawOutlinedRect(x, y, wid, hei)
				surface.SetDrawColor(colNail)
				surface.DrawRect(x + 1, y + 1, (wid - 2) * mu, hei - 2)

				draw.SimpleText(math.ceil(self:GetNailHealth()).." / "..math.ceil(self:GetMaxNailHealth()), "ZS3D2DFont2Smaller", x + wid / 2, y + hei + 1, colNail, TEXT_ALIGN_CENTER)
			end

			if displayowner then
				draw.SimpleText(displayowner, "ZS3D2DFont2Smaller", 0, y + 38, redname and COLOR_DARKRED or COLOR_DARKGRAY, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
end
