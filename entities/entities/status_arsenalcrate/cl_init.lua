include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.5, 0)
	
	hook.Add("PostDrawTranslucentRenderables", "DrawStatusArsenalHints", function( bDepth, bSkybox )
		if ( bSkybox ) then return end
		for _, ent in pairs(ents.FindByClass("status_arsenalcrate")) do
			ent:DrawWorldHint()
		end
	end)
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
	
	if !MySelf:RadiusCheck(owner, GAMEMODE.TransparencyRadius) then 
		self:DrawModel()
	end
end

function ENT:DrawWorldHint()
	if MySelf:IsValid() and MySelf:Alive() and MySelf:Team() ~= TEAM_UNDEAD and MySelf:GetInfo("zs_nostatusarscrate") == "0" then
		DrawIconHint(translate.Get("arsenal_crate"), "zombiesurvival/arsenalcrate.png", self:GetPos() + Vector(0, 0, self:OBBMaxs().z / 2), nil, 0.75, Color(255, 255, 255, 225))
	end
end