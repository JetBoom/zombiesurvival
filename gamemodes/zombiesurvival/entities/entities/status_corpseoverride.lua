AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))

	-- Intentionally not using status__base: no DieTime lifecycle, no
	-- owner registration, no SetPos-follow. This entity is a purely
	-- cosmetic overlay that rides on a ragdoll.
end

if CLIENT then
	function ENT:Draw()
		if not IsValid(self:GetParent()) then return end
		self:DrawModel()
	end
	ENT.DrawTranslucent = ENT.Draw
end