INC_CLIENT()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.4, 0)

	self:SetRenderBounds(Vector(-26, -26, -26), Vector(26, 26, 45))
end

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end

	local boneid = owner:LookupBone("ValveBiped.Bip01_Spine2")
	if not boneid or boneid <= 0 then return end

	local bonepos, boneang = owner:GetBonePositionMatrixed(boneid)

	self:SetPos(bonepos + boneang:Forward() + boneang:Right() * 4)
	boneang:RotateAroundAxis(boneang:Right(), 270)
	boneang:RotateAroundAxis(boneang:Forward(), 90)
	self:SetAngles(boneang)

	local shadowman = owner.ShadowMan
	local hidepacks = not GAMEMODE.HidePacks

	if hidepacks and shadowman then
		render.SetBlend(0)
	end

	self:DrawModel()

	if hidepacks and shadowman then
		render.SetBlend(1)
	end

	if not hidepacks or not shadowman then
		local w, h = 420, 200
		cam.Start3D2D(self:LocalToWorld(Vector(0, 0, self:OBBMaxs().z)), self:GetAngles(), 0.025)
			draw.RoundedBox(64, w * -0.5, h * -0.5, w, h, color_black_alpha120)
			draw.SimpleText(translate.Get("arsenal_crate"), "ZS3D2DFont2", 0, 0, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
