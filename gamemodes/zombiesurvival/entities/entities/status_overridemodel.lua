AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))

	local pPlayer = self:GetOwner()
	if pPlayer:IsValid() then
		pPlayer.status_overridemodel = self
		pPlayer:SetRenderMode(RENDERMODE_NONE)
	end
end

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer:SetRenderMode(RENDERMODE_NONE)
end

function ENT:OnRemove()
	local pPlayer = self:GetOwner()
	if pPlayer:IsValid() then
		pPlayer:SetRenderMode(RENDERMODE_NORMAL)
	end
end

function ENT:Think()
end

if CLIENT then
	function ENT:Draw()
		local owner = self:GetOwner()
		if owner:IsValid() and owner:Alive() then
			local col = owner:GetColor()
			col.a = 255
			self:SetColor(col)
			self:DrawModel()
		end
	end
end
