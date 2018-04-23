include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.5, 0)
end

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == LocalPlayer() and not owner:ShouldDrawLocalPlayer() then return end

	local wep = owner:GetActiveWeapon()
	if wep:IsValid() and wep:GetClass() == "weapon_zs_arsenalcrate" then return end

	local boneid = owner:LookupBone("ValveBiped.Bip01_Spine2")
	if not boneid or boneid <= 0 then return end

	local bonepos, boneang = owner:GetBonePositionMatrixed(boneid)

	self:SetPos(bonepos + boneang:Forward() + boneang:Right() * 5)
	boneang:RotateAroundAxis(boneang:Forward(), 90)
	boneang:RotateAroundAxis(boneang:Up(), 180)
	
	self:SetAngles(boneang)
	
	if owner == LocalPlayer() then return end
	
	if owner ~= MySelf then
		// you should prolly make an optional convar to player held item blending.
		local radius = 10 ^ 2
		if radius > 0 then
			local eyepos = EyePos()
			local dist = owner:NearestPoint(eyepos):DistToSqr(eyepos)
			if dist < radius then
				--Don't Draw it!
			else
				self:DrawModel()
			end
		end
	end
end
