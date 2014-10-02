include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.5, 0)
end

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == LocalPlayer() and not owner:ShouldDrawLocalPlayer() then return end

	local wep = owner:GetActiveWeapon()
	if wep:IsValid() and wep:GetClass() == "weapon_zs_oxygentank" then return end

	local boneid = owner:LookupBone("ValveBiped.Bip01_Spine2")
	if not boneid or boneid <= 0 then return end

	local bonepos, boneang = owner:GetBonePositionMatrixed(boneid)

	self:SetPos(bonepos + boneang:Forward() + boneang:Right() * 4)
	boneang:RotateAroundAxis(boneang:Right(), 270)
	boneang:RotateAroundAxis(boneang:Up(), 180)
	self:SetAngles(boneang)

	self:DrawModel()
end
