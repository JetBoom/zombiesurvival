INC_CLIENT()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.35, 0)

	self:SetRenderBounds(Vector(-26, -26, -26), Vector(26, 26, 45))
end

function ENT:Think()
	if MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN then
		local nextuse = MySelf.NextUse or 0
		if self.Dinged then
			if CurTime() < nextuse then
				self.Dinged = false
			end
		elseif CurTime() >= nextuse then
			self.Dinged = true

			self:EmitSound("zombiesurvival/ding.ogg")
		end
	end

	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end

	local wep = owner:GetActiveWeapon()
	if wep:IsValid() and wep:GetClass() == "weapon_zs_t_resupplypack" then return end

	local boneid = owner:LookupBone("ValveBiped.Bip01_Spine2")
	if not boneid or boneid <= 0 then return end

	local bonepos, boneang = owner:GetBonePositionMatrixed(boneid)

	self:SetPos(bonepos + boneang:Forward() + boneang:Right() * 6)
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
			draw.SimpleText(translate.Get("resupply_box"), "ZS3D2DFont2", 0, 0, (MySelf.NextUse or 0) <= CurTime() and COLOR_GREEN or COLOR_DARKRED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
